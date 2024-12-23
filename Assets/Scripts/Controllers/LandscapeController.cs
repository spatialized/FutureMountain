using Assets.Scripts.Models;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Assets.Scripts.Models.Assets.Scripts.Models;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.Assertions;
using static TMPro.SpriteAssetUtilities.TexturePacker_JsonArray;

/// <summary>
/// Landscape controller.
/// </summary>
public class LandscapeController : MonoBehaviour
{
    /* Debugging */
    [Header("Debugging")]
    private bool debug = true;
    private bool debugFire = false;
    private bool debugDetailed = false;

    #region Fields
    /* Settings */
    private static bool landscapeSimulationOn = true;                // Landscape Simulation On / Off
    private static bool landscapeSimulationWeb = true;               // Optimized landscape simulation for web

    private bool loadFireDataFromFile = landscapeSimulationOn && !landscapeSimulationWeb;
    private bool loadPatchDataFromFile = landscapeSimulationOn && !landscapeSimulationWeb;
    private bool loadWaterDataFromFile = landscapeSimulationOn && !landscapeSimulationWeb;
    //private bool loadStreamflowFromFile = landscapeSimulationOn && !landscapeSimulationWeb;

    private int immediateFireTimeThreshold;
    //SimulationSettings settings;

    /* States */
    public bool initialized { get; set; } = false;            // Initialized flag
    public bool dataFormatted { get; set; } = false;          // Data formatted flag
    public bool setup { get; set; } = false;                  // Setup flag
    public bool pauseGameState { get; set; }                  // Pause game flag
    public bool unpauseGameState { get; set; }                // Unpause game flag
    public bool updateDate { get; set; }                      // Update date flag

    /* Pooling */
    private GameObjectPool pooler;                            // Pooler script

    /* Landscape */
    private Terrain terrain;                                   // Landscape Terrain
    private GameController.LandscapeData landscapeDataList;    // Data List
    float[,,] unburntSplatmap;                                 // Unburnt terrain splatmap data
    float[,,] burntSplatmap;                                   // Burnt terrain splatmap data
    bool[,] burnedAlphamapGrid;                                // Grid of boolean values representing burned alphamap grid cells 

    /* Fire */
    [Header("Fire")]
    [SerializeField]
    private bool terrainBurning = false;            // Cube terrain is currently burning
    private float burnedTerrainCellDelay = 0.25f;    // Time to wait for cell to burn before setting burnt texture
    [SerializeField]
    private bool recentFire = false;                // Recent fire happened (and still burning or regrowing vegetation)
    [SerializeField]
    private bool terrainBurnt = false;              // Burnt terrain flag

    //List<FireDataPoint>[] firePointLists = null;    // List of fire points for each fire date

    //private List<Dictionary<Vector3, List<int>>> patchesToBurnDictList;

    private Vector3[] fireDates;
    private SERI_FireManager fireManager;           // Fire Manager
    public GameObject firePrefab;                   // Ground fire prefab
    private int minFireFrameLength;                 // Minimum fire frame length

    private Dictionary<Vector3, List<int>> patchesToBurnDict;

    public int fireRegrowthLength = 200;       // Frames to regrow grass
    //private float fireStartTime = -1f;    // Fire start time

    private int fireRegrowthStartTimeIdx;           // Time idx when last fire ended
    private List<SERI_FireCell> activeBurnCells;    // Active burning / burned cells

    private Vector3 fireGridCenterLocation = new Vector3(250f, 0f, 250f);             // Fire grid center location
    private int fireGridCols;                       // Fire grid column count
    private int fireGridRows;                       // Fire grid row count

    /* River */
    [Header("River")]
    public GameObject riverObject;                  // River object
    public GameObject riverFaceObject;              // River face object
    public GameObject[] tributarySplines;           // River tributary spline array 
    private float StreamflowLevel;                  // Current river height (Streamflow gauge level)
    public float riverFullHeight;                   // Height (transform.localPosition.y) of river spline at full water level
    public float riverMinHeight;                    // Height (transform.localPosition.y) of river spline at min. water level
    public float riverFaceMinHeight;                // Height (transform.localPosition.y) of river face at full water level
    public float riverFaceFullHeight;               // Height (transform.localPosition.y) of river face at full water level
    public float riverFaceMinScale;                 // Scale (transform.localScale.y) of river spline at full water level
    public float riverFaceFullScale;                // Scale (transform.localScale.y) of river spline at full water level 
    private float RiverLevelMin = 100000f;          // Min. river level in current data file
    private float RiverLevelMax = -100000f;         // Max. river level in current data file

    // Desktop
    private float[,] waterDataArray;                // Water data array
    private List<WaterDataYear> waterData;          // List of formatted water data by warming idx.

    /* Snow */
    [Header("Snow")]
    [Range(0f, 2000f)]
    public float snowWeightFactor = 250f;
    private float backgroundSnowFactor = 12500f; //= 10000f;    // Background snow amount visualization factor
    private SnowManager snowManagerBkgd;                // Background mountains snow manager
    private SnowManager snowManager;                // Background mountains snow manager
    private float averageSnowAmount = 0f;               // Average snow amount for current frame
    private float snowWeightMax = 1f;               // Amount above which full snow is shown

    /* Rain */
    private float Precipitation;                    // Current precipitation

    /* Visualization Settings */
    private int currentTimeIdx = 0;                    // Current time index
    private bool gridMode = false;                     // Show patch grid

    /* Visualization Parameters */
    private float plantCarbon;                         // Plant carbon amount
    private float PlantCarbonMin, PlantCarbonMax;
    private float snowAmount;                          // Current snow amount in shader
    private float SnowAmountMax;                       // Max. snow amount in shader
    private float AvgSnowAmountMin = 0f;               // Min. and max. avg. snow amounts in data
    private float AvgSnowAmountMax;                    // Min. and max. avg. snow amounts in data

    /* Data */
    private int warmingIdx = 0;                        // Warming index for current simulation run

    /* Data -- Desktop Version */
    private TextAsset dataFile;                        // Data file as TextAsset ( from GameController in ProcessDataFile() )
    private TerrainSimulationData[] simulationData;    // Terrain data from patch extents file          -- Desktop Version
    private TerrainSimulationData currentSimulationData;    // Terrain data from patch extents file     -- Web Version
    private List<PatchDataYear[]> patchesData;         // List of patch data arrays ordered by warming index
    private PatchDataMonth currentPatchData;           // Current patch data frame
    private PatchDataMonth nextPatchData;              // Next patch data frame
    private WaterDataFrame currentWaterData;                    // Current water data frame
    private Dictionary<int, PatchPointCollection> patchExtents; // Extents (bounds) of each patch in simulation

    public int simulationStartYear, simulationStartMonth, simulationStartDay = 1;    // Start year, month, day of extents / streamflow data, whichever begins later
    public int extentsStartYear, waterStartYear;                // Start year for water and extents data

    private int lastFrameDay, lastFrameMonth, lastFrameYear;    // Day, month and year of last data frame
    private int nextFrameDay, nextFrameMonth, nextFrameYear;    // Day, month and year next in dataset

    private int patchDataLength;                 // Data file line count
    private int patchDataCols;                   // Patch data column count
    private int patchDataRows;                   // Patch data row count
    private int streamflowDataLength;            // Streamflow line count
    private int streamflowDataCols;              // Streamflow column count
    private int streamflowDataRows;              // Streamflow row count

    /* Data -- Web Version */
    // -- TO DO

    /* Dimensions */
    private float northEdge;                     // Patch file North boundary
    private float southEdge;                     // Patch file South boundary
    private float eastEdge;                      // Patch file East boundary
    private float westEdge;                      // Patch file West boundary
    #endregion

    #region DataTypes
    /// <summary>
    /// Landscape patch data parameter columns used in simulation
    /// </summary>
    private enum PatchDataColumnIdx
    {
        Month = 0,
        Year = 1,
        PatchID = 2,
        Snow = 3,
        Carbon = 4,
        Spread = 5,
        Iter = 6
    };

    /// <summary>
    /// Landscape data parameter columns used in simulation
    /// </summary>
    private enum WaterDataColumnIdx
    {
        Day = 0,
        Month = 1,
        Year = 2,
        Date = 3,
        WY = 4,
        Precip = 5,
        QBase = 6,
        QWarm1 = 7,
        QWarm2 = 8,
        QWarm4 = 9,
        QWarm6 = 10
    };
    #endregion

    #region UpdateMethods
    /// <summary>
    /// Updates vegetation growth simulation.
    /// </summary>
    /// <param name="curTimeIdx">Current time index.</param>
    /// <param name="curYear">Current year.</param>
    /// <param name="curMonth">Current month.</param>
    /// <param name="curDay">Current day.</param>
    /// <param name="timeStep">Time step.</param>>
    public void UpdateLandscape(int curTimeIdx, int curYear, int curMonth, int curDay, int timeStep, bool pausedDuringFire)  // Update cube simulation
    {
        currentTimeIdx = curTimeIdx;

        if (landscapeSimulationOn)
        {
            //if (waterData != null)
            //{
            //    if (!landscapeSimulationWeb && patchesData == null)
            //    {
            //        Debug.Log(name + ".UpdateLandscape()... ERROR: Turning off landscape simulation... patchData == null:" + (patchesData == null) + " waterData == null: " + (waterData == null) + " curYear:" + curYear + " curMonth:" + " curDay:" + curDay + " dataFormatted:" + dataFormatted);
            //        return;
            //    }

            //    if (!pausedDuringFire)
            //        UpdateData(curTimeIdx, curYear, curMonth, curDay, timeStep);

            //    UpdateTerrain(curYear, curMonth, curDay, timeStep);

            //    if (!pausedDuringFire)
            //        UpdateRiver(curYear, curMonth, curDay, timeStep);
            //}
            //else
            //{
            //    Debug.Log(name + ".UpdateLandscape()... ERROR: Turning off landscape simulation... patchData == null:" + (patchesData == null) + " waterData == null: " + (waterData == null) + " curYear:" + curYear + " curMonth:" + " curDay:" + curDay + " dataFormatted:" + dataFormatted);
            //    landscapeSimulationOn = false;
            //}

            if (!landscapeSimulationWeb && patchesData == null)
            {
                Debug.Log(name + ".UpdateLandscape()... ERROR: Turning off landscape simulation... patchData == null:" + (patchesData == null) + " waterData == null: " + (waterData == null) + " curYear:" + curYear + " curMonth:" + " curDay:" + curDay + " dataFormatted:" + dataFormatted);
                return;
            }
            if (!landscapeSimulationWeb && waterData == null)
            {
                Debug.Log(name + ".UpdateLandscape()... ERROR: Turning off landscape simulation... patchData == null:" + (patchesData == null) + " waterData == null: " + (waterData == null) + " curYear:" + curYear + " curMonth:" + " curDay:" + curDay + " dataFormatted:" + dataFormatted);
                return;
            }

            if (!pausedDuringFire)
                UpdateData(curTimeIdx, curYear, curMonth, curDay, timeStep);

            UpdateTerrain(curYear, curMonth, curDay, timeStep);

            if (!pausedDuringFire)
                UpdateRiver(curYear, curMonth, curDay, timeStep);
        }
        //else
        //{
        //    UpdateTerrainTest(curYear, curMonth, curDay, timeStep);  // Testing
        //}
    }

    /// <summary>
    /// Update fire simulation
    /// </summary>
    /// <param name="timeStep"></param>
    public void UpdateFire(int timeStep)
    {
        if (terrainBurning)
        {
            if (!StillBurning())
            {
                if (debugFire)
                    Debug.Log(name + " Stopped burning...");

                fireRegrowthStartTimeIdx = currentTimeIdx;                  // Time idx when last fire ended
                terrainBurning = false;
                terrainBurnt = true;

                fireManager.StopAllGridFires();
            }
        }
    }

    /// <summary>
    /// Update data from model output for current time
    /// </summary>
    /// <param name="curTimeIdx">Current time step.</param>
    /// <param name="curFrameYear">Current year.</param>
    /// <param name="curFrameMonth">Current month.</param>
    /// <param name="curFrameDay">Current day.</param>
    /// <param name="timeStep">Time step.</param>
    private void UpdateData(int curTimeIdx, int curFrameYear, int curFrameMonth, int curFrameDay, int timeStep)
    {
        if (debug && debugDetailed)
            Debug.Log(transform.parent.name + " LandscapeController.UpdateCurrentData()... curFrameYear:" + curFrameYear + " curFrameMonth:" + curFrameMonth + " startYear:" + simulationStartYear);

        if (curFrameYear != lastFrameYear || curFrameMonth != lastFrameMonth || curFrameDay != lastFrameDay)        // Update data if moved to new day
        {
            if (landscapeSimulationWeb)
            {
                WebManager.Instance.RequestWaterData(curTimeIdx + 1, this.FinishUpdateWaterDataFromWeb);
            }
            else
            {
                int patchIdx = curFrameYear - extentsStartYear;
                if (patchIdx >= 0 && patchIdx < patchesData[warmingIdx].Length) // Check if year is in patch data range
                {
                    PatchDataYear patchYear = patchesData[warmingIdx][patchIdx];
                    currentPatchData = patchYear.GetDataForMonth(curFrameMonth); // Set data for current frame
                }

                int waterIdx = curFrameYear - waterStartYear;
                if (waterIdx >= 0 && waterIdx < waterData.Count)                      // Check if year is in water data range
                {
                    WaterDataYear waterYear = waterData[waterIdx];
                    currentWaterData = waterYear.GetDataForMonth(curFrameMonth).GetDataForDay(curFrameDay);               // Set data for current day
                    StreamflowLevel = currentWaterData.GetStreamflowForWarmingIdx(warmingIdx);
                    Precipitation = currentWaterData.precipitation;
                }
                else
                {
                    Debug.Log(name + ".UpdateCurrentData()... Couldn't update current water data!  waterIdx:" + waterIdx + " curYear:" + curFrameYear + " startYear:" + simulationStartYear + " waterData.Length:" + waterData.Count + " warmingIdx:" + warmingIdx);
                }
            }

            lastFrameDay = curFrameDay;
            lastFrameMonth = curFrameMonth;
            lastFrameYear = curFrameYear;

            nextFrameDay = curFrameDay + timeStep;
            nextFrameMonth = curFrameMonth;
            nextFrameYear = curFrameYear;

            int daysInMonth = GetDaysInMonth(curFrameMonth, curFrameYear);
            while (nextFrameDay > daysInMonth)
            {
                nextFrameDay -= daysInMonth;
                nextFrameMonth++;

                if (nextFrameMonth > 12)
                {
                    nextFrameMonth = 1;
                    nextFrameYear += 1;
                }

                daysInMonth = GetDaysInMonth(nextFrameMonth, nextFrameYear);
            }

            if (!landscapeSimulationWeb)
            {
                if (nextPatchData == null) // Update next patch data
                    nextPatchData = GetPatchData(nextFrameYear, nextFrameMonth);
                else if (curFrameYear != nextFrameYear || curFrameMonth != nextFrameMonth)
                    nextPatchData = GetPatchData(nextFrameYear, nextFrameMonth);
            }
        }
    }

    private void FinishUpdateWaterDataFromWeb(string jsonString)
    {
        WaterData waterDataObj = JsonConvert.DeserializeObject<WaterData>(jsonString);
        currentWaterData = ConvertWaterDataToWaterDataFrame(waterDataObj);

        StreamflowLevel = currentWaterData.GetStreamflowForWarmingIdx(warmingIdx);
        Precipitation = currentWaterData.precipitation;
    }

    private void FinishUpdateFireDataFromWeb(string jsonString)
    {
        simulationData = new TerrainSimulationData[5];
        List<SnowDataFrame> sDataList = new List<SnowDataFrame>(); // Snow data frames (unused)
        List<FireDataFrame> fDataList = new List<FireDataFrame>(); // Fire data frames for curr. warming idx

        TimelineFireData timelineFireData = JsonConvert.DeserializeObject<TimelineFireData>("{\"years\":" + jsonString + "}");

        if (timelineFireData != null)
        {
            FireDataFrameJSONRecord[] jDataArr = timelineFireData.years;

            foreach (FireDataFrameJSONRecord jsonRecord in jDataArr)
            {
                FireDataFrameRecord frameRecord = ConvertFireDataJsonToFrameRecord(jsonRecord);
                FireDataFrame frame = ConvertFireDataFrameRecordToFrame(frameRecord);
                fDataList.Add(frame);
            }

            int warm = WarmingIndexToDegrees(warmingIdx);
            simulationData[warmingIdx] = new TerrainSimulationData(sDataList, fDataList, "Thin_0_Warm_" + warm);
            currentSimulationData = simulationData[warmingIdx];
            //if (debug && currentTimeIdx % 10 == 0)
            //{
            //    Debug.Log(("At time: "+currentTimeIdx+"... FinishUpdateFireDataFromWeb ERROR... deserialize failed"));
            //}
        }
        else
        {
            Debug.Log(("FinishUpdateFireDataFromWeb ERROR... deserialize failed"));
        }
    }

    // Unused
    private void FinishUpdateAllPatchDataFromWeb(string jsonString)
    {
        PatchDataList patchDataList = JsonConvert.DeserializeObject<PatchDataList>("{\"patches\":" + jsonString + "}");
        patchExtents = new Dictionary<int, PatchPointCollection>();

        if (patchDataList != null)
        {
            PatchDataRecord[] jDataArr = patchDataList.patches;
            foreach (PatchDataRecord jsonRecord in jDataArr)
            {
                patchExtents.Add(jsonRecord.patchID, jsonRecord.Data);
            }
        }
        else
        {
            Debug.Log(("FinishUpdateAllPatchDataFromWeb ERROR... deserialize failed"));
        }

        //if(debug && debugDetailed)
            Debug.Log("FinishUpdateAllPatchDataFromWeb finished... patchExtents.Count:"+patchExtents.Count);
    }

    private WaterDataFrame ConvertWaterDataToWaterDataFrame(WaterData wd)
    {
        WaterDataFrame frame = new WaterDataFrame(wd.year, wd.month, wd.day, wd.precipitation, wd.qBase,
            wd.qWarm1, wd.qWarm2, wd.qWarm4, wd.qWarm6, wd.index);
        return frame;
    }

    private FireDataFrameRecord ConvertFireDataJsonToFrameRecord(FireDataFrameJSONRecord fdjr)
    {
        FireDataFrameRecord frameRecord = new FireDataFrameRecord(fdjr.day, fdjr.month, fdjr.year,
            fdjr.gridHeight, fdjr.gridWidth, fdjr.DataList);
        return frameRecord;
    }

    /// <summary>
    /// Updates the landscape terrain based on current data.
    /// </summary>
    /// <param name="curYear">Current year.</param>
    /// <param name="curMonth">Current month.</param>
    /// <param name="curDay">Current day.</param>
    /// <param name="timeStep">Time step.</param>
    private void UpdateTerrain(int curYear, int curMonth, int curDay, int timeStep)
    {
        //Terrain t = terrain;

        float regrowthAmount = 1f;          // Fire regrowth amount

        if (terrainBurning)                 // Set burnt splatmap
        {
            regrowthAmount = 0f;
        }
        else if (recentFire)                // Transition back to unburnt splatmap
        {
            regrowthAmount = Mathf.Clamp(MapValue(currentTimeIdx - fireRegrowthStartTimeIdx, 0, fireRegrowthLength, 0f, 1f), 0f, 1f);

            if(debugFire)
                Debug.Log(name + ".UpdateTerrain()... recentFire: true...  regrowthAmount:" + regrowthAmount + " currentTimeIdx:" + currentTimeIdx + " fireRegrowthStartTimeIdx: " + fireRegrowthStartTimeIdx + " fireGrassRegrowthLength: " + fireRegrowthLength);

            if (Mathf.Abs(regrowthAmount - 1f) < 0.0001f)           // Check if finished
            {
                ResetBurntState();
                activeBurnCells = new List<SERI_FireCell>();

                if(debugFire)
                    Debug.Log(name + ".UpdateTerrain()... Finished post-fire regrowth");
            }
        }

        if (landscapeSimulationWeb)
        {
            ResetTerrainSplatmap();
            ResetSnow(false);
            //SnowDataFrame sdf = GetTerrainSplatmapForDay(curDay, currentYear, currentPatchData, nextPatchData, regrowthAmount);
            //if (sdf != null)
            //    terrain.terrainData.SetAlphamaps(0, 0, sdf.GetData());

            // -- TO DO: Is this possible for web?
        }
        else
        {
            int currentYear = currentPatchData.GetYear();
            SnowDataFrame sdf = BuildTerrainSplatmapForDay(curDay, currentYear, currentPatchData, nextPatchData, regrowthAmount);
            if (sdf != null)
                terrain.terrainData.SetAlphamaps(0, 0, sdf.GetData());
            else
                Debug.Log("ERROR NO sdf");
        }

        //UpdateBackgroundSnow();
    }

    /// <summary>
    /// Updates the stream from simulation data.
    /// </summary>
    private void UpdateRiver(int curYear, int curMonth, int curDay, int timeStep)
    {
        riverObject.transform.localPosition = new Vector3( riverObject.transform.localPosition.x,
                                                           Mathf.Clamp(MapValue(StreamflowLevel, RiverLevelMin, RiverLevelMax, riverMinHeight, riverFullHeight), riverMinHeight, riverFullHeight),
                                                           riverObject.transform.localPosition.z );

        riverFaceObject.transform.localPosition = new Vector3( riverFaceObject.transform.localPosition.x,
                                                               Mathf.Clamp(MapValue(StreamflowLevel, RiverLevelMin, RiverLevelMax, riverFaceMinHeight, riverFaceFullHeight), riverFaceMinHeight, riverFaceFullHeight),
                                                               riverObject.transform.localPosition.z );

        riverFaceObject.transform.localScale = new Vector3( riverFaceObject.transform.localScale.x,
                                                            Mathf.Clamp(MapValue(StreamflowLevel, RiverLevelMin, RiverLevelMax, riverFaceMinScale, riverFaceFullScale), riverFaceMinScale, riverFaceFullScale),
                                                            riverObject.transform.localScale.z );
    }
    #endregion

    #region Initialization

    /// <summary>
    /// Setup landscape game objects.
    /// </summary>
    private void Awake()
    {
        initialized = false;             // Initialized flag
        dataFormatted = false;
        setup = false;
        pauseGameState = false;          // Pause game flag
        unpauseGameState = false;        // Unpause game flag

        terrain = gameObject.transform.Find("LargeTerrain").GetComponent<Terrain>() as Terrain;
        fireManager = terrain.transform.GetComponentInChildren<SERI_FireManager>() as SERI_FireManager;
        SetFirePrefab(firePrefab);

        fireGridCols = fireManager.GetGridWidth();
        fireGridRows = fireManager.GetGridHeight();

        Assert.IsNotNull(gameObject);
        Assert.IsNotNull(terrain);
        Assert.IsNotNull(fireManager);

        riverObject = GameObject.FindWithTag("River").gameObject;
        tributarySplines = GameObject.FindGameObjectsWithTag("Tributary");
        Assert.IsNotNull(riverObject);
        Assert.IsNotNull(riverFaceObject);

        snowManager = transform.Find("SnowManager_Landscape").gameObject.GetComponent<SnowManager>() as SnowManager;
        snowManagerBkgd = transform.Find("SnowManager_Background").gameObject.GetComponent<SnowManager>() as SnowManager;
        Assert.IsNotNull(snowManager);
        Assert.IsNotNull(snowManagerBkgd);

        SetSnowVisibility(false);
        ResetSnow(false);

        pooler = GetComponent<GameObjectPool>() as GameObjectPool;
        pooler.Initialize(firePrefab);
    }

    /// <summary>
    /// Set starting parameters for objects in cube.
    /// </summary>
    /// <param name="curTimeIdx"></param>
    /// <param name="curYear"></param>
    /// <param name="curMonth"></param>
    /// <param name="curDay"></param>
    /// <param name="timeStep"></param>
    /// <param name="newWarmingIdx"></param>
    /// <param name="newMinFireFrames"></param>
    /// <param name="newImmediateFireTimeThreshold"></param>
    public void StartSimulation(int curTimeIdx, int curYear, int curMonth, int curDay, int timeStep, int newWarmingIdx, int newMinFireFrames, int newImmediateFireTimeThreshold)
    {
        if (debug)
            Debug.Log("Landscape.StartSimulation()... curYear:" + curYear + " curMonth:" + curMonth + " curDay:" + curDay + " warmingIdx:" + newWarmingIdx);

        warmingIdx = newWarmingIdx;
        minFireFrameLength = newMinFireFrames;
        immediateFireTimeThreshold = newImmediateFireTimeThreshold;

        activeBurnCells = new List<SERI_FireCell>();

        if (landscapeSimulationOn && !landscapeSimulationWeb)
            SetSnowVisibility(true);

        UpdateLandscape(curTimeIdx, curYear, curMonth, curDay, timeStep, false);
    }


    /// <summary>
    /// Initialize LandscapeController with data list.
    /// </summary>
    public IEnumerator InitializeData()//SimulationSettings newSettings)
    {
        if (debug)
            Debug.Log("LandscapeController.Initialize()...");

        //settings = newSettings;

        if (landscapeSimulationOn)
        {
            if (landscapeSimulationWeb)
            {
                //LoadDataWeb();                         // Loads snow and fire data frames (Web Version)
                if (debug)
                    Debug.Log("InitializeData()... Data from web... ");

                //LoadPatchExtentsData();                                // Load patch extents from Resources
                if (loadPatchDataFromFile)
                {
                    try
                    {
                        if (debug)
                            Debug.Log("loadPatchDataFromFile... true");

                        TextAsset patchExtTextAsset = (TextAsset)Resources.Load("PatchData/PatchData");
                        patchExtents =
                            JsonConvert.DeserializeObject<Dictionary<int, PatchPointCollection>>(patchExtTextAsset
                                .text);
                    }
                    catch (Exception e)
                    {
                        Debug.Log("InitializeData()... ERROR: " + e.Message);
                    }
                }

                yield return null;

                Debug.Log("Loading landscape data... ");

                //LoadFireData();
                //try
                //{
                    if (loadFireDataFromFile)
                    {
                        TextAsset[] fireDataFrames = Resources.LoadAll<TextAsset>("FireData");
                        simulationData = new TerrainSimulationData[5];

                        //int i = warmingIdx;
                        for (int i = 0; i < 5; i++)
                        {
                            List<SnowDataFrame> sDataList = new List<SnowDataFrame>(); // Snow data frames (unused)
                            List<FireDataFrame> fDataList = new List<FireDataFrame>(); // Fire data frames
                            List<FireDataFrameRecord> fDataRecordList = new List<FireDataFrameRecord>(); // Fire data frames

                            TextAsset fireFrameTextAsset = fireDataFrames[i]; // List<FireDataFrame> 

                            fDataRecordList =
                                JsonConvert.DeserializeObject<List<FireDataFrameRecord>>(fireFrameTextAsset.text);

                            yield return null;

                            foreach (FireDataFrameRecord rec in fDataRecordList)
                            {
                                fDataList.Add(ConvertFireDataFrameRecordToFrame(rec));
                                yield return null;
                            }

                            fDataRecordList.Clear();
                            yield return null;

                            int warm = 0;
                            switch (i)
                            {
                                case 0:
                                    warm = 0;
                                    break;
                                case 1:
                                    warm = 1;
                                    break;
                                case 2:
                                    warm = 2;
                                    break;
                                case 3:
                                    warm = 4;
                                    break;
                                case 4:
                                    warm = 6;
                                    break;
                                default:
                                    warm = 0;
                                    break;
                            }

                            simulationData[i] = new TerrainSimulationData(sDataList, fDataList, "Thin_0_Warm_" + warm);
                            currentSimulationData = simulationData[i];

                            Debug.Log("Loading simulation data : " + i);

                        yield return null;
                    }
                }
                //catch (Exception ex)
                //{
                //    Debug.Log("LoadLandscapeData()... ERROR ex: " + ex.Message);
                //}

                //ImportWaterData();
                try
                {
                    if (loadWaterDataFromFile)
                    {

                        TextAsset patchExtTextAsset = (TextAsset)Resources.Load("WaterData/WaterData");
                        waterData = JsonConvert.DeserializeObject<List<WaterDataYear>>(patchExtTextAsset.text);

                        CalculateWaterRanges(); // Calculate streamflow range
                    }
                }
                catch (Exception ex)
                {
                    Debug.Log("InitializeData()... waterData ERROR: " + ex.Message);
                }

                GetWaterRangesFromWeb();    // -- TO DO
                waterStartYear = 1941;//waterData[0].GetYear();

                updateDate = false;

                dataFormatted = true;
                //dataInitialized = true;

                //if (debug)
                //    Debug.Log("LoadDataWeb()... Finished");
            }
            else
            {

            }
            //else
            //{
            //    LoadDataDesktop();                     // Loads patches data (Desktop Version)
            //}
        }

        InitSplatmaps();
        ResetTerrainSplatmap();

        lastFrameDay = -1;
        lastFrameMonth = -1;
        lastFrameYear = -1;

        nextFrameDay = -1;
        nextFrameMonth = -1;
        nextFrameYear = -1;

        Debug.Log(name+"... Data Initialized...");
        initialized = true;
        yield return null;
    }

    public void LoadLandscapeDataForWarmingIdx(int warmIdx)
    {
        int i = warmIdx;
        warmingIdx = warmIdx;

        if (loadFireDataFromFile)
        {
            TextAsset fireFrameTextAsset =
                Resources.Load<TextAsset>("FireData/fireDataList_" + i); // List<FireDataFrame> 

            simulationData = new TerrainSimulationData[5];

            //for (int i = 0; i < 5; i++)
            //{
            List<SnowDataFrame> sDataList = new List<SnowDataFrame>(); // Snow data frames (unused)
            List<FireDataFrame> fDataList = new List<FireDataFrame>(); // Fire data frames
            List<FireDataFrameRecord> fDataRecordList = new List<FireDataFrameRecord>(); // Fire data frames


            fDataRecordList = JsonConvert.DeserializeObject<List<FireDataFrameRecord>>(fireFrameTextAsset.text);

            foreach (FireDataFrameRecord rec in fDataRecordList)
            {
                fDataList.Add(ConvertFireDataFrameRecordToFrame(rec));
            }

            fDataRecordList.Clear();
            
            int warm = WarmingIndexToDegrees(i);
            

            simulationData[i] = new TerrainSimulationData(sDataList, fDataList, "Thin_0_Warm_" + warm);
            currentSimulationData = simulationData[i];
        }
        else // Load from web
        {
            if(WebManager.Instance)
                WebManager.Instance.RequestFireData(warmingIdx, this.FinishUpdateFireDataFromWeb);
            else
                Debug.Log("LoadLandscapeDataForWarmingIdx()... ERROR... no instance of WebManager!");
        }

            
        Debug.Log("LoadLandscapeDataForWarmingIdx()... Loading simulation data : " + i);
    }


    private static int WarmingIndexToDegrees(int idx)
    {
        int warm;
        switch (idx)
        {
            case 0:
                warm = 0;
                break;
            case 1:
                warm = 1;
                break;
            case 2:
                warm = 2;
                break;
            case 3:
                warm = 4;
                break;
            case 4:
                warm = 6;
                break;
            default:
                warm = 0;
                break;
        }

        return warm;
    }

    /// <summary>
    /// Initialize splatmaps
    /// </summary>
    public void InitSplatmaps()
    {
        unburntSplatmap = CreateUnburntSplatmap();
    }

    /// <summary>
    /// Sets the landscape data list.
    /// </summary>
    /// <param name="newDataList">New data list.</param>
    /// <param name="newLandscapeSimulationOn">Landscape simulation on/off state</param>
    public void SetupController(GameController.LandscapeData newDataList, bool newLandscapeSimulationOn)
    {
        landscapeSimulationOn = newLandscapeSimulationOn;
        landscapeDataList = newDataList;
    }

    #endregion

    #region Fire
    /// <summary>
    /// Ignites the fire.
    /// </summary>
    /// <param name="date">Date.</param>
    /// <param name="timeStep">Time step.</param>
    /// <param name="pauseDuringFire">Pause during fire flag</param>
    /// <param name="newFireLengthInSec">Fire length in sec</param>
    /// <param name="fireIdx">Index of fire</param>
    public void IgniteTerrain(Vector3 date, int timeStep, bool pauseDuringFire, float newFireLengthInSec, int fireIdx)
    {
        if (!terrainBurning)
        {
            bool immediateFire = !landscapeSimulationOn;
            if(landscapeSimulationOn && !pauseDuringFire && timeStep > immediateFireTimeThreshold)
                immediateFire = true;

            int frameRate, maxFireFrameLength;
            float fireLengthInSec;

            if(pauseDuringFire)
            {
                fireLengthInSec = newFireLengthInSec;
            }
            else
            {
                frameRate = (int)(1f / Time.smoothDeltaTime);                               // Find frame length in sec
                maxFireFrameLength = (int)immediateFireTimeThreshold;                       // Find maximum frames per fire 
                int fireFrameCount = maxFireFrameLength / timeStep;                         // Calculate fire length in steps 
                fireFrameCount = Mathf.Clamp(fireFrameCount, minFireFrameLength, maxFireFrameLength);
                fireLengthInSec = fireFrameCount / frameRate;                               // Calculate fire length in seconds
            }

            if(debugFire)
                Debug.Log(name+ ".IgniteTerrain()... parent:" + transform.parent.name + " setting terrainBurning to true... timeStep:" + timeStep + " fireLengthInSec:" + fireLengthInSec+" time:" + Time.time);

            fireManager.IgniteTerrain( terrain, timeStep, fireLengthInSec, fireIdx );

            //fireStartTime = Time.time;
            terrainBurning = true;
            recentFire = true;

            burnedAlphamapGrid = new bool[terrain.terrainData.alphamapHeight, terrain.terrainData.alphamapWidth];
            for (int x = 0; x < terrain.terrainData.alphamapWidth; x++)
            {
                for (int y = 0; y < terrain.terrainData.alphamapHeight; y++)
                {
                    burnedAlphamapGrid[x, y] = false;
                }
            }
        }
        else
            Debug.Log(transform.parent.name+ "." + name + ".IgniteTerrain()... ERROR Can't ignite fire... already burning! time:" + Time.time);
    }

    /// <summary>
    /// Get fire location for patch location
    /// </summary>
    /// <param name="location"></param>
    /// <returns></returns>
    public Vector2 GetFireLocationForPatchLocation(Vector2 location)
    {
        //int rows = fireGridRows;
        //int cols = fireGridCols;
        int rows = fireGridRows - 1;             // Keep within grid array bounds
        int cols = fireGridCols - 1;
        int xLoc = cols - (int)Mathf.Clamp(MapValue(location.x, 0, patchDataCols, 0, cols), 0, cols);
        int yLoc = (int)Mathf.Clamp(MapValue(location.y, 0, patchDataRows, 0, rows), 0, rows);

        Vector2 gridLoc = new Vector2(xLoc, yLoc);
        return gridLoc;
    }

    /// <summary>
    /// Checks whether terrain is burning
    /// </summary>
    /// <returns></returns>
    public bool IsBurning()
    {
        return terrainBurning;
    }

    /// <summary>
    /// Resets burnt state 
    /// </summary>
    public void ResetBurntState()
    {
        terrainBurnt = false;
        recentFire = false;
    }

    /// <summary>
    /// Add burned cell at given time after fire start.
    /// </summary>
    /// <param name="cell">Cell</param>
    /// <param name="waitTime">Time after start when patch IDs associated with cell will burn</param>
    public void AddBurnedCellAfterTime(SERI_FireCell cell, float waitTime)
    {
        StartCoroutine( AddBurnedCell(cell, waitTime + burnedTerrainCellDelay) );
    }

    /// <summary>
    /// Add burned cell
    /// </summary>
    /// <param name="cell">Cell to add</param>
    /// <param name="waitTime">Wait time</param>
    /// <returns></returns>
    private IEnumerator AddBurnedCell(SERI_FireCell cell, float waitTime)
    {
        yield return new WaitForSeconds(waitTime);

        foreach(int patchID in cell.patchIDList)
        {
            if (patchID == -1)
            {
                Debug.Log("AddBurnedCell()... WARNING patchID == -1!  Skipping...");
                continue;
            }

            if (!landscapeSimulationWeb)
            {
                var patchCollection = patchExtents[patchID]; // -- TO DO: Optimize - get atomic data from web

                foreach (PatchPoint point in patchCollection.GetPoints()) // Loop over points in collection
                {
                    Vector2 loc = point.GetAlphamapLocation(); // -- TO DO: Optimize by skipping duplicates (if any)
                    burnedAlphamapGrid[(int)loc.y, (int)loc.x] = true;

                    if (!gridMode) // Remove grid   -- OPTIMIZE?? ONLY APPLY TO EDGES OF COLLECTION
                    {
                        if ((int)loc.y + 1 < burnedAlphamapGrid.GetLength(0))
                        {
                            burnedAlphamapGrid[(int)loc.y + 1, (int)loc.x] = true;
                        }

                        if ((int)loc.x + 1 < burnedAlphamapGrid.GetLength(1))
                        {
                            burnedAlphamapGrid[(int)loc.y, (int)loc.x + 1] = true;
                        }

                        if ((int)loc.y + 1 < burnedAlphamapGrid.GetLength(0) &&
                            (int)loc.x + 1 < burnedAlphamapGrid.GetLength(1))
                        {
                            burnedAlphamapGrid[(int)loc.y + 1, (int)loc.x + 1] = true;
                        }
                    }
                }
            }
        }
    }


    /// <summary>
    /// Checks if fire still burning.
    /// </summary>
    /// <returns><c>true</c>, if still burning, <c>false</c> otherwise.</returns>
    private bool StillBurning()
    {
        if (fireManager.burning)
        {
            //Debug.Log(name + ".StillBurning()... fireManager.m_activeFireGrids:" + fireManager.m_activeFireGrids+" time:"+Time.time);
            return true;
        }
        else
        {
            return false;
        }
    }

    /// <summary>
    /// Calculate the fire cells for fire on given date.
    /// </summary>
    /// <param name="date">Date.</param>
    public void CalculatePatchesToBurn()
    {
        List<FireDataFrame> frames = GetCurrentSimulationData().GetFireData();
        List<int> patchesToBurn = new List<int>();

        //Debug.Log(name + ".CalculatePatchesToBurn().. Looking for fire at month:" + month + " day:" + day + " year:" + year + " frames.Count:" + frames.Count+" warmingIdx:"+warmingIdx);

        foreach (FireDataFrame fire in frames)
        {
            //Debug.Log(name + ".CalculatePatchesToBurn().. Checking fire frame at month:" + fire.GetMonth() + " day:" + fire.GetDay() + " year:" + fire.GetYear());

            List<FireDataPoint> points = fire.GetDataList();

            foreach (FireDataPoint point in points)
            {
                if (!patchesToBurn.Contains(point.GetPatchID()))
                {
                    patchesToBurn.Add(point.GetPatchID());
                }
            }

            patchesToBurnDict.Add(new Vector3(fire.GetMonth(), fire.GetDay(), fire.GetYear()), patchesToBurn);

            //Debug.Log(name + ".CalculatePatchesToBurn().. Found fire at month:" + month + " day:" + day + " year:" + year + " cellLocations.Count:" + burnedPatches.Count+ " points.Count:"+ points.Count + " warmingIdx:" + warmingIdx);
        }

        if (debugFire)
            Debug.Log(name + ".CalculatePatchesToBurn().. Found burnedPatches.Count:" + patchesToBurn.Count + " warmingIdx:" + warmingIdx);
    }

    /// <summary>
    /// Calculate the fire cells for fire on given date.
    /// </summary>
    /// <returns>True if success, false otherwise</returns>
    //public void LoadPatchesToBurn()
    //{
    //    //List<FireDataFrame> frames = GetCurrentSimulationData().GetFireData();
    //    //List<int> patchesToBurn = new List<int>();

    //    //Debug.Log(name + ".CalculatePatchesToBurn().. Looking for fire at month:" + month + " day:" + day + " year:" + year + " frames.Count:" + frames.Count+" warmingIdx:"+warmingIdx);

    //    //foreach (FireDataFrame fire in frames)
    //    //{
    //    //    //Debug.Log(name + ".CalculatePatchesToBurn().. Checking fire frame at month:" + fire.GetMonth() + " day:" + fire.GetDay() + " year:" + fire.GetYear());

    //    //    List<FireDataPoint> points = fire.GetDataList();

    //    //    foreach (FireDataPoint point in points)
    //    //    {
    //    //        if (!patchesToBurn.Contains(point.GetPatchID()))
    //    //        {
    //    //            patchesToBurn.Add(point.GetPatchID());
    //    //        }
    //    //    }

    //    //    patchesToBurnDict.Add(new Vector3(fire.GetMonth(), fire.GetDay(), fire.GetYear()), patchesToBurn);

    //    //    //Debug.Log(name + ".CalculatePatchesToBurn().. Found fire at month:" + month + " day:" + day + " year:" + year + " cellLocations.Count:" + burnedPatches.Count+ " points.Count:"+ points.Count + " warmingIdx:" + warmingIdx);
    //    //}
        

    //    ////burn_warm0_1969_7_15.json
    //    //List<Dictionary<Vector3, List<int>>> burnDictList = new List<Dictionary<Vector3, List<int>>>();

    //    //TextAsset[] burnDataFrames = (TextAsset[])Resources.LoadAll("BurnData", typeof(TextAsset));
    //    //foreach (TextAsset textAsset in burnDataFrames)
    //    //{
    //    //    Dictionary<Vector3, List<int>> bDataList = JsonConvert.DeserializeObject<Dictionary<Vector3, List<int>>>(textAsset.text);
    //    //    burnDictList.Add(bDataList);
    //    //}

    //    try
    //    {
    //        patchesToBurnDict = patchesToBurnDictList[warmingIdx];
    //        //return true;
    //    }
    //    catch(Exception ex)
    //    {
    //        Debug.Log("LoadPatchesToBurn()... ERROR... ex:"+ex.Message);
    //        //return false;
    //    }

    //    //if (debugFire)
    //    //    Debug.Log(name + ".LoadPatchesToBurn().. Found burnedPatches.Count:" + patchesToBurn.Count + " warmingIdx:" + warmingIdx);
    //}

    /// <summary>
    /// Gets the active fire cells for date.
    /// </summary>
    /// <param name="date">Date.</param>
    public List<int> GetPatchesToBurnForDate(Vector3 date)
    {
        return patchesToBurnDict[date];
    }

    /// <summary>
    /// Gets the active fire cells for date.
    /// </summary>
    /// <param name="date">Date.</param>
    //private List<FireDataPoint> GetFirePointsForDate(Vector3 date)
    //{
    //    int month = (int)date.x;
    //    int day = (int)date.y;
    //    int year = (int)date.z;

    //    List<FireDataFrame> frames = GetCurrentSimulationData().GetFireData();
    //    List<FireDataPoint> activePoints = new List<FireDataPoint>();

    //    //Debug.Log(name + ".GetActiveFireCellsForDate().. Looking for fire at month:" + month + " day:" + day + " year:" + year + " frames.Count:" + frames.Count);

    //    int count = 0;
    //    foreach (FireDataFrame fire in frames)
    //    {
    //        //Debug.Log(name + ".GetActiveFireCellsForDate().. Checking fire frame at month:" + fire.GetMonth() + " day:" + fire.GetDay() + " year:" + fire.GetYear());
    //        if (fire.GetMonth() == month && fire.GetDay() == day && fire.GetYear() == year)         // Get fire data frames for fire day
    //        {
    //            return firePointLists[count];
    //            //activePoints = fire.GetData();
    //            //activePoints.Sort();                 // Sort cells

    //            //Debug.Log(name + ".GetActiveFireCellsForDate().. Found fire at month:" + month + " day:" + day + " year:" + year + " cellLocations.Count:" + activePoints.Count + " warmingIdx:" + warmingIdx);
    //        }

    //        count++;
    //    }

    //    Debug.Log(name + ".GetActiveFireCellsForDate().. Found cellLocations.Count:" + activePoints.Count);

    //    return null;
    //}

    public SERI_FireManager GetFireManager()
    {
        return fireManager;
    }

    /// <summary>
    /// Set fire prefab
    /// </summary>
    /// <param name="newFirePrefab">New fire prefab.</param>
    public void SetFirePrefab(GameObject newFirePrefab)
    {
        fireManager.SetFirePrefab(newFirePrefab);
    }

    /// <summary>
    /// Sets the landscape data list.
    /// </summary>
    /// <param name="newFireDates">New fire date list.</param>
    public void SetupFires(Vector3[] fireDates, int warmIdx)        /// -- TO DO: Get fire dates from data!!
    {
        //List<FireDataPoint>[] firePointLists;
        Assert.IsNotNull(fireDates);
        Assert.IsNotNull(pooler);
        Assert.IsNotNull(firePrefab);

        if (!landscapeSimulationOn)
        {
            fireManager.Initialize(pooler, firePrefab, fireGridCenterLocation, terrain.transform.position, null, this, false, true, false);
        }
        else 
        {
            //firePointLists = new List<FireDataPoint>[fireDates.Length];

            List<FireDataFrame> frames; 
            if(landscapeSimulationWeb)
                frames = currentSimulationData.GetFireData();
            else
                frames = simulationData[warmIdx].GetFireData();

            foreach (FireDataFrame fire in frames)
            {
                /* Find day fire occurred */
                Assert.IsNotNull(fire); 

                int day = 1;
                int count = 0;
                foreach (Vector3 date in fireDates)
                {
                    int fireMonth = (int)date.x;
                    int fireDay = (int)date.y;
                    int fireYear = (int)date.z;

                    //List<FireDataPoint> firePoints = new List<FireDataPoint>();

                    if (fireMonth == fire.GetMonth() && fireYear == fire.GetYear())
                    {
                        Debug.Log(name + ".SetupFires()... Found day for fire at month:" + fire.GetMonth() + " year:" + fire.GetYear() + " Day = " + fireDay + " warmIdx:" + warmIdx);
                        //firePoints = fire.GetDataList();
                        day = fireDay;
                    }

                    fire.SetDay(day);
                    //firePointLists[count] = firePoints;

                    count++;
                }
            }

            //if (landscapeSimulationWeb)         // Load burn data from Resources 
            //{
            //    patchesToBurnDictList = new List<Dictionary<Vector3, List<int>>>();

            //    //burn_warm0_1969_7_15.json

            //    TextAsset[] burnDataFrames = Resources.LoadAll<TextAsset>("BurnData");
            //    foreach (TextAsset textAsset in burnDataFrames)
            //    {
            //        Dictionary<Vector3, List<int>> bDataList = JsonConvert.DeserializeObject<Dictionary<Vector3, List<int>>>(textAsset.text);
            //        patchesToBurnDictList.Add(bDataList);
            //    }
            //}

            fireManager.Initialize(pooler, firePrefab, fireGridCenterLocation, terrain.transform.position, frames, this, true, false, false);

            patchesToBurnDict = new Dictionary<Vector3, List<int>>();
        }
    }

    #endregion

    #region Water

    /// <summary>
    /// Process current simulation data file (CSV Format).      
    /// </summary>
    /// <param name="newDataFile">New data file.</param>
    public void LoadStreamflowFile(TextAsset newDataFile)    // Process cube data file
    {
        List<string> rawData = TextAssetToList(newDataFile);
        streamflowDataLength = rawData.Count - 1;                  // Set data length (raw data length - 1 for blank space at end)
        int columnCount = Enum.GetNames(typeof(WaterDataColumnIdx)).Length;
        waterDataArray = new float[streamflowDataLength, columnCount];

        if (debug)
            Debug.Log("LoadStreamflowFile()... length x:" + waterDataArray.GetLength(0) + " y:" + waterDataArray.GetLength(1) + " streamflowDataLength:" + streamflowDataLength + " columnCount:" + columnCount);

        string[] tempData = new string[7];                   // Streamflow daily data TXT file has 7 columns

        for (int i = 1; i < streamflowDataLength; i++)       // Store data in 'data' 2D array
        {
            tempData = rawData[i].Split(' ');
            waterDataArray[i - 1, 0] = i - 1;                          // Store line index as first element in row

            for (int j = 0; j < columnCount; j++)
            {
                try
                {
                    waterDataArray[i - 1, j] = float.Parse(tempData[j]);    // Store data fields
                }
                catch (System.Exception e)
                {
                    try
                    {
                        waterDataArray[i - 1, j] = int.Parse(tempData[j]);      // Store data fields
                    }
                    catch (System.Exception f)
                    {
                        waterDataArray[i - 1, j] = 0;
                    }
                }
            }
        }

        if (debug)
            Debug.Log("LoadStreamflowFile()... Finished");
    }

    /// <summary>
    /// Gets all water data for current simulation run
    /// </summary>
    /// <returns></returns>
    public List<WaterDataYear> GetWaterData()
    {
        return waterData;
    }

    /// <summary>
    /// Calculates the streamflow parameter ranges (min/max values).  
    /// </summary>
    private void CalculateWaterRanges()
    {
        if (debug && debugDetailed)
            Debug.Log("CalculateParameterRanges()... Time:" + Time.time);

        RiverLevelMin = 100000f;
        RiverLevelMax = -100000f;

        foreach (WaterDataYear wdy in waterData)
        {
            foreach (WaterDataMonth mon in wdy.GetMonths())
            {
                foreach (WaterDataFrame frame in mon.GetFrames())
                {
                    float val = frame.QBase;                    // -- TO DO: NEED TO FIX THIS!! SHOULD BE MAPPED TO warmingIdx!!!!
                    if (val < RiverLevelMin)
                        RiverLevelMin = val;
                    if (val > RiverLevelMax)
                        RiverLevelMax = val;

                }
            }
            //int rows = waterData.Count;               // Get row count
            //int idx = 0;                                          // Row in data file

            //int s = (int)WaterDataColumnIdx.QBase + i;            // Start with streamflow base level 

            //while (idx < rows)
            //{
            //    float val = waterDataArray[idx, s];
            //    if (val < RiverLevelMin)
            //        RiverLevelMin = val;
            //    if (val > RiverLevelMax)
            //        RiverLevelMax = val;

            //    idx++;
            //}
        }
    }

    private void GetWaterRangesFromWeb()
    {
        RiverLevelMin = 100000f;
        RiverLevelMax = -100000f;

        RiverLevelMin = 0f;
        RiverLevelMax = 2500f;

        //private void FinishUpdateWaterDataFromWeb(string jsonString)
        //{
        //    UpdateDataRowsFromJSON(jsonString);     // Update data for parameter range finding
        //    FindParameterRanges();
        //    UpdateDataFromJSON(jsonString);         // Update data for simulation

        //    GrowInitialVegetation();        // TESTING
        //}

        //WebManager.Instance.RequestCubeData(patchID, warmingIdx, this.FinishUpdateWaterDataFromWeb);

    }

    /// <summary>
    /// Calculates the streamflow parameter ranges (min/max values).  
    /// </summary>
    private void CalculateWaterRangesOLD()
    {
        if (debug && debugDetailed)
            Debug.Log("CalculateParameterRanges()... Time:" + Time.time);

        RiverLevelMin = 100000f;
        RiverLevelMax = -100000f;

        for (int i = 0; i < 5; i++)
        {
            int rows = waterDataArray.GetLength(0);               // Get row count
            int idx = 0;                                          // Row in data file

            int s = (int)WaterDataColumnIdx.QBase + i;            // Start with streamflow base level 

            while (idx < rows)
            {
                float val = waterDataArray[idx, s];
                if (val < RiverLevelMin)
                    RiverLevelMin = val;
                if (val > RiverLevelMax)
                    RiverLevelMax = val;

                idx++;
            }
        }
    }

    #endregion

    #region Data

    /// <summary>
    /// Gets the current data.
    /// </summary>
    //private float[,] GetCurrentData()
    //{
    //    return waterDataArray;
    //}

    /// <summary>
    /// Sets the data ranges.
    /// </summary>
    private void SetPatchDataRanges()
    {
        SnowAmountMax = -1000000f;
        PlantCarbonMin = 1000000f;
        PlantCarbonMax = -1000000f;
        AvgSnowAmountMin = 1000000f;
        AvgSnowAmountMax = -1000000f;

        for (int i = 0; i < 5; i++)
        {
            foreach (PatchDataYear year in patchesData[i])
            {
                foreach (PatchDataMonth month in year.GetMonths())
                {
                    int count = 0;
                    float totalSnow = 0f;
                    foreach (PatchDataFrame frame in month.GetFrames())
                    {
                        float snow = frame.snow;
                        totalSnow += snow;

                        float carbon = frame.carbon;
                        if (carbon < PlantCarbonMin)
                            PlantCarbonMin = carbon;
                        if (carbon > PlantCarbonMax)
                            PlantCarbonMax = carbon;
                        if (snow > SnowAmountMax)
                            SnowAmountMax = snow;

                        count++;
                    }

                    if (count > 0)
                    {
                        float avgSnow = totalSnow / count;
                        if (avgSnow < AvgSnowAmountMin)
                            AvgSnowAmountMin = avgSnow;
                        if (avgSnow > AvgSnowAmountMax)
                            AvgSnowAmountMax = avgSnow;
                    }
                    else
                    {
                        Debug.LogError("No frames in month! month:" + month.GetMonth());
                    }
                }
            }
        }
        if (debug)
            Debug.Log("SetDataRanges()... plantCarbonMin:" + PlantCarbonMin + "  plantCarbonMax:" + PlantCarbonMax + "  SnowAmountMax:" + SnowAmountMax);
    }


    /// <summary>
    /// Process current simulation data file (CSV Format).      
    /// </summary>
    /// <param name="newDataFile">New data file.</param>
    public float[,] LoadDataFile(TextAsset newDataFile)    // Process cube data file
    {
        List<string> rawData = TextAssetToList(newDataFile);
        int extentsDataLength = rawData.Count - 1;                  // Set data length (raw data length - 1 for blank space at end)
        int columnCount = Enum.GetNames(typeof(PatchDataColumnIdx)).Length;
        float[,] extentsData = new float[extentsDataLength, columnCount];

        if (debug)
            Debug.Log("LoadDataFile()... newDataFile:" + newDataFile.name + " length x:" + extentsData.GetLength(0) + " y:" + extentsData.GetLength(1) + " extentsDataLength:" + extentsDataLength);

        string[] tempData = new string[6];                           // Landscape data CSV file has 6 columns

        for (int i = 1; i < extentsDataLength; i++)                  // Store data in 'data' 2D array
        {
            tempData = rawData[i].Split(' ');

            extentsData[i - 1, 0] = i - 1;                           // Store line index as first element in row

            for (int j = 0; j < columnCount; j++)
            {
                extentsData[i - 1, j] = float.Parse(tempData[j]);    // Store data fields
            }
        }

        if (debug)
            Debug.Log(name + ".LoadDataFile()... Finished");

        dataFile = newDataFile;
        return extentsData;
    }

    /// <summary>
    /// Formats the streamflow data.
    /// </summary>
    /// <param name="dataArray">Streamflow data.</param>
    private bool FormatWaterData(float[,] dataArray)
    {
        waterData = new List<WaterDataYear>();
        List<WaterDataFrame> dataFrames = new List<WaterDataFrame>();           // List of frames in month
        List<WaterDataMonth> dataMonths = new List<WaterDataMonth>();           // List to store months data 
        int dataLength = dataArray.GetLength(0);
        int curYear = -1;
        int curMonth = -1;
        int monthCount = 0;

        waterStartYear = (int)dataArray[0, (int)WaterDataColumnIdx.Year];
        updateDate = false;

        if (simulationStartYear != waterStartYear)        // Compare starting years of data files
        {
            if (waterStartYear > simulationStartYear)
            {
                simulationStartYear = waterStartYear;
                simulationStartMonth = (int)dataArray[0, (int)WaterDataColumnIdx.Month];
                simulationStartDay = (int)dataArray[0, (int)WaterDataColumnIdx.Day];
                updateDate = true;

                if (debug)
                    Debug.Log(name + ".FormatStreamflowData()... Setting startYear / startMonth / startDay from streamflow data... setting startYear to:" + simulationStartYear);
            }
        }

        if (debug)
            Debug.Log(name + ".FormatStreamflowData()... Formatting data of length:" + dataLength + " startYear:" + simulationStartYear);

        for (int i = 0; i < dataLength - 1; i++)                                    // Store data in 'data' 2D array
        {
            int year = (int)dataArray[i, (int)WaterDataColumnIdx.Year];
            int month = (int)dataArray[i, (int)WaterDataColumnIdx.Month];
            int day = (int)dataArray[i, (int)WaterDataColumnIdx.Day];
            float precip = dataArray[i, (int)WaterDataColumnIdx.Precip];
            float QBase = dataArray[i, (int)WaterDataColumnIdx.QBase];
            float QWarm1 = dataArray[i, (int)WaterDataColumnIdx.QWarm1];
            float QWarm2 = dataArray[i, (int)WaterDataColumnIdx.QWarm2];
            float QWarm4 = dataArray[i, (int)WaterDataColumnIdx.QWarm4];
            float QWarm6 = dataArray[i, (int)WaterDataColumnIdx.QWarm6];

            if (year > curYear)            // Check if moved to new year (and month)
            {
                if (curYear > -1)
                {
                    dataFrames.Sort();                                                  // Sort frames by month
                    WaterDataMonth dataMonth = new WaterDataMonth(dataFrames, curMonth, curYear);
                    dataMonths.Add(dataMonth);                                          // Add month to list
                    monthCount++;

                    WaterDataYear dataYear = new WaterDataYear(dataMonths, curYear);
                    waterData.Add(dataYear);                                            // Add year to list

                    dataMonths = new List<WaterDataMonth>();
                    dataFrames = new List<WaterDataFrame>();

                    if (debug && debugDetailed)
                        Debug.Log("> FormatStreamflowData()... Set data for curYear:" + curYear + " month:" + month + " QBase:" + QBase + " precip:" + precip);
                }

                curYear = year;
                curMonth = month;
            }

            if (month > curMonth)                       // Check if moved to new month in same year
            {
                if (curMonth > -1)
                {
                    dataFrames.Sort();                                                      // Sort frames by month
                    WaterDataMonth dataMonth = new WaterDataMonth(dataFrames, curMonth, curYear);
                    dataMonths.Add(dataMonth);                                              // Add month to list
                    monthCount++;

                    curMonth = month;
                    dataFrames = new List<WaterDataFrame>();

                    if (debug && debugDetailed)
                        Debug.Log(">> FormatStreamflowData()... Set data for month:" + month + " year:" + year + " streamflow:" + QBase + " precip:" + precip);
                }
            }

            WaterDataFrame frame = new WaterDataFrame(year, month, day, precip, QBase, QWarm1, QWarm2, QWarm4, QWarm6, i);
            dataFrames.Add(frame);

            if (i == dataLength - 2)
            {
                dataFrames.Sort();                                                  // Sort frames by month
                WaterDataMonth dataMonth = new WaterDataMonth(dataFrames, curMonth, curYear);
                dataMonths.Add(dataMonth);                                          // Add month to list

                WaterDataYear dataYear = new WaterDataYear(dataMonths, curYear);
                waterData.Add(dataYear);                                                // Add year to list
            }
        }

        waterData.Sort();                                                               // Sort frame lists by year
                                                                                        // waterData = wData.ToArray();

        return updateDate;
    }

    /// <summary>
    /// Formats the patch extents data frames into lists accessible by year and month.
    /// </summary>
    /// <param name="dataArray">New extents data.</param>
    private void FormatExtentsData(float[,] dataArray)
    {
        //      Debug.Log(name + ".FormatExtentsData()... BEFORE GC.GetTotalMemory:" + GC.GetTotalMemory(false));

        List<PatchDataYear> pData = new List<PatchDataYear>();                                  // Initialize year data list

        List<PatchDataFrame> dataFrames = new List<PatchDataFrame>();           // List of frames in month
        List<PatchDataMonth> dataMonths = new List<PatchDataMonth>();           // List to store months data 

        int dataLength = dataArray.GetLength(0);
        int curYear = -1;
        int curMonth = -1;
        int monthCount = 0;

        extentsStartYear = (int)dataArray[0, (int)PatchDataColumnIdx.Year];
        simulationStartYear = (int)dataArray[0, (int)PatchDataColumnIdx.Year];
        simulationStartMonth = (int)dataArray[0, (int)PatchDataColumnIdx.Month];
        simulationStartDay = 1;

        if (debug)
            Debug.Log("FormatExtentsData()... Formatting data of length:" + dataLength + " startYear:" + simulationStartYear);

        for (int i = 0; i < dataLength - 1; i++)                                    // Store data in 'data' 2D array
        {
            int year = (int)dataArray[i, (int)PatchDataColumnIdx.Year];
            int month = (int)dataArray[i, (int)PatchDataColumnIdx.Month];
            int patchID = (int)dataArray[i, (int)PatchDataColumnIdx.PatchID];
            float carbon = dataArray[i, (int)PatchDataColumnIdx.Carbon];
            float snow = dataArray[i, (int)PatchDataColumnIdx.Snow];
            float spread = dataArray[i, (int)PatchDataColumnIdx.Spread];
            float iter = dataArray[i, (int)PatchDataColumnIdx.Iter];

            if (patchID == 0)
            {
                Debug.Log(name + ".FormatExtentsData()... patchID == 0... i:" + i + " dataLength:" + dataLength);
                continue;
            }

            if (year > curYear)            // Check if moved to new year (and month)
            {
                if (curYear > -1)
                {
                    dataFrames.Sort();                                                  // Sort frames by month
                    PatchDataMonth dataMonth = new PatchDataMonth(dataFrames, curMonth, curYear, monthCount);
                    dataMonths.Add(dataMonth);                                          // Add month to list
                    monthCount++;

                    PatchDataYear dataYear = new PatchDataYear(dataMonths, curYear);
                    pData.Add(dataYear);                                            // Add year to list

                    dataMonths = new List<PatchDataMonth>();
                    dataFrames = new List<PatchDataFrame>();

                    if (debug && debugDetailed)
                        Debug.Log(name + ".FormatExtentsData()... Set data for curYear:" + curYear + " month:" + month + " patchID:" + patchID + " carbon:" + carbon + " patchData.Count:" + pData.Count);
                }

                curYear = year;
                curMonth = month;
            }

            if (month > curMonth)            // Check if moved to new month in same year
            {
                if (curMonth > -1)
                {
                    dataFrames.Sort();                                                      // Sort frames by month
                    PatchDataMonth dataMonth = new PatchDataMonth(dataFrames, curMonth, curYear, monthCount);
                    dataMonths.Add(dataMonth);                                              // Add month to list
                    monthCount++;

                    curMonth = month;
                    dataFrames = new List<PatchDataFrame>();

                    if (debug && debugDetailed)
                        Debug.Log(name + ".FormatExtentsData()... Set data for month:" + month + " year:" + year + " patchID:" + patchID + " carbon:" + carbon);
                }
            }

            PatchDataFrame frame = new PatchDataFrame(patchID, month, year, carbon, snow, spread, iter);
            dataFrames.Add(frame);

            if (i == dataLength - 2)
            {
                dataFrames.Sort();                                                  // Sort frames by month
                PatchDataMonth dataMonth = new PatchDataMonth(dataFrames, curMonth, curYear, monthCount);
                dataMonths.Add(dataMonth);                                          // Add month to list

                PatchDataYear dataYear = new PatchDataYear(dataMonths, curYear);
                pData.Add(dataYear);                                                // Add year to list
            }
        }

        pData.Sort();                                                     // Sort frame lists by year
        patchesData.Add(pData.ToArray());

        if (debug)
            Debug.Log(name + ".FormatExtentsData()... AFTER GC.GetTotalMemory:" + GC.GetTotalMemory(false) + " patchesData[warmingIdx].Length:" + patchesData[warmingIdx].Length);
    }

    /// <summary>
    /// Creates terrain alphamaps from data by date.
    /// </summary>
    private void GenerateLandscapeData()
    {
        simulationData = new TerrainSimulationData[5];                      // -- TO DO: Use variable rather than constant warming degree count

        for (int i = 0; i < 5; i++)
        {
            List<SnowDataFrame> sDataList = new List<SnowDataFrame>();                  // Snow data frames
            List<FireDataFrame> fDataList = new List<FireDataFrame>();                  // Fire data frames

            foreach (PatchDataYear year in patchesData[i])
            {
                List<PatchDataMonth> months = year.GetMonths();
                foreach (PatchDataMonth month in months)                                // Generate terrain alphamap for each month of patch data
                {
                    List<PatchDataFrame> frames = month.GetFrames();                    // Get patch data frames for month
                    FireDataFrame fireFrame = BuildFireDataFrame(month);

                    if (fireFrame != null)
                        fDataList.Add(fireFrame);
                }

                //Debug.Log(name + ".GenerateLandscapeData()... year:" + year.GetYear() + " last month:" + year.GetMonths().Last().GetMonth());
            }

            int warm = 0;
            switch (i)
            {
                case 0:
                    warm = 0;
                    break;
                case 1:
                    warm = 1;
                    break;
                case 2:
                    warm = 2;
                    break;
                case 3:
                    warm = 4;
                    break;
                case 4:
                    warm = 6;
                    break;
                default:
                    warm = 0;
                    break;
            }

            simulationData[i] = new TerrainSimulationData(sDataList, fDataList, "Thin_0_Warm_" + warm);
            //currentSimulationData = simulationData[i];
        }
    }
    
    /// <summary>
    /// Gets the terrain data frame from patch data for month.
    /// </summary>
    /// <returns>The terrain data frame.</returns>
    /// <param name="dataMonth">First month.</param>
    private FireDataFrame BuildFireDataFrame(PatchDataMonth dataMonth)
    {
        //Terrain t = terrain;
        List<PatchDataFrame> frames = dataMonth.GetFrames();

        int month = dataMonth.GetMonth();
        int year = dataMonth.GetYear();

        int count = 0;                                               // Patch counter
        int frameCt = 0;                                             // Frame count

        List<FireDataPoint> firePointList = new List<FireDataPoint>();
        FireDataPointCollection[,] firePointGrid = new FireDataPointCollection[fireGridCols, fireGridRows];

        foreach (PatchDataFrame frame in frames)                        // Visualize each frame
        {
            int patchID = frame.GetPatchID();

            int ct = 0;                                                 // Temp. patch counter
            int iterRange = 0;                                          // Iteration count

            var patchCollection = patchExtents[patchID];
            List<PatchPoint> points = patchCollection.GetPoints();

            float spreadValue = frame.spread;

            if (Mathf.Abs(spreadValue) > 0.0001)                    // Ignore if fire didn't spread to patch
            {
                int iterValue = (int)frame.iter;

                if (iterRange < iterValue)
                    iterRange = iterValue;

                foreach (PatchPoint point in points)                                               // Loop over points in collection
                {
                    FireDataPoint fdp = new FireDataPoint(point.GetFireGridLocation(), point.GetPatchID(), spreadValue, iterValue);

                    int gridX = (int)point.GetFireGridLocation().x;
                    int gridY = (int)point.GetFireGridLocation().y;

                    if (firePointGrid[gridX, gridY] == null)
                    {
                        firePointGrid[gridX, gridY] = new FireDataPointCollection();
                        firePointGrid[gridX, gridY].AddPoint(fdp);
                    }
                    else
                    {
                        firePointGrid[gridX, gridY].AddPoint(fdp);
                    }

                    firePointList.Add(fdp);
                    ct++;
                }
            }

            count += ct;
            frameCt++;
        }

        if (count > 0)
        {
            firePointList.Sort();

            FireDataFrame fdf = new FireDataFrame(1, month, year, fireGridRows, fireGridCols, firePointList, firePointGrid);
            return fdf;
        }
        else
        {
            //Debug.Log("LandscapeController.BuildFireDataFrame()... count == 0! month:" + month + " year:" + year);
            return null;
        }
    }

    /// <summary>
    /// Loads the chosen data list. (Desktop Version)
    /// </summary>
    //private void LoadDataDesktop()
    //{
    //    TextAsset newPatchesFile = landscapeDataList.patches;
    //    patchExtents = LoadPatchesFile(newPatchesFile);            // Load patches data file

    //    patchesData = new List<PatchDataYear[]>();                 // Initialize patchesData list

    //    for (int i = 0; i < 5; i++)
    //    {
    //        TextAsset newDataFile = landscapeDataList.extents[i];
    //        float[,] extentsData = LoadDataFile(newDataFile);      // Load data file

    //        FormatExtentsData(extentsData);                        // Format patch extents data by date
    //    }

    //    SetPatchDataRanges();                                      // Set data ranges
    //    GenerateLandscapeData();                                   // Generate terrain alphamaps from data

    //    TextAsset newDailyFile = landscapeDataList.streamflowDaily;
    //    LoadStreamflowFile(newDailyFile);             // Load daily streamflow data file

    //    FormatWaterData(waterDataArray);              // Format water data by date
    //    CalculateWaterRanges();                       // Calculate streamflow range

    //    dataFormatted = true;
    //}

    //private void LoadDataWeb()
    //{
    //    if(debug)
    //        Debug.Log("LoadDataWeb()...");

    //    LoadPatchExtentsData();                                // Load patch extents from Resources
    //    LoadLandscapeData();                                   // Load (terrain splatmaps +) fire data from Resources

    //    TextAsset newDailyFile = landscapeDataList.streamflowDaily;
    //    LoadStreamflowFile(newDailyFile);             // Load daily streamflow data file

    //    FormatWaterData(waterDataArray);              // Format water data by date
    //    CalculateWaterRanges();                       // Calculate streamflow range

    //    dataFormatted = true;
    //    dataInitialized = true;

    //    if (debug)
    //        Debug.Log("LoadDataWeb()... Finished");
    //}

    //public FireDataFrame(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth, List<FireDataPoint> newDataList, FireDataPointCollection[,] newDataGrid)
    //{
    //    year = newYear;
    //    month = newMonth;
    //    day = newDay;
    //    dataGrid = newDataGrid;
    //    dataList = newDataList;
    //    gridHeight = newGridHeight;
    //    gridWidth = newGridWidth;
    //}



    /// <summary>
    /// Load and process landscape patches data file (ASC Format).
    /// </summary>
    public Dictionary<int, PatchPointCollection> LoadPatchesFile(TextAsset patchesFile)
    {
        patchExtents = new Dictionary<int, PatchPointCollection>();
        List<string> rawData = TextAssetToList(patchesFile);

        patchDataLength = rawData.Count - 6;                    // Set data length (raw data length - 6 for header lines)
        patchDataLength--;                                      // Ignore white space at end

        northEdge = float.Parse(rawData[0].Split(':')[1]);
        southEdge = float.Parse(rawData[1].Split(':')[1]);
        eastEdge = float.Parse(rawData[2].Split(':')[1]);
        westEdge = float.Parse(rawData[3].Split(':')[1]);

        patchDataRows = int.Parse(rawData[4].Split(':')[1]);
        patchDataCols = int.Parse(rawData[5].Split(':')[1]);

        if (debug)
        {
            Debug.Log("LandscapeController.LoadPatchesFile()... patchesFile:" + patchesFile.name);
            Debug.Log("UTM Boundary: northEdge:" + northEdge + " southEdge:" + southEdge + " eastEdge:" + eastEdge + " westEdge:" + westEdge);
            Debug.Log("Data Array: patchDataRows:" + patchDataRows + " patchDataCols:" + patchDataCols);
        }

        string[] tempData = new string[patchDataCols];                  // Array to store line data

        for (int row = 6; row < patchDataRows + 6; row++)               // Store patch locations in dictionary
        {
            tempData = rawData[row].Split(' ');

            for (int col = 0; col < patchDataCols; col++)
            {
                int idx = int.Parse(tempData[col]);

                if (idx > 0)
                {
                    //Vector2 pos = new Vector2(col, row);
                    if (!patchExtents.ContainsKey(idx))                    // Generate point collection for patch ID
                    {
                        PatchPointCollection collection = new PatchPointCollection(idx);

                        int top = row - 6;
                        int left = col;

                        int r = row;
                        int c;

                        int count = 0;
                        bool reachedLastRow = false;                                  // Whether reached bottom bounds of patch extent
                        while (!reachedLastRow)
                        {
                            string[] tData = rawData[r].Split(' ');                 // Get data for row
                            c = col;                                                // Start at initial column idx
                            int patchIdx = int.Parse(tData[c]);
                            bool foundInRow = patchIdx == idx;

                            //if (idx == 1203612 || idx == 1205276 || idx == 1370056 || idx == 1369922)
                            //Debug.Log(name + ".LoadPatchesFile()... r:" + r + " row:" + row + " c:" + c + " col:" + col+" patchIdx:"+patchIdx+" idx:"+idx + " foundInRow:" + foundInRow);

                            if (r - 6 > top)
                            {
                                while (patchIdx == idx)                                  // Look to left for irregular left edge points
                                {
                                    c--;
                                    if (c < 0)
                                    {
                                        c = -1;
                                        break;
                                    }

                                    patchIdx = int.Parse(tData[c]);
                                }

                                if (foundInRow)
                                {
                                    patchIdx = idx;
                                    c++;                                                 // Return to last point where patch ID matches index 
                                }
                            }

                            if (!foundInRow)                                            // If no matching patch ID to left (inclusive), look to right
                            {
                                c = col;
                                patchIdx = int.Parse(tData[c]);
                                if (patchIdx == idx)
                                {
                                    foundInRow = true;
                                }
                                else
                                {
                                    int ct = 0;
                                    while (patchIdx != idx)                             // Look to right for irregular left edge points
                                    {
                                        //if (idx == 1203612 || idx == 1205276 || idx == 1370056 || idx == 1369922)
                                        //Debug.Log("LandscapeController.LoadPatchesFile()... Looking to right for idx:" + idx);

                                        c++;
                                        if (c >= patchDataCols)
                                        {
                                            reachedLastRow = true;
                                            break;
                                        }

                                        patchIdx = int.Parse(tData[c]);
                                        if (patchIdx == idx)
                                            foundInRow = true;

                                        if (ct++ > 5)
                                            break;
                                    }
                                }
                            }

                            patchIdx = idx;

                            if (foundInRow)                                              // If no matching patchID found in row, then reached end
                            {
                                while (patchIdx == idx)                                  // Add points in first row left-to-right until reached new patchIdx
                                {
                                    Vector2 loc = new Vector2(c, r - 6);
                                    Vector2 fireLoc = GetFireLocationForPatchLocation(loc);
                                    Vector3 utm = MapDataToUTMPosition(loc);
                                    Vector3 alphamapLoc = GetAlphamapPositionForPatchLocation(loc);           // -- TO DO: Optimize by skipping duplicates (if any)
                                    PatchPoint point = new PatchPoint(idx, loc, fireLoc, alphamapLoc, utm);
                                    if (!collection.ContainsPoint(point))
                                    {
                                        collection.AddPoint(point);
                                    }

                                    c++;
                                    if (c >= patchDataCols)                            // Increment column
                                        break;

                                    patchIdx = int.Parse(tData[c]);
                                }

                                r++;                                                     // Increment row

                                if (r >= patchDataRows + 6)
                                {
                                    reachedLastRow = true;
                                    //if (idx == 1203612 || idx == 1205276 || idx == 1370056 || idx == 1369922)
                                    //Debug.Log(name + ".LoadPatchesFile()... Reached last row... r:"+r+ " patchesDataRows + 6:" + (patchesDataRows + 6));
                                }
                            }
                            else
                            {
                                reachedLastRow = true;
                            }

                            if (count++ > 15)
                            {
                                Debug.Log("While loop error: idx:" + idx);
                                reachedLastRow = true;
                                break;
                            }
                        }

                        patchExtents.Add(idx, collection);
                        //if (idx == 1205275 || idx == 1205276 || idx == 1368474 || idx == 1369922)
                        //Debug.Log("Added patchExtents point collection... idx:" + idx + " loc:" + collection.GetPoints()[0].GetLocation() + " collection.GetPoints().Count:" + collection.GetPoints().Count);
                        //if (idx == 1203612 || idx == 1205276 || idx == 1370056 || idx == 1369922)
                        //Debug.Log(">>> collection.GetPoints()[n-1].GetLocation():" + collection.GetPoints()[collection.GetPoints().Count-1].GetLocation());
                    }
                }
            }
        }

        if (debug)
            Debug.Log("LandscapeController.LoadPatchesFile()... Loaded patchesFile:" + patchesFile.name);

        return patchExtents;
    }

    /// <summary>
    /// Gets the next month's patch data.
    /// </summary>
    /// <returns>The next month data.</returns>
    /// <param name="year">Current year.</param>
    /// <param name="month">Current month.</param>
    private PatchDataMonth GetPatchData(int year, int month)
    {
        int idx = year - extentsStartYear;
        if (idx >= 0 && idx < patchesData[warmingIdx].Length)
        {
            PatchDataYear dataYear = patchesData[warmingIdx][idx];
            PatchDataMonth result = dataYear.GetDataForMonth(month);           // Set data for current frame

            //Debug.Log("GetPatchData()... year:" + year + " extentsStartYear:" + extentsStartYear + " idx:" + idx+ " month:"+ month);
            return result;
        }

        return null;
    }

    /// <summary>
    /// Gets the next month's water data.
    /// </summary>
    /// <returns>The next month data.</returns>
    /// <param name="year">Current year.</param>
    /// <param name="month">Current month.</param>
    /// <param name="month">Current day.</param>
    private WaterDataFrame GetWaterData(int year, int month, int day)
    {
        int daysInMonth = GetDaysInMonth(month, year);
        if (day > daysInMonth)
            return null;
        int idx = year - waterStartYear;

        //Debug.Log("GetWaterData()... year:" + year + " waterStartYear:" + waterStartYear+ " idx:"+ idx + " month:" + month + " day:" + day);

        //int idx = year - startYear;
        if (idx >= 0 && idx < waterData.Count)
        {
            WaterDataYear waterYear = waterData[idx];                             // Get data for year
            WaterDataMonth waterMonth = waterYear.GetDataForMonth(month);          // Get data for month
            WaterDataFrame result = waterMonth.GetDataForDay(day);                // Get data for next frame
            return result;
        }

        return null;
    }

    /// <summary>
    /// Gets the net psn for given time index.
    /// </summary>
    /// <returns>The net psn for time.</returns>
    /// <param name="timeIdx">Time index.</param>
    /// <param name="patchID">Patch identifier.</param>
    private float GetNetPsnForTime(int timeIdx, int patchID)
    {
        return 0f;
    }

    /// <summary>
    /// Gets all patch data.
    /// </summary>
    /// <returns>The patch data.</returns>
    public PatchDataYear[] GetPatchesData()
    {
        if (patchesData == null)
        {
            Debug.Log("GetPatchesData()... ERROR patchesData is null.");
            return null;
        }
        if (warmingIdx < 0 || warmingIdx >= patchesData.Count)
        {
            Debug.Log("GetPatchesData()... ERROR warmingIdx out of range... patchesData.Count:"+patchesData.Count+" warmingIdx:"+warmingIdx);
            return null;
        }
        return patchesData[warmingIdx];
    }

    /// <summary>
    /// Check whether patch data exists.
    /// </summary>
    /// <returns>Whether patch data exists</returns>
    public bool PatchDataExists()
    {
        return patchesData != null;
    }

    /// <summary>
    /// Check whether patch data exists.
    /// </summary>
    /// <returns>Whether patch data exists</returns>
    public bool PatchExtentDataExists()
    {
        return patchExtents != null;
    }

    /// <summary>
    /// Gets the patch extents.
    /// </summary>
    /// <returns>The extents data.</returns>
    public Dictionary<int, PatchPointCollection> GetExtentsData()
    {
        return patchExtents;
    }

    /// <summary>
    /// Gets the current landscape data.
    /// </summary>
    /// <returns>The landscape data.</returns>
    public TerrainSimulationData GetCurrentSimulationData()
    {
        if (landscapeSimulationWeb)
        {
            if (currentSimulationData == null)
            {
                Debug.Log("ERROR currentSimulationData == null!");
                return null;
            }

            return currentSimulationData;
        }

        if (simulationData == null)
        {
            Debug.Log("ERROR simulationData == null!");
            return null;
        }
        if (simulationData[warmingIdx] == null)
        {
            Debug.Log("ERROR simulationData[warmingIdx] == null for warmingIdx:" + warmingIdx);
            return null;
        }
        return simulationData[warmingIdx];
    }

    /// <summary>
    /// Patch data for a year, indexed by month.
    /// </summary>
    private class PatchYearData
    {
        public int year;
        public PatchMonthData[] data;          // Index is month (- 1) in year 
        public PatchYearData(int newYear)
        {
            year = newYear;
            data = new PatchMonthData[12];
        }
    }
    #endregion

    #region Terrain
    /// <summary>
    /// Gets the terrain data frame for day in given month data.       
    /// </summary>
    /// <returns>The terrain data frame for day.</returns>
    /// <param name="day">Day to get data frame for.</param>
    /// <param name="firstMonth">Month data.</param>
    /// <param name="secondMonth">Next month data.</param>
    private SnowDataFrame BuildTerrainSplatmapForDay(int day, int year, PatchDataMonth firstMonth, PatchDataMonth secondMonth, float regrowthAmount)
    {
        Terrain t = terrain;

        if (firstMonth == null)
            return null;

        List<PatchDataFrame> frames = firstMonth.GetFrames();
        List<PatchDataFrame> nextFrames;

        if (secondMonth == null)
            nextFrames = frames;
        else
            nextFrames = secondMonth.GetFrames();

        float[,,] lastSplatmap = t.terrainData.GetAlphamaps(0, 0, t.terrainData.alphamapWidth, t.terrainData.alphamapHeight);
        float[,,] splatmapData = new float[t.terrainData.alphamapWidth, t.terrainData.alphamapHeight, t.terrainData.alphamapLayers];

        int month = firstMonth.GetMonth();
        averageSnowAmount = 0f;                       // Reset avg. snow amount

        float pos = MapValue(day, 1, GetDaysInMonth(month, year) + 1, 0f, 1f);     // Find position between current month and next month

        int count = 0;                                // Patch counter
        int frameCt = 0;                              // Frame count

        float[] splatWeights = new float[t.terrainData.alphamapLayers];            // Array to record mix of texture weights 
        float[] splatWeightsBurned = new float[t.terrainData.alphamapLayers];      // Array to record mix of texture weights 

        foreach (PatchDataFrame frame in frames)                                   // Visualize each frame
        {
            int patchID = frame.GetPatchID();

            int ct = 0;                                                            // Patch counter
            float tempSnow = 0f;                                                   // Snow amount used for calculating average

            var patchCollection = patchExtents[patchID];
            PatchDataFrame nextFrame = nextFrames[frameCt];

            float snowValue = Mathf.Clamp(MapValue(frame.snow, 0f, SnowAmountMax, 0f, 1f), 0f, 1f);
            float nextSnowValue = Mathf.Clamp(MapValue(nextFrame.snow, 0f, SnowAmountMax, 0f, 1f), 0f, 1f);
            float snowWeight = Mathf.Lerp(snowValue, nextSnowValue, pos);              // Find interpolated snow value

            snowValue *= snowWeightFactor;

            if (terrainBurning)
            {
                splatWeightsBurned[0] = 0f;                               // Unburnt, zero snow
                splatWeightsBurned[1] = 0f;                               // Unburnt, full snow   
                splatWeightsBurned[2] = 0f;                               // Burnt, full snow
                splatWeightsBurned[3] = 1f;                               // Burnt, zero snow
            }
            else
            {
                snowWeight = Mathf.Clamp(MapValue(snowValue, 0f, snowWeightMax, 0f, 1f), 0f, 1f);

                if (snowWeight > 0.0001f)                           // Some snow
                {
                    if (recentFire)
                    {
                        splatWeightsBurned[0] = (1f - snowWeight) * regrowthAmount;               // Fully recovered, zero snow
                        splatWeightsBurned[1] = snowWeight * regrowthAmount;                      // Fully recovered, full snow
                        splatWeightsBurned[2] = snowWeight * (1f - regrowthAmount);               // Burnt, full snow
                        splatWeightsBurned[3] = (1f - snowWeight) * (1f - regrowthAmount);        // Burnt, zero snow
                    }

                    splatWeights[0] = 1f - snowWeight;              // Unburnt, zero snow
                    splatWeights[1] = snowWeight;                   // Unburnt, full snow   
                    splatWeights[2] = 0f;                           // Burnt, full snow   
                    splatWeights[3] = 0f;                           // Burnt, zero snow
                }
                else                                                // No snow
                {
                    if (recentFire)
                    {
                        splatWeightsBurned[0] = regrowthAmount;            // Fully recovered, zero snow
                        splatWeightsBurned[1] = 0f;                        // Fully recovered, full snow
                        splatWeightsBurned[2] = 0f;                        // Burnt, full snow
                        splatWeightsBurned[3] = 1f - regrowthAmount;       // Burnt, zero snow
                    }

                    splatWeights[0] = 1f;                           // Unburnt, zero snow
                    splatWeights[1] = 0f;                           // Unburnt, full snow
                    splatWeights[2] = 0f;                           // Burnt, full snow
                    splatWeights[3] = 0f;                           // Burnt, zero snow
                }

                float s = splatWeights.Sum();                                             // Calculate normalization factor from sum of weights (Sum of all textures weights must be 1)
                for (int i = 0; i < t.terrainData.alphamapLayers; i++)                    // Loop through each terrain texture
                {
                    if (s > 0f)
                        splatWeights[i] /= s;                                             // Normalize to make sum of all texture weights = 1
                }
            }

            float z = splatWeightsBurned.Sum();                                           // Calculate normalization factor from sum of weights (Sum of all textures weights must be 1)
            for (int i = 0; i < t.terrainData.alphamapLayers; i++)                        // Loop through each terrain texture
            {
                if (z > 0f)
                    splatWeightsBurned[i] /= z;                                           // Normalize to make sum of all texture weights = 1
            }

            float[] weights;

            foreach (PatchPoint point in patchCollection.GetPoints())                     // Loop over points in collection
            {
                Vector2 loc = point.GetAlphamapLocation();                                // -- TO DO: Optimize by skipping duplicates (if any)
                bool pointBurned = false;

                if (burnedAlphamapGrid != null)
                    pointBurned = burnedAlphamapGrid[(int)loc.x, (int)loc.y];

                if (terrainBurning && !pointBurned)                                        // If terrain burning and point didn't burn, keep current texture
                {
                    for (int i = 0; i < t.terrainData.alphamapLayers; i++)                // Loop through each terrain texture
                    {
                        splatmapData[(int)loc.x, (int)loc.y, i] = lastSplatmap[(int)loc.x, (int)loc.y, i];

                        if (!gridMode)                                                    // Remove grid
                        {
                            if ((int)loc.x + 1 < splatmapData.GetLength(0))
                            {
                                splatmapData[(int)loc.x + 1, (int)loc.y, i] = lastSplatmap[(int)loc.x + 1, (int)loc.y, i];
                            }
                            if ((int)loc.y + 1 < splatmapData.GetLength(1))
                            {
                                splatmapData[(int)loc.x, (int)loc.y + 1, i] = lastSplatmap[(int)loc.x, (int)loc.y + 1, i];
                            }
                            if ((int)loc.x + 1 < splatmapData.GetLength(0) && (int)loc.y + 1 < splatmapData.GetLength(1))
                            {
                                splatmapData[(int)loc.x + 1, (int)loc.y + 1, i] = lastSplatmap[(int)loc.x + 1, (int)loc.y + 1, i];
                            }
                        }
                    }

                    ct++;
                    continue;
                }

                if (recentFire && pointBurned)
                {
                    weights = splatWeightsBurned;
                }
                else
                {
                    weights = splatWeights;
                }

                //if (count == 0)
                //    Debug.Log(name + "   patchID:" + patchID + " regrowthAmount:"+ regrowthAmount+" snowWeight:" + snowWeight + " >> s[0]:" + weights[0] + " s[1]:" + weights[1] + " s[2]:" + weights[2] + " s[3]:" + weights[3]);

                for (int i = 0; i < t.terrainData.alphamapLayers; i++)          // Loop through each terrain texture
                {
                    splatmapData[(int)loc.x, (int)loc.y, i] = weights[i];       // Assign this point to the splatmap array

                    if (!gridMode)                                              // Remove grid   -- OPTIMIZE?? ONLY APPLY TO EDGES OF COLLECTION
                    {
                        if ((int)loc.x + 1 < splatmapData.GetLength(0))
                        {
                            splatmapData[(int)loc.x + 1, (int)loc.y, i] = weights[i];
                        }
                        if ((int)loc.y + 1 < splatmapData.GetLength(1))
                        {
                            splatmapData[(int)loc.x, (int)loc.y + 1, i] = weights[i];
                        }
                        if ((int)loc.x + 1 < splatmapData.GetLength(0) && (int)loc.y + 1 < splatmapData.GetLength(1))
                        {
                            splatmapData[(int)loc.x + 1, (int)loc.y + 1, i] = weights[i];
                        }
                    }
                }

                tempSnow += snowValue;
                ct++;
            }

            count += ct;
            averageSnowAmount += tempSnow;

            frameCt++;
        }

        averageSnowAmount /= frameCt;
        SnowDataFrame sdf = new SnowDataFrame(day, month, year, splatmapData, averageSnowAmount);

        return sdf;
    }
    
    /// <summary>
    /// Creates the default splatmap.
    /// </summary>
    public float[,,] CreateUnburntSplatmap()
    {
        TerrainData terrainData = terrain.terrainData;        // Get a reference to the terrain data

        // Splatmap data is stored internally as a 3d array of floats, so declare a new empty array ready for your custom splatmap data:
        float[,,] splatmapData = new float[terrainData.alphamapWidth, terrainData.alphamapHeight, terrainData.alphamapLayers];

        for (int y = 0; y < terrainData.alphamapHeight; y++)
        {
            for (int x = 0; x < terrainData.alphamapWidth; x++)
            {
                // Normalise x/y coordinates to range 0-1 
                float y_01 = (float)y / (float)terrainData.alphamapHeight;
                float x_01 = (float)x / (float)terrainData.alphamapWidth;

                // Sample the height at this location (note GetHeight expects int coordinates corresponding to locations in the heightmap array)
                float height = terrainData.GetHeight(Mathf.RoundToInt(y_01 * terrainData.heightmapResolution), Mathf.RoundToInt(x_01 * terrainData.heightmapResolution));

                // Calculate the normal of the terrain (note this is in normalised coordinates relative to the overall terrain dimensions)
                Vector3 normal = terrainData.GetInterpolatedNormal(y_01, x_01);

                // Calculate the steepness of the terrain
                float steepness = terrainData.GetSteepness(y_01, x_01);

                // Setup an array to record the mix of texture weights at this point
                float[] splatWeights = new float[terrainData.alphamapLayers];

                // Texture[0] Grass (Snow)
                //splatWeights[0] = Mathf.Clamp01((terrainData.heightmapResolution - height));            //  Stronger at lower altitudes
                splatWeights[0] = 0f;

                // Texture[1]  Grass (No Snow)
                splatWeights[1] = 1f;

                // Texture[2] Burnt (Snow)
                splatWeights[2] = 0f;

                // Texture[3] Burnt (No Snow)
                splatWeights[3] = 0f;

                // Sum of all textures weights must add to 1, so calculate normalization factor from sum of weights
                float z = splatWeights.Sum();

                // Loop through each terrain texture
                for (int i = 0; i < terrainData.alphamapLayers; i++)
                {
                    // Normalize so that sum of all texture weights = 1
                    splatWeights[i] /= z;

                    // Assign this point to the splatmap array
                    splatmapData[x, y, i] = splatWeights[i];
                }
            }
        }

        return splatmapData;
    }

    /// <summary>
    /// Resets terrain splatmap.
    /// </summary>
    public void ResetTerrainSplatmap()
    {
        terrain.terrainData.SetAlphamaps(0, 0, unburntSplatmap);
    }

    /// <summary>
    /// Resets the background snow amount to zero.
    /// </summary>
    public void ResetSnow(bool backgroundOnly)
    {
        snowManagerBkgd.snowValue = 0f;
        if(!backgroundOnly)
           snowManager.snowValue = 0f;
    }

    /// <summary>
    /// Shows the landscape snow if currently visible in simulation.
    /// </summary>
    /// <param name="state">Snow visibility state</param>
    public void SetSnowVisibility(bool state)
    {
        Material terrainMaterial = terrain.materialTemplate;

        if (!terrainMaterial.IsKeywordEnabled("_SNOW_AMOUNT"))
            terrainMaterial.EnableKeyword("_SNOW_AMOUNT");

        float value = state ? 1f : 0f;
        //terrainMaterial.SetFloat("_Snow_Amount", value);
        snowManager.snowValue = value;
    }

    /// <summary>
    /// Maps the data to terrain position.
    /// </summary>
    /// <returns>The data to terrain position.</returns>
    /// <param name="dataPosition">Data position.</param>
    public Vector3 MapDataToTerrainPosition(Vector2 dataPosition)
    {
        Vector3 result = MapUTMToTerrainPosition(MapDataToUTMPosition(dataPosition));
        return result;
    }

    /// <summary>
    /// Convert patch data to patch UTM position.
    /// </summary>
    /// <returns>The UTM patch position.</returns>
    /// <param name="dataPosition">Data position.</param>
    public Vector2 MapDataToUTMPosition(Vector2 dataPosition)
    {
        float xPos = MapValue(dataPosition.x, 0, patchDataCols, westEdge, eastEdge);
        float yPos = MapValue(dataPosition.y, 0, patchDataRows, southEdge, northEdge);

        Vector2 result = new Vector2(xPos, yPos);

        //if(debug)
        //Debug.Log("MapDataToUTMPosition()... dataPosition:" + dataPosition + " result:" + result + " patchesDataRows:" + patchesDataRows + " patchesDataCols:" + patchesDataCols + " southEdge:" + southEdge + " northEdge:" + northEdge + " westEdge:" + westEdge + " eastEdge:" + eastEdge);

        return result;
    }

    /// <summary>
    /// Get position on alphamap grid for patch point.
    /// </summary>
    /// <param name="point">Patch point</param>
    /// <returns></returns>
    Vector2 GetAlphamapPositionForPatchLocation(Vector2 point)
    {
        int adjX = (int)MapValue(point.x, 0, patchDataCols, 0, terrain.terrainData.alphamapWidth - 1);
        int adjY = (int)MapValue(point.y, 0, patchDataRows, 0, terrain.terrainData.alphamapHeight - 1);

        int terrainXLoc = (int)Mathf.Clamp(terrain.terrainData.alphamapWidth - 1 - adjX, 0, terrain.terrainData.alphamapWidth - 1);
        int terrainYLoc = (int)Mathf.Clamp(adjY, 0, terrain.terrainData.alphamapHeight);

        return new Vector2(terrainXLoc, terrainYLoc);
    }

    /// <summary>
    /// Converts the UTM to 3D point on large landscape terrain.
    /// </summary>
    /// <returns>Landscpe UTM terrain position.</returns>
    /// <param name="utm">Utm.</param>
    private Vector3 MapUTMToTerrainPosition(Vector2 utm)
    {
        if (utm.x < westEdge || utm.x > eastEdge)
        {
            Debug.Log("ERROR: utm range! utm.x:" + utm.x + " westEdge:" + westEdge + " eastEdge:" + eastEdge);
            return new Vector3(-1000f, -1000f, -1000f);
        }

        if (utm.y < southEdge || utm.y > northEdge)
        {
            Debug.Log("ERROR: utm range! utm.y:" + utm.y + " southEdge:" + southEdge + " northEdge:" + northEdge);
            return new Vector3(-1000f, -1000f, -1000f);
        }

        /* Find terrain height at location */
        float normX = MapValue(utm.x, westEdge, eastEdge, 0f, 1f);
        float normZ = MapValue(utm.y, southEdge, northEdge, 0f, 1f);
        float terrainX = terrain.terrainData.size.x - MapValue(utm.x, westEdge, eastEdge, 0f, terrain.terrainData.size.x);
        float terrainZ = MapValue(utm.y, southEdge, northEdge, 0f, terrain.terrainData.size.z);

        float terrainY = terrain.terrainData.GetInterpolatedHeight(normX, normZ);

        Vector3 result = new Vector3(terrainX, terrainY, terrainZ);

        return result;
    }

    /// <summary>
    /// Gets the world position of UTM Location.
    /// </summary>
    /// <returns>The world position of UTML ocation.</returns>
    /// <param name="utm">Utm.</param>
    public Vector3 GetWorldPositionOfUTMLocation(Vector2 utm)
    {
        Vector3 terrainPos = MapUTMToTerrainPosition(utm);
        Vector3 result = terrain.transform.TransformPoint(terrainPos);      // Convert local to world coordinates
        return result;
    }

    /// <summary>
    /// Gets the patch location in UTM coords.                      // -- TO DO: Get from web
    /// </summary>
    /// <returns>The patch location.</returns>
    /// <param name="patchID">Patch identifier.</param>
    public Vector2 GetPatchUTMLocation(int patchID)             // Usage commented in GameController
    {
        if (patchExtents != null)
        {
            try
            {
                var patchCollection = patchExtents[patchID];
                PatchPoint point = patchCollection.GetPoints()[0];
                return point.GetUTMLocation();
            }
            catch (Exception e)
            {
                Debug.Log("ERROR e:" + e + " patchID:" + patchID + " doesn't exist!");
            }

        }

        Debug.Log("Can't find patchID:" + patchID + " patchExtents == null? " + (patchExtents == null) + " patchData == null? " + (patchesData == null) + " dataFormatted:" + dataFormatted + " patchID:" + patchID);
        return new Vector3(0, 0, 0);
    }

    /// <summary>
    /// Gets the world position of UTM Location.
    /// </summary>
    /// <returns>The world position of UTML ocation.</returns>
    /// <param name="pos">Utm.</param>
    public Vector3 GetWorldPositionOfDataPosition(Vector2 pos)
    {
        Vector3 terrainPos = MapDataToTerrainPosition(pos);
        Vector3 result = terrain.transform.TransformPoint(terrainPos);      // Convert local to world coordinates
        return result;
    }

    /// <summary>
    /// Returns whether the landscape simulation is on.
    /// </summary>
    /// <returns><c>true</c>, if landscape simulation is on, <c>false</c> otherwise.</returns>
    public bool LandscapeSimulationIsOn()
    {
        return landscapeSimulationOn;
    }


    /// <summary>
    /// Returns whether the landscape simulation is on and running Web version.
    /// </summary>
    /// <returns><c>true</c>, if landscape simulation is on, <c>false</c> otherwise.</returns>
    public bool LandscapeWebSimulationIsOn()
    {
        return landscapeSimulationWeb;
    }

    ///// <summary>
    ///// Updates the background snow.
    ///// </summary>
    //private void UpdateBackgroundSnow()
    //{
    //    float value = Mathf.Clamp(MapValue(averageSnowAmount * backgroundSnowFactor, 0f, AvgSnowAmountMax, 0f, 1f), 0f, 1f);
    //    if (float.IsNaN(value))
    //    {
    //        Debug.Log(name + ".UpdateBackgroundSnow()... Value is NaN   avgSnowAmount:" + averageSnowAmount + " backgroundSnowFactor:" + backgroundSnowFactor + " AvgSnowAmountMin:" + AvgSnowAmountMin + " AvgSnowAmountMax:" + AvgSnowAmountMax);
    //        snowManagerBkgd.snowValue = 0f;
    //    }
    //    else
    //        snowManagerBkgd.snowValue = value;

    //    Debug.Log(name + ".UpdateBackgroundSnow()... avgSnowAmount:" + averageSnowAmount + " backgroundSnowFactor:" + backgroundSnowFactor + " AvgSnowAmountMin:" + AvgSnowAmountMin + " AvgSnowAmountMax:" + AvgSnowAmountMax);

    //    //snowManager.snowValue = Mathf.Clamp(MapValue(avgSnowAmount * backgroundSnowFactor, AvgSnowAmountMin, AvgSnowAmountMax, 0f, 1f), 0f, 1f);  // -- TESTING
    //}

    #endregion

    #region NestedClasses
    /// <summary>
    /// Patch data for given month and year, indexed by patch ID.
    /// </summary>
    private class PatchMonthData
    {
        public int month, year;
        public Dictionary<int, PatchDataPoint> data;            // Patch ID, PatchDataPoint
        public PatchMonthData(int newMonth, int newYear)
        {
            month = newMonth;
            year = newYear;
            data = new Dictionary<int, PatchDataPoint>();
        }
    }

    /// <summary>
    /// Single data point for landscape patch.
    /// </summary>
    private class PatchDataPoint
    {
        public int id;
        public int month, year;
        public float snow;
        public float netPhotosynthesis;

        public PatchDataPoint(int newID, int newMonth, int newYear, float newSnow, float newNetPsn)
        {
            id = newID;
            month = newMonth;
            year = newYear;
            snow = newSnow;
            netPhotosynthesis = newNetPsn;
        }
    }

    /// <summary>
    /// Patch data frame.
    /// </summary>
    public class PatchDataFrame : IComparable<PatchDataFrame>
    {
        private int month, year;
        private int patchID;
        public float carbon { get; set; }
        public float snow { get; set; }
        public float spread { get; set; }
        public float iter { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchDataFrame"/> class.
        /// </summary>
        /// <param name="newPatchID">New patch identifier.</param>
        /// <param name="newMonth">New month.</param>
        /// <param name="newYear">New year.</param>
        public PatchDataFrame(int newPatchID, int newMonth, int newYear)
        {
            patchID = newPatchID;
            month = newMonth;
            year = newYear;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchDataFrame"/> class.
        /// </summary>
        /// <param name="newPatchID">New patch identifier.</param>
        /// <param name="newMonth">New month.</param>
        /// <param name="newYear">New year.</param>
        /// <param name="newCarbon">New carbon.</param>
        /// <param name="newSnow">New snow.</param>
        /// <param name="newSpread">New snow.</param>
        /// <param name="newIter">New snow.</param>
        public PatchDataFrame(int newPatchID, int newMonth, int newYear, float newCarbon, float newSnow, float newSpread, float newIter)
        {
            patchID = newPatchID;
            month = newMonth;
            year = newYear;
            carbon = newCarbon;
            snow = newSnow;
            spread = newSpread;
            iter = newIter;
        }

        /// <summary>
        /// Compares patch ID of this frame to given frame's patch ID.
        /// </summary>
        /// <returns>The comparison result.</returns>
        /// <param name="that">Patch to compare to.</param>
        public int CompareTo(PatchDataFrame that)
        {
            return this.GetMonth().CompareTo(that.GetMonth());
        }

        public int GetPatchID()
        {
            return patchID;
        }

        public int GetMonth()
        {
            return month;
        }

        public int GetYear()
        {
            return year;
        }
    }

    /// <summary>
    /// List of PatchDataFrame objects sorted by month.
    /// </summary>
    public class PatchDataMonth : IComparable<PatchDataMonth>
    {
        private int index;
        private int month, year;
        private List<PatchDataFrame> dataFrames;

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchDataMonth"/> class.
        /// </summary>
        /// <param name="newDataFrames">New data frames.</param>
        /// <param name="newMonth">New month.</param>
        /// <param name="newYear">New year.</param>
        public PatchDataMonth(List<PatchDataFrame> newDataFrames, int newMonth, int newYear, int newIndex)
        {
            dataFrames = newDataFrames;
            month = newMonth;
            year = newYear;
            index = newIndex;
        }

        public int CompareTo(PatchDataMonth that)
        {
            return this.GetMonth().CompareTo(that.GetMonth());
        }

        public int GetMonth()
        {
            return month;
        }

        public int GetYear()
        {
            return year;
        }

        public int GetIndex()
        {
            return index;
        }

        public List<PatchDataFrame> GetFrames()
        {
            return dataFrames;
        }

        public void ClearFrames()
        {
            dataFrames = null;
        }
    }

    /// <summary>
    /// List of PatchDataMonth objects sorted by year.
    /// </summary>
    public class PatchDataYear : IComparable<PatchDataYear>
    {
        private int year;
        private List<PatchDataMonth> dataMonths;

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchDataYear"/> class.
        /// </summary>
        /// <param name="newDataFrames">New data frames.</param>
        /// <param name="newYear">New year.</param>
        public PatchDataYear(List<PatchDataMonth> newDataFrames, int newYear)
        {
            dataMonths = newDataFrames;
            year = newYear;
            //Debug.Log("New PatchDataYear()... newDataFrames:" + newDataFrames.Count+" year:"+newYear);
            //Debug.Log("New PatchDataYear()... dataMonths[0].GetFrames()[1].GetPatchID():" + dataMonths[0].GetFrames()[1].GetPatchID());
        }
        public int CompareTo(PatchDataYear that)
        {
            return this.GetYear().CompareTo(that.GetYear());
        }

        public int GetYear()
        {
            return year;
        }

        /// <summary>
        /// Gets the data for month.
        /// </summary>
        /// <returns>The data for month.</returns>
        /// <param name="month">Month.</param>
        public PatchDataMonth GetDataForMonth(int month)
        {
            if (dataMonths.Count < 12)                       // Check for incomplete year data
            {
                if (dataMonths[0].GetMonth() > 1)
                {
                    int startMonth = dataMonths[0].GetMonth();
                    month = month - startMonth + 1;
                }
            }

            if (month > 0 && month <= dataMonths.Count)
            {
                return dataMonths[month - 1];
            }
            else
            {
                Debug.Log("WaterDataYear.GetDataForMonth()... ERROR: year:" + year + " month:" + month + " dataMonths:" + dataMonths.Count);
                return null;
            }
            //Debug.Log("GetDataForMonth()... year:"+year+" month:" + month + " dataMonths:" + dataMonths.Count);
            //return dataMonths[month - 1];
        }

        public List<PatchDataMonth> GetMonths()
        {
            return dataMonths;
        }
    }

    #endregion

    #region Utilities

    /// <summary>
    /// Text asset to list.
    /// </summary>
    /// <returns>The asset to list.</returns>
    /// <param name="ta">Ta.</param>
    private List<string> TextAssetToList(TextAsset ta)
    {    // Convert TextAsset to list
        return new List<string>(ta.text.Split('\n'));
    }

    /// <summary>
    /// Formats data string from Landscape CSV data file
    /// </summary>
    /// <returns>The CSVS tring.</returns>
    /// <param name="str">String.</param>
    private string FormatCSVString(string str)
    {
        return new string((from c in str
                           where char.IsWhiteSpace(c) || char.IsLetterOrDigit(c)
                           select c).ToArray());
    }

    /// <summary>
    /// Maps value from one range to another.
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="value">Value.</param>
    /// <param name="from1">From1.</param>
    /// <param name="to1">To1.</param>
    /// <param name="from2">From2.</param>
    /// <param name="to2">To2.</param>
    public static float MapValue(float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }

    /// <summary>
    /// Gets the days in given month.
    /// </summary>
    /// <returns>The days in month.</returns>
    /// <param name="month">Month.</param>
    /// <param name="year">Year.</param>
    public int GetDaysInMonth(int month, int year)
    {
        bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        int days = 0;

        switch (month)
        {
            case 1:
                days = 31;
                break;
            case 2:
                if (isLeapYear)
                    days = 29;
                else
                    days = 28;
                break;
            case 3:
                days = 31;
                break;
            case 4:
                days = 30;
                break;
            case 5:
                days = 31;
                break;
            case 6:
                days = 30;
                break;
            case 7:
                days = 31;
                break;
            case 8:
                days = 31;
                break;
            case 9:
                days = 30;
                break;
            case 10:
                days = 31;
                break;
            case 11:
                days = 30;
                break;
            case 12:
                days = 31;
                break;
            default:
                days = 0;
                break;
        }
        return days;
    }


    ///// <summary>
    ///// Get an array containing the relative mix of textures on the main terrain at this world position.
    ///// </summary>
    ///// <param name="worldPos"></param>
    ///// <returns></returns>
    //private float[] GetTextureMix(Vector3 worldPos)
    //{
    //    Vector3 terrainPos = terrain.transform.position;
    //    TerrainData terrainData = terrain.terrainData;

    //    // calculate which splat map cell the worldPos falls within (ignoring y)
    //    int mapX = (int)(((worldPos.x - terrainPos.x) / terrainData.size.x) * terrainData.alphamapWidth);
    //    int mapZ = (int)(((worldPos.z - terrainPos.z) / terrainData.size.z) * terrainData.alphamapHeight);

    //    // get the splat data for this cell as a 1x1xN 3d array (where N = number of textures)
    //    float[,,] splatmapData = terrainData.GetAlphamaps(mapX, mapZ, 1, 1);

    //    // extract the 3D array data to a 1D array:
    //    float[] cellMix = new float[splatmapData.GetUpperBound(2) + 1];

    //    for (int n = 0; n < cellMix.Length; n++)
    //    {
    //        cellMix[n] = splatmapData[0, 0, n];
    //    }
    //    return cellMix;
    //}

    //private int GetMainTexture(Vector3 worldPos)
    //{
    //    // returns the zero-based index of the most dominant texture
    //    // on the main terrain at this world position.
    //    float[] mix = GetTextureMix(worldPos);

    //    float maxMix = 0;
    //    int maxIndex = 0;

    //    // loop through each mix value and find the maximum
    //    for (int n = 0; n < mix.Length; n++)
    //    {
    //        if (mix[n] > maxMix)
    //        {
    //            maxIndex = n;
    //            maxMix = mix[n];
    //        }
    //    }
    //    return maxIndex;
    //}

    private FireDataFrameRecord ConvertFireDataFrameToRecord(FireDataFrame fdf)
    {
        FireDataFrameRecord record = new FireDataFrameRecord(fdf.GetDay(), fdf.GetMonth(), fdf.GetYear(), fdf.GetGridHeight(),
            fdf.GetGridWidth(), fdf.GetDataList());
        return record;
    }

    private FireDataFrame ConvertFireDataFrameRecordToFrame(FireDataFrameRecord record)
    {
        try
        {
            FireDataFrame fdf = new FireDataFrame(record.GetDay(), record.GetMonth(), record.GetYear(),
                record.GetGridHeight(),
                record.GetGridWidth(), record.GetDataList(), record.GetDataGrid());
            return fdf;
        }
        catch (Exception ex)
        {
            Debug.Log("ConvertFireDataFrameRecordToFrame()... ERROR ex:"+ex.Message);
        }

        return null;
    }

    #endregion
}

#region Classes
///// <summary>
///// Patch point collection.
///// </summary>
//[Serializable]
//public class PatchPointCollection
//{
//    private int patchID;
//    List<PatchPoint> points;                // Points in collection

//    /// <summary>
//    /// Initializes a new instance of the <see cref="T:LandscapeController.PatchPointCollection"/> class.
//    /// </summary>
//    public PatchPointCollection(int newPatchID)
//    {
//        patchID = newPatchID;
//        points = new List<PatchPoint>();
//    }

//    /// <summary>
//    /// Adds point to collection.
//    /// </summary>
//    /// <param name="newPoint">New point.</param>
//    public void AddPoint(PatchPoint newPoint)
//    {
//        points.Add(newPoint);
//    }

//    /// <summary>
//    /// Adds point to collection.
//    /// </summary>
//    /// <param name="newPoint">New point.</param>
//    public bool ContainsPoint(PatchPoint newPoint)
//    {
//        return points.Contains(newPoint);
//    }

//    /// <summary>
//    /// Clears the points.
//    /// </summary>
//    public void ClearPoints()
//    {
//        points = new List<PatchPoint>();
//    }

//    /// <summary>
//    /// Gets the points.
//    /// </summary>
//    /// <returns>The points.</returns>
//    public List<PatchPoint> GetPoints()
//    {
//        return points;
//    }

//    /// <summary>
//    /// Gets the patch identifier.
//    /// </summary>
//    /// <returns>The patch identifier.</returns>
//    public int GetPatchID()
//    {
//        return patchID;
//    }
//}

///// <summary>
///// Point on terrain splatmap associated with a patch ID.
///// </summary>
//[Serializable]
//public class PatchPoint
//{
//    private int patchID;
//    private Vector2 location;           // Patch grid location (col, row in data file)
//    private Vector2 fireLocation;       // Fire grid location
//    private Vector2 alphamapLoc;        // Alphamap grid location
//    private Vector3 utm;                // UTM location
        
//    /// <summary>
//    /// Initializes a new instance of the <see cref="T:LandscapeController.PatchPoint"/> class.
//    /// </summary>
//    /// <param name="newPatchID">New patch identifier.</param>
//    /// <param name="newLocation">New location.</param>
//    /// <param name="newUTM">New utm.</param>
//    public PatchPoint(int newPatchID, Vector2 newLocation, Vector2 newFireLocation, Vector2 newAlphamapLocation, Vector3 newUTM)
//    {
//        patchID = newPatchID;
//        location = newLocation;
//        fireLocation = newFireLocation;
//        alphamapLoc = newAlphamapLocation;
//        utm = newUTM;
//    }

//    /// <summary>
//    /// Gets the patch identifier.
//    /// </summary>
//    /// <returns>The patch identifier.</returns>
//    public int GetPatchID()
//    {
//        return patchID;
//    }

//    ///// <summary>
//    ///// Gets the patch grid location.
//    ///// </summary>
//    ///// <returns>The location.</returns>
//    //public Vector2 GetLocation()
//    //{
//    //    return location;
//    //}

//    /// <summary>
//    /// Gets the fire grid location.
//    /// </summary>
//    /// <returns>The location.</returns>
//    public Vector2 GetFireGridLocation()
//    {
//        return fireLocation;
//    }

//    /// <summary>
//    /// Gets the alphamap location.
//    /// </summary>
//    /// <returns>The location.</returns>
//    public Vector2 GetAlphamapLocation()
//    {
//        return alphamapLoc;
//    }

//    /// <summary>
//    /// Gets X coord.
//    /// </summary>
//    /// <returns>The x.</returns>
//    public int X()
//    {
//        return (int)location.x;
//    }
//    /// <summary>
//    /// Gets Y coord.
//    /// </summary>
//    /// <returns>The y.</returns>
//    public int Y()
//    {
//        return (int)location.y;
//    }

//    /// <summary>
//    /// Gets the UTM Location.
//    /// </summary>
//    /// <returns>The UTML ocation.</returns>
//    public Vector3 GetUTMLocation()
//    {
//        return utm;
//    }
//}

/// <summary>
/// Data point on fire grid associated with a PatchPoint.
/// </summary>
[Serializable]
public class FireDataPoint : IComparable<FireDataPoint>
{
    public Vector2 gridLocation;
    public int patchId;
    public float spread;
    public int iter;

    /// <summary>
    /// Constructor 
    /// </summary>
    /// <param name="patchPoint">Position in terrain alphamap grid</param>
    /// <param name="newSpread"></param>
    /// <param name="newIter"></param>
    public FireDataPoint(Vector2 newGridLocation, int newPatchId, float newSpread, int newIter)
    {
        gridLocation = newGridLocation;
        patchId = newPatchId;
        spread = newSpread;
        iter = newIter;

        //gridLocation = patchPoint.GetFireGridLocation();
        //patchId = patchPoint.GetPatchID();
    }

    ///// <summary>
    ///// Constructor 
    ///// </summary>
    ///// <param name="patchPoint">Position in terrain alphamap grid</param>
    ///// <param name="newSpread"></param>
    ///// <param name="newIter"></param>
    //public FireDataPoint(PatchPoint patchPoint, float newSpread, int newIter)
    //{
    //    spread = newSpread;
    //    iter = newIter;

    //    gridLocation = patchPoint.GetFireGridLocation();
    //    patchId = patchPoint.GetPatchID();
    //}

    //public PatchPoint GetPatchPoint()
    //{
    //    return patchPoint;
    //}

    public Vector2 GetGridPosition()
    {
        return gridLocation;
        //return patchPoint.GetFireGridLocation();
    }

    /// <summary>
    /// Gets X coord.
    /// </summary>
    /// <returns>The x.</returns>
    public int X()
    {
        return (int)gridLocation.x;
        //return (int)patchPoint.GetFireGridLocation().x;
    }

    /// <summary>
    /// Gets Y coord.
    /// </summary>
    /// <returns>The y.</returns>
    public int Y()
    {
        return (int)gridLocation.y;
        //return (int)patchPoint.GetFireGridLocation().y;
    }

    public float GetSpread()
    {
        return spread;
    }

    public int GetIter()
    {
        return iter;
    }

    public int GetPatchID()
    {
        return patchId;
        //return patchPoint.GetPatchID();
    }

    public int CompareTo(FireDataPoint that)
    {
        return this.GetIter().CompareTo(that.GetIter());
    }
}

/// <summary>
/// Collection of fire data points
/// </summary>
[Serializable]
public class FireDataPointCollection
{
    public List<FireDataPoint> points;

    public FireDataPointCollection()
    {
        points = new List<FireDataPoint>();
    }

    public void AddPoint(FireDataPoint newPoint)
    {
        points.Add(newPoint);
    }

    public List<FireDataPoint> GetPoints()
    {
        return points;
    }
}

/// <summary>
/// Terrain fire data frame.
/// </summary>
public class FireDataFrame
{
    public FireDataPointCollection[,] dataGrid;
    //public FireDataPointCollection[] dataGrid;
    public List<FireDataPoint> dataList;
    public int year, month, day;
    public int gridHeight;
    public int gridWidth;

    public FireDataFrame(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth, List<FireDataPoint> newDataList, FireDataPointCollection[,] newDataGrid)
    {
        year = newYear;
        month = newMonth;
        day = newDay;
        //dataGrid = Flatten2DArrayTo1D(newDataGrid);
        dataGrid = newDataGrid;
        dataList = newDataList;
        gridHeight = newGridHeight;
        gridWidth = newGridWidth;
    }

    public int GetYear()
    {
        return year;
    }
    public int GetMonth()
    {
        return month;
    }
    public void SetDay(int newDay)
    {
        day = newDay;
    }
    public int GetDay()
    {
        return day;
    }
    public int GetGridHeight()
    {
        return gridHeight;
    }
    public int GetGridWidth()
    {
        return gridWidth;
    }

    public FireDataPointCollection[,] GetDataGrid()
    {
        return dataGrid;
    }

    public List<FireDataPoint> GetDataList()
    {
        return dataList;
    }

    public void OptimizeData()
    {
        FireDataPointCollection[,] newDataGrid = new FireDataPointCollection[gridWidth, gridHeight];
        List<FireDataPoint> newDataList = new List<FireDataPoint>();

        for (int x = 0; x < gridWidth; x++)
        {
            for (int y = 0; y < gridHeight; y++)
            {
                int iter = 0;
                float size = 0f;
                int patchId = -1;
                FireDataPointCollection coll = dataGrid[x, y];
                if (coll == null)
                {
                    Debug.Log("OptimizeData() WARNING coll == null?: " + (coll == null));

                    coll = new FireDataPointCollection();
                }

                if (coll.GetPoints() == null)
                {
                    Debug.Log("coll.GetPoints() == null? " + (coll.GetPoints() == null));
                    coll.points = new List<FireDataPoint>();
                }

                foreach (FireDataPoint p in coll.GetPoints())
                {
                    iter += p.GetIter();

                    float fireSizeFactor = 5f;                  // -- TO DO: MOVE TO SETTINGS
                    size += p.GetSpread() * fireSizeFactor;

                    patchId = p.patchId;
                }

                if (patchId == -1)
                {
                    Debug.Log("NO PatchId");
                }
                FireDataPointCollection newColl = new FireDataPointCollection();
                FireDataPoint fdp = new FireDataPoint(new Vector2(x, y), patchId, size, iter);
                newColl.AddPoint(fdp);
                newDataList.Add(fdp);
                newDataGrid[x, y] = newColl;
            }
        }

        dataGrid = newDataGrid;
        dataList = newDataList;
    }


    //public FireDataPointCollection[] Flatten2DArrayTo1D(FireDataPointCollection[,] grid)
    //{
    //    FireDataPointCollection[] flatArray = new FireDataPointCollection[grid.GetLength(0) * grid.GetLength(1)];

    //    string str = "";

    //    int i = 0;
    //    for (int a = 0; a < grid.GetLength(0); a++)
    //    {
    //        for (int b = 0; b < grid.GetLength(1); b++)
    //        {
    //            flatArray[i++] = grid[a, b];
    //            if (i < 100)
    //                str += "a: "+a+" b:"+b+ " val: " + grid[a, b] + " __ ";
    //        }
    //    }

    //    Debug.Log("Flatten2DArrayTo1D()... flatArray length:" + flatArray.Length+ "   str: "+str);

    //    return flatArray;
    //}

    //public FireDataPointCollection[,] Unflatten1DArrayTo2D(FireDataPointCollection[] array, int xCount, int yCount)
    //{
    //    string str = "";

    //    var output = new FireDataPointCollection[xCount, yCount];
    //    var i = 0;
    //    for (var a = 0; a < xCount; a++)
    //    {
    //        for (var b = 0; b < yCount; b++)
    //        {
    //            output[a, b] = array[i++];
    //            if (i < 100)
    //                str += "a: " + a + " b:" + b + " val: " + output[a, b] + " __ ";
    //        }
    //    }

    //    Debug.Log("Unflatten1DArrayTo2D()... output length:" + output.Length + "   str: " + str);

    //    return output;
    //}
}

/// <summary>
/// Terrain fire data frame record (for serialization).
/// </summary>
[Serializable]
public class FireDataFrameRecord
{
    public List<FireDataPoint> dataList;              
    public int year, month, day;
    public int gridHeight;
    public int gridWidth;

    public FireDataFrameRecord(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth, List<FireDataPoint> newDataList)//, FireDataPointCollection[,] newDataGrid)
    {
        year = newYear;
        month = newMonth;
        day = newDay;
        dataList = newDataList;
        gridHeight = newGridHeight;
        gridWidth = newGridWidth;
    }

    public int GetYear()
    {
        return year;
    }
    public int GetMonth()
    {
        return month;
    }
    //public void SetDay(int newDay)
    //{
    //    day = newDay;
    //}
    public int GetDay()
    {
        return day;
    }

    public int GetGridHeight()
    {
        return gridHeight;
    }

    public int GetGridWidth()
    {
        return gridWidth;
    }

    public FireDataPointCollection[,] GetDataGrid()
    {
        FireDataPointCollection[,] firePointGrid = new FireDataPointCollection[gridWidth, gridHeight];

        for (int x = 0; x < gridWidth; x++)
        {
            for (int y = 0; y < gridHeight; y++)
            {
                firePointGrid[x, y] = new FireDataPointCollection();
            }
        }

        foreach (FireDataPoint fdp in dataList)                                            // Loop over points in collection
        {
            if (Mathf.Abs(fdp.spread) > 0.0001) // Ignore if fire didn't spread to patch
            {
                int gridX = (int)fdp.GetGridPosition().x; //(int)point.GetFireGridLocation().x;
                int gridY = (int)fdp.GetGridPosition().y; //(int)point.GetFireGridLocation().y;
                firePointGrid[gridX, gridY].AddPoint(fdp);
            }
        }

        return firePointGrid;
    }

    public List<FireDataPoint> GetDataList()
    {
        return dataList;
    }
}

/// <summary>
/// Terrain snow data frame.
/// </summary>
[Serializable]
public class SnowDataFrame
{
    int year, month, day;
    float[,,] data;
    float avgSnow;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:LandscapeController.TerrainDataFrame"/> class.
    /// </summary>
    /// <param name="newDay">New day.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    /// <param name="newData">New data.</param>
    /// <param name="newAvgSnow">New average snow.</param>
    public SnowDataFrame(int newDay, int newMonth, int newYear, float[,,] newData, float newAvgSnow)
    {
        day = newDay;
        month = newMonth;
        year = newYear;
        data = newData;
        avgSnow = newAvgSnow;

        if (float.IsNaN(avgSnow))
            avgSnow = 0f;
    }

    public float[,,] GetData()
    {
        return data;
    }
    public int GetYear()
    {
        return year;
    }
    public int GetMonth()
    {
        return month;
    }
    public int GetDay()
    {
        return day;
    }
    public float GetAverageSnow()
    {
        return avgSnow;
    }
}

/// <summary>
/// Water data frame.
/// </summary>
[Serializable]
public class WaterDataFrame : IComparable<WaterDataFrame>
{
    public int index;
    public int year, month, day;
    public float QBase { get; set; }
    public float QWarm1 { get; set; }
    public float QWarm2 { get; set; }
    public float QWarm4 { get; set; }
    public float QWarm6 { get; set; }
    public float precipitation { get; set; }

    /// <summary>
    /// Initializes a new instance of the <see cref="T:LandscapeController.WaterDataFrame"/> class.
    /// </summary>
    /// <param name="newYear">New year.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newDay">New day.</param>
    /// <param name="newQBase">New streamflow.</param>
    /// <param name="newPrecipitation">New precipitation.</param>
    /// <param name="newIndex">New index.</param>
    public WaterDataFrame(int newYear, int newMonth, int newDay, float newPrecipitation, float newQBase, float newQWarm1, float newQWarm2, float newQWarm4, float newQWarm6, int newIndex)
    {
        index = newIndex;
        year = newYear;
        month = newMonth;
        day = newDay;
        QBase = newQBase;
        QWarm1 = newQWarm1;
        QWarm2 = newQWarm2;
        QWarm4 = newQWarm4;
        QWarm6 = newQWarm6;
        precipitation = newPrecipitation;
    }

    public int CompareTo(WaterDataFrame that)
    {
        return this.GetIndex().CompareTo(that.GetIndex());
    }

    /// <summary>
    /// Gets the index of the streamflow for warming.
    /// </summary>
    /// <returns>The streamflow for warming index.</returns>
    /// <param name="warmIdx">Warm index.</param>
    public float GetStreamflowForWarmingIdx(int warmIdx)
    {
        switch (warmIdx)
        {
            case 0:
                return QBase;
            case 1:
                return QWarm1;
            case 2:
                return QWarm2;
            case 3:
                return QWarm4;
            case 4:
                return QWarm6;
            default:
                return QBase;
        }
    }

    public int GetDay()
    {
        return day;
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetYear()
    {
        return year;
    }

    public int GetIndex()
    {
        return index;
    }
}

/// <summary>
/// List of WaterDataFrame objects sorted by month.
/// </summary>
[Serializable]
public class WaterDataMonth : IComparable<WaterDataMonth>
{
    public int index;
    public int month, year;
    public List<WaterDataFrame> dataFrames;

    /// <summary>
    /// Initializes a new instance of the <see cref="T:LandscapeController.PatchDataMonth"/> class.
    /// </summary>
    /// <param name="newDataFrames">New data frames.</param>
    /// <param name="newMonth">New month.</param>
    /// <param name="newYear">New year.</param>
    public WaterDataMonth(List<WaterDataFrame> newDataFrames, int newMonth, int newYear)
    {
        dataFrames = newDataFrames;
        month = newMonth;
        year = newYear;
        //index = newIndex;
    }

    public int CompareTo(WaterDataMonth that)
    {
        return this.GetMonth().CompareTo(that.GetMonth());
    }

    public int GetMonth()
    {
        return month;
    }

    public int GetYear()
    {
        return year;
    }

    public WaterDataFrame GetDataForDay(int day)
    {
        if (day < 0 || day > dataFrames.Count)
            return null;
        else
            return dataFrames[day - 1];
    }

    public List<WaterDataFrame> GetFrames()
    {
        return dataFrames;
    }
}

/// <summary>
/// List of WaterDataMonth objects sorted by year.
/// </summary>
[Serializable]
public class WaterDataYear : IComparable<WaterDataYear>
{
    public int year;
    public List<WaterDataMonth> dataMonths;

    public WaterDataYear(List<WaterDataMonth> newDataFrames, int newYear)
    {
        dataMonths = newDataFrames;
        year = newYear;

        //Debug.Log("WaterDataYear()... dataMonths[0].GetFrames()[0].GetPatchID():" + dataMonths[0].GetFrames()[0].GetPatchID());
        //Debug.Log("WaterDataYear()... dataMonths[0].GetFrames()[1].GetPatchID():" + dataMonths[0].GetFrames()[1].GetPatchID());
    }

    public int CompareTo(WaterDataYear that)
    {
        return this.GetYear().CompareTo(that.GetYear());
    }

    public int GetYear()
    {
        return year;
    }

    /// <summary>
    /// Gets the data for month.
    /// </summary>
    /// <returns>The data for month.</returns>
    /// <param name="month">Month.</param>
    public WaterDataMonth GetDataForMonth(int month)
    {
        if (dataMonths.Count < 12)                       // Check for incomplete year data
        {
            if (dataMonths[0].GetMonth() > 1)
            {
                int startMonth = dataMonths[0].GetMonth();
                month = month - startMonth + 1;
            }
        }

        if (month > 0 && month <= dataMonths.Count)
        {
            return dataMonths[month - 1];
        }
        else
        {
            Debug.Log("WaterDataYear.GetDataForMonth()... ERROR: year:" + year + " month:" + month + " dataMonths:" + dataMonths.Count);
            return null;
        }
    }

    public List<WaterDataMonth> GetMonths()
    {
        return dataMonths;
    }

    /// <summary>
    /// Get total precipitation for year
    /// </summary>
    /// <returns></returns>
    public float GetTotalPrecipitation()
    {
        float result = 0f;
        foreach (WaterDataMonth month in dataMonths)
        {
            foreach (WaterDataFrame frame in month.GetFrames())
            {
                result += frame.precipitation;
            }
        }
        return result;
    }

    /// <summary>
    /// Get total streamflow
    /// </summary>
    /// <returns></returns>
    public float GetTotalStreamflow(int warmIdx)
    {
        float result = 0f;
        foreach (WaterDataMonth month in dataMonths)
        {
            foreach (WaterDataFrame frame in month.GetFrames())
            {
                result += frame.GetStreamflowForWarmingIdx(warmIdx);
            }
        }
        return result;
    }
}

/// <summary>
/// Terrain simulation data.
/// </summary>
[Serializable]
public class TerrainSimulationData
{
    List<SnowDataFrame> snowData;               // Currently unused?
    List<FireDataFrame> fireData;
    string name;

    public TerrainSimulationData(List<SnowDataFrame> newSnowData, List<FireDataFrame> newFireData, string newName)
    {
        name = newName;
        snowData = newSnowData;
        fireData = newFireData;
    }

    //public void SetWaterData(WaterDataYear[] newWaterData)
    //{
    //    wData = newWaterData;
    //}

    public List<SnowDataFrame> GetSnowData()
    {
        return snowData;
    }

    public List<FireDataFrame> GetFireData()
    {
        return fireData;
    }

    public bool HasPreloadedSnowData()
    {
        return !(snowData == null);
    }

    //public WaterDataYear[] GetWaterData()
    //{
    //    return wData;
    //}

    public string GetName()
    {
        return name;
    }
}
#endregion