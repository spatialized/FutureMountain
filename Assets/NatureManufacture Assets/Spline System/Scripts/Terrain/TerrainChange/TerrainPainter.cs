using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.TerrainTools;

namespace NatureManufacture.RAM
{
    public class TerrainPainter : TerrainModifier, ITerrainModifier
    {

        public static void ModifyTerrain(TerrainPainterData terrainPainterData, TerrainManagerData terrainManagerData, HashSet<MeshFilter> meshFilters,
            TerrainManager.PaintHeightPasses paintHeightPasses = TerrainManager.PaintHeightPasses.PaintTexture)
        {
            if (terrainManagerData.Texture2DCarve)
            {
                RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DCarve);
            }

            if (terrainManagerData.Texture2DMask)
            {
                RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DMask);
            }

            if (terrainManagerData.Texture2DHeight)
            {
                RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DHeight);
            }


            if (!TerrainManager.GenerateTerrainBrushTexture(terrainPainterData, terrainManagerData, meshFilters, null))
                return;


            if (terrainManagerData.TerrainUV == null)
                return;

            if (terrainManagerData.TerrainUV.terrainData.terrainLayers.Length == 0)
                return;

            if (terrainPainterData.WorkTerrain.terrainData.terrainLayers.Length == 0)
                return;

#if UNITY_EDITOR
            Undo.RegisterCompleteObjectUndo(terrainManagerData.TerrainUV.terrainData, "Paint");
#endif


            BrushTransform brushTransform = TerrainPaintUtility.CalculateBrushTransform(terrainManagerData.TerrainUV, terrainManagerData.TextureCoord, terrainManagerData.BrushSize, 0.0f);


            int textureParamsSize = (int)(0.5f * (int)terrainPainterData.TerrainCarveQuality);
            Color[] paramsColors = new Color[textureParamsSize];

            foreach (var terrainLayerData in terrainPainterData.TerrainLayersData)
            {
                if (!terrainLayerData.IsActive)
                    continue;
                int layerID = terrainLayerData.SplatMapID;

                if (terrainPainterData.WorkTerrain.terrainData.terrainLayers.Length <= layerID)
                {
                    Debug.LogWarning($"Error in paint layer \"{terrainLayerData.LayerName}\" - Terrain \"{terrainPainterData.WorkTerrain.name}\" does not have {layerID + 1} layers.");
                    continue;
                }


                var paramsTexture = new Texture2D(textureParamsSize, 1, TextureFormat.RGB24, false)
                {
                    wrapMode = TextureWrapMode.Clamp
                };
                for (int i = 0; i < textureParamsSize; i++)
                {
                    float angle = terrainLayerData.UseAngle ? terrainLayerData.Angle.Evaluate(90 * i / (float)textureParamsSize) : 1;
                    float power = terrainLayerData.Power.Evaluate(RamMath.Remap(i, 0, textureParamsSize - 1, -terrainManagerData.BrushSize, terrainManagerData.BrushSize));

                    float height = terrainLayerData.UseHeight ? terrainLayerData.Height.Evaluate(RamMath.Remap(i, 0, textureParamsSize - 1, 0, terrainManagerData.TerrainUV.terrainData.size.y)) : 1;


                    paramsColors[i] = new Color(angle, power, height);
                }

                paramsTexture.SetPixels(paramsColors, 0);
                paramsTexture.Apply();

                var mainParams = new Vector4(terrainLayerData.PowerMultiplier, terrainLayerData.UseHeight ? terrainLayerData.HeightMultiplier : 1, terrainLayerData.UseHeight ? terrainLayerData.HeightPower : 1, 0.0f);

                (terrainManagerData.Texture2DMask, terrainManagerData.Texture2DHeight) = TerrainManagerUtils.GenerateMaskFromTerrainHeight(brushTransform, terrainLayerData.ConvexParameters, terrainManagerData.TerrainUV,
                    terrainManagerData.Texture2DMask, terrainManagerData.Texture2DHeight, (int)terrainPainterData.TerrainCarveQuality);

                PaintContext paintContext = TerrainPaintUtility.BeginPaintTexture(terrainManagerData.TerrainUV, brushTransform.GetBrushXYBounds(), terrainPainterData.WorkTerrain.terrainData.terrainLayers[layerID]);
                Brush(paintContext, mainParams, paramsTexture, terrainLayerData.NoiseParametersList, terrainManagerData.Texture2DMask, terrainManagerData.Texture2DCarve, brushTransform,
                    terrainManagerData.TerrainUV, paintHeightPasses);

                TerrainPaintUtility.EndPaintTexture(paintContext, "Terrain Paint - Texture");
            }

            RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DMask);
            RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DHeight);
        }

        private static void Brush(PaintContext paintContext, Vector4 mainParams, Texture2D paramsTexture, List<TerrainNoiseParameters> terrainNoiseParameters, RenderTexture maskTexture, Texture brushTexture,
            BrushTransform brushTransform, Terrain terrainUV, TerrainManager.PaintHeightPasses paintHeightPasses = TerrainManager.PaintHeightPasses.PaintTexture)
        {
            Material materialPaintHeight = Object.Instantiate(TerrainPaintUtility.GetBuiltinPaintMaterial());
            materialPaintHeight.shader = Shader.Find("Hidden/NatureManufacture Shaders/PaintHeight");

            var brushParams = new Vector4(1, 1, terrainUV.terrainData.size.y, 0.0f);

            var noiseParams = new Vector4(paintContext.pixelRect.width, paintContext.pixelRect.height, paintContext.pixelRect.x, paintContext.pixelRect.y);


            materialPaintHeight.SetTexture(BrushTex, brushTexture);
            materialPaintHeight.SetTexture(MaskTex, maskTexture);
            materialPaintHeight.SetTexture(ParamsTex, paramsTexture);
            materialPaintHeight.SetTexture(NoiseTex, TerrainNoiseGenerator.Generate(terrainNoiseParameters));
            materialPaintHeight.SetVector(BrushParams, brushParams);
            materialPaintHeight.SetVector(NoiseParams, noiseParams);
            materialPaintHeight.SetVector(MainParams, mainParams);


            TerrainPaintUtility.SetupTerrainToolMaterialProperties(paintContext, brushTransform, materialPaintHeight);
            Graphics.Blit(paintContext.sourceRenderTexture, paintContext.destinationRenderTexture, materialPaintHeight, (int)paintHeightPasses);
        }
    }
}