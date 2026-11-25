using System.Collections.Generic;
using NatureManufacture.RAM;
using UnityEngine;


namespace NatureManufacture.RAM
{
    public abstract class TerrainModifier
    {
        public static readonly int BrushTex = Shader.PropertyToID("_BrushTex");
        public static readonly int ParamsTex = Shader.PropertyToID("_ParamsTex");
        public static readonly int BrushParams = Shader.PropertyToID("_BrushParams");

        public static readonly int NoiseParams = Shader.PropertyToID("_NoiseParams");
        public static readonly int HeightmapOrig = Shader.PropertyToID("_HeightmapOrig");
        public static readonly int MaskTex = Shader.PropertyToID("_MaskTex");
        public static readonly int MainParams = Shader.PropertyToID("_MainParams");
        public static readonly int HeightOffset = Shader.PropertyToID("_heightOffset");
        public static readonly int NoiseTex = Shader.PropertyToID("_NoiseTex");
        public static readonly int StampTex = Shader.PropertyToID("_StampTex");
    }

    public interface ITerrainModifier
    {
        public static void ModifyTerrain(TerrainPainterData terrainPainterData, TerrainManagerData terrainManagerData, HashSet<MeshFilter> meshFilters,
            TerrainManager.PaintHeightPasses paintHeightPasses = TerrainManager.PaintHeightPasses.CarveTerrain)
        {
        }
    }
}