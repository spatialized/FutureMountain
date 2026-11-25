using System.Collections.Generic;
using Unity.Mathematics;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Events;
using Random = UnityEngine.Random;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    [RequireComponent(typeof(NmSpline))]
    [RequireComponent(typeof(NmSplineDataFenceScale))]
    public class FenceGenerator : MonoBehaviour, IGenerationEvents
    {
        private const int MaxLengthChecks = 10000;

        [SerializeField] private NmSpline nmSpline;

        public FenceProfile baseProfile;
        public FenceProfile currentProfile;
        public FenceProfile oldProfile;


        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }

        public NmSpline NmSpline
        {
            get
            {
                if (nmSpline != null && nmSpline.gameObject == gameObject)
                    return nmSpline;

                nmSpline = GetComponentInParent<NmSpline>();

                if (BaseProfile == null)
                    GenerateBaseProfile();

                nmSpline.SetData(0, 1, false, true, false, true, false, false);

                return nmSpline;
            }
        }

        public int ToolbarInt
        {
            get => toolbarInt;
            set => toolbarInt = value;
        }

        public bool AutoGenerate
        {
            get => autoGenerate;
            set => autoGenerate = value;
        }

        public bool BaseDebug
        {
            get => debug;
            set => debug = value;
        }

        public NmSpline OtherSpline
        {
            get => otherSpline;
            set => otherSpline = value;
        }

        public float SplineLerp
        {
            get => splineLerp;
            set => splineLerp = value;
        }

        public bool BendMeshesPreview
        {
            get => bendMeshesPreview;
            set => bendMeshesPreview = value;
        }

        public List<GameObject> GeneratedPrefabs
        {
            get => generatedPrefabs;
            set => generatedPrefabs = value;
        }

        public FenceProfile BaseProfile
        {
            get
            {
                if (baseProfile == null)
                    GenerateBaseProfile();
                return baseProfile;
            }
            set => baseProfile = value;
        }

        public bool ShowUISplineSettings { get; set; }

        public bool ShowUIPrefabSettings { get; set; }


        public bool ShowUIDistributionSettings { get; set; }


        [SerializeField] private int toolbarInt;


        [SerializeField] private bool autoGenerate;

        [SerializeField] private bool debug;


        //Ramspline
        [SerializeField] private NmSpline otherSpline;
        [SerializeField] private float splineLerp;

        [SerializeField] private List<GameObject> generatedPrefabs = new List<GameObject>();

        private NmSplinePoint[] _points;

        [SerializeField] private bool bendMeshesPreview;

        [SerializeField] private NmSplineDataFenceScale fenceScaleData;


        public void OnValidate()
        {
            if (BaseProfile == null || BaseProfile.GameObject == gameObject) return;

            FenceProfile tempProfile = BaseProfile;
            BaseProfile = ScriptableObject.CreateInstance<FenceProfile>();
            BaseProfile.SetProfileData(tempProfile);
            BaseProfile.GameObject = gameObject;
            //_duplicate = true;
        }

        #region spline

        public void GenerateSplineAndPointList(bool quick = false, bool checkAuto = true)
        {
            OnGenerationStarted?.Invoke();
            if (BaseProfile == null)
            {
                GenerateBaseProfile();
            }

            GeneratePointList();


            if (!checkAuto || AutoGenerate)
                GenerateSplineObjects(quick);

            OnGenerationEnded?.Invoke();
        }


        private void GeneratePointList()
        {
            nmSpline.PrepareSpline();


            nmSpline.GenerateFullSpline(BaseProfile.TriangleDensity);


            if (nmSpline.Points.Count > 2)
            {
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

                //snap all points to terrain
                if (nmSpline.IsSnapping)
                {
                    RaycastHit[] raycastHits = new RaycastHit[2];
                    for (int i = 0; i < nmSpline.Points.Count; i++)
                    {
                        NmSplinePoint point = nmSpline.Points[i];

                        if (Physics.Raycast(point.Position + transform.position + Vector3.up * 5, Vector3.down, out RaycastHit hit, 1000,
                                BaseProfile.RaycastMask, QueryTriggerInteraction.Ignore))
                        {
                            point.Position = hit.point - transform.position;
                        }


                        nmSpline.Points[i] = point;
                    }
                }

                nmSpline.GenerateArrayForDistanceSearch();
            }
        }

        #endregion

        public static FenceGenerator CreateFenceGenerator(List<Vector3> positions = null)
        {
            var gameObject = new GameObject("Fence Generator");


            var fenceGenerator = gameObject.AddComponent<FenceGenerator>();
#if UNITY_EDITOR
            EditorGUIUtility.SetIconForObject(gameObject, EditorGUIUtility.GetIconForObject(fenceGenerator));
#endif

            fenceGenerator.nmSpline = fenceGenerator.GetComponentInParent<NmSpline>();
            fenceGenerator.nmSpline.SetData(0, 1, false, true, false, true, false, false, false);

            if (positions != null)
                for (int i = 0; i < positions.Count; i++)
                {
                    fenceGenerator.nmSpline.AddPoint(positions[i]);
                }

            return fenceGenerator;
        }

        public void GenerateSplineObjects(bool quick = false)
        {
            DestroyPrefabs();
            //NMTODO: Remove this later after 2024.10.01
            if (nmSpline.UseWidth == true)
            {
                nmSpline.UseWidth = false;
            }

            if (!NmSpline.CanGenerateSpline())
                return;
            nmSpline.CenterSplinePivot();

            RemoveEmptyElements();
            GeneratePointList();

            if (BaseProfile.Posts.Count == 0 && BaseProfile.Spans.Count == 0)
                return;


            fenceScaleData = nmSpline.GetData<NmSplineDataFenceScale>();


            GameObject span = null;

            if (BaseProfile.Spans.Count > 0 && BaseProfile.Spans[0].gameObject != null)
                span = BaseProfile.Spans[0].gameObject;

            if (span == null)
                return;


            NmSplinePoint nextPosition;

            int stop = 0;

            if (baseProfile.RandomSeed)
                baseProfile.Seed = Mathf.Abs((int)System.DateTime.Now.Ticks);

            Random.InitState(baseProfile.Seed);

            float currentLength = 0;

            NmSplinePoint newPosition = nmSpline.NmSplinePointSearcher.FindPosition(currentLength, 0, out int searchLast);
            nextPosition = newPosition;
            float sizePrefab = 0;
            float sizeSpan;

            NmSplinePoint previousPosition= nextPosition;

            //Debug.Log($"PrepareFenceProbabilities {gameObject.name}");

            List<FenceObjectProbability> fenceObjectProbabilities = PrepareFenceProbabilities(stop, ref currentLength);


            float scaleSize = nmSpline.Length / currentLength;
            currentLength = 0;
            int i;

            //bool endFence = false;
            for (i = 0; i < fenceObjectProbabilities.Count; i++)
            {
                FenceObjectProbability probabilitySpan = fenceObjectProbabilities[i];

                sizePrefab = GetSpanSize(probabilitySpan, out sizeSpan, scaleSize);


                currentLength += sizePrefab * BaseProfile.DistanceMultiplier + (BaseProfile.AdditionalDistance > 0 ? BaseProfile.AdditionalDistance : 0);

                if (BaseProfile.LengthType == FenceProfile.LengthTypeEnum.Spline)
                {
                    nextPosition = nmSpline.NmSplinePointSearcher.FindPosition(currentLength, searchLast, out searchLast);
                }
                else
                {
                    float distance = sizePrefab * BaseProfile.DistanceMultiplier + (BaseProfile.AdditionalDistance > 0 ? BaseProfile.AdditionalDistance : 0);
                    nextPosition = nmSpline.NmSplinePointSearcher.FindPositionByDistance(newPosition.Position, distance, searchLast, out searchLast);
                }

                if (searchLast == -1)
                {
                    //endFence = true;
                    break;
                }

                if (nmSpline.IsLooping && nmSpline.Length < currentLength)
                    nextPosition = nmSpline.NmSplinePointSearcher.FindPosition(0, 0, out searchLast);


                if (nmSpline.Length < currentLength && Vector3.Distance(nextPosition.Position, newPosition.Position) < sizePrefab * 0.5f)
                    break;


                if (BaseProfile.Posts.Count > 0)
                {
                    FenceObjectProbability probabilityPost = BaseProfile.PostRandomType switch
                    {
                        0 => BaseProfile.Posts.GetRandomFromList(),
                        1 => BaseProfile.Posts[i % BaseProfile.Posts.Count],
                        _ => BaseProfile.Posts[0]
                    };
                    //Debug.Log(sizeSpan);
                    //Debug.Log(sizePrefab);
                    SetPrefabPosition(probabilityPost, quick, 1, newPosition, nextPosition, i, currentLength - sizePrefab, sizePrefab, false);
                }

                SetPrefabPosition(probabilitySpan, quick, sizeSpan, newPosition, nextPosition, i, currentLength - sizePrefab, sizePrefab);


                previousPosition = newPosition;
                newPosition = nextPosition;
            }

            if (!nmSpline.IsLooping && BaseProfile.Posts.Count > 0)
            {
                FenceObjectProbability probabilityPost = BaseProfile.PostRandomType switch
                {
                    0 => BaseProfile.Posts.GetRandomFromList(),
                    1 => BaseProfile.Posts[i % BaseProfile.Posts.Count],
                    _ => BaseProfile.Posts[0]
                };
                
                nextPosition.Position = newPosition.Position + newPosition.Position - previousPosition.Position;
                
                SetPrefabPosition(probabilityPost, quick, 1, newPosition, nextPosition, i, currentLength - sizePrefab, sizePrefab, false);
            }

            RecalculateLodBounds(quick);

            AddOffsetToGeneratedPrefabs();

            SetNormalsFromTerrainRaycast();
        }

        private void SetNormalsFromTerrainRaycast()
        {
            if (BaseProfile.NormalFromTerrain == false) return;


            Terrain[] terrains = Terrain.activeTerrains;
            TerrainCollider[] terrainColliders = new TerrainCollider[terrains.Length];
            for (int i = 0; i < terrains.Length; i++)
            {
                terrainColliders[i] = terrains[i].GetComponent<TerrainCollider>();
            }

            double timeTest = Time.realtimeSinceStartupAsDouble;

            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();


            //for each mesh filter for each mesh filter vertex raycast to terrain and set normal
            foreach (MeshFilter meshFilter in meshFilters)
            {
                Mesh mesh = meshFilter.sharedMesh;
                Vector3[] vertices = mesh.vertices;

                Vector3[] normals = mesh.normals;

                //find max normal terrain curve distance
                float maxDistance = float.MinValue;
                foreach (Keyframe key in BaseProfile.NormalFromTerrainCurve.keys)
                {
                    if (key.time > maxDistance)
                    {
                        maxDistance = key.time;
                    }
                }


                for (int i = 0; i < vertices.Length; i++)
                {
                    Vector3 vertex = meshFilter.transform.TransformPoint(vertices[i]);


                    foreach (TerrainCollider terrainCollider in terrainColliders)
                    {
                        if (!terrainCollider) continue;

                        if (!terrainCollider.Raycast(new Ray(vertex + Vector3.up * 1000, Vector3.down), out RaycastHit hit, 10000)) continue;

                        float distance = Vector3.Distance(vertex, hit.point);
                        if (distance > maxDistance) continue;

                        if (vertex.y < hit.point.y) distance = -distance;

                        //check how normals are different
                        if (Vector3.Angle(normals[i], hit.normal) < BaseProfile.NormalFromTerrainNormalTolerance)
                        {
                            normals[i] = Vector3.Lerp(normals[i], hit.normal, BaseProfile.NormalFromTerrainCurve.Evaluate(distance));
                        }


                        break;
                    }
                }

                mesh.normals = normals;
            }


            Debug.Log($"terrain normals time {Time.realtimeSinceStartupAsDouble - timeTest}");
        }

        private void AddOffsetToGeneratedPrefabs()
        {
            foreach (GameObject go in GeneratedPrefabs)
            {
                if (go == null) continue;

                go.transform.position += BaseProfile.Offset;
            }
        }

        private void RecalculateLodBounds(bool quick)
        {
            if (quick) return;

            LODGroup[] lodGroups = GetComponentsInChildren<LODGroup>();
            foreach (LODGroup lodGroup in lodGroups)
            {
                lodGroup.RecalculateBounds();
            }
        }

        private List<FenceObjectProbability> PrepareFenceProbabilities(int stop, ref float currentLength)
        {
            List<FenceObjectProbability> fenceObjectProbabilities = new();

            if (BaseProfile.FirstSpan != null && BaseProfile.FirstSpan.gameObject)
                CalculateFullLength(0, fenceObjectProbabilities, ref currentLength, BaseProfile.FirstSpan);


            while (currentLength < nmSpline.Length && stop < MaxLengthChecks)
            {
                if (CalculateFullLength(stop, fenceObjectProbabilities, ref currentLength)) break;
                stop++;
            }

            if (BaseProfile.LastSpan != null && BaseProfile.LastSpan.gameObject)
                CalculateFullLength(0, fenceObjectProbabilities, ref currentLength, BaseProfile.LastSpan, true);
            return fenceObjectProbabilities;
        }

        private void RemoveEmptyElements()
        {
            BaseProfile.Posts.RemoveAll(item => item == null);
            BaseProfile.Spans.RemoveAll(item => item == null);
        }

        private bool CalculateFullLength(int id, List<FenceObjectProbability> fenceObjectProbabilities, ref float currentLength,
            FenceObjectProbability baseProbability = null, bool replaceLast = false)
        {
            NmSplinePoint splinePoint = nmSpline.NmSplinePointSearcher.FindPosition(currentLength, 0, out _);
            //Debug.Log(splinePoint.Width);

            FenceObjectProbability probability;
            if (baseProbability != null)
                probability = baseProbability;
            else
                probability = BaseProfile.SpanRandomType switch
                {
                    0 => BaseProfile.Spans.GetRandomFromList(),
                    1 => BaseProfile.Spans[id % BaseProfile.Spans.Count],
                    _ => BaseProfile.Spans[0]
                };

            float sizePrefab = GetSpanSize(probability, out float _);

            if (replaceLast && baseProbability != null)
            {
                do
                {
                    float sizePrefabLast = GetSpanSize(fenceObjectProbabilities[^1], out float _);

                    currentLength -= sizePrefabLast;
                    fenceObjectProbabilities.RemoveAt(fenceObjectProbabilities.Count - 1);
                } while (nmSpline.Length < currentLength + sizePrefab);
            }


            if (nmSpline.Length < currentLength) // && Vector3.Distance(nextPosition.Position, newPosition.Position) < sizePrefab * 0.5f)
                return true;

            fenceObjectProbabilities.Add(probability);
            currentLength += sizePrefab;
            return false;
        }


        public void DestroyPrefabs()
        {
            bool allDestroyed;
            do
            {
                //clear nulls from list
                GeneratedPrefabs.RemoveAll(item => item == null);

                allDestroyed = true;
                foreach (GameObject obj in GeneratedPrefabs)
                {
                    if (Application.isEditor)
#if UNITY_EDITOR
                        Undo.DestroyObjectImmediate(obj);
#else
                        DestroyImmediate(obj);
#endif
                    else
                        Destroy(obj);
                }

                foreach (GameObject obj in GeneratedPrefabs)
                {
                    if (obj == null) continue;

                    allDestroyed = false;
                    break;
                }
            } while (!allDestroyed);


            GeneratedPrefabs.Clear();
        }

        private float GetSpanSize(FenceObjectProbability prefabProbability, out float sizeSpan, float scaleSize = 0)
        {
            Vector3 size;

            if (prefabProbability.BoundsType == FenceObjectProbability.EnumBoundsType.MeshFilter)
            {
                var meshFilter = prefabProbability.gameObject.GetComponentInChildren<MeshFilter>();

                if (meshFilter == null)
                {
                    Debug.LogWarning($"There is no MeshFilter in {prefabProbability.gameObject.name}");
                    size = Vector3.one;
                }
                else
                {
                    Mesh spanMesh = meshFilter.sharedMesh;
                    size = spanMesh.bounds.size;
                }
            }
            else if (prefabProbability.BoundsType == FenceObjectProbability.EnumBoundsType.MeshRenderer)
            {
                var meshRenderer = prefabProbability.gameObject.GetComponentInChildren<MeshRenderer>();
                if (meshRenderer == null)
                {
                    Debug.LogWarning($"There is no meshRenderer in {prefabProbability.gameObject.name}");
                    size = Vector3.one;
                }
                else
                {
                    size = meshRenderer.bounds.size;
                }
            }
            else if (prefabProbability.BoundsType == FenceObjectProbability.EnumBoundsType.Custom)
            {
                size = prefabProbability.CustomBoundsSize;
                if (size.x == 0)
                    size.x = 1;
                if (size.y == 0)
                    size.y = 1;
                if (size.z == 0)
                    size.z = 1;
            }
            else
            {
                size = Vector3.one;
            }


            prefabProbability.CustomBoundsSize = size;

            Vector3 scale = prefabProbability.scaleOffset;
            if (prefabProbability.scaleOffset.x == 0)
                scale.x = 1;
            if (prefabProbability.scaleOffset.y == 0)
                scale.y = 1;
            if (prefabProbability.scaleOffset.z == 0)
                scale.z = 1;

            prefabProbability.scaleOffset = scale;

            size = new Vector3(size.x * scale.x,
                size.y * scale.y,
                size.z * scale.z);

            sizeSpan = prefabProbability.forward switch
            {
                FenceAxis.AlignAxis.XAxis or FenceAxis.AlignAxis.NegativeXAxis => Mathf.Abs(size.x),
                FenceAxis.AlignAxis.YAxis or FenceAxis.AlignAxis.NegativeYAxis => Mathf.Abs(size.y),
                _ => Mathf.Abs(size.z)
            };


            float sizePrefab = sizeSpan; // * BaseProfile.DistanceMultiplier;


            //if (sizePrefab + BaseProfile.AdditionalDistance > 0)
            //{
            //    sizePrefab += BaseProfile.AdditionalDistance;
            //}


            if (BaseProfile.ScaleMesh && scaleSize > 0)
            {
                sizePrefab *= scaleSize;
            }

            return sizePrefab;
        }

        private void SetPrefabPosition(FenceObjectProbability probability, bool quick, float sizeSpan, NmSplinePoint newPosition, NmSplinePoint nextPosition, int count, float currentLength, float sizePrefab = 0,
            bool canBend = true)
        {
            GameObject go;

            if (probability == null || probability.gameObject == null) return;

            go = InstantiatePrefab(probability);


            go = GenerateMirror(probability, go);


            go.transform.position = newPosition.Position;


            Vector3 localScale = go.transform.localScale;

            if (BaseProfile.ScaleMesh)
            {
                float distance = sizePrefab;
                if (!BaseProfile.ScaleMeshUnified)
                    distance = Vector3.Distance(newPosition.Position, nextPosition.Position);

                localScale = GetLocalScale(probability, quick, sizeSpan, newPosition, nextPosition, distance, canBend, localScale, currentLength);
                //localScale = GetLocalScale(probability, quick, sizeSpan, newPosition, nextPosition, sizePrefab, canBend, localScale, currentLength);
            }


            localScale = new Vector3(localScale.x * probability.scaleOffset.x,
                localScale.y * probability.scaleOffset.y,
                localScale.z * probability.scaleOffset.z);

            //Debug.Log($"name {probability.gameObject.name} localScale: {localScale.x}");

            go.transform.localScale = localScale;

            Quaternion rotation = probability.GetRotation();

            Vector3 position = go.transform.position;

            Vector3 lookPosition = nextPosition.Position - position;
            if (lookPosition.magnitude == 0)
                lookPosition += newPosition.Tangent;

            if (BaseProfile.HoldUp)
                lookPosition.y = 0;


            go.transform.rotation = Quaternion.LookRotation(lookPosition, newPosition.Normal) * newPosition.Rotation * Quaternion.Euler(probability.rotationOffset) * rotation;


            go.name = $"{probability.gameObject.name}_{count}";

            if (!canBend || (!BaseProfile.BendMeshes || (quick && !BendMeshesPreview)))
                position += go.transform.rotation * probability.PositionOffset;

            go.transform.position = position;
            GeneratedPrefabs.Add(go);
            go.transform.SetParent(transform, true);

            if (!canBend || !BaseProfile.BendMeshes || (quick && !BendMeshesPreview))
                return;

            FenceMeshBender.BendMeshesWithLod(newPosition.Position, currentLength, go, rotation, probability, nmSpline, fenceScaleData, BaseProfile);
        }

        private Vector3 GetLocalScale(FenceObjectProbability probability, bool quick, float sizeSpan, NmSplinePoint newPosition, NmSplinePoint nextPosition, float sizePrefab, bool canBend, Vector3 localScale,
            float currentLength)
        {
            if (canBend)
            {
                Vector3 forward = probability.GetRemappedForward();
                forward.x = Mathf.Abs(forward.x);
                forward.y = Mathf.Abs(forward.y);
                forward.z = Mathf.Abs(forward.z);
                float scale = 1;

                /*  if (!BaseProfile.BendMeshes || (quick && !BendMeshesPreview))
                  {
                      scale = (Vector3.Distance(newPosition.Position, nextPosition.Position)- BaseProfile.AdditionalDistance) / sizeSpan;
                  }
                  else
                  {
                      scale = sizePrefab / sizeSpan;
                  }*/
                scale = sizePrefab / sizeSpan;

                // Debug.Log($"forward {forward} up {probability.GetRemappedUp()} localScale {localScale} sizeSpan {sizeSpan}");


                localScale = new Vector3(Mathf.Lerp(localScale.x, scale, forward.x),
                    Mathf.Lerp(localScale.y, scale, forward.y),
                    Mathf.Lerp(localScale.z, scale, forward.z));

                if (!BaseProfile.BendMeshes || (quick && !BendMeshesPreview))
                {
                    Vector3 up = probability.GetRemappedUp();
                    up.x = Mathf.Abs(up.x);
                    up.y = Mathf.Abs(up.y);
                    up.z = Mathf.Abs(up.z);

                    Vector3 right = probability.GetRemappedRight();
                    right.x = Mathf.Abs(right.x);
                    right.y = Mathf.Abs(right.y);
                    right.z = Mathf.Abs(right.z);

                    Vector2 additionalScale = fenceScaleData.GetSearchData(currentLength);


                    localScale = new Vector3(Mathf.Lerp(localScale.x, localScale.x * additionalScale.y, up.x),
                        Mathf.Lerp(localScale.y, localScale.y * additionalScale.y, up.y),
                        Mathf.Lerp(localScale.z, localScale.z * additionalScale.y, up.z));

                    localScale = new Vector3(Mathf.Lerp(localScale.x, localScale.x * additionalScale.x, right.x),
                        Mathf.Lerp(localScale.y, localScale.y * additionalScale.x, right.y),
                        Mathf.Lerp(localScale.z, localScale.z * additionalScale.x, right.z));
                }
            }
            else
            {
                Vector2 additionalScale = fenceScaleData.GetSearchData(currentLength);
                localScale.x *= additionalScale.x;
                localScale.z *= additionalScale.y;
            }

            return localScale;
        }

        private GameObject InstantiatePrefab(FenceObjectProbability probability)
        {
            GameObject go;
#if UNITY_EDITOR
            if (PrefabUtility.IsPartOfAnyPrefab(gameObject))
                go = (GameObject)PrefabUtility.InstantiatePrefab(probability.gameObject);

            else
                go = Instantiate(probability.gameObject);

            Undo.RegisterCreatedObjectUndo(go, "Create Fence Object");
#else
            go = Instantiate(probability.gameObject);
#endif
            return go;
        }

        private static GameObject GenerateMirror(FenceObjectProbability probability, GameObject go)
        {
            if (probability.mirror != FenceObjectProbability.MirrorType.None)
            {
                GameObject newGo = new();
                go.transform.SetParent(newGo.transform);

                newGo.transform.position = Vector3.zero;

                Vector3 forward = probability.GetRemappedForward();

                go.transform.localPosition = forward * go.GetComponentInChildren<MeshFilter>().sharedMesh.bounds.size.x;

                if (probability.mirror == FenceObjectProbability.MirrorType.Mirror)
                    go.transform.localScale = new Vector3(forward.x != 0 ? -1 : 1, forward.y != 0 ? -1 : 1, forward.z != 0 ? -1 : 1);

                go = newGo;
            }

            return go;
        }


        public void GenerateBaseProfile()
        {
            BaseProfile = ScriptableObject.CreateInstance<FenceProfile>();
        }
    }
}