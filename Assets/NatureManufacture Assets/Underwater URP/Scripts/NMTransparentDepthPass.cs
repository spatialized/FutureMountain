using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.Universal;

namespace NatureManufacture.Underwater
{
    public class NMTransparentDepthPass : ScriptableRenderPass
    {
        //private static readonly int _TransparentDepthTextureId = Shader.PropertyToID("_NMTransparentDepthTexture");
        private static readonly ShaderTagId _DepthOnlyTag = new("DepthOnly");
        private new readonly ProfilingSampler profilingSampler = new("Transparent Depth");
        private NMUnderwaterFeature.Settings settings;


        public NMTransparentDepthPass(RenderPassEvent renderPassEvent, NMUnderwaterFeature.Settings settings)
        {
            this.renderPassEvent = renderPassEvent;
            this.settings = settings; // Default to water layer
        }

        private class PassData
        {
            public RendererListHandle rendererList;
        }

        public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
        {
            UniversalRenderingData renderingData = frameData.Get<UniversalRenderingData>();
            UniversalCameraData cameraData = frameData.Get<UniversalCameraData>();
            UniversalLightData lightData = frameData.Get<UniversalLightData>();

            var depthTexture = renderGraph.CreateTexture(new TextureDesc(
                cameraData.cameraTargetDescriptor.width,
                cameraData.cameraTargetDescriptor.height)
            {
                colorFormat = GraphicsFormat.None, // depth-only target
                depthBufferBits = DepthBits.Depth32,
                clearBuffer = true,
                clearColor = Color.black,
                name = settings.textureId
            });

            if (!depthTexture.IsValid())
                return;
            
            using (var builder = renderGraph.AddRasterRenderPass<PassData>(
                       "Transparent Depth Pass",
                       out var passData,
                       profilingSampler))
            {
                var drawSettings = RenderingUtils.CreateDrawingSettings(
                    _DepthOnlyTag,
                    renderingData,
                    cameraData,
                    lightData,
                    SortingCriteria.CommonTransparent);

                drawSettings.perObjectData = PerObjectData.None;

                var filteringSettings = new FilteringSettings(
                    RenderQueueRange.transparent,
                    settings.transparentLayerMask);

                var rendererListParams = new RendererListParams(
                    renderingData.cullResults,
                    drawSettings,
                    filteringSettings);

                passData.rendererList = renderGraph.CreateRendererList(rendererListParams);

                if (!passData.rendererList.IsValid())
                    return;

                builder.UseRendererList(passData.rendererList);
                builder.SetRenderAttachmentDepth(depthTexture, AccessFlags.Write);
                builder.SetGlobalTextureAfterPass(depthTexture, Shader.PropertyToID(settings.textureId));

                builder.SetRenderFunc(static (PassData data, RasterGraphContext context) =>
                {
                    context.cmd.ClearRenderTarget(true, false, Color.black);
                    context.cmd.DrawRendererList(data.rendererList);
                });
            }
        }
    }
}