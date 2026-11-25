using UnityEngine;
using System.Collections;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

using UnityEngine.Profiling;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    [ExecuteInEditMode]
    public class LodManager : MonoBehaviour, ISerializationCallbackReceiver
    {
        public struct SVector2Int
        {
            public int X;
            public int Y;
        }


        [SerializeField] private MeshFilter sourceMeshFilter;

        [SerializeField] private float refreshTime = 0.1f;
        [SerializeField] private Vector4 lodDistance = new(100, 80, 50, 20);
        [SerializeField] private Transform cameraLod;
        [SerializeField] private float trianglesRefreshRate = 200f;
        [SerializeField] private float cameraMovementDistanceCheck = 0.1f;

        [SerializeField] private int levelStart = 4;
        private int currentTriangleIndex = 0;
        private float _lastRefresh = -100;

        private readonly Queue<(int, int, int, int)> subdivideData = new();
        private SubdividePhase _currentPhase = SubdividePhase.Loading;

        private Vector3 _camPosition;


        private enum SubdividePhase
        {
            Loading,
            PreSubdivide,
            InitArrays,
            DoSubdivide,
            FinishMesh,
        }


        private MeshRenderer _sourceMeshRenderer;
        private Matrix4x4 _localToWorldMatrix;
        private Bounds _objectBounds;
        private Vector3 _lastCameraPosition;

        private Mesh _targetMesh;
        private Mesh _baseMesh;


        private readonly List<Vector3> _vertices = new();
        private readonly List<Vector3> _normals = new();
        private readonly List<Vector4> _tangents = new();
        private readonly List<Color> _colors = new();
        private readonly List<Vector4> _uv = new();
        private readonly List<Vector4> _uv3 = new();
        private readonly List<int> _indices = new();
        private Bounds _meshBounds;
        private int[] _indicesBase;

        private int _verticesCount;
        private int _indicesCount;


        private readonly Dictionary<SVector2Int, int> _newVertices = new(new NmsVector2IntEqualityComparer());
        private SVector2Int _test;


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

        public Transform CameraLod
        {
            get
            {
                if (cameraLod == null && Camera.main != null)
                    cameraLod = Camera.main.transform;

                return cameraLod;
            }
            set => cameraLod = value;
        }

        private void OnEnable()
        {
            //Debug.Log($"enabled {EditorApplication.isPlaying} {_currentPhase} ");
            _currentPhase = SubdividePhase.Loading;
#if UNITY_EDITOR

            EditorApplication.update += EditorUpdate;
#endif
        }

        private void OnDisable()
        {
            //Debug.Log($"disabled {EditorApplication.isPlaying} {_currentPhase} ");
            StopAllCoroutines();
            _currentPhase = SubdividePhase.Loading;
#if UNITY_EDITOR

            EditorApplication.update -= EditorUpdate;
#endif
        }

        public void OnBeforeSerialize()
        {
            StopAllCoroutines();
        }

        public void OnAfterDeserialize()
        {
            _currentPhase = SubdividePhase.Loading;
        }


        private void PrepareMesh()
        {
            //Debug.Log("PrepareMesh");

            if (!SourceMeshFilter)
                return;

            if (!CameraLod && Camera.main != null)
                CameraLod = Camera.main.transform;

            _baseMesh = SourceMeshFilter.sharedMesh;
            _baseMesh.RecalculateTangents();
            _meshBounds = _baseMesh.bounds;

            _sourceMeshRenderer = SourceMeshFilter.GetComponent<MeshRenderer>();
            //_sourceMeshRenderer.enabled = false;

            _objectBounds = _sourceMeshRenderer.bounds;

            ClearData();

            _targetMesh = DuplicateMesh(_baseMesh);
            _targetMesh.indexFormat = IndexFormat.UInt32;
            _targetMesh.MarkDynamic();
            GetComponent<MeshFilter>().sharedMesh = _targetMesh;


            _currentPhase = SubdividePhase.PreSubdivide;
            _lastRefresh = Time.realtimeSinceStartup;
            _lastCameraPosition = Vector3.zero;

            //Debug.Log($"After PrepareMesh {EditorApplication.isPlaying} {_currentPhase} ");
        }

        private void ClearData()
        {
            _vertices.Clear();
            _normals.Clear();
            _tangents.Clear();
            _colors.Clear();
            _uv.Clear();
            _uv3.Clear();
            _indices.Clear();
            _newVertices.Clear();
        }

#if UNITY_EDITOR
        private void EditorUpdate()
        {
            //Debug.Log($"EditorUpdate {EditorApplication.isPlaying} {_reload}");
            if (EditorApplication.isPlaying) return;


            ManageSubdivide();
        }
#endif


        private void Update()
        {
            //Debug.Log($"Update {EditorApplication.isCompiling}");
#if UNITY_EDITOR

            if (!EditorApplication.isPlaying)
            {
                return;
            }
#endif


            ManageSubdivide();
        }

        private void ManageSubdivide(bool checkDistance = true)
        {
            //Debug.Log($"ManageSubdivide  currentPhase {_currentPhase} {currentTriangleIndex} / {_indicesBase.Length} ");

            switch (_currentPhase)
            {
                case SubdividePhase.Loading:
                    PrepareMesh();
                    break;
                case SubdividePhase.PreSubdivide:
                    WaitForSubdivide(checkDistance);
                    break;
                case SubdividePhase.InitArrays:
                    InitArrays();
                    break;
                case SubdividePhase.DoSubdivide:
                    DoSubdivide();
                    break;
                case SubdividePhase.FinishMesh:
                    FinishMesh();
                    break;


                default:
                    break;
            }
        }

        private void WaitForSubdivide(bool checkDistance)
        {
            //Debug.Log($"WaitForSubdivide {checkDistance} {_lastRefresh + RefreshTime} < {Time.realtimeSinceStartup} ");
            if (!(_lastRefresh + RefreshTime < Time.realtimeSinceStartup)) return;

            _lastRefresh = Time.realtimeSinceStartup;
            SetPosition();

            if (checkDistance && !(Mathf.Sqrt(_objectBounds.SqrDistance(_camPosition)) < lodDistance[0])) return;
            float cameraMoveDistance = Vector3.Distance(_camPosition, _lastCameraPosition);

            float lastNonZeroLODDistance = lodDistance[0];
            for (int i = 1; i < 4; i++)
            {
                if (lodDistance[i] == 0) continue;

                lastNonZeroLODDistance = lodDistance[i];

                break;
            }

            if (checkDistance && cameraMoveDistance < lastNonZeroLODDistance * cameraMovementDistanceCheck) return;


            _lastCameraPosition = _camPosition;

            _currentPhase = SubdividePhase.InitArrays;
        }

        private void SetPosition()
        {
            if (!Application.isPlaying)
            {
#if UNITY_EDITOR
                if (!SceneView.lastActiveSceneView) return;

                if (!SceneView.lastActiveSceneView.camera) return;

                _camPosition = SceneView.lastActiveSceneView.camera.transform.position;
#endif
            }
            else
            {
                _camPosition = CameraLod != null ? CameraLod.position : transform.position;
            }
        }


        private void InitArrays()
        {
            if (_baseMesh)
                _baseMesh = SourceMeshFilter.sharedMesh;

            if (!_baseMesh)
            {
                Debug.Log(_baseMesh.vertices.Length);
                Debug.LogError("No base mesh filter with mesh");
                return;
            }


            _verticesCount = _vertices.Count;
            _indicesCount = 0;
            currentTriangleIndex = 0;

            _localToWorldMatrix = transform.localToWorldMatrix;

            _currentPhase = SubdividePhase.DoSubdivide;
        }

        private void FinishMesh()
        {
            Profiler.BeginSample("Clear Mesh");
            //_targetMesh.Clear();
            Profiler.EndSample();

            Profiler.BeginSample("Set Vertices");
            _targetMesh.SetVertices(_vertices, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            if (_normals.Count > 0)
                _targetMesh.SetNormals(_normals, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            if (_tangents.Count > 0)
                _targetMesh.SetTangents(_tangents, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            if (_colors.Count > 0)
                _targetMesh.SetColors(_colors, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            if (_uv.Count > 0)
                _targetMesh.SetUVs(0, _uv, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            if (_uv3.Count > 0)
                _targetMesh.SetUVs(3, _uv3, 0, _verticesCount, MeshUpdateFlags.DontNotifyMeshUsers | MeshUpdateFlags.DontValidateIndices);
            Profiler.EndSample();

            Profiler.BeginSample("Set Triangles");
            _targetMesh.SetTriangles(_indices, 0, _indicesCount, 0, false);
            Profiler.EndSample();

            _targetMesh.bounds = _meshBounds;

            Profiler.BeginSample("Recalculate Tangents");
            //too costly
            //_targetMesh.RecalculateTangents();
            Profiler.EndSample();

            if (_sourceMeshRenderer.enabled)
                _sourceMeshRenderer.enabled = false;

            _currentPhase = SubdividePhase.PreSubdivide;
        }

        #region Subdivide4 (2x2)

        private void DoSubdivide()
        {
            // Process a certain number of triangles each frame
            for (int i = 0; i < trianglesRefreshRate; i++)
            {
                // If all triangles have been processed, reset the index
                if (currentTriangleIndex >= _indicesBase.Length)
                {
                    currentTriangleIndex = 0;
                    _currentPhase = SubdividePhase.FinishMesh;
                    break;
                }

                int i1 = _indicesBase[currentTriangleIndex + 0];
                int i2 = _indicesBase[currentTriangleIndex + 1];
                int i3 = _indicesBase[currentTriangleIndex + 2];

                SubdivideTriangleIterative(_camPosition, levelStart, i1, i2, i3);

                currentTriangleIndex += 3;
            }
        }

        private void SubdivideTriangleIterative(Vector3 camPosition, int level, int i1, int i2, int i3)
        {
            subdivideData.Enqueue((level, i1, i2, i3));

            while (subdivideData.Count > 0)
            {
                (int lvl, int index1, int index2, int index3) = subdivideData.Dequeue();

                int currentLevel = levelStart - lvl;
                if (currentLevel > 3)
                    currentLevel = 0;


                float distanceLevel = LODDistance[currentLevel];

                bool i1In = Vector3.Distance(_localToWorldMatrix.MultiplyPoint3x4(_vertices[index1]), camPosition) > distanceLevel;
                bool i2In = Vector3.Distance(_localToWorldMatrix.MultiplyPoint3x4(_vertices[index2]), camPosition) > distanceLevel;
                bool i3In = Vector3.Distance(_localToWorldMatrix.MultiplyPoint3x4(_vertices[index3]), camPosition) > distanceLevel;

                if (!i1In && !i2In && i3In && lvl > 0)
                {
                    int i12 = GetNewVertex4(index1, index2);

                    AddOrChangeIndice(index1);
                    AddOrChangeIndice(i12);
                    AddOrChangeIndice(index3);

                    AddOrChangeIndice(i12);
                    AddOrChangeIndice(index2);
                    AddOrChangeIndice(index3);
                }
                else if (i1In && !i2In && !i3In && lvl > 0)
                {
                    int i23 = GetNewVertex4(index2, index3);

                    AddOrChangeIndice(index1);
                    AddOrChangeIndice(i23);
                    AddOrChangeIndice(index3);

                    AddOrChangeIndice(index1);
                    AddOrChangeIndice(index2);
                    AddOrChangeIndice(i23);
                }
                else if (!i1In && i2In && !i3In && lvl > 0)
                {
                    int i13 = GetNewVertex4(index1, index3);

                    AddOrChangeIndice(i13);
                    AddOrChangeIndice(index2);
                    AddOrChangeIndice(index3);

                    AddOrChangeIndice(index1);
                    AddOrChangeIndice(index2);
                    AddOrChangeIndice(i13);
                }
                else if (i1In || i2In || lvl == 0)
                {
                    AddOrChangeIndice(index1);
                    AddOrChangeIndice(index2);
                    AddOrChangeIndice(index3);
                }
                else if (lvl > 0)
                {
                    int a = GetNewVertex4(index1, index2);
                    int b = GetNewVertex4(index2, index3);
                    int c = GetNewVertex4(index3, index1);

                    subdivideData.Enqueue((lvl - 1, index1, a, c));
                    subdivideData.Enqueue((lvl - 1, index2, b, a));
                    subdivideData.Enqueue((lvl - 1, index3, c, b));
                    subdivideData.Enqueue((lvl - 1, a, b, c));
                }
            }
        }


        private void AddOrChangeIndice(int indice)
        {
            if (_indices.Count > _indicesCount)
            {
                _indices[_indicesCount] = indice;
            }
            else
                _indices.Add(indice);

            _indicesCount++;
        }


        //dictionary 6.67ms 2.05ms
        //List list
        private int GetNewVertex4(int i1, int i2)
        {
            Profiler.BeginSample("Get New Vertex");
            // uint t1 = 0;
            // if (i1 < i2)
            //     t1 = ((uint) i1 << 16) | (uint) i2;
            // else
            //     t1 = ((uint) i2 << 16) | (uint) i1;

            Profiler.BeginSample("Get Dictionary");
            if (i1 < i2)
            {
                _test.X = i1;
                _test.Y = i2;
            }
            else
            {
                _test.X = i2;
                _test.Y = i1;
            }

            if (_newVertices.TryGetValue(_test, out int vertex4))
            {
                Profiler.EndSample();
                Profiler.EndSample();
                return vertex4;
            }


            int newIndex = _vertices.Count;
            _newVertices.Add(_test, newIndex);
            Profiler.EndSample();
            Profiler.BeginSample("Defining new vertice");


            if (_vertices.Count > _verticesCount)
            {
                //Debug.Log(_verticesCount);
                _vertices[_verticesCount] = (_vertices[i1] + _vertices[i2]) * 0.5f;

                _uv[_verticesCount] = NewUv(_uv, i1, i2);
                _normals[_verticesCount] = (_normals[i1] + _normals[i2]) * 0.5f;
                _tangents[_verticesCount] = (_tangents[i1] + _tangents[i2]) * 0.5f;

                if (_colors.Count > 0)
                    _colors[_verticesCount] = Color.Lerp(_colors[i1], _colors[i2], 0.5f);

                if (_uv3.Count > 0)
                {
                    _uv3[_verticesCount] = (_uv3[i1] + _uv3[i2]) * 0.5f;
                }
            }
            else
            {
                _vertices.Add((_vertices[i1] + _vertices[i2]) * 0.5f);
                _normals.Add((_normals[i1] + _normals[i2]) * 0.5f);
                _tangents.Add((_tangents[i1] + _tangents[i2]) * 0.5f);
                _uv.Add(NewUv(_uv, i1, i2));

                if (_colors.Count > 0)
                    _colors.Add(Color.Lerp(_colors[i1], _colors[i2], 0.5f));
                if (_uv3.Count > 0)
                    _uv3.Add((_uv3[i1] + _uv3[i2]) * 0.5f);
            }

            _verticesCount++;


            Profiler.EndSample();
            Profiler.EndSample();

            return newIndex;
        }

        private Vector4 NewUv(List<Vector4> oldUv, int i1, int i2)
        {
            Vector4 newUv = (oldUv[i1] + oldUv[i2]) * 0.5f;

            return newUv;
            /*     if ((oldUv[i1].z * oldUv[i2].z + oldUv[i1].w * oldUv[i2].w > 0)) return newUv;

                 newUv.z = oldUv[i1].z;
                 newUv.w = oldUv[i1].w;


                 return newUv;*/
        }

        #endregion Subdivide4 (2x2)


        private Mesh DuplicateMesh(Mesh mesh)
        {
            _indicesBase = mesh.triangles;
            _vertices.AddRange(mesh.vertices);
            _normals.AddRange(mesh.normals);
            _tangents.AddRange(mesh.tangents);
            _colors.AddRange(mesh.colors);
            mesh.GetUVs(0, _uv);
            mesh.GetUVs(3, _uv3);

            return Instantiate(mesh);
        }
    }
}