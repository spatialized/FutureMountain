// /**
//  * Created by Pawel Homenko on  08/2022
//  */

namespace NatureManufacture.RAM
{
    using NatureManufacture.RAM;
    using UnityEditor;
    using UnityEngine;

    [CustomPropertyDrawer(typeof(TerrainNoiseParameters))]
    public class TerrainNoiseParametersDrawer : PropertyDrawer
    {
        private SerializedProperty _useUseNoise;
        private SerializedProperty _randomizeSeed;
        private SerializedProperty _noiseSeed;
        private SerializedProperty _noiseMultiplierPower;
        private SerializedProperty _noiseMultiplier;
        private SerializedProperty _noiseSizeX;
        private SerializedProperty _noiseSizeZ;
        private SerializedProperty _operationType;

        private float _nextPositionY;

        private Rect GetNextPosition(Rect currentPos)
        {
            Rect rect = new Rect(currentPos.x, currentPos.y + _nextPositionY, currentPos.width, EditorGUIUtility.singleLineHeight);
            _nextPositionY += EditorGUIUtility.singleLineHeight + 2;

            return rect;
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            _useUseNoise = property.FindPropertyRelative("useNoise");
            _randomizeSeed = property.FindPropertyRelative("randomizeSeed");
            _noiseSeed = property.FindPropertyRelative("noiseSeed");
            _noiseMultiplierPower = property.FindPropertyRelative("noiseMultiplierPower");
            _noiseMultiplier = property.FindPropertyRelative("noiseMultiplier");
            _noiseSizeX = property.FindPropertyRelative("noiseSizeX");
            _noiseSizeZ = property.FindPropertyRelative("noiseSizeZ");
            _operationType = property.FindPropertyRelative("operationType");

            float totalHeight = 0;
            totalHeight += EditorGUI.GetPropertyHeight(_useUseNoise);

            if (!_useUseNoise.boolValue) return totalHeight;


            totalHeight += EditorGUI.GetPropertyHeight(_randomizeSeed);
            totalHeight += EditorGUI.GetPropertyHeight(_noiseSeed) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_noiseMultiplierPower) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_noiseMultiplier) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_noiseSizeX) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_noiseSizeZ) + 2;
            totalHeight += EditorGUI.GetPropertyHeight(_operationType) + 2;

            return totalHeight;
        }


        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            _nextPositionY = 0;

            _useUseNoise = property.FindPropertyRelative("useNoise");

            _randomizeSeed = property.FindPropertyRelative("randomizeSeed");
            _noiseSeed = property.FindPropertyRelative("noiseSeed");

            _noiseMultiplierPower = property.FindPropertyRelative("noiseMultiplierPower");
            _noiseMultiplier = property.FindPropertyRelative("noiseMultiplier");
            _noiseSizeX = property.FindPropertyRelative("noiseSizeX");
            _noiseSizeZ = property.FindPropertyRelative("noiseSizeZ");
            _operationType = property.FindPropertyRelative("operationType");

            EditorGUI.BeginProperty(position, label, property);


            EditorGUI.PropertyField(GetNextPosition(position), _useUseNoise);
            if (_useUseNoise.boolValue)
            {
                EditorGUI.indentLevel++;
                EditorGUI.PropertyField(GetNextPosition(position), _randomizeSeed);

                EditorGUI.indentLevel++;
                if (_randomizeSeed.boolValue)
                {
                    EditorGUI.BeginDisabledGroup(true);
                    EditorGUI.PropertyField(GetNextPosition(position), _noiseSeed);
                    EditorGUI.EndDisabledGroup();
                }
                else
                {
                    EditorGUI.PropertyField(GetNextPosition(position), _noiseSeed);
                }

                EditorGUI.indentLevel--;
                EditorGUI.PropertyField(GetNextPosition(position), _noiseMultiplierPower);
                EditorGUI.PropertyField(GetNextPosition(position), _noiseMultiplier);
                EditorGUI.PropertyField(GetNextPosition(position), _noiseSizeX);
                EditorGUI.PropertyField(GetNextPosition(position), _noiseSizeZ);
                EditorGUI.PropertyField(GetNextPosition(position), _operationType);
                EditorGUI.indentLevel--;
            }

            EditorGUI.EndProperty();
        }
    }
}