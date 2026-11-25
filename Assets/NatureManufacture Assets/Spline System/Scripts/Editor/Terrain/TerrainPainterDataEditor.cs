// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    [CustomEditor(typeof(TerrainPainterData))]
    public class TerrainPainterDataEditor : UnityEditor.Editor
    {
        private SerializedProperty _terrainCarveQuality;

        //private SerializedProperty _cameraView;
        private SerializedProperty _brushAdditionalSize;
        private SerializedProperty _terrainCarve;
        private SerializedProperty _terrainSmooth;
        private SerializedProperty _terrainCarveStamp;
        private SerializedProperty _terrainSmoothStamp;
        private SerializedProperty _terrainStampTexture;
        
        private SerializedProperty _terrainNoiseParametersListCarve;
        private SerializedProperty _terrainLayersData;
        private SerializedProperty _distanceClearFoliage;
        private SerializedProperty _distanceClearFoliageTrees;

        private int _terrainLayersDataCount = 0;

        private void OnEnable()
        {
            TerrainLayerDataDrawer.CurrentTerrainData = null;

            if (target == null) return;

            _terrainCarveQuality = serializedObject.FindProperty("terrainCarveQuality");
            //_cameraView = serializedObject.FindProperty("cameraView");
            _brushAdditionalSize = serializedObject.FindProperty("brushAdditionalSize");
            _terrainCarve = serializedObject.FindProperty("terrainCarve");
            _terrainSmooth = serializedObject.FindProperty("smooth");
            _terrainCarveStamp = serializedObject.FindProperty("terrainCarveStamp");
            _terrainSmoothStamp = serializedObject.FindProperty("smoothStamp");
            _terrainStampTexture = serializedObject.FindProperty("stampTexture");
            
            _terrainNoiseParametersListCarve = serializedObject.FindProperty("terrainNoiseParametersListCarve");
            _terrainLayersData = serializedObject.FindProperty("terrainLayersData");
            _distanceClearFoliage = serializedObject.FindProperty("distanceClearFoliage");
            _distanceClearFoliageTrees = serializedObject.FindProperty("distanceClearFoliageTrees");

            _terrainLayersDataCount = _terrainLayersData.arraySize;
        }


        public override void OnInspectorGUI()
        {
            if (_terrainLayersDataCount == 0 && _terrainLayersData.arraySize == 1)
            {
                ((TerrainPainterData)target).TerrainLayersData[0].Reset();
            }

            _terrainLayersDataCount = _terrainLayersData.arraySize;


            GUILayout.Label("Main Settings:", EditorStyles.boldLabel);

            UIBaseSettings();

            UIBrushAdditional();
            GUILayout.Label("Terrain Carve:", EditorStyles.boldLabel);
            UICarve();
            
            GUILayout.Label("Terrain stamp:", EditorStyles.boldLabel);
            UIStamp();

            EditorGUILayout.Space();
            GUILayout.Label("Terrain Paint:", EditorStyles.boldLabel);
            UILayers();
            EditorGUILayout.Space();
            GUILayout.Label("Terrain Foliage:", EditorStyles.boldLabel);
            UIDistanceClearFoliage();
            UIDistanceClearFoliageTrees();
        }

        private void UIBaseSettings()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(_terrainCarveQuality);
            //EditorGUILayout.PropertyField(_cameraView);
            serializedObject.ApplyModifiedProperties();
        }

        public bool UIBrushAdditional()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(_brushAdditionalSize);
            bool modified = serializedObject.hasModifiedProperties;
            serializedObject.ApplyModifiedProperties();

            return modified;
        }

        public bool UICarve()
        {
            EditorGUILayout.Space();
            serializedObject.Update();
            EditorGUILayout.PropertyField(_terrainCarve);
            EditorGUILayout.PropertyField(_terrainSmooth);

            int arraySize = _terrainNoiseParametersListCarve.arraySize;
            EditorGUILayout.PropertyField(_terrainNoiseParametersListCarve);
            if (arraySize == 0 && _terrainNoiseParametersListCarve.arraySize == 1)
            {
                var noiseParameters = (TerrainNoiseParameters)_terrainNoiseParametersListCarve.GetArrayElementAtIndex(0).boxedValue;
                noiseParameters.Reset();
                _terrainNoiseParametersListCarve.GetArrayElementAtIndex(0).boxedValue = noiseParameters;
            }

            bool modified = serializedObject.hasModifiedProperties;
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();
            return modified;
        }
        
        
        public bool UIStamp()
        {
            EditorGUILayout.Space();
            serializedObject.Update();
            EditorGUILayout.PropertyField(_terrainCarveStamp);
            EditorGUILayout.PropertyField(_terrainSmoothStamp);
            EditorGUILayout.PropertyField(_terrainStampTexture);


            bool modified = serializedObject.hasModifiedProperties;
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();
            return modified;
        }

        public void UILayers(bool useTerrain = false)
        {
            EditorGUILayout.Space();
            if (useTerrain)
            {
                TerrainPainterData terrainPainterData = (TerrainPainterData)target;
                if (terrainPainterData.WorkTerrain != null)
                    TerrainLayerDataDrawer.CurrentTerrainData = terrainPainterData.WorkTerrain.terrainData;
            }

            serializedObject.Update();
            EditorGUILayout.PropertyField(_terrainLayersData, true);


            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();
        }

        public void UIDistanceClearFoliage()
        {
            EditorGUILayout.Space();
            serializedObject.Update();
            EditorGUILayout.PropertyField(_distanceClearFoliage, new GUIContent("Remove Details Distance"));
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();
        }

        public void UIDistanceClearFoliageTrees()
        {
            EditorGUILayout.Space();
            serializedObject.Update();
            EditorGUILayout.PropertyField(_distanceClearFoliageTrees, new GUIContent("Remove Trees Distance"));
            serializedObject.ApplyModifiedProperties();
            EditorGUILayout.Space();
        }
    }
}