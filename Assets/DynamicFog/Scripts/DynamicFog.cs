using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace DynamicFogAndMist
{

    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [HelpURL("https://kronnect.com/support")]
    [ImageEffectAllowedInSceneView]
    public class DynamicFog : DynamicFogBase
    {


        // Postprocess the image
        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (fogMat == null || _alpha == 0 || currentCamera == null)
            {
                Graphics.Blit(source, destination);
                return;
            }

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
                fogMat.SetMatrix("_ClipToWorld", currentCamera.cameraToWorldMatrix);
            }
            else
            {
                fogMat.SetMatrix("_ClipToWorld", currentCamera.cameraToWorldMatrix * currentCamera.projectionMatrix.inverse);
            }
            Graphics.Blit(source, destination, fogMat);
        }

    }

}