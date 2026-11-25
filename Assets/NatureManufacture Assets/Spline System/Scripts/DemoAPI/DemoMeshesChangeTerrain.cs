using System.Collections;
using System.Collections.Generic;
using NatureManufacture.RAM;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class DemoMeshesChangeTerrain : MonoBehaviour
    {
        [SerializeField] private TerrainPainterData terrainPainterData;

        [SerializeField] private List<MeshFilter> meshFilters;


        private void Start()
        {
            HashSet<MeshFilter> meshFiltersHashSet = new(meshFilters);

            var terrainManager = new TerrainManager(meshFiltersHashSet);
            terrainPainterData.TerrainsUnder.Clear();
            terrainPainterData.TerrainsUnder.Add(Terrain.activeTerrain);
            terrainManager.CarveTerrain(terrainPainterData);
            terrainManager.PaintTerrain(terrainPainterData);
        }
    }
}