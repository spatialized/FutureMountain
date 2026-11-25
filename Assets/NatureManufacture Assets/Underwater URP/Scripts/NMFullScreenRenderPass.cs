using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;
using UnityEngine.Rendering.Universal;

namespace NatureManufacture.Underwater
{
    public class NMFullScreenRenderPass : ScriptableRenderPass
    {
        private Material m_Material;
        private int m_PassIndex;
        private bool m_FetchActiveColor;
        private bool m_BindDepthStencilAttachment;

        private MaterialPropertyBlock s_SharedPropertyBlock = new MaterialPropertyBlock();

        readonly int blitTexture = Shader.PropertyToID("_BlitTexture");
        readonly int blitScaleBias = Shader.PropertyToID("_BlitScaleBias");

        public NMFullScreenRenderPass(string passName)
        {
            profilingSampler = new ProfilingSampler(passName);
        }

        public void SetupMembers(Material material, int passIndex, bool fetchActiveColor, bool bindDepthStencilAttachment)
        {
            m_Material = material;
            m_PassIndex = passIndex;
            m_FetchActiveColor = fetchActiveColor;
            m_BindDepthStencilAttachment = bindDepthStencilAttachment;
        }



        private void ExecuteCopyColorPass(RasterCommandBuffer cmd, RTHandle sourceTexture)
        {
            Blitter.BlitTexture(cmd, sourceTexture, new Vector4(1, 1, 0, 0), 0.0f, false);
        }

        private void ExecuteMainPass(RasterCommandBuffer cmd, RTHandle sourceTexture, Material material, int passIndex)
        {
            s_SharedPropertyBlock.Clear();
            if (sourceTexture != null)
                s_SharedPropertyBlock.SetTexture(blitTexture, sourceTexture);

            // We need to set the "_BlitScaleBias" uniform for user materials with shaders relying on core Blit.hlsl to work
            s_SharedPropertyBlock.SetVector(blitScaleBias, new Vector4(1, 1, 0, 0));

            cmd.DrawProcedural(Matrix4x4.identity, material, passIndex, MeshTopology.Triangles, 3, 1, s_SharedPropertyBlock);
        }



        public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
        {
            UniversalResourceData resourcesData = frameData.Get<UniversalResourceData>();
            UniversalCameraData cameraData = frameData.Get<UniversalCameraData>();

            TextureHandle source, destination;

            Debug.Assert(resourcesData.cameraColor.IsValid());

            if (m_FetchActiveColor)
            {
                var targetDesc = renderGraph.GetTextureDesc(resourcesData.cameraColor);
                targetDesc.name = "_CameraColorFullScreenPass";
                targetDesc.clearBuffer = false;

                source = resourcesData.activeColorTexture;
                destination = renderGraph.CreateTexture(targetDesc);

                renderGraph.AddBlitPass(source, destination, Vector2.one, Vector2.zero, passName: "Copy Color Full Screen");

                //Swap for next pass;
                source = destination;
            }
            else
            {
                source = TextureHandle.nullHandle;
            }

            destination = resourcesData.activeColorTexture;

            // The AddBlitPass utility is not used when m_BindDepthStencilAttachment is active since SetRenderAttachmentDepth is not available with the returned builder of AddBlitPass.
            bool useCustomPass = input != ScriptableRenderPassInput.None || m_BindDepthStencilAttachment;

            if (useCustomPass)
            {
                AddFullscreenRenderPassInputPass(renderGraph, resourcesData, cameraData, source, destination);
            }
            else
            {
                var blitMaterialParameters = new RenderGraphUtils.BlitMaterialParameters(source, destination, m_Material, m_PassIndex);

                renderGraph.AddBlitPass(blitMaterialParameters, passName: "Blit Color Full Screen");
            }
        }

        private void AddFullscreenRenderPassInputPass(RenderGraph renderGraph, UniversalResourceData resourcesData, UniversalCameraData cameraData, TextureHandle source, TextureHandle destination)
        {
            using (var builder = renderGraph.AddRasterRenderPass<MainPassData>(passName, out var passData, profilingSampler))
            {
                passData.material = m_Material;
                passData.passIndex = m_PassIndex;

                passData.inputTexture = source;

                if (passData.inputTexture.IsValid())
                    builder.UseTexture(passData.inputTexture, AccessFlags.Read);

                bool needsColor = (input & ScriptableRenderPassInput.Color) != ScriptableRenderPassInput.None;
                bool needsDepth = (input & ScriptableRenderPassInput.Depth) != ScriptableRenderPassInput.None;
                bool needsNormal = (input & ScriptableRenderPassInput.Normal) != ScriptableRenderPassInput.None;

                if (needsColor)
                {
                    Debug.Assert(resourcesData.cameraOpaqueTexture.IsValid());
                    builder.UseTexture(resourcesData.cameraOpaqueTexture);
                }

                if (needsDepth)
                {
                    Debug.Assert(resourcesData.cameraDepthTexture.IsValid());
                    builder.UseTexture(resourcesData.cameraDepthTexture);
                }

              

                if (needsNormal)
                {
                    Debug.Assert(resourcesData.cameraNormalsTexture.IsValid());
                    builder.UseTexture(resourcesData.cameraNormalsTexture);
                }

                builder.SetRenderAttachment(destination, 0, AccessFlags.Write);

                if (m_BindDepthStencilAttachment)
                    builder.SetRenderAttachmentDepth(resourcesData.activeDepthTexture, AccessFlags.Write);

                builder.SetRenderFunc((MainPassData data, RasterGraphContext rgContext) =>
                {
                    ExecuteMainPass(rgContext.cmd, data.inputTexture, data.material, data.passIndex);
                });
            }
        }

        private void AddCopyPassRenderPassFullscreen(RenderGraph renderGraph, TextureHandle source, TextureHandle destination)
        {
            using (var builder = renderGraph.AddRasterRenderPass<CopyPassData>("Copy Color Full Screen", out var passData, profilingSampler))
            {
                passData.inputTexture = source;
                builder.UseTexture(passData.inputTexture, AccessFlags.Read);

                builder.SetRenderAttachment(destination, 0, AccessFlags.Write);

                builder.SetRenderFunc((CopyPassData data, RasterGraphContext rgContext) =>
                {
                    ExecuteCopyColorPass(rgContext.cmd, data.inputTexture);
                });
            }
        }

        private class CopyPassData
        {
            internal TextureHandle inputTexture;
        }

        private class MainPassData
        {
            internal Material material;
            internal int passIndex;
            internal TextureHandle inputTexture;
        }
    }
}