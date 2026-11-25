using System.Collections.Generic;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;


    [CustomEditor(typeof(TerrainSpline))]
    public class TerrainSplineEditor : Editor
    {
        private Vector2 scrollPosition;
        private bool _showPositions;

        private TerrainSpline _terrainSpline;


        private bool _dragged;


        public string[] toolbarStrings = new[]
        {
            "Basic",
            "Points",
            "Terrain",
        };

        private TerrainManagerEditor TerrainManagerEditor { get; set; }
        private NmSplineManager NmSplineManager { get; set; }

        private int _postCount;
        private int _spansCount;

        private void OnEnable()
        {
            _terrainSpline = (TerrainSpline)target;


            if (NmSplineManager == null)
            {
                NmSplineManager = new NmSplineManager(_terrainSpline.NmSpline, "Terrain Spline");
                _terrainSpline.NmSpline.NmSplineChanged.AddListener(OnNmSplineChange);
            }

            if (TerrainManagerEditor == null)
            {
                if (_terrainSpline.RamTerrainManager.NmSpline != _terrainSpline.NmSpline)
                    _terrainSpline.RamTerrainManager.NmSpline = _terrainSpline.NmSpline;
                TerrainManagerEditor = new TerrainManagerEditor(_terrainSpline.RamTerrainManager, _terrainSpline);
                TerrainManagerEditor.GetTerrains.AddListener(() => _terrainSpline.GeneratePolygon());
            }

            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            SceneView.duringSceneGui += OnSceneGUIInvoke;
        }

        private void OnNmSplineChange()
        {
            _dragged = true;
            RegeneratePolygon();
        }


        private void OnDisable()
        {
            SceneView.duringSceneGui -= this.OnSceneGUIInvoke;

            if (_terrainSpline != null && _terrainSpline.gameObject != null && _terrainSpline.gameObject.activeInHierarchy)
            {
                _terrainSpline.NmSpline.NmSplineChanged.RemoveListener(OnNmSplineChange);
            }
        }

        [MenuItem("GameObject/3D Object/NatureManufacture/Create Terrain Spline")]
        public static void CreateTerrainSpline()
        {
            Selection.activeGameObject = TerrainSpline.CreateTerrainSpline().gameObject;
        }

        public override void OnInspectorGUI()
        {
            _terrainSpline = (TerrainSpline)target;
            EditorGUILayout.Space();

            UILogo();




            EditorGUI.BeginChangeCheck();

            int toolbarNew = GUILayout.SelectionGrid(_terrainSpline.ToolbarInt, toolbarStrings, 3, GUILayout.Height(30));

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_terrainSpline, "Points change");
                _dragged = true;
                RegeneratePolygon();
            }

            switch (toolbarNew)
            {
                case 0:
                    UISplineSettings();
                    break;
                case 1:
                    UISplinePoints();
                    break;
                case 2:
                    if (_terrainSpline.ToolbarInt != toolbarNew)
                    {
                        if (_terrainSpline.RamTerrainManager != null && _terrainSpline.RamTerrainManager.BasePainterData && _terrainSpline.RamTerrainManager.BasePainterData.WorkTerrain == null)
                        {
                            _terrainSpline.GeneratePolygon();
                        }
                    }

                    EditorGUILayout.Space();
                    TerrainManagerEditor.UITerrain();


                    break;
            }

            _terrainSpline.ToolbarInt = toolbarNew;
        }

     


        private void UILogo()
        {
            LogoRamUi.UILogo();
        }

        private void UISplinePoints()
        {
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Space();
            _showPositions = EditorGUILayout.Foldout(_showPositions, "Spline Points");
            if (_showPositions)
            {
                scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);
                NmSplineManager.PointsUI();
                EditorGUILayout.EndScrollView();
            }

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_terrainSpline, "Points change");
                RegeneratePolygon();
            }
        }


        private void UISplineSettings()
        {
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.Space();

            GUILayout.Label("Spline settings:", EditorStyles.boldLabel);
            _terrainSpline.TriangleDensity = EditorGUILayout.IntSlider("Spline density", (int)(_terrainSpline.TriangleDensity), 1, 100);
            if (_terrainSpline.TriangleDensity < 1)
                _terrainSpline.TriangleDensity = 1;

            _terrainSpline.LockHeight = EditorGUILayout.Toggle("Lock height", _terrainSpline.LockHeight);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_terrainSpline, "Points change");
                _dragged = true;
                RegeneratePolygon();
            }
        }


        private void RegeneratePolygon()
        {
            _terrainSpline.GeneratePolygon();
        }

        private void OnSceneGUIInvoke(SceneView sceneView)
        {
            if (_dragged && Event.current.type == EventType.MouseUp)
            {
                _dragged = false;
                RegeneratePolygon();
            }

            _terrainSpline = (TerrainSpline)target;


            if (_terrainSpline.NmSpline.Points == null)
                RegeneratePolygon();

            Handles.color = Color.red;

            if (_terrainSpline.NmSpline.Points != null)
            {
                int end = _terrainSpline.NmSpline.Points.Count;

                if (!_terrainSpline.NmSpline.IsLooping)
                    end -= 1;


                var position = _terrainSpline.transform.position;
                for (int i = 0; i < end; i++)
                {
                    Vector3 one = _terrainSpline.NmSpline.Points[i].Position + position;
                    Vector3 two = _terrainSpline.NmSpline.Points[(i + 1) % _terrainSpline.NmSpline.Points.Count].Position + position;
                    Handles.color = Color.green;
                    Handles.DrawLine(one, two);
                }
            }

            NmSplineManager.SceneGUI(_terrainSpline);

            if (_terrainSpline.ToolbarInt == 2)
                TerrainManagerEditor.OnSceneGui();
        }
    }
}