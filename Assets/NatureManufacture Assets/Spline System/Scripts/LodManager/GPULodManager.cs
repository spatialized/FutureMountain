using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.InteropServices;
using Unity.Collections;
using Unity.Mathematics;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Rendering;
using Debug = UnityEngine.Debug;

namespace NatureManufacture.RAM
{
    [ExecuteInEditMode]
    public class GPULodManager : MonoBehaviour
    {
        [SerializeField] private MeshFilter sourceMeshFilter;

        [SerializeField] private float refreshTime = 0.1f;
        [SerializeField] private Vector4 lodDistance = new(100, 80, 50, 20);
        [SerializeField] private Transform cameraLod;

        [SerializeField] private ComputeShader computeShader;


        private Mesh _targetMesh;


        //Position, Normal, Tangent, Color, TexCoord0, TexCoord3
        [StructLayout(LayoutKind.Sequential)]
        private struct SourceVertex
        {
            public Vector3 position;
            public Vector3 normal;
            public Vector4 tangent;
            public Color color;
            public Vector4 uv;
            public Vector4 uv3;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct DrawVertex
        {
            private readonly float3 position;
            private readonly float3 normal;
            private readonly float4 tangent;
            private readonly Color color;
            private readonly float4 uv;
            private readonly float4 uv3;
        };


        private bool _initialized;
        private ComputeBuffer _sourceVertBuffer;
        private ComputeBuffer _sourceTriBuffer;
        private ComputeBuffer _drawBuffer;
        private ComputeBuffer _countBuffer;
        private int _idPyramidKernel;
        private int _idTriToVertKernel;
        private int _dispatchSize;
        private Bounds _localBounds;
        private int _numTriangles;
        private int _verticesCount;
        private NativeArray<VertexAttributeDescriptor> _vertexLayout;
        private NativeArray<int> _indexArray;

        private Vector3 _cameraPosition;
        private float _executeTime;

        private static readonly int SourceVertices = Shader.PropertyToID("_SourceVertices");
        private static readonly int SourceTriangles = Shader.PropertyToID("_SourceTriangles");
        private static readonly int DrawTriangles = Shader.PropertyToID("_DrawTriangles");
        private static readonly int NumSourceTriangles = Shader.PropertyToID("_NumSourceTriangles");
        private static readonly int LocalToWorld = Shader.PropertyToID("_LocalToWorld");
        private static readonly int Distance = Shader.PropertyToID("_LODDistance");
        private static readonly int CameraPosition = Shader.PropertyToID("_CameraPosition");
        private int _numVertices;
        private SourceVertex[] _vertices;
        private int[] _tris;

        private const int SourceVertStride = sizeof(float) * (3 + 3 + 4 + 4 + 4 + 4);
        private const int SourceTriStride = sizeof(int);
        private const int DrawStride = sizeof(float) * (3 + 3 + 4 + 4 + 4 + 4);
        private const int CountStride = sizeof(int) * 1;
        private const float MinRefreshTime = 0.01f;
        private const MeshUpdateFlags DontNotifyMeshUsers = MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices | MeshUpdateFlags.DontRecalculateBounds;

        public MeshFilter SourceMeshFilter
        {
            get => sourceMeshFilter;
            set => sourceMeshFilter = value;
        }

        public Vector4 LODDistance
        {
            get => lodDistance;
            set => lodDistance = value;
        }

        public float RefreshTime
        {
            get => refreshTime;
            set => refreshTime = value;
        }

        // Start is called before the first frame update
        private void OnEnable()
        {
            SetupLod();
        }

        private void SetupLod()
        {
            if (!cameraLod && Camera.main != null)
                cameraLod = Camera.main.transform;


            if (_initialized)
            {
                OnDisable();
            }

            _initialized = true;

            _targetMesh = new Mesh();
            GetComponent<MeshFilter>().sharedMesh = _targetMesh;

            // specify vertex count and layout
            GenerateVertexLayout();

            Mesh sourceMesh = SourceMeshFilter.sharedMesh;
            SourceMeshFilter.GetComponent<MeshRenderer>().enabled = false;
            sourceMesh.RecalculateTangents();

            Vector3[] positions = sourceMesh.vertices;
            Vector3[] normals = sourceMesh.normals;
            Color[] colors = sourceMesh.colors;

            Vector4[] tangents = sourceMesh.tangents;

            List<Vector4> uvs = new();
            List<Vector4> uvs3 = new();
            sourceMesh.GetUVs(0, uvs);
            sourceMesh.GetUVs(3, uvs3);
            _tris = sourceMesh.triangles;

            _vertices = new SourceVertex[positions.Length];
            for (int i = 0; i < _vertices.Length; i++)
            {
                _vertices[i] = new SourceVertex
                {
                    position = positions[i],
                    normal = normals.Length > 0 ? normals[i] : Vector3.up,
                    tangent = tangents[i],
                    color = colors.Length > 0 ? colors[i] : Color.black,
                    uv = uvs[i],
                    uv3 = uvs3.Count > 0 ? uvs3[i] : uvs[i],
                };
            }

            _numTriangles = _tris.Length / 3;
            _numVertices = _tris.Length * 4 * 4 * 4 * 4;

            GenerateIndexArray();

            _localBounds = sourceMesh.bounds;

            SetupBuffers();

            UpdateLod();
        }

        private void GenerateIndexArray()
        {
            _indexArray = new NativeArray<int>(_numVertices, Allocator.Persistent);
            for (int i = 0; i < _numVertices; i++)
                _indexArray[i] = i;
        }

        private void GenerateVertexLayout()
        {
            _vertexLayout = new NativeArray<VertexAttributeDescriptor>(
                6, Allocator.Persistent, NativeArrayOptions.UninitializedMemory
            );

            _vertexLayout[0] = new VertexAttributeDescriptor(VertexAttribute.Position, VertexAttributeFormat.Float32, 3);
            _vertexLayout[1] = new VertexAttributeDescriptor(VertexAttribute.Normal, VertexAttributeFormat.Float32, 3);
            _vertexLayout[2] = new VertexAttributeDescriptor(VertexAttribute.Tangent, VertexAttributeFormat.Float32, 4);
            _vertexLayout[3] = new VertexAttributeDescriptor(VertexAttribute.Color, VertexAttributeFormat.Float32, 4);
            _vertexLayout[4] = new VertexAttributeDescriptor(VertexAttribute.TexCoord0, VertexAttributeFormat.Float32, 4);
            _vertexLayout[5] = new VertexAttributeDescriptor(VertexAttribute.TexCoord3, VertexAttributeFormat.Float32, 4);
        }


        private void SetupBuffers()
        {
            //check if buffers are not null if not null release them
            _sourceVertBuffer?.Release();
            _sourceTriBuffer?.Release();
            _drawBuffer?.Release();
            _countBuffer?.Release();


            _sourceVertBuffer = new ComputeBuffer(_vertices.Length, SourceVertStride, ComputeBufferType.Structured, ComputeBufferMode.Immutable);
            _sourceVertBuffer.SetData(_vertices);
            _sourceTriBuffer = new ComputeBuffer(_tris.Length, SourceTriStride, ComputeBufferType.Structured, ComputeBufferMode.Immutable);
            _sourceTriBuffer.SetData(_tris);

            _drawBuffer = new ComputeBuffer(_numVertices, DrawStride, ComputeBufferType.Append);
            _drawBuffer.SetCounterValue(0);
            _countBuffer = new ComputeBuffer(1, CountStride, ComputeBufferType.IndirectArguments);

            computeShader = Instantiate(computeShader);
            _idPyramidKernel = computeShader.FindKernel("Main");

            computeShader.SetBuffer(_idPyramidKernel, SourceVertices, _sourceVertBuffer);
            computeShader.SetBuffer(_idPyramidKernel, SourceTriangles, _sourceTriBuffer);
            computeShader.SetBuffer(_idPyramidKernel, DrawTriangles, _drawBuffer);
            computeShader.SetInt(NumSourceTriangles, _numTriangles);

            computeShader.GetKernelThreadGroupSizes(_idPyramidKernel, out uint threadGroupSize, out _, out _);

            _dispatchSize = Mathf.CeilToInt((float)_numTriangles / threadGroupSize);
        }


        private void UpdateLod()
        {
            //Debug.Log("UpdateLod");

            if (cameraLod == null)
                return;

#if UNITY_EDITOR
            if (SceneView.lastActiveSceneView != null && SceneView.lastActiveSceneView.camera != null)
            {
                _cameraPosition = Application.isPlaying ? cameraLod.position : SceneView.lastActiveSceneView.camera.transform.position;
            }
            else
            {
                _cameraPosition = cameraLod.position;
            }
#else
            _cameraPosition = cameraLod.position;
#endif


            if (_drawBuffer == null || _countBuffer == null || !_drawBuffer.IsValid() || !_countBuffer.IsValid())
            {
                DisposeBuffers();
                return;
            }


            _drawBuffer.SetCounterValue(0);
            computeShader.SetMatrix(LocalToWorld, transform.localToWorldMatrix);
            computeShader.SetVector(Distance, LODDistance);
            computeShader.SetVector(CameraPosition, transform.InverseTransformPoint(_cameraPosition));

            computeShader.Dispatch(_idPyramidKernel, _dispatchSize, 1, 1);
            ComputeBuffer.CopyCount(_drawBuffer, _countBuffer, 0);

            //_coroutineMesh = StartCoroutine(UpdateMesh());

            AsyncGPUReadback.Request(_countBuffer, CountBufferRead);
        }

        private void CountBufferRead(AsyncGPUReadbackRequest countBufferRequest)
        {
            //Debug.Log("CountBufferRead");
            if (countBufferRequest.hasError || _drawBuffer == null || !_drawBuffer.IsValid())
            {
                DisposeBuffers();
                return;
            }

            _verticesCount = countBufferRequest.GetData<int>()[0] * 3;
            AsyncGPUReadback.Request(_drawBuffer, DrawBufferRead);
        }

        private void DrawBufferRead(AsyncGPUReadbackRequest drawBufferRequest)
        {
            //Debug.Log("DrawBufferRead");
            if (drawBufferRequest.hasError)
            {
                DisposeBuffers();
                return;
            }

            var data = drawBufferRequest.GetData<DrawVertex>();

            //Debug.Log(_verticesCount+" "+_drawBuffer.count);

            GenerateMeshNative(data, _verticesCount);


            switch (Application.isPlaying)
            {
                case true:
                    StartCoroutine(WaitForCalculateLods());
                    break;
                case false:
#if UNITY_EDITOR
                    EditorApplication.delayCall += WaitForCalculateLodsEditor;
#endif
                    break;
            }
        }
#if UNITY_EDITOR
        private void WaitForCalculateLodsEditor()
        {
            if (RefreshTime < MinRefreshTime)
                RefreshTime = 0.1f;

            _executeTime = (float)EditorApplication.timeSinceStartup + RefreshTime;
            EditorApplication.update += CheckIfUpdateEditor;
        }

        private void CheckIfUpdateEditor()
        {
            if (!(EditorApplication.timeSinceStartup >= _executeTime)) return;
            EditorApplication.update -= CheckIfUpdateEditor;
            UpdateLod();
        }
#endif

        private IEnumerator WaitForCalculateLods()
        {
            yield return new WaitForSeconds(RefreshTime);
            UpdateLod();
        }


        private void GenerateMeshNative(NativeArray<DrawVertex> data, int verticesCount)
        {
            if (!_vertexLayout.IsCreated)
                return;

            //Debug.Log($"GenerateMeshNative {verticesCount}");
            var vertexCount = verticesCount;
            _targetMesh.SetIndexBufferParams(vertexCount, IndexFormat.UInt32);


            _targetMesh.SetVertexBufferParams(vertexCount, _vertexLayout);

            _targetMesh.SetVertexBufferData(data, 0, 0, vertexCount);

            //Debug.Log(ib.Length);

            _targetMesh.SetIndexBufferData(_indexArray, 0, 0, vertexCount);

            //Bounds bounds = TransformBounds(localBounds);
            _targetMesh.subMeshCount = 1;


            _targetMesh.SetSubMesh(0, new SubMeshDescriptor(0, vertexCount)
            {
                bounds = _localBounds,
                vertexCount = vertexCount
            }, DontNotifyMeshUsers);


            _targetMesh.bounds = _localBounds;
            //targetMesh.RecalculateBounds();
            //Debug.Log(localBounds.min);
            //Debug.Log(targetMesh.bounds.min);
        }


        private void OnDisable()
        {
            DisposeBuffers();
        }

        private void DisposeBuffers()
        {
            if (_initialized)
            {
                //StopCoroutine(_coroutineMesh);
                _sourceVertBuffer?.Release();
                _sourceTriBuffer?.Release();
                _drawBuffer?.Release();
                _countBuffer?.Release();
                if (_vertexLayout.IsCreated)
                    _vertexLayout.Dispose();
                if (_indexArray.IsCreated)
                    _indexArray.Dispose();
            }

            _initialized = false;
        }
    }
}