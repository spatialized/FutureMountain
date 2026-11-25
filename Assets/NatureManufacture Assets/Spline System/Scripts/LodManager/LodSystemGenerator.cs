// /**
//  * Created by Pawel Homenko on  10/2023
//  */

using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.RAM
{
    public static class LodSystemGenerator
    {
        public static void GenerateLodSystem(GameObject go, Material meshMaterial, MeshFilter meshFilter, bool receiveShadows, ShadowCastingMode shadowCastingMode, bool generateLodGPU, Vector4 lodDistance, float lodRefreshTime)
        {
            string name = $"{go.name}- MeshPartLOD_{(generateLodGPU ? "GPU" : "CPU")}";

            var goLod = new GameObject(name);
            goLod.transform.SetParent(go.transform, false);
            goLod.transform.localPosition = Vector3.zero;
            goLod.transform.localEulerAngles = Vector3.zero;
            goLod.transform.localScale = Vector3.one;
            goLod.AddComponent<MeshFilter>();
            MeshRenderer goLodMeshRenderer = goLod.AddComponent<MeshRenderer>();
            goLodMeshRenderer.sharedMaterial = meshMaterial;
            goLodMeshRenderer.receiveShadows = receiveShadows;
            goLodMeshRenderer.shadowCastingMode = shadowCastingMode;
            goLod.SetActive(false);
            goLod.layer = go.layer;

            if (generateLodGPU)
            {
                GPULodManager gpuLodManager = goLod.AddComponent<GPULodManager>();
                gpuLodManager.SourceMeshFilter = meshFilter;
                gpuLodManager.LODDistance = lodDistance;
                gpuLodManager.RefreshTime = lodRefreshTime;
            }
            else
            {
                LodManager lodManager = goLod.AddComponent<LodManager>();
                lodManager.SourceMeshFilter = meshFilter;
                lodManager.LODDistance = lodDistance;
                lodManager.RefreshTime = lodRefreshTime;
            }

            goLod.SetActive(true);
        }
    }
}