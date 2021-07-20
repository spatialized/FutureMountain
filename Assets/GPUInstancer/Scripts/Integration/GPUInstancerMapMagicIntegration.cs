using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GPUInstancer
{
    [ExecuteInEditMode]
    public class GPUInstancerMapMagicIntegration : MonoBehaviour
    {
        public List<GPUInstancerPrototype> detailPrototypes;
        public List<GPUInstancerPrototype> treePrototypes;
        public List<GPUInstancerPrototype> prefabPrototypes;
        public GPUInstancerTerrainSettings terrainSettings;
        public bool importDetails;
        public bool importTrees;
        public bool importObjects;
        private bool _selectAllPrefabs;

        public bool autoSelectCamera = true;
        public GPUInstancerCameraData cameraData = new GPUInstancerCameraData(null);
        public bool isFrustumCulling = true;
        public bool isOcclusionCulling = true;
        public float minCullingDistance = 0;
        public int detailLayer = 0;
        public bool detailRunInThreads = true;
        public bool useSinglePrefabManager = false;
        public bool disableMeshRenderers = false;
        public bool prefabRunInThreads = false;

        public List<DetailPrototype> terrainDetailPrototypes;
        public List<TreePrototype> terrainTreePrototypes;
        public List<GameObject> prefabs;
        public List<GameObject> selectedPrefabs;

        public GPUInstancerPrefabManager prefabManagerInstance;

#if UNITY_EDITOR
        [HideInInspector]
        public GPUInstancerPrototype selectedDetailPrototype;
        public GPUInstancerPrototype selectedTreePrototype;
        public GPUInstancerPrototype selectedPrefabPrototype;
#endif


#if MAPMAGIC
        public MapMagic.MapMagic mapMagicInstance;

        private void Start()
        {
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                CheckPrototypeChanges();
            }
            else
            {
#endif
                MapMagic.MapMagic.OnApplyCompleted += MapMagicTerrainAddDetailManager;
                MapMagic.MapMagic.OnApplyCompleted += MapMagicTerrainAddTreeManager;
                if (useSinglePrefabManager)
                    MapMagic.MapMagic.OnApplyCompleted += MapMagicTerrainAddPrefabManagerSingleton;
                else
                    MapMagic.MapMagic.OnApplyCompleted += MapMagicTerrainAddPrefabManager;

                // for pinned terrains
                Terrain[] activeTerrains = Terrain.activeTerrains;
                if (activeTerrains != null)
                {
                    foreach (Terrain terrain in activeTerrains)
                    {
                        MapMagicTerrainAddDetailManager(terrain);
                        MapMagicTerrainAddTreeManager(terrain);
                        if (useSinglePrefabManager)
                            MapMagicTerrainAddPrefabManagerSingleton(terrain);
                        else
                            MapMagicTerrainAddPrefabManager(terrain);
                    }
                }
#if UNITY_EDITOR
            }
#endif
            if (GPUInstancerConstants.gpuiSettings == null)
                GPUInstancerConstants.gpuiSettings = GPUInstancerSettings.GetDefaultGPUInstancerSettings();
            GPUInstancerConstants.gpuiSettings.SetDefultBindings();
        }

#if UNITY_EDITOR
        private void LateUpdate()
        {
            if (!Application.isPlaying)
            {
                CheckPrototypeChanges();
            }
        }
#endif

        private void OnDestroy()
        {
            MapMagic.MapMagic.OnApplyCompleted -= MapMagicTerrainAddDetailManager;
            MapMagic.MapMagic.OnApplyCompleted -= MapMagicTerrainAddTreeManager;
            MapMagic.MapMagic.OnApplyCompleted -= MapMagicTerrainAddPrefabManager;
        }

        private void Reset()
        {
            if (mapMagicInstance == null)
                SetMapMagicInstance();
#if UNITY_EDITOR
            CheckPrototypeChanges();
#endif
        }

        public void SetMapMagicInstance()
        {
#if UNITY_EDITOR
            Undo.RecordObject(this, "GPUI Set Map Magic Instance");
#endif
            if (MapMagic.MapMagic.instance != null)
                mapMagicInstance = MapMagic.MapMagic.instance;
            else
                mapMagicInstance = FindObjectOfType<MapMagic.MapMagic>();
            importDetails = true;
            importTrees = true;
            importObjects = true;
            _selectAllPrefabs = true;
        }

        public void SetUpWithGeneratorsAsset()
        {
#if UNITY_EDITOR
            Undo.RecordObject(this, "GPUI Map Magic Setup");
#endif
            if (GPUInstancerConstants.gpuiSettings == null)
                GPUInstancerConstants.gpuiSettings = GPUInstancerSettings.GetDefaultGPUInstancerSettings();
            GPUInstancerConstants.gpuiSettings.SetDefultBindings();

            terrainDetailPrototypes = new List<DetailPrototype>();
            terrainTreePrototypes = new List<TreePrototype>();
            prefabs = new List<GameObject>();
            if (selectedPrefabs == null)
                selectedPrefabs = new List<GameObject>();

            if (mapMagicInstance == null)
                return;

            FillListsWithGeneratorsAsset(mapMagicInstance.gens);

            if (selectedPrefabs.Count > 0)
                selectedPrefabs.RemoveAll(p => !prefabs.Contains(p));
            else if (_selectAllPrefabs)
            {
                selectedPrefabs.AddRange(prefabs);
                _selectAllPrefabs = false;
            }
        }

        public void FillListsWithGeneratorsAsset(MapMagic.GeneratorsAsset generatorsAsset)
        {
            if (generatorsAsset == null)
                return;

            foreach (MapMagic.Generator generator in generatorsAsset.list)
            {
                // biome
                if (generator is MapMagic.Biome)
                {
                    MapMagic.Biome biome = (MapMagic.Biome)generator;
                    FillListsWithGeneratorsAsset(biome.data);
                }
                // detail instancing
                else if (generator is MapMagic.GrassOutput)
                {
                    MapMagic.GrassOutput gen = (MapMagic.GrassOutput)generator;
                    for (int i = 0; i < gen.baseLayers.Length; i++)
                    {
                        if (gen.baseLayers[i].det != null)
                            terrainDetailPrototypes.Add(gen.baseLayers[i].det);
                        else
                            Debug.LogWarning("Map Magic generator contains unassigned Grass Output values. Please assign or remove these values.");
                    }
                }
                // tree instancing
                else if (generator is MapMagic.TreesOutput)
                {
                    MapMagic.TreesOutput gen = (MapMagic.TreesOutput)generator;
                    for (int i = 0; i < gen.baseLayers.Length; i++)
                    {
                        if (gen.baseLayers[i].prefab != null)
                            terrainTreePrototypes.Add(new TreePrototype() { prefab = gen.baseLayers[i].prefab });
                        else
                            Debug.LogWarning("Map Magic generator contains unassigned Trees Output values. Please assign or remove these values.");
                    }
                }
                // prefab instancing
                else if (generator is MapMagic.ObjectOutput)
                {
                    MapMagic.ObjectOutput gen = (MapMagic.ObjectOutput)generator;
                    for (int i = 0; i < gen.baseLayers.Length; i++)
                    {
                        if (gen.baseLayers[i].prefab != null && !prefabs.Contains(gen.baseLayers[i].prefab.gameObject))
                        {
#if UNITY_EDITOR
#if UNITY_2018_3_OR_NEWER
                            if (PrefabUtility.GetPrefabAssetType(gen.baseLayers[i].prefab.gameObject) == PrefabAssetType.Model)
#else
                            if (PrefabUtility.GetPrefabType(gen.baseLayers[i].prefab.gameObject) == PrefabType.ModelPrefab)
#endif
                                Debug.LogWarning(GPUInstancerConstants.TEXT_PREFAB_TYPE_WARNING_3D + " " + gen.baseLayers[i].prefab.gameObject.name, gen.baseLayers[i].prefab.gameObject);
                            else
#endif
                                prefabs.Add(gen.baseLayers[i].prefab.gameObject);
                        }
                    }
                }
            }

        }

        public void GeneratePrototypes()
        {
#if UNITY_EDITOR
            Undo.RecordObject(this, "GPUI Set Map Magic Import");
            if (terrainSettings != null)
                AssetDatabase.DeleteAsset(AssetDatabase.GetAssetPath(terrainSettings));
#endif

            // import terrain details
            detailPrototypes = new List<GPUInstancerPrototype>();

            if (importDetails)
            {
                GenerateMapMagicTerrainSettings();
                GPUInstancerUtility.SetDetailInstancePrototypes(gameObject, detailPrototypes, terrainDetailPrototypes.ToArray(), 2, terrainSettings, true);
            }
            
            // import terrain trees
            treePrototypes = new List<GPUInstancerPrototype>();
            if (importTrees)
            {
                GenerateMapMagicTerrainSettings();
                GPUInstancerUtility.SetTreeInstancePrototypes(gameObject, treePrototypes, terrainTreePrototypes.ToArray(), terrainSettings, true);
            }

            // import prefabs
            prefabPrototypes = new List<GPUInstancerPrototype>();
            if (importObjects)
                GPUInstancerUtility.SetPrefabInstancePrototypes(gameObject, prefabPrototypes, selectedPrefabs, true);
            else
                selectedPrefabs.Clear();

            foreach(GameObject notSelectedPrefab in prefabs.FindAll(p => !selectedPrefabs.Contains(p)))
            {
                if(notSelectedPrefab.GetComponent<GPUInstancerPrefab>() != null)
                {
                    DestroyImmediate(notSelectedPrefab.GetComponent<GPUInstancerPrefab>(), true);
#if UNITY_EDITOR
                    EditorUtility.SetDirty(notSelectedPrefab);
#endif
                }
            }

#if UNITY_EDITOR
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
#endif
        }

        private void GenerateMapMagicTerrainSettings()
        {
            if (terrainSettings)
                return;

            terrainSettings = ScriptableObject.CreateInstance<GPUInstancerTerrainSettings>();
            terrainSettings.name = "GPUI_MapMagic_" + mapMagicInstance.gens.name + "_" + mapMagicInstance.gens.GetInstanceID();
            terrainSettings.maxDetailDistance = mapMagicInstance.detailDistance;
            terrainSettings.maxTreeDistance = mapMagicInstance.treeDistance;
            terrainSettings.detailDensity = mapMagicInstance.detailDensity;
            terrainSettings.healthyDryNoiseTexture = Resources.Load<Texture2D>(GPUInstancerConstants.NOISE_TEXTURES_PATH + GPUInstancerConstants.DEFAULT_HEALTHY_DRY_NOISE);
            terrainSettings.windWaveNormalTexture = Resources.Load<Texture2D>(GPUInstancerConstants.NOISE_TEXTURES_PATH + GPUInstancerConstants.DEFAULT_WIND_WAVE_NOISE);

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                string assetPath = GPUInstancerConstants.GetDefaultPath() + GPUInstancerConstants.PROTOTYPES_TERRAIN_PATH + terrainSettings.name + ".asset";

                if (!System.IO.Directory.Exists(GPUInstancerConstants.GetDefaultPath() + GPUInstancerConstants.PROTOTYPES_TERRAIN_PATH))
                {
                    System.IO.Directory.CreateDirectory(GPUInstancerConstants.GetDefaultPath() + GPUInstancerConstants.PROTOTYPES_TERRAIN_PATH);
                }

                AssetDatabase.CreateAsset(terrainSettings, assetPath);

                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }
#endif
        }

        private void MapMagicTerrainAddDetailManager(Terrain terrain)
        {
            if (terrain.GetComponent<GPUInstancerDetailManager>() == null && detailPrototypes != null && detailPrototypes.Count > 0)
            {
                GPUInstancerDetailManager newDetailManager = terrain.gameObject.AddComponent<GPUInstancerDetailManager>();
                newDetailManager.isFrustumCulling = isFrustumCulling;
                newDetailManager.isOcclusionCulling = isOcclusionCulling;
                newDetailManager.minCullingDistance = minCullingDistance;
                newDetailManager.detailLayer = detailLayer;
                newDetailManager.runInThreads = detailRunInThreads;
                newDetailManager.autoSelectCamera = autoSelectCamera;
                newDetailManager.cameraData.SetCamera(cameraData.mainCamera);
                newDetailManager.cameraData.renderOnlySelectedCamera = cameraData.renderOnlySelectedCamera;
                newDetailManager.cameraData.hiZOcclusionGenerator = null;
                newDetailManager.InitializeCameraData();
                // for mapmagic detail optimization
                if (terrain.terrainData.detailPrototypes.Length != detailPrototypes.Count)
                {
                    int terrainDetailIndex = 0;
                    List<GPUInstancerPrototype> newPrototypeList = new List<GPUInstancerPrototype>();
                    for(int i = 0; i < detailPrototypes.Count; i++)
                    {
                        if (terrainDetailIndex >= terrain.terrainData.detailPrototypes.Length)
                            break;

                        GPUInstancerDetailPrototype dp = (GPUInstancerDetailPrototype)detailPrototypes[i];
                        if(!terrain.terrainData.detailPrototypes[terrainDetailIndex].usePrototypeMesh && dp.prototypeTexture == terrain.terrainData.detailPrototypes[terrainDetailIndex].prototypeTexture)
                        {
                            newPrototypeList.Add(dp);
                            terrainDetailIndex++;
                        }
                        else if (terrain.terrainData.detailPrototypes[terrainDetailIndex].usePrototypeMesh && dp.prefabObject == terrain.terrainData.detailPrototypes[terrainDetailIndex].prototype)
                        {
                            newPrototypeList.Add(dp);
                            terrainDetailIndex++;
                        }
                    }
                    newDetailManager.prototypeList = newPrototypeList;
                }
                else
                    newDetailManager.prototypeList = detailPrototypes;
                newDetailManager.SetupManagerWithTerrain(terrain);

                newDetailManager.terrainSettings.maxDetailDistance = terrainSettings.maxDetailDistance;
                newDetailManager.terrainSettings.detailDensity = terrainSettings.detailDensity;
                newDetailManager.terrainSettings.healthyDryNoiseTexture = terrainSettings.healthyDryNoiseTexture;
                newDetailManager.terrainSettings.windWaveNormalTexture = terrainSettings.windWaveNormalTexture;
                newDetailManager.terrainSettings.windVector = terrainSettings.windVector;
                newDetailManager.terrainSettings.autoSPCellSize = terrainSettings.autoSPCellSize;
                newDetailManager.terrainSettings.preferedSPCellSize = terrainSettings.preferedSPCellSize;

                if (terrain.gameObject.activeSelf)
                    newDetailManager.InitializeRuntimeDataAndBuffers();
            }
        }

        private void MapMagicTerrainAddTreeManager(Terrain terrain)
        {
            if (terrain.GetComponent<GPUInstancerTreeManager>() == null && treePrototypes != null && treePrototypes.Count > 0)
            {
                GPUInstancerTreeManager newTreeManager = terrain.gameObject.AddComponent<GPUInstancerTreeManager>();
                newTreeManager.isFrustumCulling = isFrustumCulling;
                newTreeManager.isOcclusionCulling = isOcclusionCulling;
                newTreeManager.minCullingDistance = minCullingDistance;
                newTreeManager.autoSelectCamera = autoSelectCamera;
                newTreeManager.cameraData.SetCamera(cameraData.mainCamera);
                newTreeManager.cameraData.renderOnlySelectedCamera = cameraData.renderOnlySelectedCamera;
                newTreeManager.cameraData.hiZOcclusionGenerator = null;
                newTreeManager.InitializeCameraData();
                // for mapmagic tree optimization
                if (terrain.terrainData.treePrototypes.Length != treePrototypes.Count)
                {
                    int terrainTreeIndex = 0;
                    List<GPUInstancerPrototype> newPrototypeList = new List<GPUInstancerPrototype>();
                    for (int i = 0; i < treePrototypes.Count; i++)
                    {
                        if (terrainTreeIndex >= terrain.terrainData.treePrototypes.Length)
                            break;

                        GPUInstancerTreePrototype tp = (GPUInstancerTreePrototype)treePrototypes[i];
                        if (!terrain.terrainData.treePrototypes[terrainTreeIndex].prefab == tp.prefabObject)
                        {
                            newPrototypeList.Add(tp);
                            terrainTreeIndex++;
                        }
                    }
                    newTreeManager.prototypeList = newPrototypeList;
                }
                else
                    newTreeManager.prototypeList = treePrototypes;
                newTreeManager.SetupManagerWithTerrain(terrain);

                newTreeManager.terrainSettings.maxTreeDistance = terrainSettings.maxTreeDistance;

                if (terrain.gameObject.activeSelf)
                    newTreeManager.InitializeRuntimeDataAndBuffers();
            }
        }

        private void MapMagicTerrainAddPrefabManager(Terrain terrain)
        {
            if (terrain.GetComponent<GPUInstancerPrefabManager>() == null && prefabPrototypes != null && prefabPrototypes.Count > 0)
            {
                GPUInstancerPrefab[] prefabList = terrain.gameObject.GetComponentsInChildren<GPUInstancerPrefab>(true);
                if (prefabList.Length > 0)
                {
                    GPUInstancerPrefabManager newPrefabManager = terrain.gameObject.AddComponent<GPUInstancerPrefabManager>();
                    newPrefabManager.isFrustumCulling = isFrustumCulling;
                    newPrefabManager.isOcclusionCulling = isOcclusionCulling;
                    newPrefabManager.minCullingDistance = minCullingDistance;
                    newPrefabManager.autoSelectCamera = autoSelectCamera;
                    newPrefabManager.cameraData.SetCamera(cameraData.mainCamera);
                    newPrefabManager.cameraData.renderOnlySelectedCamera = cameraData.renderOnlySelectedCamera;
                    newPrefabManager.cameraData.hiZOcclusionGenerator = null;
                    newPrefabManager.InitializeCameraData();
                    newPrefabManager.enableMROnManagerDisable = false;

                    newPrefabManager.prototypeList = prefabPrototypes;
                    newPrefabManager.RegisterPrefabInstanceList(prefabList);
                    if (terrain.gameObject.activeSelf)
                        newPrefabManager.InitializeRuntimeDataAndBuffers();
                }
            }
        }

        private void MapMagicTerrainAddPrefabManagerSingleton(Terrain terrain)
        {
            if (prefabPrototypes != null && prefabPrototypes.Count > 0)
            {
                if (prefabManagerInstance == null)
                {
                    GameObject prefabManagerInstanceGO = new GameObject("GPUI Prefab Manager");
                    prefabManagerInstance = prefabManagerInstanceGO.AddComponent<GPUInstancerPrefabManager>();
                    prefabManagerInstance.isFrustumCulling = isFrustumCulling;
                    prefabManagerInstance.isOcclusionCulling = isOcclusionCulling;
                    prefabManagerInstance.minCullingDistance = minCullingDistance;
                    prefabManagerInstance.autoSelectCamera = autoSelectCamera;
                    prefabManagerInstance.cameraData.SetCamera(cameraData.mainCamera);
                    prefabManagerInstance.cameraData.renderOnlySelectedCamera = cameraData.renderOnlySelectedCamera;
                    prefabManagerInstance.cameraData.hiZOcclusionGenerator = null;
                    prefabManagerInstance.InitializeCameraData();
                    prefabManagerInstance.enableMROnRemoveInstance = false;
                    prefabManagerInstance.enableMROnManagerDisable = false;

                    prefabManagerInstance.prototypeList = prefabPrototypes;
                    prefabManagerInstance.InitializeRuntimeDataAndBuffers();
                }

                GPUInstancerPrefabListRuntimeHandler plrh = terrain.gameObject.GetComponent<GPUInstancerPrefabListRuntimeHandler>();
                if (plrh == null)
                    plrh = terrain.gameObject.AddComponent<GPUInstancerPrefabListRuntimeHandler>();
                plrh.runInThreads = prefabRunInThreads;
                plrh.SetManager(prefabManagerInstance);
            }
        }
#endif // MAPMAGIC

#if UNITY_EDITOR
        public void CheckPrototypeChanges()
        {
            if (GPUInstancerConstants.gpuiSettings == null)
                GPUInstancerConstants.gpuiSettings = GPUInstancerSettings.GetDefaultGPUInstancerSettings();
            GPUInstancerConstants.gpuiSettings.SetDefultBindings();

            if (GPUInstancerConstants.gpuiSettings.shaderBindings != null)
            {
                GPUInstancerConstants.gpuiSettings.shaderBindings.ClearEmptyShaderInstances();

                CheckForShaderBindings(detailPrototypes);
                CheckForShaderBindings(treePrototypes);
                CheckForShaderBindings(prefabPrototypes);
            }
            if (GPUInstancerConstants.gpuiSettings.billboardAtlasBindings != null)
            {
                GPUInstancerConstants.gpuiSettings.billboardAtlasBindings.ClearEmptyBillboardAtlases();

                CheckForBillboardBindinds(detailPrototypes);
                CheckForBillboardBindinds(treePrototypes);
                CheckForBillboardBindinds(prefabPrototypes);
            }
        }

        public void CheckForShaderBindings(List<GPUInstancerPrototype> prototypeList)
        {
            if (prototypeList != null)
            {
                foreach (GPUInstancerPrototype prototype in prototypeList)
                {
                    if (prototype.prefabObject != null)
                    {
                        GPUInstancerUtility.GenerateInstancedShadersForGameObject(prototype);
                        if (string.IsNullOrEmpty(prototype.warningText))
                        {
                            if (prototype.prefabObject.GetComponentInChildren<MeshRenderer>() == null)
                            {
                                prototype.warningText = "Prefab object does not contain any Mesh Renderers.";
                            }
                        }
                    }
                }
            }
        }

        public void CheckForBillboardBindinds(List<GPUInstancerPrototype> prototypeList)
        {
            //if (prototypeList != null)
            //{
            //    foreach (GPUInstancerPrototype prototype in prototypeList)
            //    {
            //        if (prototype.prefabObject != null && prototype.useGeneratedBillboard &&
            //                (prototype.billboard == null || prototype.billboard.albedoAtlasTexture == null || prototype.billboard.normalAtlasTexture == null))
            //            GPUInstancerUtility.GeneratePrototypeBillboard(prototype, billboardAtlasBindings);
            //    }
            //}
        }
#endif

        public void SetCamera(Camera camera)
        {
            cameraData.mainCamera = camera;
            GPUInstancerAPI.SetCamera(camera);
        }
    }
}
