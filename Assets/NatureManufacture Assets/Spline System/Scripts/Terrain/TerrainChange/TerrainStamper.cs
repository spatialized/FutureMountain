using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.TerrainTools;
#endif
using UnityEngine;
using UnityEngine.TerrainTools;

namespace NatureManufacture.RAM
{
    public class TerrainStamper : TerrainModifier, ITerrainModifier
    {
        public static void ModifyTerrain(TerrainPainterData terrainPainterData, TerrainManagerData terrainManagerData, HashSet<MeshFilter> meshFilters,
            TerrainManager.PaintHeightPasses paintHeightPasses = TerrainManager.PaintHeightPasses.CarveTerrain)
        {
            if (!TerrainManager.GenerateTerrainBrushTexture(terrainPainterData, terrainManagerData, meshFilters, terrainPainterData.TerrainCarveStamp))
                return;

            if (!terrainManagerData.TerrainUV)
                return;

#if UNITY_EDITOR
            Undo.RegisterCompleteObjectUndo(terrainManagerData.TerrainUV.terrainData, "Carve");
#endif


            BrushTransform brushTransform = TerrainPaintUtility.CalculateBrushTransform(terrainManagerData.TerrainUV, terrainManagerData.TextureCoord, terrainManagerData.BrushSize, 0);
            PaintContext paintContext = TerrainPaintUtility.BeginPaintHeightmap(terrainManagerData.TerrainUV, brushTransform.GetBrushXYBounds());

            Brush(paintContext, terrainPainterData.SmoothStamp, terrainManagerData.ParamsTextureCarve, terrainPainterData.StampTexture, terrainManagerData.Texture2DCarve, brushTransform,
                paintHeightPasses);

            TerrainPaintUtility.EndPaintHeightmap(paintContext, "Terrain Paint - Raise or Lower Height");

            int terrainCount = paintContext.terrainCount;
            for (int i = 0; i < terrainCount; i++)
            {
                Terrain terrain = paintContext.GetTerrain(i);
                terrain.terrainData.SyncHeightmap();
            }
        }

        private static void Brush(PaintContext paintContext, float brushStrength, Texture2D paramsTexture, Texture2D stampTexture, Texture brushTexture, BrushTransform brushTransform,
            TerrainManager.PaintHeightPasses paintHeightPasses = TerrainManager.PaintHeightPasses.CarveTerrain)
        {
            Material mat = Object.Instantiate(TerrainPaintUtility.GetBuiltinPaintMaterial());
            mat.shader = Shader.Find("Hidden/NatureManufacture Shaders/StampHeight");

            var brushParams = new Vector4(brushStrength, 1, 1, 0.0f);
            mat.SetTexture(BrushTex, brushTexture);
            mat.SetTexture(ParamsTex, paramsTexture);
            mat.SetVector(BrushParams, brushParams);
            mat.SetTexture(StampTex, stampTexture);

            //TextureManager.SaveTexture(stampTexture, "stamp.png" );

            TerrainPaintUtility.SetupTerrainToolMaterialProperties(paintContext, brushTransform, mat);

            Graphics.Blit(paintContext.sourceRenderTexture, paintContext.destinationRenderTexture, mat, (int)paintHeightPasses);


            //TextureManager.SaveTexture((RenderTexture)brushTexture, TextureFormat.ARGB32);
        }

        public static void DrawPreview(TerrainPainterData terrainPainterData, TerrainManagerData managerData)
        {
            #if UNITY_EDITOR
            //Debug.Log($"textureCoord {raycastHit.textureCoord.x} {raycastHit.textureCoord.y}");
            BrushTransform brushTransform = TerrainPaintUtility.CalculateBrushTransform(managerData.TerrainUV, managerData.TextureCoord, managerData.BrushSize, 0);

            //Debug.Log(brushXform.brushOrigin + " " + brushXform.targetOrigin);
            PaintContext paintContext = TerrainPaintUtility.BeginPaintHeightmap(managerData.TerrainUV, brushTransform.GetBrushXYBounds(), 1);

            Material material = TerrainPaintUtilityEditor.GetDefaultBrushPreviewMaterial();
            // Material material =  new Material(Shader.Find("Debug Terrain Carve"));

            TerrainPaintUtilityEditor.DrawBrushPreview(
                paintContext, TerrainBrushPreviewMode.SourceRenderTexture, managerData.Texture2DCarve, brushTransform, material, 0);


            // draw result preview
            {
                //Debug.Log($"strength {_newHeight / terrain.terrainData.size.y}");
                Brush(paintContext, terrainPainterData.SmoothStamp, managerData.ParamsTextureCarve,
                    terrainPainterData.StampTexture, managerData.Texture2DCarve, brushTransform);

                // restore old render target
                RenderTexture.active = paintContext.oldRenderTexture;

                material.SetTexture(HeightmapOrig, paintContext.sourceRenderTexture);
                TerrainPaintUtilityEditor.DrawBrushPreview(paintContext, TerrainBrushPreviewMode.DestinationRenderTexture, managerData.Texture2DCarve, brushTransform, material, 2);
            }

            TerrainPaintUtility.ReleaseContextResources(paintContext);
            #endif
        }
    }
}