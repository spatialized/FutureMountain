using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.TerrainTools;

namespace NatureManufacture.RAM
{
    public static class TerrainManagerUtils
    {
        private static readonly int _BrushParams = Shader.PropertyToID("_BrushParams");
        private static readonly int _HeightMax = Shader.PropertyToID("_heightMax");
        private static readonly int _BlurAdditionalSize = Shader.PropertyToID("_BlurAdditionalSize");
        private static readonly int _BlurSize = Shader.PropertyToID("_BlurSize");
        private static readonly int _ConvexParams = Shader.PropertyToID("_ConvexParams");
        private static readonly int _PassNumber = Shader.PropertyToID("_PassNumber");
        private static readonly int _HeightOffset = Shader.PropertyToID("_heightOffset");

        public enum BrushGeneratorPass
        {
            Copy = 0,
            Border = 1,
            Blur = 2,
            BlurRChannel = 3,
        }

        /// <summary>
        /// r - height of spline
        /// g - distance to border
        /// b - mask of spline
        /// a - blend distance by brush additional
        /// </summary>
        /// <param name="meshesData"></param>
        /// <param name="brushParameters"></param>
        /// <returns></returns>
        public static RenderTexture GenerateBrushFromCamera(List<(Mesh, Matrix4x4)> meshesData, BrushParameters brushParameters)
        {
            RenderTexture currentActiveRT = RenderTexture.active;


            RenderTexture depthRenderTexture = GenerateDepthMask(meshesData, brushParameters);


            RenderTexture renderTexture = RenderTexture.GetTemporary(depthRenderTexture.width, depthRenderTexture.height, 0, RenderTextureFormat.ARGB64, RenderTextureReadWrite.Linear);
            RenderTexture renderTextureSecond = RenderTexture.GetTemporary(depthRenderTexture.width, depthRenderTexture.height, 0, RenderTextureFormat.ARGB64, RenderTextureReadWrite.Linear);

            var materialRenderBrush = new Material(Shader.Find("Hidden/NatureManufacture Shaders/BrushGenerator"));

            //TextureManager.SaveTexture(depthRenderTexture, TextureFormat.RGBA64, "1depthMask");

            Graphics.Blit(depthRenderTexture, renderTexture, materialRenderBrush, (int)BrushGeneratorPass.Border);

            //TextureManager.SaveTexture(renderTexture, TextureFormat.RGBA64, "2Border");

            float additionalSize = brushParameters.AdditionalSize / brushParameters.BrushSize;
            materialRenderBrush.SetFloat(TerrainManagerUtils._BlurAdditionalSize, additionalSize);

            for (int i = 0; i < (int)(0.25f * (int)brushParameters.CarveQuality); i++)
            {
                materialRenderBrush.SetFloat(TerrainManagerUtils._BlurSize, (i * 2) / (float)(depthRenderTexture.height));
                materialRenderBrush.SetFloat(TerrainManagerUtils._PassNumber, i * 2);
                Graphics.Blit(renderTexture, renderTextureSecond, materialRenderBrush, (int)BrushGeneratorPass.Blur);
                materialRenderBrush.SetFloat(TerrainManagerUtils._BlurSize, (i * 2 + 1) / (float)(depthRenderTexture.height));
                materialRenderBrush.SetFloat(TerrainManagerUtils._PassNumber, i * 2 + 1);
                Graphics.Blit(renderTextureSecond, renderTexture, materialRenderBrush, (int)BrushGeneratorPass.Blur);
            }


            //TextureManager.SaveTexture(renderTexture, TextureFormat.RGBA64, "3Blur");


            for (int i = 0; i < 0.25f * (int)brushParameters.CarveQuality; i++)
            {
                Graphics.Blit(renderTexture, renderTextureSecond, materialRenderBrush, (int)BrushGeneratorPass.BlurRChannel);
                Graphics.Blit(renderTextureSecond, renderTexture, materialRenderBrush, (int)BrushGeneratorPass.BlurRChannel);
            }


            Graphics.Blit(renderTexture, depthRenderTexture, materialRenderBrush, (int)BrushGeneratorPass.Copy);


            //TextureManager.SaveTexture(depthRenderTexture, TextureFormat.RGBA64, "4Blur R");


            RenderTexture.ReleaseTemporary(renderTexture);
            RenderTexture.ReleaseTemporary(renderTextureSecond);

            RenderTexture.active = currentActiveRT;


            return depthRenderTexture;
        }

        public static RenderTexture GenerateDepthMask(List<(Mesh, Matrix4x4)> meshesData, BrushParameters brushParameters)
        {
            Vector3 position = brushParameters.BrushCenter;
            position.y = brushParameters.BrushBounds.max.y + 10;

            var depthMaterial = new Material(Shader.Find("Hidden/NatureManufacture Shaders/WorldDepth"));
            depthMaterial.SetFloat(_HeightMax, brushParameters.TerrainHeight);
            depthMaterial.SetFloat(_HeightOffset, -brushParameters.HeightOffset);


            Matrix4x4 orthoMatrix = Matrix4x4.Ortho(-brushParameters.BrushSize * 0.5f, brushParameters.BrushSize * 0.5f, -brushParameters.BrushSize * 0.5f, brushParameters.BrushSize * 0.5f, 2, 2000);

            RenderTexture depthRenderTexture =
                RenderTexture.GetTemporary((int)brushParameters.CarveQuality, (int)brushParameters.CarveQuality, 0, RenderTextureFormat.ARGB64, RenderTextureReadWrite.Linear);

            Matrix4x4 rotationMatrix = Matrix4x4.LookAt(position, brushParameters.BrushCenter, Vector3.forward);
            Matrix4x4 translationMatrix = Matrix4x4.TRS(Vector3.zero, Quaternion.identity, new Vector3(1, 1, -1));
            Matrix4x4 worldToCameraMatrix = translationMatrix * rotationMatrix.inverse;

            var depthCommandBuffer = new CommandBuffer();
            depthCommandBuffer.name = "ModelWorldDepthBaker";


            depthCommandBuffer.Clear();
            depthCommandBuffer.SetRenderTarget(depthRenderTexture);
            depthCommandBuffer.ClearRenderTarget(true, true, Color.black);
            depthCommandBuffer.SetViewProjectionMatrices(worldToCameraMatrix, orthoMatrix);

            foreach ((Mesh mesh, Matrix4x4 matrix) meshData in meshesData)
            {
                depthCommandBuffer.DrawMesh(meshData.mesh, meshData.matrix, depthMaterial, 0);
            }

            Graphics.ExecuteCommandBuffer(depthCommandBuffer);
            depthCommandBuffer.Release();

            //Object.DestroyImmediate(cameraGameObject);
            return depthRenderTexture;
        }

        public static RenderTexture GetBrushPaint(PaintContext paintContext, BrushTransform brushTransform)
        {
            Material materialPaintHeight = Object.Instantiate(TerrainPaintUtility.GetBuiltinPaintMaterial());
            materialPaintHeight.shader = Shader.Find("Hidden/NatureManufacture Shaders/PaintHeight");


            RenderTexture source = paintContext.sourceRenderTexture;
            TerrainPaintUtility.SetupTerrainToolMaterialProperties(paintContext, brushTransform, materialPaintHeight);

            RenderTexture renderTexture = RenderTexture.GetTemporary(source.width, source.height, source.depth, RenderTextureFormat.R16);

            Graphics.Blit(source, renderTexture, materialPaintHeight, (int)TerrainManager.PaintHeightPasses.CopyTerrainHeightmap);
            return renderTexture;
        }


        public static RenderTexture BooleanMask(PaintContext paintContext, BrushTransform brushTransform, RenderTexture maskTexture = null)
        {
            Material materialPaintHeight = Object.Instantiate(TerrainPaintUtility.GetBuiltinPaintMaterial());
            materialPaintHeight.shader = Shader.Find("Hidden/NatureManufacture Shaders/PaintHeight");

            materialPaintHeight.SetTexture("_MaskTex", maskTexture);

            RenderTexture source = paintContext.sourceRenderTexture;
            TerrainPaintUtility.SetupTerrainToolMaterialProperties(paintContext, brushTransform, materialPaintHeight);

            if (!maskTexture)
                maskTexture = RenderTexture.GetTemporary(source.width, source.height, source.depth, RenderTextureFormat.R16);

            RenderTexture temp = RenderTexture.GetTemporary(source.width, source.height, source.depth, RenderTextureFormat.R16);

            Graphics.Blit(source, temp, materialPaintHeight, (int)TerrainManager.PaintHeightPasses.AndMask);
            Graphics.Blit(temp, maskTexture);

            RenderTexture.ReleaseTemporary(temp);
            return maskTexture;
        }

        public static (Terrain, Vector2) GetTerrainUV(Vector3 brushCenter)
        {
            Terrain[] terrains = Terrain.activeTerrains;

            for (int i = 0; i < terrains.Length; i++)
            {
                Terrain terrain = terrains[i];
                Vector3 terrainPos = terrain.transform.position;
                Vector3 terrainSize = terrain.terrainData.size;

                if (!(brushCenter.x >= terrainPos.x) || !(brushCenter.x <= terrainPos.x + terrainSize.x) ||
                    !(brushCenter.z >= terrainPos.z) || !(brushCenter.z <= terrainPos.z + terrainSize.z)) continue;

                float u = (brushCenter.x - terrainPos.x) / terrainSize.x;
                float v = (brushCenter.z - terrainPos.z) / terrainSize.z;

                return (terrain, new Vector2(u, v));
            }

            return (null, Vector2.zero);

            /*
              // Debug.DrawLine(_brushCenter, _brushCenter + Vector3.up * 1000, Color.cyan, 20);
              var ray = new Ray(brushCenter + Vector3.up * 10000, Vector3.down);

              RaycastHit[] hits = Physics.RaycastAll(ray, Mathf.Infinity);

              if (hits.Length <= 0)
              {
                  Debug.Log("No terrain found");
                  return (null, Vector2.zero);
              }


              foreach (var hit in hits)
              {
                  if (hit.collider is not TerrainCollider) continue;

                  return (hit.collider.GetComponent<Terrain>(), hit.textureCoord);
              }

              Debug.Log("No terrain found");
              return (null, Vector2.zero);*/
        }

        public static (RenderTexture MaskTexture, RenderTexture HeightTexture) GenerateMaskFromTerrainHeight(BrushTransform brushTransform, TerrainConvexParameters convexParameters, Terrain terrainUV,
            RenderTexture concaveMaskRT,
            RenderTexture heightMaskRT, int quality)
        {
            var materialPaintHeight = new Material(Shader.Find("Hidden/NatureManufacture Shaders/PaintHeight"));

            var brushParams = new Vector4(0, 0, terrainUV.terrainData.size.y, 0);
            materialPaintHeight.SetVector(TerrainManagerUtils._BrushParams, brushParams);

            //Debug.Log((int)convexParameters.Convex);

            var convexParams = new Vector4(convexParameters.Steps, convexParameters.StepSize, convexParameters.Strength, (int)convexParameters.Convex);
            materialPaintHeight.SetVector(TerrainManagerUtils._ConvexParams, convexParams);

            if (!heightMaskRT)
            {
               /* Rect rect = brushTransform.GetBrushXYBounds();
                float terrainSizeX = terrainUV.terrainData.size.x;
                int additionalSize = (int)((terrainSizeX - rect.width));*/


                //Debug.Log($"rect {rect} terrain size {terrainSizeX} additional size {additionalSize} quality {quality}");

                PaintContext paintContextHeight = TerrainPaintUtility.BeginPaintHeightmap(terrainUV, brushTransform.GetBrushXYBounds(), 1);
                RenderTexture source = paintContextHeight.sourceRenderTexture;

                // heightMaskRT = RenderTexture.GetTemporary(source.width, source.height, source.depth, RenderTextureFormat.ARGB64);
                heightMaskRT = RenderTexture.GetTemporary(source.width, source.height, source.depth, RenderTextureFormat.ARGB64);

               // Debug.Log($"heightMaskRT {heightMaskRT.width} {heightMaskRT.height}");
                TerrainPaintUtility.SetupTerrainToolMaterialProperties(paintContextHeight, brushTransform, materialPaintHeight);

                //Graphics.Blit(paintContextHeight.sourceRenderTexture, paintContextHeight.destinationRenderTexture, materialPaintHeight, (int)PaintHeightPasses.CopyTerrainHeightmap);
                Graphics.Blit(source, heightMaskRT, materialPaintHeight, (int)TerrainManager.PaintHeightPasses.CopyTerrainHeightmap);

                TerrainPaintUtility.ReleaseContextResources(paintContextHeight);
                //TerrainPaintUtility.EndPaintHeightmap(paintContextHeight, "Generate normal");
            }

           // TextureManager.SaveTexture(heightMaskRT, TextureFormat.RGBA64, "HeightMaskRT");

            RenderTexture renderTexture = concaveMaskRT ? concaveMaskRT : RenderTexture.GetTemporary(heightMaskRT.width, heightMaskRT.height, heightMaskRT.depth, RenderTextureFormat.ARGB64);


            Graphics.Blit(heightMaskRT, renderTexture, materialPaintHeight, (int)TerrainManager.PaintHeightPasses.MaskGenerator);

            //TextureManager.SaveTexture(renderTexture, TextureFormat.RGBA64, "renderTexture");

            return (renderTexture, heightMaskRT);
        }
    }
}