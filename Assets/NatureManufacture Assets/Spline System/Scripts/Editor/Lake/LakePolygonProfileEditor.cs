namespace NatureManufacture.RAM.Editor
{
    using UnityEngine;
    using UnityEngine.Rendering;
    using UnityEditor;

#if VEGETATION_STUDIO_PRO
using AwesomeTechnologies.VegetationSystem;
#endif

    [CustomEditor(typeof(LakePolygonProfile))]
    public class LakePolygonProfileEditor : Editor
    {
        private void OnSceneDrag(SceneView sceneView, int index)
        {
            Event e = Event.current;

            GameObject go = HandleUtility.PickGameObject(e.mousePosition, false);
            if (!go)
                return;

            var lakePolygon = go.GetComponent<LakePolygon>();

            switch (e.type)
            {
                case EventType.DragUpdated:
                {
                    DragAndDrop.visualMode = lakePolygon ? DragAndDropVisualMode.Link : DragAndDropVisualMode.Rejected;
                    e.Use();
                    break;
                }
                case EventType.DragPerform when lakePolygon == null:
                    return;
                case EventType.DragPerform:
                {
                    LakePolygonProfile lakePolygonProfile = (LakePolygonProfile)DragAndDrop.objectReferences[0];

                    DragAndDrop.visualMode = DragAndDropVisualMode.Copy;

                    Undo.RecordObject(lakePolygon, "Lake changed");
                    var lakePolygonEditor = (LakePolygonEditor)CreateEditor(lakePolygon);

                    lakePolygon.currentProfile = lakePolygonProfile;
                    lakePolygonEditor.ResetToProfile();
                    lakePolygon.GeneratePolygon();
                    EditorUtility.SetDirty(lakePolygon);

                    DestroyImmediate(lakePolygonEditor);

                    DragAndDrop.AcceptDrag();
                    e.Use();
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginChangeCheck();

            LakePolygonProfile lakePolygonProfile = (LakePolygonProfile)target;
            GUILayout.Label("Basic: ", EditorStyles.boldLabel);
            lakePolygonProfile.lakeMaterial = (Material)EditorGUILayout.ObjectField("Material", lakePolygonProfile.lakeMaterial, typeof(Material), false);

            GUILayout.Label("Mesh settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;

            lakePolygonProfile.maximumTriangleAmount = EditorGUILayout.FloatField("Maximum triangle amount", lakePolygonProfile.maximumTriangleAmount);
            lakePolygonProfile.maximumTriangleSize = EditorGUILayout.FloatField("Maximum triangle size", lakePolygonProfile.maximumTriangleSize);
            lakePolygonProfile.triangleDensity = (float)EditorGUILayout.IntSlider("Spline density", (int)(lakePolygonProfile.triangleDensity), 1, 100);
            lakePolygonProfile.uvScale = EditorGUILayout.FloatField("UV scale", lakePolygonProfile.uvScale);
            lakePolygonProfile.snapMask = LayerMaskField.ShowLayerMaskField("Layers", lakePolygonProfile.snapMask, true);
            lakePolygonProfile.NormalFromRaycast = EditorGUILayout.Toggle("Take Normal from terrain", lakePolygonProfile.NormalFromRaycast);
            if (lakePolygonProfile.NormalFromRaycast)
            {
                EditorGUI.indentLevel++;
                lakePolygonProfile.NormalFromRaycastLerp = EditorGUILayout.Slider("Normal from terrain lerp", lakePolygonProfile.NormalFromRaycastLerp, 0, 1);
                EditorGUI.indentLevel--;
            }
            
             EditorGUILayout.Space();
            lakePolygonProfile.depthEnabled = EditorGUILayout.Toggle("Depth", lakePolygonProfile.depthEnabled);

            if (lakePolygonProfile.depthEnabled)
            {
                EditorGUI.indentLevel++;
                lakePolygonProfile.depthCurve = EditorGUILayout.CurveField("Depth curve", lakePolygonProfile.depthCurve);
                lakePolygonProfile.waveCurve = EditorGUILayout.CurveField("Wave curve", lakePolygonProfile.waveCurve);
                EditorGUI.indentLevel++;
                lakePolygonProfile.depthSmoothAmount = EditorGUILayout.IntSlider("Smooth amount", lakePolygonProfile.depthSmoothAmount, 0, 100);
                EditorGUI.indentLevel--;

                EditorGUILayout.LabelField("Directional map");

                EditorGUI.indentLevel++;
                //lakePolygonProfile.automaticDirectionalMapSmoothAmount = Mathf.CeilToInt(700 / lakePolygonProfile.maximumTriangleSize);
                lakePolygonProfile.automaticDirectionalMapSmoothAmount=  EditorGUILayout.IntSlider("Smooth amount", lakePolygonProfile.automaticDirectionalMapSmoothAmount, 0, 100);
                EditorGUI.indentLevel++;
                lakePolygonProfile.smoothDistance = EditorGUILayout.Toggle("Smooth distance", lakePolygonProfile.smoothDistance);
                EditorGUI.indentLevel--;

                //lakePolygonProfile.directionalAngleCurve = EditorGUILayout.CurveField("Directional angle curve", lakePolygonProfile.directionalAngleCurve);
                lakePolygonProfile.directionalMapRaysAngle = EditorGUILayout.IntSlider("Rays angle", lakePolygonProfile.directionalMapRaysAngle, 90, 360);
                lakePolygonProfile.directionalMapRaysAmount = EditorGUILayout.IntSlider("Rays amount", lakePolygonProfile.directionalMapRaysAmount, 1, 60);

                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
            }
            
            
            

            GUILayout.Label("Flow Map Automatic: ", EditorStyles.boldLabel);
            lakePolygonProfile.automaticFlowMapScale = EditorGUILayout.FloatField("Automatic speed", lakePolygonProfile.automaticFlowMapScale);
            lakePolygonProfile.noiseFlowMap = EditorGUILayout.Toggle("Add noise", lakePolygonProfile.noiseFlowMap);
            if (lakePolygonProfile.noiseFlowMap)
            {
                EditorGUI.indentLevel++;
                lakePolygonProfile.noiseMultiplierFlowMap = EditorGUILayout.FloatField("Noise multiplier inside", lakePolygonProfile.noiseMultiplierFlowMap);
                lakePolygonProfile.noiseSizeXFlowMap = EditorGUILayout.FloatField("Noise scale X", lakePolygonProfile.noiseSizeXFlowMap);
                lakePolygonProfile.noiseSizeZFlowMap = EditorGUILayout.FloatField("Noise scale Z", lakePolygonProfile.noiseSizeZFlowMap);
                EditorGUI.indentLevel--;
            }

            lakePolygonProfile.floatSpeed = EditorGUILayout.FloatField("Float speed", lakePolygonProfile.floatSpeed);
            lakePolygonProfile.physicalDensity = EditorGUILayout.FloatField("Physical density", lakePolygonProfile.physicalDensity);

            GUILayout.Label("Lightning settings:", EditorStyles.boldLabel);

            EditorGUI.indentLevel++;
            lakePolygonProfile.receiveShadows = EditorGUILayout.Toggle("Receive Shadows", lakePolygonProfile.receiveShadows);

            lakePolygonProfile.shadowCastingMode = (ShadowCastingMode)EditorGUILayout.EnumPopup("Shadow Casting Mode", lakePolygonProfile.shadowCastingMode);
            EditorGUI.indentLevel--;

            EditorGUILayout.Space();
            GUILayout.Label("Terrain settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            lakePolygonProfile.PainterData = (TerrainPainterData)EditorGUILayout.ObjectField("Terrain Painter Data", lakePolygonProfile.PainterData, typeof(TerrainPainterData), false);

            EditorGUI.indentLevel--;

#if VEGETATION_STUDIO_PRO
           GUILayout.Label("Vegetation studio pro:", EditorStyles.boldLabel);
           lakePolygonProfile.biomeType = System.Convert.ToInt32(EditorGUILayout.EnumPopup("Select biome", (BiomeType)lakePolygonProfile.biomeType));
#else
            GUILayout.Label("Vegetation studio:", EditorStyles.boldLabel);
            lakePolygonProfile.biomeType = EditorGUILayout.IntField("Select biome", lakePolygonProfile.biomeType);
#endif
            EditorGUILayout.Space();
            GUILayout.Label("Vertex Color Automatic: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            lakePolygonProfile.redColorCurve = EditorGUILayout.CurveField("Red color curve", lakePolygonProfile.redColorCurve);
            lakePolygonProfile.greenColorCurve = EditorGUILayout.CurveField("Green color curve", lakePolygonProfile.greenColorCurve);
            lakePolygonProfile.blueColorCurve = EditorGUILayout.CurveField("Blue color curve", lakePolygonProfile.blueColorCurve);
            lakePolygonProfile.alphaColorCurve = EditorGUILayout.CurveField("Alpha color curve", lakePolygonProfile.alphaColorCurve);
            EditorGUI.indentLevel--;

            if (EditorGUI.EndChangeCheck())
            {
                EditorUtility.SetDirty(lakePolygonProfile);
                // AssetDatabase.Refresh();
            }
        }
    }
}