using System;
using System.Collections.Generic;
using NatureManufacture.Underwater;
using Unity.Mathematics;
using Unity.Profiling;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

namespace NatureManufacture.Underwater
{
    [ExecuteAlways]
    public class WaterDepthCamera : MonoBehaviour
    {
        private ProfilerMarker waterDepthProfileMarker = new(nameof(WaterDepthCamera));


        [Header("Depth settings")] [SerializeField]
        private LayerMask waterLayer = 1 << 4;

        [SerializeField] private Camera targetCamera;
        [SerializeField] private float maxWaterDepth = 30f;


        [Header("Mask settings")] [SerializeField]
        private GenerateMaskTexture.DepthMaskSize depthTextureSize = GenerateMaskTexture.DepthMaskSize._512;

        [SerializeField] private GenerateMaskTexture maskGenerator;
        [SerializeField] private UnderwaterMaterialManager underwaterMaterialManager;

        [SerializeField] private bool autoFindWaterRenderers = true;
        [SerializeField] private List<Renderer> renderers = new();

        [Header("Debug settings")] [SerializeField]
        private RawImage debugImage;


        private RenderTexture depthRT;


        private readonly Quaternion initialRotation = new(1, 0, 0, 1);
        private float orthographicSize;

        private float nearPlane = 1;
        private float FarPlane => maxWaterDepth * 2 + 1;

        private Plane[] planes = new Plane[6];

        private Transform localTransform;

        public Matrix4x4 ProjectionMatrix
        {
            get
            {
                float top = orthographicSize;
                float right = orthographicSize;

                // Create ortho projection matrix
                float4x4 projectionMatrix = Matrix4x4.Ortho(-right, right, -top, top, nearPlane, FarPlane);
                return projectionMatrix;
            }
        }

        private Matrix4x4 ViewMatrix => Matrix4x4.Scale(new Vector3(1.0f, 1.0f, -1.0f)) * localTransform.worldToLocalMatrix;


        private Vector3 NearPosition => localTransform.position + localTransform.forward * nearPlane + orthographicSize * localTransform.right + orthographicSize * localTransform.up;
        private Vector3 FarPosition => localTransform.position + localTransform.forward * FarPlane - orthographicSize * localTransform.right - orthographicSize * localTransform.up;


        private void OnEnable()
        {
            localTransform = transform;
            if (targetCamera == null)
                targetCamera = Camera.main;
            FindRenderers();

            GenerateDepthTexture();

            RenderPipelineManager.beginCameraRendering += RenderCamera;
        }

        private void GenerateDepthTexture()
        {
            if (depthRT != null) return;
            depthRT = new RenderTexture((int)depthTextureSize, (int)depthTextureSize, 32, RenderTextureFormat.Depth)
            {
                filterMode = FilterMode.Point
            };
            depthRT.Create();
            if (debugImage)
                debugImage.texture = depthRT;
        }

        private void FindRenderers()
        {
            if (!autoFindWaterRenderers) return;
            renderers.Clear();

            Renderer[] allRenderers = FindObjectsByType<Renderer>(FindObjectsSortMode.None);
            for (int i = 0; i < allRenderers.Length; i++)
            {
                Renderer rendererToCheck = allRenderers[i];
                if (((1 << rendererToCheck.gameObject.layer) & waterLayer) != 0 && rendererToCheck.enabled && rendererToCheck.gameObject.activeInHierarchy)
                    renderers.Add(allRenderers[i]);
            }
        }

        private void OnDisable()
        {
            RenderPipelineManager.beginCameraRendering -= RenderCamera;
        }

        private void OnDestroy()
        {
            depthRT.Release();
        }

        private void Update()
        {
            PositionCamera();
        }

        private void PositionCamera()
        {
            if (!targetCamera) return;

            float targetCameraNearClipPlane = targetCamera.nearClipPlane;
            Vector3 positionNearPlane = targetCamera.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, targetCameraNearClipPlane));
            localTransform.position = positionNearPlane + Vector3.up * (FarPlane * 0.5f + 1);
            localTransform.rotation = initialRotation;
            orthographicSize = Vector3.Distance(targetCamera.ViewportToWorldPoint(new Vector3(0, 0, targetCameraNearClipPlane)), targetCamera.ViewportToWorldPoint(new Vector3(1, 0, targetCameraNearClipPlane))) * 0.5f;
        }


        private void RenderCamera(ScriptableRenderContext ctx, Camera cam)
        {
            if (targetCamera == null || cam != targetCamera)
                return;

            using (waterDepthProfileMarker.Auto())
            {
                CommandBuffer cmd = CommandBufferPool.Get(nameof(WaterDepthCamera));

                cmd.SetRenderTarget(depthRT);
                cmd.ClearRenderTarget(true, true, Color.clear);


                Matrix4x4 viewMatrix = ViewMatrix;
                Matrix4x4 projectionMatrix = ProjectionMatrix;

                cmd.SetViewProjectionMatrices(viewMatrix, projectionMatrix);


                GeometryUtility.CalculateFrustumPlanes(projectionMatrix * ViewMatrix, planes);

                for (int i = 0; i < renderers.Count; i++)
                {
                    Renderer waterRenderer = renderers[i];
                    if (!waterRenderer || !GeometryUtility.TestPlanesAABB(planes, waterRenderer.bounds)) continue;

                    Material mat = waterRenderer.sharedMaterial;
                    cmd.DrawRenderer(waterRenderer, waterRenderer.sharedMaterial, 0, mat.FindPass("DepthOnly"));
                }

                ctx.ExecuteCommandBuffer(cmd);
                CommandBufferPool.Release(cmd);
            }

            if (maskGenerator)
                maskGenerator.Generate(targetCamera, depthRT, FarPosition, NearPosition);

            if (underwaterMaterialManager)
                underwaterMaterialManager.CheckMaterial(waterLayer, localTransform.position, targetCamera.transform.position);
        }


        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(NearPosition, 0.05f);
            Gizmos.DrawWireSphere(FarPosition, 0.05f);

            Gizmos.matrix = localTransform.localToWorldMatrix;
            Gizmos.color = Color.white;

            float top = orthographicSize;
            float right = orthographicSize;

            float3 center = new float3(0.0f, 0.0f, nearPlane + (FarPlane - nearPlane) * 0.5f);
            float3 extents = new float3(right * 2.0f, top * 2.0f, (FarPlane - nearPlane));

            Gizmos.DrawWireCube(center, extents);
        }
    }
}