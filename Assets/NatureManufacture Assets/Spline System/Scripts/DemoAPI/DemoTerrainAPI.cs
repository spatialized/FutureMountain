using NatureManufacture.RAM;
using UnityEngine;

public class DemoTerrainAPO : MonoBehaviour
{
    [SerializeField] TerrainSpline clearTerrainSpline;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        clearTerrainSpline.RamTerrainManager.TerrainManager.CarveTerrain(clearTerrainSpline.RamTerrainManager.BasePainterData);
        clearTerrainSpline.RamTerrainManager.TerrainManager.PaintTerrain(clearTerrainSpline.RamTerrainManager.BasePainterData);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}