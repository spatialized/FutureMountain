using UnityEngine;

namespace NatureManufacture.RAM
{
    public class TerrainManagerData
    {
        private RenderTexture _texture2DPaint;
        private RenderTexture _texture2DCarve;
        private Vector2 _textureCoord = Vector3.zero;
        private float _brushSize;
        private Terrain _terrainUV;
        private Texture2D _paramsTextureCarve;
        private RenderTexture _texture2DMask;
        private RenderTexture _texture2DHeight;

        public TerrainManagerData()
        {
        }

        public RenderTexture Texture2DPaint
        {
            get => _texture2DPaint;
            set => _texture2DPaint = value;
        }

        public RenderTexture Texture2DCarve
        {
            get => _texture2DCarve;
            set => _texture2DCarve = value;
        }

        public Vector2 TextureCoord
        {
            get => _textureCoord;
            set => _textureCoord = value;
        }

        public float BrushSize
        {
            get => _brushSize;
            set => _brushSize = value;
        }

        public Terrain TerrainUV
        {
            get => _terrainUV;
            set => _terrainUV = value;
        }

        public Texture2D ParamsTextureCarve
        {
            get => _paramsTextureCarve;
            set => _paramsTextureCarve = value;
        }

        public RenderTexture Texture2DMask
        {
            get => _texture2DMask;
            set => _texture2DMask = value;
        }

        public RenderTexture Texture2DHeight
        {
            get => _texture2DHeight;
            set => _texture2DHeight = value;
        }
    }
}