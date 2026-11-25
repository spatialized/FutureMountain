using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

namespace NatureManufacture.Underwater
{
    [ExecuteAlways]
    [DisallowMultipleComponent]
    public class GenerateMaskTexture : MonoBehaviour
    {
        public enum DepthMaskSize
        {
            _128 = 128,
            _256 = 256,
            _512 = 512,
            _1024 = 1024,
            _2048 = 2048,
            _4096 = 4096,
        }

        private static readonly int _NMWaterLevelTex = Shader.PropertyToID("_NMWaterLevelTex");
        private static readonly int _Far = Shader.PropertyToID("_Far");
        private static readonly int _Near = Shader.PropertyToID("_Near");
        private static readonly int _ViewPosition = Shader.PropertyToID("_ViewPosition");
        private static readonly int _WaterLineBlurSize = Shader.PropertyToID("_WaterLineBlurSize");
        private static readonly int _DropletsMaskDecay = Shader.PropertyToID("_DropletsMaskDecay");
        private static readonly int _OldTex = Shader.PropertyToID("_OldTex");

        [Header("Mask settings")] 

        [SerializeField] private DepthMaskSize depthMaskSize = DepthMaskSize._512;
        [SerializeField] private float waterLineBlurSize = 0.01f;
        [SerializeField] private float dropletsMaskDecay = 2f;


        [Header("Debug")] [SerializeField] private List<RawImage> rawImageDebugs;


        private Material maskMaterial;


        private RenderTexture outputMask;
        private RenderTexture oldOutputMask;

        private const RenderTextureFormat OutputFormat = RenderTextureFormat.ARGB32;

        public RenderTexture OutputMask => outputMask;

        private Matrix4x4 viewPosition = new Matrix4x4();
        private Vector3 positionCheck = new Vector3();

        private void OnEnable()
        {
           


            EnsureMaterial();
            EnsureOutputTexture();

        }

        private void OnDisable()
        {
       


            ReleaseOutputIfOwned();
            if (maskMaterial != null)
            {
#if UNITY_EDITOR
                if (!Application.isPlaying) DestroyImmediate(maskMaterial);
                else Destroy(maskMaterial);
#else
            Destroy(maskMaterial);
#endif
                maskMaterial = null;
            }
        }

     


#if UNITY_EDITOR
        private void OnValidate()
        {
            if (!isActiveAndEnabled)
                return;

            EnsureMaterial();
            EnsureOutputTexture();
        }
#endif

        public void Generate(Camera targetCamera,RenderTexture source, Vector3 far, Vector3 near)
        {
            if (!source)
                return;
            
            if(!targetCamera)
                return;


            //EnsureMaterial();
            //EnsureOutputTexture(source);

            if (!maskMaterial || !outputMask)
                return;

            float targetCameraNearClipPlane = targetCamera.nearClipPlane;
            positionCheck.x = 0;
            positionCheck.y = 0;
            positionCheck.z = targetCameraNearClipPlane;
            viewPosition.SetColumn(0, targetCamera.ViewportToWorldPoint(positionCheck));
            positionCheck.x = 1;
            positionCheck.y = 0;
            viewPosition.SetColumn(1, targetCamera.ViewportToWorldPoint(positionCheck));
            positionCheck.x = 0;
            positionCheck.y = 1;
            viewPosition.SetColumn(2, targetCamera.ViewportToWorldPoint(positionCheck));
            positionCheck.x = 1;
            positionCheck.y = 1;
            viewPosition.SetColumn(3, targetCamera.ViewportToWorldPoint(positionCheck));
            

            Graphics.Blit(outputMask, oldOutputMask);

            maskMaterial.SetVector(_Far, far);
            maskMaterial.SetVector(_Near, near);
            maskMaterial.SetMatrix(_ViewPosition, viewPosition);
            maskMaterial.SetFloat(_WaterLineBlurSize, waterLineBlurSize);
            maskMaterial.SetFloat(_DropletsMaskDecay, dropletsMaskDecay);
            maskMaterial.SetTexture(_OldTex, oldOutputMask);

            Graphics.Blit(source, outputMask, maskMaterial, 0);

            Shader.SetGlobalTexture(_NMWaterLevelTex, outputMask);
        }


        private void EnsureMaterial()
        {
            if (maskMaterial)
                return;

            Shader maskBlitShader = Shader.Find("Hidden/Nature Manufacture/WaterDepthMaskBlit");

            if (!maskBlitShader)
                return;

            maskMaterial = new Material(maskBlitShader)
            {
                hideFlags = HideFlags.HideAndDontSave
            };
        }

        private void EnsureOutputTexture(RenderTexture source = null)
        {
            if (outputMask)
                return;

            int width = (int)depthMaskSize;
            int height = (int)depthMaskSize;


            if (outputMask &&
                outputMask.width == width &&
                outputMask.height == height)
            {
                return;
            }

            ReleaseOutputIfOwned();

            outputMask = new RenderTexture(width, height, 0, OutputFormat, RenderTextureReadWrite.Linear)
            {
                name = $"WaterMask_RT_{gameObject.name}",
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                useMipMap = false,
                autoGenerateMips = false,
            };
            outputMask.Create();

            oldOutputMask = new RenderTexture(width, height, 0, OutputFormat, RenderTextureReadWrite.Linear)
            {
                name = $"WaterMask_Old_RT_{gameObject.name}",
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                useMipMap = false,
                autoGenerateMips = false,
            };
            oldOutputMask.Create();

            //Debug.Log($"[GenerateMaskTexture] Created output mask RenderTexture with size {width}x{height} for {gameObject.name}", this);

            if (rawImageDebugs is { Count: > 0 })
                foreach (RawImage rawImageDebug in rawImageDebugs)
                    rawImageDebug.texture = outputMask;
        }

        private void ReleaseOutputIfOwned()
        {
            if (!outputMask && !oldOutputMask)
                return;

            if (outputMask.IsCreated())
                outputMask.Release();

            if (oldOutputMask.IsCreated())
                oldOutputMask.Release();

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                DestroyImmediate(outputMask);
                DestroyImmediate(oldOutputMask);
            }
            else
            {
                Destroy(outputMask);
                Destroy(oldOutputMask);
            }
#else
        Destroy(outputMask);
            Destroy(oldOutputMask);
#endif

            outputMask = null;
            oldOutputMask = null;
        }
    }
}