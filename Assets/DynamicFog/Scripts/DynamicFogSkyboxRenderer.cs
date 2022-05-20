using UnityEngine;

namespace DynamicFogAndMist {

    [ExecuteInEditMode]
    public class DynamicFogSkyboxRenderer : MonoBehaviour {

        Camera cam;
        RenderTexture rtSkybox;

        private void OnEnable() {
            cam = GetComponent<Camera>();
            cam.enabled = false;
            Invoke(nameof(UpdateRTConfig), 0);
        }

        void Start() {
            Invoke(nameof(UpdateRTConfig), 0f);
        }

        void UpdateRTConfig() {

            Camera parentCam = GetComponentInParent<Camera>();
            cam.CopyFrom(parentCam);
            cam.depth = parentCam.depth - 1;
            cam.cullingMask = 0;

            RenderTextureDescriptor rtDesc = DynamicFogBase.rtDesc;
            if (rtDesc.width == 0) {
                rtDesc.width = cam.pixelWidth;
                rtDesc.height = cam.pixelHeight;
                rtDesc.dimension = UnityEngine.Rendering.TextureDimension.Tex2D;
                rtDesc.volumeDepth = 1;
                rtDesc.colorFormat = RenderTextureFormat.ARGB32;
            }
            rtDesc.useMipMap = false;
            rtDesc.depthBufferBits = 0;
            rtDesc.msaaSamples = 1;
            if (rtSkybox == null || rtSkybox.width != cam.pixelWidth) {
                if (rtSkybox != null) {
                    rtSkybox.Release();
                }
                rtSkybox = new RenderTexture(rtDesc);
            }
            cam.targetTexture = rtSkybox;

            cam.enabled = true;

            Shader.SetGlobalTexture("_DynamicFogSkybox", rtSkybox);
        }


        private void OnDisable() {
            if (cam != null) {
                cam.targetTexture = null;
                cam.enabled = false;
            }
            if (rtSkybox != null) {
                rtSkybox.Release();
            }
        }


    }

}