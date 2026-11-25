using System;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEditorInternal;
    using UnityEngine;

    [CanEditMultipleObjects]
    [CustomEditor(typeof(MeshColoring))]
    public class MeshColoringEditor : Editor
    {
        private static RamSpline[] _ramSplines;
        private static LakePolygon[] _lakePolygons;
        private static Waterfall[] _waterfalls;
        private static MeshFilter[] _meshFilterInScene;


        private SerializedProperty _threshold;
        private SerializedProperty _height;
        private SerializedProperty _thresholdDistance;
        private SerializedProperty _dynamicReactionOffset;
        private SerializedProperty _newMesh;
        private SerializedProperty _useMaterialPropertyBlock;
        private SerializedProperty _layer;
        private SerializedProperty _autoColor;
        private SerializedProperty _colorMeshLive;
        private SerializedProperty _coloringSpeed;
        private SerializedProperty _cleaningSpeed;

        private void OnEnable()
        {
            GetSceneObjects();

            _threshold = serializedObject.FindProperty("threshold");
            _height = serializedObject.FindProperty("height");
            _thresholdDistance = serializedObject.FindProperty("thresholdDistance");
            _dynamicReactionOffset = serializedObject.FindProperty("dynamicReactionOffset");
            _newMesh = serializedObject.FindProperty("newMesh");
            _useMaterialPropertyBlock = serializedObject.FindProperty("useMaterialPropertyBlock");
            _layer = serializedObject.FindProperty("layer");
            _autoColor = serializedObject.FindProperty("autoColor");
            _colorMeshLive = serializedObject.FindProperty("colorMeshLive");
            _coloringSpeed = serializedObject.FindProperty("coloringSpeed");
            _cleaningSpeed = serializedObject.FindProperty("cleaningSpeed");

            SceneView.duringSceneGui += OnDuringSceneGUI;
        }

        public static void GetSceneObjects()
        {
            _ramSplines = FindObjectsByType<RamSpline>(FindObjectsSortMode.None);
            _lakePolygons = FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);
            _waterfalls = FindObjectsByType<Waterfall>(FindObjectsSortMode.None);

            _meshFilterInScene = Resources.FindObjectsOfTypeAll<MeshFilter>();
        }

        private void OnDisable()
        {
            SceneView.duringSceneGui -= OnDuringSceneGUI;
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            MeshColoring mainColoringMesh = (MeshColoring)target;
            EditorGUILayout.Space();


            GUILayout.Label("Settings", EditorStyles.boldLabel);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.Space();
            EditorGUILayout.PropertyField(_threshold, new GUIContent("Blend Distance"));

            EditorGUILayout.PropertyField(_height, new GUIContent("Height Above Water"));
            EditorGUILayout.PropertyField(_thresholdDistance, new GUIContent("Distance From Water (Preview)"));
            EditorGUILayout.PropertyField(_dynamicReactionOffset, new GUIContent("Dynamic Reaction Offset"));

            EditorGUILayout.PropertyField(_newMesh, new GUIContent("Create mesh instance"));
            EditorGUILayout.PropertyField(_useMaterialPropertyBlock, new GUIContent("Use Material Property Block"));

            /*  mainColoringMesh.Layer = InternalEditorUtility.ConcatenatedLayersMaskToLayerMask(
                  EditorGUILayout.MaskField(new GUIContent("R.A.M Layer"), InternalEditorUtility.LayerMaskToConcatenatedLayersMask(mainColoringMesh.Layer),
                      InternalEditorUtility.layers));*/

            EditorGUILayout.PropertyField(_layer, new GUIContent("R.A.M Layer"));

            EditorGUILayout.Space();
            EditorGUILayout.EndVertical();


            EditorGUILayout.Space();
            GUILayout.Label("Realtime Vertex Painting", EditorStyles.boldLabel);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            EditorGUILayout.Space();

            if (!Application.isPlaying)
            {
                EditorGUILayout.PropertyField(_autoColor, new GUIContent("Editor Mode"));
                EditorGUI.indentLevel++;
                if (!mainColoringMesh.AutoColor && GUILayout.Button("Color Mesh Vertex"))
                {
                    foreach (Object o in targets)
                    {
                        var coloringMesh = (MeshColoring)o;
                        ClearColors(coloringMesh);
                        ColorMesh(coloringMesh);
                    }
                }

                EditorGUILayout.Space();

                EditorGUI.indentLevel--;
            }
            else
            {
                EditorGUILayout.LabelField(new GUIContent("Editor Mode -Inactive in playmode"));
            }

            EditorGUILayout.PropertyField(_colorMeshLive, new GUIContent("Play Mode"));
            if (mainColoringMesh.ColorMeshLive)
            {
                EditorGUILayout.PropertyField(_coloringSpeed, new GUIContent("Coloring Speed"));
                EditorGUILayout.PropertyField(_cleaningSpeed, new GUIContent("Clearing Speed"));
            }


            EditorGUILayout.Space();
            if (GUILayout.Button("Clear Mesh Vertex Color"))
            {
                foreach (Object o in targets)
                {
                    var coloringMesh = (MeshColoring)o;
                    ClearColors(coloringMesh);
                }
            }

            EditorGUILayout.Space();
            EditorGUILayout.EndVertical();


            if (serializedObject.hasModifiedProperties)
            {
                serializedObject.ApplyModifiedProperties();
                // Debug.Log($"serialized object");
                foreach (Object o in serializedObject.targetObjects)
                {
                    var coloringMesh = (MeshColoring)o;

                    if (!coloringMesh.AutoColor) continue;

                    Undo.RecordObject(coloringMesh, "Coloring mesh change values");
                    ClearColors(coloringMesh);
                    ColorMesh(coloringMesh);
                }
            }
            else
                serializedObject.ApplyModifiedProperties();
        }

        private void OnDuringSceneGUI(SceneView sceneView)
        {
            // if (Selection.gameObjects.Length > 0)
            //     return;
            if (Application.isPlaying)
                return;

            foreach (Object o in targets)
            {
                var coloringMesh = (MeshColoring)o;

                if (!coloringMesh.AutoColor || !(Vector3.Distance(coloringMesh.transform.position, coloringMesh.OldPosition) > 0.01f)) return;
                ClearColors(coloringMesh);
                ColorMesh(coloringMesh);
                coloringMesh.OldPosition = coloringMesh.transform.position;
            }
        }


        public static void ClearColors(MeshColoring coloringMesh)
        {
            if (!coloringMesh.gameObject.scene.IsValid())
            {
                return;
            }

            MeshFilter[] meshFilters = coloringMesh.gameObject.GetComponentsInChildren<MeshFilter>();
            foreach (MeshFilter meshFilter in meshFilters)
            {
                if (meshFilter.sharedMesh != null)
                {
                    Mesh mesh = meshFilter.sharedMesh;
                    if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)))
                    {
                        mesh = Instantiate(meshFilter.sharedMesh);
                        meshFilter.sharedMesh = mesh;
                    }

                    int vertLength = mesh.vertices.Length;
                    Color[] colors = mesh.colors;
                    if (colors.Length == 0)
                    {
                        colors = new Color[vertLength];
                        for (int i = 0; i < colors.Length; i++)
                        {
                            colors[i] = Color.white;
                        }
                    }

                    for (int i = 0; i < vertLength; i++)
                    {
                        colors[i] = Color.white;
                    }

                    mesh.SetUVs(2, (Vector2[])null);
                    mesh.colors = colors;
                }
            }
        }

        public static void ColorMesh(MeshColoring coloringMesh)
        {
            if (!coloringMesh.gameObject.scene.IsValid())
            {
                return;
            }

            Undo.RecordObject(coloringMesh, "Coloring mesh change values");
            //Debug.Log($"color mesh");
            MeshFilter[] meshFilters = coloringMesh.gameObject.GetComponentsInChildren<MeshFilter>();

            Ray ray = new Ray
            {
                direction = Vector3.up
            };
            float thresholdDistance = coloringMesh.ThresholdDistance;
            Vector3 upVector = -Vector3.up * (coloringMesh.Height + coloringMesh.Threshold);
            foreach (MeshFilter meshFilter in meshFilters)
            {
                bool addedMeshCollider = false;
                MeshCollider meshColliderGo = meshFilter.GetComponent<MeshCollider>();

                if (meshColliderGo == null)
                {
                    addedMeshCollider = true;
                    meshColliderGo = meshFilter.gameObject.AddComponent<MeshCollider>();
                }


                bool backFace = Physics.queriesHitBackfaces;
                Physics.queriesHitBackfaces = true;

                Mesh mesh = meshFilter.sharedMesh;


                if (meshFilter.sharedMesh != null)
                {
                    int copyMeshCount = 0;

                    if (_meshFilterInScene != null)
                        foreach (MeshFilter meshInScene in _meshFilterInScene)
                        {
                            if (mesh == meshInScene.sharedMesh)
                                copyMeshCount++;
                            if (copyMeshCount > 1)
                                break;
                        }


                    if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)) || (copyMeshCount > 1 && coloringMesh.NewMesh))
                    {
                        mesh = Instantiate(meshFilter.sharedMesh);
                        meshFilter.sharedMesh = mesh;
                    }

                    MeshRenderer meshRenderer = meshFilter.GetComponent<MeshRenderer>();
                    Bounds meshRendererBounds = meshRenderer.bounds;
                    MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();
                    meshRenderer.GetPropertyBlock(materialPropertyBlock);
                    int vertLength = mesh.vertices.Length;
                    Vector3[] vertices = mesh.vertices;
                    Color[] colors = mesh.colors;
                    Vector2[] uv3 = mesh.uv3;
                    Transform transform = meshFilter.transform;

                    if (uv3.Length == 0)
                    {
                        uv3 = new Vector2[vertLength];
                    }

                    for (int i = 0; i < uv3.Length; i++)
                    {
                        uv3[i] = new Vector2(-1, -1);
                    }


                    if (colors.Length == 0)
                    {
                        colors = new Color[vertLength];
                    }

                    for (int i = 0; i < colors.Length; i++)
                    {
                        colors[i] = Color.white;
                    }

                    for (int i = 0; i < vertLength; i++)
                    {
                        vertices[i] = transform.TransformPoint(vertices[i]);
                    }


                    float maxUv = float.MinValue;
                    foreach (RamSpline item in _ramSplines)
                    {
                        if (item.meshFilter != null)
                            ColorMeshVertex(coloringMesh, meshRendererBounds, thresholdDistance, materialPropertyBlock, item.gameObject, item.meshFilter, ref colors, ref uv3, vertLength, ray, vertices, upVector,
                                ref maxUv);
                        else
                            Debug.Log($"RamSpline {item.name} needs to be regenerated");
                    }

                    foreach (LakePolygon item in _lakePolygons)
                    {
                        if (item.meshFilter != null)
                            ColorMeshVertex(coloringMesh, meshRendererBounds, thresholdDistance, materialPropertyBlock, item.gameObject, item.meshFilter, ref colors, ref uv3, vertLength, ray, vertices, upVector,
                                ref maxUv);
                        else
                            Debug.Log($"LakePolygon {item.name} needs to be regenerated");
                    }

                    foreach (Waterfall item in _waterfalls)
                    {
                        if (item.MainMeshFilter != null)
                            ColorMeshVertex(coloringMesh, meshRendererBounds, thresholdDistance, materialPropertyBlock, item.gameObject, item.MainMeshFilter, ref colors, ref uv3, vertLength, ray, vertices, upVector,
                                ref maxUv);
                        else
                            Debug.Log($"Waterfall {item.name} needs to be regenerated", item.gameObject);
                    }


                    for (int i = 0; i < uv3.Length; i++)
                    {
                        if (uv3[i].x == -1)
                            uv3[i].x = maxUv;

                        if (uv3[i].y == -1)
                            uv3[i].y = maxUv;
                    }

                    if (coloringMesh.UseMaterialPropertyBlock)
                        meshRenderer.SetPropertyBlock(materialPropertyBlock);
                    else
                        meshRenderer.SetPropertyBlock(null);


                    mesh.SetUVs(2, maxUv > float.MinValue ? uv3 : null);
                    mesh.colors = colors;
                }

                if (addedMeshCollider)
                    DestroyImmediate(meshColliderGo);

                Physics.queriesHitBackfaces = backFace;
            }
        }

        private static void ColorMeshVertex(MeshColoring coloringMesh, Bounds meshRendererBounds, float thresholdDistance, MaterialPropertyBlock materialPropertyBlock, GameObject splineGameObject,
            MeshFilter splineMeshFilter,
            ref Color[] colors, ref Vector2[] uv3, int vertLength, Ray ray, Vector3[] vertices, Vector3 upVector,
            ref float maxUv)

        {
            Mesh splineMesh = splineMeshFilter.sharedMesh;

            if (splineMesh == null)
            {
                //Debug.LogWarning($"Spline mesh {splineMeshFilter.name} is null. Please regenerate the mesh.", splineMeshFilter.gameObject);
                return;
            }

            MeshRenderer splineMeshRenderer = splineMeshFilter.GetComponent<MeshRenderer>();
            Bounds splineMeshRendererBounds = splineMeshRenderer.bounds;

            if (RamMath.CalculateDistanceBetweenBounds(meshRendererBounds, splineMeshRendererBounds) > thresholdDistance + 0.1f)
                return;


            MeshCollider meshCollider = splineGameObject.AddComponent<MeshCollider>();


            Material splineMaterial = splineMeshRenderer.sharedMaterial;
            //Debug.Log($"{splineMeshFilter.name}");
            Vector2[] hitUv3 = splineMesh.uv3;
            int[] triangles = splineMesh.triangles;

            bool colliderHit = false;
            float dynamicLavaFlow = 0;
            if (splineMaterial != null && splineMaterial.HasProperty(MeshColoring.DynamicFlowID))
                dynamicLavaFlow = splineMaterial.GetFloat(MeshColoring.DynamicFlowID);

            float distanceLerp = 0;
            Collider[] hitColliders = new Collider[1];
            int numColliders = 0;
            for (int i = 0; i < vertLength; i++)
            {
                numColliders = 0;
                ray.origin = vertices[i] + upVector;

                //distance = Vector3.Distance(vertices[i], meshCollider.ClosestPoint(vertices[i]));

                bool hited = meshCollider.Raycast(ray, out RaycastHit hit, 1000);


                if (!hited && thresholdDistance > 0)
                    numColliders = Physics.OverlapSphereNonAlloc(vertices[i], thresholdDistance, hitColliders, coloringMesh.Layer);


                if (hited || numColliders > 0)
                {
                    // if (!hited)
                    //    Debug.Log($"splineMeshFilter {splineMeshFilter.name} hited: {hited} numColliders {numColliders} upVector {upVector}");
                    if (numColliders == 0)
                        distanceLerp = hit.distance / coloringMesh.Threshold;
                    else
                        distanceLerp = 1;


                    colors[i].r = Mathf.Lerp(1, 0, distanceLerp);


                    //Debug.Log($"color {colors[i].r > 0}");
                    if (hitUv3 is not { Length: > 0 } || dynamicLavaFlow == 0 || !hited) continue;

                    //Debug.Log($"{splineMeshFilter.gameObject.name} {dynamicLavaFlow} {hit.triangleIndex}");
                    Vector2 uv3Coord1 = hitUv3[triangles[hit.triangleIndex * 3 + 0]];
                    Vector2 uv3Coord2 = hitUv3[triangles[hit.triangleIndex * 3 + 1]];
                    Vector2 uv3Coord3 = hitUv3[triangles[hit.triangleIndex * 3 + 2]];
                    Vector2 average = (uv3Coord1 + uv3Coord2 + uv3Coord3) / 3.0f;
                    //Debug.Log($"{average.x > 0}");

                    if (maxUv < average.x)
                        maxUv = average.x;

                    // Debug.Log(average);
                    uv3[i] = average;

                    colliderHit = true;
                }

                if (colliderHit)
                    coloringMesh.DynamicLavaFlow = dynamicLavaFlow;
                if (colliderHit && coloringMesh.UseMaterialPropertyBlock && dynamicLavaFlow > 0)
                {
                    coloringMesh.DynamicMaterial = splineMaterial;
                    coloringMesh.DynamicStartPositionOffset = splineMaterial.GetFloat(MeshColoring.DynamicStartPositionOffsetID);
                    coloringMesh.DynamicShapeSpeed = splineMaterial.GetFloat(MeshColoring.DynamicShapeSpeedID);
                    //coloringMesh.DynamicReactionOffset = splineMaterial.GetFloat(MeshColoring.DynamicReactionOffsetID);
                    coloringMesh.DynamicShapeVCurvePower = splineMaterial.GetFloat(MeshColoring.DynamicShapeVCurvePowerID);

                    materialPropertyBlock.SetFloat(MeshColoring.DynamicFlowID, coloringMesh.DynamicLavaFlow);
                    materialPropertyBlock.SetFloat(MeshColoring.DynamicStartPositionOffsetID, coloringMesh.DynamicStartPositionOffset);
                    materialPropertyBlock.SetFloat(MeshColoring.DynamicShapeSpeedID, coloringMesh.DynamicShapeSpeed);
                    materialPropertyBlock.SetFloat(MeshColoring.DynamicReactionOffsetID, coloringMesh.DynamicReactionOffset);
                    materialPropertyBlock.SetFloat(MeshColoring.DynamicShapeVCurvePowerID, coloringMesh.DynamicShapeVCurvePower);
                }
            }

            DestroyImmediate(meshCollider);
        }
    }
}