using System.Collections.Generic;
using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace GPUInstancer
{
    /// <summary>
    /// Add this to a Unity terrain for GPU Instancing terrain trees at runtime.
    /// </summary>
    [ExecuteInEditMode]
    public class GPUInstancerTreeManager : GPUInstancerTerrainManager
    {
        private static ComputeShader _treeInstantiationComputeShader;
        public bool initializeWithCoroutine = true;

        #region Monobehavior Methods
        public override void Awake()
        {
            base.Awake();

            if (_treeInstantiationComputeShader == null)
                _treeInstantiationComputeShader = Resources.Load<ComputeShader>(GPUInstancerConstants.TREE_INSTANTIATION_RESOURCE_PATH);
        }

        #endregion Monobehavior Methods

        #region Override Methods

        public override void ClearInstancingData()
        {
            base.ClearInstancingData();

            if (terrain != null && terrain.treeDistance == 0)
            {
                terrain.treeDistance = terrainSettings.maxTreeDistance;
            }
        }

        public override void GeneratePrototypes(bool forceNew = false)
        {
            base.GeneratePrototypes(forceNew);

            if (terrainSettings != null && terrain != null && terrain.terrainData != null)
            {
                GPUInstancerUtility.SetTreeInstancePrototypes(gameObject, prototypeList, terrain.terrainData.treePrototypes, terrainSettings, forceNew);
            }
        }

#if UNITY_EDITOR
        public override void CheckPrototypeChanges()
        {
            base.CheckPrototypeChanges();

            if (!Application.isPlaying && terrainSettings != null && terrain != null && terrain.terrainData != null)
            {
                if (prototypeList.Count != terrain.terrainData.treePrototypes.Length)
                {
                    GeneratePrototypes();
                }

                int index = 0;
                foreach (GPUInstancerTreePrototype prototype in prototypeList)
                {
                    prototype.prototypeIndex = index;
                    index++;
                }
            }
        }
#endif

        public override void InitializeRuntimeDataAndBuffers(bool forceNew = true)
        {
            base.InitializeRuntimeDataAndBuffers(forceNew);

            if (!forceNew && isInitialized)
                return;

            if (terrainSettings == null)
                return;

            if (prototypeList != null && prototypeList.Count > 0)
            {
                GPUInstancerUtility.AddTreeInstanceRuntimeDataToList(runtimeDataList, prototypeList, terrainSettings);
            }

            StartCoroutine(ReplaceUnityTrees());

            isInitialized = true;
        }

        public override void DeletePrototype(GPUInstancerPrototype prototype, bool removeSO = true)
        {
            if (terrainSettings != null && terrain != null && terrain.terrainData != null)
            {
                int treePrototypeIndex = prototypeList.IndexOf(prototype);

                TreePrototype[] treePrototypes = terrain.terrainData.treePrototypes;
                List<TreePrototype> newTreePrototypes = new List<TreePrototype>(treePrototypes);
                List<TreeInstance> newTreeInstanceList = new List<TreeInstance>();
                TreeInstance treeInstance;

                for (int i = 0; i < terrain.terrainData.treeInstances.Length; i++)
                {
                    treeInstance = terrain.terrainData.treeInstances[i];
                    if (treeInstance.prototypeIndex < treePrototypeIndex)
                    {
                        newTreeInstanceList.Add(treeInstance);
                    }
                    else if (treeInstance.prototypeIndex > treePrototypeIndex)
                    {
                        treeInstance.prototypeIndex = treeInstance.prototypeIndex - 1;
                        newTreeInstanceList.Add(treeInstance);
                    }
                }

                if (newTreePrototypes.Count > treePrototypeIndex)
                    newTreePrototypes.RemoveAt(treePrototypeIndex);

                terrain.terrainData.treeInstances = newTreeInstanceList.ToArray();
                terrain.terrainData.treePrototypes = newTreePrototypes.ToArray();

                terrain.terrainData.RefreshPrototypes();

                if (removeSO)
                    base.DeletePrototype(prototype, removeSO);
                GeneratePrototypes(false);
                if (!removeSO)
                    base.DeletePrototype(prototype, removeSO);
            }
            else
                base.DeletePrototype(prototype, removeSO);
        }

        #endregion Override Methods

        public IEnumerator ReplaceUnityTrees()
        {
            TreeInstance[] treeInstances = terrain.terrainData.treeInstances;
            int instanceTotal = treeInstances.Length;

            if (instanceTotal > 0)
            {
                Vector3 treePos = Vector3.zero;
                TreeInstance treeInstance;

                Vector4[] treeScales = new Vector4[prototypeList.Count];
                int count = 0;
                foreach (GPUInstancerTreePrototype tp in prototypeList)
                {
                    treeScales[count] = tp.isApplyPrefabScale ? tp.prefabObject.transform.localScale : Vector3.one;
                    count++;
                }

                terrain.treeDistance = 0f; // will not persist if called at runtime.

                Vector4[] treeDataArray = new Vector4[instanceTotal * 2]; // prototypeIndex - positionx3 - rotation - scalex2
                int[] instanceCounts = new int[terrain.terrainData.treePrototypes.Length];

                int index = 0;
                for (int i = 0; i < instanceTotal; i++)
                {
                    treeInstance = treeInstances[i];
                    treePos = treeInstance.position;

                    treeDataArray[index].x = treeInstance.prototypeIndex;
                    treeDataArray[index].y = treePos.x;
                    treeDataArray[index].z = treePos.y;
                    treeDataArray[index].w = treePos.z;
                    index++;
                    treeDataArray[index].x = treeInstance.rotation; 
                    treeDataArray[index].y = treeInstance.widthScale;
                    treeDataArray[index].z = treeInstance.heightScale;
                    index++;

                    instanceCounts[treeInstance.prototypeIndex]++;
                }
                if (initializeWithCoroutine)
                    yield return null;

                ComputeBuffer treeDataBuffer = new ComputeBuffer(treeDataArray.Length, GPUInstancerConstants.STRIDE_SIZE_FLOAT4);
                treeDataBuffer.SetData(treeDataArray);
                ComputeBuffer treeScalesBuffer = new ComputeBuffer(treeScales.Length, GPUInstancerConstants.STRIDE_SIZE_FLOAT4);
                treeScalesBuffer.SetData(treeScales);
                ComputeBuffer counterBuffer = new ComputeBuffer(1, GPUInstancerConstants.STRIDE_SIZE_INT);
                uint[] emptyCounterData = new uint[1];

                treeDataArray = null;
                treeScales = null;

                GPUInstancerRuntimeData runtimeData;
                for (int i = 0; i < runtimeDataList.Count; i++)
                {
                    if (instanceCounts[i] == 0)
                        continue;

                    runtimeData = runtimeDataList[i];

                    counterBuffer.SetData(emptyCounterData);
                    runtimeData.transformationMatrixVisibilityBuffer = new ComputeBuffer(instanceCounts[i], GPUInstancerConstants.STRIDE_SIZE_MATRIX4X4);

                    _treeInstantiationComputeShader.SetBuffer(0,
                        GPUInstancerConstants.VisibilityKernelPoperties.INSTANCE_DATA_BUFFER, runtimeData.transformationMatrixVisibilityBuffer);
                    _treeInstantiationComputeShader.SetBuffer(0,
                        GPUInstancerConstants.TreeKernelProperties.TREE_DATA, treeDataBuffer);
                    _treeInstantiationComputeShader.SetBuffer(0,
                        GPUInstancerConstants.TreeKernelProperties.TREE_SCALES, treeScalesBuffer);
                    _treeInstantiationComputeShader.SetBuffer(0,
                        GPUInstancerConstants.GrassKernelProperties.COUNTER_BUFFER, counterBuffer);
                    _treeInstantiationComputeShader.SetInt(
                        GPUInstancerConstants.VisibilityKernelPoperties.BUFFER_PARAMETER_BUFFER_SIZE, instanceTotal);
                    _treeInstantiationComputeShader.SetVector(
                        GPUInstancerConstants.GrassKernelProperties.TERRAIN_SIZE_DATA, terrain.terrainData.size);
                    _treeInstantiationComputeShader.SetVector(
                        GPUInstancerConstants.TreeKernelProperties.TERRAIN_POSITION, terrain.GetPosition());
                    _treeInstantiationComputeShader.SetBool(
                        GPUInstancerConstants.TreeKernelProperties.IS_APPLY_ROTATION, ((GPUInstancerTreePrototype)runtimeData.prototype).isApplyRotation);
                    _treeInstantiationComputeShader.SetBool(
                        GPUInstancerConstants.TreeKernelProperties.IS_APPLY_TERRAIN_HEIGHT, ((GPUInstancerTreePrototype)runtimeData.prototype).isApplyTerrainHeight);
                    _treeInstantiationComputeShader.SetInt(
                        GPUInstancerConstants.TreeKernelProperties.PROTOTYPE_INDEX, i);

                    _treeInstantiationComputeShader.Dispatch(0,
                        Mathf.CeilToInt(instanceTotal / GPUInstancerConstants.COMPUTE_SHADER_THREAD_COUNT), 1, 1);

                    runtimeData.bufferSize = instanceCounts[i];
                    runtimeData.instanceCount = instanceCounts[i];
                    GPUInstancerUtility.InitializeGPUBuffer(runtimeData);

                    if (initializeWithCoroutine)
                        yield return null;
                }

                treeDataBuffer.Release();
                treeScalesBuffer.Release();
                counterBuffer.Release();
            }

            isInitial = true;
            GPUInstancerUtility.TriggerEvent(GPUInstancerEventType.TreeInitializationFinished);
        }
    }
}