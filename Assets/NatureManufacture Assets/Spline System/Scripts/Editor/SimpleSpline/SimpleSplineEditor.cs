using System.Collections.Generic;

namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;


    [CustomEditor(typeof(SimpleSpline))]
    public class SimpleSplineEditor : Editor
    {
        private Vector2 scrollPosition;
        private bool _showPositions;

        private SimpleSpline _simpleSpline;


        private bool _dragged;

        private NmSplineManager NmSplineManager { get; set; }

        private int _postCount;
        private int _spansCount;

        private void OnEnable()
        {
            _simpleSpline = (SimpleSpline)target;


            if (NmSplineManager == null)
            {
                NmSplineManager = new NmSplineManager(_simpleSpline.NmSpline, "Simple Spline");
                _simpleSpline.NmSpline.NmSplineChanged.AddListener(OnNmSplineChange);
            }

            SceneView.duringSceneGui -= OnSceneGUIInvoke;
            SceneView.duringSceneGui += OnSceneGUIInvoke;
        }

        private void OnNmSplineChange()
        {
            _dragged = true;
            GenerateSplineAndPointList();
        }


        private void OnDisable()
        {
            SceneView.duringSceneGui -= this.OnSceneGUIInvoke;

            if (_simpleSpline != null && _simpleSpline.gameObject != null && _simpleSpline.gameObject.activeInHierarchy)
            {
                _simpleSpline.NmSpline.NmSplineChanged.RemoveListener(OnNmSplineChange);
            }
        }

        [MenuItem("GameObject/3D Object/NatureManufacture/Create Simple Spline")]
        public static void CreateSimpleSpline()
        {
            Selection.activeGameObject = SimpleSpline.CreateSimpleSpline().gameObject;
        }

        public override void OnInspectorGUI()
        {
            _simpleSpline = (SimpleSpline)target;
            EditorGUILayout.Space();

            UILogo();


            EditorGUI.BeginChangeCheck();


            UISplineSettings();


            EditorGUILayout.Space();
            GUILayout.Label("Spline settings:", EditorStyles.boldLabel);


            EditorGUILayout.Space();


            UISplinePoints();
        }


        private void UILogo()
        {
            LogoRamUi.UILogo();
        }

        private void UISplinePoints()
        {
            EditorGUI.BeginChangeCheck();

            _showPositions = EditorGUILayout.Foldout(_showPositions, "Spline Points");
            if (_showPositions)
            {
                scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);
                NmSplineManager.PointsUI();
                EditorGUILayout.EndScrollView();
            }

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_simpleSpline, "Points change");
                GenerateSplineAndPointList();
            }
        }


        private void UISplineSettings()
        {
            EditorGUILayout.Space();

            GUILayout.Label("Spline settings:", EditorStyles.boldLabel);
            _simpleSpline.TriangleDensity = EditorGUILayout.IntSlider("Spline density", (int)(_simpleSpline.TriangleDensity), 1, 100);

            _simpleSpline.CenterPivot = EditorGUILayout.Toggle("Center pivot", _simpleSpline.CenterPivot);
            _simpleSpline.LockHeight = EditorGUILayout.Toggle("Lock height", _simpleSpline.LockHeight);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RegisterCompleteObjectUndo(_simpleSpline, "Points change");
                _dragged = true;
                GenerateSplineAndPointList();
            }
        }


        private void GenerateSplineAndPointList()
        {
            _simpleSpline.GenerateSplineObjects();
        }

        private void OnSceneGUIInvoke(SceneView sceneView)
        {
            if (_dragged && Event.current.type == EventType.MouseUp)
            {
                _dragged = false;
                GenerateSplineAndPointList();
            }

            _simpleSpline = (SimpleSpline)target;


            if (_simpleSpline.NmSpline.Points == null)
                GenerateSplineAndPointList();

            Handles.color = Color.red;

            if (_simpleSpline.NmSpline.Points != null)
            {
                int end = _simpleSpline.NmSpline.Points.Count;

                if (!_simpleSpline.NmSpline.IsLooping)
                    end -= 1;


                var position = _simpleSpline.transform.position;
                for (int i = 0; i < end; i++)
                {
                    Vector3 one = _simpleSpline.NmSpline.Points[i].Position + position;
                    Vector3 two = _simpleSpline.NmSpline.Points[(i + 1) % _simpleSpline.NmSpline.Points.Count].Position + position;
                    Handles.color = Color.green;
                    Handles.DrawLine(one, two);
                }
            }

            NmSplineManager.SceneGUI(_simpleSpline);
        }
    }
}