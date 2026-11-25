using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class TerrainClearFoliage
    {
        public struct CarveData
        {
            public Vector4[,] Distances;
            public float MaxX;
            public float MaxZ;
            public float MinX;
            public float MinZ;

            public CarveData(Vector4[,] distances, float maxX, float maxZ, float minX, float minZ)
            {
                Distances = distances;
                MaxX = maxX;
                MaxZ = maxZ;
                MinX = minX;
                MinZ = minZ;
            }
        }


        public static void TerrainClearTrees(NmSpline nmSpline, float distanceClearFoliage, bool details = true)
        {
            Terrain[] terrains = Terrain.activeTerrains;

            //Physics.autoSyncTransforms = false;


            foreach (Terrain terrain in terrains)
            {
                TerrainData terrainData = terrain.terrainData;

                Transform transformTerrain = terrain.transform;
                float polygonHeight = nmSpline.Transform.position.y;
                //var posY = terrain.transform.position.y;
                float sizeX = terrainData.size.x;
                //var sizeY = terrainData.size.y;
                float sizeZ = terrainData.size.z;


#if UNITY_EDITOR
                Undo.RegisterCompleteObjectUndo(terrainData, "Paint");
                Undo.RegisterCompleteObjectUndo(terrain, "Terrain draw texture");
#endif
                float minX = float.MaxValue;
                float maxX = float.MinValue;
                float minZ = float.MaxValue;
                float maxZ = float.MinValue;

                for (int i = 0; i < nmSpline.Points.Count; i++)
                {
                    Vector3 point = nmSpline.Transform.TransformPoint(nmSpline.Points[i].Position);


                    if (minX > point.x)
                        minX = point.x;

                    if (maxX < point.x)
                        maxX = point.x;

                    if (minZ > point.z)
                        minZ = point.z;

                    if (maxZ < point.z)
                        maxZ = point.z;
                }


                //Debug.DrawLine(new Vector3(minX, 0, minZ), new Vector3(minX, 0, minZ) + Vector3.up * 100, Color.green, 3);
                // Debug.DrawLine(new Vector3(maxX, 0, maxZ), new Vector3(maxX, 0, maxZ) + Vector3.up * 100, Color.blue, 3);


                float terrainToWidth = 1 / sizeZ * (terrainData.detailWidth - 1);
                float terrainToHeight = 1 / sizeX * (terrainData.detailHeight - 1);
                Vector3 position1 = terrain.transform.position;
                minX -= position1.x + distanceClearFoliage;
                maxX -= position1.x - distanceClearFoliage;

                minZ -= position1.z + distanceClearFoliage;
                maxZ -= position1.z - distanceClearFoliage;


                minX *= terrainToHeight;
                maxX *= terrainToHeight;

                minZ *= terrainToWidth;
                maxZ *= terrainToWidth;

                minX = (int)Mathf.Clamp(minX, 0, terrainData.detailWidth);
                maxX = (int)Mathf.Clamp(maxX, 0, terrainData.detailWidth);
                minZ = (int)Mathf.Clamp(minZ, 0, terrainData.detailHeight);
                maxZ = (int)Mathf.Clamp(maxZ, 0, terrainData.detailHeight);
                
                //Debug.Log($"min {minX} {minZ} max {maxX} {maxZ} {maxX - minX} {maxZ - minZ}");

                int[,] detailLayer = terrainData.GetDetailLayer((int)minX, (int)minZ, (int)(maxX - minX), (int)(maxZ - minZ), 0);

                Vector4[,] distances = new Vector4[detailLayer.GetLength(0), detailLayer.GetLength(1)];

                var meshCollider = nmSpline.Transform.gameObject.AddComponent<MeshCollider>();


                Vector3 position = Vector3.zero;
                position.y = polygonHeight;

                for (int x = 0; x < detailLayer.GetLength(0); x++)
                for (int z = 0; z < detailLayer.GetLength(1); z++)
                {
                    Vector3 position2 = transformTerrain.position;
                    position.x = (z + minX) / terrainToHeight + position2.x; //, polygonHeight
                    position.z = (x + minZ) / terrainToWidth + position2.z;

                    var ray = new Ray(position + Vector3.up * 1000, Vector3.down);

                    if (meshCollider.Raycast(ray, out RaycastHit hit, 10000))
                    {
                        // Debug.DrawLine(hit.point, hit.point + Vector3.up * 30, Color.green, 3);

                        float minDist = float.MaxValue;
                        for (int i = 0; i < nmSpline.Points.Count; i++)
                        {
                            int idOne = i;
                            int idTwo = (i + 1) % nmSpline.Points.Count;

                            float dist = RamMath.DistancePointLine(hit.point, nmSpline.Transform.TransformPoint(nmSpline.Points[idOne].Position), nmSpline.Transform.TransformPoint(nmSpline.Points[idTwo].Position));
                            if (minDist > dist)
                                minDist = dist;
                        }

                        float angle = 0;


                        distances[x, z] = new Vector4(hit.point.x, minDist, hit.point.z, angle);
                    }
                    else
                    {
                        float minDist = float.MaxValue;
                        for (int i = 0; i < nmSpline.Points.Count; i++)
                        {
                            int idOne = i;
                            int idTwo = (i + 1) % nmSpline.Points.Count;

                            float dist = RamMath.DistancePointLine(position, nmSpline.Transform.TransformPoint(nmSpline.Points[idOne].Position), nmSpline.Transform.TransformPoint(nmSpline.Points[idTwo].Position));
                            if (minDist > dist)
                                minDist = dist;
                        }

                        float angle = 0;

                        distances[x, z] = new Vector4(position.x, -minDist, position.z, angle);
                    }
                }

                if (!details)
                {
                    List<TreeInstance> newTrees = new List<TreeInstance>();
                    TreeInstance[] oldTrees = terrainData.treeInstances;

                    position.y = polygonHeight;
                    foreach (TreeInstance tree in oldTrees)
                    {
                        //Debug.DrawRay(new Vector3(, 0, tree.position.z * sizeZ) + terrain.transform.position, Vector3.up * 5, Color.red, 3);

                        Vector3 position2 = transformTerrain.position;
                        position.x = tree.position.x * sizeX + position2.x; //, polygonHeight
                        position.z = tree.position.z * sizeZ + position2.z;

                        var ray = new Ray(position + Vector3.up * 1000, Vector3.down);

                        if (!meshCollider.Raycast(ray, out RaycastHit _, 10000))
                        {
                            float minDist = float.MaxValue;
                            for (int i = 0; i < nmSpline.Points.Count; i++)
                            {
                                int idOne = i;
                                int idTwo = (i + 1) % nmSpline.Points.Count;

                                float dist = RamMath.DistancePointLine(position, nmSpline.Transform.TransformPoint(nmSpline.Points[idOne].Position),
                                    nmSpline.Transform.TransformPoint(nmSpline.Points[idTwo].Position));
                                if (minDist > dist)
                                    minDist = dist;
                            }

                            if (minDist > distanceClearFoliage) newTrees.Add(tree);
                        }
                    }

                    terrainData.treeInstances = newTrees.ToArray();
                    Object.DestroyImmediate(meshCollider);
                }

            
                CarveData clearData = new CarveData(distances, maxX, maxZ, minX, minZ);


                // terrainData.treeInstances = newTrees.ToArray();
                if (details)
                    for (int l = 0; l < terrainData.detailPrototypes.Length; l++)
                    {
                        //Debug.Log($"detail layer {l} clear min {clearData.MinX} {clearData.MinZ} max {clearData.MaxX} {clearData.MaxZ} {clearData.MaxX - clearData.MinX} {clearData.MaxZ - clearData.MinZ}");
                        detailLayer = terrainData.GetDetailLayer((int)clearData.MinX,
                            (int)clearData.MinZ, (int)(clearData.MaxX - clearData.MinX),
                            (int)(clearData.MaxZ - clearData.MinZ), l);

                      if(detailLayer == null)
                            continue;

                        for (int x = 0; x < detailLayer.GetLength(0); x++)
                        {
                            for (int z = 0; z < detailLayer.GetLength(1); z++)
                            {
                                Vector4 distance = clearData.Distances[x, z];

                                if (-distance.y <= distanceClearFoliage || distance.y > 0)
                                {
                                    // float oldValue = detailLayer[x, z];
                                    detailLayer[x, z] = 0;
                                }
                            }
                        }

                        terrainData.SetDetailLayer((int)clearData.MinX, (int)clearData.MinZ, l,
                            detailLayer);
                    }


                terrain.Flush();


                Object.DestroyImmediate(meshCollider);
            }

            //Physics.autoSyncTransforms = true;
        }
    }
}