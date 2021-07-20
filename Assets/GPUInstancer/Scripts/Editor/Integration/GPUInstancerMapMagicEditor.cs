using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace GPUInstancer
{
    [CustomEditor(typeof(GPUInstancerMapMagicIntegration))]
    [CanEditMultipleObjects]
    public class GPUInstancerMapMagicEditor : GPUInstancerEditor
    {
        protected SerializedProperty prop_detailRunInThreads;
        protected SerializedProperty prop_prefabRunInThreads;
        protected SerializedProperty prop_prefabDisableMR;
        protected SerializedProperty prop_prefabSingleton;

        private GPUInstancerMapMagicIntegration _mapMagicIntegration;

        protected override void OnEnable()
        {
            base.OnEnable();

            wikiHash = "#MapMagic_World_Generator";

            prop_detailRunInThreads = serializedObject.FindProperty("detailRunInThreads");
            prop_prefabRunInThreads = serializedObject.FindProperty("prefabRunInThreads");
            prop_prefabDisableMR = serializedObject.FindProperty("disableMeshRenderers");
            prop_prefabSingleton = serializedObject.FindProperty("useSinglePrefabManager");

            _mapMagicIntegration = (target as GPUInstancerMapMagicIntegration);
            FillPrototypeList();
        }

        public override void FillPrototypeList()
        {
            prototypeList = new List<GPUInstancerPrototype>();
            if (_mapMagicIntegration.detailPrototypes != null && _mapMagicIntegration.detailPrototypes.Count > 0)
                prototypeList.AddRange(_mapMagicIntegration.detailPrototypes);
            if (_mapMagicIntegration.treePrototypes != null && _mapMagicIntegration.treePrototypes.Count > 0)
                prototypeList.AddRange(_mapMagicIntegration.treePrototypes);
            if (_mapMagicIntegration.prefabPrototypes != null && _mapMagicIntegration.prefabPrototypes.Count > 0)
                prototypeList.AddRange(_mapMagicIntegration.prefabPrototypes);
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            if (_mapMagicIntegration.cameraData.mainCamera == null)
                _mapMagicIntegration.cameraData.SetCamera(Camera.main);

            base.OnInspectorGUI();
#if MAPMAGIC
            if (_mapMagicIntegration.mapMagicInstance == null)
            {
                // set map magic instance

                EditorGUI.BeginDisabledGroup(Application.isPlaying);
                GUILayout.Space(10);
                Rect buttonRect = GUILayoutUtility.GetRect(100, 40, GUILayout.ExpandWidth(true), GUILayout.ExpandHeight(false));

                GPUInstancerEditorConstants.DrawColoredButton(GPUInstancerEditorConstants.Contents.mapMagicSet, GPUInstancerEditorConstants.Colors.lightBlue, Color.black, FontStyle.Bold, buttonRect,
                    () =>
                    {
                        _mapMagicIntegration.SetMapMagicInstance();
                    });
                DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_setMapMagic, true);
                GUILayout.Space(10);
                EditorGUI.EndDisabledGroup();
                return;
            }
            else
            {
                // import box
                _mapMagicIntegration.SetUpWithGeneratorsAsset();
                EditorGUI.BeginDisabledGroup(Application.isPlaying);
                DrawMapMagicImportBox();
                EditorGUI.EndDisabledGroup();


                if ((_mapMagicIntegration.detailPrototypes != null && _mapMagicIntegration.detailPrototypes.Count > 0) ||
                    (_mapMagicIntegration.prefabPrototypes != null && _mapMagicIntegration.prefabPrototypes.Count > 0) ||
                    (_mapMagicIntegration.treePrototypes != null && _mapMagicIntegration.treePrototypes.Count > 0)
                    )
                {
                    EditorGUI.BeginDisabledGroup(Application.isPlaying);
                    EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
                    EditorGUILayout.BeginHorizontal();
                    GUILayout.FlexibleSpace();
                    GUILayout.Label(GPUInstancerEditorConstants.TEXT_sceneSettings, GPUInstancerEditorConstants.Styles.boldLabel);
                    GUILayout.FlexibleSpace();
                    EditorGUILayout.EndHorizontal();

                    DrawCameraDataFields();
                    DrawCullingSettings(prototypeList);
                    EditorGUI.EndDisabledGroup();

                    EditorGUILayout.EndVertical();

                    int prototypeCount = (_mapMagicIntegration.detailPrototypes != null ? _mapMagicIntegration.detailPrototypes.Count : 0) +
                        (_mapMagicIntegration.treePrototypes != null ? _mapMagicIntegration.treePrototypes.Count : 0) +
                        (_mapMagicIntegration.prefabPrototypes != null ? _mapMagicIntegration.prefabPrototypes.Count : 0);

                    if (prototypeContents == null || prototypeContents.Length != prototypeCount)
                        GeneratePrototypeContents();

                    // prototypes editor
                    if (_mapMagicIntegration.detailPrototypes != null && _mapMagicIntegration.detailPrototypes.Count > 0)
                    {
                        DrawMapMagicDetailGlobalInfoBox();
                        DrawMapMagicDetailPrototypesBox();
                    }
                    if (_mapMagicIntegration.treePrototypes != null && _mapMagicIntegration.treePrototypes.Count > 0)
                    {
                        DrawMapMagicTreePrototypesBox();
                    }

                    if (_mapMagicIntegration.prefabPrototypes != null && _mapMagicIntegration.prefabPrototypes.Count > 0)
                    {
                        DrawMapMagicPrefabGlobalInfoBox();
                        DrawMapMagicPrefabPrototypesBox();
                    }
                }
            }
#else
            EditorGUILayout.HelpBox("Map Magic is not present!", MessageType.Error);
#endif

            serializedObject.ApplyModifiedProperties();

            base.InspectorGUIEnd();
        }

#if MAPMAGIC
        public void DrawMapMagicImportBox()
        {
            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_mapMagicImporter, GPUInstancerEditorConstants.Styles.boldLabel);
            _mapMagicIntegration.importDetails = EditorGUILayout.Toggle(GPUInstancerEditorConstants.TEXT_mapMagicImportDetails, _mapMagicIntegration.importDetails);
            _mapMagicIntegration.importTrees = EditorGUILayout.Toggle(GPUInstancerEditorConstants.TEXT_mapMagicImportTrees, _mapMagicIntegration.importTrees);

            if (_mapMagicIntegration.prefabs != null && _mapMagicIntegration.prefabs.Count > 0)
            {
                _mapMagicIntegration.importObjects = EditorGUILayout.Toggle(GPUInstancerEditorConstants.TEXT_mapMagicImportObjects, _mapMagicIntegration.importObjects);
                if (_mapMagicIntegration.importObjects)
                {
                    EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
                    GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_mapMagicObjectsList, GPUInstancerEditorConstants.Styles.boldLabel);

                    foreach (GameObject prefab in _mapMagicIntegration.prefabs)
                    {
                        bool isPrefabSelected = _mapMagicIntegration.selectedPrefabs.Contains(prefab);
                        bool result = EditorGUILayout.Toggle(prefab.gameObject.name, isPrefabSelected);
                        if (result && !isPrefabSelected)
                            _mapMagicIntegration.selectedPrefabs.Add(prefab);
                        else if (!result && isPrefabSelected)
                            _mapMagicIntegration.selectedPrefabs.Remove(prefab);
                    }

                    EditorGUILayout.EndVertical();
                }
            }

            Rect buttonRect = GUILayoutUtility.GetRect(100, 25, GUILayout.ExpandWidth(true), GUILayout.ExpandHeight(false));
            GPUInstancerEditorConstants.DrawColoredButton(GPUInstancerEditorConstants.Contents.mapMagicImport, GPUInstancerEditorConstants.Colors.lightBlue, Color.white, FontStyle.Bold, buttonRect,
                    () =>
                    {
                        _mapMagicIntegration.GeneratePrototypes();

                        prototypeList = new List<GPUInstancerPrototype>();
                        if (_mapMagicIntegration.detailPrototypes != null && _mapMagicIntegration.detailPrototypes.Count > 0)
                            prototypeList.AddRange(_mapMagicIntegration.detailPrototypes);
                        if (_mapMagicIntegration.treePrototypes != null && _mapMagicIntegration.treePrototypes.Count > 0)
                            prototypeList.AddRange(_mapMagicIntegration.treePrototypes);
                        if (_mapMagicIntegration.prefabPrototypes != null && _mapMagicIntegration.prefabPrototypes.Count > 0)
                            prototypeList.AddRange(_mapMagicIntegration.prefabPrototypes);
                        prototypeContents = null;
                    });
            EditorGUILayout.EndVertical();
        }

        public void DrawMapMagicDetailGlobalInfoBox()
        {
            EditorGUI.BeginDisabledGroup(Application.isPlaying);
            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_detailGlobal, GPUInstancerEditorConstants.Styles.boldLabel);
            EditorGUI.BeginChangeCheck();

            EditorGUI.BeginDisabledGroup(true);
            EditorGUILayout.ObjectField(GPUInstancerEditorConstants.TEXT_terrainSettingsSO, _mapMagicIntegration.terrainSettings, typeof(GPUInstancerTerrainSettings), false);
            EditorGUI.EndDisabledGroup();

            float newMaxDetailDistance = EditorGUILayout.Slider(GPUInstancerEditorConstants.TEXT_maxDetailDistance, _mapMagicIntegration.terrainSettings.maxDetailDistance, 0, 500);
            if (_mapMagicIntegration.terrainSettings.maxDetailDistance != newMaxDetailDistance)
            {
                foreach (GPUInstancerDetailPrototype p in _mapMagicIntegration.detailPrototypes)
                {
                    if (p.maxDistance == _mapMagicIntegration.terrainSettings.maxDetailDistance || p.maxDistance > newMaxDetailDistance)
                    {
                        p.maxDistance = newMaxDetailDistance;
                        EditorUtility.SetDirty(p);
                    }
                }
                _mapMagicIntegration.terrainSettings.maxDetailDistance = newMaxDetailDistance;
            }
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_maxDetailDistance);
            EditorGUILayout.Space();

            float newDetailDensity = EditorGUILayout.Slider(GPUInstancerEditorConstants.TEXT_detailDensity, _mapMagicIntegration.terrainSettings.detailDensity, 0.0f, 1.0f);
            if (_mapMagicIntegration.terrainSettings.detailDensity != newDetailDensity)
            {
                foreach (GPUInstancerDetailPrototype p in _mapMagicIntegration.detailPrototypes)
                {
                    if (p.detailDensity == _mapMagicIntegration.terrainSettings.detailDensity || p.detailDensity > newDetailDensity)
                    {
                        p.detailDensity = newDetailDensity;
                        EditorUtility.SetDirty(p);
                    }
                }
                _mapMagicIntegration.terrainSettings.detailDensity = newDetailDensity;
            }
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_detailDensity);
            EditorGUILayout.Space();

            _mapMagicIntegration.detailLayer = EditorGUILayout.LayerField(GPUInstancerEditorConstants.TEXT_detailLayer, _mapMagicIntegration.detailLayer);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_detailLayer);
            EditorGUILayout.Space();

            _mapMagicIntegration.terrainSettings.windVector = EditorGUILayout.Vector2Field(GPUInstancerEditorConstants.TEXT_windVector, _mapMagicIntegration.terrainSettings.windVector);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_windVector);
            EditorGUILayout.Space();

            _mapMagicIntegration.terrainSettings.healthyDryNoiseTexture = (Texture2D)EditorGUILayout.ObjectField(GPUInstancerEditorConstants.TEXT_healthyDryNoiseTexture, _mapMagicIntegration.terrainSettings.healthyDryNoiseTexture, typeof(Texture2D), false);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_healthyDryNoiseTexture);
            if (_mapMagicIntegration.terrainSettings.healthyDryNoiseTexture == null)
                _mapMagicIntegration.terrainSettings.healthyDryNoiseTexture = Resources.Load<Texture2D>(GPUInstancerConstants.NOISE_TEXTURES_PATH + GPUInstancerConstants.DEFAULT_HEALTHY_DRY_NOISE);

            _mapMagicIntegration.terrainSettings.windWaveNormalTexture = (Texture2D)EditorGUILayout.ObjectField(GPUInstancerEditorConstants.TEXT_windWaveNormalTexture, _mapMagicIntegration.terrainSettings.windWaveNormalTexture, typeof(Texture2D), false);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_windWaveNormalTexture);
            if (_mapMagicIntegration.terrainSettings.windWaveNormalTexture == null)
                _mapMagicIntegration.terrainSettings.windWaveNormalTexture = Resources.Load<Texture2D>(GPUInstancerConstants.NOISE_TEXTURES_PATH + GPUInstancerConstants.DEFAULT_WIND_WAVE_NOISE);

            _mapMagicIntegration.terrainSettings.autoSPCellSize = EditorGUILayout.Toggle(GPUInstancerEditorConstants.TEXT_autoSPCellSize, _mapMagicIntegration.terrainSettings.autoSPCellSize);
            if (!_mapMagicIntegration.terrainSettings.autoSPCellSize)
                _mapMagicIntegration.terrainSettings.preferedSPCellSize = EditorGUILayout.IntSlider(GPUInstancerEditorConstants.TEXT_preferedSPCellSize, _mapMagicIntegration.terrainSettings.preferedSPCellSize, 25, 500);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_spatialPartitioningCellSize);

            EditorGUILayout.PropertyField(prop_detailRunInThreads, GPUInstancerEditorConstants.Contents.runInThreads);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_runInThreads);

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_mapMagicIntegration, "Editor data changed.");
                EditorUtility.SetDirty(_mapMagicIntegration.terrainSettings);
            }

            EditorGUILayout.EndVertical();
            EditorGUI.EndDisabledGroup();
        }

        public void DrawMapMagicDetailPrototypesBox()
        {
            int prototypeRowCount = Mathf.FloorToInt((EditorGUIUtility.currentViewWidth - 30f) / PROTOTYPE_RECT_SIZE);

            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_mapMagicDetailPrototypes, GPUInstancerEditorConstants.Styles.boldLabel);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_prototypes);

            int i = 0;
            EditorGUILayout.BeginHorizontal();
            foreach (GPUInstancerPrototype prototype in _mapMagicIntegration.detailPrototypes)
            {
                if (prototype == null)
                    continue;
                if (i != 0 && i % prototypeRowCount == 0)
                {
                    EditorGUILayout.EndHorizontal();
                    EditorGUILayout.BeginHorizontal();
                }

                if (prototypeContents != null && prototypeContents.Length > i && prototypeContents[i] != null)
                {
                    DrawGPUInstancerPrototypeButton(prototype, prototypeContents[i], prototype == _mapMagicIntegration.selectedDetailPrototype, () =>
                    {
                        _mapMagicIntegration.selectedDetailPrototype = prototype;
                        GUI.FocusControl(prototypeContents[i].tooltip);
                    });
                }
                i++;
            }

            if (i != 0 && i % prototypeRowCount == 0)
            {
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.BeginHorizontal();
            }

            EditorGUILayout.EndHorizontal();

            DrawGPUInstancerPrototypeBox(_mapMagicIntegration.selectedDetailPrototype, prop_isManagerFrustumCulling.boolValue, prop_isManagerOcclusionCulling.boolValue);

            EditorGUILayout.EndVertical();
        }

        public void DrawMapMagicTreePrototypesBox()
        {
            int prototypeRowCount = Mathf.FloorToInt((EditorGUIUtility.currentViewWidth - 30f) / PROTOTYPE_RECT_SIZE);

            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_mapMagicTreePrototypes, GPUInstancerEditorConstants.Styles.boldLabel);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_prototypes);

            int i = 0;
            EditorGUILayout.BeginHorizontal();
            foreach (GPUInstancerPrototype prototype in _mapMagicIntegration.treePrototypes)
            {
                if (prototype == null)
                    continue;

                int prototypeContentIndex = (_mapMagicIntegration.detailPrototypes == null ? 0 : _mapMagicIntegration.detailPrototypes.Count) + i;

                if (i != 0 && i % prototypeRowCount == 0)
                {
                    EditorGUILayout.EndHorizontal();
                    EditorGUILayout.BeginHorizontal();
                }

                if (prototypeContents != null && prototypeContents.Length > prototypeContentIndex && prototypeContents[prototypeContentIndex] != null)
                {
                    DrawGPUInstancerPrototypeButton(prototype, prototypeContents[prototypeContentIndex], prototype == _mapMagicIntegration.selectedTreePrototype, () =>
                    {
                        _mapMagicIntegration.selectedTreePrototype = prototype;
                        GUI.FocusControl(prototypeContents[prototypeContentIndex].tooltip);
                    });
                }
                i++;
            }

            if (i != 0 && i % prototypeRowCount == 0)
            {
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.BeginHorizontal();
            }

            EditorGUILayout.EndHorizontal();

            DrawGPUInstancerPrototypeBox(_mapMagicIntegration.selectedTreePrototype, prop_isManagerFrustumCulling.boolValue, prop_isManagerOcclusionCulling.boolValue);

            EditorGUILayout.EndVertical();
        }

        public void DrawMapMagicPrefabGlobalInfoBox()
        {
            EditorGUI.BeginDisabledGroup(Application.isPlaying);
            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_prefabGlobal, GPUInstancerEditorConstants.Styles.boldLabel);

            EditorGUILayout.PropertyField(prop_prefabSingleton, GPUInstancerEditorConstants.Contents.useSinglePrefabManager);

            bool disableMeshRenderers = prop_prefabDisableMR.boolValue;
            EditorGUILayout.PropertyField(prop_prefabDisableMR, GPUInstancerEditorConstants.Contents.disableMeshRenderers);

            if (prop_prefabDisableMR.boolValue && prop_prefabSingleton.boolValue)
                EditorGUILayout.PropertyField(prop_prefabRunInThreads, GPUInstancerEditorConstants.Contents.runInThreads);
            else
            {
                EditorGUI.BeginDisabledGroup(true);
                EditorGUILayout.PropertyField(prop_prefabRunInThreads, GPUInstancerEditorConstants.Contents.runInThreads);
                EditorGUI.EndDisabledGroup();
                prop_prefabRunInThreads.boolValue = false;
            }

            foreach (GPUInstancerPrefabPrototype prefabPrototype in _mapMagicIntegration.prefabPrototypes)
            {
                if (disableMeshRenderers != prop_prefabDisableMR.boolValue)
                {
                    GPUInstancerPrefabManagerEditor.SetRenderersEnabled(prefabPrototype, disableMeshRenderers);
                }
            }

            EditorGUILayout.EndVertical();
            EditorGUI.EndDisabledGroup();
        }

        public void DrawMapMagicPrefabPrototypesBox()
        {
            int prototypeRowCount = Mathf.FloorToInt((EditorGUIUtility.currentViewWidth - 30f) / PROTOTYPE_RECT_SIZE);

            EditorGUILayout.BeginVertical(GPUInstancerEditorConstants.Styles.box);
            GPUInstancerEditorConstants.DrawCustomLabel(GPUInstancerEditorConstants.TEXT_mapMagicPrefabPrototypes, GPUInstancerEditorConstants.Styles.boldLabel);
            DrawHelpText(GPUInstancerEditorConstants.HELPTEXT_prototypes);

            int i = 0;
            EditorGUILayout.BeginHorizontal();
            foreach (GPUInstancerPrototype prototype in _mapMagicIntegration.prefabPrototypes)
            {
                if (prototype == null)
                    continue;

                int prototypeContentIndex = (_mapMagicIntegration.detailPrototypes == null ? 0 : _mapMagicIntegration.detailPrototypes.Count)
                    + (_mapMagicIntegration.treePrototypes == null ? 0 : _mapMagicIntegration.treePrototypes.Count) + i;

                if (i != 0 && i % prototypeRowCount == 0)
                {
                    EditorGUILayout.EndHorizontal();
                    EditorGUILayout.BeginHorizontal();
                }

                if (prototypeContents != null && prototypeContents.Length > prototypeContentIndex && prototypeContents[prototypeContentIndex] != null)
                {
                    DrawGPUInstancerPrototypeButton(prototype, prototypeContents[prototypeContentIndex], prototype == _mapMagicIntegration.selectedPrefabPrototype, () =>
                    {
                        _mapMagicIntegration.selectedPrefabPrototype = prototype;
                        GUI.FocusControl(prototypeContents[prototypeContentIndex].tooltip);
                    });
                }
                i++;
            }

            if (i != 0 && i % prototypeRowCount == 0)
            {
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.BeginHorizontal();
            }

            EditorGUILayout.EndHorizontal();

            DrawGPUInstancerPrototypeBox(_mapMagicIntegration.selectedPrefabPrototype, prop_isManagerFrustumCulling.boolValue, prop_isManagerOcclusionCulling.boolValue);

            EditorGUILayout.EndVertical();
        }
#endif

        public override void DrawGPUInstancerPrototypeActions()
        {
        }

        public override bool DrawGPUInstancerPrototypeInfo(List<GPUInstancerPrototype> selectedPrototypeList)
        {
            return false;
        }

        public override void DrawGPUInstancerPrototypeInfo(GPUInstancerPrototype selectedPrototype)
        {
            if (selectedPrototype is GPUInstancerDetailPrototype)
            {
                GPUInstancerDetailManagerEditor.DrawGPUInstancerPrototypeInfo(selectedPrototype, (string t) => { DrawHelpText(t); }, _mapMagicIntegration, null, 
                    null, _mapMagicIntegration.terrainSettings, _mapMagicIntegration.detailLayer);
            }
            else if (selectedPrototype is GPUInstancerTreePrototype)
            {
                GPUInstancerTreeManagerEditor.DrawGPUInstancerPrototypeInfo(selectedPrototype, (string t) => { DrawHelpText(t); }, _mapMagicIntegration, null, 
                    null, _mapMagicIntegration.terrainSettings);
            }
            else
            {
                GPUInstancerPrefabManagerEditor.DrawGPUInstancerPrototypeInfo(selectedPrototype, (string t) => { DrawHelpText(t); });
            }
        }

        public override void DrawSettingContents()
        {
        }

        public override float GetMaxDistance(GPUInstancerPrototype selectedPrototype)
        {
            if (selectedPrototype == null)
                return GPUInstancerConstants.gpuiSettings.MAX_DETAIL_DISTANCE;
            return selectedPrototype is GPUInstancerPrefabPrototype ?
                GPUInstancerConstants.gpuiSettings.MAX_PREFAB_DISTANCE :
                (selectedPrototype is GPUInstancerTreePrototype ?
                    GPUInstancerConstants.gpuiSettings.MAX_TREE_DISTANCE :
                    GPUInstancerConstants.gpuiSettings.MAX_DETAIL_DISTANCE);
        }
    }
}