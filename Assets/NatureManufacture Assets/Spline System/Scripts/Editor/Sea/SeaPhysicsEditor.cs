using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(NatureManufacture.RAM.SeaPhysics)), CanEditMultipleObjects]
public class SeaPhysicsEditor : Editor
{
    private SerializedProperty _gridSize;
    private SerializedProperty _gridAmount;
    private SerializedProperty _debugTransform;
    private SerializedProperty _debug;

    private void OnEnable()
    {
        _gridSize = serializedObject.FindProperty("gridSize");
        _gridAmount = serializedObject.FindProperty("gridAmount");
        _debugTransform = serializedObject.FindProperty("debugTransform");
        _debug = serializedObject.FindProperty("debug");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.PropertyField(_gridSize);
        EditorGUILayout.PropertyField(_gridAmount);
        
        EditorGUILayout.Space();
        EditorGUILayout.PropertyField(_debug);
        if (_debug.boolValue)
        {
            EditorGUI.indentLevel++;
            EditorGUILayout.PropertyField(_debugTransform);
            EditorGUI.indentLevel--;
        }

        serializedObject.ApplyModifiedProperties();
    }
}