// /**
//  * Created by Pawel Homenko on  12/2023
//  */

using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class LakeFlowmapGenerator
    {
        public void GenerateAutomaticFlowmap(List<Vector4> colorsFlowMap, int vertCount, List<int> indices, LakePolygon lakePolygon)
        {
            colorsFlowMap.Clear();

            //switch baseprofile automatic flowmap type
            switch (lakePolygon.BaseProfile.automaticFlowmapType)
            {
                case LakePolygonProfile.FlowmapType.Central:
                    CentralFlowmap(colorsFlowMap, vertCount, indices, lakePolygon);
                    break;
                case LakePolygonProfile.FlowmapType.Directional:
                    DirectionalFlowmap(colorsFlowMap, vertCount, lakePolygon);
                    break;
                default:
                    Debug.Log($"Wrong flowmap type {lakePolygon.BaseProfile.automaticFlowmapType}");
                    break;
            }
        }

        private void DirectionalFlowmap(List<Vector4> colorsFlowMap, int vertCount, LakePolygon lakePolygon)
        {
            for (int i = 0; i < vertCount; i++)
            {
                Vector2 flow = lakePolygon.BaseProfile.automaticFlowmapDirection.normalized * lakePolygon.BaseProfile.automaticFlowMapScale;


                colorsFlowMap.Add(flow);
            }
        }

        private static void CentralFlowmap(List<Vector4> colorsFlowMap, int vertCount, List<int> indices, LakePolygon lakePolygon)
        {
            for (int i = 0; i < vertCount; i++)
            {
                RamMath.MinimumDistanceVector minimumDistanceVector = lakePolygon.MinimumDistanceVectors[i];
                Vector4 flow = CalculateFlow(minimumDistanceVector, lakePolygon);
                colorsFlowMap.Add(flow);
            }

            if (lakePolygon.BaseProfile.automaticFlowMapSmooth)
            {
                //check time of for loop
                //double timeLoop = EditorApplication.timeSinceStartup;
                MeshDataSmoother.SmoothVerticeData(lakePolygon.BaseProfile.automaticFlowMapSmoothAmount, colorsFlowMap, vertCount, indices);
                //Debug.Log($"timeloop {EditorApplication.timeSinceStartup - timeLoop}");
            }
        }


        private static Vector4 CalculateFlow(RamMath.MinimumDistanceVector minimumDistanceVector, LakePolygon lakePolygon)
        {
            Vector2 currentPoint = minimumDistanceVector.Vertice;
            float noise = lakePolygon.BaseProfile.noiseFlowMap
                ? Mathf.PerlinNoise(currentPoint.x * lakePolygon.BaseProfile.noiseSizeXFlowMap * 0.1f, currentPoint.y * lakePolygon.BaseProfile.noiseSizeZFlowMap * 0.1f) * lakePolygon.BaseProfile.noiseMultiplierFlowMap
                : 1;

            Vector2 flow = -(minimumDistanceVector.Point - currentPoint).normalized * (lakePolygon.BaseProfile.automaticFlowMapScale * noise);

            if (minimumDistanceVector.Distance > lakePolygon.BaseProfile.automaticFlowMapDistance)
            {
                flow *= 1 - Mathf.Clamp01((minimumDistanceVector.Distance - lakePolygon.BaseProfile.automaticFlowMapDistance) / lakePolygon.BaseProfile.automaticFlowMapDistanceBlend);
            }

            var finalFlow = CalculateFinalFlow(currentPoint, minimumDistanceVector, flow);

            return finalFlow;
        }

        private static Vector4 CalculateFinalFlow(Vector2 currentPoint, RamMath.MinimumDistanceVector minimumDistanceVector, Vector2 flow)
        {
            Vector4 finalFlow = new Vector4(flow.x, flow.y, flow.x, flow.y);

            flow = (currentPoint - minimumDistanceVector.Point).normalized * minimumDistanceVector.Distance;
            finalFlow.z = flow.x;
            finalFlow.w = flow.y;
            return finalFlow;
        }
    }
}