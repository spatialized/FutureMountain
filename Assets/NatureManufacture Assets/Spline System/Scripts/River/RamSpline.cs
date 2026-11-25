using UnityEngine.Events;

namespace NatureManufacture.RAM
{
#if VEGETATION_STUDIO
using AwesomeTechnologies;
using AwesomeTechnologies.VegetationStudio;
#endif
#if VEGETATION_STUDIO_PRO
using AwesomeTechnologies.VegetationSystem.Biomes;
#endif
    using System;
    using System.Collections.Generic;
    using UnityEngine;
    using UnityEngine.Rendering;
    using UnityEngine.Serialization;
#if UNITY_EDITOR
    using UnityEditor;
#endif

    [SelectionBase]
    [RequireComponent(typeof(NmSpline))]
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(NmSplineDataNoiseStrength))]
    public class RamSpline : MonoBehaviour, IVertexPaintable, ITerrainPainterGetData, IGenerationEvents
    {
        #region Profiles

        public SplineProfile currentProfile;
        [SerializeField] private SplineProfile _baseProfile;
        public SplineProfile oldProfile;

        #endregion

        public int toolbarInt;
        public bool generateOnStart;
        public GameObject meshGo;

        #region ChildSplines

        public List<RamSpline> beginningChildSplines = new();
        public List<RamSpline> endingChildSplines = new();
        public RamSpline beginningSpline;
        public RamSpline endingSpline;
        public int beginningConnectionID;
        public int endingConnectionID;
        public float beginningMinWidth = 0.5f;
        public float beginningMaxWidth = 1f;
        public float endingMinWidth = 0.5f;
        public float endingMaxWidth = 1f;

        #endregion

        #region obsolete

        //Old Control Points
        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Vector4> controlPoints = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Quaternion> controlPointsRotations = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Quaternion> controlPointsOrientation = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Vector3> controlPointsUp = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<Vector3> controlPointsDown = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<float> controlPointsSnap = new();

        [Obsolete("This is an obsolete field moved to Main Control Points")]
        public List<AnimationCurve> controlPointsMeshCurves = new();

        #endregion


        #region GeneratedMeshData

        public MeshFilter meshFilter;

        [Header("Vertices data")] public List<Vector3> verticesBeginning = new();
        public List<Vector3> verticesEnding = new();

        public List<Vector3> normalsBeginning = new();

        public List<Vector3> normalsEnding = new();

        public List<Vector3> verticeDirection = new();

        public float length;
        public float fullLength;
        [FormerlySerializedAs("uv3Length")] public float uv2Length;
        [FormerlySerializedAs("uv3Final")] public float uv2Final;

        public float minMaxWidth;
        public float uvWidth;

        public float uvBeginning;
        public bool uvScaleOverride;

        #endregion

        //Part meshes

        #region PartMesh

        public bool generateMeshParts;
        public int meshPartsCount = 3;
        public List<Transform> meshesPartTransforms = new();

        #endregion


        #region Systems

        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }

        [SerializeField] private RamMeshEvent onGeneratedMeshSpline;
        private RamSimulationGenerator _ramSimulationGenerator;
        private RamVegetationStudioIntegration _ramVegetationStudioIntegration;
        [SerializeField] private NmSpline nmSpline;
        [SerializeField] private RamTerrainManager ramTerrainManager;
        [SerializeField] private RamVertexColors ramVertexColors;
        [SerializeField] private VertexPainterData vertexPainterData = new(true);


        [SerializeField] private RamSplineConnection beginningSplineConnection = new() { BlendOffset = 2, BlendDistance = 2, BlendStrength = 0.5f };
        [SerializeField] private RamSplineConnection endingSplineConnection = new() { BlendOffset = 2, BlendDistance = 2, BlendStrength = 0.5f };


        private bool _duplicate;
        private MeshCollider meshCollider;


        public NmSpline NmSpline
        {
            get
            {
                if (nmSpline != null && nmSpline.gameObject == gameObject)
                    return nmSpline;

                //Debug.Log($"base {name}");

                if (BaseProfile == null)
                    GenerateBaseProfile();
                else
                {
                    BaseProfile = ScriptableObject.CreateInstance<SplineProfile>();
                    BaseProfile.SetProfileData(BaseProfile);
                }

                nmSpline = GetComponentInParent<NmSpline>();
                nmSpline.SetData(BaseProfile.snapToTerrain ? 1 : 0, BaseProfile.width);
                MoveControlPointsToMainControlPoints();
                GenerateSpline();


                return nmSpline;
            }
            set => nmSpline = value;
        }

        public RamSimulationGenerator RamSimulationGenerator => _ramSimulationGenerator ??= new RamSimulationGenerator(this);
        public RamVegetationStudioIntegration RamVegetationStudioIntegration => _ramVegetationStudioIntegration ??= new RamVegetationStudioIntegration(this);

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

        public RamVertexColors RamVertexColors => ramVertexColors ??= new RamVertexColors(this);

        public TerrainPainterData PainterData
        {
            get => _baseProfile.PainterData;
            set => _baseProfile.PainterData = value;
        }

        public VertexPainterData VertexPainterData => vertexPainterData ??= new VertexPainterData(true);

        public SplineProfile BaseProfile
        {
            get
            {
                if (_baseProfile == null)
                    GenerateBaseProfile();
                return _baseProfile;
            }
            set => _baseProfile = value;
        }

        public RamMeshEvent OnGeneratedMeshSpline
        {
            get => onGeneratedMeshSpline;
            set => onGeneratedMeshSpline = value;
        }


        public RamSplineConnection EndingSplineConnection
        {
            get => endingSplineConnection;
            set => endingSplineConnection = value;
        }

        public RamSplineConnection BeginningSplineConnection
        {
            get => beginningSplineConnection;
            set => beginningSplineConnection = value;
        }

        #endregion

        private void Start()
        {
            if (generateOnStart)
                GenerateSpline();
        }

        /// <summary>
        /// Creates spline
        /// </summary>
        /// <param name="splineMaterial">Material of the spline</param>
        /// <param name="positions">Positions to add to the spline</param>
        /// <param name="name">Spline name</param>
        /// <param name="snapToTerrain">Snap spline to terrain</param>
        /// <returns></returns>
        public static RamSpline CreateSpline(Material splineMaterial = null, List<Vector4> positions = null,
            string name = "RamSpline", bool snapToTerrain = false)
        {
            var gameObject = new GameObject(name)
            {
                layer = LayerMask.NameToLayer("Water")
            };
            var spline = gameObject.AddComponent<RamSpline>();

            spline.BaseProfile = ScriptableObject.CreateInstance<SplineProfile>();
            spline.BaseProfile.snapToTerrain = snapToTerrain;

            spline.nmSpline = spline.GetComponentInParent<NmSpline>();
            spline.nmSpline.SetData(spline.BaseProfile.snapToTerrain ? 1 : 0, spline.BaseProfile.width);
#if UNITY_EDITOR
            var flags = StaticEditorFlags.ContributeGI;

            GameObjectUtility.SetStaticEditorFlags(gameObject, flags);
#endif

            var meshRenderer = gameObject.AddComponent<MeshRenderer>();
            meshRenderer.receiveShadows = true;
            meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
#if UNITY_EDITOR
            meshRenderer.receiveGI = ReceiveGI.Lightmaps;
#endif

            if (splineMaterial != null)
                meshRenderer.sharedMaterial = splineMaterial;

            if (positions != null)
                foreach (Vector4 t in positions)
                    spline.NmSpline.AddPoint(t, spline.BaseProfile.snapToTerrain, spline.BaseProfile.width);

            spline.RamTerrainManager.NmSpline = spline.NmSpline;
#if UNITY_EDITOR
            Undo.RegisterCreatedObjectUndo(gameObject, "Create river");
#endif

            return spline;
        }

        public RamSpline CreateSecondSpline(Material ramMaterial, List<Vector4> ramPoints, string suffix, float splineWidth)
        {
            var newRam = CreateSpline(ramMaterial, ramPoints, name + suffix, BaseProfile.snapToTerrain);

            if (currentProfile != null)
            {
                newRam.currentProfile = currentProfile;
                newRam.oldProfile = newRam.currentProfile;
            }

            newRam.BaseProfile.SetProfileData(BaseProfile);
            newRam.BaseProfile.width = splineWidth;
            newRam.BaseProfile.uvFixedWidth = BaseProfile.uvFixedWidth * 0.5f;
            for (int i = 0; i < newRam.NmSpline.MainControlPoints.Count; i++) newRam.NmSpline.MainControlPoints[i].meshCurve = new AnimationCurve(BaseProfile.meshCurve.keys);


            return newRam;
        }

        public void ChangePivot(Vector3 center)
        {
            var transform1 = transform;
            Vector3 position = transform1.position + center;
            transform1.position = position;
            for (int i = 0; i < NmSpline.MainControlPoints.Count; i++)
            {
                Vector4 vec = NmSpline.MainControlPoints[i].position;
                vec.x -= center.x;
                vec.y -= center.y;
                vec.z -= center.z;
                NmSpline.MainControlPoints[i].position = vec;
            }

            GenerateSpline();
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
                SplineProfile tempProfile = BaseProfile;
                BaseProfile = ScriptableObject.CreateInstance<SplineProfile>();

                BaseProfile.SetProfileData(tempProfile);
            }

            RamTerrainManager oldRamTerrainManager = ramTerrainManager;
            ramTerrainManager = new RamTerrainManager(NmSpline, this, oldRamTerrainManager);
        }

        public Transform GetTransform => transform;

        public void GenerateForTerrain()
        {
            GenerateSpline();
        }


        public void GenerateSpline(List<RamSpline> generatedSplines = null)
        {
            OnGenerationStarted?.Invoke();
            if (BaseProfile == null)
            {
                GenerateBaseProfile();
            }

            if (RamTerrainManager.BasePainterData != null)
                RamTerrainManager.BasePainterData.TerrainsUnder.Clear();

            MoveControlPointsToMainControlPoints();


            generatedSplines ??= new List<RamSpline>();

            if (beginningSpline != null && beginningSpline.endingSpline != null)
            {
                Debug.LogError("River can't be ending spline and have beginning spline");
                return;
            }

            if (endingSpline != null && endingSpline.beginningSpline != null)
            {
                Debug.LogError("River can't be beginning spline and have ending spline");
                return;
            }

            if (beginningSpline) RamSplineConnection.GenerateBeginningPointsFromParent(this);

            if (endingSpline) RamSplineConnection.GenerateEndingPointsFromParent(this);

            if (BeginningSplineConnection.Spline != null)
                RamSplineConnection.SetBlendPosition(this, BeginningSplineConnection, 0);

            if (EndingSplineConnection.Spline != null)
                RamSplineConnection.SetBlendPosition(this, EndingSplineConnection, NmSpline.MainControlPoints.Count - 1);


            Mesh mesh;

            if (meshFilter == null || _duplicate)
            {
                _duplicate = false;
                meshFilter = GetComponent<MeshFilter>();


                mesh = new Mesh();
            }
            else if (meshFilter.sharedMesh != null)
            {
                mesh = Instantiate(meshFilter.sharedMesh);
            }
            else
            {
                mesh = new Mesh();
            }

            mesh.name = $"mesh {gameObject.name}";


            //Debug.Log($"splinePrepared {name}");
            bool splinePrepared = nmSpline.PrepareSpline();


            if (!splinePrepared)
            {
                mesh.Clear();

                meshFilter.sharedMesh = mesh;
                return;
            }


            verticesBeginning.Clear();
            verticesEnding.Clear();
            normalsBeginning.Clear();
            normalsEnding.Clear();

            if (beginningSpline != null && beginningSpline.NmSpline.MainControlPoints.Count > 0) NmSpline.MainControlPoints[0].rotation = Quaternion.identity;
            if (endingSpline != null && endingSpline.NmSpline.MainControlPoints.Count > 0) NmSpline.MainControlPoints[^1].rotation = Quaternion.identity;


            NmSpline.CalculateCatmullRomSideSplines();

            if (beginningSpline != null && beginningSpline.NmSpline.MainControlPoints.Count > 0)
                NmSpline.MainControlPoints[0].rotation = Quaternion.Inverse(NmSpline.MainControlPoints[0].orientation) *
                                                         beginningSpline.NmSpline.MainControlPoints[
                                                             ^1].orientation;

            if (endingSpline != null && endingSpline.NmSpline.MainControlPoints.Count > 0)
                NmSpline.MainControlPoints[^1].rotation =
                    Quaternion.Inverse(NmSpline.MainControlPoints[^1].orientation) *
                    endingSpline.NmSpline.MainControlPoints[0].orientation;

            NmSpline.GenerateFullSpline(BaseProfile.triangleDensity);

            //Debug.Log($"GenerateMesh {name}");
            GenerateMesh(ref mesh);

            generatedSplines.Add(this);

            List<RamSpline> splinesToRemove = new();
            foreach (RamSpline item in beginningChildSplines)
            {
                if (item == null) continue;


                if (item.beginningSpline != this && item.endingSpline != this)
                {
                    splinesToRemove.Add(item);
                    continue;
                }

                if (!generatedSplines.Contains(item))
                    item.GenerateSpline(generatedSplines);
            }

            foreach (var item in splinesToRemove) beginningChildSplines.Remove(item);

            splinesToRemove.Clear();
            foreach (RamSpline item in endingChildSplines)
            {
                if (item == null) continue;

                if (item.beginningSpline != this && item.endingSpline != this)
                {
                    splinesToRemove.Add(item);
                    continue;
                }

                if (!generatedSplines.Contains(item))
                    item.GenerateSpline(generatedSplines);
            }

            //Debug.Log($"splinesToRemove {name}");
            foreach (var item in splinesToRemove) endingChildSplines.Remove(item);


#if VEGETATION_STUDIO_PRO
            RamVegetationStudioIntegration.RegenerateBiomeMask();
#endif

#if VEGETATION_STUDIO
            RamVegetationStudioIntegration.RegenerateVegetationMask();
#endif


            OnGenerationEnded?.Invoke();
        }

        private void CheckMeshColliderMesh(Mesh mesh, bool turnOnMeshCollider)
        {
            if (meshCollider == null) return;

            meshCollider.sharedMesh = mesh;
            meshCollider.enabled = turnOnMeshCollider;
        }

        /// <summary>
        /// Tranforming flow map from different spaces
        /// </summary>
        /// <param name="flowDirection"></param>
        /// <param name="id"></param>
        /// <param name="meshFilter"></param>
        /// <returns></returns>
        public static Vector2 TransformFlowMap(Vector2 flowDirection, int id, MeshFilter meshFilter)
        {
            RamSpline spline = meshFilter.GetComponent<RamSpline>();

            Vector2 vert = -new Vector2(spline.verticeDirection[id].x, spline.verticeDirection[id].z).normalized;
            Vector2 flow = new Vector2(-flowDirection.x, flowDirection.y);

            Vector2 newFlow = Quaternion.Euler(0, 0, Vector2.SignedAngle(new Vector2(0, 1), vert)) * flow;


            if (spline._baseProfile.uvRotation)
            {
                newFlow.y = -newFlow.y;
            }

            //Debug.Log($"{flowDirection} {id}");

            return newFlow;
            // return flowDirection;
        }

        private void GenerateMesh(ref Mesh mesh)
        {
            //Debug.Log($"GenerateMesh  {name} {NmSpline.Points.Count}");
            if (NmSpline.Points.Count < 2)
                return;

            for (int i = 0; i < beginningChildSplines.Count; i++)
                if (beginningChildSplines[i] == null)
                    beginningChildSplines.RemoveAt(i--);

            for (int i = 0; i < endingChildSplines.Count; i++)
                if (endingChildSplines[i] == null)
                    endingChildSplines.RemoveAt(i--);

            var meshRenderer = gameObject.GetComponent<MeshRenderer>();
            if (meshRenderer != null)
            {
                meshRenderer.receiveShadows = BaseProfile.receiveShadows;
                meshRenderer.shadowCastingMode = BaseProfile.shadowCastingMode;
            }

            meshCollider = GetComponent<MeshCollider>();

            foreach (Transform item in meshesPartTransforms)
                if (item != null)
                {
                    if (Application.isPlaying)
                        Destroy(item.gameObject);
                    else
                        DestroyImmediate(item.gameObject);
                    if (item != null)
                        Destroy(item.gameObject);
                }


            int segments = NmSpline.Points.Count - 1;

            int vertCount = 0; //vertsInShape * edgeLoops;

            for (int i = 0; i < NmSpline.PointsDown.Count; i++)
            {
                vertCount += NmSpline.Points[i].Density * BaseProfile.vertsInShape;
            }


            List<int> triangleIndices = new();
            Vector3[] vertices = new Vector3[vertCount];
            Vector3[] normals = new Vector3[vertCount];
            Vector4[] uvs = new Vector4[vertCount];
            Vector2[] uvs1 = new Vector2[vertCount];
            Vector2[] uvs2 = new Vector2[vertCount];
            Vector2[] uvs3 = new Vector2[vertCount];
            List<Vector4> vertexData = new();

            Color[] colors = mesh.colors;
            List<Vector2> colorsFlowMap = new();

            mesh.GetUVs(3, colorsFlowMap);
            mesh.GetUVs(4, vertexData);


            if (colorsFlowMap.Count != vertCount)
                colorsFlowMap.Clear();

            colors = RamVertexColors.CheckColors(colors, vertCount);

            length = 0;

            uv2Length = 0;

            if (beginningSpline != null)
                length = beginningSpline.length;
            else if (beginningChildSplines != null && beginningChildSplines.Count > 0 && beginningChildSplines[0] != null)
            {
                length = beginningChildSplines[0].length;
            }


            minMaxWidth = 1;
            uvWidth = 1;
            uvBeginning = 0;

            SetExtremeWidthsLengths();

            CalculateFullLength();

            float roundEnding = Mathf.Round(fullLength);
            if (roundEnding == 0)
                roundEnding = 1;

            int offsetVert = 0;
            float normalChange = 1;
            // float lengthTest = 0;


            //List<RamVertexColors.LakeBlend> lakeBlends = RamVertexColors.GetLakesBlend(meshRenderer);

            float distanceToLake = Vector3.Distance(NmSpline.MainControlPoints[^1].position, NmSpline.MainControlPoints[^2].position);
            distanceToLake /= BaseProfile.triangleDensity * NmSpline.MainControlPoints[^2].additionalDensityU;


            int endingBlendDistance = (int)(EndingSplineConnection.BlendStrength * EndingSplineConnection.BlendDistance / distanceToLake);

            distanceToLake = Vector3.Distance(NmSpline.MainControlPoints[0].position, NmSpline.MainControlPoints[1].position);
            distanceToLake /= BaseProfile.triangleDensity * NmSpline.MainControlPoints[0].additionalDensityU;


            int beginningBlendDistance = (int)(BeginningSplineConnection.BlendStrength * BeginningSplineConnection.BlendDistance / distanceToLake);


            //Debug.Log($"blendDistance {blendDistance} distanceToLake {distanceToLake}");

            bool turnOnMeshCollider = TurnOffMeshCollider();

            for (int i = 0; i < NmSpline.PointsDown.Count; i++)
            {
                float widthPoint = _baseProfile.uvUseFixedTile ? Mathf.Lerp(NmSpline.Points[i].Width, _baseProfile.width, _baseProfile.uvFixedTileLerp) : NmSpline.Points[i].Width;


                if (i > 0)
                {
                    length += (uvWidth * Vector3.Distance(NmSpline.Points[i].Position, NmSpline.Points[i - 1].Position) / (BaseProfile.uvScale * widthPoint))
                        / fullLength * roundEnding;

                    // lengthTest += uvWidth * Vector3.Distance(NmSpline.Points[i].Position, NmSpline.Points[i - 1].Position) / (BaseProfile.uvScale * widthPoint);


                    normalChange = (Mathf.Clamp(NmSpline.Points[i].Normal.y, 0.1f, 1) * BaseProfile.meshFlowSpeed);
                    uv2Length += Vector3.Distance(NmSpline.Points[i].Position, NmSpline.Points[i - 1].Position) * normalChange;
                }

                var dataNoiseStrength = NmSpline.GetData<NmSplineDataNoiseStrength>();

                int verticeWidthCount = BaseProfile.vertsInShape * NmSpline.Points[i].Density;

                for (int j = 0; j < verticeWidthCount; j++)
                {
                    int id = offsetVert;
                    bool vertexChange = false;

                    float pos = GetVerticePosition(j, i);

                    if (i == 0 && beginningSpline != null && beginningSpline.verticesBeginning is { Count: > 0 } &&
                        beginningSpline.normalsEnding is { Count: > 0 })
                    {
                        GenerateBeginningVertices(vertices, id, j, normals);
                    }
                    else if (i == NmSpline.PointsDown.Count - 1 && endingSpline != null && endingSpline.verticesBeginning is { Count: > 0 } &&
                             endingSpline.normalsBeginning is { Count: > 0 })
                    {
                        GenerateEndingVertices(vertices, id, j, normals);
                    }
                    else
                    {
                        GenerateSplineVertices(vertices, id, i, pos, normals);
                        vertexChange = true;
                    }


                    SetNormals(normals, id, i);

                    if (vertexChange)
                        VertexPaintHeight.ChangeSingleVertexPosition(vertices, normals, vertexData, BaseProfile.vertexPainterNoiseData, id, transform.position, dataNoiseStrength.GetPointData(i));

                    GenerateUvs(j, pos, normals, id, vertices, i, uvs, uvs1, uvs2, uvs3, colorsFlowMap);

                    SetExtremeVertices(i, vertices, id);

                    RamVertexColors.ManageVertexColor(colors, normals, id);

                    ConnectionBlendColors(colors, id, i, j, verticeWidthCount, beginningBlendDistance, endingBlendDistance);


                    offsetVert++;
                }
            }


            GenerateTriangles(segments, triangleIndices);

            GenerateVerticeDirection(segments, vertices);
            //GenerateVerticeDirection(vertices);


            mesh.Clear();
            mesh.vertices = vertices;
            mesh.normals = normals;
            mesh.SetUVs(0, uvs);
            mesh.SetUVs(1, uvs1);
            mesh.SetUVs(2, uvs2);
            mesh.SetUVs(3, colorsFlowMap);
            mesh.SetUVs(4, vertexData);
            mesh.SetTriangles(triangleIndices, 0);
            mesh.colors = colors;


            FixNormalAfterVertex(mesh, vertices);


            //LightningUtility.UnwrapLightning(mesh);

            meshFilter.mesh = mesh;
            GetComponent<MeshRenderer>().enabled = true;


            if (generateMeshParts)
            {
                RamMeshPartGenerator ramMeshPartGenerator = new RamMeshPartGenerator(this, mesh);
                ramMeshPartGenerator.GenerateMeshParts();
            }


            OnGeneratedMeshSpline?.Invoke(mesh);

            CheckMeshColliderMesh(mesh, turnOnMeshCollider);
        }

        private bool TurnOffMeshCollider()
        {
            if (meshCollider == null || !meshCollider.enabled) return false;

            meshCollider.enabled = false;

            return true;
        }

        private void ConnectionBlendColors(Color[] colors, int id, int row, int column, int columnCount, int beginningBlendDistance, int endingBlendDistance)
        {
            float lengthBlend = 1;
            float widthBlend = 1;


            if (row >= NmSpline.PointsDown.Count - endingBlendDistance &&
                EndingSplineConnection.ConnectionType == RamSplineConnection.ConnectionTypeEnum.Alpha) //EndingSplineConnection.Spline != null && EndingSplineConnection.Spline.Points.Count > 0)
            {
                lengthBlend = EndingSplineConnection.BlendCurve.Evaluate((NmSpline.PointsDown.Count - row) / (float)endingBlendDistance);
                widthBlend = EndingSplineConnection.SideBlendCurve.Evaluate(column / (float)(columnCount - 1));
                colors[id].a = widthBlend * lengthBlend;
            }

            if (row <= beginningBlendDistance &&
                BeginningSplineConnection.ConnectionType == RamSplineConnection.ConnectionTypeEnum.Alpha) // BeginningSplineConnection.Spline != null && BeginningSplineConnection.Spline.Points.Count > 0)
            {
                lengthBlend = BeginningSplineConnection.BlendCurve.Evaluate(row / (float)beginningBlendDistance);
                widthBlend = BeginningSplineConnection.SideBlendCurve.Evaluate(column / (float)(columnCount - 1));
                colors[id].a = widthBlend * lengthBlend;
            }
        }

        private void FixNormalAfterVertex(Mesh mesh, Vector3[] vertices)
        {
            if (!BaseProfile.normalFromRaycast)
                mesh.RecalculateNormals();
            Vector3[] normals = mesh.normals;


            int offsetVert = 0;
            for (int i = 0; i < NmSpline.PointsDown.Count; i++)
            {
                int verticeWidthCount = BaseProfile.vertsInShape * NmSpline.Points[i].Density;
                for (int j = 0; j < verticeWidthCount; j++)
                {
                    int id = offsetVert;

                    if (i == 0 && beginningSpline != null && beginningSpline.verticesBeginning is { Count: > 0 } &&
                        beginningSpline.normalsEnding is { Count: > 0 })
                    {
                        GenerateBeginningVertices(vertices, id, j, normals, true);
                    }
                    else if (i == NmSpline.PointsDown.Count - 1 && endingSpline != null && endingSpline.verticesBeginning is { Count: > 0 } &&
                             endingSpline.normalsBeginning is { Count: > 0 })
                    {
                        GenerateEndingVertices(vertices, id, j, normals, true);
                    }


                    SetExtremeNormals(normals, id, i);

                    offsetVert++;
                }
            }


            mesh.vertices = vertices;

            if (!BaseProfile.normalFromRaycast)
                mesh.normals = normals;


            mesh.RecalculateTangents();
        }


        private void GenerateVerticeDirection(int segments, Vector3[] vertices)
        {
            List<Vector3> newVerticeDirection = new();

            Vector3 direction;
            int offset = 0;
            for (int i = 0; i < segments; i++)
            {
                int vertsCount = BaseProfile.vertsInShape * NmSpline.Points[i].Density;
                int vertsCountNext = BaseProfile.vertsInShape * NmSpline.Points[i + 1].Density;


                if (vertsCount < vertsCountNext)
                {
                    int difference = vertsCountNext / vertsCount;


                    for (int l = 0; l < vertsCount; l += 1)
                    {
                        int a = offset + l;
                        int b = offset + vertsCount + (l) * difference;

                        direction = (vertices[b] - vertices[a]).normalized;
                        newVerticeDirection.Add(direction);
                        // Debug.DrawRay(transform.TransformPoint(vertices[a])+Vector3.up*0.1f, direction*0.1f, Color.blue, 1);

                        //Debug.DrawLine(transform.TransformPoint( vertices[a])+Vector3.up*0.1f, transform.TransformPoint( vertices[b]), Color.magenta, 1);
                    }
                }
                else if (vertsCount > vertsCountNext)
                {
                    int difference = vertsCount / vertsCountNext;

                    for (int l = 0; l < vertsCount; l += 1)
                    {
                        int a = offset + l;
                        int b = offset + vertsCount + l / difference;


                        direction = (vertices[b] - vertices[a]).normalized;
                        newVerticeDirection.Add(direction);
                        // Debug.DrawRay(transform.TransformPoint(vertices[a])+Vector3.up*0.1f, direction*0.1f, Color.yellow, 1);

                        // Debug.DrawLine(transform.TransformPoint( vertices[a])+Vector3.up*0.1f, transform.TransformPoint( vertices[b]), Color.yellow, 1);
                    }
                }
                else
                {
                    for (int l = 0; l < vertsCount; l += 1)
                    {
                        int a = offset + l;
                        int b = offset + l + vertsCount;

                        // Debug.DrawLine(transform.TransformPoint( vertices[a])+Vector3.up*0.1f, transform.TransformPoint( vertices[b]), Color.red, 1);
                        direction = (vertices[b] - vertices[a]).normalized;
                        newVerticeDirection.Add(direction);
                        // Debug.DrawRay(transform.TransformPoint(vertices[a])+Vector3.up*0.1f, direction*0.1f, Color.red, 1);
                    }
                }

                offset += vertsCount;
            }


            int verticesLeft = vertices.Length - newVerticeDirection.Count;
            Vector3 last = newVerticeDirection[^1];
            for (int i = 0; i < verticesLeft; i++)
            {
                newVerticeDirection.Add(last);
            }

            verticeDirection.Clear();
            verticeDirection.AddRange(newVerticeDirection);
        }


        private void GenerateTriangles(int segments, List<int> triangleIndices)
        {
            int offset = 0;
            for (int i = 0; i < segments; i++)
            {
                int vertsCount = BaseProfile.vertsInShape * NmSpline.Points[i].Density;
                int vertsCountNext = BaseProfile.vertsInShape * NmSpline.Points[i + 1].Density;


                if (vertsCount < vertsCountNext)
                {
                    int difference = vertsCountNext / vertsCount;

                    for (int l = 0; l < vertsCountNext - 1; l += 1)
                    {
                        int a = offset + l / difference;
                        int b = offset + vertsCount + l;
                        int c = offset + vertsCount + l + 1;


                        triangleIndices.Add(a);
                        triangleIndices.Add(b);
                        triangleIndices.Add(c);
                    }

                    for (int l = 0; l < vertsCount - 1; l += 1)
                    {
                        int a = offset + l;
                        int c = offset + l + 1;
                        int b = offset + vertsCount + (l + 1) * difference;


                        triangleIndices.Add(a);
                        triangleIndices.Add(b);
                        triangleIndices.Add(c);
                    }
                }
                else if (vertsCount > vertsCountNext)
                {
                    int difference = vertsCount / vertsCountNext;

                    for (int l = 0; l < vertsCountNext - 1; l += 1)
                    {
                        int a = offset + (l + 1) * difference;
                        int b = offset + vertsCount + l;
                        int c = offset + vertsCount + l + 1;


                        triangleIndices.Add(a);
                        triangleIndices.Add(b);
                        triangleIndices.Add(c);
                    }

                    for (int l = 0; l < vertsCount - 1; l += 1)
                    {
                        int a = offset + l;
                        int c = offset + +l + 1;
                        int b = offset + vertsCount + l / difference;


                        triangleIndices.Add(a);
                        triangleIndices.Add(b);
                        triangleIndices.Add(c);
                    }
                }
                else
                {
                    for (int l = 0; l < vertsCount - 1; l += 1)
                    {
                        int a = offset + l;
                        int b = offset + l + vertsCount;
                        int c = offset + l + 1 + vertsCount;
                        int d = offset + l + 1;


                        triangleIndices.Add(a);
                        triangleIndices.Add(b);
                        triangleIndices.Add(c);

                        triangleIndices.Add(c);
                        triangleIndices.Add(d);
                        triangleIndices.Add(a);
                    }
                }

                offset += vertsCount;
            }
        }

        private float GetVerticePosition(int j, int i)
        {
            float pos = j / (float)(BaseProfile.vertsInShape * NmSpline.Points[i].Density - 1);

            if (pos < 0.5f)
                pos *= BaseProfile.minVal * 0.01f * 2;
            else
                pos = ((pos - 0.5f) * (1 - BaseProfile.maxVal * 0.01f) + 0.5f * BaseProfile.maxVal * 0.01f) * 2;

            return pos;
        }

        private void CalculateFullLength()
        {
            fullLength = 0;
            for (int i = 0; i < NmSpline.Points.Count; i++)
            {
                float widthPoint = _baseProfile.uvUseFixedTile ? Mathf.Lerp(NmSpline.Points[i].Width, _baseProfile.uvFixedWidth, _baseProfile.uvFixedTileLerp) : NmSpline.Points[i].Width;
                if (i > 0)
                {
                    fullLength += uvWidth * Vector3.Distance(NmSpline.Points[i].Position, NmSpline.Points[i - 1].Position)
                                  / (BaseProfile.uvScale * widthPoint);
                }
            }
        }

        private void SetExtremeWidthsLengths()
        {
            if (beginningSpline != null)
            {
                minMaxWidth = beginningMaxWidth - beginningMinWidth;

                uvWidth = minMaxWidth * beginningSpline.uvWidth;

                uvBeginning = beginningSpline.uvWidth * beginningMinWidth + beginningSpline.uvBeginning;
            }
            else if (endingSpline != null)
            {
                minMaxWidth = endingMaxWidth - endingMinWidth;

                uvWidth = minMaxWidth * endingSpline.uvWidth;

                uvBeginning = endingSpline.uvWidth * endingMinWidth + endingSpline.uvBeginning;
            }
        }

        private void GenerateUvs(int j, float pos, IList<Vector3> normals, int id, IList<Vector3> vertices, int i, IList<Vector4> uvs, IList<Vector2> uvs1, IList<Vector2> uvs2, IList<Vector2> uvs3,
            IList<Vector2> colorsFlowMap)
        {
            float u = 0;
            float u1 = 0;
            float u2 = 0;

            if (j > 0)
            {
                u += pos * uvWidth;
                u1 += pos;
                u2 = pos;
            }

            if (beginningSpline != null || endingSpline != null) u += uvBeginning;

            if (_baseProfile.uvUseFixedTile)
                u = Mathf.Lerp(u, u * NmSpline.Points[i].Width / _baseProfile.uvFixedWidth - (NmSpline.Points[i].Width - _baseProfile.uvFixedWidth) / (_baseProfile.uvFixedWidth * 2), _baseProfile.uvFixedTileLerp);

            u = u / BaseProfile.uvScale;


            float uv3U = FlowCalculate(u2, normals[id].y, vertices[id]);
            float uv3V = -(u2 - 0.5f) * 0.01f;

            _baseProfile.flowLerpDistance = _baseProfile.triangleDensity * 2;

            if (beginningChildSplines.Count > 0 && i <= _baseProfile.flowLerpDistance)
            {
                float lerpUv3U = 0;
                float lerpUv3V = 0;
                foreach (RamSpline item in beginningChildSplines)
                {
                    if (item == null)
                        continue;
                    if (Mathf.CeilToInt(item.endingMaxWidth * (BaseProfile.vertsInShape - 1)) >= j &&
                        j >= Mathf.CeilToInt(item.endingMinWidth * (BaseProfile.vertsInShape - 1)))
                    {
                        lerpUv3U = (j - Mathf.CeilToInt(item.endingMinWidth * (BaseProfile.vertsInShape - 1)))
                                   / (float)(Mathf.CeilToInt(item.endingMaxWidth * (BaseProfile.vertsInShape - 1)) -
                                             Mathf.CeilToInt(item.endingMinWidth * (BaseProfile.vertsInShape - 1)));

                        lerpUv3V = -(lerpUv3U - 0.5f) * 0.01f;
                        lerpUv3U = FlowCalculate(lerpUv3U, normals[id].y, vertices[id]);
                    }
                }


                uv3U = Mathf.Lerp(uv3U, lerpUv3U, 1 - i / (float)_baseProfile.flowLerpDistance);
                uv3V = Mathf.Lerp(uv3V, lerpUv3V, 1 - i / (float)_baseProfile.flowLerpDistance);
            }

            if (i >= NmSpline.PointsDown.Count - _baseProfile.flowLerpDistance - 1 && endingChildSplines.Count > 0)
            {
                float lerpUv3U = 0;
                float lerpUv3V = 0;

                foreach (RamSpline item in endingChildSplines)
                {
                    if (item == null)
                        continue;
                    if (Mathf.CeilToInt(item.beginningMaxWidth * (BaseProfile.vertsInShape - 1)) >= j &&
                        j >= Mathf.CeilToInt(item.beginningMinWidth * (BaseProfile.vertsInShape - 1)))
                    {
                        lerpUv3U = (j - Mathf.CeilToInt(item.beginningMinWidth * (BaseProfile.vertsInShape - 1)))
                                   / (float)(Mathf.CeilToInt(item.beginningMaxWidth * (BaseProfile.vertsInShape - 1)) -
                                             Mathf.CeilToInt(item.beginningMinWidth * (BaseProfile.vertsInShape - 1)));

                        lerpUv3V = -(lerpUv3U - 0.5f) * 0.01f;
                        lerpUv3U = FlowCalculate(lerpUv3U, normals[id].y, vertices[id]);
                    }
                }


                uv3U = Mathf.Lerp(uv3U, lerpUv3U, (i - (NmSpline.PointsDown.Count - _baseProfile.flowLerpDistance - 1)) / (float)_baseProfile.flowLerpDistance);
                uv3V = Mathf.Lerp(uv3V, lerpUv3V, (i - (NmSpline.PointsDown.Count - _baseProfile.flowLerpDistance - 1)) / (float)_baseProfile.flowLerpDistance);
            }

            float minParent = float.MaxValue;
            if (beginningSpline != null)
                minParent = beginningSpline.uv2Final;

            foreach (var beginningChildSpline in beginningChildSplines)
            {
                if (beginningChildSpline.uv2Final < minParent)
                    minParent = beginningChildSpline.uv2Final;
            }

            uv2Final = uv2Length;

            if (minParent != float.MaxValue)
                uv2Final += minParent;

            if (BaseProfile.uvRotation)
            {
                if (!BaseProfile.invertUVDirection)
                {
                    uvs[id] = new Vector2(1 - length, u);
                    uvs1[id] = new Vector2(1 - length / fullLength, u1);

                    uvs2[id] = new Vector2(uv2Final, u2);
                    uvs3[id] = new Vector2(uv3U, uv3V);
                }
                else
                {
                    uvs[id] = new Vector2(1 + length, u);
                    uvs1[id] = new Vector2(1 + length / fullLength, u1);
                    uvs2[id] = new Vector2(uv2Final, u2);
                    uvs3[id] = new Vector2(uv3U, uv3V);
                }
            }
            else
            {
                if (!BaseProfile.invertUVDirection)
                {
                    uvs[id] = new Vector2(u, 1 - length);
                    uvs1[id] = new Vector2(u1, 1 - length / fullLength);
                    uvs2[id] = new Vector2(uv2Final, u2);
                    uvs3[id] = new Vector2(uv3V, uv3U);
                }
                else
                {
                    uvs[id] = new Vector2(u, 1 + length);
                    uvs1[id] = new Vector2(u1, 1 + length / fullLength);
                    uvs2[id] = new Vector2(uv2Final, u2);
                    uvs3[id] = new Vector2(uv3V, uv3U);
                }
            }

            if (colorsFlowMap.Count <= id)
                colorsFlowMap.Add(uvs3[id]);
            else if (!VertexPainterData.OverridenFlow)
                colorsFlowMap[id] = uvs3[id];
        }

        private void SetNormals(Vector3[] normals, int id, int i)
        {
            if (!BaseProfile.normalFromRaycast)
            {
                normals[id] = NmSpline.Points[i].Orientation * Vector3.up;
            }
            else
            {
                normals[id] = Vector3.Lerp(NmSpline.Points[i].Orientation * Vector3.up, normals[id], BaseProfile.NormalFromRaycastLerp);

              
            }
        }

        private void SetExtremeNormals(Vector3[] normals, int id, int i)
        {
            if (i == 0)
                normalsBeginning.Add(normals[id]);

            if (i == NmSpline.PointsDown.Count - 1)
                normalsEnding.Add(normals[id]);
        }

        private void SetExtremeVertices(int i, Vector3[] vertices, int id)
        {
            if (i is > 0 and < 5 && beginningSpline != null && beginningSpline.verticesEnding != null)
                vertices[id].y = (vertices[id].y + vertices[id - BaseProfile.vertsInShape].y) * 0.5f;

            if (i == NmSpline.PointsDown.Count - 1 && endingSpline != null && endingSpline.verticesBeginning != null)
                for (int k = 1; k < 5; k++)
                    vertices[id - BaseProfile.vertsInShape * k].y =
                        (vertices[id - BaseProfile.vertsInShape * (k - 1)].y + vertices[id - BaseProfile.vertsInShape * k].y) * 0.5f;


            if (i == 0)
                verticesBeginning.Add(vertices[id]);

            if (i == NmSpline.PointsDown.Count - 1)
                verticesEnding.Add(vertices[id]);
        }

        private void GenerateSplineVertices(Vector3[] vertices, int id, int i, float pos, Vector3[] normals)
        {
            vertices[id] = Vector3.Lerp(NmSpline.PointsDown[i].Position, NmSpline.PointsUp[i].Position, pos);


            //if (normals[id].magnitude != 1)
            //    normals[id].Normalize();

            if (Physics.Raycast(vertices[id] + transform.position + Vector3.up * 5, Vector3.down, out RaycastHit hit, 1000,
                    BaseProfile.snapMask.value, QueryTriggerInteraction.Ignore))
            {
                var checkTerrain = hit.collider.gameObject.GetComponent<Terrain>();
                RamTerrainManager.BasePainterData.AddTerrain(checkTerrain);

                vertices[id] = Vector3.Lerp(vertices[id],
                    hit.point - transform.position + new Vector3(0, 0.1f, 0),
                    (Mathf.Sin(Mathf.PI * NmSpline.Points[i].Snap - Mathf.PI * 0.5f) + 1) * 0.5f);


                if (BaseProfile.normalFromRaycast && BaseProfile.NormalFromRaycastPerVertex)
                {
                    normals[id] = hit.normal.normalized;
                }
            }


            if (BaseProfile.normalFromRaycast && !BaseProfile.NormalFromRaycastPerVertex)
            {
                if (Physics.Raycast(NmSpline.Points[i].Position + transform.position + Vector3.up * 5, Vector3.down, out RaycastHit hit2,
                        1000, BaseProfile.snapMask.value, QueryTriggerInteraction.Ignore))
                    normals[id] = hit2.normal.normalized;
            }


            if (normals[id].magnitude != 1)
                normals[id] = Vector3.up;


            vertices[id] += NmSpline.Points[i].Orientation * Vector3.up * Mathf.Lerp(NmSpline.MainControlPoints[Mathf.FloorToInt(NmSpline.Points[i].LerpValue)].meshCurve.Evaluate(pos), NmSpline
                    .MainControlPoints[Mathf.CeilToInt(NmSpline.Points[i].LerpValue)].meshCurve
                    .Evaluate(pos),
                NmSpline.Points[i].LerpValue - Mathf.Floor(NmSpline.Points[i].LerpValue));
        }

        private void GenerateEndingVertices(Vector3[] vertices, int id, int j, Vector3[] normals, bool normalsOnly = false)
        {
            int pos2 = (int)(endingSpline.BaseProfile.vertsInShape * endingMinWidth);


            if (!normalsOnly)
            {
                vertices[id] =
                    endingSpline.verticesBeginning[
                        Mathf.Clamp(j + pos2, 0, endingSpline.verticesBeginning.Count - 1)] +
                    endingSpline.transform.position - transform.position;
            }
            //Debug.Log($"{id} {vertices.Length} {normals.Length}");

            normals[id] =
                endingSpline.normalsBeginning[
                    Mathf.Clamp(j + pos2, 0, endingSpline.verticesBeginning.Count - 1)];
        }

        private void GenerateBeginningVertices(Vector3[] vertices, int id, int j, Vector3[] normals, bool normalsOnly = false)
        {
            int pos2 = (int)(beginningSpline.BaseProfile.vertsInShape * beginningMinWidth);
            if (!normalsOnly)
            {
                vertices[id] =
                    beginningSpline.verticesEnding[Mathf.Clamp(j + pos2, 0, beginningSpline.verticesEnding.Count - 1)] + beginningSpline.transform.position - transform.position;
            }

            normals[id] = beginningSpline.normalsEnding[Mathf.Clamp(j + pos2, 0, beginningSpline.verticesEnding.Count - 1)];
        }


        public void AddNoiseToWidths()
        {
            for (int i = 0; i < NmSpline.MainControlPoints.Count; i++)
            {
                Vector4 controlPoint = NmSpline.MainControlPoints[i].position;

                controlPoint.w = controlPoint.w +
                                 (BaseProfile.noiseWidth
                                     ? BaseProfile.noiseMultiplierWidth * (Mathf.PerlinNoise(BaseProfile.noiseSizeWidth * i, 0) - 0.5f)
                                     : 0);

                if (controlPoint.w < 0) controlPoint.w = 0;

                NmSpline.MainControlPoints[i].position = controlPoint;
            }
        }

        private float FlowCalculate(float u, float normalY, Vector3 vertice)
        {
            float noise =
                (BaseProfile.noiseFlowMap
                    ? Mathf.PerlinNoise(vertice.x * BaseProfile.noiseSizeXFlowMap, vertice.z * BaseProfile.noiseSizeZFlowMap) *
                    BaseProfile.noiseMultiplierFlowMap - BaseProfile.noiseMultiplierFlowMap * 0.5f
                    : 0) * Mathf.Pow(Mathf.Clamp(normalY, 0, 1), 5);
            return Mathf.Lerp(BaseProfile.flowWaterfall.Evaluate(u), BaseProfile.flowFlat.Evaluate(u) + noise, Mathf.Clamp(normalY, 0, 1));
        }

        #region OldRamObsoleteMover

        public void MoveControlPointsToMainControlPoints()
        {
#pragma warning disable 612, 618

            if (controlPoints.Count > 0 && NmSpline.MainControlPoints.Count == 0)
            {
                nmSpline = GetComponentInParent<NmSpline>();

                nmSpline.SetData(BaseProfile.snapToTerrain ? 1 : 0, BaseProfile.width);

                for (int i = 0; i < controlPoints.Count; i++)
                {
                    RamControlPoint ramControlPoint = new RamControlPoint(controlPoints[i], controlPointsRotations[i],
                        controlPointsOrientation[i], controlPointsSnap[i], controlPointsMeshCurves[i]);
                    NmSpline.MainControlPoints.Add(ramControlPoint);
                }

                controlPoints.Clear();
            }

            if (NmSpline.MainControlPoints.Count > 0)
            {
                controlPoints.Clear();
                controlPointsRotations.Clear();
                controlPointsOrientation.Clear();
                controlPointsSnap.Clear();
                controlPointsMeshCurves.Clear();
            }
#pragma warning restore 612, 618
        }

        public void GenerateBaseProfile()
        {
            BaseProfile = ScriptableObject.CreateInstance<SplineProfile>();
        }

        #endregion

        public VertexPainterData GetVertexPainterData()
        {
            return VertexPainterData;
        }
    }
}