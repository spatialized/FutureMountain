// /**
//  * Created by Pawel Homenko on  08/2022
//  */

namespace NatureManufacture.RAM
{
    using NatureManufacture.RAM;
    using UnityEditor;
    using UnityEngine;

    [CustomPropertyDrawer(typeof(TerrainConvexParameters))]
    public class TerrainConvexParametersDrawer : PropertyDrawer
    {
        private SerializedProperty _convex;
        private SerializedProperty _steps;
        private SerializedProperty _stepSize;
        private SerializedProperty _strength;

        private float _nextPositionY;

        private Rect GetNextPosition(Rect currentPos)
        {
            Rect rect = new Rect(currentPos.x, currentPos.y + _nextPositionY, currentPos.width, EditorGUIUtility.singleLineHeight);
            _nextPositionY += EditorGUIUtility.singleLineHeight + 2;

            return rect;
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            _convex = property.FindPropertyRelative("convex");
            _steps = property.FindPropertyRelative("steps");
            _stepSize = property.FindPropertyRelative("stepSize");
            _strength = property.FindPropertyRelative("strength");

            float totalHeight = 0;
            totalHeight += EditorGUI.GetPropertyHeight(_convex);

            if (_convex.enumValueIndex == (int) TerrainConvexParameters.ConvexType.None) return totalHeight;

            totalHeight += EditorGUI.GetPropertyHeight(_steps) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_stepSize) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_strength) + 2;

            return totalHeight;
        }


        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            _nextPositionY = 0;

            _convex = property.FindPropertyRelative("convex");
            _steps = property.FindPropertyRelative("steps");
            _stepSize = property.FindPropertyRelative("stepSize");
            _strength = property.FindPropertyRelative("strength");

            EditorGUI.BeginProperty(position, label, property);


            EditorGUI.PropertyField(GetNextPosition(position), _convex);
            if (_convex.enumValueIndex != (int) TerrainConvexParameters.ConvexType.None)
            {
                EditorGUI.indentLevel++;
                EditorGUI.PropertyField(GetNextPosition(position), _steps);
                EditorGUI.PropertyField(GetNextPosition(position), _stepSize);
                EditorGUI.PropertyField(GetNextPosition(position), _strength);
                EditorGUI.indentLevel--;
            }

            EditorGUI.EndProperty();
        }
    }
}