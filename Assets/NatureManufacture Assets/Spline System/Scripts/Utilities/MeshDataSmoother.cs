// /**
//  * Created by Pawel Homenko on  11/2023
//  */

using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class MeshDataSmoother
    {
        public static void SmoothVerticeData(int smoothAmount, List<Vector4> dataList, int vertCount, List<int> indices, bool checkZero = true, int smoothDepth = 0,
            bool omitZero = false)
        {
            HashSet<int>[] connectedVertices = GetConnectedVertices(vertCount, indices);
            SmoothVerticeData(connectedVertices, smoothAmount, dataList, vertCount, smoothDepth, checkZero, omitZero);
        }

        public static void SmoothVerticeData(HashSet<int>[] connectedVertices, int smoothAmount, List<Vector4> dataList, int vertCount, int smoothDepth = 0, bool checkZero = true, bool omitZero = false)
        {
            if (smoothAmount <= 0) return;


            HashSet<int>[] verticesToConsiders;
            Vector4 zero = Vector4.zero;


            if (smoothDepth > 0)
            {
                verticesToConsiders = new HashSet<int>[vertCount];
                for (int i = 0; i < vertCount; i++)
                {
                    if (connectedVertices[i] == null || connectedVertices[i].Count <= 0) continue;

                    HashSet<int> verticesToConsider = new(connectedVertices[i]);
                    for (int d = 0; d < smoothDepth; d++)
                    {
                        HashSet<int> newVerticesToConsider = new();
                        foreach (int vertex in verticesToConsider)
                        {
                            newVerticesToConsider.UnionWith(connectedVertices[vertex]);
                        }

                        newVerticesToConsider.UnionWith(verticesToConsider);
                        verticesToConsider = newVerticesToConsider;
                    }

                    verticesToConsiders[i] = verticesToConsider;
                }
            }
            else
                verticesToConsiders = connectedVertices;


            for (int s = 0; s < smoothAmount; s++)
            {
                for (int i = 0; i < vertCount; i++)
                {
                    if (verticesToConsiders[i] == null || verticesToConsiders[i].Count <= 0) continue;

                    Vector4 averageFlow = dataList[i];

                    if (omitZero && averageFlow == zero)
                        continue;

                    int countConnected = 1;

                    foreach (int connectedVertex in verticesToConsiders[i])
                    {
                        if (checkZero && dataList[connectedVertex] == zero)
                            continue;

                        countConnected++;
                        averageFlow += dataList[connectedVertex];
                    }

                    averageFlow /= countConnected;
                    dataList[i] = averageFlow;
                }
            }
        }

        public static HashSet<int>[] GetConnectedVertices(int vertCount, List<int> indices)
        {
            HashSet<int>[] connectedVertices = new HashSet<int>[vertCount];
            for (int i = 0; i < indices.Count; i += 3)
            {
                int vertexA = indices[i];
                int vertexB = indices[i + 1];
                int vertexC = indices[i + 2];

                connectedVertices[vertexA] ??= new HashSet<int>();
                connectedVertices[vertexA].Add(vertexB);
                connectedVertices[vertexA].Add(vertexC);

                connectedVertices[vertexB] ??= new HashSet<int>();
                connectedVertices[vertexB].Add(vertexA);
                connectedVertices[vertexB].Add(vertexC);

                connectedVertices[vertexC] ??= new HashSet<int>();
                connectedVertices[vertexC].Add(vertexA);
                connectedVertices[vertexC].Add(vertexB);
            }

            return connectedVertices;
        }
    }
}