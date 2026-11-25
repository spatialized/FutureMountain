using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class SeaPhysics : MonoBehaviour
    {
        private MeshFilter _meshFilter;
        private Mesh _mesh;
        private MeshRenderer _MeshRenderer;
        private Material _material;
        private MeshCollider _meshCollider;
        private readonly List<Vector3> _vertices = new();
        private readonly List<Vector3> _normals = new();
        private readonly List<Vector4> _tangents = new();
        private readonly List<int> _triangles = new();
        private readonly List<Vector4> _uvs = new();
        private readonly List<Vector4> _uvs3 = new();

        private readonly Dictionary<Vector2, PositionNormal> _worldVertexDatas = new();

        [SerializeField] private float gridSize = 1;
        [SerializeField] private int gridAmount = 1;

        [SerializeField] private Transform debugTransform;
        [SerializeField] private bool debug;


        public struct PositionNormal
        {
            public Vector3 Position;
            public Vector3 Normal;
        }

        private SeaPhysicsCalculations SeaPhysicsCalculations { get; } = new SeaPhysicsCalculations();

        private void Start()
        {
            _meshFilter = GetComponent<MeshFilter>();
            _mesh = _meshFilter.sharedMesh;

            _MeshRenderer = GetComponent<MeshRenderer>();
            _material = _MeshRenderer.sharedMaterial;

            _meshCollider = GetComponent<MeshCollider>();

            if (_mesh != null)
            {
                _triangles.Clear();
                _uvs.Clear();
                _uvs3.Clear();
                _normals.Clear();
                _tangents.Clear();
                _vertices.Clear();

                _mesh.GetTriangles(_triangles, 0);
                _mesh.GetUVs(0, _uvs);
                _mesh.GetUVs(3, _uvs3);
                _mesh.GetNormals(_normals);
                _mesh.GetTangents(_tangents);
                _mesh.GetVertices(_vertices);
            }

            SeaPhysicsCalculations.GetMaterialData(_material);
        }

        private void Update()
        {
            DebugHeight();
        }

        private void FixedUpdate()
        {
            SeaPhysicsCalculations.GetShaderTime();
            ResetData();
        }

        private void DebugHeight()
        {
            if (!debug || debugTransform == null) return;

            ResetData();
            Vector3 checkPosition = debugTransform.position;
            if (gridSize <= 0)
                gridSize = 1;
            PositionNormal searchPosition = GetHeight(checkPosition, true, gridSize);


            DrawDebug(checkPosition, searchPosition);
        }

        private void DrawDebug(Vector3 checkPosition, PositionNormal searchPosition)
        {
            if (debug)
            {
                foreach (var worldVertexData in _worldVertexDatas.Values)
                {
                    Debug.DrawLine(worldVertexData.Position, worldVertexData.Position + worldVertexData.Normal, Color.blue, 0.01f);
                }

                Debug.DrawLine(searchPosition.Position, searchPosition.Position + searchPosition.Normal, Color.red, 0.01f);
            }
        }

        public void ResetData()
        {
            _worldVertexDatas.Clear();
        }

        public PositionNormal GetHeight(Vector3 checkPosition, bool planeNormal = false, float gridSize = 1)
        {
            Vector3 testPosition = new Vector3((int)(checkPosition.x / gridSize) * gridSize, checkPosition.y + 100, (int)(checkPosition.z / gridSize) * gridSize);

            for (int i = -gridAmount; i <= gridAmount; i++)
            {
                for (int j = -gridAmount; j <= gridAmount; j++)
                {
                    var position = new Vector3(i * gridSize, 0, j * gridSize);

                    Vector3 worldPosition = testPosition + position;

                    var position2D = new Vector2(worldPosition.x, worldPosition.z);
                    if (_worldVertexDatas.ContainsKey(position2D)) continue;

                    var ray = new Ray(worldPosition, Vector3.down);

                    if (!_meshCollider.Raycast(ray, out RaycastHit hit, 1000)) continue;

                    Vector3 worldVertex = hit.point;
                    Vector3 worldNormal = hit.normal;


                    (Vector3 vertex, Vector3 normal, Vector4 tangent, Vector4 uv, Vector4 uv3) = GetVertexData(hit);


                    PositionNormal positionNormal = SeaPhysicsCalculations.VertexDataFuncV3Normal(vertex, tangent, normal, uv, uv3, new float3(worldVertex.x, worldVertex.y, worldVertex.z),
                        new float3(worldNormal.x, worldNormal.y, worldNormal.z));

                    Vector3 vertexDataVector = positionNormal.Position;

                    Vector3 worldVertexData = _meshCollider.transform.TransformPoint(vertexDataVector);

                    positionNormal.Position = worldVertexData;

                    _worldVertexDatas.Add(position2D, positionNormal);
                }
            }

            PositionNormal finalPositionNormal = GetSeaHeight(checkPosition, _worldVertexDatas, planeNormal);


            return finalPositionNormal;
            //Gizmos.DrawSphere(searchPosition, 0.1f);
        }

        private void OnDrawGizmos()
        {
            if (!debug || debugTransform == null) return;


            foreach (var worldVertexData in _worldVertexDatas)
            {
                Gizmos.DrawSphere(worldVertexData.Value.Position, 0.1f);
            }
        }

        private PositionNormal GetSeaHeight(Vector3 searchPosition, Dictionary<Vector2, PositionNormal> worldVertexData, bool planeNormal)
        {
            //get average weighted by distance of closest points
            float sum = 0;
            Vector3 normalSum = Vector3.zero;
            float totalWeight = 0;


            foreach (PositionNormal positionNormal in worldVertexData.Values)
            {
                float distance = Vector3.Distance(searchPosition, positionNormal.Position);
                float weight = 1 / distance;
                sum += positionNormal.Position.y * weight;
                if (!planeNormal)
                    normalSum += positionNormal.Normal * weight;
                totalWeight += weight;
            }

            if (totalWeight == 0)
            {
                if (worldVertexData.Count <= 0)
                    return new PositionNormal
                    {
                        Position = searchPosition,
                        Normal = Vector3.up
                    };


                PositionNormal first = worldVertexData.Values.GetEnumerator().Current;
                return new PositionNormal
                {
                    Position = first.Position,
                    Normal = first.Normal
                };
            }

            searchPosition.y = sum / totalWeight;
            Vector3 normal;

            normal = planeNormal ? AverageQuadNormals(searchPosition, worldVertexData) : (normalSum / totalWeight).normalized;


            return new PositionNormal
            {
                Position = searchPosition,
                Normal = normal
            };
        }

        private Vector3 AverageQuadNormals(Vector3 checkPosition, Dictionary<Vector2, PositionNormal> worldVertexData)
        {
            Vector3 normalSum = Vector3.zero;
            int count = 0;

            Vector3 testPosition = new Vector3((int)(checkPosition.x / gridSize) * gridSize, checkPosition.y + 100, (int)(checkPosition.z / gridSize) * gridSize);

            for (int i = -gridAmount; i < gridAmount; i++)
            {
                for (int j = -gridAmount; j < gridAmount; j++)
                {
                    var position = new Vector3(i * gridSize, 0, j * gridSize);
                    Vector3 worldPosition = testPosition + position;
                    var position2D = new Vector2(worldPosition.x, worldPosition.z);

                    if (!worldVertexData.TryGetValue(position2D, out PositionNormal pn1)) continue;
                    Vector3 v1 = pn1.Position;

                    position2D = new Vector2(worldPosition.x + gridSize, worldPosition.z);
                    if (!worldVertexData.TryGetValue(position2D, out PositionNormal pn2)) continue;
                    Vector3 v2 = pn2.Position;

                    position2D = new Vector2(worldPosition.x, worldPosition.z + gridSize);
                    if (!worldVertexData.TryGetValue(position2D, out PositionNormal pn3)) continue;
                    Vector3 v3 = pn3.Position;

                    position2D = new Vector2(worldPosition.x + gridSize, worldPosition.z + gridSize);
                    if (!worldVertexData.TryGetValue(position2D, out PositionNormal pn4)) continue;
                    Vector3 v4 = pn4.Position;

                    Vector3 normal1 = Vector3.Cross(v2 - v1, v3 - v1).normalized;
                    Vector3 normal2 = Vector3.Cross(v4 - v2, v3 - v2).normalized;
                    if (Vector3.Dot(normal1, Vector3.up) < 0)
                    {
                        normal1 = -normal1;
                    }

                    if (Vector3.Dot(normal2, Vector3.up) < 0)
                    {
                        normal2 = -normal2;
                    }

                    normalSum += normal1 + normal2;
                    count += 2;
                }
            }

            Vector3 averageNormal = (count > 0) ? normalSum / count : Vector3.up;
            averageNormal.Normalize();

            return averageNormal;
        }

        private (Vector3 vertex, Vector3 normal, Vector4 tangent, Vector4 uv, Vector4 uv3) GetVertexData(RaycastHit hit)
        {
            Vector3 barycentricCoordinate = hit.barycentricCoordinate;
            int triangle0 = _triangles[hit.triangleIndex * 3 + 0];
            int triangle1 = _triangles[hit.triangleIndex * 3 + 1];
            int triangle2 = _triangles[hit.triangleIndex * 3 + 2];

            Vector3 vertex0 = _vertices[triangle0];
            Vector3 vertex1 = _vertices[triangle1];
            Vector3 vertex2 = _vertices[triangle2];

            Vector3 normal0 = _normals[triangle0];
            Vector3 normal1 = _normals[triangle1];
            Vector3 normal2 = _normals[triangle2];

            Vector4 tangent0 = _tangents[triangle0];
            Vector4 tangent1 = _tangents[triangle1];
            Vector4 tangent2 = _tangents[triangle2];

            Vector4 uv00 = _uvs[triangle0];
            Vector4 uv01 = _uvs[triangle1];
            Vector4 uv02 = _uvs[triangle2];

            Vector4 uv30 = _uvs3[triangle0];
            Vector4 uv31 = _uvs3[triangle1];
            Vector4 uv32 = _uvs3[triangle2];

            Vector3 vertex = vertex0 * barycentricCoordinate.x + vertex1 * barycentricCoordinate.y + vertex2 * barycentricCoordinate.z;
            Vector3 normal = normal0 * barycentricCoordinate.x + normal1 * barycentricCoordinate.y + normal2 * barycentricCoordinate.z;
            Vector4 tangent = tangent0 * barycentricCoordinate.x + tangent1 * barycentricCoordinate.y + tangent2 * barycentricCoordinate.z;
            Vector4 uv = uv00 * barycentricCoordinate.x + uv01 * barycentricCoordinate.y + uv02 * barycentricCoordinate.z;
            Vector4 uv3 = uv30 * barycentricCoordinate.x + uv31 * barycentricCoordinate.y + uv32 * barycentricCoordinate.z;

            return (vertex, normal, tangent, uv, uv3);
        }
    }
}