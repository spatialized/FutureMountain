using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(NatureManufacture.RAM.RamBuoyancyArcade)), CanEditMultipleObjects]
public class RamBuoyancyArcadeEditor : Editor
{
    private SerializedProperty _layer;
    private SerializedProperty _lerpRotationSpeed;
    private SerializedProperty _lerpFloatSpeed;
    private SerializedProperty _lerpWaterVelocity;
    private SerializedProperty _velocityMultiplier;
    private SerializedProperty _rotateToSpeed;
    private SerializedProperty _rotationSpeed;
    private SerializedProperty _physicsPivot;
    private SerializedProperty _checkWaterDistance;
    private SerializedProperty _debugForces;

    private void OnEnable()
    {
        _layer = serializedObject.FindProperty("layer");
        _lerpRotationSpeed = serializedObject.FindProperty("lerpRotationSpeed");
        _lerpFloatSpeed = serializedObject.FindProperty("lerpFloatSpeed");
        _lerpWaterVelocity = serializedObject.FindProperty("lerpWaterVelocity");
        _velocityMultiplier = serializedObject.FindProperty("velocityMultiplier");
        _rotateToSpeed = serializedObject.FindProperty("rotateToSpeed");
        _rotationSpeed = serializedObject.FindProperty("rotationSpeed");
        _physicsPivot = serializedObject.FindProperty("physicsPivot");
        _checkWaterDistance = serializedObject.FindProperty("checkWaterDistance");
        _debugForces = serializedObject.FindProperty("debugForces");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();


        EditorGUILayout.PropertyField(_lerpRotationSpeed, new GUIContent("Vertical Alignment Strength"));
        EditorGUILayout.PropertyField(_lerpFloatSpeed, new GUIContent("Float Strength"));
        EditorGUILayout.PropertyField(_lerpWaterVelocity, new GUIContent("Float Speed Acceleration"));
        EditorGUILayout.PropertyField(_velocityMultiplier, new GUIContent("Float Speed Multiplier"));
        EditorGUILayout.PropertyField(_rotateToSpeed, new GUIContent("Rotate To Speed"));
        if (_rotateToSpeed.boolValue)
        {
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_rotationSpeed, new GUIContent("Rotation Speed"));
            EditorGUI.indentLevel--;
        }

        EditorGUILayout.PropertyField(_layer);
        EditorGUILayout.PropertyField(_physicsPivot);
        EditorGUILayout.PropertyField(_checkWaterDistance);
        
        EditorGUILayout.PropertyField(_debugForces);
        
        

        serializedObject.ApplyModifiedProperties();
    }
}