using System;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class TerrainSplinesManagerDataHolder : MonoBehaviour
    {
        public List<GameObject> terrainPainterObjectsPrepass = new();
        public List<GameObject> terrainPainterObjects = new();
        [SerializeField] private TerrainPainterData terrainPainterData;

        public List<GameObject> TerrainPainterObjects
        {
            get => terrainPainterObjects;
            set => terrainPainterObjects = value;
        }

        public List<ITerrainPainterGetData> TerrainPainterGetDataObjects
        {
            get
            {
                List<ITerrainPainterGetData> terrainPainterGetDataObjects = new();
                foreach (GameObject terrainPainterObject in TerrainPainterObjects)
                {
                    if (terrainPainterObject == null) continue;

                    var terrainPainterGetData = terrainPainterObject.GetComponent<ITerrainPainterGetData>();
                    if (terrainPainterGetData != null)
                    {
                        terrainPainterGetDataObjects.Add(terrainPainterGetData);
                    }
                }

                return terrainPainterGetDataObjects;
            }
        }

        public List<GameObject> TerrainPainterObjectsPrepass
        {
            get => terrainPainterObjectsPrepass;
            set => terrainPainterObjectsPrepass = value;
        }

        public List<ITerrainPainterGetData> TerrainPainterGetDataObjectsPrepass
        {
            get
            {
                List<ITerrainPainterGetData> terrainPainterGetDataObjects = new();
                foreach (GameObject terrainPainterObject in TerrainPainterObjectsPrepass)
                {
                    var terrainPainterGetData = terrainPainterObject.GetComponent<ITerrainPainterGetData>();
                    if (terrainPainterGetData != null)
                    {
                        terrainPainterGetDataObjects.Add(terrainPainterGetData);
                    }
                }

                return terrainPainterGetDataObjects;
            }
        }


        public TerrainPainterData PainterData
        {
            get => terrainPainterData;
            set => terrainPainterData = value;
        }


        public void SortAndCheckList()
        {
            SortByHierarchyOrder(TerrainPainterObjects);
        }

        public static void SortByHierarchyOrder(List<GameObject> gameObjects)
        {
            gameObjects.Sort((a, b) => GetHierarchyPath(a.transform) >= GetHierarchyPath(b.transform) ? 1 : -1);
        }

        private static double GetHierarchyPath(Transform transform)
        {
            double size = 100;
            double path = transform.GetSiblingIndex();
            while (transform.parent != null)
            {
                transform = transform.parent;
                path += transform.GetSiblingIndex() * size;
                size *= 100;
            }

            path /= size;
            return path;
        }

        public void AddRangeWithoutDuplicates(TerrainSpline[] terrainSplines)
        {
            foreach (TerrainSpline terrainSpline in terrainSplines)
            {
                if (terrainSpline != null && !TerrainPainterObjects.Contains(terrainSpline.gameObject) && !TerrainPainterObjectsPrepass.Contains(terrainSpline.gameObject))
                {
                    TerrainPainterObjects.Add(terrainSpline.gameObject);
                }
            }

            //Debug.Log($"TerrainPainterObjects.Count: {TerrainPainterObjects.Count}");
        }

        public void AddRangeWithoutDuplicates(LakePolygon[] terrainSplines)
        {
            foreach (LakePolygon terrainSpline in terrainSplines)
            {
                if (terrainSpline != null && !TerrainPainterObjects.Contains(terrainSpline.gameObject) && !TerrainPainterObjectsPrepass.Contains(terrainSpline.gameObject))
                {
                    TerrainPainterObjects.Add(terrainSpline.gameObject);
                }
            }
        }

        public void AddRangeWithoutDuplicates(RamSpline[] terrainSplines)
        {
            foreach (RamSpline terrainSpline in terrainSplines)
            {
                if (terrainSpline != null && !TerrainPainterObjects.Contains(terrainSpline.gameObject) && !TerrainPainterObjectsPrepass.Contains(terrainSpline.gameObject))
                {
                    TerrainPainterObjects.Add(terrainSpline.gameObject);
                }
            }
        }
    }
}