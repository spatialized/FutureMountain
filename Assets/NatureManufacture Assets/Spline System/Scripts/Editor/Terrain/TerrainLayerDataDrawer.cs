// /**
//  * Created by Pawel Homenko on 08/2022
//  */

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;


namespace NatureManufacture.RAM.Editor
{
    [CustomPropertyDrawer(typeof(TerrainLayerData))]
    public class TerrainLayerDataDrawer : PropertyDrawer
    {
        private GUIStyle _layerButtonStyle;
        private SerializedProperty _layerName;
        private SerializedProperty _isActive;
        private SerializedProperty _power;
        private SerializedProperty _powerMultiplier;
        private SerializedProperty _useHeight;
        private SerializedProperty _height;
        private SerializedProperty _heightMultiplier;
        private SerializedProperty _heightPower;
        private SerializedProperty _splatMapID;
        private SerializedProperty _useAngle;
        private SerializedProperty _angle;
        private SerializedProperty _noiseParametersList;
        private SerializedProperty _convexParameters;

        private float _nextPositionY;

        public static TerrainData CurrentTerrainData;

        private Rect GetNextPosition(Rect currentPos, float customHeight = 0)
        {
            float height = customHeight > 0 ? customHeight : EditorGUIUtility.singleLineHeight;
            Rect rect = new Rect(currentPos.x, currentPos.y + _nextPositionY, currentPos.width, height);
            _nextPositionY += height + 2;

            return rect;
        }


        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            _isActive = property.FindPropertyRelative("isActive");
            _layerName = property.FindPropertyRelative("layerName");
            _power = property.FindPropertyRelative("power");
            _powerMultiplier = property.FindPropertyRelative("powerMultiplier");
            _useHeight = property.FindPropertyRelative("useHeight");
            _height = property.FindPropertyRelative("height");
            _heightMultiplier = property.FindPropertyRelative("heightMultiplier");
            _heightPower = property.FindPropertyRelative("heightPower");
            _splatMapID = property.FindPropertyRelative("splatMapID");
            _useAngle = property.FindPropertyRelative("useAngle");
            _angle = property.FindPropertyRelative("angle");
            _noiseParametersList = property.FindPropertyRelative("noiseParametersList");
            _convexParameters = property.FindPropertyRelative("convexParameters");

            float totalHeight = 0;
            totalHeight += EditorGUI.GetPropertyHeight(_layerName) + 2;
            if (property.isExpanded)
            {
                totalHeight += EditorGUI.GetPropertyHeight(_power) + 2;
                totalHeight += EditorGUI.GetPropertyHeight(_powerMultiplier) + 2;
                totalHeight += EditorGUI.GetPropertyHeight(_useHeight) + 2;
                if (_useHeight.boolValue)
                {
                    totalHeight += EditorGUI.GetPropertyHeight(_height) + 2;
                    totalHeight += EditorGUI.GetPropertyHeight(_heightMultiplier) + 2;
                    totalHeight += EditorGUI.GetPropertyHeight(_heightPower) + 2;
                }

                if (CurrentTerrainData == null)
                {
                    totalHeight += EditorGUI.GetPropertyHeight(_splatMapID) + 2;
                }
                else
                {
                    totalHeight += EditorGUIUtility.singleLineHeight + 2;
                    totalHeight += 64 * Mathf.Ceil(CurrentTerrainData.terrainLayers.Length / 4f) + 2;
                }

                totalHeight += EditorGUI.GetPropertyHeight(_useAngle) + 2;
                if (_useAngle.boolValue)
                {
                    totalHeight += EditorGUI.GetPropertyHeight(_angle) + 2;
                }

                totalHeight += EditorGUI.GetPropertyHeight(_noiseParametersList) + 2;
                totalHeight += EditorGUI.GetPropertyHeight(_convexParameters) + 2;
                totalHeight += 10;
            }

            return totalHeight;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            _nextPositionY = 0;

            _isActive = property.FindPropertyRelative("isActive");
            _layerName = property.FindPropertyRelative("layerName");
            _power = property.FindPropertyRelative("power");
            _powerMultiplier = property.FindPropertyRelative("powerMultiplier");
            _useHeight = property.FindPropertyRelative("useHeight");
            _height = property.FindPropertyRelative("height");
            _heightMultiplier = property.FindPropertyRelative("heightMultiplier");
            _heightPower = property.FindPropertyRelative("heightPower");
            _splatMapID = property.FindPropertyRelative("splatMapID");
            _useAngle = property.FindPropertyRelative("useAngle");
            _angle = property.FindPropertyRelative("angle");
            _noiseParametersList = property.FindPropertyRelative("noiseParametersList");
            _convexParameters = property.FindPropertyRelative("convexParameters");

            EditorGUI.BeginProperty(position, label, property);
            property.serializedObject.Update();

            Color oldBackgroundColor = GUI.backgroundColor;
            Color oldColor = GUI.color;
            Color oldContentColor = GUI.contentColor;

            //GUIStyle currentStyle = new GUIStyle(GUI.skin.box);


            Rect pos = GetNextPosition(position);
            pos.width = 10;
            property.isExpanded = EditorGUI.Foldout(pos, property.isExpanded, "");
            pos.x += 10;

            EditorGUI.PropertyField(pos, _isActive, new GUIContent(""));
            pos.x += 20;
            pos.width = position.width - 30;


            if (!_isActive.boolValue)
            {
                // currentStyle.normal.background = Texture2D.blackTexture;


                GUI.color = Color.grey;
                GUI.contentColor = Color.grey;
                // GUI.backgroundColor = Color.black;

                //GUI.Box(position, "", currentStyle);
            }

            EditorGUI.PropertyField(pos, _layerName, new GUIContent(_layerName.stringValue));

            if (property.isExpanded)
            {
                if (CurrentTerrainData == null)
                {
                    EditorGUI.PropertyField(GetNextPosition(position, EditorGUIUtility.singleLineHeight + 10), _splatMapID);
                }
                else
                {
                    string splatMapText = $"Splat Map ({_splatMapID.intValue + 1}):";
                    GUIContent guiContent = new GUIContent(splatMapText);

                    if (CurrentTerrainData.terrainLayers.Length <= _splatMapID.intValue)
                    {
                        guiContent = EditorGUIUtility.IconContent("Warning", "");
                        guiContent.text = splatMapText;
                        guiContent.tooltip = $"Terrain \"{CurrentTerrainData.name}\" does not have {_splatMapID.intValue + 1} layers.";
                    }


                    EditorGUI.LabelField(GetNextPosition(position, EditorGUIUtility.singleLineHeight + 10), guiContent);
                    _splatMapID.intValue = InspectorPaintTexture(CurrentTerrainData, _splatMapID.intValue, GetNextPosition(position, 64 * Mathf.Ceil(CurrentTerrainData.terrainLayers.Length / 4f)));
                }

                EditorGUI.PropertyField(GetNextPosition(position), _power);
                EditorGUI.PropertyField(GetNextPosition(position), _powerMultiplier);

                EditorGUI.PropertyField(GetNextPosition(position), _useHeight);
                if (_useHeight.boolValue)
                {
                    EditorGUI.indentLevel++;
                    EditorGUI.PropertyField(GetNextPosition(position), _height);
                    EditorGUI.PropertyField(GetNextPosition(position), _heightMultiplier);
                    EditorGUI.PropertyField(GetNextPosition(position), _heightPower);

                    EditorGUI.indentLevel--;
                }

                EditorGUI.PropertyField(GetNextPosition(position), _useAngle);
                if (_useAngle.boolValue)
                {
                    EditorGUI.indentLevel++;
                    EditorGUI.PropertyField(GetNextPosition(position), _angle);
                    EditorGUI.indentLevel--;
                }


                EditorGUI.PropertyField(GetNextPosition(position,EditorGUI.GetPropertyHeight(_convexParameters)), _convexParameters);
                int arraySize = _noiseParametersList.arraySize;
                EditorGUI.PropertyField(GetNextPosition(position, EditorGUI.GetPropertyHeight(_noiseParametersList)), _noiseParametersList);
                if (arraySize == 0 && _noiseParametersList.arraySize == 1)
                {
                    var noiseParameters = (TerrainNoiseParameters)_noiseParametersList.GetArrayElementAtIndex(0).boxedValue;
                    noiseParameters.Reset();
                    _noiseParametersList.GetArrayElementAtIndex(0).boxedValue = noiseParameters;
                }
            }

            GUI.backgroundColor = oldBackgroundColor;
            GUI.color = oldColor;
            GUI.contentColor = oldContentColor;


            EditorGUI.EndProperty();

            property.serializedObject.ApplyModifiedProperties();
        }

        public int InspectorPaintTexture(TerrainData terrainData, int layerId, Rect position)
        {
            //GUILayout.Label("Settings", EditorStyles.boldLabel);
            EditorGUI.BeginChangeCheck();
            float fieldWidth = EditorGUIUtility.fieldWidth;
            float labelWidth = EditorGUIUtility.labelWidth;
            EditorGUIUtility.fieldWidth = fieldWidth;
            EditorGUIUtility.labelWidth = labelWidth;
            if (layerId == -1)
                layerId = 1; //TerrainPaintUtility.FindTerrainLayerIndex(terrain, m_SelectedTerrainLayer);

            //Rewrite show terrain layers
            layerId = ShowTerrainLayersSelectionHelper(terrainData, layerId, position);

            if (EditorGUI.EndChangeCheck())
            {
                //m_SelectedTerrainLayer = _lakePolygon.baseProfile.currentSplatMap != -1 ? terrain.terrainData.terrainLayers[_lakePolygon.baseProfile.currentSplatMap] : null;
                //this.Save(true);
            }

            return layerId;
        }

        private int ShowTerrainLayersSelectionHelper(TerrainData terrainData, int activeTerrainLayer, Rect position)
        {
            int inUserData;
            if ((uint)terrainData.terrainLayers.Length > 0U)
            {
                TerrainLayer[] terrainLayers = terrainData.terrainLayers;
                GUIContent[] textures = new GUIContent[terrainLayers.Length];
                for (int index = 0; index < terrainLayers.Length; ++index)
                    textures[index] = new GUIContent()
                    {
                        image = terrainLayers[index] == null || terrainLayers[index].diffuseTexture == null
                            ? EditorGUIUtility.whiteTexture
                            : (Texture)(AssetPreview.GetAssetPreview(terrainLayers[index].diffuseTexture) ?? terrainLayers[index].diffuseTexture),
                        text = terrainLayers[index] == null ? "Missing" : terrainLayers[index].name,
                        tooltip = terrainLayers[index] == null ? "Missing" : terrainLayers[index].name
                    };
                // inUserData = TerrainInspector.AspectSelectionGridImageAndText(activeTerrainLayer, textures, 64, TerrainLayerUtility.s_Styles.errNoLayersFound, out bool _);

                if (_layerButtonStyle == null)
                {
                    _layerButtonStyle = "GridListText";
                    _layerButtonStyle.fixedHeight = 64;
                    _layerButtonStyle.fixedWidth = 64;
                }


                // style.
                inUserData = GUI.SelectionGrid(position, activeTerrainLayer, textures, 4, _layerButtonStyle);
            }
            else
                inUserData = -1;

            return inUserData;
        }
    }
}