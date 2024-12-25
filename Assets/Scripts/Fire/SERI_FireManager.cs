/* Adapted from FireManager.cs
// Fire Propagation System
// Copyright (c) 2016-2017 Lewis Ward
// author: Lewis Ward
// date  : 04/04/2017
*/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Assertions;

/// <summary>
/// Fire Manager class.
/// </summary>
public class SERI_FireManager : MonoBehaviour 
{
    #region Fields
    /* State */
    public bool burning = false;
    public bool webOptimized = false;

    /* Ignition */
    [SerializeField]
    private int gridWidth = 20;
    [SerializeField]
    private int gridHeight = 20;

    //[SerializeField]
    private GameObject firePrefab;

    /* Fire */
    private int gridIdx = -1;
    private SERI_FireGrid[] fireGrids;
    private GameObjectPool pooler;

    /* Main Settings */
    public Terrain terrain = null; // terrain should be the parent GameObject of this object

    [Tooltip("Size of the index array used to keep track of active fires in a FireGrid, if goes over array will increase.")]
    public int preAllocatedFireIndexSize = 100;
    //public float cellSize = 1.0f;
    public float cellSize = 10.0f;                      // -- TO DO: CALCULATE FROM Height / GridHeight, Width / GridWidth
    [Tooltip("Relative position of fire spawning in the cell (0 -> 1). If left empty default value is 0.5 on X and Y.")]
    public Vector2[] cellFireSpawnPositions;
    [Tooltip("How fast fuel is used in the combustion step within FireCell's, higher the value the faster fuels are used up.")]
    public float maxCombustionRate = 1.1f;
    [Tooltip("How fast fuel is used in the combustion step with FireNode's, higher the value the faster fuels are used up.")]
    public float maxNodeCombustionRate = 1.1f;
    [Tooltip("The textured used on the terrain are fuels, can set fuel values for each texture.")]
    public SERI_FireTerrainTexture[] terrainTextures;
    [SerializeField][Tooltip("The index of the terrain grass texture to replace grass with once burnt, this is used only if 'Remove Grass Once Burnt' is disabled.")]
    private int burntGrassTextureIndex = 0;
    [Tooltip("Removes grass in a lit fire cell.")]
    public bool removeGrassOnceBurnt = false;
    [Tooltip("Replaced ground textures with scorch marks, this may have a small impact on performance!")]
    public bool replaceGroundTextureOnceBurnt = true;
    [SerializeField][Tooltip("The about of time taken before the next terrain update.")]
    private float terrainUpdateTime = 1.0f;
    [Tooltip("Use as many terrain grass texture details as possible, this may have an impact on performance!")]
    public bool maxGrassDetails = false;
    [Tooltip("Which index of the grass detail texture is the burnt grass, only used if 'Max Grass Details' is enabled.")]
    public int burntGrassDetailIndex = 1;
    private float terrainUpdateTimer = 0.0f; // update timer
    public List<int[,]> terrainMaps;
    private List<int[,]> terrainMapsOriginal;
    public int[,] terrainMap;                // Terrain alphamap
    private int[,] terrainMapOriginal;        // Terrain alphamap original
    private int[,] terrainReplaceMap;         // used for grass and removing grass (normal)
    private int[,] terrainReplaceMapOriginal; // used for grass and removing grass (normal)
    private float[,,] terrainTexture;         // used for replacing terrain textures
    private float[,,] terrainTextureOriginal; // used for replacing terrain textures
    public float terrainDetailSize;
    private int terrainDetailWidth;
    private int terrainDetailHeight;
    private int terrainAlphaWidth;
    private int terrainAlphaHeight;
    public bool dirty = false;

    //private SimulationSettings settings;

    public int[,] terrainReplacementMap
    {
        get { return terrainReplaceMap; }
        set { terrainReplaceMap = value; }
    }
    public float[,,] terrainAlpha
    {
        get { return terrainTexture; }
        set { terrainTexture = value; }
    }

    public int terrainWidth { get { return terrainDetailWidth; } }
    public int terrainHeight { get { return terrainDetailHeight; } }
    public int alphaWidth { get { return terrainAlphaWidth; } }
    public int alphaHeight { get { return terrainAlphaHeight; } }
    #endregion

    #region Initialization
    private void Awake()
    {
        //terrain = GetComponentInParent<Terrain>();
        Assert.IsNotNull(terrain);
    }

    /// <summary>
    /// Initialize this instance.
    /// </summary>
    public void Initialize(GameObjectPool newPooler, GameObject newFirePrefab, Vector3 ignitionPos, Vector3 offset, List<FireDataFrame> fireDataFrames, LandscapeController newLandscapeController, bool dataControlled, bool immediateFire, bool newWebOptimized)
    {
        //terrain = GetComponentInParent<Terrain>();
        Assert.IsNotNull(terrain);

        webOptimized = newWebOptimized;
        pooler = newPooler;
        firePrefab = newFirePrefab;

        if (maxCombustionRate < 1.0f)
            maxCombustionRate = 1.0f;

        // Get the terrain, need to be a child of a Terrain GameObject
        Assert.IsNotNull(terrain);

        if (terrain != null)
        {
            terrainDetailWidth = terrain.terrainData.detailWidth;
            terrainDetailHeight = terrain.terrainData.detailHeight;
            terrainAlphaWidth = terrain.terrainData.alphamapWidth;
            terrainAlphaHeight = terrain.terrainData.alphamapHeight;

            // Use the arrays or the lists
            if (!maxGrassDetails)
            {
                terrainMap = terrain.terrainData.GetDetailLayer(0, 0, terrainDetailWidth, terrainDetailHeight, 0);
                terrainReplaceMap = terrain.terrainData.GetDetailLayer(0, 0, terrainDetailWidth, terrainDetailHeight, 1);       // -- OBSOLETE?
                terrainMapOriginal = (int[,])terrainMap.Clone(); // performs a deep copy, Clone by itself performs a shallow copy (i.e. 2nd array has references to the 1st array)
                terrainReplaceMapOriginal = (int[,])terrainReplaceMap.Clone();                                                      // -- OBSOLETE?
            }
            else
            {
                // Make sure a valid index was set
                if (burntGrassDetailIndex >= terrain.terrainData.detailPrototypes.Length || burntGrassDetailIndex < 0)
                {
                    burntGrassDetailIndex = 0;
                    Debug.Log("Burnt Grass Texture Index is higher/lower then the number of grass texture details set, setting to 0");
                }

                // Set up Lists
                terrainMaps = new List<int[,]>();
                terrainMapsOriginal = new List<int[,]>();
                for (int i = 0; i < terrain.terrainData.detailPrototypes.Length; i++)
                {
                    terrainMaps.Add(terrain.terrainData.GetDetailLayer(0, 0, terrainDetailWidth, terrainDetailHeight, i));
                    terrainMapsOriginal.Add(terrain.terrainData.GetDetailLayer(0, 0, terrainDetailWidth, terrainDetailHeight, i));
                }
            }

            // Get the current terrain textures
            terrainTexture = terrain.terrainData.GetAlphamaps(0, 0, terrainAlphaWidth, terrainAlphaHeight);
            terrainTextureOriginal = (float[,,])terrainTexture.Clone();

            Assert.IsNotNull(terrainTexture);

            int TerrainDetailMapSize = terrain.terrainData.detailResolution;
            if (terrain.terrainData.size.x != terrain.terrainData.size.z)
            {
                Debug.Log("X and Y size of terrain have to be the same.");
                return;
            }

            // Need to have at least one terrain texture defined
            if (terrainTextures.Length != terrainAlpha.GetLength(2))
            {
                Debug.LogError("A different number of Terrain Textures are set in Fire Manager compared with the Terrain... terrainTextures.Length:"+ terrainTextures.Length+ " terrainAlpha.GetLength(2):"+ terrainAlpha.GetLength(2));
            }

            terrainDetailSize = TerrainDetailMapSize / terrain.terrainData.size.x;

            if (cellFireSpawnPositions.Length == 0)
                cellFireSpawnPositions = new Vector2[1] { new Vector2(0.5f, 0.5f) };
        }
        else
        {
            Debug.LogError("Terrain not found! A Fire Manager should be a child of a Terrain GameObject.");
        }

        if (gridWidth < 0)
            gridWidth = -gridWidth;
        if (gridHeight < 0)
            gridHeight = -gridHeight;

        if (gridWidth == 0)
            gridWidth = 1;
        if (gridHeight == 0)
            gridHeight = 1;

        if(dataControlled && fireDataFrames != null)
        {
            fireGrids = new SERI_FireGrid[fireDataFrames.Count];

            Debug.Log(name+ ".Initialize()... Creating fire grids:  fireDataFrames.Count:"+ fireDataFrames.Count);

            int count = 0;
            foreach (FireDataFrame fdf in fireDataFrames)
            {
                Assert.IsNotNull(fdf);
                Assert.IsNotNull(fdf.GetDataList());
                Assert.IsNotNull(fdf.GetDataGrid());

                GameObject fireGridObj = new GameObject();
                fireGridObj.name = "FireGrid_"+count;
                fireGridObj.transform.parent = transform.parent;                   // Set parent

                SERI_FireGrid fireGrid = fireGridObj.AddComponent<SERI_FireGrid>();

                Vector3 pos = new Vector3(ignitionPos.x, ignitionPos.y, ignitionPos.z);
                pos.x += offset.x;
                pos.y += terrain.transform.position.y;
                pos.z += offset.z;

                fireGrid.Initialize(this, firePrefab, pos, gridWidth, gridHeight, pooler, fdf.GetDataList(), fdf.GetDataGrid(), newLandscapeController, true, false);
                fireGrids[count] = fireGrid;

                //Debug.Log(name + ".Initialize()... grid #" + count);

                count++;
            }
        }
        else
        {
            fireGrids = new SERI_FireGrid[1];

            GameObject fireGridObj = new GameObject();
            fireGridObj.name = "FireGrid";
            fireGridObj.transform.parent = transform.parent;                   // Set parent

            SERI_FireGrid fireGrid = fireGridObj.AddComponent<SERI_FireGrid>();

            Vector3 pos = new Vector3(ignitionPos.x, ignitionPos.y, ignitionPos.z);
            pos.x += offset.x;
            pos.y += terrain.transform.position.y;
            pos.z += offset.z;

            fireGrid.Initialize(this, firePrefab, pos, gridWidth, gridHeight, pooler, null, null, newLandscapeController, false, immediateFire);

            //if(debug)
            //    Debug.Log(name + ".Initialize()... grid #0");

            fireGrids[0] = fireGrid;
        }

        //initialized = true;
        gridIdx = 0;
    }

    /// <summary>
    /// Set fire prefab
    /// </summary>
    /// <param name="newFirePrefab">New fire prefab</param>
    public void SetFirePrefab(GameObject newFirePrefab)
    {
        firePrefab = newFirePrefab;
    }

    /// <summary>
    /// Set fire grid
    /// </summary>
    /// <param name="newFireIdx">New fire index</param>
    private void SetFireGrid(int newFireIdx)
    {
        gridIdx = newFireIdx;
    }
    #endregion

    #region UpdateMethods
    /// <summary>
    /// Update this instance.
    /// </summary>
    public void Update()
    {
        if (burning)
        {
            CurrentFireGrid().UpdateGrid();
            //Debug.Log("FireManager.Update()...");
        }
	}
    #endregion

    #region Ignition
    /// <summary>
    /// Ignites the terrain.
    /// </summary>
    /// <param name="terrain">Terrain</param>
    /// <param name="timeStep">Time step</param>
    /// <param name="fireLengthInSec">Fire length in seconds</param>
    /// <param name="fireIdx">Fire index</param>
    public void IgniteTerrain(Terrain terrain, int timeStep, float fireLengthInSec, int fireIdx)
    {
        //if (webOptimized)
        //{
        //    // TO DO
        //}
        //else
        //{
            SetFireGrid(fireIdx);
            CurrentFireGrid().Ignite(new Vector3(0,0,0), timeStep, fireLengthInSec);
        //}
        StartBurning();

        StartCoroutine(WaitToStopBurning(fireLengthInSec)); // Added 12/24/24 to fix bug in SBS cube where fire keeps going
    }

    private void StartBurning()
    {
        burning = true;
    }

    public void StopBurning()
    {
        burning = false;
    }
    private void StopBurningInSec(float time)
    {
        StartCoroutine(WaitToStopBurning(time));
    }

    private IEnumerator WaitToStopBurning(float time)
    {
        yield return new WaitForSeconds(time);
        burning = false;
    }

    public void StopAllGridFires()
    {
        StopBurningInSec(2f);
        foreach (var grid in fireGrids)
        {
            StartCoroutine(grid.WaitToStopAllFires(2f));
        }
    }
    #endregion

    #region Grid
    /// <summary>
    /// Gets current fire grid
    /// </summary>
    /// <returns></returns>
    private SERI_FireGrid CurrentFireGrid()
    {
        if (gridIdx >= 0 && gridIdx < fireGrids.Length)
            return fireGrids[gridIdx];
        else
        {
            Debug.Log(name + ".CurrentFireGrid()... ERROR no gridIdx:" + gridIdx + " fireGrids.Length:" + fireGrids.Length);
            return fireGrids[0];
        }
    }

    /// <summary>
    /// Get current fire grid
    /// </summary>
    /// <returns></returns>
    public SERI_FireGrid GetCurrentFireGrid()
    {
        return CurrentFireGrid();
    }

    /// <summary>
    /// Get fire grid at index
    /// </summary>
    /// <param name="idx"></param>
    /// <returns></returns>
    public SERI_FireGrid GetFireGrid(int idx)
    {
        if(idx >= 0 && idx < fireGrids.Length)
            return fireGrids[idx];
        else
            return null;
    }

    public int GetGridHeight()
    {
        return gridHeight;
    }

    public int GetGridWidth()
    {
        return gridWidth;
    }
    #endregion

    #region Resetting
    /// <summary>
    /// Reset fire manager
    /// </summary>
    public void Reset()
    {
        foreach (SERI_FireGrid grid in fireGrids)
        {
            if (grid.ignited)
                grid.StopBurning(true);

            grid.DestroyGrid();
        }

        gridIdx = 0;
    }
    #endregion

    #region Termination
    /// <summary>
    /// When the application to closed, needs to reset the terrain data to the original data
    /// </summary>
    void OnApplicationQuit()
    {
        if (terrain != null)
        {
            if (!maxGrassDetails)
            {
                terrain.terrainData.SetDetailLayer(0, 0, 0, terrainMapOriginal);
                terrain.terrainData.SetDetailLayer(0, 0, 1, terrainReplaceMapOriginal);
            }
            else
            {
                for (int i = 0; i < terrain.terrainData.detailPrototypes.Length; i++)
                {
                    terrain.terrainData.SetDetailLayer(0, 0, i, terrainMapsOriginal[i]);
                }
            }

            terrain.terrainData.SetAlphamaps(0, 0, terrainTextureOriginal);
        }
    }
    #endregion
}