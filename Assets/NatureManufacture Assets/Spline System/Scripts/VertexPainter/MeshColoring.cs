using System;
using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    public class MeshColoring : MonoBehaviour
    {
        public static readonly int DynamicFlowID = Shader.PropertyToID("_Dynamic_Flow");
        public static readonly int DynamicShapeSpeedID = Shader.PropertyToID("_Dynamic_Shape_Speed");
        public static readonly int DynamicStartPositionOffsetID = Shader.PropertyToID("_Dynamic_Start_Position_Offset");
        public static readonly int DynamicReactionOffsetID = Shader.PropertyToID("_Dynamic_Reaction_Offset");
        public static readonly int DynamicShapeVCurvePowerID = Shader.PropertyToID("_Dynamic_Shape_V_Curve_Power");

        private MeshRenderer meshRenderer;
        [SerializeField] private float height = 0.5f;

        //Blend Distance above water
        [SerializeField] private float threshold = 0.5f;
        [SerializeField] private float thresholdDistance = 0f;
        [SerializeField] private bool colorMeshLive;
        [SerializeField] private bool autoColor;
        [SerializeField] private LayerMask layer;
        [SerializeField] private bool newMesh = true;


        [SerializeField] private bool useMaterialPropertyBlock = true;

        [FormerlySerializedAs("dynamicLavaFlow")] [SerializeField]
        private float dynamicFlow;

        [SerializeField] private Material dynamicMaterial;
        [SerializeField] private float dynamicStartPositionOffset;
        [SerializeField] private float dynamicShapeSpeed;
        [SerializeField] private float dynamicReactionOffset;
        [SerializeField] private float dynamicShapeVCurvePower;

        [SerializeField] private float coloringSpeed = 1;
        [SerializeField] private float cleaningSpeed = 1;

        private MeshFilter[] _meshFilters;
        private bool _colored;

        private static RamSpline[] _ramSplines;
        private static LakePolygon[] _lakePolygons;
        private static Waterfall[] _waterfalls;
        private static readonly List<MeshRenderer> _SplineMeshRenderers = new();


        public bool AutoColor
        {
            get => autoColor;
            set => autoColor = value;
        }

        public float Threshold
        {
            get => threshold;
            set => threshold = value;
        }

        public float Height
        {
            get => height;
            set => height = value;
        }

        public bool NewMesh
        {
            get => newMesh;
            set => newMesh = value;
        }

        public bool ColorMeshLive
        {
            get => colorMeshLive;
            set => colorMeshLive = value;
        }

        public LayerMask Layer
        {
            get => layer;
            set => layer = value;
        }

        [field: SerializeField] public Vector3 OldPosition { get; set; }

        public float DynamicLavaFlow
        {
            get => dynamicFlow;
            set => dynamicFlow = value;
        }

        public float DynamicStartPositionOffset
        {
            get => dynamicStartPositionOffset;
            set => dynamicStartPositionOffset = value;
        }

        public float DynamicShapeSpeed
        {
            get => dynamicShapeSpeed;
            set => dynamicShapeSpeed = value;
        }

        public float DynamicReactionOffset
        {
            get => dynamicReactionOffset;
            set => dynamicReactionOffset = value;
        }

        public float DynamicShapeVCurvePower
        {
            get => dynamicShapeVCurvePower;
            set => dynamicShapeVCurvePower = value;
        }

        public bool UseMaterialPropertyBlock
        {
            get => useMaterialPropertyBlock;
            set => useMaterialPropertyBlock = value;
        }

        public float ThresholdDistance
        {
            get => thresholdDistance;
            set => thresholdDistance = value;
        }

        public float ColoringSpeed
        {
            get => coloringSpeed;
            set => coloringSpeed = value;
        }

        public float CleaningSpeed
        {
            get => cleaningSpeed;
            set => cleaningSpeed = value;
        }

        public Material DynamicMaterial
        {
            get => dynamicMaterial;
            set => dynamicMaterial = value;
        }


        private void OnValidate()
        {
            PrepareMaterialPropertyBlock();
        }


        private void Awake()
        {
            meshRenderer = GetComponentInChildren<MeshRenderer>();
            PrepareMaterialPropertyBlock();
        }

        private void PrepareMaterialPropertyBlock()
        {
            if (!UseMaterialPropertyBlock || !(dynamicFlow > 0) || dynamicMaterial == null) return;

            MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();

            MeshRenderer[] meshRenderers = gameObject.GetComponentsInChildren<MeshRenderer>();

            DynamicLavaFlow = dynamicMaterial.GetFloat(DynamicFlowID);
            DynamicStartPositionOffset = dynamicMaterial.GetFloat(DynamicStartPositionOffsetID);
            DynamicShapeSpeed = dynamicMaterial.GetFloat(DynamicShapeSpeedID);
            //DynamicReactionOffset = dynamicMaterial.GetFloat(DynamicReactionOffsetID);
            DynamicShapeVCurvePower = dynamicMaterial.GetFloat(DynamicShapeVCurvePowerID);

            foreach (var meshRenderer in meshRenderers)
            {
                meshRenderer.GetPropertyBlock(materialPropertyBlock);
                materialPropertyBlock.SetFloat(DynamicFlowID, DynamicLavaFlow);
                materialPropertyBlock.SetFloat(DynamicStartPositionOffsetID, DynamicStartPositionOffset);
                materialPropertyBlock.SetFloat(DynamicShapeSpeedID, DynamicShapeSpeed);
                materialPropertyBlock.SetFloat(DynamicReactionOffsetID, DynamicReactionOffset);
                materialPropertyBlock.SetFloat(DynamicShapeVCurvePowerID, DynamicShapeVCurvePower);

                meshRenderer.SetPropertyBlock(materialPropertyBlock);
            }
        }


        private void Start()
        {
            if (!ColorMeshLive) return;

            _ramSplines ??= FindObjectsByType<RamSpline>(FindObjectsSortMode.None);
            _lakePolygons ??= FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);
            _waterfalls ??= FindObjectsByType<Waterfall>(FindObjectsSortMode.None);

            if (_SplineMeshRenderers.Count == 0)
            {
                MeshRenderer splineMeshRenderer;
                //get mesh renderers from ramspline, lakepolygon and waterfall
                for (int i = 0; i < _ramSplines.Length; i++)
                {
                    RamSpline spline = _ramSplines[i];
                    splineMeshRenderer = spline.GetComponent<MeshRenderer>();

                    if (splineMeshRenderer != null)
                        _SplineMeshRenderers.Add(splineMeshRenderer);
                }

                for (int i = 0; i < _lakePolygons.Length; i++)
                {
                    LakePolygon spline = _lakePolygons[i];
                    splineMeshRenderer = spline.GetComponent<MeshRenderer>();

                    if (splineMeshRenderer != null)
                        _SplineMeshRenderers.Add(splineMeshRenderer);
                }

                for (int i = 0; i < _waterfalls.Length; i++)
                {
                    Waterfall spline = _waterfalls[i];
                    splineMeshRenderer = spline.GetComponent<MeshRenderer>();

                    if (splineMeshRenderer != null)
                        _SplineMeshRenderers.Add(splineMeshRenderer);
                }
            }


            _colored = false;
            _meshFilters = gameObject.GetComponentsInChildren<MeshFilter>();
        }


        private void Update()
        {
            if (!ColorMeshLive) return;

            ColorMeshInUpdate();
        }


        private void ColorMeshInUpdate()
        {
            _colored = true;

            Ray ray = new Ray
            {
                direction = Vector3.up
            };
            RaycastHit hit;
            Vector3 upVector = -Vector3.up * (Height + Threshold);
            Color white = Color.white;

            List<MeshCollider> meshColliders = AddMeshCollidersToSplines();

            Collider[] hitColliders = new Collider[1];
            bool backFace = Physics.queriesHitBackfaces;
            Physics.queriesHitBackfaces = true;
            foreach (var meshFilter in _meshFilters)
            {
                Mesh mesh = meshFilter.sharedMesh;


                if (meshFilter.sharedMesh == null) continue;

                if (!_colored)
                {
                    mesh = Instantiate(meshFilter.sharedMesh);
                    meshFilter.sharedMesh = mesh;
                    _colored = true;
                }

                int vertLength = mesh.vertices.Length;
                Vector3[] vertices = mesh.vertices;
                Color[] colors = mesh.colors;
                Transform meshFilterTransform = meshFilter.transform;

                var lowestPoint = FindLowestPoint(vertices, vertLength, meshFilterTransform, upVector);

                colors = CheckIfColorsExist(colors, vertLength, white);

                ray.origin = lowestPoint;

                float minY = float.MinValue;

                if (Physics.Raycast(ray, out hit, 100, Layer))
                {
                    minY = hit.point.y;
                }


                SetColors(vertLength, vertices, minY, colors, hitColliders);

                mesh.colors = colors;
            }

            ClearMeshColliders(meshColliders);

            Physics.queriesHitBackfaces = backFace;
        }

        private Vector3 FindLowestPoint(Vector3[] vertices, int vertLength, Transform meshFilterTransform, Vector3 upVector)
        {
            float minY = float.MaxValue;
            Vector3 lowestPoint = vertices[0];
            for (int i = 0; i < vertLength; i++)
            {
                vertices[i] = meshFilterTransform.TransformPoint(vertices[i]) + upVector;

                if (!(vertices[i].y < minY)) continue;
                minY = vertices[i].y;
                lowestPoint = vertices[i];
            }

            return lowestPoint;
        }

        private Color[] CheckIfColorsExist(Color[] colors, int vertLength, Color white)
        {
            if (colors.Length == 0)
            {
                colors = new Color[vertLength];
                for (int i = 0; i < colors.Length; i++)
                {
                    colors[i] = white;
                }
            }

            return colors;
        }

        private void SetColors(int vertLength, Vector3[] vertices, float minY, Color[] colors, Collider[] hitColliders)
        {
            float dist;
            for (int i = 0; i < vertLength; i++)
            {
                //Debug.Log($"vertices[i].y < minY = {vertices[i].y < minY} ThresholdDistance = {ThresholdDistance}");
                if (vertices[i].y < minY)
                {
                    dist = Mathf.Abs(vertices[i].y - minY);

                    colors[i].r = Mathf.Lerp(colors[i].r, Mathf.Lerp(1, 0, dist / Threshold), Time.deltaTime * ColoringSpeed);
                }
                else if (ThresholdDistance > 0 && Physics.OverlapSphereNonAlloc(vertices[i], ThresholdDistance, hitColliders, Layer) > 0)
                {
                    colors[i].r = Mathf.Lerp(colors[i].r, Mathf.Lerp(1, 0, 1), Time.deltaTime * ColoringSpeed);
                }
                else
                    colors[i].r = Mathf.Lerp(colors[i].r, 1, Time.deltaTime * CleaningSpeed);
            }
        }

        private void ClearMeshColliders(List<MeshCollider> meshColliders)
        {
            foreach (var item in meshColliders)
            {
                Destroy(item);
            }
        }

        private List<MeshCollider> AddMeshCollidersToSplines()
        {
            Bounds bounds = meshRenderer.bounds;

            List<MeshCollider> meshColliders = new();
            for (int i = 0; i < _SplineMeshRenderers.Count; i++)
            {
                MeshRenderer item = _SplineMeshRenderers[i];
                
                if (RamMath.CalculateDistanceBetweenBounds(bounds, item.bounds) < ThresholdDistance + 0.1f)
                    meshColliders.Add(item.gameObject.AddComponent<MeshCollider>());
            }


            return meshColliders;
        }
    }
}