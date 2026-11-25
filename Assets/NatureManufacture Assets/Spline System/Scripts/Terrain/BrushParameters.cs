using UnityEngine;

namespace NatureManufacture.RAM
{
    public class BrushParameters
    {
        public Vector3 BrushCenter { get; }
        public float BrushSize { get; }
        public float TerrainHeight { get; }
        public float TerrainPositionY { get; }
        public Bounds BrushBounds { get; }
        
        public float HeightOffset { get; }
        public TerrainPainterData.TerrainCarveQualityEnum CarveQuality { get; }
        public float AdditionalSize { get; }

        public BrushParameters(
            Vector3 brushCenter,
            float brushSize, 
            float terrainPositionY,
            float terrainHeight,
            Bounds brushBounds,
            float heightOffset,
            TerrainPainterData.TerrainCarveQualityEnum carveQuality,
            float additionalSize)
        {
            BrushCenter = brushCenter;
            BrushSize = brushSize;
            TerrainPositionY = terrainPositionY;
            TerrainHeight = terrainHeight;
            BrushBounds = brushBounds;
            HeightOffset = heightOffset;
            CarveQuality = carveQuality;
            AdditionalSize = additionalSize;
        }
    }
}