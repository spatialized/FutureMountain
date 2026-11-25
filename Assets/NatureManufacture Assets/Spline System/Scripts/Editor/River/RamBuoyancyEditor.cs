namespace NatureManufacture.RAM.Editor
{
    using UnityEditor;
    using UnityEngine;

    [CustomEditor(typeof(RamBuoyancy)), CanEditMultipleObjects]
    public class RamBuoyancyEditor : Editor
    {

        
        private SerializedProperty _buoyancyProperty;
        
        private SerializedProperty _viscosityProperty;
        private SerializedProperty _viscosityAngularProperty;
        private SerializedProperty _rotateToSpeedProperty;
        private SerializedProperty _rotationSpeedProperty;
        private SerializedProperty _layerProperty;
        private SerializedProperty _colliderProperty;
        private SerializedProperty _pointsInAxisProperty;
        private SerializedProperty _volumePointsProperty;
        private SerializedProperty _autoGenerateVolumePointsProperty;
        private SerializedProperty _debugForcesProperty;
        private SerializedProperty _debugVolumePointsProperty;
        private SerializedProperty _checkWaterDistance;


        private void OnEnable()
        {
            
            _buoyancyProperty = serializedObject.FindProperty("buoyancy");
            _viscosityProperty = serializedObject.FindProperty("viscosity");
            _viscosityAngularProperty = serializedObject.FindProperty("viscosityAngular");
            _rotateToSpeedProperty = serializedObject.FindProperty("rotateToSpeed");
            _rotationSpeedProperty = serializedObject.FindProperty("rotationSpeed");
            _layerProperty = serializedObject.FindProperty("layer");
            _colliderProperty = serializedObject.FindProperty("collider");
            _pointsInAxisProperty = serializedObject.FindProperty("pointsInAxis");
            _volumePointsProperty = serializedObject.FindProperty("volumePoints");
            _autoGenerateVolumePointsProperty = serializedObject.FindProperty("autoGenerateVolumePoints");
            _debugForcesProperty = serializedObject.FindProperty("debugForces");
            _debugVolumePointsProperty = serializedObject.FindProperty("debugVolumePoints");
            _checkWaterDistance = serializedObject.FindProperty("checkWaterDistance");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            
           // EditorGUILayout.LabelField("test Settings", EditorStyles.boldLabel);

            
            
            

            EditorGUILayout.Space();
            EditorGUILayout.PropertyField(_buoyancyProperty);
            EditorGUILayout.PropertyField(_viscosityProperty);
            EditorGUILayout.PropertyField(_viscosityAngularProperty);
            EditorGUILayout.Space();


            EditorGUILayout.PropertyField(_rotateToSpeedProperty);
            if (_rotateToSpeedProperty.boolValue)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(_rotationSpeedProperty);
                EditorGUI.indentLevel--;
            }

            EditorGUILayout.Space();
            EditorGUILayout.PropertyField(_layerProperty);
            EditorGUILayout.PropertyField(_colliderProperty);

            //EditorGUILayout.PropertyField(_pointsInAxisProperty);

            _pointsInAxisProperty.intValue = EditorGUILayout.IntSlider(new GUIContent("Points In Axis"), _pointsInAxisProperty.intValue, 2, 10);


            _autoGenerateVolumePointsProperty.boolValue = EditorGUILayout.Toggle("Auto Generate Volume Points", _autoGenerateVolumePointsProperty.boolValue);

            if (!_autoGenerateVolumePointsProperty.boolValue)
            {
                EditorGUI.indentLevel++;
                if(GUILayout.Button("Generate Volume Points"))
                {
                    foreach (RamBuoyancy buoyancy in targets)
                    {
                        buoyancy.AutoGenerateVolumePoints();
                    }
                }
                EditorGUILayout.PropertyField(_volumePointsProperty, true);
                EditorGUI.indentLevel--;
            }
            
            EditorGUILayout.PropertyField(_checkWaterDistance);

            EditorGUILayout.Space();

            EditorGUILayout.PropertyField(_debugForcesProperty);
            EditorGUILayout.PropertyField(_debugVolumePointsProperty);

            serializedObject.ApplyModifiedProperties();
        }
    }
}