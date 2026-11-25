using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    [RequireComponent(typeof(NmSpline))]
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public class TerrainSpline : MonoBehaviour, ITerrainPainterGetData, IGenerationEvents
    {
        private bool _duplicate;

        [SerializeField] private NmSpline nmSpline;

        [SerializeField] private float triangleDensity = 1;

        [SerializeField] private RamTerrainManager ramTerrainManager;

        [SerializeField] private TerrainPainterData terrainPainterData;
        [field: SerializeField] public MeshFilter MainMeshFilter { get; set; }
        [SerializeField] private Mesh currentMesh;

        [field: SerializeField] public bool LockHeight { get; set; } = true;
        private List<int> indices;
        private Vector3[] vertices;
        private Vector3[] normals;

        [field: SerializeField] public float TriangleSizeByLimit { get; set; }

        [field: SerializeField] public float MaximumTriangleAmount { get; set; } = 500;

        [field: SerializeField] public float MaximumTriangleSize { get; set; } = 50;


        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }

        public TerrainPainterData PainterData
        {
            get => terrainPainterData;
            set => terrainPainterData = value;
        }

        [field: SerializeField] public int ToolbarInt { get; set; } = 0;

        public RamTerrainManager RamTerrainManager
        {
            get => ramTerrainManager ??= new RamTerrainManager(NmSpline, this);
            set => ramTerrainManager = value;
        }

        public NmSpline NmSpline
        {
            get
            {
                if (nmSpline != null && nmSpline.gameObject == gameObject)
                    return nmSpline;

                nmSpline = GetComponentInParent<NmSpline>();


                nmSpline.SetData(0, 1, false, false, false, false, false, false);

                return nmSpline;
            }
        }

        public float TriangleDensity
        {
            get => triangleDensity;
            set => triangleDensity = value;
        }

        public void OnValidate()
        {
            Event e = Event.current;

            if (e is not { type: EventType.ExecuteCommand, commandName: "Duplicate" } &&
                e is not { type: EventType.ExecuteCommand, commandName: "Paste" }) return;


            _duplicate = true;


            RamTerrainManager oldRamTerrainManager = ramTerrainManager;

            ramTerrainManager = new RamTerrainManager(NmSpline, this, oldRamTerrainManager);
        }


        #region spline

        private void GeneratePointList()
        {
            nmSpline.PrepareSpline();


            nmSpline.GenerateFullSpline(triangleDensity);
        }

        #endregion


        public static TerrainSpline CreateTerrainSpline()
        {
            var gameObject = new GameObject("Terrain Spline");


            var terrainSpline = gameObject.AddComponent<TerrainSpline>();
#if UNITY_EDITOR
            EditorGUIUtility.SetIconForObject(gameObject, EditorGUIUtility.GetIconForObject(terrainSpline));
#endif
            gameObject.GetComponent<MeshRenderer>().enabled = false;

            terrainSpline.nmSpline = terrainSpline.GetComponentInParent<NmSpline>();
            terrainSpline.nmSpline.SetData(0, 1, true, true, false, true, false, false, false);


            return terrainSpline;
        }

        public Transform GetTransform => transform;

        public void GenerateForTerrain()
        {
            GeneratePolygon();
        }

        public void GeneratePolygon()
        {
            OnGenerationStarted?.Invoke();

            MainMeshFilter = GetComponent<MeshFilter>();

            if (MainMeshFilter.sharedMesh != null)
            {
                currentMesh = Instantiate(MainMeshFilter.sharedMesh);
                currentMesh.name = $"mesh {gameObject.name}";
            }

            CheckMeshRenderer();

            if (RamTerrainManager.BasePainterData != null)
                RamTerrainManager.BasePainterData.TerrainsUnder.Clear();


            SetLockHeight();

            if (!NmSpline.CanGenerateSpline(3))
                return;

            NmSpline.CenterSplinePivot();

            NmSpline.PrepareSpline();
            NmSpline.CalculateCatmullRomSideSplines();

            NmSpline.CalculateSplinePositions(triangleDensity, NmSpline.SplineSide.Center);


            (List<int> indices, List<Vector3> vertices, float triangleSizeByLimit) verticesData =
                SplineTriangulator.TriangulateSpline(false, MaximumTriangleSize, MaximumTriangleAmount, nmSpline);

            TriangleSizeByLimit = verticesData.triangleSizeByLimit;
            indices = verticesData.indices;
            vertices = verticesData.vertices.ToArray();
            int vertCount = vertices.Length;
            normals = new Vector3[vertCount];


            SetMeshData(vertCount);

            //find terrain under spline which bounding box overlaps
            SetTerrain();

            OnGenerationEnded?.Invoke();
        }

        private void SetTerrain()
        {
            if (RamTerrainManager.NmSpline.MainControlPoints.Count <= 0) return;

            RamTerrainManager.BasePainterData.TerrainsUnder.Clear();
            Vector3 position = transform.position;

            var bounds = new Bounds((Vector3)NmSpline.MainControlPoints[0].position + position, Vector3.zero);

            for (int i = 0; i < NmSpline.MainControlPoints.Count; i++)
            {
                RamControlPoint point = NmSpline.MainControlPoints[i];
                bounds.Encapsulate(position + (Vector3)point.position);
            }

            bounds.Expand(new Vector3(0, 10000, 0));

            foreach (Terrain activeTerrain in Terrain.activeTerrains)
            {
                Bounds activeBounds = activeTerrain.terrainData.bounds;
                activeBounds.center = activeTerrain.transform.position + activeBounds.center;
                if (bounds.Intersects(activeBounds))
                {
                    RamTerrainManager.BasePainterData.AddTerrain(activeTerrain);
                }
            }
        }

        private void SetMeshData(int vertCount)
        {
            if (currentMesh && !_duplicate)
            {
                _duplicate = false;
                currentMesh.Clear();
            }
            else
                currentMesh = new Mesh();


            if (vertCount > 65000) currentMesh.indexFormat = IndexFormat.UInt32;


            currentMesh.vertices = vertices;
            currentMesh.subMeshCount = 1;
            currentMesh.SetTriangles(indices, 0);
            currentMesh.normals = normals;

            currentMesh.RecalculateTangents();
            currentMesh.RecalculateBounds();

            MainMeshFilter.sharedMesh = currentMesh;
        }

        private void CheckMeshRenderer()
        {
            var meshRenderer = gameObject.GetComponent<MeshRenderer>();
            if (meshRenderer == null) return;
            meshRenderer.enabled = false;
        }


        private void SetLockHeight()
        {
            if (!LockHeight) return;

            for (int i = 1; i < NmSpline.MainControlPoints.Count; i++)
            {
                Vector4 vec = NmSpline.MainControlPoints[i].position;
                vec.y = NmSpline.MainControlPoints[0].position.y;
                NmSpline.MainControlPoints[i].position = vec;
            }
        }
    }
}