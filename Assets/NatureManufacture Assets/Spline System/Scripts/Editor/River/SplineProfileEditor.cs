namespace NatureManufacture.RAM.Editor
{
    using UnityEngine;
    using UnityEditor;
    using UnityEngine.Rendering;
#if VEGETATION_STUDIO_PRO
    using AwesomeTechnologies.VegetationSystem;
#endif

    [CustomEditor(typeof(SplineProfile))]
    public class SplineProfileEditor : Editor
    {
        private void OnSceneDrag(SceneView sceneView, int index)
        {
            Event e = Event.current;

            GameObject go = HandleUtility.PickGameObject(e.mousePosition, false);
            if (!go)
                return;

            var ramSpline = go.GetComponent<RamSpline>();


            switch (e.type)
            {
                case EventType.DragUpdated:
                {
                    DragAndDrop.visualMode = ramSpline ? DragAndDropVisualMode.Link : DragAndDropVisualMode.Rejected;

                    e.Use();
                    break;
                }
                case EventType.DragPerform when ramSpline == null:
                    return;
                case EventType.DragPerform:
                {
                    SplineProfile splineProfile = (SplineProfile)DragAndDrop.objectReferences[0];
                    DragAndDrop.visualMode = DragAndDropVisualMode.Link;

                    Undo.RecordObject(ramSpline, "River changed");

                    var ramSplineEditor = (RamSplineEditor)CreateEditor(ramSpline);

                    ramSpline.currentProfile = splineProfile;
                    ramSplineEditor.ResetToProfile();
                    ramSpline.GenerateSpline();
                    EditorUtility.SetDirty(ramSpline);


                    DestroyImmediate(ramSplineEditor);
                    DragAndDrop.AcceptDrag();
                    e.Use();
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            SplineProfile splineProfile = (SplineProfile)target;


            EditorGUI.BeginChangeCheck();
            GUILayout.Label("Basic: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.splineMaterial = (Material)EditorGUILayout.ObjectField("Material", splineProfile.splineMaterial, typeof(Material), false);

            splineProfile.meshCurve = EditorGUILayout.CurveField("Mesh curve", splineProfile.meshCurve);

            EditorGUILayout.LabelField("Vertice distribution: " + splineProfile.minVal + " " + splineProfile.maxVal);
            EditorGUILayout.MinMaxSlider(ref splineProfile.minVal, ref splineProfile.maxVal, 1, 99);
            splineProfile.minVal = (int)splineProfile.minVal;
            splineProfile.maxVal = (int)splineProfile.maxVal;


            splineProfile.triangleDensity = EditorGUILayout.IntSlider("U", (int)(splineProfile.triangleDensity), 1, 100);
            splineProfile.vertsInShape = EditorGUILayout.IntSlider("V", splineProfile.vertsInShape - 1, 1, 20) + 1;
            splineProfile.width = EditorGUILayout.FloatField("River width", splineProfile.width);
            splineProfile.snapMask = LayerMaskField.ShowLayerMaskField("Layers", splineProfile.snapMask, true);


            splineProfile.normalFromRaycast = EditorGUILayout.Toggle("Take Normal from terrain", splineProfile.normalFromRaycast);
            if (splineProfile.normalFromRaycast)
            {
                EditorGUI.indentLevel++;

                splineProfile.NormalFromRaycastPerVertex = EditorGUILayout.Toggle("Per vertex", splineProfile.NormalFromRaycastPerVertex);
                splineProfile.NormalFromRaycastLerp = EditorGUILayout.Slider("Normal from terrain lerp", splineProfile.NormalFromRaycastLerp, 0, 1);

                EditorGUI.indentLevel--;
            }


            splineProfile.uvScale = EditorGUILayout.FloatField("UV scale (texture tiling)", splineProfile.uvScale);
            splineProfile.uvUseFixedTile = EditorGUILayout.Toggle("Use fixed tilling", splineProfile.uvUseFixedTile);
            if (splineProfile.uvUseFixedTile)
                splineProfile.uvFixedTileLerp = EditorGUILayout.Slider("Fixed tilling lerp", splineProfile.uvFixedTileLerp, 0, 1);
            splineProfile.uvRotation = EditorGUILayout.Toggle("Rotate UV", splineProfile.uvRotation);
            EditorGUI.indentLevel--;

            GUILayout.Label("Flow Map Automatic: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.flowFlat = EditorGUILayout.CurveField("Flow curve flat speed", splineProfile.flowFlat);
            splineProfile.flowWaterfall = EditorGUILayout.CurveField("Flow curve waterfall speed", splineProfile.flowWaterfall);

            splineProfile.noiseFlowMap = EditorGUILayout.Toggle("Add noise", splineProfile.noiseFlowMap);
            if (splineProfile.noiseFlowMap)
            {
                EditorGUI.indentLevel++;
                splineProfile.noiseMultiplierFlowMap = EditorGUILayout.FloatField("Noise multiplier inside", splineProfile.noiseMultiplierFlowMap);
                splineProfile.noiseSizeXFlowMap = EditorGUILayout.FloatField("Noise scale X", splineProfile.noiseSizeXFlowMap);
                splineProfile.noiseSizeZFlowMap = EditorGUILayout.FloatField("Noise scale Z", splineProfile.noiseSizeZFlowMap);
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;

            GUILayout.Label("Flow Map Physic: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.floatSpeed = EditorGUILayout.FloatField("River float speed", splineProfile.floatSpeed);
            splineProfile.floatSpeedWaterfallMultiplier = EditorGUILayout.FloatField("Waterfall float speed multiplier", splineProfile.floatSpeedWaterfallMultiplier);
            splineProfile.physicalDensity = EditorGUILayout.FloatField("Physical Density", splineProfile.physicalDensity);
            splineProfile.meshFlowSpeed = EditorGUILayout.FloatField("River flow speed multiplier", splineProfile.meshFlowSpeed);
            EditorGUI.indentLevel--;


            GUILayout.Label("Vertex noise: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.vertexPainterNoiseData.IsNoiseActive = EditorGUILayout.Toggle("Add noise", splineProfile.vertexPainterNoiseData.IsNoiseActive);
            if (splineProfile.vertexPainterNoiseData.IsNoiseActive)
            {
                EditorGUI.indentLevel++;
                splineProfile.vertexPainterNoiseData.Multiplier = EditorGUILayout.FloatField("Noise multiplier", splineProfile.vertexPainterNoiseData.Multiplier);
                splineProfile.vertexPainterNoiseData.SizeX = EditorGUILayout.FloatField("Noise scale X", splineProfile.vertexPainterNoiseData.SizeX);
                splineProfile.vertexPainterNoiseData.SizeZ = EditorGUILayout.FloatField("Noise scale Z", splineProfile.vertexPainterNoiseData.SizeZ);
                splineProfile.vertexPainterNoiseData.SlopeCurve = EditorGUILayout.CurveField("Slope curve", splineProfile.vertexPainterNoiseData.SlopeCurve);
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;


            GUILayout.Label("River simulation:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.simulatedRiverLength = EditorGUILayout.FloatField("Simulation length", splineProfile.simulatedRiverLength);
            if (splineProfile.simulatedRiverLength < 1)
                splineProfile.simulatedRiverLength = 1;
            splineProfile.simulatedRiverPoints = EditorGUILayout.IntSlider("Simulation points interval", splineProfile.simulatedRiverPoints, 1, 100);
            splineProfile.simulatedMinStepSize = EditorGUILayout.Slider("Simulation sampling interval", splineProfile.simulatedMinStepSize, 0.5f, 5);
            splineProfile.simulatedNoUp = EditorGUILayout.Toggle("Simulation block uphill", splineProfile.simulatedNoUp);
            splineProfile.simulatedBreakOnUp = EditorGUILayout.Toggle("Simulation break on uphill", splineProfile.simulatedBreakOnUp);

            splineProfile.noiseWidth = EditorGUILayout.Toggle("Add width noise", splineProfile.noiseWidth);
            if (splineProfile.noiseWidth)
            {
                EditorGUI.indentLevel++;
                splineProfile.noiseMultiplierWidth = EditorGUILayout.FloatField("Noise Multiplier Width", splineProfile.noiseMultiplierWidth);
                splineProfile.noiseSizeWidth = EditorGUILayout.FloatField("Noise Scale Width", splineProfile.noiseSizeWidth);
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;

            GUILayout.Label("Lightning settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.receiveShadows = EditorGUILayout.Toggle("Receive Shadows", splineProfile.receiveShadows);

            splineProfile.shadowCastingMode = (ShadowCastingMode)EditorGUILayout.EnumPopup("Shadow Casting Mode", splineProfile.shadowCastingMode);
            EditorGUI.indentLevel--;

            EditorGUILayout.Space();
            GUILayout.Label("Terrain settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.PainterData = (TerrainPainterData)EditorGUILayout.ObjectField("Terrain Painter Data", splineProfile.PainterData, typeof(TerrainPainterData), false);

            EditorGUI.indentLevel--;
            EditorGUILayout.Space();
            EditorUtility.SetDirty(target);
#if VEGETATION_STUDIO_PRO
            GUILayout.Label("Vegetation stuio pro:", EditorStyles.boldLabel);
            splineProfile.biomeType = System.Convert.ToInt32(EditorGUILayout.EnumPopup("Select biome", (BiomeType) splineProfile.biomeType));
#else
            GUILayout.Label("Vegetation studio pro:", EditorStyles.boldLabel);
            splineProfile.biomeType = EditorGUILayout.IntField("Select biome", splineProfile.biomeType);
#endif
            EditorGUILayout.Space();
            GUILayout.Label("Vertex Color Automatic: ", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            splineProfile.redColorCurve = EditorGUILayout.CurveField("Red color curve", splineProfile.redColorCurve);
            splineProfile.greenColorCurve = EditorGUILayout.CurveField("Green color curve", splineProfile.greenColorCurve);
            splineProfile.blueColorCurve = EditorGUILayout.CurveField("Blue color curve", splineProfile.blueColorCurve);
            splineProfile.alphaColorCurve = EditorGUILayout.CurveField("Alpha color curve", splineProfile.alphaColorCurve);
            EditorGUI.indentLevel--;
            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(splineProfile, "Spline profile changed");
            }
        }
    }
}