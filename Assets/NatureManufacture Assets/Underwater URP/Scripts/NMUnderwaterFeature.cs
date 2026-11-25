using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace NatureManufacture.Underwater
{
    public class NMUnderwaterFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class Settings
        {
            public LayerMask transparentLayerMask;
            public string textureId;
        }

        private readonly List<NMTransparentDepthPass> passes = new();
        private NMFullScreenRenderPass fullScreenPassPreTransparent;
        private NMFullScreenRenderPass fullScreenPassPreRenderPostProcessing;

        public List<Settings> settings = new();
        public Material underwaterPassMaterial;

        public NMUnderwaterFeature()
        {
            settings.Add(new Settings { transparentLayerMask = (1 << 0) |(1 << 4), textureId = "_NMTransparentDepthTexture" });
        }

        public override void Create()
        {
            passes.Clear();
            for (int i = 0; i < settings.Count; i++)
            {
                passes.Add(new NMTransparentDepthPass(RenderPassEvent.AfterRenderingTransparents, settings[i]));
            }

            fullScreenPassPreTransparent = new NMFullScreenRenderPass("NM FullScreen Pass PreTransparent");
            fullScreenPassPreRenderPostProcessing = new NMFullScreenRenderPass("NM FullScreen Pass PreRenderPostProcessing");


            //Debug.Log(passes.Count);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (renderingData.cameraData.cameraType == CameraType.Preview
                || renderingData.cameraData.cameraType == CameraType.Reflection
                || renderingData.cameraData.cameraType == CameraType.SceneView
                || UniversalRenderer.IsOffscreenDepthTexture(ref renderingData.cameraData))
                return;


            for (int i = 0; i < settings.Count; i++)
            {
                renderer.EnqueuePass(passes[i]);
            }

            if (!Shader.GetGlobalTexture("_NMWaterLevelTex"))
                return;

            if (underwaterPassMaterial == null)
                return;

            fullScreenPassPreTransparent.renderPassEvent = RenderPassEvent.BeforeRenderingTransparents;
            fullScreenPassPreTransparent.ConfigureInput(ScriptableRenderPassInput.Color);
            fullScreenPassPreTransparent.SetupMembers(underwaterPassMaterial, 0, true, false);
            fullScreenPassPreTransparent.requiresIntermediateTexture = true;

            renderer.EnqueuePass(fullScreenPassPreTransparent);

            fullScreenPassPreRenderPostProcessing.renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
            fullScreenPassPreRenderPostProcessing.ConfigureInput(ScriptableRenderPassInput.Color);
            fullScreenPassPreRenderPostProcessing.SetupMembers(underwaterPassMaterial, 1, true, false);
            fullScreenPassPreTransparent.requiresIntermediateTexture = true;

            renderer.EnqueuePass(fullScreenPassPreRenderPostProcessing);
        }
    }
}