using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.XR;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace DynamicFogAndMist
{

    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [HelpURL("https://kronnect.com/support")]
    [ImageEffectAllowedInSceneView]
    public class DynamicFogExclusive : DynamicFogBase
    {
        RenderTexture rt;

        [Range(0.1f, 2f)]
        public float renderScale = 1f;

        private void OnPreRender()
        {
            if (fogMat == null || _alpha == 0 || currentCamera == null) return;

            if (VRCheck.IsVrRunning())
            {
                RenderTextureDescriptor rtDesc = XRSettings.eyeTextureDesc;
                rtDesc.width = (int)(rtDesc.width * renderScale);
                rtDesc.height = (int)(rtDesc.height * renderScale);
                rt = RenderTexture.GetTemporary(rtDesc);
            }
            else
            {
                int w = (int)(currentCamera.pixelWidth * renderScale);
                int h = (int)(currentCamera.pixelHeight * renderScale);
                rt = RenderTexture.GetTemporary(w, h, 24, RenderTextureFormat.ARGB32);
                rt.antiAliasing = 1;
            }
            rt.wrapMode = TextureWrapMode.Clamp;
            currentCamera.targetTexture = rt;
        }

        private void OnPostRender()
        {
            if (fogMat == null || _alpha == 0 || currentCamera == null)
                return;

            if (shouldUpdateMaterialProperties)
            {
                shouldUpdateMaterialProperties = false;
                UpdateMaterialPropertiesNow();
            }

            if (currentCamera.orthographic)
            {
                if (!matOrtho)
                    ResetMaterial();
                fogMat.SetVector(ShaderParams.ClipDir, currentCamera.transform.forward);
            }
            else
            {
                if (matOrtho)
                    ResetMaterial();
            }

            if (_useSinglePassStereoRenderingMatrix && VRCheck.IsVrRunning())
            {
                fogMat.SetMatrix(ShaderParams.ClipToWorld, currentCamera.cameraToWorldMatrix);
            }
            else
            {
                fogMat.SetMatrix(ShaderParams.ClipToWorld, currentCamera.cameraToWorldMatrix * currentCamera.projectionMatrix.inverse);
            }
            currentCamera.targetTexture = null;
            Graphics.Blit(rt, null as RenderTexture, fogMat);
            RenderTexture.ReleaseTemporary(rt);

        }

    }

}