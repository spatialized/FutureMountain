using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class TerrainManager
    {
        public enum PaintHeightPasses
        {
            CopyTerrainHeightmap = 0,
            CarveTerrain = 1,
            GetAngle = 2,
            MaskGenerator = 3,
            PaintTexture = 4,
            CarveTerrainMin = 5,
            CarveTerrainMax = 6,
            AndMask = 7,
        }


        private HashSet<MeshFilter> _meshFilters = new();

        public HashSet<MeshFilter> MeshFilters
        {
            get => _meshFilters;
            set => _meshFilters = value;
        }

        public TerrainManager(MeshFilter meshFilter)
        {
            terrainManagerData = new TerrainManagerData();
            MeshFilters.Add(meshFilter);
        }

        public TerrainManager(HashSet<MeshFilter> meshFilters)
        {
            terrainManagerData = new TerrainManagerData();
            MeshFilters = meshFilters;
        }

        public TerrainManager()
        {
            terrainManagerData = new TerrainManagerData();
        }


        private readonly TerrainManagerData terrainManagerData;

        public bool ShowTerrainCarve(TerrainPainterData terrainPainterData)
        {
            return GenerateTerrainBrushTexture(terrainPainterData, terrainPainterData.TerrainCarve);
        }

        public bool ShowTerrainStamp(TerrainPainterData terrainPainterData)
        {
            return GenerateTerrainBrushTexture(terrainPainterData, terrainPainterData.TerrainCarveStamp);
        }


        public bool GenerateTerrainBrushTexture(TerrainPainterData terrainPainterData, AnimationCurve terrainCarvePower)
        {
            return GenerateTerrainBrushTexture(terrainPainterData, terrainManagerData, MeshFilters, terrainCarvePower);
        }

        public static bool GenerateTerrainBrushTexture(TerrainPainterData terrainPainterData, TerrainManagerData terrainManagerData, HashSet<MeshFilter> meshFilters, AnimationCurve terrainCarvePower)
        {
            if (terrainManagerData.Texture2DCarve)
            {
                RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DCarve);
            }

            if (terrainManagerData.Texture2DMask)
            {
                RenderTexture.ReleaseTemporary(terrainManagerData.Texture2DMask);
            }

            //Debug.Log($"terrainPainterData.WorkTerrain {terrainPainterData.WorkTerrain} | terrain under {terrainPainterData.TerrainsUnder.Count}");
            float terrainHeight = terrainPainterData.WorkTerrain.terrainData.size.y;

            //get bounds from mesh filters

            //create bounds from mesh filters in a loop
            Bounds bounds = meshFilters.First().GetComponent<MeshRenderer>().bounds;
            foreach (MeshFilter meshFilter in meshFilters)
            {
                var renderer = meshFilter.GetComponent<MeshRenderer>();
                bounds.Encapsulate(renderer.bounds);
            }

            Vector3 center = bounds.center;
            Vector3 extents = bounds.extents;

            float extent = Mathf.Max(extents.x, extents.z);

            float minX = center.x - extent;
            float maxX = center.x + extent;

            minX -= terrainPainterData.BrushAdditionalSize;
            maxX += terrainPainterData.BrushAdditionalSize;

            terrainManagerData.BrushSize = maxX - minX;

            Vector3 brushCenter = center;
            Bounds brushBounds = bounds;
            //Debug.Log($"brush center {center} brush bounds {bounds} brush size {BrushSize}");

            (terrainManagerData.TerrainUV, terrainManagerData.TextureCoord) = TerrainManagerUtils.GetTerrainUV(brushCenter);
            if (!terrainManagerData.TerrainUV)
                return false;

            List<(Mesh, Matrix4x4)> meshesData = new();
            foreach (MeshFilter meshFilter in meshFilters)
            {
                Mesh mesh = meshFilter.sharedMesh;
                if (!mesh)
                    continue;

                Matrix4x4 matrix = meshFilter.transform.localToWorldMatrix;
                meshesData.Add((mesh, matrix));
            }

            var brushParameters = new BrushParameters(
                brushCenter, terrainManagerData.BrushSize, terrainManagerData.TerrainUV.transform.position.y,
                terrainHeight,
                brushBounds,
                -terrainManagerData.TerrainUV.transform.position.y,
                terrainPainterData.TerrainCarveQuality,
                terrainPainterData.BrushAdditionalSize
            );

            terrainManagerData.Texture2DCarve = TerrainManagerUtils.GenerateBrushFromCamera(meshesData, brushParameters);

            if (terrainCarvePower != null)
                GenerateParamsTexture(terrainPainterData, terrainManagerData, terrainHeight, terrainCarvePower);

            return true;
        }

        private static void GenerateParamsTexture(TerrainPainterData terrainPainterData, TerrainManagerData terrainManagerData, float terrainHeight, AnimationCurve terrainCarvePower)
        {
            int textureParamsSize = (int)(0.5f * (int)terrainPainterData.TerrainCarveQuality);
            ushort[] paramsColors = new ushort[textureParamsSize];

            if (!terrainManagerData.ParamsTextureCarve || terrainManagerData.ParamsTextureCarve.width != textureParamsSize)
            {
                terrainManagerData.ParamsTextureCarve = new Texture2D(textureParamsSize, 1, TextureFormat.R16, false)
                {
                    wrapMode = TextureWrapMode.Clamp
                };
            }

            for (int i = 0; i < textureParamsSize; i++)
            {
                float power = RamMath.Remap(i, 0, textureParamsSize - 1, -terrainManagerData.BrushSize, terrainManagerData.BrushSize);

                power = terrainCarvePower.Evaluate(power);

                //power = 100 * i / (float) textureParamsSize;
                power = RamMath.Remap(power, -terrainHeight, terrainHeight, 0, 1);

                //Debug.Log(i + " " + power);

                paramsColors[i] = (ushort)(power * ushort.MaxValue);
            }

            terrainManagerData.ParamsTextureCarve.SetPixelData(paramsColors, 0);
            terrainManagerData.ParamsTextureCarve.Apply();
        }

        public void StampTerrain(TerrainPainterData terrainPainterData, PaintHeightPasses paintHeightPasses = PaintHeightPasses.CarveTerrain)
        {
            TerrainStamper.ModifyTerrain(terrainPainterData, terrainManagerData, MeshFilters, paintHeightPasses);
        }

        public void DrawStampPreview(TerrainPainterData terrainPainterData)
        {
            TerrainStamper.DrawPreview(terrainPainterData, terrainManagerData);
        }

        public void CarveTerrain(TerrainPainterData terrainPainterData, PaintHeightPasses paintHeightPasses = PaintHeightPasses.CarveTerrain)
        {
            TerrainCarver.ModifyTerrain(terrainPainterData, terrainManagerData, MeshFilters, paintHeightPasses);
        }

        public void DrawCarvePreview(TerrainPainterData terrainPainterData)
        {
            TerrainCarver.DrawPreview(terrainPainterData, terrainManagerData);
        }

        public void PaintTerrain(TerrainPainterData terrainPainterData, PaintHeightPasses paintHeightPasses = PaintHeightPasses.PaintTexture)
        {
            TerrainPainter.ModifyTerrain(terrainPainterData, terrainManagerData, MeshFilters, paintHeightPasses);
        }
    }
}