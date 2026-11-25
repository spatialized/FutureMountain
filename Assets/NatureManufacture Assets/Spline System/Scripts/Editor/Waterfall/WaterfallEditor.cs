using System;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;

    [CustomEditor(typeof(Waterfall))]
    public class WaterfallEditor : Editor
    {
        private const string TooltipTriangleDensity = "This is the density of the spline.";
        private const string TooltipTimeStep = "This is the time step for the simulation.";
        private const string TooltipSimulationTime = "This is the total simulation time.";
        private const string TooltipStrength = "This is the base strength of the waterfall.";
        private const string TooltipBlurVelocityStrength = "This is the blur strength of the waterfall velocity.";
        private const string TooltipBlurVelocityIterations = "This is the number of blur iterations for the waterfall velocity.";
        private const string TooltipBlurVelocitySize = "This is the blur size for the waterfall velocity.";
        private const string TooltipBlurPositionStrength = "This is the blur strength of the waterfall points y position.";
        private const string TooltipBlurPositionIterations = "This is the number of blur iterations for the waterfall points y position.";
        private const string TooltipBlurPositionSize = "This is the blur size for the waterfall points y position.";
        private const string TooltipMaximumDistance = "This is the maximum distance of the waterfall.";
        private const string TooltipMinPointDistance = "This is the minimum distance between points in the waterfall.";
        private const string TooltipTerrainOffset = "This is the offset of the waterfall from the terrain.";
        private const string TooltipRestitution = "This is the restitution coefficient of the waterfall.";
        private const string TooltipRestitutionAngleLerp = "Restitution Bounce Angle Lerp";
        private Waterfall _waterfall;
        private bool _dragged;

        public string[] toolbarStrings = new[]
        {
            "Basic",
            "Points",
            "Mesh Painting",
        };


        private VertexPainterEditor<RamSpline> VertexPainterEditor { get; set; }

        private NmSplineManager NmSplineManager { get; set; }

        private void OnEnable()
        {
            _waterfall = (Waterfall)target;
            if (_waterfall.BaseProfile == null)
                _waterfall.GenerateBaseProfile();

            if (VertexPainterEditor == null)
            {
                VertexPainterEditor = new VertexPainterEditor<RamSpline>(_waterfall.VertexPainterData, true);
                VertexPainterEditor.OnResetDrawing.AddListener(() => _waterfall.GenerateSplineAndPointList(false));
                VertexPainterEditor.TransformFlowMap = RamSpline.TransformFlowMap;
                VertexPainterEditor.ColorDescriptions = "R - Slow Water \nG - Small Cascade \nB - Big Cascade \nA - Opacity";
            }

            if (NmSplineManager == null)
            {
                NmSplineManager = new NmSplineManager(_waterfall.NmSpline, "Waterfall");
                _waterfall.NmSpline.NmSplineChanged.AddListener(OnNmSplineChange);
            }

            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            SceneView.duringSceneGui += OnSceneGUIInvoke;
        }

        private void OnDisable()
        {
            SceneView.duringSceneGui -= this.OnSceneGUIInvoke;

            if (_waterfall != null && _waterfall.gameObject != null && _waterfall.gameObject.activeInHierarchy)
            {
                _waterfall.NmSpline.NmSplineChanged.RemoveListener(OnNmSplineChange);
            }
        }

        private void OnNmSplineChange()
        {
            _dragged = true;
            GenerateSplineAndPointList(true);
        }

        private void GenerateSplineAndPointList(bool quick = false)
        {
            _waterfall.GenerateSplineAndPointList(quick);
        }

        public override void OnInspectorGUI()
        {
            _waterfall = (Waterfall)target;
            EditorGUILayout.Space();

            EditorGUILayout.Space();
            LogoRamUi.UILogo();

            int toolbarNew = GUILayout.SelectionGrid(_waterfall.ToolbarInt, toolbarStrings, 3, GUILayout.Height(40));
            EditorGUILayout.Space();

            if (_waterfall.ToolbarInt != toolbarNew)
            {
                Undo.RegisterCompleteObjectUndo(_waterfall, "Toolbar change");
                if (toolbarNew == 2)
                {
                    VertexPainterEditor.GetMeshFilters(_waterfall.gameObject);
                }
                else if (_waterfall.ToolbarInt == 2)
                {
                    VertexPainterEditor.ResetOldMaterials();
                }
            }


            switch (toolbarNew)
            {
                case 0:
                    UIMain();
                    break;
                case 1:
                    UIPoints();
                    break;
                case 2:
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

                    break;
            }


            _waterfall.ToolbarInt = toolbarNew;
        }

        private void UIAutomaticFlowMap()
        {
            EditorGUILayout.Space();

            EditorGUI.BeginChangeCheck();

            GUILayout.Label("Flow Map Physic: ", EditorStyles.boldLabel);
            _waterfall.BaseProfile.FloatSpeed = EditorGUILayout.FloatField("Float speed", _waterfall.BaseProfile.FloatSpeed);
            _waterfall.BaseProfile.FloatSpeedWaterfallMultiplier = EditorGUILayout.FloatField("Waterfall float speed  multiplier", _waterfall.BaseProfile.FloatSpeedWaterfallMultiplier);
            _waterfall.BaseProfile.PhysicalDensity = EditorGUILayout.FloatField("Physical density", _waterfall.BaseProfile.PhysicalDensity);
            
            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_waterfall, "Waterfall changed");
                GenerateSplineAndPointList();
            }
        }

        private void UIAutomaticPaint()
        {
            EditorGUILayout.Space();

            EditorGUI.BeginChangeCheck();
            GUILayout.Label("Vertex Color Automatic: ", EditorStyles.boldLabel);


            _waterfall.BaseProfile.AlphaByDistance = EditorGUILayout.CurveField("Alpha by distance", _waterfall.BaseProfile.AlphaByDistance);


            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_waterfall, "Waterfall changed");
                GenerateSplineAndPointList();
            }
        }

        private void UIPoints()
        {
            EditorGUI.BeginChangeCheck();

            NmSplineManager.PointsUI();

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_waterfall, "Points change");
                GenerateSplineAndPointList();
            }
        }

        private void UIMain()
        {
            ProfileManage();

            EditorGUILayout.Space();
            UISplineSettings();

            EditorGUILayout.Space();
            _waterfall.BaseDebug = EditorGUILayout.Toggle("Debug", _waterfall.BaseDebug);
        }

        private void UISplineSettings()
        {
            EditorGUI.BeginChangeCheck();

            GUILayout.Label("Spline settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            string meshResolution = "Triangles density";
            if (_waterfall.MainMeshFilter != null && _waterfall.MainMeshFilter.sharedMesh != null)
            {
                int tris = _waterfall.MainMeshFilter.sharedMesh.triangles.Length / 3;
                meshResolution += $" ({tris} tris)";
            }

            EditorGUILayout.LabelField(meshResolution);


            _waterfall.BaseProfile.TriangleDensity = EditorGUILayout.IntSlider(new GUIContent("Spline density", TooltipTriangleDensity), (int)(_waterfall.BaseProfile.TriangleDensity), 1, 100);
            _waterfall.BaseProfile.TimeStep = EditorGUILayout.Slider(new GUIContent("Time step", TooltipTimeStep), _waterfall.BaseProfile.TimeStep, 0.001f, 1f);
            EditorGUILayout.Space();
            _waterfall.BaseProfile.SimulationTime = EditorGUILayout.DelayedFloatField(new GUIContent("Simulation time", TooltipSimulationTime), _waterfall.BaseProfile.SimulationTime);
            _waterfall.BaseProfile.MaxWaterfallDistance = EditorGUILayout.FloatField(new GUIContent("Max waterfall distance", TooltipMaximumDistance), _waterfall.BaseProfile.MaxWaterfallDistance);


            _waterfall.BaseProfile.BaseStrength = EditorGUILayout.DelayedFloatField(new GUIContent("Base strength", TooltipStrength), _waterfall.BaseProfile.BaseStrength);

            EditorGUILayout.Space();

            _waterfall.BaseProfile.RestitutionCoeff = EditorGUILayout.FloatField(new GUIContent("Restitution Coefficient", TooltipRestitution), _waterfall.BaseProfile.RestitutionCoeff);

            _waterfall.BaseProfile.RestitutionAnglelerp = EditorGUILayout.Slider(new GUIContent("Restitution Angle Lerp", TooltipRestitutionAngleLerp), _waterfall.BaseProfile.RestitutionAnglelerp, 0, 1);

            _waterfall.BaseProfile.RaycastMask = LayerMaskField.ShowLayerMaskField("Raycast mask", _waterfall.BaseProfile.RaycastMask, true);

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Velocity blur:");
            EditorGUI.indentLevel++;

            _waterfall.BaseProfile.BlurVelocityIterations = EditorGUILayout.IntField(new GUIContent("Blur iterations", TooltipBlurVelocityIterations), _waterfall.BaseProfile.BlurVelocityIterations);
            _waterfall.BaseProfile.BlurVelocityStrength = EditorGUILayout.FloatField(new GUIContent("Blur strength", TooltipBlurVelocityStrength), _waterfall.BaseProfile.BlurVelocityStrength);
            _waterfall.BaseProfile.BlurVelocitySize = EditorGUILayout.IntField(new GUIContent("Blur size", TooltipBlurVelocitySize), _waterfall.BaseProfile.BlurVelocitySize);

            EditorGUI.indentLevel--;

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Position blur:");
            EditorGUI.indentLevel++;

            _waterfall.BaseProfile.BlurPositionIterations = EditorGUILayout.IntField(new GUIContent("Blur iterations", TooltipBlurPositionIterations), _waterfall.BaseProfile.BlurPositionIterations);
            _waterfall.BaseProfile.BlurPositionStrength = EditorGUILayout.FloatField(new GUIContent("Blur strength", TooltipBlurPositionStrength), _waterfall.BaseProfile.BlurPositionStrength);
            _waterfall.BaseProfile.BlurPositionSize = EditorGUILayout.IntField(new GUIContent("Blur size", TooltipBlurPositionSize), _waterfall.BaseProfile.BlurPositionSize);

            EditorGUI.indentLevel--;

            EditorGUILayout.Space();

            _waterfall.BaseProfile.MinPointDistance = EditorGUILayout.FloatField(new GUIContent("Min point distance", TooltipMinPointDistance), _waterfall.BaseProfile.MinPointDistance);

            EditorGUILayout.Space();
            _waterfall.BaseProfile.TerrainOffset = EditorGUILayout.CurveField(new GUIContent("Terrain offset", TooltipTerrainOffset), _waterfall.BaseProfile.TerrainOffset);

            if (_waterfall.BaseProfile.TerrainOffset.keys.Length == 0)
                _waterfall.BaseProfile.TerrainOffset = new AnimationCurve(new Keyframe(0, 0), new Keyframe(0.1f, 0.1f), new Keyframe(0.9f, 0.1f), new Keyframe(1, 0));

            _waterfall.BaseProfile.ClipUnderTerrain = EditorGUILayout.Toggle("Clip under terrain", _waterfall.BaseProfile.ClipUnderTerrain);

            EditorGUILayout.Space();
            _waterfall.BaseProfile.UvScale = EditorGUILayout.Vector2Field("UV scale", _waterfall.BaseProfile.UvScale);


            _waterfall.NmSpline.IsLooping = EditorGUILayout.Toggle("Loop", _waterfall.NmSpline.IsLooping);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_waterfall, "Points change");
                Undo.RegisterCompleteObjectUndo(_waterfall.BaseProfile, "Points change");
                Undo.RegisterCompleteObjectUndo(_waterfall.NmSpline, "Points change");


                _dragged = true;
                GenerateSplineAndPointList(true);
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("Generate Waterfall"))
            {
                _waterfall.GenerateSplineObjects();
            }

            EditorGUILayout.Space();


            WaterfallConnectionUI.ConnectionUI(_waterfall, _waterfall.Connection);
        }


        [MenuItem("GameObject/3D Object/NatureManufacture/Create Waterfall")]
        public static void CreateWaterfall()
        {
            Selection.activeGameObject = Waterfall.CreatWaterfall().gameObject;
        }

        private void ProfileManage()
        {
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Space();
            _waterfall.CurrentProfile = (WaterfallProfile)EditorGUILayout.ObjectField("Waterfall profile",
                _waterfall.CurrentProfile, typeof(WaterfallProfile), false);


            if (GUILayout.Button("Create profile from settings"))
            {
                WaterfallProfile asset = CreateInstance<WaterfallProfile>();


                MeshRenderer ren = _waterfall.GetComponent<MeshRenderer>();
                _waterfall.BaseProfile.WaterfallMaterial = ren.sharedMaterial;
                asset.SetProfileData(_waterfall.BaseProfile);


                string path = EditorUtility.SaveFilePanelInProject("Save new spline profile",
                    _waterfall.gameObject.name + ".asset", "asset",
                    "Please enter a file name to save the spline profile to");

                if (!string.IsNullOrEmpty(path))
                {
                    AssetDatabase.CreateAsset(asset, path);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    _waterfall.CurrentProfile = asset;
                }
            }

            if (_waterfall.CurrentProfile != null && GUILayout.Button("Save profile from settings"))
            {
                MeshRenderer ren = _waterfall.GetComponent<MeshRenderer>();
                _waterfall.BaseProfile.WaterfallMaterial = ren.sharedMaterial;

                _waterfall.CurrentProfile.SetProfileData(_waterfall.BaseProfile);
                EditorUtility.SetDirty(_waterfall.CurrentProfile);
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }


            if (_waterfall.CurrentProfile != null && _waterfall.CurrentProfile != _waterfall.OldProfile)
            {
                ResetToProfile();
                EditorUtility.SetDirty(_waterfall);
            }

            if (CheckProfileChange())
                EditorGUILayout.HelpBox("Profile data changed.", MessageType.Info);

            if (_waterfall.CurrentProfile != null && GUILayout.Button("Reset to profile"))
                if (EditorUtility.DisplayDialog("Reset to profile", "Are you sure you want to reset spline to profile?", "Reset", "Do Not Reset"))
                    ResetToProfile();

            if (EditorGUI.EndChangeCheck())
            {
                Debug.Log("UISplineSettings");
                Undo.RegisterCompleteObjectUndo(_waterfall, "Points change");
                Undo.RegisterCompleteObjectUndo(_waterfall.BaseProfile, "Points change");
                Undo.RegisterCompleteObjectUndo(_waterfall.NmSpline, "Points change");


                _dragged = true;
                GenerateSplineAndPointList(true);
            }
        }


        private void OnSceneGUIInvoke(SceneView sceneView)
        {
            if (_dragged && Event.current.type == EventType.MouseUp)
            {
                _dragged = false;
                GenerateSplineAndPointList();
            }


            _waterfall = (Waterfall)target;


            if (_waterfall.NmSpline.Points == null)
                GenerateSplineAndPointList();


            if (_waterfall.ToolbarInt == 2 && VertexPainterEditor != null && VertexPainterEditor.OnSceneGUI(sceneView))
                return;

            Handles.color = Color.red;

            DrawPoints();

            NmSplineManager.SceneGUI(_waterfall);

            if (_waterfall.Connection.Spline != null)
                WaterfallConnectionUI.ShowConnectionOnSpline(_waterfall, _waterfall.Connection);

            if (_waterfall.BaseDebug)
                WaterfallDebugger.ShowBaseDebug(_waterfall.Simulator.AllSimulationPoints, _waterfall.transform.position);
        }

        private void DrawPoints()
        {
            if (_waterfall.NmSpline.Points != null)
            {
                int end = _waterfall.NmSpline.Points.Count;

                if (!_waterfall.NmSpline.IsLooping)
                    end -= 1;

                //if (_waterfall.BaseDebug)
                {
                    for (int i = 0; i < _waterfall.NmSpline.Points.Count; i++)
                    {
                        Vector3 direction = _waterfall.NmSpline.Points[i].Orientation * Vector3.right * _waterfall.BaseProfile.BaseStrength;
                        Vector3 handlePos = _waterfall.transform.position + _waterfall.NmSpline.Points[i].Position;
                        float handleSize = HandleUtility.GetHandleSize(handlePos) * 0.3f;
                        //draw arrow
                        Handles.color = Color.red;
                        Handles.ArrowHandleCap(0, handlePos, Quaternion.LookRotation(direction), handleSize, EventType.Repaint);
                    }
                }


                Vector3 position = _waterfall.transform.position;
                for (int i = 0; i < end; i++)
                {
                    Vector3 one = _waterfall.NmSpline.Points[i].Position + position;
                    Vector3 two = _waterfall.NmSpline.Points[(i + 1) % _waterfall.NmSpline.Points.Count]
                        .Position + position;
                    Handles.color = Color.green;
                    Handles.DrawLine(one, two);

                    DrawDebug(one, i);
                }
            }
        }

        private void DrawDebug(Vector3 one, int i)
        {
            if (!_waterfall.BaseDebug) return;

            Handles.color = Color.blue;
            Handles.DrawLine(one, one + _waterfall.NmSpline.Points[i].Normal);
            Handles.color = Color.yellow;
            Handles.DrawLine(one, one + _waterfall.NmSpline.Points[i].Binormal);
            Handles.color = Color.green;
            Handles.DrawLine(one, one + _waterfall.NmSpline.Points[i].Tangent);
        }

        private bool CheckProfileChange()
        {
            return _waterfall.CurrentProfile != null && _waterfall.BaseProfile.CheckProfileChange(_waterfall.CurrentProfile);
        }

        public void ResetToProfile()
        {
            if (_waterfall == null)
                _waterfall = (Waterfall)target;

            _waterfall.BaseProfile.SetProfileData(_waterfall.CurrentProfile);

            MeshRenderer ren = _waterfall.GetComponent<MeshRenderer>();
            ren.sharedMaterial = _waterfall.BaseProfile.WaterfallMaterial;

            _waterfall.OldProfile = _waterfall.CurrentProfile;

            _waterfall.GenerateSplineObjects();
        }
    }
}