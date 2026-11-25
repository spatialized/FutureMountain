using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public partial class Waterfall : MonoBehaviour, IVertexPaintable, IGenerationEvents
    {
        [SerializeField] private NmSpline nmSpline;
        [field: SerializeField] public bool BaseDebug { get; set; }


        [SerializeField] private WaterfallProfile baseProfile;
        [SerializeField] private WaterfallProfile currentProfile;
        [SerializeField] private WaterfallProfile oldProfile;
        [field: SerializeField] public MeshFilter MainMeshFilter { get; set; }


        [field: SerializeField] public int ToolbarInt { get; set; }
        [SerializeField] private VertexPainterData vertexPainterData = new(true);
        [field: SerializeField] public List<Vector3> VerticeDirection { get; set; } = new();

        [SerializeField] private WaterfallConnection connection;

        // Initialize mesh UVs, vertices, triangles, and normals
        private Mesh mesh;
        private readonly Dictionary<WaterfallSimulator.MeshSimulation, int> verticeIndex = new();
        private readonly List<Vector2> uvs = new();
        private readonly List<Vector2> colorsFlowMap = new();
        private readonly List<Vector3> vertices = new();
        private readonly List<int> triangles = new();
        private readonly List<Vector3> normals = new();
        private readonly List<Vector4> tangents = new();
        private readonly List<Vector3> binormals = new();
        private readonly List<Color> colors = new();

        private readonly List<Vector4> vertexData = new();
        private Color[] oldColors;
        private bool _duplicate;
        private WaterfallSimulator _waterfallSimulator = new();


        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }

        public VertexPainterData VertexPainterData => vertexPainterData ??= new VertexPainterData(true);

        public NmSpline NmSpline
        {
            get
            {
                if (nmSpline != null && nmSpline.gameObject == gameObject)
                    return nmSpline;


                if (BaseProfile == null)
                    GenerateBaseProfile();
                else
                {
                    BaseProfile = ScriptableObject.CreateInstance<WaterfallProfile>();
                    //MeshRenderer ren = GetComponent<MeshRenderer>();
                    // BaseProfile.WaterfallMaterial = ren.sharedMaterial;
                    BaseProfile.SetProfileData(BaseProfile);
                }

                nmSpline = GetComponentInParent<NmSpline>();

                nmSpline.SetData(0, 1, false, true, false, true, false, false);

                return nmSpline;
            }
        }

        public WaterfallProfile BaseProfile
        {
            get
            {
                if (baseProfile == null)
                    GenerateBaseProfile();
                return baseProfile;
            }
            private set => baseProfile = value;
        }


        public WaterfallProfile CurrentProfile
        {
            get => currentProfile;
            set => currentProfile = value;
        }

        public WaterfallProfile OldProfile
        {
            get => oldProfile;
            set => oldProfile = value;
        }

        public WaterfallSimulator Simulator
        {
            get => _waterfallSimulator;
            private set => _waterfallSimulator = value;
        }

        public WaterfallConnection Connection
        {
            get => connection;
            set => connection = value;
        }


        public void GenerateBaseProfile()
        {
            baseProfile = ScriptableObject.CreateInstance<WaterfallProfile>();
            MeshRenderer ren = GetComponent<MeshRenderer>();
            BaseProfile.WaterfallMaterial = ren.sharedMaterial;
            baseProfile.name = "WaterfallProfile";
            baseProfile.GameObject = gameObject;
        }

        public void OnValidate()
        {
            if (BaseProfile == null || BaseProfile.GameObject == gameObject) return;

            WaterfallProfile tempProfile = BaseProfile;
            BaseProfile = ScriptableObject.CreateInstance<WaterfallProfile>();
            BaseProfile.SetProfileData(tempProfile);
            BaseProfile.GameObject = gameObject;
            _duplicate = true;
        }


        public static Waterfall CreatWaterfall()
        {
            GameObject waterfall = new("Waterfall")
            {
                layer = LayerMask.NameToLayer("Water")
            };
            waterfall.AddComponent<NmSpline>();
            waterfall.AddComponent<Waterfall>();

            var meshRenderer = waterfall.GetComponent<MeshRenderer>();


            if (meshRenderer == null)
                meshRenderer = waterfall.AddComponent<MeshRenderer>();

            meshRenderer.receiveShadows = true;
            meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
#if UNITY_EDITOR
            meshRenderer.receiveGI = ReceiveGI.Lightmaps;
#endif

            return waterfall.GetComponent<Waterfall>();
        }

        public void GenerateSplineAndPointList(bool quick)
        {
            if (quick)
            {
                VertexPainterData.OverridenColors = false;
                VertexPainterData.OverridenFlow = false;
            }

            if (BaseProfile == null)
            {
                GenerateBaseProfile();
            }

            GeneratePointList();

            SimulateAndDraw();
        }

        private void GeneratePointList()
        {
            nmSpline.PrepareSpline();
            nmSpline.GenerateFullSpline(BaseProfile.TriangleDensity);

            if (nmSpline.Points.Count <= 2) return;

            NmSplinePoint nmSplinePoint = nmSpline.Points[0];
            nmSplinePoint.Normal = nmSpline.Points[1].Normal;
            nmSplinePoint.Binormal = nmSpline.Points[1].Binormal;
            nmSplinePoint.Tangent = nmSpline.Points[1].Tangent;
            nmSplinePoint.Orientation = nmSpline.Points[1].Orientation;
            nmSplinePoint.Tangent = nmSpline.Points[1].Tangent;


            NmSplinePoint lastNmSplinePoint = nmSpline.Points[^1];
            lastNmSplinePoint.Normal = nmSpline.Points[^2].Normal;
            lastNmSplinePoint.Binormal = nmSpline.Points[^2].Binormal;
            lastNmSplinePoint.Tangent = nmSpline.Points[^2].Tangent;
            lastNmSplinePoint.Orientation = nmSpline.Points[^2].Orientation;
            lastNmSplinePoint.Rotation = nmSpline.Points[^2].Rotation;

            nmSpline.GenerateArrayForDistanceSearch();
        }

        public void GenerateSplineObjects()
        {
            OnGenerationStarted?.Invoke();

            if (!NmSpline.CanGenerateSpline())
                return;
            nmSpline.CenterSplinePivot();
            GeneratePointList();
            SimulateAndDraw();


            OnGenerationEnded?.Invoke();
        }


        private void SimulateAndDraw()
        {
            if (BaseProfile.TimeStep == 0 || BaseProfile.SimulationTime == 0)
                return;


            Simulator ??= new WaterfallSimulator();

            double fullGeneratioTime = Time.realtimeSinceStartupAsDouble;
            double makeSimulationTime = Time.realtimeSinceStartupAsDouble;

            List<List<WaterfallSimulator.MeshSimulation>> simulationPoints = Simulator.MakeSimulation(this);

            if (BaseDebug)
            {
                Debug.Log($"Make simulation time: {(Time.realtimeSinceStartupAsDouble - makeSimulationTime):0.00000} s");
            }

            double clearMeshDataTime = Time.realtimeSinceStartupAsDouble;
            ClearMeshData();

            if (BaseDebug)
                Debug.Log($"Clear mesh data time: {(Time.realtimeSinceStartupAsDouble - clearMeshDataTime):0.00000} s");

            double fixUVsTime = Time.realtimeSinceStartupAsDouble;

            FixUVs(simulationPoints);

            if (BaseDebug)
                Debug.Log($"Fix UVs time: {(Time.realtimeSinceStartupAsDouble - fixUVsTime):0.00000} s");

            double generateMeshDataTime = Time.realtimeSinceStartupAsDouble;

            GenerateMeshData(simulationPoints);

            if (BaseDebug)
                Debug.Log($"Generate mesh data time: {(Time.realtimeSinceStartupAsDouble - generateMeshDataTime):0.00000} s");

            Vector3[] verticesArray = vertices.ToArray();

            double changeVertexPaintHeightTime = Time.realtimeSinceStartupAsDouble;

            VertexPaintHeight.ChangeVertexPosition(verticesArray, normals.ToArray(), vertexData);

            if (BaseDebug)
                Debug.Log($"Change vertex paint height time: {(Time.realtimeSinceStartupAsDouble - changeVertexPaintHeightTime):0.00000} s");

            double setupMeshTime = Time.realtimeSinceStartupAsDouble;
            SetupMesh(verticesArray);

            CheckMeshColliderMesh();

            if (BaseDebug)
                Debug.Log($"Setup mesh time: {(Time.realtimeSinceStartupAsDouble - setupMeshTime):0.00000} s");

            if (BaseDebug)
                Debug.Log($"Full generation time: {(Time.realtimeSinceStartupAsDouble - fullGeneratioTime):0.00000} s");
        }

        private void CheckMeshColliderMesh()
        {
            if (TryGetComponent(out MeshCollider meshCollider))
            {
                meshCollider.sharedMesh = mesh;
            }
        }

        private void GetMeshVertexData(List<Vector4> uv4)
        {
            uv4.Clear();

            if (mesh != null)
            {
                mesh.GetUVs(4, uv4);
            }
        }

        private void FixUVs(List<List<WaterfallSimulator.MeshSimulation>> simulationPoints)
        {
            float uvVMultiplier = 0.25f;

            if (NmSpline.IsLooping)
                uvVMultiplier = (Mathf.Ceil(simulationPoints[^1][0].DistanceV * 0.25f * BaseProfile.UvScale.x) / BaseProfile.UvScale.x) / (simulationPoints[^1][0].DistanceV * 0.25f);

            for (int i = 0; i < simulationPoints.Count; i++)
            {
                for (int j = 0; j < simulationPoints[i].Count; j++)
                {
                    WaterfallSimulator.MeshSimulation meshSimulation = simulationPoints[i][j];


                    //generate uv based on distance to previous point
                    if (j > 0)
                    {
                        meshSimulation.DistanceU = simulationPoints[i][j - 1].DistanceU + Vector3.Distance(simulationPoints[i][j - 1].Position, meshSimulation.Position);
                    }
                    else
                    {
                        meshSimulation.DistanceU = 0;
                    }


                    meshSimulation.DistanceV *= uvVMultiplier;

                    simulationPoints[i][j] = meshSimulation;
                }
            }
        }


        private void SetupMesh(Vector3[] verticesArray = null)
        {
            int vertexCount = verticesArray?.Length ?? vertices.Count;

            mesh.indexFormat = vertexCount > 65535 ? IndexFormat.UInt32 : IndexFormat.UInt16;


            mesh.SetVertices(verticesArray ?? vertices.ToArray());
            mesh.SetTriangles(triangles, 0);
            mesh.SetNormals(normals);
            mesh.SetTangents(tangents);
            mesh.SetColors(colors);

            mesh.SetUVs(0, uvs);
            mesh.SetUVs(3, colorsFlowMap);
            mesh.SetUVs(4, vertexData);

            mesh.RecalculateNormals();
            mesh.RecalculateTangents();

            MainMeshFilter.sharedMesh = mesh;
        }

        private void GenerateMeshData(List<List<WaterfallSimulator.MeshSimulation>> simulationPoints)
        {
            for (int i = 1; i < simulationPoints.Count; i++)
            {
                for (int j = 1; j < simulationPoints[i].Count; j++)
                {
                    if (simulationPoints[i - 1].Count > j)
                    {
                        WaterfallSimulator.MeshSimulation meshSimulation1 = simulationPoints[i - 1][j - 1];
                        WaterfallSimulator.MeshSimulation meshSimulation2 = simulationPoints[i][j - 1];
                        WaterfallSimulator.MeshSimulation meshSimulation3 = simulationPoints[i][j];

                        int vertex1 = GenerateVerticeData(meshSimulation1);
                        int vertex2 = GenerateVerticeData(meshSimulation2);
                        int vertex3 = GenerateVerticeData(meshSimulation3);

                        AddTriangle(vertex1, vertex2, vertex3);

                        if (simulationPoints[i - 1].Count <= j) continue;

                        int vertex4 = GenerateVerticeData(simulationPoints[i - 1][j]);

                        AddTriangle(vertex1, vertex3, vertex4);


                        if (simulationPoints[i].Count != j + 1 || simulationPoints[i - 1].Count <= j) continue;

                        int k = j + 1;
                        while (simulationPoints[i - 1].Count > k)
                        {
                            int vertex5 = GenerateVerticeData(simulationPoints[i - 1][k]);

                            AddTriangle(vertex4, vertex3, vertex5);
                            k++;
                        }
                    }
                    else
                    {
                        WaterfallSimulator.MeshSimulation meshSimulation1 = simulationPoints[i - 1][^1];
                        WaterfallSimulator.MeshSimulation meshSimulation2 = simulationPoints[i][j - 1];
                        WaterfallSimulator.MeshSimulation meshSimulation3 = simulationPoints[i][j];

                        int vertex1 = GenerateVerticeData(meshSimulation1);
                        int vertex2 = GenerateVerticeData(meshSimulation2);
                        int vertex3 = GenerateVerticeData(meshSimulation3);

                        AddTriangle(vertex1, vertex2, vertex3);
                    }
                }
            }


            GetOldVertexColors();
        }

        private void GetOldVertexColors()
        {
            if (oldColors == null || oldColors.Length != vertices.Count || !VertexPainterData.OverridenColors) return;

            for (int i = 0; i < oldColors.Length && i < colors.Count; i++)
            {
                colors[i] = oldColors[i];
            }
        }


        private void AddTriangle(int vertex1, int vertex2, int vertex3)
        {
            triangles.Add(vertex1);
            triangles.Add(vertex2);
            triangles.Add(vertex3);
        }

        private void GetMesh()
        {
            if (!MainMeshFilter || _duplicate)
            {
                MainMeshFilter = GetComponent<MeshFilter>();
                MainMeshFilter.sharedMesh = null;

                _duplicate = false;
            }


            if (MainMeshFilter.sharedMesh == null)
            {
                mesh = new Mesh();
                mesh.name = "Waterfall Mesh";
                MainMeshFilter.sharedMesh = mesh;
            }
            else
            {
                mesh = MainMeshFilter.sharedMesh;
            }
        }


        private void ClearMeshData()
        {
            GetMesh();

            GetMeshVertexData(vertexData);

            oldColors = mesh.colors;
            mesh.Clear();

            //clear all mesh data list
            verticeIndex.Clear();
            uvs.Clear();
            vertices.Clear();
            triangles.Clear();
            normals.Clear();
            tangents.Clear();
            binormals.Clear();
            colors.Clear();
            colorsFlowMap.Clear();
            VerticeDirection.Clear();
        }

        private int GenerateVerticeData(WaterfallSimulator.MeshSimulation meshSimulation)
        {
            if (verticeIndex.TryGetValue(meshSimulation, out int verticeData))
            {
                return verticeData;
            }

            Vector3 vertice = meshSimulation.Position;
            uvs.Add(new Vector2(meshSimulation.DistanceV * BaseProfile.UvScale.x, -meshSimulation.DistanceU * BaseProfile.UvScale.y));
            normals.Add(meshSimulation.Normal);
            tangents.Add(new Vector4(meshSimulation.Tangent.x, meshSimulation.Tangent.y, meshSimulation.Tangent.z, 1));
            binormals.Add(meshSimulation.Binormal);
            colorsFlowMap.Add(new Vector2(0, 0.5f));

            //Debug.DrawRay(transform.TransformPoint(meshSimulation.Position), meshSimulation.Velocity.normalized, Color.red, 2.5f);

            VerticeDirection.Add(meshSimulation.Velocity.normalized);

            //Debug.Log(meshSimulation.Distance);
            float alpha = BaseProfile.AlphaByDistance.Evaluate(meshSimulation.Distance / BaseProfile.MaxWaterfallDistance);
            colors.Add(new Color(0, 0, 0, alpha));

            vertices.Add(vertice);
            verticeIndex.Add(meshSimulation, vertices.Count - 1);

            return vertices.Count - 1;
        }

        public VertexPainterData GetVertexPainterData()
        {
            return VertexPainterData;
        }
    }
}