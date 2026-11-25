using System;
using System.Collections.Generic;
using TriangleNet.Geometry;
using TriangleNet.Meshing;
using TriangleNet.Smoothing;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;
using UnityEngine.Serialization;
using Vertex = TriangleNet.Geometry.Vertex;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace NatureManufacture.RAM
{
#if VEGETATION_STUDIO
using AwesomeTechnologies;
using AwesomeTechnologies.VegetationStudio;
#endif
#if VEGETATION_STUDIO_PRO
using AwesomeTechnologies.VegetationSystem.Biomes;
#endif

    [SelectionBase]
    [RequireComponent(typeof(NmSpline))]
    [RequireComponent(typeof(MeshFilter))]
    public class LakePolygon : MonoBehaviour, IVertexPaintable, ITerrainPainterGetData, IGenerationEvents
    {
        public int toolbarInt;

        public LakePolygonProfile baseProfile;
        public LakePolygonProfile currentProfile;
        public LakePolygonProfile oldProfile;

        #region Obsolete

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Vector3> points = new List<Vector3>();

        #endregion


        //public bool overrideLakeRender;


        public bool generateMeshParts;
        public int meshPartsCount = 3;
        public List<Transform> meshesPartTransforms = new List<Transform>();
        public bool generateLod;
        public bool canGenerateLod = false;
        public bool generateLodGPU = false;
        public Vector4 lodDistance = new(100, 80, 50, 20);
        public float lodRefreshTime = 0.1f;


        public float height;
        public bool lockHeight = true;


        public float yOffset;


        public int trianglesGenerated;
        public float vertsGenerated;
        public Mesh currentMesh;

        public MeshFilter meshFilter;

        public MeshRenderer MeshRenderer
        {
            get
            {
                if (meshRenderer == null) meshRenderer = GetComponent<MeshRenderer>();
                return meshRenderer;
            }
            set => meshRenderer = value;
        }


        public List<Vector4> depth = new();


        public float closeDistanceSimulation = 5f;
        public int angleSimulation = 5;
        public float checkDistanceSimulation = 50;
        public float depthOffsetSimulation = 0.5f;
        public bool removeFirstPointSimulation = true;


        public bool snapToTerrain;


        

        public bool ShowDebug { get; set; }

        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }
        [field: SerializeField] public RamControlPoint LastGenerationPoint { get; set; }
        [field: SerializeField] public Vector3 LastGenerationPosition { get; set; }


        [SerializeField] List<RamMath.MinimumDistanceVector> minimumDistanceVectors = new();
        [SerializeField] private List<NmSpline> lakeHoles = new();

        [SerializeField] private NmSpline nmSpline;


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
                    BaseProfile = ScriptableObject.CreateInstance<LakePolygonProfile>();
                    BaseProfile.SetProfileData(BaseProfile);
                }


                nmSpline = GetComponentInParent<NmSpline>();
                nmSpline.SetData(snapToTerrain ? 1 : 0, 1, true, false, false, true, false, false, false);
                MoveControlPointsToMainControlPoints();
                GeneratePolygon();

                return nmSpline;
            }
            set => nmSpline = value;
        }


        public RamTerrainManager RamTerrainManager
        {
            get => ramTerrainManager ??= new RamTerrainManager(NmSpline, this);
            set => ramTerrainManager = value;
        }

        public MeshFilter MainMeshFilter
        {
            get => meshFilter;
            set => meshFilter = value;
        }

        public TerrainPainterData PainterData
        {
            get => BaseProfile.PainterData;
            set => BaseProfile.PainterData = value;
        }


        public VertexPainterData VertexPainterData => vertexPainterData ??= new VertexPainterData(true);

        [field: SerializeField] public float TriangleSizeByLimit { get; set; }

        public LakePolygonProfile BaseProfile
        {
            get
            {
                if (baseProfile == null)
                    GenerateBaseProfile();
                return baseProfile;
            }
            set => baseProfile = value;
        }


        private LakeMeshPartGenerator MeshPartGenerator { get; } = new();

        private LakeFlowmapGenerator LakeFlowmapGenerator
        {
            get { return _lakeFlowmapGenerator; }
        }

        public List<RamMath.MinimumDistanceVector> MinimumDistanceVectors
        {
            get => minimumDistanceVectors;
            set => minimumDistanceVectors = value;
        }

        public LakeVertexColorGenerator LakeVertexColorGenerator
        {
            get { return _lakeVertexColorGenerator; }
        }

        public bool GenerateLod
        {
            get => generateLod && canGenerateLod;
            set => generateLod = value;
        }

        public List<NmSpline> LakeHoles
        {
            get => lakeHoles;
            set => lakeHoles = value;
        }


#if VEGETATION_STUDIO_PRO
    public float biomMaskResolution = 0.5f;
    public float vegetationBlendDistance = 1;
    public float vegetationMaskSize = 3;
    public BiomeMaskArea biomeMaskArea;
    public bool refreshMask = false;
#endif
#if VEGETATION_STUDIO
    public float vegetationMaskResolution = 0.5f;
    public float vegetationMaskPerimeter = 5;
    public VegetationMaskArea vegetationMaskArea;

#endif


        public List<GameObject> meshTerrainGOs = new();

        [FormerlySerializedAs("terrainManager")] [SerializeField]
        private RamTerrainManager ramTerrainManager;

        [SerializeField] private VertexPainterData vertexPainterData = new(true);
        private bool _duplicate;
        private readonly LakeFlowmapGenerator _lakeFlowmapGenerator = new();
        private readonly LakeVertexColorGenerator _lakeVertexColorGenerator;
        private List<Vector4> _directionFlowMap = new();
        private List<float> _directionFlowMapDistance = new();
        private Vector3[] _vertices;
        private Vector3[] _normals;
        private Vector4[] _uvs;
        private List<Vector4> _colorsFlowMap;
        private List<int> _indices;

        List<Vector4> vertexData;
        private Color[] _colors;
        [SerializeField] private MeshRenderer meshRenderer;


        public LakePolygon()
        {
            _lakeVertexColorGenerator = new LakeVertexColorGenerator(this);
        }


        private void Awake()
        {
            ShowDebug = false;
        }

        public void OnValidate()
        {
            Event e = Event.current;

            if (e is not { type: EventType.ExecuteCommand, commandName: "Duplicate" } &&
                e is not { type: EventType.ExecuteCommand, commandName: "Paste" }) return;


            _duplicate = true;


            if (BaseProfile == null)
                GenerateBaseProfile();
            else
            {
                LakePolygonProfile tempProfile = BaseProfile;
                BaseProfile = ScriptableObject.CreateInstance<LakePolygonProfile>();

                BaseProfile.SetProfileData(tempProfile);
            }

            RamTerrainManager oldRamTerrainManager = ramTerrainManager;

            ramTerrainManager = new RamTerrainManager(NmSpline, this, oldRamTerrainManager);
        }

  
        public Transform GetTransform => transform;

        public void GenerateForTerrain()
        {
            GeneratePolygon();
        }

        public void GeneratePolygon(bool quick = false)
        {
            OnGenerationStarted?.Invoke();

#if UNITY_EDITOR
            if (ShowDebug)
            {
                Debug.Log($"-----Generate mesh polygon {gameObject.name}", gameObject);
            }

            double fullTime = EditorApplication.timeSinceStartup;
            double time = EditorApplication.timeSinceStartup;
#endif


            meshFilter = GetComponent<MeshFilter>();

            if (meshFilter.sharedMesh != null)
            {
                currentMesh = Instantiate(meshFilter.sharedMesh);
                currentMesh.name = $"mesh {gameObject.name}";
            }


            if (RamTerrainManager.BasePainterData != null)
                RamTerrainManager.BasePainterData.TerrainsUnder.Clear();

            if (BaseProfile == null)
            {
                GenerateBaseProfile();
            }

            MoveControlPointsToMainControlPoints();

            CheckMeshRenderer();

            LockHeight();

            if (!NmSpline.CanGenerateSpline(3))
                return;

            NmSpline.CenterSplinePivot();

            NmSpline.PrepareSpline();
            
            NmSpline.GenerateFullSpline(BaseProfile.triangleDensity);
           // NmSpline.CalculateCatmullRomSideSplines();

           // NmSpline.CalculateSplinePositions(BaseProfile.triangleDensity, NmSpline.SplineSide.Center);
            
            


            if (ShowDebug)
            {
#if UNITY_EDITOR
                if (ShowDebug)
                {
                    Debug.Log($"-Prepare spline and mesh data: {EditorApplication.timeSinceStartup - time:F6}");
                }
#endif
            }

            (List<int> indices, List<Vector3> vertices, float triangleSizeByLimit) verticesData =
                SplineTriangulator.TriangulateSpline(quick, BaseProfile.maximumTriangleSize, BaseProfile.maximumTriangleAmount, nmSpline, LakeHoles, ShowDebug);

            TriangleSizeByLimit = verticesData.triangleSizeByLimit;
            _indices = verticesData.indices;
            _vertices = verticesData.vertices.ToArray();
            int vertCount = _vertices.Length;

            _normals = new Vector3[vertCount];
            _uvs = new Vector4[vertCount];
            _colorsFlowMap = new List<Vector4>();
            vertexData = new List<Vector4>();
            _directionFlowMap.Clear();
            _directionFlowMapDistance.Clear();


            GetMeshColorsFlowmap(_colorsFlowMap);

            GetMeshVertexData(vertexData);

            _colors = GetMeshVertexColors(vertCount);


            GenerateMeshData(quick, vertCount);

            SetMeshData(quick, vertCount);


            var meshCollider = GetComponent<MeshCollider>();
            if (meshCollider != null) meshCollider.sharedMesh = currentMesh;
#if UNITY_EDITOR

            double timeManageMeshParts = EditorApplication.timeSinceStartup;
#endif
            ManageMeshParts(quick);
#if UNITY_EDITOR
            if (ShowDebug)
            {
                Debug.Log($"-Manage Mesh Parts: {EditorApplication.timeSinceStartup - timeManageMeshParts:F6}");
            }
#endif

#if UNITY_EDITOR
            if (ShowDebug)
            {
                Debug.Log($"Full lake polygon generation: {EditorApplication.timeSinceStartup - fullTime:F6}");
            }
#endif

            OnGenerationEnded?.Invoke();
        }

        private void GenerateMeshData(bool quick, int vertCount)
        {
#if UNITY_EDITOR
            double time = EditorApplication.timeSinceStartup;
#endif
            if (!quick)
            {
                GenerateMinimumDistances();


                ManageFlowmap(_colorsFlowMap, vertCount, _indices);

                
                ManageVertexColor(_colors, vertCount);


#if UNITY_EDITOR
                double timeCalculate = EditorApplication.timeSinceStartup;
#endif

                Vector3 position;
                depth.Clear();
                float maxWaveValue = !BaseProfile.depthEnabled ? 1 : RamMath.FindMaxCurveValue(BaseProfile.waveCurve);
                float maxDepthValue = !BaseProfile.depthEnabled ? 1 : RamMath.FindMaxCurveValue(BaseProfile.depthCurve);


                for (int i = 0; i < vertCount; i++)
                {
                    position = transform.position;
                    Vector3 vertice = _vertices[i];

                    //Offset mesh

                    _normals[i] = Vector3.up;
                    _uvs[i] = new Vector2(_vertices[i].x, _vertices[i].z) * (0.01f * BaseProfile.uvScale);


                    CalculateDepthAndDirectionalMap(i, ref vertice, position, maxWaveValue, maxDepthValue);

                    _vertices[i] = vertice;
                    _vertices[i].y += yOffset;
                }

                VertexPaintHeight.ChangeVertexPosition(_vertices, _normals, vertexData);


#if UNITY_EDITOR
                if (ShowDebug)
                {
                    Debug.Log($"--Calculate Data: {EditorApplication.timeSinceStartup - timeCalculate:F6}");
                }
#endif

#if UNITY_EDITOR
                double timeCalculateSmoothDirect = EditorApplication.timeSinceStartup;
#endif


                if (BaseProfile.depthEnabled)
                {
                    HashSet<int>[] connectedVertices = MeshDataSmoother.GetConnectedVertices(vertCount, _indices);

                    if (BaseProfile.automaticDirectionalMapSmoothAmount > 0)
                        MeshDataSmoother.SmoothVerticeData(connectedVertices, BaseProfile.automaticDirectionalMapSmoothAmount, _directionFlowMap, vertCount);

                    if (BaseProfile.depthSmoothAmount > 0)
                        MeshDataSmoother.SmoothVerticeData(connectedVertices, BaseProfile.depthSmoothAmount, depth, vertCount, 0, false, true);
                }

#if UNITY_EDITOR
                if (ShowDebug)
                {
                    Debug.Log($"-Smoothing directional map: {EditorApplication.timeSinceStartup - timeCalculateSmoothDirect:F6}");
                }
#endif
            }
            else
            {
                PrepareClearMeshData(vertCount, _normals);
            }

#if UNITY_EDITOR
            if (ShowDebug)
            {
                Debug.Log($"-Get additional mesh data: {EditorApplication.timeSinceStartup - time:F6}");
            }
#endif
        }

        public void GenerateMinimumDistances()
        {
            if (MinimumDistanceVectors.Count != _vertices.Length)
            {
                minimumDistanceVectors = RamMath.CalculateVectorBorderDistances(_vertices, NmSpline);
            }
        }

        private void CalculateDepthAndDirectionalMap(int i, ref Vector3 vertice, Vector3 position, float maxWaveValue, float maxDepthValue)
        {
            Vector3 flowDirection = -new Vector3(_colorsFlowMap[i].x, 0, _colorsFlowMap[i].y);
            Vector4 directionalFlow;


            //Check if terrain under
            if (Physics.Raycast(vertice + position + Vector3.up * 10000, Vector3.down, out RaycastHit hit, 30000, BaseProfile.snapMask.value, QueryTriggerInteraction.Ignore))
            {
                if (BaseProfile.NormalFromRaycast)
                {
                    _normals[i] = Vector3.Lerp(_normals[i], hit.normal, BaseProfile.NormalFromRaycastLerp);
                }

                var checkTerrain = hit.collider.gameObject.GetComponent<Terrain>();
                RamTerrainManager.BasePainterData.AddTerrain(checkTerrain);

                //Debug.Log(snapToTerrain);
                if (snapToTerrain)
                    vertice = hit.point - position + new Vector3(0, 0.1f, 0);

                float positionY = position.y + vertice.y - hit.point.y + yOffset;


                if (BaseProfile.depthEnabled)
                {
                    depth.Add(new Vector2(BaseProfile.waveCurve.Evaluate(positionY), BaseProfile.depthCurve.Evaluate(positionY)));

                    CalculateDirectionFlowMap(positionY, flowDirection, vertice, position);
                }
                else
                {
                    depth.Add(new Vector2(maxWaveValue, maxDepthValue));
                    directionalFlow = flowDirection * 0.1f;
                    directionalFlow.w = 1000;
                    _directionFlowMap.Add(directionalFlow);
                    _directionFlowMapDistance.Add(directionalFlow.w);
                }
            }
            else //No terrain under
            {
                depth.Add(new Vector2(maxWaveValue, maxDepthValue));
                directionalFlow = flowDirection * 0.1f;
                directionalFlow.w = 1000;
                _directionFlowMap.Add(directionalFlow);
                _directionFlowMapDistance.Add(directionalFlow.w);
            }
        }


        private void PrepareClearMeshData(int vertCount, Vector3[] normals)
        {
            VertexPainterData.OverridenColors = false;
            VertexPainterData.OverridenFlow = false;


            minimumDistanceVectors.Clear();

            for (int i = 0; i < vertCount; i++)
            {
                normals[i] = Vector3.up;
            }
        }

        private void CalculateDirectionFlowMap(float positionY, Vector3 flowDirection, Vector3 vertice, Vector3 position)
        {
            Vector3 minPosition = Vector3.zero;
            float minDistance = float.MaxValue;
            bool hited = false;
            Vector3 verticePosition = vertice + position;
            Vector4 directionalFlow;

            float raysAmount = BaseProfile.directionalMapRaysAngle / (float)BaseProfile.directionalMapRaysAmount;
            if (positionY > 0)
                for (float angle = -BaseProfile.directionalMapRaysAngle * 0.5f; angle <= BaseProfile.directionalMapRaysAngle * 0.5f; angle += raysAmount)
                {
                    Vector3 direction = Quaternion.Euler(0, angle, 0) * flowDirection;

                    //find closest hitted point
                    if (!Physics.Raycast(verticePosition, direction, out RaycastHit hitRotated, 1000, BaseProfile.snapMask.value, QueryTriggerInteraction.Ignore)) continue;

                    float distance = hitRotated.distance;
                    if (!(distance < minDistance)) continue;

                    minDistance = distance;
                    minPosition = hitRotated.point;
                    hited = true;
                }


            if (hited)
            {
                //if (ShowDebug)
                //    Debug.DrawLine(verticePosition, minPosition, Color.red, 1f);
                directionalFlow = verticePosition - minPosition;
                directionalFlow.w = minDistance;
                //Direction and distance
            }
            else
            {
                directionalFlow = flowDirection * 0.1f;
                directionalFlow.w = 0.1f;
            }

            _directionFlowMap.Add(directionalFlow);
            _directionFlowMapDistance.Add(directionalFlow.w);
        }

        private void SetMeshData(bool quick, int vertCount)
        {
#if UNITY_EDITOR
            double time = EditorApplication.timeSinceStartup;
#endif
            if (currentMesh && !_duplicate)
            {
                _duplicate = false;
                currentMesh.Clear();
            }
            else
                currentMesh = new Mesh();

            vertsGenerated = vertCount;

            if (vertCount > 65000) currentMesh.indexFormat = IndexFormat.UInt32;


            currentMesh.vertices = _vertices;
            currentMesh.subMeshCount = 1;
            currentMesh.SetTriangles(_indices, 0);


            currentMesh.normals = _normals;


            if (!quick)
            {
                Vector2 directional = new();
                // set depth data into colorsFlowMap z and w
                for (int i = 0; i < depth.Count; i++)
                {
                    float distance = _directionFlowMap[i].w;
                    if (!BaseProfile.smoothDistance)
                    {
                        distance = _directionFlowMapDistance[i];
                    }

                    if (distance < 1)
                        distance = 1;

                    directional.x = _directionFlowMap[i].x;
                    directional.y = _directionFlowMap[i].z;
                    directional = directional.normalized * distance;


                    _uvs[i].z = directional.x;
                    _uvs[i].w = directional.y;
                    _colorsFlowMap[i] = new Vector4(_colorsFlowMap[i].x, _colorsFlowMap[i].y, depth[i].x < 0 ? 0 : depth[i].x, depth[i].y < 0 ? 0 : depth[i].y);
                }

                currentMesh.colors = _colors;
                currentMesh.SetUVs(3, _colorsFlowMap);
                currentMesh.SetUVs(4, vertexData);
            }
            else
            {
                currentMesh.colors = null;
                currentMesh.SetUVs(3, (Vector4[])null);
            }

            currentMesh.SetUVs(0, _uvs);

            trianglesGenerated = _indices.Count / 3;


            currentMesh.RecalculateTangents();
            currentMesh.RecalculateBounds();

            meshFilter.sharedMesh = currentMesh;

#if UNITY_EDITOR
            if (ShowDebug)
            {
                Debug.Log($"-Set mesh data: {EditorApplication.timeSinceStartup - time:F6}");
            }
#endif
        }

        private void ManageVertexColor(Color[] colors, int vertCount)
        {
            if (!VertexPainterData.OverridenColors)
            {
                LakeVertexColorGenerator.GenerateVertexColor(colors, vertCount, this);
            }
        }

        private void ManageFlowmap(List<Vector4> colorsFlowMap, int vertCount, List<int> indices)
        {
            if (VertexPainterData.OverridenFlow)
            {
                while (colorsFlowMap.Count < vertCount) colorsFlowMap.Add(new Vector4(1, 1, 1, 1));

                while (colorsFlowMap.Count > vertCount) colorsFlowMap.RemoveAt(colorsFlowMap.Count - 1);
            }
            else
            {
                LakeFlowmapGenerator.GenerateAutomaticFlowmap(colorsFlowMap, vertCount, indices, this);
            }
        }


        private Color[] GetMeshVertexColors(int vertCount)
        {
            Color[] colors;
            if (currentMesh != null && currentMesh.colors != null && VertexPainterData.OverridenColors)
            {
                if (currentMesh.colors.Length == vertCount)
                    colors = currentMesh.colors;
                else
                {
                    Color[] oldColors = currentMesh.colors;
                    colors = new Color[vertCount];
                    for (int i = 0; i < oldColors.Length && i < colors.Length; i++)
                    {
                        colors[i] = oldColors[i];
                    }
                }
            }
            else
                colors = new Color[vertCount];

            return colors;
        }

        private void GetMeshColorsFlowmap(List<Vector4> colorsFlowMap)
        {
            if (currentMesh != null && currentMesh.uv4 != null && VertexPainterData.OverridenFlow)
            {
                currentMesh.GetUVs(3, colorsFlowMap);
            }
        }

        private void GetMeshVertexData(List<Vector4> vertexData)
        {
            if (currentMesh != null)
            {
                currentMesh.GetUVs(4, vertexData);
            }
        }

        private void ManageMeshParts(bool quick)
        {
            if (!quick)
            {
                if (generateMeshParts)
                    MeshPartGenerator.GenerateMeshParts(this);
                else if (GenerateLod)
                {
                    meshPartsCount = 1;
                    MeshPartGenerator.GenerateMeshParts(this);
                }
                else
                    foreach (Transform item in meshesPartTransforms)
                        if (item != null)
                            DestroyImmediate(item.gameObject);
            }
            else
                foreach (Transform item in meshesPartTransforms)
                    if (item != null)
                        DestroyImmediate(item.gameObject);
        }

        private void CheckMeshRenderer()
        {
            MeshRenderer = gameObject.GetComponent<MeshRenderer>();
            if (MeshRenderer == null) return;

            MeshRenderer.enabled = true;
            MeshRenderer.receiveShadows = BaseProfile.receiveShadows;
            MeshRenderer.shadowCastingMode = BaseProfile.shadowCastingMode;
        }

        private void LockHeight()
        {
            if (!lockHeight) return;

            for (int i = 1; i < NmSpline.MainControlPoints.Count; i++)
            {
                Vector4 vec = NmSpline.MainControlPoints[i].position;
                vec.y = NmSpline.MainControlPoints[0].position.y;
                NmSpline.MainControlPoints[i].position = vec;
            }
        }


        public void GenerateBaseProfile()
        {
            //Debug.Log("GenerateBaseProfile");

            BaseProfile = ScriptableObject.CreateInstance<LakePolygonProfile>();

            BaseProfile.lakeMaterial = MeshRenderer.sharedMaterial;
        }

        #region Obsolete

        public void MoveControlPointsToMainControlPoints()
        {
#pragma warning disable 612, 618

            if (points.Count > 0 && NmSpline.MainControlPoints.Count == 0)
            {
                Debug.Log("Move Control Points To Main Control Points");
                nmSpline = GetComponentInParent<NmSpline>();
                nmSpline.SetData(snapToTerrain ? 1 : 0, 1, true, false, false, true, false, false, false);

                for (int i = 0; i < points.Count; i++)
                {
                    RamControlPoint ramControlPoint = new RamControlPoint(points[i]);
                    NmSpline.MainControlPoints.Add(ramControlPoint);
                }
            }

            if (NmSpline.MainControlPoints.Count > 0)
            {
                points.Clear();
            }
#pragma warning restore 612, 618
        }

        #endregion

        public VertexPainterData GetVertexPainterData()
        {
            return VertexPainterData;
        }
    }
}