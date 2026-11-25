using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

namespace NatureManufacture.RAM
{
    public static class TerrainNoiseGenerator
    {
        private static readonly int _NoiseParams = Shader.PropertyToID("_NoiseParams");
        private static readonly int _OperationType = Shader.PropertyToID("_OperationType");
        private static readonly int _Seed = Shader.PropertyToID("_Seed");


        public static RenderTexture Generate(List<TerrainNoiseParameters> terrainNoiseParametersList, int width = 1024, int height = 1024, bool clearWhite = true, bool preview = false)
        {
            //count number of noise parameters with UseNoise set to true

            int activeNoiseCount = 0;
            if (terrainNoiseParametersList != null)
                foreach (TerrainNoiseParameters terrainNoiseParameters in terrainNoiseParametersList)
                {
                    if (terrainNoiseParameters.UseNoise)
                    {
                        activeNoiseCount++;
                    }
                }


            var material = new Material(Shader.Find("Hidden/NatureManufacture Shaders/NoiseShader"));

            if (activeNoiseCount == 0)
            {
                RenderTexture renderTextureTempSmall = RenderTexture.GetTemporary(1, 1, 16, RenderTextureFormat.R16);
                Graphics.Blit(null, renderTextureTempSmall, material, clearWhite ? 1 : 2);
                return renderTextureTempSmall;
            }


            RenderTexture renderTexture = RenderTexture.GetTemporary(width, height, 16, RenderTextureFormat.R16);
            renderTexture.wrapMode = TextureWrapMode.Repeat;

            RenderTexture renderTexture2 = RenderTexture.GetTemporary(width, height, 16, RenderTextureFormat.R16);
            renderTexture2.wrapMode = TextureWrapMode.Repeat;

            for (int i = 0; i < terrainNoiseParametersList.Count; i++)
            {
                TerrainNoiseParameters terrainNoiseParameters = terrainNoiseParametersList[i];

                if (!terrainNoiseParameters.UseNoise)
                    continue;

                var noiseParams = new Vector4(terrainNoiseParameters.NoiseMultiplier, terrainNoiseParameters.NoiseSizeX, terrainNoiseParameters.NoiseSizeZ,
                    terrainNoiseParameters.NoiseMultiplierPower);


                material.SetVector(_NoiseParams, noiseParams);
                material.SetFloat(_OperationType, (int)terrainNoiseParameters.OperationType);


                if (terrainNoiseParameters.RandomizeSeed && !preview)
                    terrainNoiseParameters.NoiseSeed = Random.value;


                material.SetFloat(_Seed, terrainNoiseParameters.NoiseSeed);


                Graphics.Blit(renderTexture, renderTexture2, material, 0);
                (renderTexture, renderTexture2) = (renderTexture2, renderTexture);
            }


            RenderTexture.ReleaseTemporary(renderTexture2);


            return renderTexture;
        }
    }
}