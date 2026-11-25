using System;
using System.Collections.Generic;
using UnityEditorInternal;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;
    using UnityEngine.Rendering;


    [CustomEditor(typeof(LakePolygon))]
    public sealed class LakePolygonEditor : Editor
    {
        private bool _dragged;

        private LakePolygon _lakePolygon;


        private TerrainManagerEditor TerrainManagerEditor { get; set; }
        private NmSplineManager NmSplineManager { get; set; }

        private LakePolygonTips LakePolygonTips { get; } = new();

        private VertexPainterEditor<LakePolygon> VertexPainterEditor { get; set; }

        private LakeDebug LakeDebug { get; set; }


        public string[] toolbarStrings = new[]
        {
            "Basic",
            "Points",
            "Mesh Painting",
            "Simulate",
            "Terrain",
            "File Points",
            "Tips",
            "Manual",
            "Video Tutorials",
            "Debug"
#if VEGETATION_STUDIO
        ,
        "Vegetation Studio"
#endif
#if VEGETATION_STUDIO_PRO
        ,
        "Vegetation Studio Pro"
#endif
        };


        private LakePolygonVegetationStudio _lakePolygonVegetationStudio;
        private ReorderableList reorderableList;

        [MenuItem("GameObject/3D Object/NatureManufacture/Create Lake Polygon")]
        public static void CreateLakePolygon()
        {
            Selection.activeGameObject = LakePolygonFactory
                .CreatePolygon(AssetDatabase.GetBuiltinExtraResource<Material>("Default-Diffuse.mat")).gameObject;
        }

        private void OnEnable()
        {
            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;

            PrepareHoleList();

            LakeDebug ??= new LakeDebug(_lakePolygon);

            if (VertexPainterEditor == null)
            {
                VertexPainterEditor = new VertexPainterEditor<LakePolygon>(_lakePolygon.VertexPainterData);
                VertexPainterEditor.OnResetDrawing.AddListener(RegeneratePolygon);
                VertexPainterEditor.OnFinishedDrawing.AddListener(FinishedVertexDrawing);
                VertexPainterEditor.ColorDescriptions = "R - Slow Water \nG - Small Cascade \nB - Big Cascade \nA - Opacity";
            }

            _lakePolygonVegetationStudio ??= new LakePolygonVegetationStudio(_lakePolygon);


            //Debug.Log("NmSplineEditor");
            if (NmSplineManager == null)
            {
                NmSplineManager = new NmSplineManager(_lakePolygon.NmSpline, "Lake");
                _lakePolygon.NmSpline.NmSplineChanged.AddListener(PositionMoved);
                //NmSplineEditor.AdditionalPointUI += PointGUI;
            }


            if (TerrainManagerEditor == null)
            {
                if (_lakePolygon.RamTerrainManager.NmSpline != _lakePolygon.NmSpline)
                    _lakePolygon.RamTerrainManager.NmSpline = _lakePolygon.NmSpline;
                TerrainManagerEditor = new TerrainManagerEditor(_lakePolygon.RamTerrainManager, _lakePolygon);
                TerrainManagerEditor.GetTerrains.AddListener(() => _lakePolygon.GeneratePolygon());
            }

            if (_lakePolygon.BaseProfile == null)
            {
                _lakePolygon.GenerateBaseProfile();
            }

            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            SceneView.duringSceneGui += OnSceneGUIInvoke;


            _lakePolygon.MoveControlPointsToMainControlPoints();
            // _lakePolygon.GeneratePolygon();
        }

        private void PrepareHoleList()
        {
            SerializedProperty lakeHolesProperty = serializedObject.FindProperty("lakeHoles");
            reorderableList = new ReorderableList(serializedObject, lakeHolesProperty, true, true, true, true)
            {
                drawHeaderCallback = (Rect rect) => { EditorGUI.LabelField(rect, "Lake Holes"); },
                drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
                {
                    SerializedProperty element = reorderableList.serializedProperty.GetArrayElementAtIndex(index);
                    rect.y += 2;
                    EditorGUI.PropertyField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), element, GUIContent.none);
                }
            };
        }

        private void OnDisable()
        {
            SceneView.duringSceneGui -= OnSceneGUIInvoke;

            if (!(_lakePolygon != null))
                return;

            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;

            if (_lakePolygon.meshTerrainGOs is { Count: > 0 })
            {
                foreach (GameObject item in _lakePolygon.meshTerrainGOs)
                {
                    DestroyImmediate(item);
                }

                _lakePolygon.meshTerrainGOs.Clear();
            }

            _lakePolygon.NmSpline.NmSplineChanged.RemoveListener(PositionMoved);

            if (VertexPainterEditor != null)
            {
                VertexPainterEditor.OnResetDrawing.RemoveListener(RegeneratePolygon);
                VertexPainterEditor.OnFinishedDrawing.RemoveListener(FinishedVertexDrawing);
            }


            //Debug.Log("//////////////////////////OnDisable////////////////////");
        }


        private void OnDestroy()
        {
            if (!(_lakePolygon != null))
                return;
            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;
            if (_lakePolygon.meshTerrainGOs is { Count: > 0 })
            {
                foreach (GameObject item in _lakePolygon.meshTerrainGOs)
                {
                    DestroyImmediate(item);
                }

                _lakePolygon.meshTerrainGOs.Clear();
            }
        }

        private void FinishedVertexDrawing()
        {
            if (VertexPainterEditor.VertexHeightChanged)
                _lakePolygon.GeneratePolygon();

            VertexPainterEditor.ResetFinished();
        }


        public override void OnInspectorGUI()
        {
            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;

            LakeDebug ??= new LakeDebug(_lakePolygon);

            _lakePolygon.canGenerateLod = true;
            EditorGUILayout.Space();
            LogoRamUi.UILogo();


            toolbarStrings[9] = _lakePolygon.ShowDebug ? "Debug [ON]" : "Debug [OFF]";

            int toolbarNew = GUILayout.SelectionGrid(_lakePolygon.toolbarInt, toolbarStrings, 3, GUILayout.Height(125));


            if (_lakePolygon.transform.eulerAngles.magnitude != 0 || _lakePolygon.transform.localScale.x != 1 ||
                _lakePolygon.transform.localScale.y != 1 || _lakePolygon.transform.localScale.z != 1)
                EditorGUILayout.HelpBox("Lake should have scale (1,1,1) and rotation (0,0,0) during edit!",
                    MessageType.Error);


            if (toolbarNew == 0)
            {
                UIBaseSettings();
            }


            if (toolbarNew == 1)
            {
                NmSplineManager.PointsUI();
            }

            if (_lakePolygon.toolbarInt != toolbarNew)
            {
                if (toolbarNew == 2)
                {
                    _lakePolygon.canGenerateLod = false;
                    _lakePolygon.GeneratePolygon();
                    VertexPainterEditor.GetMeshFilters(_lakePolygon.gameObject);
                }
                else if (_lakePolygon.toolbarInt == 2)
                {
                    _lakePolygon.canGenerateLod = true;
                    _lakePolygon.GeneratePolygon();
                    VertexPainterEditor.ResetOldMaterials();
                }
            }

            if (toolbarNew == 2)
            {
                _lakePolygon.canGenerateLod = false;
                VertexPainterEditor.UIPainter();


                switch (VertexPainterEditor.VertexPainterData.ToolbarInt)
                {
                    case 0:
                        UIAutomaticPaint();
                        break;

                    case 1:
                        UIAutomaticFlowMap();
                        break;
                }
            }

            if (_lakePolygon.toolbarInt == 3)
            {
                UISimulation();
            }


            if (toolbarNew == 4)
            {
                if (_lakePolygon.toolbarInt != toolbarNew)
                {
                    if (_lakePolygon.RamTerrainManager != null && _lakePolygon.RamTerrainManager.BasePainterData && _lakePolygon.RamTerrainManager.BasePainterData.WorkTerrain == null)
                    {
                        _lakePolygon.GeneratePolygon();
                    }
                }

                TerrainManagerEditor.UITerrain();
            }

            if (_lakePolygon.toolbarInt == 5)
            {
                FilesManager();
            }

            if (toolbarNew == 6)
            {
                LakePolygonTips.Tips();
            }

            if (toolbarNew == 7)
            {
                toolbarNew = _lakePolygon.toolbarInt;
                string[] guids1 = AssetDatabase.FindAssets("River and Lava 3 Manual");
                Application.OpenURL("file:///" + Application.dataPath.Replace("Assets", "") +
                                    AssetDatabase.GUIDToAssetPath(guids1[0]));
            }

            if (toolbarNew == 8)
            {
                toolbarNew = _lakePolygon.toolbarInt;
                Application.OpenURL("https://www.youtube.com/playlist?list=PLWMxYDHySK5MyWZsMYWSRtpn1glwcS99x");
            }


            if (toolbarNew == 9)
            {
                LakeDebug.DebugOptions();
            }

#if VEGETATION_STUDIO || VEGETATION_STUDIO_PRO
            if (toolbarNew == 10)
            {
                _lakePolygonVegetationStudio.UIVegetationStudio();
            }
#endif


            _lakePolygon.toolbarInt = toolbarNew;


            EditorGUILayout.Space();
        }

        private void UIAutomaticPaint()
        {
            EditorGUILayout.Space();

            EditorGUI.BeginChangeCheck();
            GUILayout.Label("Vertex Color Automatic: ", EditorStyles.boldLabel);

            _lakePolygon.BaseProfile.redColorCurve = EditorGUILayout.CurveField("Red color curve", _lakePolygon.BaseProfile.redColorCurve);
            _lakePolygon.BaseProfile.greenColorCurve = EditorGUILayout.CurveField("Green color curve", _lakePolygon.BaseProfile.greenColorCurve);
            _lakePolygon.BaseProfile.blueColorCurve = EditorGUILayout.CurveField("Blue color curve", _lakePolygon.BaseProfile.blueColorCurve);
            _lakePolygon.BaseProfile.alphaColorCurve = EditorGUILayout.CurveField("Alpha color curve", _lakePolygon.BaseProfile.alphaColorCurve);


            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_lakePolygon, "Lake changed");
                _lakePolygon.GeneratePolygon();
            }
        }

        private void UIAutomaticFlowMap()
        {
            EditorGUILayout.Space();

            EditorGUI.BeginChangeCheck();
            GUILayout.Label("Flow Map Automatic: ", EditorStyles.boldLabel);
            _lakePolygon.BaseProfile.automaticFlowmapType =
                (LakePolygonProfile.FlowmapType)EditorGUILayout.EnumPopup("Flowmap type", _lakePolygon.BaseProfile.automaticFlowmapType);

            _lakePolygon.BaseProfile.automaticFlowMapScale = EditorGUILayout.DelayedFloatField("Automatic speed", _lakePolygon.BaseProfile.automaticFlowMapScale);

            //switch baseprofile automatic flowmap type
            switch (_lakePolygon.BaseProfile.automaticFlowmapType)
            {
                case LakePolygonProfile.FlowmapType.Central:
                    _lakePolygon.BaseProfile.automaticFlowMapDistance = EditorGUILayout.DelayedFloatField("Automatic distance", _lakePolygon.BaseProfile.automaticFlowMapDistance);
                    _lakePolygon.BaseProfile.automaticFlowMapDistanceBlend = EditorGUILayout.DelayedFloatField("Automatic distance blend", _lakePolygon.BaseProfile.automaticFlowMapDistanceBlend);
                    _lakePolygon.BaseProfile.automaticFlowMapSmooth = EditorGUILayout.Toggle("Automatic smooth", _lakePolygon.BaseProfile.automaticFlowMapSmooth);
                    if (_lakePolygon.BaseProfile.automaticFlowMapSmooth)
                        _lakePolygon.BaseProfile.automaticFlowMapSmoothAmount = EditorGUILayout.IntSlider("Smooth amount", _lakePolygon.BaseProfile.automaticFlowMapSmoothAmount, 1, 100);
                    break;
                case LakePolygonProfile.FlowmapType.Directional:
                    _lakePolygon.BaseProfile.automaticFlowmapDirection = EditorGUILayout.Vector2Field("Direction", _lakePolygon.BaseProfile.automaticFlowmapDirection);
                    break;
                default:
                    Debug.Log($"Wrong flowmap type {_lakePolygon.BaseProfile.automaticFlowmapType}");
                    break;
            }


            _lakePolygon.BaseProfile.noiseFlowMap = EditorGUILayout.Toggle("Add noise", _lakePolygon.BaseProfile.noiseFlowMap);
            if (_lakePolygon.BaseProfile.noiseFlowMap)
            {
                EditorGUI.indentLevel++;
                _lakePolygon.BaseProfile.noiseMultiplierFlowMap =
                    EditorGUILayout.FloatField("Noise multiplier inside", _lakePolygon.BaseProfile.noiseMultiplierFlowMap);
                _lakePolygon.BaseProfile.noiseSizeXFlowMap = EditorGUILayout.FloatField("Noise scale X", _lakePolygon.BaseProfile.noiseSizeXFlowMap);
                _lakePolygon.BaseProfile.noiseSizeZFlowMap = EditorGUILayout.FloatField("Noise scale Z", _lakePolygon.BaseProfile.noiseSizeZFlowMap);
                EditorGUI.indentLevel--;
            }


            EditorGUILayout.Space();
            GUILayout.Label("Flow Map Physic: ", EditorStyles.boldLabel);
            _lakePolygon.BaseProfile.floatSpeed = EditorGUILayout.FloatField("Float speed", _lakePolygon.BaseProfile.floatSpeed);
            _lakePolygon.BaseProfile.physicalDensity = EditorGUILayout.FloatField("Physical density", _lakePolygon.BaseProfile.physicalDensity);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_lakePolygon, "Lake changed");
                _lakePolygon.GeneratePolygon();
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("Generate polygon"))
            {
                _lakePolygon.GeneratePolygon();
            }
        }

        private void UISimulation()
        {
            EditorGUILayout.HelpBox("\nSet 1 point and R.A.M will generate lake.\n", MessageType.Info);
            EditorGUILayout.Space();
            _lakePolygon.angleSimulation = EditorGUILayout.IntSlider("Angle", _lakePolygon.angleSimulation, 1, 180);
            _lakePolygon.closeDistanceSimulation = EditorGUILayout.FloatField("Point distance", _lakePolygon.closeDistanceSimulation);
            _lakePolygon.checkDistanceSimulation = EditorGUILayout.FloatField("Check distance", _lakePolygon.checkDistanceSimulation);
            _lakePolygon.depthOffsetSimulation = EditorGUILayout.FloatField("Depth offset", _lakePolygon.depthOffsetSimulation);
            _lakePolygon.removeFirstPointSimulation = EditorGUILayout.Toggle("Remove first point", _lakePolygon.removeFirstPointSimulation);


            EditorGUILayout.Space();
            if (_lakePolygon.NmSpline.MainControlPoints.Count == 0)
            {
                EditorGUILayout.HelpBox("Set 1 point and R.A.M will generate lake.", MessageType.Warning);
                GUI.enabled = false;
            }


            if (GUILayout.Button("Simulate"))
            {
                LakePolygonSimulationGenerator.Simulation(_lakePolygon);
            }


            if (GUILayout.Button(_lakePolygon.LastGenerationPoint != null ? "Restore generation point" : "Remove points except first"))
            {
                LakePolygonSimulationGenerator.RemoveAllPoints(_lakePolygon, true);
            }

            // if (GUILayout.Button("Remove all points"))
            // {
            //     LakePolygonSimulationGenerator.RemoveAllPoints(_lakePolygon);
            // }

            GUI.enabled = true;
        }


        private void UIBaseSettings()
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox("Add Point  - CTRL + Left Mouse Button Click \n" +
                                    "Add point between existing points - SHIFT + Left Button Click \n" +
                                    "Remove point - CTRL + SHIFT + Left Button Click", MessageType.Info);
            EditorGUILayout.Space();


            ProfileManage();


            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUI.BeginChangeCheck();

            Undo.RecordObject(_lakePolygon, "Lake changed");

            _lakePolygon.lockHeight = EditorGUILayout.Toggle("Lock height", _lakePolygon.lockHeight);

            EditorGUILayout.BeginHorizontal();
            _lakePolygon.height = EditorGUILayout.FloatField(_lakePolygon.height);
            if (GUILayout.Button("Set heights"))
            {
                for (int i = 0; i < _lakePolygon.NmSpline.MainControlPoints.Count; i++)
                {
                    Vector4 point = _lakePolygon.NmSpline.MainControlPoints[i].position;
                    point.y = _lakePolygon.height - _lakePolygon.transform.position.y;
                    _lakePolygon.NmSpline.MainControlPoints[i].position = point;
                }

                _lakePolygon.GeneratePolygon();
            }

            EditorGUILayout.EndHorizontal();

            _lakePolygon.yOffset = EditorGUILayout.DelayedFloatField("Y offset mesh", _lakePolygon.yOffset);
            EditorGUI.indentLevel--;
            EditorGUILayout.Space();


            GUILayout.Label("Mesh settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUI.indentLevel++;
            string meshResolution = "Triangles density" + "(" + _lakePolygon.trianglesGenerated + " tris)";

            EditorGUILayout.LabelField(meshResolution);

            if (_lakePolygon.vertsGenerated > 65000)
            {
                EditorGUILayout.HelpBox(
                    "Too many vertices for 16 bit mesh index buffer.  Mesh switched to 32 bit index buffer.",
                    MessageType.Warning);
            }


            _lakePolygon.BaseProfile.maximumTriangleAmount =
                EditorGUILayout.DelayedFloatField("Maximum triangle amount", _lakePolygon.BaseProfile.maximumTriangleAmount);
            if (_lakePolygon.BaseProfile.maximumTriangleAmount == 0)
                _lakePolygon.BaseProfile.maximumTriangleAmount = 50;
            _lakePolygon.BaseProfile.maximumTriangleSize =
                EditorGUILayout.DelayedFloatField("Maximum triangle size", _lakePolygon.BaseProfile.maximumTriangleSize);
            if (_lakePolygon.BaseProfile.maximumTriangleSize == 0)
                _lakePolygon.BaseProfile.maximumTriangleSize = 10;


            if (_lakePolygon.TriangleSizeByLimit > 0 && _lakePolygon.BaseProfile.maximumTriangleSize < _lakePolygon.TriangleSizeByLimit)
            {
                EditorGUILayout.HelpBox("Triangle size too small for triangle limit", MessageType.Warning);
            }


            _lakePolygon.BaseProfile.triangleDensity = EditorGUILayout.IntSlider("Spline density",
                (int)(_lakePolygon.BaseProfile.triangleDensity), 1, 100);
            _lakePolygon.BaseProfile.uvScale = EditorGUILayout.FloatField("UV scale", _lakePolygon.BaseProfile.uvScale);


            EditorGUILayout.Space();
            _lakePolygon.BaseProfile.depthEnabled = EditorGUILayout.Toggle("Depth", _lakePolygon.BaseProfile.depthEnabled);

            if (_lakePolygon.BaseProfile.depthEnabled)
            {
                EditorGUI.indentLevel++;
                _lakePolygon.BaseProfile.depthCurve = EditorGUILayout.CurveField("Depth curve", _lakePolygon.BaseProfile.depthCurve);
                _lakePolygon.BaseProfile.waveCurve = EditorGUILayout.CurveField("Wave curve", _lakePolygon.BaseProfile.waveCurve);
                EditorGUI.indentLevel++;
                _lakePolygon.BaseProfile.depthSmoothAmount = EditorGUILayout.IntSlider("Smooth amount", _lakePolygon.BaseProfile.depthSmoothAmount, 0, 100);
                EditorGUI.indentLevel--;

                EditorGUILayout.LabelField("Directional map");

                EditorGUI.indentLevel++;
                //_lakePolygon.BaseProfile.automaticDirectionalMapSmoothAmount = Mathf.CeilToInt(700 / _lakePolygon.BaseProfile.maximumTriangleSize);
                _lakePolygon.BaseProfile.automaticDirectionalMapSmoothAmount=  EditorGUILayout.IntSlider("Smooth amount", _lakePolygon.BaseProfile.automaticDirectionalMapSmoothAmount, 0, 100);
                EditorGUI.indentLevel++;
                _lakePolygon.BaseProfile.smoothDistance = EditorGUILayout.Toggle("Smooth distance", _lakePolygon.BaseProfile.smoothDistance);
                EditorGUI.indentLevel--;

                //_lakePolygon.BaseProfile.directionalAngleCurve = EditorGUILayout.CurveField("Directional angle curve", _lakePolygon.BaseProfile.directionalAngleCurve);
                _lakePolygon.BaseProfile.directionalMapRaysAngle = EditorGUILayout.IntSlider("Rays angle", _lakePolygon.BaseProfile.directionalMapRaysAngle, 90, 360);
                _lakePolygon.BaseProfile.directionalMapRaysAmount = EditorGUILayout.IntSlider("Rays amount", _lakePolygon.BaseProfile.directionalMapRaysAmount, 1, 60);

                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;

            EditorGUILayout.Space();
            serializedObject.Update();
            reorderableList.DoLayoutList();
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();


            if (GUILayout.Button(_lakePolygon.snapToTerrain ? "Unsnap mesh to terrain" : "Snap mesh to terrain"))
            {
                _lakePolygon.snapToTerrain = !_lakePolygon.snapToTerrain;
            }

            EditorGUI.indentLevel++;
            //spline.snapMask = EditorGUILayout.MaskField ("Layers", spline.snapMask, InternalEditorUtility.layers);
            _lakePolygon.BaseProfile.snapMask = LayerMaskField.ShowLayerMaskField("Layers", _lakePolygon.BaseProfile.snapMask, true);

            _lakePolygon.BaseProfile.NormalFromRaycast =
                EditorGUILayout.Toggle("Take Normal from terrain", _lakePolygon.BaseProfile.NormalFromRaycast);
            if (_lakePolygon.BaseProfile.NormalFromRaycast)
            {
                EditorGUI.indentLevel++;
                _lakePolygon.BaseProfile.NormalFromRaycastLerp = EditorGUILayout.Slider("Normal from terrain lerp", _lakePolygon.BaseProfile.NormalFromRaycastLerp, 0, 1);
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;


            EditorGUILayout.Space();
            GUILayout.Label("Lightning settings:", EditorStyles.boldLabel);

            EditorGUI.indentLevel++;
            _lakePolygon.BaseProfile.receiveShadows = EditorGUILayout.Toggle("Receive Shadows", _lakePolygon.BaseProfile.receiveShadows);

            _lakePolygon.BaseProfile.shadowCastingMode =
                (ShadowCastingMode)EditorGUILayout.EnumPopup("Shadow Casting Mode", _lakePolygon.BaseProfile.shadowCastingMode);
            EditorGUI.indentLevel--;


            EditorGUILayout.Space();
            GUILayout.Label("Optimization:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            _lakePolygon.generateMeshParts = EditorGUILayout.Toggle("Split mesh into submeshes", _lakePolygon.generateMeshParts);
            EditorGUI.indentLevel++;
            if (_lakePolygon.generateMeshParts)
                _lakePolygon.meshPartsCount = EditorGUILayout.IntSlider("Parts", _lakePolygon.meshPartsCount, 2, 100);
            EditorGUI.indentLevel--;
            _lakePolygon.GenerateLod = EditorGUILayout.Toggle("Generate lod system", _lakePolygon.GenerateLod);
            if (_lakePolygon.GenerateLod)
            {
                EditorGUI.indentLevel++;
                _lakePolygon.generateLodGPU = EditorGUILayout.Toggle("GPU system (Preview)", _lakePolygon.generateLodGPU);

                EditorGUILayout.LabelField("Distances");
                EditorGUI.indentLevel++;
                float lod0 = EditorGUILayout.FloatField("LOD0:", _lakePolygon.lodDistance[3]);
                float lod1 = EditorGUILayout.FloatField("LOD1:", _lakePolygon.lodDistance[2]);
                float lod2 = EditorGUILayout.FloatField("LOD2:", _lakePolygon.lodDistance[1]);
                float lod3 = EditorGUILayout.FloatField("LOD3:", _lakePolygon.lodDistance[0]);
                _lakePolygon.lodDistance[3] = lod0;
                _lakePolygon.lodDistance[2] = lod1;
                _lakePolygon.lodDistance[1] = lod2;
                _lakePolygon.lodDistance[0] = lod3;
                EditorGUI.indentLevel--;

                // _lakePolygon.lodDistance = EditorGUILayout.Vector3Field("Distances", _lakePolygon.lodDistance);
                _lakePolygon.lodRefreshTime = EditorGUILayout.DelayedFloatField("Refresh time", _lakePolygon.lodRefreshTime);
                if (_lakePolygon.lodRefreshTime < 0.01f)
                    _lakePolygon.lodRefreshTime = 0.1f;

                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;

            if (EditorGUI.EndChangeCheck())
            {
                _lakePolygon.GeneratePolygon();
            }

            EditorGUI.indentLevel--;
            EditorGUILayout.Space();

            if (GUILayout.Button("Generate polygon"))
            {
                _lakePolygon.GeneratePolygon();
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("Export as mesh"))
            {
                string path = EditorUtility.SaveFilePanelInProject("Save lake mesh", "", "asset", "Save lake mesh");


                if (path.Length != 0 && _lakePolygon.meshFilter.sharedMesh != null)
                {
                    AssetDatabase.CreateAsset(_lakePolygon.meshFilter.sharedMesh, path);

                    AssetDatabase.Refresh();
                    _lakePolygon.GeneratePolygon();
                }
            }
        }

        private void ProfileManage()
        {
            _lakePolygon.currentProfile = (LakePolygonProfile)EditorGUILayout.ObjectField("Lake profile",
                _lakePolygon.currentProfile, typeof(LakePolygonProfile), false);


            if (GUILayout.Button("Create profile from settings"))
            {
                LakePolygonProfile asset = CreateInstance<LakePolygonProfile>();

                MeshRenderer ren = _lakePolygon.GetComponent<MeshRenderer>();
                _lakePolygon.BaseProfile.lakeMaterial = ren.sharedMaterial;
                asset.SetProfileData(_lakePolygon.BaseProfile);


                string path = EditorUtility.SaveFilePanelInProject("Save new spline profile",
                    _lakePolygon.gameObject.name + ".asset", "asset",
                    "Please enter a file name to save the spline profile to");

                if (!string.IsNullOrEmpty(path))
                {
                    AssetDatabase.CreateAsset(asset, path);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    _lakePolygon.currentProfile = asset;
                }
            }

            if (_lakePolygon.currentProfile != null && GUILayout.Button("Save profile from settings"))
            {
                MeshRenderer ren = _lakePolygon.GetComponent<MeshRenderer>();
                _lakePolygon.BaseProfile.lakeMaterial = ren.sharedMaterial;

                _lakePolygon.currentProfile.SetProfileData(_lakePolygon.BaseProfile);
                EditorUtility.SetDirty(_lakePolygon.currentProfile);

                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }


            if (_lakePolygon.currentProfile != null && _lakePolygon.currentProfile != _lakePolygon.oldProfile)
            {
                ResetToProfile();
                _lakePolygon.GeneratePolygon();
                EditorUtility.SetDirty(_lakePolygon);
            }

            if (CheckProfileChange())
                EditorGUILayout.HelpBox("Profile data changed.", MessageType.Info);

            if (_lakePolygon.currentProfile != null && GUILayout.Button("Reset to profile"))
                if (EditorUtility.DisplayDialog("Reset to profile", "Are you sure you want to reset spline to profile?", "Reset", "Do Not Reset"))
                    ResetToProfile();
        }

        private void FilesManager()
        {
            if (GUILayout.Button("Save points to csv file"))
            {
                NMSplineExporter nmSplineExporter = new NMSplineExporter();
                nmSplineExporter.PointsToFile(_lakePolygon.NmSpline);
            }

            if (GUILayout.Button("Load points from csv file"))
            {
                NMSplineExporter nmSplineExporter = new NMSplineExporter();
                nmSplineExporter.PointsFromFile(_lakePolygon.NmSpline);
            }
        }


        private void OnSceneGUIInvoke(SceneView sceneView)
        {
            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;

            if (_lakePolygon == null)
                return;

            if (_lakePolygon.toolbarInt == 2 && VertexPainterEditor != null && VertexPainterEditor.OnSceneGUI(sceneView))
                return;


            if (_lakePolygon.ShowDebug)
            {
                LakeDebug.ShowDebugHandles();
            }

            if (_lakePolygon.lockHeight && _lakePolygon.NmSpline.MainControlPoints.Count > 1)
            {
                for (int i = 1; i < _lakePolygon.NmSpline.MainControlPoints.Count; i++)
                {
                    Vector4 vec = _lakePolygon.NmSpline.MainControlPoints[i].position;
                    vec.y = _lakePolygon.NmSpline.MainControlPoints[0].position.y;
                    _lakePolygon.NmSpline.MainControlPoints[i].position = vec;
                }
            }

            if (_lakePolygon.NmSpline == null)
            {
                Debug.Log("No NM spline");
                return;
            }


            if (_lakePolygon.NmSpline.Points == null)
            {
                _lakePolygon.GeneratePolygon();
                Debug.Log("No NM spline points");
                return;
            }

            Vector3[] points = new Vector3[_lakePolygon.NmSpline.Points.Count];


            for (int i = 0; i < _lakePolygon.NmSpline.Points.Count; i++)
            {
                points[i] = _lakePolygon.NmSpline.Points[i].Position + _lakePolygon.transform.position;
            }


            Handles.color = Color.white;
            if (points.Length > 1)
                Handles.DrawPolyLine(points);

            if (Event.current.commandName == "UndoRedoPerformed")
            {
                _lakePolygon.GeneratePolygon();
                return;
            }


            if (_dragged && Event.current.type == EventType.MouseUp)
            {
                _dragged = false;
                _lakePolygon.GeneratePolygon();
            }


            NmSplineManager.SceneGUI(_lakePolygon);

            if (_lakePolygon.toolbarInt == 4)
                TerrainManagerEditor.OnSceneGui();
        }

        private void RegeneratePolygon()
        {
            _lakePolygon.GeneratePolygon();
        }

        private void PositionMoved()
        {
            _dragged = true;

            Undo.RecordObject(_lakePolygon, "Change Position");
            _lakePolygon.GeneratePolygon(true);

            _lakePolygonVegetationStudio.RegenerateVegetationStudio();
        }


        private bool CheckProfileChange()
        {
            return _lakePolygon.currentProfile != null && _lakePolygon.BaseProfile.CheckProfileChange(_lakePolygon.currentProfile);
        }

        public void ResetToProfile()
        {
            if (_lakePolygon == null)
                _lakePolygon = (LakePolygon)target;


            _lakePolygon.BaseProfile.SetProfileData(_lakePolygon.currentProfile);

            var ren = _lakePolygon.GetComponent<MeshRenderer>();
            ren.sharedMaterial = _lakePolygon.BaseProfile.lakeMaterial;

            _lakePolygon.oldProfile = _lakePolygon.currentProfile;
        }
    }
}