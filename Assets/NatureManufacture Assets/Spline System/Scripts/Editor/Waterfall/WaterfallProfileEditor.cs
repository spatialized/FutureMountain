namespace NatureManufacture.RAM.Editor
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using UnityEditor;

    [CustomEditor(typeof(WaterfallProfile)), CanEditMultipleObjects]
    public class WaterfallProfileEditor : Editor
    {
        private SerializedObject _serializedWaterfallProfile;
        private SerializedProperty _triangleDensity;
        private SerializedProperty _waterfallMaterial;
        private SerializedProperty _simulationTime;
        private SerializedProperty _timeStep;
        private SerializedProperty _baseStrength;
        private SerializedProperty _uvScale;
        private SerializedProperty _restitutionCoeff;
        private SerializedProperty _restitutionAnglelerp;
        private SerializedProperty _raycastMask;
        private SerializedProperty _blurVelocityStrength;
        private SerializedProperty _blurVelocityIterations;
        private SerializedProperty _blurVelocitySize;
        private SerializedProperty _blurPositionStrength;
        private SerializedProperty _blurPositionIterations;
        private SerializedProperty _blurPositionSize;
        private SerializedProperty _maxWaterfallDistance;
        private SerializedProperty _minPointDistance;
        private SerializedProperty _terrainOffset;
        private SerializedProperty _alphaByDistance;
        private SerializedProperty _floatSpeed;
        private SerializedProperty _floatSpeedWaterfallMultiplier;
        private SerializedProperty _physicalDensity;
        private SerializedProperty _clipUnderTerrain;
        private SerializedProperty _offset;
        private SerializedProperty _yOffset;
        private SerializedProperty _angleOffset;


        private void OnEnable()
        {
            _serializedWaterfallProfile = new SerializedObject(target);
            _triangleDensity = _serializedWaterfallProfile.FindProperty("triangleDensity");
            _waterfallMaterial = _serializedWaterfallProfile.FindProperty("waterfallMaterial");
            _simulationTime = _serializedWaterfallProfile.FindProperty("simulationTime");
            _timeStep = _serializedWaterfallProfile.FindProperty("timeStep");
            _baseStrength = _serializedWaterfallProfile.FindProperty("baseStrength");
            _uvScale = _serializedWaterfallProfile.FindProperty("uvScale");
            _restitutionCoeff = _serializedWaterfallProfile.FindProperty("restitutionCoeff");
            _restitutionAnglelerp = _serializedWaterfallProfile.FindProperty("restitutionAnglelerp");
            _raycastMask = _serializedWaterfallProfile.FindProperty("raycastMask");
            _blurVelocityStrength = _serializedWaterfallProfile.FindProperty("blurVelocityStrength");
            _blurVelocityIterations = _serializedWaterfallProfile.FindProperty("blurVelocityIterations");
            _blurVelocitySize = _serializedWaterfallProfile.FindProperty("blurVelocitySize");
            _blurPositionStrength = _serializedWaterfallProfile.FindProperty("blurPositionStrength");
            _blurPositionIterations = _serializedWaterfallProfile.FindProperty("blurPositionIterations");
            _blurPositionSize = _serializedWaterfallProfile.FindProperty("blurPositionSize");
            _maxWaterfallDistance = _serializedWaterfallProfile.FindProperty("maxWaterfallDistance");
            _minPointDistance = _serializedWaterfallProfile.FindProperty("minPointDistance");
            _terrainOffset = _serializedWaterfallProfile.FindProperty("terrainOffset");
            _alphaByDistance = _serializedWaterfallProfile.FindProperty("alphaByDistance");
            _floatSpeed = _serializedWaterfallProfile.FindProperty("floatSpeed");
            _floatSpeedWaterfallMultiplier = _serializedWaterfallProfile.FindProperty("floatSpeedWaterfallMultiplier");
            _physicalDensity = _serializedWaterfallProfile.FindProperty("physicalDensity");
            _clipUnderTerrain = _serializedWaterfallProfile.FindProperty("clipUnderTerrain");

            _offset = _serializedWaterfallProfile.FindProperty("offset");
            _yOffset = _serializedWaterfallProfile.FindProperty("yOffset");
            _angleOffset = _serializedWaterfallProfile.FindProperty("angleOffset");
        }

        private void OnSceneDrag(SceneView sceneView, int index)
        {
            Event e = Event.current;

            GameObject go = HandleUtility.PickGameObject(e.mousePosition, false);
            if (!go)
                return;

            var waterfall = go.GetComponent<Waterfall>();

            switch (e.type)
            {
                case EventType.DragUpdated:
                {
                    DragAndDrop.visualMode = waterfall ? DragAndDropVisualMode.Link : DragAndDropVisualMode.Rejected;
                    e.Use();
                    break;
                }
                case EventType.DragPerform when waterfall == null:
                    return;
                case EventType.DragPerform:
                {
                    WaterfallProfile waterfallProfile = (WaterfallProfile)DragAndDrop.objectReferences[0];
                    DragAndDrop.visualMode = DragAndDropVisualMode.Copy;

                    Undo.RecordObject(waterfall, "Lake changed");
                    var waterfallEditor = (WaterfallEditor)CreateEditor(waterfall);

                    waterfall.CurrentProfile = waterfallProfile;
                    waterfallEditor.ResetToProfile();

                    EditorUtility.SetDirty(waterfall);

                    DestroyImmediate(waterfallEditor);

                    DragAndDrop.AcceptDrag();
                    e.Use();
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            _serializedWaterfallProfile.Update();

            GUILayout.Label("Basic Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_triangleDensity);
            EditorGUILayout.PropertyField(_waterfallMaterial);
            EditorGUI.indentLevel--;

            GUILayout.Label("Simulation Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_simulationTime);
            EditorGUILayout.PropertyField(_timeStep);
            EditorGUILayout.PropertyField(_baseStrength);
            EditorGUILayout.PropertyField(_uvScale);
            EditorGUI.indentLevel--;

            GUILayout.Label("Restitution Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_restitutionCoeff);
            EditorGUILayout.PropertyField(_restitutionAnglelerp);
            EditorGUI.indentLevel--;

            GUILayout.Label("Raycast Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_raycastMask);
            EditorGUI.indentLevel--;

            GUILayout.Label("Blur Velocity Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_blurVelocityStrength);
            EditorGUILayout.PropertyField(_blurVelocityIterations);
            EditorGUILayout.PropertyField(_blurVelocitySize);
            EditorGUI.indentLevel--;

            GUILayout.Label("Blur Position Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_blurPositionStrength);
            EditorGUILayout.PropertyField(_blurPositionIterations);
            EditorGUILayout.PropertyField(_blurPositionSize);
            EditorGUI.indentLevel--;

            GUILayout.Label("Distance Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_maxWaterfallDistance);
            EditorGUILayout.PropertyField(_minPointDistance);
            EditorGUI.indentLevel--;

            GUILayout.Label("Terrain Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_terrainOffset);
            EditorGUILayout.PropertyField(_alphaByDistance);
            EditorGUI.indentLevel--;

            GUILayout.Label("Miscellaneous Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_floatSpeed);
            EditorGUILayout.PropertyField(_floatSpeedWaterfallMultiplier);
            EditorGUILayout.PropertyField(_physicalDensity);

            EditorGUILayout.PropertyField(_clipUnderTerrain);
            EditorGUI.indentLevel--;


            GUILayout.Label("Connection Settings:", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_offset);
            EditorGUILayout.PropertyField(_yOffset);
            EditorGUILayout.PropertyField(_angleOffset);
            EditorGUI.indentLevel--;


            _serializedWaterfallProfile.ApplyModifiedProperties();
        }
    }
}