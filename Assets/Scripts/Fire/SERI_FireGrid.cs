/* Adapted from FireGrid.cs
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
/// Fire grid class.
/// </summary>
public class SERI_FireGrid : MonoBehaviour
{
    // Debugging
    private bool debug = false;
    float fireLength = 0f;          // Debugging

    #region Fields
    // States
    public bool initialized = false;
    public bool ignited = false;

    // Settings
    private float fireSizeFactor = 5f;
    private float frameSlowdownFactor = 0.25f;                  // -- Temp. hack to account for slowdown when many fires instantiated
    private float fireGridDestroyWaitTime = 0.15f;
    public bool waitingToDeactivate = false;

    // Classes
    public LandscapeController landscapeController;

    // Variables
    private bool immediateFire = false;                         // Immediate fire
    private bool startAtCenter = false;                         // Start at center flag
    private bool dataControlled = false;                        // Data controlled fire

    private Vector2 startPoint;                                 // Fire start point

    List<SERI_FireCell> fireCellsList = new List<SERI_FireCell>();
    List<FireDataPoint> activePointsList;
    FireDataPointCollection[,] activePointsGrid;                // Used in data-controlled fire

    /* Pooling */
    private GameObjectPool pooler;

    [SerializeField]
    [Tooltip("Prefab to be used for the fire.")]
    private GameObject firePrefab;
    private SERI_FireManager fireManager;
    //private WindZone windZone;
    private Terrain terrain;

    private GameObject[,] fireGrid;
    private Vector3[,] fireGridPositions;
    private SERI_FireCell[,] fireCells;

    private SortedList<int, Vector2> burningCells;
    private Vector3 origin;                                   // Terrain world origin
    private string terrainName;
    private float cellSize;
    private int allocatedListSize;
    private int gridWidth;
    private int gridHeight;
    public bool fireStarted = false;
    [SerializeField]
    private bool gridCreated = false;
    #endregion

    #region Initialization
    /// <summary>
    /// Initialize fire grid
    /// </summary>
    /// <param name="newFirePrefab">The prefab that should be used to create fires</param>
    /// <param name="position">Center of the grid</param>
    /// <param name="gridWidth">Width of the grid</param>
    /// <param name="gridHeight">Height of the grid</param>
    /// <param name="newPooler">Pooler object</param>
    public void Initialize(SERI_FireManager newFireManager, GameObject newFirePrefab, Vector3 position, int newGridWidth, int newGridHeight, GameObjectPool newPooler, List<FireDataPoint> newActivePoints, FireDataPointCollection[,] newActivePointsGrid, LandscapeController newLandscapeController, bool newDataControlled, bool newImmediate)
    {
        fireManager = newFireManager;
        immediateFire = newImmediate;
        dataControlled = newDataControlled;

        activePointsList = newActivePoints;
        activePointsGrid = newActivePointsGrid;

        if (!pooler)
            pooler = newPooler;

        transform.position = position;

        gridWidth = newGridWidth;
        gridHeight = newGridHeight;
        firePrefab = newFirePrefab;

        Assert.IsNotNull(fireManager);

        if (fireManager != null)
        {
            terrain = fireManager.terrain;
            cellSize = fireManager.cellSize;

            allocatedListSize = fireManager.preAllocatedFireIndexSize;
            terrainName = fireManager.terrain.name;

            if (terrain != null)
            {
                origin = transform.position;

                if (dataControlled && !immediateFire)
                {
                    startPoint = activePointsList[0].GetGridPosition();
                }
                else
                {
                    if (startAtCenter)
                        startPoint = new Vector2((float)gridWidth / 2.0f, (float)gridHeight / 2.0f);    // Start at center
                    else
                        startPoint = new Vector2((float)gridWidth - 1, (float)gridHeight - 1);          // Start at edge
                }
                if (activePointsList == null)                // Non-data-controlled fire
                {
                    CreateGrid(null);
                }
                else                                     // Data-controlled fire
                {
                    CreateGrid(activePointsGrid);
                }

                landscapeController = newLandscapeController;
                ignited = true;
            }
            else
            {
                Debug.LogError("Not a child of a Terrain GameObject!");
            }
        }
        else
        {
            Debug.LogWarning("No FireManager found in the scene!");
        }

        if (debug)
            Debug.Log(transform.parent.name + "." + name + ".Initialize()... Time:"+Time.time);

        initialized = true;
    }

    /// <summary>
    /// Build a grid in a single frame
    /// </summary>
    /// <param name="gridActivePoints">Active points in fire</param>
    /// <param name="fuelAmount">Fuel amount for all cells</param>
    /// <param name="combustionRate">Combustion rate for all cells</param>
    /// <param name="fireLengthInSec">Fire length in seconds</param>
    private void CreateGrid(FireDataPointCollection[,] gridActivePoints)//, float fuelAmount, float combustionRate, float fireLengthInSec)
    {
        burningCells = new SortedList<int, Vector2>(allocatedListSize);

        float offsetX = 0.0f;
        float offsetY = 0.0f;

        if (gridWidth % 2 == 0)
            offsetX = (gridWidth / 2.0f) * cellSize;
        else if (gridWidth % 2 == 1)
            offsetX = ((gridWidth - 1) / 2.0f) * cellSize;

        if (gridHeight % 2 == 0)
            offsetY = (gridHeight / 2.0f) * cellSize - cellSize * .5f;
        else if (gridHeight % 2 == 1)
            offsetY = ((gridHeight - 1) / 2.0f) * cellSize - cellSize * .5f;

        fireGrid = new GameObject[gridWidth, gridHeight];
        fireCells = new SERI_FireCell[gridWidth, gridHeight];

        GameObject tmp = new GameObject();
        tmp.AddComponent<SERI_FireCell>();
        Quaternion quat = new Quaternion();

        if (debug)
            Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".CreateGrid()... Creating cells ... dataControlled:" + dataControlled + " immediateFire:" + immediateFire);

        fireCellsList = new List<SERI_FireCell>();

        int cellBurnCount = 0;
        int count = 0;

        //Vector2 gridPosition;
        Vector3 worldPosition;
        Vector2 index;

        /* Find and initialize cells to burn */
        for (int x = 0; x < gridWidth; x++)        // Create the cells in the grid
        {
            for (int y = 0; y < gridHeight; y++)
            {
                //gridPosition = new Vector2(x, y);
                index = new Vector2((transform.position.x - offsetX) + (x * cellSize), (transform.position.z - offsetY) + (y * cellSize));
                worldPosition = GridToWorldPosition(index);
                worldPosition.y += terrain.SampleHeight(worldPosition) + 0.001f;

                fireGrid[x, y] = (GameObject)Instantiate(tmp, worldPosition, quat, transform);   // Instantiate cell
                if (fireGrid[x, y] != null)
                {
                    fireGrid[x, y].transform.position = worldPosition;
                    fireGrid[x, y].transform.rotation = quat;
                    fireGrid[x, y].transform.parent = transform;
                }
                else
                {
                    Debug.Log("Cell " + fireGrid[x, y] + " is null");
                }

                fireGrid[x, y].name = "FireCell " + count;

                SERI_FireCell cell = fireGrid[x, y].GetComponent<SERI_FireCell>();
                cell.gridLocation = new Vector2(x, y);                                      // Save grid location
                fireCells[x, y] = cell;

                try
                {
                    cell.SetupCell(firePrefab, cellSize, fireManager.maxCombustionRate, terrainName, fireManager.cellFireSpawnPositions);
                }
                catch (System.Exception e)
                {
                    Debug.Log("Exception e:" + e);
                }

                if (immediateFire)                                                      // Ignite cells immediately
                {
                    //bool ignite = true;
                    //if (dataControlled)                                                 // Only true for large landscape fires
                    //{
                    //    //foreach (FireDataPoint point in gridActivePoints[x, y].GetPoints())    
                    //    //{
                    //    //    ignite = true;                     
                    //    //    break;
                    //    //}

                    //    if (gridActivePoints[x, y].GetPoints().Count > 0)
                    //    {
                    //        ignite = true;
                    //        break;
                    //    }
                    //}

                    //if (ignite)
                    //{
                        cell.SetFireSize(1f);
                        fireCellsList.Add(cell);
                        cellBurnCount++;
                    //}
                }
                else
                {
                    if (dataControlled)                                                     // Always true for large landscape fires
                    {
                        //List<int> patchIDList = new List<int>();
                        float avgFireSize = 0f;
                        float avgIter = 0f;

                        if (gridActivePoints[x, y] == null)
                        {
                            Debug.Log("ERROR: x:" + x + " y:" + y + " activePointsList[x,y] == null! Time:" + Time.time);
                            continue;
                        }
                        if (gridActivePoints[x, y].GetPoints() == null)
                        {
                            Debug.Log("ERROR: x:" + x + " y:" + y + " activePointsList[x, y].GetPoints() == null!  Time:" + Time.time);
                            continue;
                        }

                        List<FireDataPoint> ptList = gridActivePoints[x, y].GetPoints();
                        foreach (FireDataPoint point in ptList)
                        {
                            if (point != null)
                            {
                                //patchIDList.Add(point.GetPatchID());
                                float fireSize = point.GetSpread() * fireSizeFactor;
                                float iter = point.GetIter();
                                avgFireSize += fireSize;
                                avgIter += iter;
                            }
                        }

                        avgFireSize /= ptList.Count;
                        avgIter /= ptList.Count;

                        cell.SetFireSize(avgFireSize);                                      // Set fire size based on spread data
                        cell.SetIter(avgIter);

                        //cell.SetPatchIDList(patchIDList);

                        fireCellsList.Add(cell);
                        cellBurnCount++;
                    }
                    else
                    {
                        Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".CreateGrid()... Non-immediate non-data controlled fire!!");
                    }
                }

                count++;
            }
        }

        fireCellsList.Sort();
        if (debug)
            Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".CreateGrid()... Added fireCellsList.Count:" + fireCellsList.Count + " immediateFire:" + immediateFire + " dataControlled:" + dataControlled);

        DestroyImmediate(tmp);
        gridCreated = true;
    }

    /// <summary>
    /// Wait to burn cell coroutine
    /// </summary>
    /// <param name="cell"></param>
    /// <param name="waitSec"></param>
    /// <param name="size"></param>
    /// <param name="fireLengthInFrames"></param>
    /// <returns></returns>
    private IEnumerator WaitToBurnCell(SERI_FireCell cell, float waitSec, float fuelAmount, float combustionRate)
    {
        if (debug)
        {
            float cellBurnWaitTime = fireLength / fireCellsList.Count;
            int num = (int)(waitSec / cellBurnWaitTime);
            cell.SetID(num);
        }

        yield return new WaitForSeconds(waitSec);
        cell.Ignite(pooler, false, fuelAmount, combustionRate);
    }
    #endregion

    #region Ignition
    /// <summary>
    /// Ignite the fire.
    /// </summary>
    /// <param name="newOffsetPos">New offset position.</param>
    /// <param name="timeStep">Simulation time step.</param>
    /// <param name="fireLengthInSec">Frame length of fire.</param>
    public void Ignite(Vector3 newOffsetPos, int timeStep, float fireLengthInSec)
    {
        if (fireManager != null)
        {
            terrain = fireManager.terrain;
            cellSize = fireManager.cellSize;

            allocatedListSize = fireManager.preAllocatedFireIndexSize;
            terrainName = fireManager.terrain.name;

            if (terrain != null)
            {
                origin = transform.position;

                int fireLengthInFrames = (int)(fireLengthInSec * 30f * frameSlowdownFactor);     // Calculate fire length in frames  -- TO DO: Improve frame rate calculation

                float combustionRate = fireManager.maxCombustionRate / fireLengthInFrames;       // Find combustion rate from fire frame length

                if (activePointsList == null)               // Non-data-controlled fire
                {
                    if (debug)
                        Debug.Log(name + ".Ignite()... parent:" + transform.parent.name + " IMMEDIATE  fireLengthInFrames:" + fireLengthInFrames + " fireLengthInSec:" + fireLengthInSec + " combustionRate:" + combustionRate);
                    IgniteGrid(fireManager.maxCombustionRate, combustionRate, fireLengthInSec);
                }
                else                                     // Data-controlled fire
                {
                    if (debug)
                        Debug.Log(name + ".Ignite()...   SPREAD fireLengthInFrames:" + fireLengthInFrames + " fireLengthInSec:" + fireLengthInSec + "   combustionRate:" + combustionRate + " activePointsList.Count:" + activePointsList.Count);
                    IgniteGrid(fireManager.maxCombustionRate, combustionRate, fireLengthInSec);
                }

                ignited = true;
            }
            else
            {
                Debug.LogError("Not a child of a Terrain GameObject!");
            }
        }
        else
        {
            Debug.LogWarning("No FireManager found in the scene!");
        }
    }

    /// <summary>
    /// Ignite grid 
    /// </summary>
    /// <param name = "activePoints" > Active points in fire</param>
    /// <param name="fuelAmount">Fuel amount for all cells</param>
    /// <param name="combustionRate">Combustion rate for all cells</param>
    /// <param name="fireLengthInSec">Fire length in seconds</param>
    private void IgniteGrid(float fuelAmount, float combustionRate, float fireLengthInSec)
    {
        fireLength = fireLengthInSec;

        /* Burn cells */
        float cellBurnWaitTime = fireLengthInSec / fireCellsList.Count;     // Calculate length in sec. each cell should wait to burn before the next
        int count = 0;

        if(debug)
            Debug.Log(transform.parent.name + "." + name + ".IgniteGrid()... Time:"+Time.time);

        foreach (SERI_FireCell cell in fireCellsList)
        {
            if (immediateFire)
            {
                //if (debug && count % 10 == 0)
                //    Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".IgniteGrid()... immediateFire   Will ignite cell:" + cell + " fuelAmount:" + fuelAmount + " combustionRate:" + combustionRate + " activeCells.Count:" + fireCellsList.Count);

                cell.Ignite(pooler, false, fuelAmount, combustionRate);
            }
            else
            {
                if (dataControlled)
                {
                    StartCoroutine(WaitToBurnCell(cell, cellBurnWaitTime * count, fuelAmount, combustionRate));
                    landscapeController.AddBurnedCellAfterTime(cell, cellBurnWaitTime * count);

                    //if (debug && count % 100 == 0)
                    //    Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".IgniteGrid()... Will ignite cell:" + cell + " after " + (cellBurnWaitTime * count) + " sec.. cellBurnWaitTime:" + cellBurnWaitTime + "  fuelAmount:" + fuelAmount + " combustionRate:" + combustionRate + " activeCells.Count:" + fireCellsList.Count);
                }
                else
                    Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".IgniteGrid()... Non-immediate non-data controlled fire!!");
            }
            count++;
        }

        //gridIgnited = true;
    }

    /// <summary>
    /// Stop burning and return fire cells to grid
    /// </summary>
    public void StopBurning(bool immediate)
    {
        Debug.Log(transform.parent.name + "." + name + ".StopBurning()... Time: " + Time.time);

        ResetCellsAfterFire();
        fireManager.StopBurning();

        if (gameObject.activeInHierarchy)
            StartCoroutine(WaitToDeactivate(immediate ? 0f : fireGridDestroyWaitTime));
        else
            Deactivate();
    }


    #endregion

    #region Resetting
    /// <summary>
    /// Reset cells after fire
    /// </summary>
    private void ResetCellsAfterFire()
    {
        if (debug)
            Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".ResetCellsAfterFire()...  will reset cells in grid... time:" + Time.time);     // -- KEEPS GETTING CALLED

        if (fireGrid != null)
        {
            List<SERI_FireCell> resetList = new List<SERI_FireCell>();
            for (int x = 0; x < fireGrid.GetLength(0); x++)
            {
                for (int y = 0; y < fireGrid.GetLength(1); y++)
                {
                    SERI_FireCell cell = fireCells[x, y];
                    if (!cell.setToDelete)
                    {
                        if (!cell.gameObject.activeInHierarchy)
                            cell.gameObject.SetActive(true);
                        resetList.Add(cell);
                    }
                }
            }

            foreach (SERI_FireCell cell in resetList)
            {
                cell.ResetCell();
                //cell.DeleteCellAfterTime(0f);
            }
        }

        //if (debug)
        //    Debug.Log(name + ".DeleteCellsAfterFire()... parent: " + transform.parent.name + " Will destroy grid after 0.5 sec   Time:" + Time.time);
    }
    #endregion

    #region UpdateMethods
    /// <summary>
    /// Update this instance.
    /// </summary>
    //void Update()
    public bool UpdateGrid()
    {
        if (ignited && !waitingToDeactivate)
        {
            if (fireManager != null && gridCreated)                       // Requires a valid fire manager
            {
                if (dataControlled && !fireStarted)                       // Run fire propagation based on landscape data (pIter and pSpread)
                {
                    fireGrid[(int)startPoint.x, (int)startPoint.y].GetComponent<SERI_FireCell>().Burn(pooler); // Start at start point

                    if (debug)
                        Debug.Log(transform.parent.transform.parent.transform.parent.name + "." + name + ".Update()... fireStarted:" + fireStarted + " ... time:" + Time.time);
                }

                fireStarted = true;
                UpdateFire();

                if (fireStarted && burningCells.Count == 0)      // Ensure grid is deleted after no more fires are currently lit
                {
                    StopBurning(false);
                    return false;
                }
            }
        }

        return true;
    }

    /// <summary>
    /// Updates the fire
    /// </summary>
    private void UpdateFire()
    {
        if (burningCells == null)                                    
        {
            burningCells = new SortedList<int, Vector2>();
            return;
        }

        int count = 0;
        for (int x = 0; x < gridWidth; x++)                                             // Keep within grid boundary for the next step
        {
            for (int y = 0; y < gridHeight; y++)
            {
                Vector2 indexVector = new Vector2(x, y);
                int index = count;
                bool contained = burningCells.ContainsKey(index);
                
                SERI_FireCell cell = fireCells[x, y];

                if (!contained && cell.fireInstantiated && !cell.extinguished)      // Add cell idx. to alight cells if fire instantiated
                    burningCells.Add(index, indexVector);
                else if (contained && cell.extinguished)                            // Remove cell idx. if fire extinguished
                    burningCells.Remove(index);

                count++;
            }
        }

        UpdateCombustion();
    }

    /// <summary>
    /// Run fire combustion
    /// </summary>
    private void UpdateCombustion()
    {
        int count = 0;
        foreach (Vector2 index in burningCells.Values)
        {
            int x = (int)index.x;
            int y = (int)index.y;

            fireCells[x, y].RunCombustion();
            count++;
        }
    }
    #endregion

    #region Termination
    /// <summary>
    /// Delete cell after delay time
    /// </summary>
    /// <param name="delay"></param>
    /// <returns></returns>
    IEnumerator WaitToDeactivate(float delay)
    {
        waitingToDeactivate = true;
        yield return new WaitForSeconds(delay);
        Deactivate();
    }

    /// <summary>
    /// Set inactive
    /// </summary>
    void Deactivate()
    {
        Debug.Log(transform.parent.name+"."+name + ".SetInactive()... Time: "+Time.time);
        waitingToDeactivate = false;
        fireStarted = false;
        ignited = false;
    }

    /// <summary>
    /// Destroys the fire grid
    /// </summary>
    public void DestroyGrid()
    {
        ReturnAllCellsToPool();
        Destroy(gameObject, 0.1f);
    }

    /// <summary>
    /// Return any fire particle systems to pool not already returned
    /// </summary>
    private void ReturnAllCellsToPool()
    {
        if (fireGrid != null)
        {
            for (int x = 0; x < fireGrid.GetLength(0); x++)
            {
                for (int y = 0; y < fireGrid.GetLength(1); y++)
                {
                    if(fireCells[x, y] != null)
                        fireCells[x, y].ResetCell();
                }
            }
        }
    }
    #endregion

    #region Terrain
    /// <summary>
    /// Gets the world position of the grid
    /// </summary>
    /// <param name="gridPosition">Grid position</param>
    /// <returns>Grid position in world coords</returns>
    public Vector3 GridToWorldPosition(Vector2 gridPosition)
    {
        Vector3 result = new Vector3(gridPosition.x, origin.y, gridPosition.y);
        return result;
    }

    /// <summary>
    /// Gets the grids' position in the world
    /// <param name="worldPosition">3D grid position in world</param>
    /// <returns>2D grid position (2D)</returns>
    /// </summary>
    public Vector2 WorldToGridPosition(Vector3 worldPosition)
    {
        return new Vector2(worldPosition.z / cellSize, worldPosition.x / cellSize);
    }

    /// <summary>
    /// Gets the terrain position.
    /// </summary>
    /// <returns>The terrain position.</returns>
    /// <param name="position">Position.</param>
    /// <param name="terrain">Terrain.</param>
    private Vector3 GetTerrainPosition(Vector3 position, Terrain terrain)
    {
        Vector3 adjusted = position - terrain.GetPosition();
        return adjusted;
    }
    #endregion
}
