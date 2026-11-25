using System.Collections.Generic;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;
    using UnityEngine.Rendering;


    [CustomEditor(typeof(RamSpline))]
    public sealed class RamSplineEditor : Editor
    {
        //Vector2 scrollPos;


        private GameObject _lastGameObjectUnderCursor;

        private RamSpline _ramSpline;

        private Vector3 _pivotChange = Vector3.zero;

        private bool _terrainShapeShow;

        private Vector3 _hitPositionOldFlow;


        //public string[] ShadowCastingOptions { get; } = {"Off", "On", "TwoSided", "ShadowsOnly"};


        public string[] toolbarStrings =
        {
            "Basic ",
            "Points",
            "Mesh Painting",
            "Simulate",
            "Terrain",
            "File Points",
            "Tips",
            "Manual",
            "Video Tutorials",
            "Debug",
#if VEGETATION_STUDIO
        ,
        "Vegetation Studio"
#endif
#if VEGETATION_STUDIO_PRO
            "Vegetation Studio Pro"
#endif
        };

        private static readonly int RotateUV = Shader.PropertyToID("_RotateUV");
        private readonly RamTips _ramTips = new();
        private readonly RamSplitter _ramSplitter = new();
        private bool _generateButtonClicked;

        private NmSplineDataNoiseStrength dataNoiseStrength;
        private RamDebug RamDebug { get; set; }

        private TerrainManagerEditor TerrainManagerEditor { get; set; }
        private NmSplineManager NmSplineManager { get; set; }


        private VertexPainterEditor<RamSpline> VertexPainterEditor { get; set; }


        //	/// <summary>
        //	/// The button editing style.
        //	/// </summary>
        //	GUIStyle buttonEditingStyle;

        [MenuItem("GameObject/3D Object/NatureManufacture/Create River Spline")]
        public static void CreateSpline()
        {
            Selection.activeGameObject = RamSpline
                .CreateSpline(AssetDatabase.GetBuiltinExtraResource<Material>("Default-Diffuse.mat")).gameObject;
        }


        private void OnEnable()
        {
            //FindObjectsOfType<RamSpline>();
            _ramSpline = (RamSpline)target;

            if (RamDebug == null)
            {
                if (_ramSpline == null)
                    _ramSpline = (RamSpline)target;
                RamDebug = new RamDebug(_ramSpline);
            }


            if (NmSplineManager == null)
            {
                NmSplineManager = new NmSplineManager(_ramSpline.NmSpline, "RAM");
                _ramSpline.NmSpline.NmSplineChanged.AddListener(OnNmSplineChanged);
                NmSplineManager.AdditionalPointUI += PointGUI;
            }

            if (VertexPainterEditor == null)
            {
                VertexPainterEditor = new VertexPainterEditor<RamSpline>(_ramSpline.VertexPainterData, true);
                VertexPainterEditor.OnResetDrawing.AddListener(() => _ramSpline.GenerateSpline());
                VertexPainterEditor.OnFinishedDrawing.AddListener(FinishedVertexDrawing);
                VertexPainterEditor.TransformFlowMap = RamSpline.TransformFlowMap;
                VertexPainterEditor.ColorDescriptions = "R - Slow Water \nG - Small Cascade \nB - Big Cascade \nA - Opacity";
            }

            if (TerrainManagerEditor == null)
            {
                if (_ramSpline.RamTerrainManager.NmSpline != _ramSpline.NmSpline)
                    _ramSpline.RamTerrainManager.NmSpline = _ramSpline.NmSpline;
                TerrainManagerEditor = new TerrainManagerEditor(_ramSpline.RamTerrainManager, _ramSpline);
                TerrainManagerEditor.GetTerrains.AddListener(() => _ramSpline.GenerateSpline());
            }

            if (_ramSpline.BaseProfile == null)
            {
                _ramSpline.GenerateBaseProfile();
            }

            dataNoiseStrength = _ramSpline.NmSpline.GetData<NmSplineDataNoiseStrength>();

#if VEGETATION_STUDIO
        _spline.vegetationMaskArea = spline.gameObject.GetComponent<VegetationMaskArea>();
#endif
            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            SceneView.duringSceneGui += OnSceneGUIInvoke;

            _ramSpline.MoveControlPointsToMainControlPoints();
        }


        private void OnDisable()
        {
            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            if (_ramSpline != null && _ramSpline.meshGo != null)
                DestroyImmediate(_ramSpline.meshGo);

            if (_ramSpline != null && _ramSpline.gameObject != null && _ramSpline.gameObject.activeInHierarchy)
            {
                _ramSpline.NmSpline.NmSplineChanged.RemoveListener(OnNmSplineChanged);
            }


            if (VertexPainterEditor != null)
            {
                VertexPainterEditor.OnResetDrawing.RemoveListener(() => _ramSpline.GenerateSpline());
                VertexPainterEditor.OnFinishedDrawing.RemoveListener(FinishedVertexDrawing);
            }

            TerrainManagerEditor?.GetTerrains.RemoveListener(() => _ramSpline.GenerateSpline());
        }


        private void OnDestroy()
        {
            if (_ramSpline != null && _ramSpline.meshGo != null)
                DestroyImmediate(_ramSpline.meshGo);
        }


        private void FinishedVertexDrawing()
        {
            if (VertexPainterEditor.VertexHeightChanged)
                _ramSpline.GenerateSpline();

            VertexPainterEditor.ResetFinished();
        }

        private void OnNmSplineChanged()
        {
            _ramSpline.GenerateSpline();
        }


        public override void OnInspectorGUI()
        {
            EditorGUILayout.Space();


            _ramSpline = (RamSpline)target;
            RamDebug ??= new RamDebug(_ramSpline);


            Event e = Event.current;


            if (e != null && e.type == EventType.ValidateCommand && (e.commandName == "Paste" || e.commandName == "Duplicate"))
            {
                Debug.Log("Duplicate");
            }

            LogoRamUi.UILogo();

            EditorGUI.BeginChangeCheck();

            Undo.RecordObject(_ramSpline, "Spline changed");

            //  GUILayout.Toolbar(spline.toolbarInt, toolbarStrings);
            int toolbarNew = GUILayout.SelectionGrid(_ramSpline.toolbarInt, toolbarStrings, 3, GUILayout.Height(125));

            if (toolbarNew == 7)
            {
                toolbarNew = _ramSpline.toolbarInt;
                string[] guids1 = AssetDatabase.FindAssets("River and Lava 3 Manual");
                Application.OpenURL("file:///" + Application.dataPath.Replace("Assets", "") +
                                    AssetDatabase.GUIDToAssetPath(guids1[0]));
            }

            if (toolbarNew == 8)
            {
                toolbarNew = _ramSpline.toolbarInt;
                Application.OpenURL("https://www.youtube.com/playlist?list=PLWMxYDHySK5MyWZsMYWSRtpn1glwcS99x");
            }


            if (_ramSpline.toolbarInt != toolbarNew)
            {
                if (_ramSpline.meshGo != null)
                    DestroyImmediate(_ramSpline.meshGo);

                if (toolbarNew == 2)
                {
                    VertexPainterEditor.GetMeshFilters(_ramSpline.gameObject);
                }
                else if (_ramSpline.toolbarInt == 2)
                {
                    VertexPainterEditor.ResetOldMaterials();
                }
            }


            EditorGUILayout.Space();


            if (_ramSpline.VertexPainterData.ShowFlowMap)
            {
                _ramSpline.GetComponent<MeshRenderer>().sharedMaterial.SetFloat(RotateUV, _ramSpline.BaseProfile.uvRotation ? 1 : 0);
            }

            if (_ramSpline.transform.eulerAngles.magnitude != 0 || _ramSpline.transform.localScale.x != 1f ||
                _ramSpline.transform.localScale.y != 1f || _ramSpline.transform.localScale.z != 1f)
                EditorGUILayout.HelpBox("River should have scale (1,1,1) and rotation (0,0,0) during edit!",
                    MessageType.Error);


            if (toolbarNew == 0)
            {
                EditorGUILayout.HelpBox("Add Point  - CTRL + Left Mouse Button Click \n" +
                                        "Add point between existing points - SHIFT + Left Button Click \n" +
                                        "Remove point - CTRL + SHIFT + Left Button Click", MessageType.Info);
                EditorGUI.indentLevel++;

                AddPointAtEnd();

                EditorGUI.indentLevel--;
                EditorGUILayout.Space();

                UIMeshSettings();


                GUILayout.Label("UV settings:", EditorStyles.boldLabel);
                if (_ramSpline.beginningSpline == null && _ramSpline.endingSpline == null)
                {
                    _ramSpline.BaseProfile.uvScale = EditorGUILayout.FloatField("UV scale (texture tiling)", _ramSpline.BaseProfile.uvScale);
                }
                else
                {
                    _ramSpline.uvScaleOverride = EditorGUILayout.Toggle("Parent UV scale override", _ramSpline.uvScaleOverride);
                    if (!_ramSpline.uvScaleOverride)
                    {
                        if (_ramSpline.beginningSpline != null)
                            _ramSpline.BaseProfile.uvScale = _ramSpline.beginningSpline.BaseProfile.uvScale;
                        else if (_ramSpline.endingSpline != null)
                            _ramSpline.BaseProfile.uvScale = _ramSpline.endingSpline.BaseProfile.uvScale;


                        GUI.enabled = false;
                    }

                    _ramSpline.BaseProfile.uvScale = EditorGUILayout.FloatField("UV scale (texture tiling)", _ramSpline.BaseProfile.uvScale);
                    GUI.enabled = true;
                }

                if (Mathf.Round(_ramSpline.fullLength) == 0)
                {
                    EditorGUILayout.HelpBox("UV scale too big to setup mesh uvs", MessageType.Warning);
                }


                _ramSpline.BaseProfile.uvUseFixedTile = EditorGUILayout.Toggle("Use fixed tilling", _ramSpline.BaseProfile.uvUseFixedTile);

                if (_ramSpline.BaseProfile.uvUseFixedTile)
                {
                    EditorGUI.indentLevel++;

                    if (_ramSpline.beginningSpline == null && _ramSpline.endingSpline == null)
                    {
                        _ramSpline.BaseProfile.uvFixedWidth = EditorGUILayout.FloatField("Use fixed width", _ramSpline.BaseProfile.uvFixedWidth);
                    }
                    else
                    {
                        GUI.enabled = false;
                        if (_ramSpline.beginningSpline != null)
                            _ramSpline.BaseProfile.uvFixedWidth = _ramSpline.beginningSpline.BaseProfile.uvFixedWidth * (_ramSpline.beginningMaxWidth - _ramSpline.beginningMinWidth);
                        else if (_ramSpline.endingSpline != null)
                            _ramSpline.BaseProfile.uvFixedWidth = _ramSpline.endingSpline.BaseProfile.uvFixedWidth * (_ramSpline.endingMaxWidth - _ramSpline.endingMinWidth);

                        EditorGUILayout.FloatField("Use fixed width", _ramSpline.BaseProfile.uvFixedWidth);
                        GUI.enabled = true;
                    }


                    _ramSpline.BaseProfile.uvFixedTileLerp = EditorGUILayout.Slider("Fixed tilling lerp", _ramSpline.BaseProfile.uvFixedTileLerp, 0, 1);
                    EditorGUI.indentLevel--;
                }

                _ramSpline.BaseProfile.invertUVDirection = EditorGUILayout.Toggle("Invert UV direction", _ramSpline.BaseProfile.invertUVDirection);


                _ramSpline.BaseProfile.uvRotation = EditorGUILayout.Toggle("Rotate UV", _ramSpline.BaseProfile.uvRotation);


                GUILayout.Label("Lightning settings:", EditorStyles.boldLabel);
                _ramSpline.BaseProfile.receiveShadows = EditorGUILayout.Toggle("Receive Shadows", _ramSpline.BaseProfile.receiveShadows);


                _ramSpline.BaseProfile.shadowCastingMode =
                    (ShadowCastingMode)EditorGUILayout.EnumPopup("Shadow Casting Mode", _ramSpline.BaseProfile.shadowCastingMode);


                EditorGUILayout.Space();

                //SetMaterials ();


                EditorGUILayout.Space();

                RamConnectionUI.ParentingSplineUI(_ramSpline);
                EditorGUILayout.Space();

                EditorGUILayout.Space();
                GUILayout.Label("Mesh splitting:", EditorStyles.boldLabel);
                _ramSpline.generateMeshParts = EditorGUILayout.Toggle("Split mesh into submeshes", _ramSpline.generateMeshParts);
                if (_ramSpline.generateMeshParts)
                    _ramSpline.meshPartsCount = EditorGUILayout.IntSlider("Parts", _ramSpline.meshPartsCount, 2, _ramSpline.NmSpline.Points.Count - 1);


                EditorGUILayout.Space();

                GUILayout.Label("Object settings:", EditorStyles.boldLabel);


                EditorGUILayout.Space();
                if (GUILayout.Button("Set object pivot to center"))
                {
                    Vector3 center = _ramSpline.meshFilter.sharedMesh.bounds.center;

                    _ramSpline.ChangePivot(center);
                }

                EditorGUILayout.BeginHorizontal();
                {
                    if (GUILayout.Button("Set object pivot position")) _ramSpline.ChangePivot(_pivotChange - _ramSpline.transform.position);

                    _pivotChange = EditorGUILayout.Vector3Field("", _pivotChange);
                }
                EditorGUILayout.EndHorizontal();


                EditorGUILayout.Space();


                EditorGUILayout.Space();
                if (GUILayout.Button(new GUIContent("Regenerate spline", "Recalculates whole mesh")))
                {
                    _generateButtonClicked = true;
                    _ramSpline.GenerateSpline();
                }


                _ramSpline.generateOnStart = EditorGUILayout.Toggle("Regenerate on Start", _ramSpline.generateOnStart);

                EditorGUILayout.Space();
                if (GUILayout.Button("Export as mesh"))
                {
                    string path = EditorUtility.SaveFilePanelInProject("Save river mesh", "", "asset", "Save river mesh");


                    if (path.Length != 0 && _ramSpline.meshFilter.sharedMesh != null)
                    {
                        AssetDatabase.CreateAsset(_ramSpline.meshFilter.sharedMesh, path);

                        AssetDatabase.Refresh();
                        _ramSpline.GenerateSpline();
                    }
                }


                //EditorGUILayout.Space();
                // GUILayout.Label("Debug Settings: ", EditorStyles.boldLabel);


                EditorGUILayout.Space();
                EditorGUILayout.Space();
            }
            else if (toolbarNew == 1)
            {
                NmSplineManager.PointsUI();
            }
            else if (toolbarNew == 2)
            {
                VertexPainterEditor.UIPainter();
                switch (VertexPainterEditor.VertexPainterData.ToolbarInt)
                {
                    case 0:
                        RiverAutomaticVertexColor.UIAutomaticVertexColors(_ramSpline);
                        break;
                    case 1:
                        UIAutomaticFlowColors();
                        break;
                    case 2:
                        UIVertexNoise();
                        break;
                }
            }
            else if (toolbarNew == 3)
            {
                EditorGUILayout.HelpBox("\nSet 1 point and R.A.M will show potential river direction.\n", MessageType.Info);
                GUILayout.Label("River simulation:", EditorStyles.boldLabel);
                EditorGUI.indentLevel++;
                _ramSpline.BaseProfile.simulatedRiverLength = EditorGUILayout.FloatField("Simulation length", _ramSpline.BaseProfile.simulatedRiverLength);
                if (_ramSpline.BaseProfile.simulatedRiverLength < 1)
                    _ramSpline.BaseProfile.simulatedRiverLength = 1;
                _ramSpline.BaseProfile.simulatedRiverPoints =
                    EditorGUILayout.IntSlider("Simulation points interval", _ramSpline.BaseProfile.simulatedRiverPoints, 1, 100);
                _ramSpline.BaseProfile.simulatedMinStepSize =
                    EditorGUILayout.Slider("Simulation sampling interval", _ramSpline.BaseProfile.simulatedMinStepSize, 0.5f, 5);
                _ramSpline.BaseProfile.simulatedNoUp = EditorGUILayout.Toggle("Simulation block uphill", _ramSpline.BaseProfile.simulatedNoUp);
                _ramSpline.BaseProfile.simulatedBreakOnUp = EditorGUILayout.Toggle("Simulation break on uphill", _ramSpline.BaseProfile.simulatedBreakOnUp);

                _ramSpline.BaseProfile.noiseWidth = EditorGUILayout.Toggle("Add width noise", _ramSpline.BaseProfile.noiseWidth);
                if (_ramSpline.BaseProfile.noiseWidth)
                {
                    EditorGUI.indentLevel++;
                    _ramSpline.BaseProfile.noiseMultiplierWidth =
                        EditorGUILayout.FloatField("Noise Multiplier Width", _ramSpline.BaseProfile.noiseMultiplierWidth);
                    _ramSpline.BaseProfile.noiseSizeWidth = EditorGUILayout.FloatField("Noise Tilling Width", _ramSpline.BaseProfile.noiseSizeWidth);
                    EditorGUI.indentLevel--;
                }

                EditorGUILayout.Space();

                if (GUILayout.Button("Show simulated River")) _ramSpline.RamSimulationGenerator.SimulateRiver(false);

                if (GUILayout.Button("Generate Simulated River"))
                {
                    Undo.RecordObject(_ramSpline, "Spline changed");
                    _ramSpline.RamSimulationGenerator.SimulateRiver();
                }

                if (GUILayout.Button("Remove points except first")) _ramSpline.NmSpline.RemovePoints(0);

                EditorGUI.indentLevel--;
            }
            else if (toolbarNew == 4)
            {
                TerrainManagerEditor.UITerrain();
            }
            else if (toolbarNew == 5)
            {
                UIFilesManager();
            }
            else if (toolbarNew == 6)
            {
                _ramTips.Tips();
            }


            if (toolbarNew == 9)
            {
                RamDebug.DebugOptions();
            }

            if (toolbarNew == 10)
            {
                _ramSpline.RamVegetationStudioIntegration.VegetationStudioEditorUI();
            }

            if (EditorGUI.EndChangeCheck())
                if (_ramSpline != null)
                {
                    //Debug.Log("changed");
                    if (!_generateButtonClicked)
                        _ramSpline.GenerateSpline();
                    else
                        _generateButtonClicked = false;

#if VEGETATION_STUDIO_PRO
                    _ramSpline.RamVegetationStudioIntegration.RegenerateBiomeMask();
#endif
                }

            EditorGUILayout.Space();

            if (_ramSpline.beginningSpline)
                if (!_ramSpline.beginningSpline.endingChildSplines.Contains(_ramSpline))
                    _ramSpline.beginningSpline.endingChildSplines.Add(_ramSpline);

            if (_ramSpline.endingSpline)
                if (!_ramSpline.endingSpline.beginningChildSplines.Contains(_ramSpline))
                    _ramSpline.endingSpline.beginningChildSplines.Add(_ramSpline);

            _ramSpline.toolbarInt = toolbarNew;
        }

        private void UIVertexNoise()
        {
            GUILayout.Label("Vertex Noise:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            _ramSpline.BaseProfile.vertexPainterNoiseData.IsNoiseActive = EditorGUILayout.Toggle("Add noise", _ramSpline.BaseProfile.vertexPainterNoiseData.IsNoiseActive);
            if (_ramSpline.BaseProfile.vertexPainterNoiseData.IsNoiseActive)
            {
                EditorGUI.indentLevel++;
                _ramSpline.BaseProfile.vertexPainterNoiseData.VertexNoiseTexture =
                    (Texture2D)EditorGUILayout.ObjectField("Noise texture", _ramSpline.BaseProfile.vertexPainterNoiseData.VertexNoiseTexture, typeof(Texture2D), false);
                _ramSpline.BaseProfile.vertexPainterNoiseData.Multiplier = EditorGUILayout.FloatField("Noise Multiplier", _ramSpline.BaseProfile.vertexPainterNoiseData.Multiplier);
                _ramSpline.BaseProfile.vertexPainterNoiseData.SizeX = EditorGUILayout.FloatField("Noise Scale X", _ramSpline.BaseProfile.vertexPainterNoiseData.SizeX);
                _ramSpline.BaseProfile.vertexPainterNoiseData.SizeZ = EditorGUILayout.FloatField("Noise Scale Z", _ramSpline.BaseProfile.vertexPainterNoiseData.SizeZ);
                _ramSpline.BaseProfile.vertexPainterNoiseData.SlopeCurve = EditorGUILayout.CurveField("Slope curve", _ramSpline.BaseProfile.vertexPainterNoiseData.SlopeCurve);
                EditorGUI.indentLevel--;
            }

            if (GUILayout.Button("Regenerate spline"))
            {
                Undo.RecordObject(_ramSpline, "Add noise to vertices");
                _ramSpline.GenerateSpline();
            }

            EditorGUI.indentLevel--;
            EditorGUILayout.Space();
        }


        private void AddPointAtEnd()
        {
            if (GUILayout.Button("Add point at end"))
            {
                _ramSpline.NmSpline.AddPointAtEnd(_ramSpline.BaseProfile.width);
                _ramSpline.GenerateSpline();
            }
        }

        private void UIMeshSettings()
        {
            _ramSpline.currentProfile =
                (SplineProfile)EditorGUILayout.ObjectField("Spline profile", _ramSpline.currentProfile, typeof(SplineProfile),
                    false);

            if (GUILayout.Button("Create profile from settings"))
            {
                var asset = CreateInstance<SplineProfile>();

                asset.SetProfileData(_ramSpline.BaseProfile);

                string path = EditorUtility.SaveFilePanelInProject("Save new spline profile",
                    _ramSpline.gameObject.name + ".asset", "asset", "Please enter a file name to save the spline profile to");

                if (!string.IsNullOrEmpty(path))
                {
                    AssetDatabase.CreateAsset(asset, path);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    _ramSpline.currentProfile = asset;
                }
            }

            if (_ramSpline.currentProfile != null && GUILayout.Button("Save profile from settings"))
            {
                //spline.currentProfile.meshCurve = spline.meshCurve;

                var ren = _ramSpline.GetComponent<MeshRenderer>();

                _ramSpline.currentProfile.SetProfileData(_ramSpline.BaseProfile);

                _ramSpline.currentProfile.splineMaterial = ren.sharedMaterial;

                EditorUtility.SetDirty(_ramSpline.currentProfile);

                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }


            if (_ramSpline.currentProfile != null && _ramSpline.currentProfile != _ramSpline.oldProfile)
            {
                ResetToProfile();
                EditorUtility.SetDirty(_ramSpline);
            }

            bool profileChanged = CheckProfileChange();


            if (_ramSpline.currentProfile != null &&
                GUILayout.Button("Reset to profile" + (profileChanged ? " (Profile data changed)" : "")))
                if (EditorUtility.DisplayDialog("Reset to profile", "Are you sure you want to reset spline to profile?", "Reset", "Do Not Reset"))
                    ResetToProfile();


            EditorGUILayout.Space();
            GUILayout.Label("Mesh settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            string meshResolution = "Triangles density";
            if (_ramSpline.meshFilter != null && _ramSpline.meshFilter.sharedMesh != null)
            {
                int tris = _ramSpline.meshFilter.sharedMesh.triangles.Length / 3;
                meshResolution += " (" + tris + " tris)";
            }
            else if (_ramSpline.meshFilter != null && _ramSpline.meshFilter.sharedMesh == null)
            {
                _ramSpline.GenerateSpline();
            }


            EditorGUILayout.LabelField(meshResolution);
            EditorGUI.indentLevel++;
            //  _ramSpline.BaseProfile.triangleDensity = 1 / (float) EditorGUILayout.IntSlider("U", (int) (1 / _ramSpline.BaseProfile.triangleDensity), 1, 100);
            _ramSpline.BaseProfile.triangleDensity = EditorGUILayout.IntSlider("U", (int)_ramSpline.BaseProfile.triangleDensity, 1, 100);

            if (_ramSpline.beginningSpline == null && _ramSpline.endingSpline == null)
            {
                _ramSpline.BaseProfile.vertsInShape = EditorGUILayout.IntSlider("V", _ramSpline.BaseProfile.vertsInShape - 1, 1, 20) + 1;
            }
            else
            {
                GUI.enabled = false;
                if (_ramSpline.beginningSpline != null)
                    _ramSpline.BaseProfile.vertsInShape = (int)Mathf.Round((_ramSpline.beginningSpline.BaseProfile.vertsInShape - 1) *
                        (_ramSpline.beginningMaxWidth - _ramSpline.beginningMinWidth) + 1);
                else if (_ramSpline.endingSpline != null)
                    _ramSpline.BaseProfile.vertsInShape = (int)Mathf.Round((_ramSpline.endingSpline.BaseProfile.vertsInShape - 1) *
                        (_ramSpline.endingMaxWidth - _ramSpline.endingMinWidth) + 1);

                EditorGUILayout.IntSlider("V", _ramSpline.BaseProfile.vertsInShape - 1, 1, 20);
                GUI.enabled = true;
            }

            EditorGUI.indentLevel--;
            EditorGUILayout.Space();


            EditorGUILayout.BeginHorizontal();
            {
                _ramSpline.BaseProfile.width = EditorGUILayout.FloatField("River width", _ramSpline.BaseProfile.width);

                if (GUILayout.Button("Change width for whole river"))
                    if (_ramSpline.BaseProfile.width > 0)
                    {
                        for (int i = 0; i < _ramSpline.NmSpline.MainControlPoints.Count; i++)
                        {
                            Vector4 point = _ramSpline.NmSpline.MainControlPoints[i].position;
                            point.w = _ramSpline.BaseProfile.width;
                            _ramSpline.NmSpline.MainControlPoints[i].position = point;
                        }

                        _ramSpline.GenerateSpline();
                    }
            }
            EditorGUILayout.EndHorizontal();
            EditorGUI.indentLevel++;
            _ramSpline.BaseProfile.noiseWidth = EditorGUILayout.Toggle("Add width noise", _ramSpline.BaseProfile.noiseWidth);
            if (_ramSpline.BaseProfile.noiseWidth)
            {
                EditorGUI.indentLevel++;
                _ramSpline.BaseProfile.noiseMultiplierWidth =
                    EditorGUILayout.FloatField("Noise Multiplier Width", _ramSpline.BaseProfile.noiseMultiplierWidth);
                _ramSpline.BaseProfile.noiseSizeWidth = EditorGUILayout.FloatField("Noise Tilling Width", _ramSpline.BaseProfile.noiseSizeWidth);
                EditorGUI.indentLevel--;
                if (GUILayout.Button("Add noise to width for whole river"))
                {
                    Undo.RecordObject(_ramSpline, "Change widths");
                    _ramSpline.AddNoiseToWidths();
                    _ramSpline.GenerateSpline();
                }
            }

            EditorGUI.indentLevel--;
            EditorGUILayout.Space();


            _ramSpline.BaseProfile.meshCurve = EditorGUILayout.CurveField("Mesh curve", _ramSpline.BaseProfile.meshCurve);
            if (GUILayout.Button("Set all mesh curves"))
                for (int i = 0; i < _ramSpline.NmSpline.MainControlPoints.Count; i++)
                    _ramSpline.NmSpline.MainControlPoints[i].meshCurve = new AnimationCurve(_ramSpline.BaseProfile.meshCurve.keys);

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Vertices distribution: " + _ramSpline.BaseProfile.minVal + " " +
                                       _ramSpline.BaseProfile.maxVal);
            EditorGUILayout.MinMaxSlider(ref _ramSpline.BaseProfile.minVal, ref _ramSpline.BaseProfile.maxVal, 1, 99);

            //Debug.Log (spline.minVal + " " + spline.maxVal);

            _ramSpline.BaseProfile.minVal = (int)_ramSpline.BaseProfile.minVal;
            _ramSpline.BaseProfile.maxVal = (int)_ramSpline.BaseProfile.maxVal;


            EditorGUILayout.Space();

            if (GUILayout.Button("Snap/Unsnap mesh to terrain"))
            {
                _ramSpline.BaseProfile.snapToTerrain = !_ramSpline.BaseProfile.snapToTerrain;
                for (int i = 0; i < _ramSpline.NmSpline.MainControlPoints.Count; i++) _ramSpline.NmSpline.MainControlPoints[i].snap = _ramSpline.BaseProfile.snapToTerrain ? 1 : 0;
            }

            //spline.snapMask = EditorGUILayout.MaskField ("Layers", spline.snapMask, InternalEditorUtility.layers);
            _ramSpline.BaseProfile.snapMask = LayerMaskField.ShowLayerMaskField("Layers", _ramSpline.BaseProfile.snapMask, true);


            _ramSpline.BaseProfile.normalFromRaycast = EditorGUILayout.Toggle("Take Normal from terrain", _ramSpline.BaseProfile.normalFromRaycast);
            if (_ramSpline.BaseProfile.normalFromRaycast)
            {
                EditorGUI.indentLevel++;

                _ramSpline.BaseProfile.NormalFromRaycastPerVertex = EditorGUILayout.Toggle("Per vertex", _ramSpline.BaseProfile.NormalFromRaycastPerVertex);

                _ramSpline.BaseProfile.NormalFromRaycastLerp = EditorGUILayout.Slider("Normal from terrain lerp", _ramSpline.BaseProfile.NormalFromRaycastLerp, 0, 1);
                EditorGUI.indentLevel--;
            }


            EditorGUILayout.Space();
        }

        private bool CheckProfileChange()
        {
            return _ramSpline.BaseProfile.CheckProfileChange(_ramSpline.currentProfile);
        }

        public void ResetToProfile()
        {
            if (_ramSpline == null)
                _ramSpline = (RamSpline)target;


            _ramSpline.BaseProfile.SetProfileData(_ramSpline.currentProfile);

            var ren = _ramSpline.GetComponent<MeshRenderer>();
            ren.sharedMaterial = _ramSpline.BaseProfile.splineMaterial;

            for (int i = 0; i < _ramSpline.NmSpline.MainControlPoints.Count; i++) _ramSpline.NmSpline.MainControlPoints[i].meshCurve = new AnimationCurve(_ramSpline.BaseProfile.meshCurve.keys);

            VertexPainterEditor.RestartFlow();

            _ramSpline.GenerateSpline();


            _ramSpline.oldProfile = _ramSpline.currentProfile;
        }


        private void UIAutomaticFlowColors()
        {
            EditorGUILayout.Space();
            GUILayout.Label("Flow Map Automatic: ", EditorStyles.boldLabel);

            _ramSpline.BaseProfile.flowFlat = EditorGUILayout.CurveField("Flow curve flat speed", _ramSpline.BaseProfile.flowFlat);
            _ramSpline.BaseProfile.flowWaterfall = EditorGUILayout.CurveField("Flow curve waterfall speed", _ramSpline.BaseProfile.flowWaterfall);
            //_ramSpline.BaseProfile.flowLerpDistance = EditorGUILayout.IntSlider("Flow blend distance between splines", (int) _ramSpline.BaseProfile.flowLerpDistance, 1, 100);

            _ramSpline.BaseProfile.noiseFlowMap = EditorGUILayout.Toggle("Add noise", _ramSpline.BaseProfile.noiseFlowMap);
            if (_ramSpline.BaseProfile.noiseFlowMap)
            {
                EditorGUI.indentLevel++;
                _ramSpline.BaseProfile.noiseMultiplierFlowMap =
                    EditorGUILayout.FloatField("Noise multiplier inside", _ramSpline.BaseProfile.noiseMultiplierFlowMap);
                _ramSpline.BaseProfile.noiseSizeXFlowMap = EditorGUILayout.FloatField("Noise scale X", _ramSpline.BaseProfile.noiseSizeXFlowMap);
                _ramSpline.BaseProfile.noiseSizeZFlowMap = EditorGUILayout.FloatField("Noise scale Z", _ramSpline.BaseProfile.noiseSizeZFlowMap);
                EditorGUI.indentLevel--;
            }


            EditorGUILayout.Space();
            GUILayout.Label("Flow Map Physic: ", EditorStyles.boldLabel);
            _ramSpline.BaseProfile.floatSpeed = EditorGUILayout.FloatField("River float speed", _ramSpline.BaseProfile.floatSpeed);
            _ramSpline.BaseProfile.floatSpeedWaterfallMultiplier = EditorGUILayout.FloatField("Waterfall float speed multiplier", _ramSpline.BaseProfile.floatSpeedWaterfallMultiplier);
            _ramSpline.BaseProfile.physicalDensity = EditorGUILayout.FloatField("Physical Density", _ramSpline.BaseProfile.physicalDensity);

            _ramSpline.BaseProfile.meshFlowSpeed = EditorGUILayout.FloatField("River flow speed multiplier", _ramSpline.BaseProfile.meshFlowSpeed);
        }


        private void UIFilesManager()
        {
            if (GUILayout.Button("Save points to csv file"))
            {
                NMSplineExporter nmSplineExporter = new NMSplineExporter();
                nmSplineExporter.PointsToFile(_ramSpline.NmSpline);
            }

            if (GUILayout.Button("Load points from csv file"))
            {
                NMSplineExporter nmSplineExporter = new NMSplineExporter();
                nmSplineExporter.PointsFromFile(_ramSpline.NmSpline);
            }
        }


        private void PointGUI(int i)
        {
            if (i > 0 && i < _ramSpline.NmSpline.MainControlPoints.Count - 1)
            {
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Split spline into 2 splines:");

                EditorGUI.indentLevel++;
                EditorGUILayout.BeginHorizontal();
                if (GUILayout.Button("Split spline"))
                {
                    _ramSpline.NmSpline.SelectedPosition = -1;
                    _ramSplitter.SplitRiver(_ramSpline, i);
                }

                if (GUILayout.Button("Split spline into two"))
                {
                    _ramSpline.NmSpline.SelectedPosition = -1;
                    _ramSplitter.SplitRiverIntoTwo(_ramSpline, i);
                }

                EditorGUILayout.EndHorizontal();

                EditorGUI.indentLevel--;
            }
        }

        private void OnSceneGUIInvoke(SceneView sceneView)
        {
            if (Event.current.commandName == "UndoRedoPerformed")
            {
                _ramSpline.GenerateSpline();

                return;
            }


            if (_ramSpline == null)
                _ramSpline = (RamSpline)target;


            if (_ramSpline == null || _ramSpline.NmSpline == null) return;


            if (_ramSpline.toolbarInt == 4)
                TerrainManagerEditor.OnSceneGui();


            if (_ramSpline.toolbarInt == 2)
            {
                if (_ramSpline.BaseProfile.vertexPainterNoiseData.IsNoiseActive)
                    dataNoiseStrength.ShowSceneGUI(_ramSpline.NmSpline);


                if (VertexPainterEditor != null && VertexPainterEditor.OnSceneGUI(sceneView))
                {
                    NmSplineManager.SceneGUI(_ramSpline, _ramSpline.beginningSpline != null, _ramSpline.endingSpline != null, true);
                }

                return;
            }


            if (RamDebug.debug)
            {
                RamDebug.ShowDebugHandles();
            }

            NmSplineManager.SceneGUI(_ramSpline, _ramSpline.beginningSpline != null, _ramSpline.endingSpline != null);
        }
    }
}