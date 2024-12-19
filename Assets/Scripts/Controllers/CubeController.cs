using System;
using Assets.Scripts.Models;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;
using Random = UnityEngine.Random;
using Unity.VisualScripting.Antlr3.Runtime.Tree;

/// <summary>
/// Cube controller.
/// </summary>
public class CubeController : MonoBehaviour
{
    [Header("Debugging")]
    /* Debug Settings */
    private bool debugCubes = false;             // Debug Sample Cube specific methods
    private bool debugAggregate = false;         // Debug Aggregate Cube specific methods
    private bool debugDetailed = false;          // Debug Detailed

    private int whileLoopMaxCount = 50;         // For loop debugging
    private static string debugOutputPath = "/Users/davidgordon/Desktop/debug.txt";     // Debug output filepath
    public UI_MessageManager messageManager { get; set; }         // Message manager

    /* Debug Modes */
    public bool debugTrees = false;             // Debug Tree Trunks + Leaves 
    public bool debugRoots = false;             // Debug Tree Roots 
    public bool debugShrubs = false;            // Debug Shrubs
    public bool debugLitter = false;            // Debug Litter
    public bool debugFire = false;              // Debug Fire
    public bool debugStream = false;            // Debug Stream

    #region Fields
    /* General */
    private bool firstRun = true;               // First simulation run flag

    [Header("General")]
    public bool simulationOn = false;          // Is this cube active in the simulation?
    public bool isAggregate = false;                         // Flag for aggregate cube
    public int patchID = -1;                                 // Patch ID
    public bool isSideCube = false;                          // Flag for side cube

    /* Objects */
    public GameObject cubeObject;                            // Cube base containing all cube parts (except glass)
    public GameObject cubeLabel;                // Cube label
    private List<ParticleSystem.EmissionModule> emissions;                // List of all ET emitting objects in cube
    public GameObject housePrefab;             // House to spawn

    private GameObject houseObj;

    /* Vegetation Prefabs */
    [Header("Vegetation Prefabs")]
    public VegetationList vegetation;            // All vegetation game objects in cube
    private List<List<GameObject>> treeList;     // List of tree game object lists
    private List<List<GameObject>> shrubList;    // List of shrub game object lists
    private List<GameObject> shrubPrefabs;       // Shrub prefabs           // -- TEMPORARY      

    public GameObject deadTreePrefab;            // Dead tree prefab            
    public GameObject grassPrefab;               // Grass prefab
    private GameObject etPrefab;                 // ET emitter prefab
    private GameObject shrubETPrefab;            // Shrub ET emitter

    [Header("Roots + Soil")]
    public List<GameObject> rootsPrefabs;        // Root prefabs (least grown to full-grown) 
    private GameObject rainToGWPrefab;           // Prefab for particle system of rain seeping into ground
    private WaterToGWController precipToGWController;

    /* Animation */
    [Header("Animation")]
    public GameObject animationPrefab;           // Cube animation prefab
    private GameObject animated;                 // Animated cube object
    private Vector3 animatedCubeFullScale;       // Animated cube full scale

    /* Fire */
    [Header("Fire")]
    public GameObject fireNodeChainPrefab;       // ET emitter prefab
    public GameObject firePrefab;               // Ground fire prefab

    private float fireDetectionThreshold = 0.2f; // Ratio of (tree) carbon in data to visualized carbon under which fire is detected (ignited)  -- OBSOLETE
    private float fireDetectionMinCarbon = 10f;  // Ratio of (tree) carbon in data to visualized carbon under which fire is detected (ignited)  -- OBSOLETE
    public int fireGrassRegrowthLength = 120;    // Frames to regrow grass   -- TEMP.
    [SerializeField]
    private bool terrainBurning = false;         // Cube terrain is currently burning
    [SerializeField]
    private bool terrainBurnt = false;           // Burnt terrain flag
    public float lastBurnEndedTime = -1f;        // Time last burn ended
    private int fireRegrowthStartTimeIdx;        // Time idx when last fire ended

    private int minTreesBurnedToShowFire = 2;
    private int minShrubsBurnedToShowFire = 5;

    private GameObjectPool pooler;
    private SERI_FireManager fireManager;                                   // Fire Manager
    private Vector3 fireGridCenterLocation = new Vector3(24f, 0f, 0f);             // Fire Ignition location   -- TEMP.

    private SERI_FireGrid fireGrid;              // Current fire grid
    //private bool igniteFire = false;              // Ignite fire flag                    -- For Testing

    /* Roots Parameters */
    public float RootsCarbonOver;                    // Total roots carbon amount for all cube trees at current simulation frame
    public float RootsCarbonUnder;                   // Total roots carbon amount for all cube trees at current simulation frame
    public float RootsCarbonOverMin { get; set; } = 100000f;   // Root carbon min. from data
    public float RootsCarbonOverMax { get; set; } = -100000f;  // Root carbon max. from data
    public float RootsCarbonUnderMin { get; set; } = 100000f;   // Root carbon min. from data
    public float RootsCarbonUnderMax { get; set; } = -100000f;  // Root carbon max. from data

    /* Settings */
    private SimulationSettings settings;          // Simulation settings
    private int shrubCount;                       // Current number of grown shrubs in cube
    private float minShrubFullSize = 1.5f;        // Min. shrub grown size (m.)
    private float maxShrubFullSize = 2.5f;        // Max. shrub grown size (m.)
    private float minGrassFullSize = 4f;        // Max. shrub grown size (m.)
    private float maxGrassFullSize = 12f;        // Max. shrub grown size (m.)
    private float shrubGrowthIncrement = 0.01f;   // Shrub growth increment per frame

    /* Timing */
    private int timeIdx = 0;                    // Current index of simulation in data time series
    private int firGrowthWaitTime = 30;         // Frames to wait between tree instantiations (avoid spawning too many all at once)
    private int shrubGrowthWaitTime = 10;       // Frames to wait between shrub instantiations (avoid spawning too many all at once)
    private int lastFirGrownTimeIdx = 0;        // Time at which tree most recently started growing
    private int lastShrubGrownTimeIdx = 0;      // Time at which tree most recently started growing
    private int lastDataUpdate = 0;             // Time at which carbon data was most recently compared to carbon visualized in simulation
    private int lastKilledTreeFrame = 0;        // Time at which tree most recently started dying       -- OBSOLETE
    //private int vegetationDataWaitFrames = 2; // Frames to wait between checks whether visualized carbon amount is more than carbon in data
    private int timeStep;                       // Simulation time step (days per frame)

    /* Geometry */
    public Vector3 defaultPosition { get; set; } // Default position
    private float cubeWidth = 50f;              // Cube width (m.)
    private float cubeHeightScale = 1f;         // Cube height scale
    private float cubeWidthScale = 1f;          // Cube width scale
    public Vector3 neCorner { get; set; }       // Corners of cube (in world coords.)
    public Vector3 swCorner { get; set; }

    /* Data */
    public CubeDataType dataType;              // Cube data type (1- or 2-story)
    private TextAsset[] dataFiles;              // Data files for different warming scenarios  
    private float[][,] dataArray;               // Data arrays by [warming idx][row, col] in desktop version OR [time idx offset][row, col] in web version
    private float[][,] nextDataArray;           // Used for pre-loading data in web version
    private Dictionary<int, CubeData> cubeData;              // Data access for web loaded data
    //private Dictionary<int, CubeDataRow> nextCubeData;          // Used for pre-loading data in web version  
    private CubeData[] dataRows;             // Data rows for calculating paramater ranges
    //private CubeDataRow[] nextDataRows;         // Used for pre-loading data in web version
    //private int firstCurrentDataIdx = -1;        
    //private int lastCurrentDataIdx = -1;
    //private int firstNextDataIdx = -1;
    //private int lastNextDataIdx = -1;
    private int dataBuffer = 500;                 // Frames of cube data to preload

    private int dataLength;                     // Data file line count

    //private string[] dataHeadings;              // Data headings
    //private List<DateModel> dataDates;          // Dates by time index

    public int warmingIdx;                     // Current warming index
    public int warmingDegrees;                 // Current warming degrees
    public int warmingRange;                   // Warming range (warming idx values)

    /* Display + UI */
    private GameObject displayObject;           // UI Display game object
    private GameObject displayPanel;            // UI Display panel object

    //- Update data display bars((ET), (PSN), (SA), (PC) and (WA).)

    private Slider netTransSlider;
    private Slider psnSlider;
    private Slider snowAmountSlider;
    private Slider plantCarbonSlider;
    private Slider waterAccessSlider;

    private Slider netTransSliderDebug;
    private Slider psnSliderDebug;
    private Slider snowAmountSliderDebug;
    private Slider plantCarbonSliderDebug;
    private Slider waterAccessSliderDebug;
    /* Animation */
    public bool animating { get; set; } = false;
    private Vector3 targetPosition, startPosition;
    private Vector3 targetScale, halfTargetScale, startScale;
    private float animationStartTime = -1;
    private float animationEndTime = -1;
    private float animationLength = 3f;

    /* Landscape */
    private Terrain terrain;                                  // Cube terrain object
    private UnityEngine.TerrainData defaultTerrain;           // -- Needed?
    float[,,] unburntSplatmap;                                // Unburnt terrain splatmap data
    float[,,] burntSplatmap;                                  // Burnt terrain splatmap data

    private SoilController soilController;

    /* Snow */
    private SnowManager snowManager;
    private float snowValue = 0f;                   // Amount of snow currently being visualized
    private float snowMeltRate = 0.075f;            // Snow melt rate
    private float snowScalingFactor = 1.8f;           // Snow scaling factor

    public float SnowAmount { get; set; } = 0f;     // Snow amount in simulation
    private float SnowAmountMin = 100000f;          // Snow amount max. 
    private float SnowAmountMax = -100000f;         // Snow amount min.
    private float snowValueMin = 0f;                // Min. snow value in SnowManager
    private float snowValueMax = 1.4f;              // Max. snow value in SnowManager

    /* Water */
    public float WaterAccess { get; set; }         // Vegetation access to water in (surface) soil
    public float Evaporation { get; set; }         // Soil moisture evaporation  (X)
    public float DepthToGW { get; set; }           // Depth to ground water

    /* Stream */
    [Header("Stream")]
    public bool hasStream;                       // Whether cube has a stream
    public GameObject streamObject;              // Stream object
    public GameObject streamFaceObject;          // Stream face object
    public float StreamHeight { get; set; }      // Stream height (QOut)
    public float streamFullHeight;               // Height (transform.position.y) of stream spline at full water level
    public float streamZeroHeight;               // Height (transform.position.y) of stream spline at zero water level
    //public float streamFaceFullHeight;         // Height (transform.position.y) of stream spline at full water level
    //public float streamFaceZeroHeight;         // Height (transform.position.y) of stream spline at zero water level
    public float streamFaceFullScale;            // Scale (transform.scale.y) of stream face at full water level
    public float streamFaceZeroScale;            // Scale of stream face for zero water level
    private float StreamHeightMin = 100000f;     // Min. stream level in current data file
    private float StreamHeightMax = -100000f;    // Max. stream level in current data file

    private float WaterAccessMin = 100000f;
    private float WaterAccessMax = -100000f;
    private float DepthToGWMin = 100000f;
    private float DepthToGWMax = -100000f;

    public float streamCenter = 25f;             // Stream center position in cube (0f-50f)
    public float streamWidth = 10f;              // Stream width (m.)

    /* Vegetation */
    private List<FirController> firs;                // Array of all fir controllers
    private ManzanitaController[] manzanitas;    // Array of all fir controllers
    private List<ShrubController> shrubs;         // List of active (simple) shrub objects
    private List<GameObject> grasses;         // List of active (simple) shrub objects

    private List<GameObject> litter;             // List of active (simple) shrub objects
    private Vector3[] firLocations;              // Tree locations
    private List<int> activeFirLocations;        // Used fir location IDs
    public int firsToKill = 0;                   // Trees to kill
    public int shrubsToKill = 0;                 // Shrubs to kill
    public int grassesToKill = 0;            // Grass patches to kill
    public float LeafCarbonOver;                 // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    public float LeafCarbonUnder;                // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    public float StemCarbonOver;                 // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    public float StemCarbonUnder;                // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?

    //public float LeafCarbon { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float StemCarbon { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    //public float LeafCarbonOver { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float LeafCarbonUnder { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float StemCarbonOver { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    //public float StemCarbonUnder { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?

    private float LeafCarbonOverMin = 100000f;      // Leaf carbon (overstory) minimum value in data
    private float LeafCarbonOverMax = -100000f;     // Leaf carbon (overstory) maximum value in data
    private float LeafCarbonUnderMin = 100000f;     // Leaf carbon (understory) minimum value in data
    private float LeafCarbonUnderMax = -100000f;    // Leaf carbon (understory) maximum value in data
    private float StemCarbonOverMin = 100000f;      // Stem carbon (overstory) minimum value in data
    private float StemCarbonOverMax = -100000f;     // Stem carbon (overstory) maximum value in data
    private float StemCarbonUnderMin = 100000f;     // Stem carbon (understory) minimum value in data
    private float StemCarbonUnderMax = -100000f;    // Stem carbon (understory) maximum value in data

    public float NetTranspiration;     // Net transpiration for all trees + plants
    public float TransOver;     // Net transpiration for all trees + plants
    public float TransUnder;     // Net transpiration for all trees + plants
    //public float NetTranspiration { get; set; }     // Net transpiration for all trees + plants
    //public float TransOver { get; set; }     // Net transpiration for all trees + plants
    //public float TransUnder { get; set; }     // Net transpiration for all trees + plants
    private float NetTranspirationMin = 100000f;    // Net trans. min. from data
    private float NetTranspirationMax = -100000f;   // Net trans. max. from data
    private float TransOverMin = 100000f;    // Net trans. min. from data
    private float TransOverMax = -100000f;   // Net trans. max. from data
    private float TransUnderMin = 100000f;    // Net trans. min. from data
    private float TransUnderMax = -100000f;   // Net trans. max. from data

    public float Litter { get; set; }               // Litter amount
    private float LitterMin = 100000f;              // Litter min. from data
    private float LitterMax = -100000f;             // Litter max. from data

    public float NetPhotosynthesis { get; set; }    // Net photosynthesis for all trees + plants  (X)
    private float NetPhotosynthesisMin = 100000f;
    private float NetPhotosynthesisMax = -100000f;

    private float treeAverageCarbonAmount;          // Average carbon amount per tree, calculated from TreeCarbonFactor
    private float treeAverageRootCarbonAmount;      // Average root carbon per tree, calculated from RootsCarbonFactor
    private float shrubAverageCarbonAmount;         // Average carbon amount per shrub, calculated from ShrubCarbonFactor
    private float grassAverageCarbonAmount;         // Average grass patch carbon amount, set to 1/10 of shrubAverageCarbonAmount
    private float litterAverageCarbonAmount;        // Average carbon amount per litter object, from GameController

    private float treeCarbonFactor;                 // Scaling of tree height to vegetation amount (to compare with stem+leaf carbon in data)
    private float rootsCarbonFactor;                // Scaling of root height to roots amount to compare with root carbon in data   -- SHOULD ACCOUNT FOR WIDTH!
    private float shrubCarbonFactor;                // Scaling of shrub height to vegetation amount (to compare with stem+leaf carbon in data)

    #endregion

    #region DataTypes
    public enum CubeAnimationType
    {
        shrink,
        grow,
        still
    }

    public enum CubeDataType
    {
        Veg1,                       // One vegetation level (shrub only)
        Veg2,                       // Two vegetation levels (shrub and tree)
        Agg                         // Aggregate cube, two vegetation levels
    }

    //date snow evap netpsn depthtogw vegaccesswater Qout litter soil height trans leafc stemc rootc year month day
    /// <summary>
    /// Cube data parameter columns used in simulation 
    /// </summary>
    //private enum DataVeg1ColumnIdx
    //{
    //    Date = 0,
    //    Snow = 1,
    //    Evap = 2,
    //    NetPsn = 3,
    //    DepthToGW = 4,
    //    WaterAccess = 5,
    //    StreamLevel = 6,
    //    Litter = 7,
    //    SoilCarbon = 8,
    //    Height = 9,
    //    NetTranspiration = 10,
    //    LeafCarbon = 11,
    //    StemCarbon = 12,
    //    RootCarbon = 13,
    //    Year = 14,
    //    Month = 15,
    //    Day = 16
    //};

    //date snow evap netpsn depthtogw vegaccesswater Qout litter soil height_over trans_over height_under trans_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
    /// <summary>
    /// Cube data parameter columns used in simulation
    /// </summary>
    private enum DataColumnIdx
    {
        Date = 0,
        Snow = 1,
        Evap = 2,
        NetPsn = 3,
        DepthToGW = 4,
        WaterAccess = 5,
        StreamLevel = 6,
        Litter = 7,
        SoilCarbon = 8,
        HeightOver = 9,
        TransOver = 10,
        HeightUnder = 11,
        TransUnder = 12,
        LeafCarbonOver = 13,
        StemCarbonOver = 14,
        RootCarbonOver = 15,
        LeafCarbonUnder = 16,
        StemCarbonUnder = 17,
        RootCarbonUnder = 18,
        Year = 19,
        Month = 20,
        Day = 21
    };

    //  date snow evap netpsn depthtogw vegaccesswater Qout litter soil height_over trans height_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
    private enum AggregateDataColumnIdx
    {
        Date = 0,
        Snow = 1,
        Evap = 2,
        NetPsn = 3,
        DepthToGW = 4,
        WaterAccess = 5,
        StreamLevel = 6,
        Litter = 7,
        SoilCarbon = 8,
        HeightOver = 9,
        Trans = 10,
        HeightUnder = 11,
        LeafCarbonOver = 12,
        StemCarbonOver = 13,
        RootCarbonOver = 14,
        LeafCarbonUnder = 15,
        StemCarbonUnder = 16,
        RootCarbonUnder = 17,
        Year = 18,
        Month = 19,
        Day = 20
    }
    #endregion

    #region Initialization

    /// <summary>
    /// Starts the simulation.
    /// </summary>
    /// <param name="startTimeIdx">Start time index.</param>
    /// <param name="curTimeStep">Current time step.</param>
    public void StartSimulation(int startTimeIdx, int curTimeStep)
    {
        if (isSideCube || debugDetailed)
            Debug.Log(transform.name + ".StartSimulation()...  startTimeIdx:" + startTimeIdx + " simulationOn: " + simulationOn);

        simulationOn = true;

        timeIdx = startTimeIdx;
        timeStep = curTimeStep;

        cubeObject.SetActive(true);

        // Initial update of data parameters
        if (settings.BuildForWeb)
            UpdateDataFromWeb(timeIdx, true, true);
        else
            UpdateCurrentData(timeIdx);

        soilController.UpdateParams(timeStep, WaterAccess, DepthToGW);      // Initial update of soil parameters
        snowManager.snowValue = Mathf.Clamp(MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, 0f, snowScalingFactor), 0f, snowScalingFactor);

        if(!settings.BuildForWeb)
            GrowInitialVegetation();

        if (hasStream)
            UpdateStream();
    }

    public void StopSimulation()
    {
        // TO DO
    }

    /// <summary>
    /// Grows initial vegetation for cube.                          
    /// </summary>
    private void GrowInitialVegetation()
    {
        float combinedCarbonOver, combinedCarbonUnder;

        if (dataType == CubeDataType.Veg1)
        {
            combinedCarbonOver = StemCarbonOver + LeafCarbonOver;

            /* Grow Initial Shrubs */
            int shrubsToGrow = (int)Mathf.Round(combinedCarbonOver / shrubAverageCarbonAmount);
            for (int i = 0; i < shrubsToGrow; i++)
            {
                GrowAShrub(true);
            }

            //UpdateShrubParticleSystems();
            //UpdateShrubRenderers();
        }
        else
        {
            combinedCarbonUnder = StemCarbonUnder + LeafCarbonUnder;
            combinedCarbonOver = StemCarbonOver + LeafCarbonOver;

            int treesToGrow = (int)Mathf.Round(combinedCarbonOver / treeAverageCarbonAmount);           // Use Overstory Data for Trees
            if (debugTrees)
                Debug.Log(transform.name + ".GrowInitialVegetation()... treeAverageCarbonAmount:" + treeAverageCarbonAmount + " combinedStemLeafCarbon:" + combinedCarbonOver + " treesToGrow:" + treesToGrow);

            for (int i = 0; i < treesToGrow; i++)            /* Grow Initial Trees */
            {
                bool spawned = GrowAFir(true);
                if (!spawned)
                {
                    if (debugTrees)
                        Debug.Log(transform.name + ".GrowInitialVegetation()... Couldn't grow tree!");
                    break;
                }
            }

            /* Grow Initial Shrubs */
            int shrubsToGrow = (int)Mathf.Round(combinedCarbonUnder / shrubAverageCarbonAmount);        // Use Understory Data for Shrubs
            for (int i = 0; i < shrubsToGrow; i++)
            {
                GrowAShrub(true);
            }

            //UpdateShrubParticleSystems();
            //UpdateShrubRenderers();
        }

        GrowInitialGrass(50);
    }

    /// <summary>
    /// Sets the initial cube parameter values.
    /// </summary>
    public void SetInitParameterValues()
    {
        timeIdx = 0;
        lastFirGrownTimeIdx = 0;
        lastShrubGrownTimeIdx = 0;
        lastKilledTreeFrame = 0;

        snowValue = 0f;
        SnowAmount = 0f;

        litter = new List<GameObject>();
    }

    /// <summary>
    /// Setup game objects for cube
    /// </summary>
    public void SetupObjects()
    {
        settings = GameObject.Find("GameSettings").GetComponent<SimulationSettings>() as SimulationSettings;
        Assert.IsNotNull(settings);

        GameObject gameControllerObject = GameObject.Find("Game");
        Assert.IsNotNull(gameControllerObject);
        GameController gameController = gameControllerObject.GetComponent<GameController>() as GameController;
        Assert.IsNotNull(gameController);

        //cubeObject = transform.Find("CubeObject").gameObject;              // Get (cube) base object
        Assert.IsNotNull(cubeObject);
        
        string terrainName = "Terrain_" + name.Substring(name.Length == 5 ? name.Length - 1 : name.Length - 6);

        terrain = cubeObject.transform.Find(terrainName).GetComponent<Terrain>();
        fireManager = terrain.transform.GetComponentInChildren<SERI_FireManager>() as SERI_FireManager;
        Assert.IsNotNull(terrain);
        Assert.IsNotNull(fireManager);
        SetFirePrefab(firePrefab);

        GameObject cubeSoil = cubeObject.transform.Find("Soil").gameObject;         // Get soil object
        Assert.IsNotNull(cubeSoil);
        soilController = cubeSoil.GetComponent<SoilController>() as SoilController; // Get soil controller
        Assert.IsNotNull(soilController);

        rainToGWPrefab = soilController.transform.Find("RainToGW_Prefab").gameObject;
        Assert.IsNotNull(rainToGWPrefab);
        rainToGWPrefab.SetActive(false);
        precipToGWController = rainToGWPrefab.GetComponent<WaterToGWController>();
        Assert.IsNotNull(precipToGWController);

        //cubeLabel = transform.Find("CubeLabel").gameObject;              // Get (cube) base object
        Assert.IsNotNull(cubeLabel);
        cubeLabel.SetActive(false);

        displayObject = cubeObject.transform.Find("CubeStats").gameObject;
        Assert.IsNotNull(displayObject);
        displayPanel = displayObject.transform.Find("Canvas").gameObject;
        Assert.IsNotNull(displayPanel);
        HideStatistics();

        GameObject snowManagerObject = GameObject.Find("SnowManager_" + name);
        Assert.IsNotNull(snowManagerObject);
        snowManager = snowManagerObject.GetComponent<SnowManager>() as SnowManager;
        Assert.IsNotNull(snowManager);

        defaultPosition = transform.position;

        pooler = GetComponent<GameObjectPool>() as GameObjectPool;
        pooler.Initialize(firePrefab);
    }

    /// <summary>
    /// Initialize this cube instance.
    /// </summary>
    /// <param name="newETPrefab">New ET prefab.</param>
    /// <param name="newShrubETPrefab">New Shrub ET prefab.</param>
    /// <param name="newFirePrefab">New fire prefab.</param>
    public void Initialize(GameObject newETPrefab, GameObject newShrubETPrefab, GameObject newFirePrefab)
    {
        etPrefab = newETPrefab;
        shrubETPrefab = newShrubETPrefab;
        firePrefab = newFirePrefab;

        SetFirePrefab(firePrefab);
        if(housePrefab)
            SetupHouse();
        SetupCube();

        /* Initialize Geometry */
        if (isAggregate)
        {
            cubeWidthScale = transform.localScale.x;
            cubeHeightScale = transform.localScale.y;
        }

        animatedCubeFullScale = animationPrefab.transform.localScale;

        /* Initialize Vegetation Species */
        foreach (Species species in vegetation.species)
        {
            if (species.isShrub)
            {
                List<GameObject> growthStageList = new List<GameObject>();
                foreach (GameObject obj in species.list)
                {
                    growthStageList.Add(obj);
                }
                shrubList.Add(growthStageList);
                shrubPrefabs.Add(growthStageList[0]);           // -- TEMP.
            }
            else
            {
                List<GameObject> growthStageList = new List<GameObject>();
                foreach (GameObject obj in species.list)
                {
                    growthStageList.Add(obj);
                }
                treeList.Add(growthStageList);
            }
        }

        treeCarbonFactor = GetTreeCarbonFactor();          // Scaling of tree height to vegetation amount (to compare with stem+leaf carbon in data)
        rootsCarbonFactor = GetRootsCarbonFactor();        // Scaling of root height to roots amount to compare with root carbon in data   -- SHOULD ACCOUNT FOR WIDTH!
        shrubCarbonFactor = GetShrubCarbonFactor();        // Scaling of shrub height to vegetation amount (to compare with stem+leaf carbon in data)

        GameObject lodGroup = rootsPrefabs[rootsPrefabs.Count - 1];                              // -- UPDATE TO REFLECT WIDTH AND HEIGHT
        GameObject lod0 = lodGroup.transform.GetChild(0).gameObject as GameObject;
        float fullRootsDepth = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of prefab (m.)

        treeAverageRootCarbonAmount = (settings.MaxRootsFullHeightScale + settings.MinRootsFullHeightScale) / 2f * fullRootsDepth * GetRootsCarbonFactor();
        shrubAverageCarbonAmount = (maxShrubFullSize + minShrubFullSize) / 2f * GetShrubCarbonFactor();
        grassAverageCarbonAmount = shrubAverageCarbonAmount * 0.1f;

        lodGroup = treeList[0][treeList[0].Count - 1];
        lod0 = lodGroup.transform.GetChild(0).gameObject as GameObject;
        float fullTreeHeight = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of prefab (m.)
        treeAverageCarbonAmount = (settings.MaxTreeFullHeightScale + settings.MinTreeFullHeightScale) / 2f * fullTreeHeight * GetTreeCarbonFactor();    // -- WHY CAUSES FREEZING BUG??

        burntSplatmap = CreateBurntSplatmap();
        unburntSplatmap = CreateUnburntSplatmap();
        ResetTerrainSplatmap();

        //fireGridCenterLocation = new Vector3(24f, 0f, 0f);
        //defaultPosition = transform.position;

        if (hasStream)
        {
            streamObject = cubeObject.transform.Find("StreamSpline").gameObject;
            streamFaceObject = cubeObject.transform.Find("StreamFace_Prefab").gameObject;
            Assert.IsNotNull(streamObject);
            Assert.IsNotNull(streamFaceObject);
        }

        if (firstRun) CreateTreeLocations();                  // Create trees on first run

        shrubs = new List<ShrubController>();
        grasses = new List<GameObject>();
        litter = new List<GameObject>();

        fireManager.Initialize(pooler, firePrefab, fireGridCenterLocation, cubeObject.transform.position, null, null, false, true, settings.BuildForWeb);

        HideStatistics();

        emissions = new List<ParticleSystem.EmissionModule>();
        UpdateETList();

        firstRun = false;
        //Debug.Log(name+".Initialize()... firePrefab == null? " + (firePrefab == null));
    }

    /// <summary>
    /// Enter Side-by-Side Mode
    /// </summary>
    /// <param name="sideBySideStatsPanel">Statistics panel to use for cube</param>
    public void EnterSideBySide(int newTimeIdx, GameObject sideBySideStatsPanel)
    {
        timeIdx = newTimeIdx;

        if (settings.DebugGame)
            Debug.Log(transform.name + ".EnterSideBySide()... Cube Name: " + name);

        SetupStatisticsPanel(sideBySideStatsPanel);
        //if(GameController.Instance.displayModel)
            HideStatistics();

        if (isSideCube)
        {
            UpdateDataFromWeb(timeIdx, true, true);
            cubeObject.SetActive(true);
        }
    }

    /// <summary>
    /// Sets up the house
    /// </summary>
    private void SetupHouse()
    {
        Vector3 loc = new Vector3(8.6f, 7f, -20.4f);
        houseObj = Instantiate(housePrefab, Vector3.zero, housePrefab.transform.rotation, cubeObject.transform);
        houseObj.transform.localPosition = loc;

        //GameObject rootsPrefab = rootsPrefabs[i];
        //float rootsY = settings.RootsYOffsetFactor;
        //Vector3 rootLocation = new Vector3(firLocations[treeID].x, firLocations[treeID].y + rootsY, firLocations[treeID].z);
        //GameObject newRoots = Instantiate(rootsPrefab, rootLocation, rootsPrefab.transform.rotation, parent);       // Create root object from prefab
    }

    /// <summary>
    /// Sets up the cube.
    /// </summary>
    private void SetupCube()
    {
        treeList = new List<List<GameObject>>();
        shrubList = new List<List<GameObject>>();
        shrubPrefabs = new List<GameObject>();

        SetupStatisticsPanel(displayPanel);

        neCorner = transform.TransformPoint(terrain.transform.position);
        swCorner = transform.TransformPoint(new Vector3(neCorner.x + cubeWidth, neCorner.y, neCorner.z - cubeWidth));

        KillAllTrees(true);
        ClearAllLitter();
    }

    public void ResetStatsPanel()
    {
        SetupStatisticsPanel(displayPanel);
    }

    private void SetupStatisticsPanel(GameObject statsPanel)
    {
        //if (settings.BuildForWeb)
        //    return;

        //Debug.Log(transform.name + ".SetupStatisticsPanel()");

        netTransSlider = statsPanel.transform.Find("NetTransSlider").GetComponent<Slider>() as Slider;
        //plantCarbonSlider = statsPanel.transform.Find("PlantCarbonSlider").GetComponent<Slider>() as Slider;
        snowAmountSlider = statsPanel.transform.Find("SnowAmountSlider").GetComponent<Slider>() as Slider;
        //psnSlider = statsPanel.transform.Find("PSNSlider").GetComponent<Slider>() as Slider;
        waterAccessSlider = statsPanel.transform.Find("WaterAccessSlider").GetComponent<Slider>() as Slider;

        netTransSliderDebug = statsPanel.transform.Find("NetTransSliderDebug").GetComponent<Slider>() as Slider;
        netTransSliderDebug.gameObject.SetActive(false);
        plantCarbonSliderDebug = statsPanel.transform.Find("PlantCarbonSliderDebug").GetComponent<Slider>() as Slider;
        plantCarbonSliderDebug.gameObject.SetActive(false);
        snowAmountSliderDebug = statsPanel.transform.Find("SnowAmountSliderDebug").GetComponent<Slider>() as Slider;
        snowAmountSliderDebug.gameObject.SetActive(false);
        psnSliderDebug = statsPanel.transform.Find("PSNSliderDebug").GetComponent<Slider>() as Slider;
        psnSliderDebug.gameObject.SetActive(false);
        waterAccessSliderDebug = statsPanel.transform.Find("WaterAccessSliderDebug").GetComponent<Slider>() as Slider;
        waterAccessSliderDebug.gameObject.SetActive(false);

        Assert.IsNotNull(netTransSlider);
        //Assert.IsNotNull(plantCarbonSlider);
        Assert.IsNotNull(snowAmountSlider);
        //Assert.IsNotNull(psnSlider);
        Assert.IsNotNull(waterAccessSlider);
    }

    /// <summary>
    /// Creates the trees.
    /// </summary>
    private void CreateTreeLocations()
    {
        firLocations = new Vector3[settings.MaxTrees];
        activeFirLocations = new List<int>();

        float offsetX = terrain.GetPosition().x;
        float offsetZ = terrain.GetPosition().z;

        int start = 1;
        float randX;

        float cubeXMin = settings.CubeTreePadding;
        float cubeXMax = cubeWidth * cubeWidthScale - settings.CubeTreePadding;
        float cubeZMin = settings.CubeTreePadding;
        float cubeZMax = cubeWidth * cubeWidthScale - settings.CubeTreePadding;
        float cubeFront = cubeWidth * cubeWidthScale;

        if (hasStream)                  // Create trees for cube with stream
        {
            switch (settings.MinFrontTrees)
            {
                case 1:
                    goto default;

                case 2:
                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
                    firLocations[0] = new Vector3(randX, 0, cubeFront);        //  Front tree 1
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;

                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
                    firLocations[1] = new Vector3(randX, 0, cubeFront);        //  Front tree 2
                    firLocations[1].y = terrain.SampleHeight(firLocations[1]) + terrain.GetPosition().y;

                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;
                    firLocations[1].x += offsetX;
                    firLocations[1].z += offsetZ;

                    start = 2;
                    break;

                default:
                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + (streamWidth * 0.5f));
                    firLocations[0] = new Vector3(randX, 0, cubeFront);        //  Front tree 
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;
                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;

                    start = 1;
                    break;
            }

            for (int i = start; i < settings.MaxTrees; i++)
            {
                randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
                float randZ = Random.Range(cubeZMin, cubeZMax);
                randX += offsetX;
                randZ += offsetZ;

                int count = 0;
                bool found = false;
                while (!found)
                {
                    Vector3 testLoc;                                                                     // Location to compare

                    found = true;
                    for (int x = start; x < i; x++)
                    {
                        testLoc = new Vector3(randX, 0f, randZ);                                         // Get random location for testing
                        if (Mathf.Abs(Vector3.Distance(testLoc, firLocations[x])) < settings.TreeMinSpacing)
                            found = false;                                                               // Too close to another tree, try again
                    }
                    if (!found)                                                                          // Choose new location
                    {
                        randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
                        randZ = Random.Range(cubeZMin, cubeZMax);
                        randX += offsetX;
                        randZ += offsetZ;
                    }
                    if (++count > whileLoopMaxCount)
                    {
                        Debug.Log(transform.name + ".CreateTrees()... Tried 100 tree locations and none found within min spacing distance!");
                        throw new System.Exception();      // -- TEST
                        //break;
                    }
                }

                firLocations[i] = new Vector3(randX, 0f, randZ);
                firLocations[i].y = terrain.SampleHeight(firLocations[i]) + terrain.GetPosition().y;
            }
        }
        else                     // Create trees for cube without stream
        {
            switch (settings.MinFrontTrees)
            {
                case 1:
                    goto default;

                case 2:
                    firLocations[0] = new Vector3(Random.Range(cubeXMin, cubeXMax), 0f, cubeFront);             //  Front tree 1
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;
                    firLocations[1] = new Vector3(Random.Range(cubeXMin, cubeXMax), 0f, cubeFront);             //  Front tree 2
                    firLocations[1].y = terrain.SampleHeight(firLocations[1]) + terrain.GetPosition().y;
                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;
                    firLocations[1].x += offsetX;
                    firLocations[1].z += offsetZ;

                    start = 2;
                    break;

                default:
                    firLocations[0] = new Vector3(Random.Range(cubeXMin, cubeXMax), 0f, cubeFront);             //  Front tree
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;
                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;

                    start = 1;
                    break;
            }

            for (int i = start; i < settings.MaxTrees; i++)
            {
                randX = Random.Range(cubeXMin, cubeXMax);
                float randZ = Random.Range(cubeZMin, cubeZMax);

                randX += offsetX;
                randZ += offsetZ;

                firLocations[i] = new Vector3(randX, 0f, randZ);
                firLocations[i].y = terrain.SampleHeight(firLocations[i]) + terrain.GetPosition().y;

                if (debugTrees && debugDetailed)
                    Debug.Log(transform.parent.name + "  Adding Tree Location... i:" + i + " at: " + firLocations[i]);
            }
        }

        firs = new List<FirController>();
    }


    /// <summary>
    /// Sets the warming index.
    /// </summary>
    /// <param name="newWarmingIdx">New warming index.</param>
    public void SetWarmingIdx(int newWarmingIdx)
    {
        warmingIdx = newWarmingIdx;
    }

    /// <summary>
    /// Set warming degrees
    /// </summary>
    /// <param name="newWarmingDegrees"></param>
    public void SetWarmingDegrees(int newWarmingDegrees)
    {
        warmingDegrees = newWarmingDegrees;
    }

    /// <summary>
    /// Sets the warming range.
    /// </summary>
    /// <param name="newWarmingRange">New warming range.</param>
    public void SetWarmingRange(int newWarmingRange)
    {
        warmingRange = newWarmingRange;
    }

    /// <summary>
    /// Update list of ET emitting objects in cube
    /// </summary>
    private void UpdateETList()
    {
        GameObject[] etList = GameObject.FindGameObjectsWithTag("ET");                  // -- Optimize?

        //Debug.Log("Found "+ etList.Length +" objects tagged 'ET'...");

        foreach (GameObject et in etList)
        {
            ParticleSystem ps = et.GetComponent<ParticleSystem>() as ParticleSystem;

            if (ps)
            {
                ParticleSystem.EmissionModule em = ps.emission;
                emissions.Add(em);
            }
        }
    }

    /// <summary>
    /// Sets whether ET particles are displayed or not
    /// </summary>
    /// <param name="newState"></param>
    public void SetDisplayET(bool newState)
    {
        for (int i = 0; i < emissions.Count; i++)
        {
            ParticleSystem.EmissionModule em = emissions[i];
            em.enabled = newState;
        }
    }

    /// <summary>
    /// Initializes cube data arrays from data file.
    /// </summary>
    /// <param name="dataFile">Data file.</param>
    public void InitializeData(TextAsset dataFile)
    {
        if (settings.BuildForWeb)
            return;
        
        List<string> rawData = TextAssetToList(dataFile);

        dataLength = rawData.Count - 1;                             // Set data length (raw data length - 1 for blank space at end)
        //dataDates = new string[dataLength];
        //dataHeadings = rawData[0].Split(' ');
        dataFiles = new TextAsset[warmingRange];
        dataArray = new float[warmingRange][,];
        nextDataArray = new float[warmingRange][,];
        //dataRows = new CubeDataRow[0];
        //nextDataRows = new CubeDataRow[0];

        cubeData = new Dictionary<int, CubeData>();
        //nextCubeData = new Dictionary<int, CubeDataRow>();

        if (isAggregate)
        {
            patchID = -1;
            dataType = CubeDataType.Agg;
        }
        else
        {
            if (!settings.BuildForWeb)
            {
                string patchFileName = dataFile.name;
                string[] arr = patchFileName.Split('_');
                patchID = int.Parse(arr[0].Substring(1));

                dataType = CubeDataType.Veg1;
                string dataTypeStr = arr[1];
                if (dataTypeStr.Equals("2veg"))
                {
                    //Debug.Log("Cube #" + patchID + " switched to Veg2 type!" + " Name:" + patchFileName);
                    dataType = CubeDataType.Veg2;
                }
                else
                {
                    //Debug.Log("Cube #" + patchID + " stayed at Veg1 type.  Name:" + patchFileName);
                }
            }
        }

        if (debugCubes)
            Debug.Log("InitializeData()... " + dataFile.name + "  dataLength:" + GetDataLength() + " patchID:" + patchID + " dataArray null?:" + (dataArray == null));
    }

    #endregion

    #region UpdateMethods
    /// <summary>
    /// Update ET based on time step
    /// </summary>
    /// <param name="timeStep"></param>
    public void UpdateETSpeed(int timeStep)
    {
        if (!simulationOn)
            return;

        if (firs == null)
            return;
        if (shrubs == null)
            return;

        foreach (FirController fir in firs)
        {
            fir.UpdateETSimulationSpeed(Mathf.Clamp(timeStep, 0f, 16f));
        }

        foreach (ShrubController shrub in shrubs)
        {
            if (shrub != null)
                shrub.UpdateETSimulationSpeed(Mathf.Clamp(timeStep, 0f, 16f));
        }
    }

    /// <summary>
    /// Updates the vegetation from data.
    /// </summary>
    public void UpdateVegetationFromData()
    {
        if (!simulationOn)
            return;

        ResetCube();
        GrowInitialVegetation();
    }

    /// <summary>
    /// Updates the animation.
    /// </summary>
    public void UpdateAnimation()
    {
        float pos = MapValue(Time.time, animationStartTime, animationEndTime, 0f, 1f);

        if (pos >= 1f)
        {
            animated.transform.position = targetPosition;
            animated.transform.localScale = targetScale;
            animating = false;

            if (Vector3.Distance(targetScale, animatedCubeFullScale) < 0.01f)
                cubeObject.SetActive(true);

            Destroy(animated);
        }
        else
        {
            if (Vector3.Distance(startPosition, targetPosition) > 0.001f)
                animated.transform.position = Vector3.Lerp(startPosition, targetPosition, pos);

            if (pos < 0.5f)
            {
                float pos1 = MapValue(pos, 0f, 0.5f, 0f, 1f);
                animated.transform.localScale = Vector3.Lerp(startScale, halfTargetScale, pos1);
            }
            else
            {
                float pos2 = MapValue(pos, 0.5f, 1f, 0f, 1f);
                animated.transform.localScale = Vector3.Lerp(halfTargetScale, targetScale, pos2);
            }
            //animated.transform.localScale = Vector3.Lerp(startScale, targetScale, pos);
        }
    }

    /// <summary>
    /// Updates vegetation growth simulation.
    /// </summary>
    /// <param name="newTimeIdx">Time index.</param>
    /// <param name="curTimeStep">Current time step.</param>
    public void UpdateVegetationBehavior(int newTimeIdx, int curTimeStep)
    {
        //Debug.Log(name + ".UpdateVegetationBehavior()... newTimeIdx: " + newTimeIdx+ " simulationOn:"+ simulationOn);

        if (!simulationOn)
            return;

        timeIdx = newTimeIdx;

        timeStep = curTimeStep;

        int dataLength = -1;
        try
        {
            dataLength = GetDataLength();
        }
        catch(Exception ex)
        {
            Debug.Log(name + ".UpdateVegetationBehavior()... ERROR in GetDataLength() ex: " + ex.Message);
            return;
        }

        if (timeIdx >= 0 && timeIdx < dataLength)
        {
            UpdateCurrentData(timeIdx);

            /* Update Shrub ET Rate */
            if (dataType == CubeDataType.Veg1)
            {
                for (int i = 0; i < shrubs.Count; i++)
                {
                    if (i < 0 || i > shrubs.Count)
                    {
                        Debug.Log(name + " Shrub index error i:" + i + " shrubs.Count:" + shrubs.Count);
                        continue;
                    }

                    try
                    {
                        if (shrubs[i].pSystem == null)
                        {
                            if (debugShrubs)
                                Debug.Log(name + " i: " + i + " shrubs[i] is null...");
                            continue;
                        }

                        ParticleSystem.EmissionModule emission = shrubs[i].pSystem.emission;
                        emission.rateOverTime = (TransOver * settings.ShrubParticleEmissionFactor);
                        //Debug.Log("TransOver:" + TransOver + " emission.rateOverTime:" + (int)(TransOver * settings.ShrubParticleEmissionFactor) + " playing? " + etParticles.isPlaying);
                    }
                    catch (System.Exception e)
                    {
                        //if (debugCubes)
                        Debug.Log(name + " ERROR:   " + e);
                    }
                }
            }
            else if (dataType == CubeDataType.Veg2)
            {
                for (int i = 0; i < shrubs.Count; i++)
                {
                    if (i < 0 || i > shrubs.Count)
                    {
                        Debug.Log(name + " Shrub index error i:" + i + " shrubs.Count:" + shrubs.Count);
                        continue;
                    }

                    try
                    {
                        if (shrubs[i].pSystem == null)
                        {
                            //Debug.Log(name + " i: " + i + " shrubsETPSystems[i] is null...");
                            continue;
                        }
                        ParticleSystem.EmissionModule emission = shrubs[i].pSystem.emission;
                        emission.rateOverTime = (TransUnder * settings.ShrubParticleEmissionFactor);
                        //Debug.Log("TransUnder:" + TransUnder + " emission.rateOverTime:" + (int)(TransUnder * settings.ShrubParticleEmissionFactor) + " playing? " + etParticles.isPlaying);
                    }
                    catch (System.Exception e)
                    {
                        //if(debugCubes)
                        Debug.Log(name + " shrubs[i] is null? :" + (shrubs[i] == null) + " i:" + i + " ERROR:   " + e);
                    }
                }

                for (int i = 0; i < firs.Count; i++)
                    firs[i].UpdateSimulation(timeIdx, curTimeStep, TransOver, LeafCarbonOver, StemCarbonOver, RootsCarbonOver);
            }
            else if (dataType == CubeDataType.Agg)
            {
                for (int i = 0; i < shrubs.Count; i++)
                {
                    if (i < 0 || i > shrubs.Count)
                    {
                        Debug.Log(name + " Shrub index error i:" + i + " shrubs.Count:" + shrubs.Count);
                        //DebugMessage(name + " Shrub index error i:" + i + " shrubs.Count:" + shrubs.Count, 0, 0, 0);
                        continue;
                    }

                    try {
                        if (shrubs[i].pSystem == null)
                        {
                            if (debugShrubs)
                                Debug.Log(name + " i: " + i + " shrubsETPSystems[i] is null...");
                            continue;
                        }

                        ParticleSystem.EmissionModule emission = shrubs[i].pSystem.emission;
                        emission.rateOverTime = (NetTranspiration * settings.AggregateShrubParticleEmissionFactor);
                    }
                    catch (System.Exception e)
                    {
                        Debug.Log(name + " ERROR:   " + e);
                        //DebugMessage(name + " ERROR:   " + e + "..... i:"+i+" shrubs.Count:" + shrubs.Count+" shrub == null?"+(shrub == null)+ " evapTrans == null? "+(evapTrans == null)+ " etParticles == null? " + (etParticles == null), 0, 0, 0);
                    }
                }

                for (int i = 0; i < firs.Count; i++)
                    firs[i].UpdateSimulation(timeIdx, curTimeStep, NetTranspiration, LeafCarbonOver, StemCarbonOver, RootsCarbonOver);
            }

            if (soilController != null && cubeObject.activeInHierarchy)
                soilController.UpdateSimulation(timeIdx, curTimeStep, WaterAccess, DepthToGW);

            if (snowValue > 0.0001f)
                snowValue = Mathf.Clamp(snowValue - snowMeltRate * Mathf.Sqrt(timeStep), 0f, 100000f);      // Melt snow

            /* Add snow from current data */
            if (timeStep == 1)
            {
                snowValue = Mathf.Clamp(snowValue + MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, snowValueMin, snowValueMax), snowValueMin, snowValueMax);
            }
            else
            {
                float combinedSnow = 0f;
                int step = timeStep;
                for (int i = timeStep; i > 0; i--)
                {
                    int idx = timeIdx - timeStep;
                    if (idx < 0)
                    {
                        step = timeStep - timeIdx;
                        continue;
                    }

                    float amount = ReadData((int)DataColumnIdx.Snow, idx);
                    float val = Mathf.Clamp(MapValue(amount, SnowAmountMin, SnowAmountMax, snowValueMin, snowValueMax), snowValueMin, snowValueMax);
                    combinedSnow += val;

                    //if (transform.name.Contains("CubeB"))
                    //    Debug.Log(transform.name + " Snow... val:" + val + " combinedSnow:" + combinedSnow);
                    //Debug.Log(transform.name + " GetCurrentData... amount:" + amount);
                    //Debug.Log(transform.name + " GetCurrentData... snowValueMin:" + snowValueMin + "  snowValueMax:" + snowValueMax);
                    //Debug.Log(transform.name + " GetCurrentData... SnowAmountMin:" + SnowAmountMin + "  SnowAmountMax:" + SnowAmountMax);
                }

                if (timeStep <= 7)
                {
                    combinedSnow /= step;
                    snowValue += combinedSnow;

                    //if (isSideCube)
                    //    Debug.Log(transform.name + " added from combined snow... snowValue:" + snowValue);
                }
                else
                {
                    combinedSnow /= step;
                    combinedSnow *= 5f;
                    snowValue = combinedSnow;

                    //if (transform.name.Contains("CubeB"))
                    //    Debug.Log(transform.name + " >>> calculated new snowValue:" + snowValue);
                }
            }

            snowManager.snowValue = snowValue;

            if (!terrainBurning)
            {
                UpdateVegetation();         // Update vegetation
                UpdateLitter();             // Update litter

                if (terrainBurnt)
                {
                    if (debugFire)
                        Debug.Log(name + ".UpdateSimulation()... Burnt... will transition to unburnt splatmap     time:" + Time.time);

                    TransitionToUnburntSplatmap();
                }
            }

            if (lastBurnEndedTime > 0f && Time.time - lastBurnEndedTime < 10f)
                CleanUpBurntVegetation();

            CleanUpDeadFirs();

            if (hasStream)
                UpdateStream();
        }
        else
        {
            if (debugCubes && debugDetailed)
                Debug.Log("UpdateSimulation()... Invalid time index!  timeIdx: " + timeIdx);
        }

        if (snowValue > 0)
            UpdatePrecipToGW(snowValue);
    }

    /// <summary>
    /// Update precipitation to groundwater animation
    /// </summary>
    public void UpdatePrecipToGW(float snowValue)
    {
        if (snowValue > 0)
        {
            if (!rainToGWPrefab.activeSelf)
                rainToGWPrefab.SetActive(true);
        }
        precipToGWController.UpdatePrecipitation(snowValue);
    }

    /// <summary>
    /// Update fire simulation
    /// </summary>
    /// <param name="timeStep"></param>
    public void UpdateFire(int timeStep)
    {
        if (!simulationOn)
            return;

        if (terrainBurning)
        {
            if (!StillBurning())
            {
                if (debugFire)
                    Debug.Log(name + ".UpdateSimulation()... Stopped burning... set terrainBurnt to true   time:" + Time.time);

                terrain.terrainData.SetAlphamaps(0, 0, burntSplatmap);      // Reset terrain splatmap

                fireRegrowthStartTimeIdx = timeIdx;                         // Time idx when last fire ended
                terrainBurning = false;
                terrainBurnt = true;
            }
        }
    }

    /// <summary>
    /// Updates the stream from simulation data.
    /// </summary>
    private void UpdateStream()
    {
        if (!simulationOn)
            return;

        float streamPos = Mathf.Clamp(MapValue(Mathf.Log(StreamHeight) * 20f, StreamHeightMin, StreamHeightMax, 0f, 1f), 0f, 1f);  // -- TESTING
        float streamSplineHeight = Mathf.Clamp(MapValue(streamPos, 0f, 1f, streamZeroHeight, streamFullHeight), streamZeroHeight, streamFullHeight);
        float streamFaceScale = Mathf.Clamp(MapValue(streamPos, 0f, 1f, streamFaceZeroScale, streamFaceFullScale), streamFaceZeroScale, streamFaceFullScale);

        streamObject.transform.localPosition = new Vector3(streamObject.transform.localPosition.x,
                                                            streamSplineHeight,
                                                            streamObject.transform.localPosition.z);

        streamFaceObject.transform.localScale = new Vector3(streamFaceObject.transform.localScale.x,
                                                             streamFaceScale,
                                                             streamFaceObject.transform.localScale.z);

        if (debugStream)
            Debug.Log(transform.parent.name + " UpdateStream()... streamPos:" + streamPos + " StreamHeight:" + StreamHeight + " streamObject.y:" + streamObject.transform.localPosition.y + " streamFaceObject.y:" + streamFaceObject.transform.localPosition.y);
    }

    /// <summary>
    /// Handle vegetation growth in response to data       
    /// </summary>
    private void UpdateVegetation()
    {
        if (!simulationOn)
            return;

        if (firsToKill > 0)
        {
            bool killed = KillAFir(false);
        }

        if (shrubsToKill > 0)
        {
            KillAShrub();
        }

        if (grassesToKill > 0)
        {
            KillAGrassPatch();
        }

        if (dataType == CubeDataType.Veg1)                       // Grow shrubs for 1-story cubes
        {
            float shrubCarbonInData = StemCarbonOver + LeafCarbonOver;    // Get combined stem + leaf carbon in data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();      // Get carbon amount represented by shrubs in current simulation

            if (shrubCarbonInViz < shrubCarbonInData - shrubAverageCarbonAmount / 2f)         // Grow a tree or shrub if visualized carbon too low
            {
                if (timeIdx - lastShrubGrownTimeIdx > shrubGrowthWaitTime)
                    GrowAShrub(false);
                else if (Random.Range(0f, 15f) <= 1f)
                    GrowAGrassPatch(false);
            }
            else if (shrubCarbonInViz > shrubCarbonInData + shrubAverageCarbonAmount / 2f)    // Kill a tree or shrub if visualized carbon too high
            {
                if (!ShrubsAreDead())
                {
                    float diff = (shrubCarbonInViz - shrubCarbonInData) / shrubAverageCarbonAmount;
                    shrubsToKill = (int)Mathf.Round(diff);
                    grassesToKill = (int)Mathf.Round((diff - shrubsToKill) / grassAverageCarbonAmount);
                }
            }
        }
        else                                                        // Grow shrubs for 2-story cubes
        {
            float combinedCarbonOverInData = StemCarbonOver + LeafCarbonOver;       // Get combined stem + leaf carbon in overstory data
            float combinedCarbonUnderInData = StemCarbonUnder + LeafCarbonUnder;    // Get combined stem + leaf carbon in understory data
            float treeCarbonInViz = GetTreeCarbonAmountVisualized();                          // Get carbon amount represented by trees in current simulation
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();                        // Get carbon amount represented by shrubs in current simulation

            if (shrubCarbonInViz < combinedCarbonUnderInData - shrubAverageCarbonAmount / 2f)         // Grow a tree or shrub if visualized carbon too low
            {
                if (timeIdx - lastShrubGrownTimeIdx > shrubGrowthWaitTime)
                    GrowAShrub(false);
                else if (Random.Range(0f, 15f) <= 1f)
                    GrowAGrassPatch(false);
            }
            else if (shrubCarbonInViz > combinedCarbonUnderInData + shrubAverageCarbonAmount / 2f)    // Kill a tree or shrub if visualized carbon too high
            {
                if (!ShrubsAreDead())
                {
                    float diff = (shrubCarbonInViz - combinedCarbonUnderInData) / shrubAverageCarbonAmount;
                    shrubsToKill = (int)Mathf.Round(diff);
                    grassesToKill = (int)Mathf.Round((diff - shrubsToKill) / grassAverageCarbonAmount);
                }
            }

            if (treeCarbonInViz < combinedCarbonOverInData - treeAverageCarbonAmount / 2f)      // Grow a tree if visualized carbon too low
            {
                if (timeIdx - lastFirGrownTimeIdx > firGrowthWaitTime)
                {
                    bool spawned = GrowAFir(false);
                    if (!spawned)
                    {
                        if (debugTrees)
                        {
                            Debug.Log(name + ".UpdateVegetation()... Couldn't grow tree!" + "  treeCarbonAmount:" + treeCarbonInViz + " combinedCarbonOverInData:" + combinedCarbonOverInData
                                       + "  shrubCarbonAmount:" + shrubCarbonInViz + " combinedCarbonUnderInData:" + combinedCarbonUnderInData + " tree avg:" + treeAverageCarbonAmount + " shrub avg:" + shrubAverageCarbonAmount);
                        }
                    }
                }
                else if (Random.Range(0f, 15f) <= 1f)
                    GrowAGrassPatch(false);
            }
            else if (treeCarbonInViz > combinedCarbonOverInData + treeAverageCarbonAmount / 2f)      // Kill a tree if visualized carbon too high
            {
                if (combinedCarbonOverInData < treeAverageCarbonAmount)                              // Kill all trees if data shows very low carbon
                {
                    if (!terrainBurning && !terrainBurnt)
                    {
                        if (debugFire || debugTrees)
                            Debug.Log(name + ".UpdateVegetation()... Kill all trees... combinedCarbonOverInData:" + combinedCarbonOverInData + " treeAverageCarbonAmount:" + treeAverageCarbonAmount);

                        KillAllTrees(true);
                    }
                }
                else
                {
                    if (firsToKill == 0)
                    {
                        firsToKill = (int)Mathf.Round((treeCarbonInViz - combinedCarbonOverInData) / treeAverageCarbonAmount);

                        if (debugTrees)
                            Debug.Log(transform.name + "CubeController.UpdateVegetation()... " + " treeCarbonInViz too high:" + treeCarbonInViz + " combinedCarbonOverInData:" + combinedCarbonOverInData + " treeAverageCarbonAmount:" + treeAverageCarbonAmount + " shrubCarbonAmount:" + shrubCarbonInViz + " firsToKill:" + firsToKill);

                        if (firsToKill <= 0)
                            firsToKill = 1;

                        if (firsToKill > 1)
                        {
                            int aliveCount = GetAliveTreesCount();
                            firsToKill = Mathf.Clamp(firsToKill, 0, aliveCount);

                            /* Fire Detection */
                            //if (vegCarbonInData > fireDetectionMinCarbon && vegCarbonInViz > fireDetectionMinCarbon)
                            //{
                            //    float ratio = vegCarbonInData / vegCarbonInViz;
                            //    if (ratio < fireDetectionThreshold)                         // Check if decrease in carbon is under fire ignition threshold
                            //    {
                            //        if (!burning && !burnt)
                            //        {
                            //            if (debugFire || debugTrees)
                            //                Debug.Log(name + ".UpdateVegetation()... firsToKill:" + firsToKill + " ratio: " + ratio + " is over fireDetectionThreshold:" + fireDetectionThreshold);

                            //            IgniteFire();
                            //        }
                            //    }
                            //}
                        }
                    }

                    lastDataUpdate = timeIdx;
                }
            }
        }

        GrowRoots();
        GrowShrubs();
        GrowGrass();
    }

    /// <summary>
    /// Updates the litter for current simulation frame.
    /// </summary>
    private void UpdateLitter()
    {
        if (!simulationOn)
            return;

        CollectLitter();        /* Collect Litter from Dead Trees */

        float litterAmount = GetLitterAmountVisualized();
        if (Litter > litterAmount + litterAverageCarbonAmount)
        {
            if (debugLitter)
                Debug.Log(transform.name + " Litter:" + Litter + " litterAverageCarbonAmount:" + litterAverageCarbonAmount);
        }

        List<GameObject> removeList = new List<GameObject>();
        foreach (GameObject obj in litter)
        {
            float x, y, z;
            float factor = (1f - settings.DeadTreeShrinkFactor);
            x = obj.transform.localScale.x * factor;
            y = obj.transform.localScale.y * 0.998f;
            z = obj.transform.localScale.z * factor;

            obj.transform.localScale = new Vector3(x, y, z);
            if (obj.transform.localScale.x < 0.25f)
            {
                removeList.Add(obj);
                if (debugLitter)
                    Debug.Log("Will destroy litter object out of " + litter.Count);
            }
        }

        foreach (GameObject obj in removeList)
        {
            litter.Remove(obj);
            Destroy(obj);
        }
    }

    //public bool ShouldUpdateDataFromWeb()    // Unused
    //{
    //    if (timeIdx + timeStep > lastCurrentDataIdx)
    //        return true;
    //    else
    //        return false;
    //}

    public void UpdateDataFromWeb(int newTimeIdx, bool first, bool full) 
    {
        if (full)  // Always true
        {
            //Debug.Log("UpdateDataFromWeb()...");
            WebManager.Instance.RequestCubeData(patchID, warmingIdx, this.FinishUpdateDataFromWeb);
        }
        //else       // Unused
        //{
        //    firstCurrentDataIdx = newTimeIdx;
        //    if (first)                              // Get initial data
        //    {
        //        lastCurrentDataIdx = firstCurrentDataIdx + dataBuffer; // * timeStep < GameController.Instance.GetEndTimeIdx() ? timeIdx + 9 * timeStep : GameController.Instance.GetEndTimeIdx();
        //        Debug.Log("UpdateDataFromWeb()... first... newTimeIdx: " + newTimeIdx + " set lastCurrentDataIdx: " + lastCurrentDataIdx);
        //        WebManager.Instance.RequestData(patchID, warmingIdx, timeIdx, lastCurrentDataIdx, this.UpdateDataFromJSON);

        //        Debug.Log("UpdateDataFromWeb()... setting next data...");
        //        int end = lastCurrentDataIdx + dataBuffer;
        //        int last = GameController.Instance.GetEndTimeIdx();
        //        firstNextDataIdx = lastCurrentDataIdx + 1;
        //        lastNextDataIdx = end < last ? end : last;
        //        WebManager.Instance.RequestData(patchID, warmingIdx, firstNextDataIdx, lastNextDataIdx, this.UpdateNextDataFromJSON);
        //    }
        //    else
        //    {
        //        cubeData = nextCubeData;
        //        firstCurrentDataIdx = firstNextDataIdx;
        //        lastCurrentDataIdx = lastNextDataIdx;

        //        int end = lastCurrentDataIdx + dataBuffer;
        //        int last = GameController.Instance.GetEndTimeIdx();

        //        firstNextDataIdx = lastCurrentDataIdx + 1;
        //        lastNextDataIdx = end < last ? end : last;

        //        if(firstNextDataIdx <= lastCurrentDataIdx)
        //            return;

        //        Debug.Log("UpdateDataFromWeb()... newTimeIdx: " + newTimeIdx + " set firstCurrentDataIdx: " + firstCurrentDataIdx + " lastCurrentDataIdx:" + lastCurrentDataIdx + " firstNextDataIdx:" + firstNextDataIdx + " lastNextDataIdx:" + lastNextDataIdx);

        //        WebManager.Instance.RequestData(patchID, warmingIdx, firstNextDataIdx, lastNextDataIdx, this.UpdateNextDataFromJSON);
        //    }
        //}
    }

    private void UpdateDataFromJSON(string jsonString)
    {
        //Debug.Log("UpdateDataFromJSON()... FromJson:  " + "{\"rows\":" + jsonString + "}");
        CubeDataModelList rowsObj = JsonUtility.FromJson<CubeDataModelList>("{\"rows\":" + jsonString + "}");
        CubeData[] rows = rowsObj.rows;

        //Debug.Log(name + ".UpdateDataFromJSON()... rows.Length: " + rows.Length);
        //Debug.Log("UpdateDataFromJSON()... rows[0].DateIdx: " + rows[0].dateIdx + " rows[0].VegAccessWater" + rows[0].vegAccessWater + " rows[0].Evap: " + rows[0].evap + " rows[0].DepthToGW: " + rows[0].depthToGW);
        //Debug.Log("UpdateDataFromJSON()... rows[5].DateIdx: " + rows[5].dateIdx + " rows[5].VegAccessWater" + rows[5].vegAccessWater + " rows[5].Evap: " + rows[5].evap + " rows[5].DepthToGW: " + rows[5].depthToGW);

        cubeData = LoadData(rows);
    }

    private void UpdateDataRowsFromJSON(string jsonString)
    {
        CubeDataModelList rowsObj = JsonUtility.FromJson<CubeDataModelList>("{\"rows\":" + jsonString + "}");
        CubeData[] rows = rowsObj.rows;

        //Debug.Log(name + ".UpdateDataRowsFromJSON()... rows.Length: " + rows.Length);
        //Debug.Log("UpdateDataRowsFromJSON()... rows[0].DateIdx: " + rows[0].dateIdx + " rows[0].VegAccessWater" + rows[0].vegAccessWater + " rows[0].Evap: " + rows[0].evap + " rows[0].DepthToGW: " + rows[0].depthToGW);
        //Debug.Log("UpdateDataRowsFromJSON()... rows[5].DateIdx: " + rows[5].dateIdx + " rows[5].VegAccessWater" + rows[5].vegAccessWater + " rows[5].Evap: " + rows[5].evap + " rows[5].DepthToGW: " + rows[5].depthToGW);

        dataRows = rows;

        //FindParameterRanges();
    }

    private Dictionary<int, CubeData> LoadData(CubeData[] rows)
    {
        Dictionary<int, CubeData> result = new Dictionary<int, CubeData>();

        foreach(CubeData row in rows)
        {
            result.Add(row.dateIdx, row);
        }
        return result;
    }

    private void FinishUpdateDataFromWeb(string jsonString) // -- TO DO: OPTIMIZE THIS!!!  CALCULATE PARAMETERS ON BACKEND!!!
    {
        UpdateDataRowsFromJSON(jsonString);     // Update data for parameter range finding
        FindParameterRanges();
        UpdateDataFromJSON(jsonString);         // Update data for simulation

        GrowInitialVegetation();        // TESTING
    }

    /// <summary>
    /// Update data from model output for current time
    /// </summary>
    /// <param name="newTimeIdx">Current time.</param>
    private void UpdateCurrentData(int newTimeIdx)
    {
        //Debug.Log(name + ".UpdateVegetationBehavior()... newTimeIdx:"+ newTimeIdx);

        if (!simulationOn)
            return;

        timeIdx = newTimeIdx;

        if (settings.BuildForWeb)
        {
            CubeData row = GetDataRow(timeIdx);
            //Debug.Log("UpdateCurrentData()... timeIdx: " + timeIdx+ " row.soil:" + row.soil);

            if (dataType == CubeDataType.Veg1)
            {
                SnowAmount = row.snow;
                DepthToGW = row.depthToGW;
                WaterAccess = row.vegAccessWater;
                StreamHeight = row.Qout;
                Litter = row.litter;
                TransOver = row.transOver;
                LeafCarbonOver = row.leafCOver;
                StemCarbonOver = row.stemCOver;
                RootsCarbonOver = row.rootCOver;
            }
            else if (dataType == CubeDataType.Veg2)
            {
                SnowAmount = row.snow;
                DepthToGW = row.depthToGW;
                WaterAccess = row.vegAccessWater;
                StreamHeight = row.Qout;
                Litter = row.litter;
                TransOver = row.transOver;
                TransUnder = row.transUnder;
                LeafCarbonOver = row.leafCOver;
                LeafCarbonUnder = row.leafCUnder;
                StemCarbonOver = row.stemCOver;
                StemCarbonUnder = row.stemCUnder;
                RootsCarbonOver = row.rootCOver;
                RootsCarbonUnder = row.rootCUnder;
            }
            else if (dataType == CubeDataType.Agg)
            {
                SnowAmount = row.snow;
                DepthToGW = row.depthToGW;
                WaterAccess = row.vegAccessWater;
                StreamHeight = row.Qout;
                Litter = row.litter;
                NetTranspiration = row.transOver;
                LeafCarbonOver = row.leafCOver;
                LeafCarbonUnder = row.leafCUnder;
                StemCarbonOver = row.stemCOver;
                StemCarbonUnder = row.stemCUnder;
                RootsCarbonOver = row.rootCOver;
                RootsCarbonUnder = row.rootCUnder;
            }
        }
        else
        {
            if (dataType == CubeDataType.Veg1)
            {
                SnowAmount = ReadData((int)DataColumnIdx.Snow, timeIdx);
                DepthToGW = ReadData((int)DataColumnIdx.DepthToGW, timeIdx);
                WaterAccess = ReadData((int)DataColumnIdx.WaterAccess, timeIdx);
                StreamHeight = ReadData((int)DataColumnIdx.StreamLevel, timeIdx);
                Litter = ReadData((int)DataColumnIdx.Litter, timeIdx);
                TransOver = ReadData((int)DataColumnIdx.TransOver, timeIdx);
                LeafCarbonOver = ReadData((int)DataColumnIdx.LeafCarbonOver, timeIdx);
                StemCarbonOver = ReadData((int)DataColumnIdx.StemCarbonOver, timeIdx);
                RootsCarbonOver = ReadData((int)DataColumnIdx.RootCarbonOver, timeIdx);
            }
            else if (dataType == CubeDataType.Veg2)
            {
                SnowAmount = ReadData((int)DataColumnIdx.Snow, timeIdx);
                DepthToGW = ReadData((int)DataColumnIdx.DepthToGW, timeIdx);
                WaterAccess = ReadData((int)DataColumnIdx.WaterAccess, timeIdx);
                StreamHeight = ReadData((int)DataColumnIdx.StreamLevel, timeIdx);
                Litter = ReadData((int)DataColumnIdx.Litter, timeIdx);
                TransOver = ReadData((int)DataColumnIdx.TransOver, timeIdx);
                TransUnder = ReadData((int)DataColumnIdx.TransUnder, timeIdx);
                LeafCarbonOver = ReadData((int)DataColumnIdx.LeafCarbonOver, timeIdx);
                LeafCarbonUnder = ReadData((int)DataColumnIdx.LeafCarbonUnder, timeIdx);
                StemCarbonOver = ReadData((int)DataColumnIdx.StemCarbonOver, timeIdx);
                StemCarbonUnder = ReadData((int)DataColumnIdx.StemCarbonUnder, timeIdx);
                RootsCarbonOver = ReadData((int)DataColumnIdx.RootCarbonOver, timeIdx);
                RootsCarbonUnder = ReadData((int)DataColumnIdx.RootCarbonUnder, timeIdx);
            }
            else if (dataType == CubeDataType.Agg)
            {
                SnowAmount = ReadData((int)AggregateDataColumnIdx.Snow, timeIdx);
                DepthToGW = ReadData((int)AggregateDataColumnIdx.DepthToGW, timeIdx);
                WaterAccess = ReadData((int)AggregateDataColumnIdx.WaterAccess, timeIdx);
                StreamHeight = ReadData((int)AggregateDataColumnIdx.StreamLevel, timeIdx);
                Litter = ReadData((int)AggregateDataColumnIdx.Litter, timeIdx);
                NetTranspiration = ReadData((int)AggregateDataColumnIdx.Trans, timeIdx);
                LeafCarbonOver = ReadData((int)AggregateDataColumnIdx.LeafCarbonOver, timeIdx);
                LeafCarbonUnder = ReadData((int)AggregateDataColumnIdx.LeafCarbonUnder, timeIdx);
                StemCarbonOver = ReadData((int)AggregateDataColumnIdx.StemCarbonOver, timeIdx);
                StemCarbonUnder = ReadData((int)AggregateDataColumnIdx.StemCarbonUnder, timeIdx);
                RootsCarbonOver = ReadData((int)AggregateDataColumnIdx.RootCarbonOver, timeIdx);
                RootsCarbonUnder = ReadData((int)AggregateDataColumnIdx.RootCarbonUnder, timeIdx);
            }
        }
    }

    CubeData GetDataRow(int timeIdx)
    {
        //return dataRows[timeIdx - currentDataTimeIdx];
        if (timeIdx > cubeData.Count)
        {
            Debug.Log("GetDataRow() ERROR... timeIdx: "+timeIdx+" cubeData.Count:"+cubeData.Count);
            return null;
        }
        return cubeData[timeIdx];
    }

    #endregion

    #region Vegetation

    /// <summary>
    /// Instantiates tree from prefab.
    /// </summary>
    /// <returns>The tree from prefab.</returns>
    /// <param name="treeID">Tree id.</param>
    /// <param name="prefabListID">Prefab list id.</param>
    /// <param name="treeLocation">Tree location.</param>
    /// <param name="newRotation">New rotation.</param>
    /// <param name="parent">Parent.</param>
    private GameObject InstantiateTreeFromPrefab(int treeID, int prefabListID, Vector3 treeLocation, Quaternion newRotation, Transform parent)
    {
        /* Instantiate trunks and leaves */
        GameObject empty = new GameObject("Fir_" + treeID);
        GameObject newTree = Instantiate(empty, firLocations[treeID], newRotation, cubeObject.transform);
        Destroy(empty);

        int count = 0;

        foreach (GameObject prefab in treeList[prefabListID])
        {
            GameObject newTreePrefab = Instantiate(prefab, firLocations[treeID], prefab.transform.rotation, newTree.transform);
            newTreePrefab.name = "LODGroup_" + count;
            newTreePrefab.SetActive(false);

            count++;
        }

        GameObject newDeadTreePrefab = Instantiate(deadTreePrefab, firLocations[treeID], newRotation, newTree.transform);
        newDeadTreePrefab.transform.localRotation = newRotation;
        newDeadTreePrefab.name = "LODGroup_DeadTree";
        newDeadTreePrefab.SetActive(false);

        /* Add roots */
        for (int i = 0; i < rootsPrefabs.Count; i++)
        {
            GameObject rootsPrefab = rootsPrefabs[i];
            float rootsY = settings.RootsYOffsetFactor;
            Vector3 rootLocation = new Vector3(firLocations[treeID].x, firLocations[treeID].y + rootsY, firLocations[treeID].z);
            GameObject newRoots = Instantiate(rootsPrefab, rootLocation, rootsPrefab.transform.rotation, parent);       // Create root object from prefab

            newRoots.transform.parent = newTree.transform;
            newRoots.name = "Roots_" + i;

            Assert.IsNotNull(newRoots);
            newRoots.SetActive(false);
        }

        newTree.AddComponent<FirController>();

        FirController firController = newTree.GetComponent<FirController>() as FirController;
        firController.InitializeSettings(settings);
        firController.InitializeGeometry();
        firController.InitializePrefabs(treeList[0], rootsPrefabs, deadTreePrefab);
        firController.locationID = treeID;

        GameObject treeFireNodeChain = Instantiate(fireNodeChainPrefab, newTree.transform);         // Add fire node chain to tree

        //SERI_FireNodeChain nodeChain = newTree.GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;
        SERI_FireNodeChain nodeChain = treeFireNodeChain.GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;
        firController.InitFireNodeChain(nodeChain);

        nodeChain.fireNodes = new SERI_FireNode[1];
        nodeChain.fireNodes[0] = treeFireNodeChain.transform.GetChild(0).GetComponent<SERI_FireNode>();
        nodeChain.Initialize(fireManager, true, true);

        newTree.tag = "Fire";
        newTree.AddComponent<BoxCollider>();

        /* Create Box Collider */
        BoxCollider bc = newTree.GetComponent<BoxCollider>();
        //bc.material = treePhysicMaterial;
        bc.center = new Vector3(0f, 3f, 0f);
        bc.size = new Vector3(2.5f, 6f, 2.5f);

        float etY = etPrefab.transform.position.y;
        Vector3 etLocation = new Vector3(firLocations[treeID].x, firLocations[treeID].y + etY, firLocations[treeID].z);

        GameObject newETEmitter = Instantiate(etPrefab, etLocation, etPrefab.transform.rotation, parent);
        newETEmitter.transform.parent = newTree.transform;
        newETEmitter.name = "EvapTrans";

        return newTree;
    }

    /// <summary>
    /// Collects the litter from dead trees.
    /// </summary>
    private void CollectLitter()
    {
        GameObject[] objects = GameObject.FindGameObjectsWithTag("Litter");
        foreach (GameObject obj in objects)
        {
            obj.tag = "Untagged";
            litter.Add(obj);
        }
    }

    /// <summary>
    /// Clears all litter.
    /// </summary>
    private void ClearAllLitter()
    {
        if (litter == null)
            return;

        List<GameObject> removeList = new List<GameObject>();
        foreach (GameObject obj in litter)
        {
            removeList.Add(obj);
        }
        foreach (GameObject obj in removeList)
        {
            litter.Remove(obj);
            Destroy(obj);
        }
    }

    /// <summary>
    /// Grows the roots.
    /// </summary>
    private void GrowRoots()
    {
        //for (int i = 0; i < firs.Length; i++)
        for (int i = 0; i < firs.Count; i++)
        {
            if (firs[i].IsAlive())
                firs[i].GrowRoots();
        }
    }

    /// <summary>
    /// Grows a fir tree.
    /// </summary>
    private bool GrowAFir(bool immediate)
    {
        if (debugTrees && debugDetailed)
            Debug.Log(transform.name + " CubeController.GrowAFir()...  Growing fir" + (immediate ? " immediately..." : " at time:" + Time.time));

        int index = 0;
        while (activeFirLocations.Contains(index))
        {
            index++;
            if (index >= settings.MaxTrees)
            {
                if (debugTrees)
                    Debug.Log(name + ".GrowAFir()... Can't grow tree, max trees already grown!  activeFirLocations:" + activeFirLocations.Count);
                return false;
            }
            if (index > 1000)
            {
                Debug.Log(name + ".GrowAFir()... While loop error");
                return false;
            }
        }

        Quaternion newRotation = Quaternion.Euler(new Vector3(0, Random.Range(0, 360), 0));

        /* Instantiate fir */
        GameObject treePrefab = treeList[0][treeList[0].Count - 1];
        GameObject newTree = InstantiateTreeFromPrefab(index, 0, firLocations[index], newRotation, gameObject.transform);

        newTree.name = "Fir_" + index;
        FirController firController = newTree.GetComponent<FirController>();
        firs.Add(firController);                                                      // Save reference to FirController component

        bool isFront = (index < settings.MinFrontTrees) ? true : false;                 // Check whether tree is front tree (at beginning of list)

        firController.InitializeFir(terrain, isAggregate, isFront, GetTreeCarbonFactor(), GetRootsCarbonFactor(), neCorner, swCorner);

        float netTrans = TransOver;
        float leafCarbon = LeafCarbonOver;
        float stemCarbon = StemCarbonOver;
        float rootsCarbon = RootsCarbonOver;

        firController.UpdateSimulation(-1, timeStep, netTrans, leafCarbon, stemCarbon, rootsCarbon);

        float netTransMin = TransOverMin;
        float netTransMax = TransOverMax;
        float leafCarbonMin = LeafCarbonOverMin;
        float leafCarbonMax = LeafCarbonOverMax;
        float stemCarbonMin = StemCarbonOverMin;
        float stemCarbonMax = StemCarbonOverMax;
        float rootsCarbonMin = RootsCarbonOverMin;
        float rootsCarbonMax = RootsCarbonOverMax;

        firController.SetMinMaxRanges(netTransMin, netTransMax, leafCarbonMin, leafCarbonMax,
                                       stemCarbonMin, stemCarbonMax, rootsCarbonMin, rootsCarbonMax);

        bool grown = firController.Grow(immediate);
        if (grown)
        {
            activeFirLocations.Add(index);
        }
        else
        {
            Debug.Log(transform.name + ".GrowAFir()...  Couldn't grow tree at location: " + index);
            return false;
        }

        activeFirLocations.Sort();

        if (debugTrees && debugDetailed)
            Debug.Log(transform.name + ".GrowAFir()...  Spawning tree at location: " + index);

        lastFirGrownTimeIdx = timeIdx;

        UpdateETList();

        return grown;
    }

    private void GrowGrass()
    {
        List<int> removeList = new List<int>();
        int count = 0;
        foreach (GameObject grass in grasses)
        {
            float maxSize = maxGrassFullSize * cubeHeightScale;

            Renderer rend = grass.GetComponent<LODGroup>().GetLODs()[0].renderers[0];
            if (rend == null)
            {
                if (debugCubes)
                    Debug.Log(name + ".GrowShrubs()... Will remove null shrub id:" + count);
                removeList.Add(count);
            }
            else if (rend.bounds.size.y < maxSize)
            {
                float x = grass.transform.localScale.x + shrubGrowthIncrement;
                float y = grass.transform.localScale.y + shrubGrowthIncrement;
                float z = grass.transform.localScale.z + shrubGrowthIncrement;
                grass.transform.localScale = new Vector3(x, y, z);
            }

            count++;
        }

        var descendingOrder = removeList.OrderByDescending(i => i);
        removeList = descendingOrder.ToList<int>();

        if (removeList.Count > 0)                        // Remove destroyed shrubs
        {
            foreach (int i in removeList)
            {
                if (grasses.Count > i)
                    grasses.RemoveAt(i);
            }
        }
    }

    private void GrowAGrassPatch(bool immediate)
    {
        Vector3 grassLocation;

        float offsetX = terrain.GetPosition().x;
        float offsetZ = terrain.GetPosition().z;

        float cubeXMin = settings.CubeTreePadding;                    // Min. local X coord where shrubs grow
        float cubeXMax = cubeWidth - settings.CubeTreePadding;        // Max. local X coord where shrubs grow
        float cubeZMin = settings.CubeTreePadding;                    // Min. local Z coord where shrubs grow
        float cubeZMax = cubeWidth - settings.CubeTreePadding;        // Max. local Z coord where shrubs grow

        if (hasStream)                                   // Set shrub locations based on stream
        {
            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
            float randZ = Random.Range(cubeZMin, cubeZMax);
            randX += offsetX;
            randZ += offsetZ;
            grassLocation = new Vector3(randX, 0f, randZ);
            grassLocation.y = terrain.SampleHeight(grassLocation) + terrain.GetPosition().y;
            AddGrass(grassLocation, immediate);
        }
        else                                              // Set shrub locations without stream
        {
            float randX = Random.Range(cubeXMin, cubeXMax);
            float randZ = Random.Range(cubeZMin, cubeZMax);
            randX += offsetX;
            randZ += offsetZ;
            grassLocation = new Vector3(randX, 0f, randZ);
            grassLocation.y = terrain.SampleHeight(grassLocation) + terrain.GetPosition().y;
            AddGrass(grassLocation, immediate);
        }
    }

    private void GrowInitialGrass(int maxPatches)
    {
        int numGrass = (int)Random.Range(2, maxPatches);
        for (int i = 0; i < numGrass; i++)
        {
            GrowAGrassPatch(true);
        }
    }

    /// <summary>
    /// Adds grass patch.
    /// </summary>
    /// <returns>The shrub.</returns>
    /// <param name="location">Location.</param>
    /// <param name="immediate">If true, create instantaneously, otherwise grow from zero scale.</param>
    private void AddGrass(Vector3 location, bool immediate)
    {
        if (grasses == null)
            return;

        Quaternion newRotation = new Quaternion(0f, 0f, 0f, 0f);
        GameObject newGrassObj = Instantiate(grassPrefab, location, newRotation, cubeObject.transform);     // Instantiate shrub
        newRotation.eulerAngles.Set(0f, Random.Range(0f, 360f), 0f);                                     // Choose random rotation
        newGrassObj.transform.localRotation = newRotation;

        newGrassObj.GetComponent<SERI_FireNodeChain>().Initialize(fireManager, false, true);

        float grassSize = Random.Range(minGrassFullSize, maxGrassFullSize);
        if (immediate)
        {
            grassSize = Random.Range(0f, maxGrassFullSize);                                               // Set initial size
            newGrassObj.transform.localScale = new Vector3(grassSize, grassSize, grassSize);
        }
        else
        {
            newGrassObj.transform.localScale = Vector3.zero;
        }

        newGrassObj.name = "Grass";                                   // Set grass name
        grasses.Add(newGrassObj);                                     // Add grass to list

        float yPos = newGrassObj.transform.position.y;
        yPos += settings.ShrubHeightOffset;
        newGrassObj.transform.position = new Vector3(newGrassObj.transform.position.x, yPos, newGrassObj.transform.position.z);

        if (debugDetailed && debugShrubs)
            Debug.Log(transform.parent.name + " Instantiated " + newGrassObj.name + " at localPosition:" + newGrassObj.transform.localPosition);
    }

    /// <summary>
    /// Handles shrub growth.
    /// </summary>
    private void GrowShrubs()
    {
        List<int> removeList = new List<int>();
        int count = 0;
        foreach (ShrubController shrub in shrubs)
        {
            float maxSize = maxShrubFullSize * cubeHeightScale;

            Renderer rend = shrub.rend;
            if (rend == null)
            {
                if (debugCubes)
                    Debug.Log(name + ".GrowShrubs()... Will remove null shrub id:" + count);
                removeList.Add(count);
            }
            else if (rend.bounds.size.y < maxSize)
            {
                float x = shrub.transform.localScale.x + shrubGrowthIncrement;
                float y = shrub.transform.localScale.y + shrubGrowthIncrement;
                float z = shrub.transform.localScale.z + shrubGrowthIncrement;
                shrub.transform.localScale = new Vector3(x, y, z);
            }

            count++;
        }

        var descendingOrder = removeList.OrderByDescending(i => i);
        removeList = descendingOrder.ToList<int>();

        if (removeList.Count > 0)                        // Remove destroyed shrubs
        {
            foreach (int i in removeList)
            {
                if (shrubs.Count > i)
                    shrubs.RemoveAt(i);
            }
        }
    }

    /// <summary>
    /// Grows a shrub at a random location.
    /// </summary>
    private void GrowAShrub(bool immediate)
    {
        Vector3 shrubLocation;

        float offsetX = terrain.GetPosition().x;
        float offsetZ = terrain.GetPosition().z;

        float cubeXMin = settings.CubeTreePadding;                    // Min. local X coord where shrubs grow
        float cubeXMax = cubeWidth - settings.CubeTreePadding;        // Max. local X coord where shrubs grow
        float cubeZMin = settings.CubeTreePadding;                    // Min. local Z coord where shrubs grow
        float cubeZMax = cubeWidth - settings.CubeTreePadding;        // Max. local Z coord where shrubs grow

        if (hasStream)                                   // Set shrub locations based on stream
        {
            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
            float randZ = Random.Range(cubeZMin, cubeZMax);
            randX += offsetX;
            randZ += offsetZ;
            shrubLocation = new Vector3(randX, 0f, randZ);
            shrubLocation.y = terrain.SampleHeight(shrubLocation) + terrain.GetPosition().y;
            AddShrub(shrubLocation, immediate);
        }
        else                                              // Set shrub locations without stream
        {
            float randX = Random.Range(cubeXMin, cubeXMax);
            float randZ = Random.Range(cubeZMin, cubeZMax);
            randX += offsetX;
            randZ += offsetZ;
            shrubLocation = new Vector3(randX, 0f, randZ);
            shrubLocation.y = terrain.SampleHeight(shrubLocation) + terrain.GetPosition().y;
            AddShrub(shrubLocation, immediate);
        }
    }

    /// <summary>
    /// Adds the shrub.
    /// </summary>
    /// <returns>The shrub.</returns>
    /// <param name="location">Location.</param>
    /// <param name="immediate">If true, create instantaneously, otherwise grow from zero scale.</param>
    private void AddShrub(Vector3 location, bool immediate)
    {
        GameObject shrubPrefab;

        /* Choose random shrub prefab */
        int randIdx = (int)Mathf.Round(Random.Range(0f, shrubPrefabs.Count - 1f));
        shrubPrefab = shrubPrefabs[randIdx];

        Quaternion newRotation = new Quaternion(0f, 0f, 0f, 0f);
        GameObject newShrubObj = Instantiate(shrubPrefab, location, newRotation, cubeObject.transform);     // Instantiate shrub
        newRotation.eulerAngles.Set(0f, Random.Range(0f, 360f), 0f);                                     // Choose random rotation
        newShrubObj.transform.localRotation = newRotation;

        newShrubObj.AddComponent<ShrubController>();
        newShrubObj.GetComponent<SERI_FireNodeChain>().Initialize(fireManager, false, true);

        float shrubSize = Random.Range(minShrubFullSize, maxShrubFullSize);
        if (immediate)
        {
            shrubSize = Random.Range(0f, maxShrubFullSize);                                               // Set initial size
            newShrubObj.transform.localScale = new Vector3(shrubSize, shrubSize, shrubSize);
        }
        else
        {
            newShrubObj.transform.localScale = Vector3.zero;
        }

        newShrubObj.name = "Shrub_Type" + randIdx;                          // Set shrub name
        ShrubController shrubController = newShrubObj.GetComponent<ShrubController>();
        shrubs.Add(shrubController);                                  // Add shrub to list

        float yPos = newShrubObj.transform.position.y;
        yPos += settings.ShrubHeightOffset;
        newShrubObj.transform.position = new Vector3(newShrubObj.transform.position.x, yPos, newShrubObj.transform.position.z);

        float etY = etPrefab.transform.position.y;
        Vector3 etLocation = new Vector3(newShrubObj.transform.position.x, newShrubObj.transform.position.y + etY, newShrubObj.transform.position.z);

        shrubController.InitializeShrub(GetShrubRenderer(newShrubObj), newShrubObj.GetComponentInChildren<ParticleSystem>());

        UpdateETList();

        if (debugDetailed && debugShrubs)
            Debug.Log(transform.parent.name + " Shrub... Instantiated:" + newShrubObj.name + " at localPosition:" + newShrubObj.transform.localPosition);
    }

    /// <summary>
    /// Kills all trees.
    /// </summary>
    /// <param name="immediate">Whether to kill trees immediately.</param>
    private void KillAllTrees(bool immediate)
    {
        if (debugTrees)
            Debug.Log(transform.name + " CubeController.KillAllTrees()...");

        if (firs == null)
            return;

        List<FirController> removeList = new List<FirController>();

        for (int i = 0; i < firs.Count; i++)
        {
            FirController fc = firs[i];
            if (fc.IsAlive())
            {
                fc.Kill(immediate);
                if (immediate)
                    removeList.Add(fc);
            }
            else if (fc.IsDying())
            {
                fc.SetTreeToDead(false);
                removeList.Add(fc);
            }
            else
            {
                fc.HideLODGroups();
                fc.HideRootsObjects();
            }
        }

        for (int i = removeList.Count - 1; i >= 0; i--)
        {
            FirController fir = removeList[i];
            activeFirLocations.Remove(fir.locationID);

            firs.Remove(removeList[i]);
            if (immediate)
            {
                DestroyFir(fir);
            }
        }

        firsToKill = 0;
        lastKilledTreeFrame = timeIdx;

        UpdateETList();
    }

    /// <summary>
    /// Get number of dying trees
    /// </summary>
    /// <returns>The dying tree count.</returns>
    private int TreesDying()
    {
        int count = 0;
        //for (int i = 0; i < settings.MaxTrees; i++)
        for (int i = 0; i < firs.Count; i++)
        {
            if (firs[i].IsDying())
                count++;
        }
        return count;
    }

    /// <summary>
    /// Kills all shrubs.
    /// </summary>
    /// <param name="immediate">If set to <c>true</c> immediate.</param>
    private void KillAllShrubs(bool immediate)
    {
        if (debugShrubs)
            Debug.Log(transform.name + " CubeController.KillAllShrubs()...");

        for (int i = shrubs.Count - 1; i >= 0; i--)
        {
            KillShrubIdx(i);
        }

        shrubsToKill = 0;

        UpdateETList();
    }

    /// <summary>
    /// Returns whether all trees are dead.
    /// </summary>
    /// <returns><c>true</c>, if all trees are dead, <c>false</c> otherwise.</returns>
    private bool TreesAreDead()
    {
        //for (int i = 0; i < settings.MaxTrees; i++)
        for (int i = 0; i < firs.Count; i++)
        {
            if (firs[i].IsAlive())
                return false;
        }
        return true;
    }

    /// <summary>
    /// Returns whether all trees are dead.
    /// </summary>
    /// <returns><c>true</c>, if all trees are dead, <c>false</c> otherwise.</returns>
    private bool ShrubsAreDead()
    {
        if (shrubs.Count == 0)
            return true;
        else
            return false;
    }

    /// <summary>
    /// Returns number of alive trees in cube.
    /// </summary>
    /// <returns>The number of alive trees in cube.</returns>
    private int GetAliveTreesCount()
    {
        int count = 0;
        foreach (FirController fir in firs)
        {
            if (fir.IsAlive())
                count++;
        }
        return count;
    }

    /// <summary>
    /// Returns number of alive trees in cube.
    /// </summary>
    /// <returns>The number of alive trees in cube.</returns>
    private List<FirController> GetAliveTrees()
    {
        List<FirController> result = new List<FirController>();
        foreach (FirController fir in firs)
        {
            if (fir.IsAlive())
                result.Add(fir);
        }
        return result;
    }

    ///// <summary>
    ///// Gets the available trees.
    ///// </summary>
    ///// <returns>The available trees.</returns>
    //private List<FirController> GetAvailableTrees()
    //{
    //    List<FirController> result = new List<FirController>();
    //    foreach (FirController fir in firs)
    //    {
    //        //if (!fir.IsAlive() && !fir.IsDying())
    //        //Debug.Log("fir #" + fir.name + " alive:" + fir.IsAlive() + " dying:" + fir.IsDying() + " availble:" + fir.IsAvailable());
    //        if (fir.IsAvailable())
    //            result.Add(fir);
    //    }
    //    return result;
    //}


    /// <summary>
    /// Gets the renderer for given shrub GameObject.
    /// </summary>
    /// <returns>The shrub renderer.</returns>
    /// <param name="shrub">Shrub.</param>
    private Renderer GetShrubRenderer(GameObject shrub)
    {
        Renderer rend;
        if (shrub == null)
            return null;

        if (shrub.transform.childCount == 0)
        {
            rend = shrub.GetComponent<Renderer>();                              // Get renderer from first child object
        }
        else
        {
            rend = shrub.transform.GetChild(0).GetComponent<Renderer>();        // Get renderer from first child object
        }
        return rend;
    }

    ///// <summary>
    ///// Creates the shrubs.
    ///// </summary>
    //private void CreateShrubs()
    //{
    //    shrubCount = Random.Range(20, 50);                            // -- TEMPORARY: WILL BE REPLACED BY OVER/UNDERSTORY DATA

    //    if (debugDetailed && debugShrubs)
    //        Debug.Log(transform.parent.name + "CreateShrubs()... numShrubs:" + shrubCount);

    //    Vector3[] shrubLocations = new Vector3[shrubCount];
    //    shrubs = new List<ShrubController>();

    //    float offsetX = terrain.GetPosition().x;
    //    float offsetZ = terrain.GetPosition().z;

    //    float cubeXMin = settings.CubeTreePadding;                    // Min. local X coord where shrubs grow
    //    float cubeXMax = cubeWidth - settings.CubeTreePadding;        // Max. local X coord where shrubs grow
    //    float cubeZMin = settings.CubeTreePadding;                    // Min. local Z coord where shrubs grow
    //    float cubeZMax = cubeWidth - settings.CubeTreePadding;        // Max. local Z coord where shrubs grow

    //    if (hasStream)                          // Set shrub locations based on stream
    //    {
    //        for (int i = 0; i < shrubCount; i++)
    //        {
    //            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
    //            float randZ = Random.Range(cubeZMin, cubeZMax);

    //            randX += offsetX;
    //            randZ += offsetZ;

    //            shrubLocations[i] = new Vector3(randX, 0f, randZ);
    //            shrubLocations[i].y = terrain.SampleHeight(shrubLocations[i]) + terrain.GetPosition().y;
    //        }
    //    }
    //    else                                    // Set shrub locations without stream
    //    {
    //        for (int i = 0; i < shrubCount; i++)
    //        {
    //            float randX = Random.Range(cubeXMin, cubeXMax);
    //            float randZ = Random.Range(cubeZMin, cubeZMax);

    //            randX += offsetX;
    //            randZ += offsetZ;

    //            shrubLocations[i] = new Vector3(randX, 0f, randZ);
    //            shrubLocations[i].y = terrain.SampleHeight(shrubLocations[i]) + terrain.GetPosition().y;
    //        }
    //    }

    //    /* Instantiate Shrubs */
    //    for (int x = 0; x < shrubCount; x++)
    //    {
    //        AddShrub(shrubLocations[x], true);
    //    }
    //}


    /// <summary>
    /// Kills a Tree.
    /// </summary>
    /// <returns><c>true</c>, if a tree was killed, <c>false</c> otherwise.</returns>
    /// <param name="immediate">If set to <c>true</c> immediate.</param>
    private bool KillAFir(bool immediate)
    {
        List<FirController> aliveTrees = GetAliveTrees();

        if (aliveTrees.Count > 0)
        {
            int rand = (int)Random.Range(0, aliveTrees.Count);

            if (debugTrees && debugDetailed)
                Debug.Log(transform.name + ".KillAFir()...  Tree to kill:" + rand);

            if (rand >= 0 && rand < aliveTrees.Count)
            {
                FirController fir = aliveTrees[rand];

                fir.Kill(immediate);

                if (immediate)
                    activeFirLocations.Remove(fir.locationID);
            }
            else
                Debug.Log(name + "KillAFir()... ERROR: rand:" + rand + " aliveTrees.Count:" + aliveTrees.Count);

            lastKilledTreeFrame = timeIdx;
            firsToKill--;

            UpdateETList();
            return true;
        }
        else
        {
            Debug.Log(transform.name + ".KillAFir()...  Can't kill a fir... no firs are alive.");
            return false;
        }

    }

    /// <summary>
    /// Destroys the fir.
    /// </summary>
    /// <param name="fir">Fir.</param>
    private void DestroyFir(FirController fir)
    {
        //Debug.Log(name+".DestroyFir()... fir:" + fir.name+" locationID:"+fir.locationID+" activeLocationIDs contains? "+activeFirLocations.Contains(fir.locationID));

        for (int i = fir.gameObject.transform.childCount - 1; i >= 0; i--)
            Destroy(fir.gameObject.transform.GetChild(i).gameObject);

        Destroy(fir.gameObject);
    }

    /// <summary>
    /// Kills a grass patch
    /// </summary>
    private void KillAGrassPatch()
    {
        int rand = (int)Mathf.Round(Random.Range(0f, grasses.Count - 1));
        KillGrassIdx(rand);
        grassesToKill--;
    }

    /// <summary>
    /// Kills a random shrub.
    /// </summary>
    private void KillAShrub()
    {
        int rand = (int)Mathf.Round(Random.Range(0f, shrubs.Count - 1));
        KillShrubIdx(rand);
        shrubsToKill--;
    }

    private void KillGrassIdx(int grassID)
    {
        GameObject obj = null;

        if (grassID < 0 || grassID >= grasses.Count)
        {
            //Debug.Log(name + ".KillGrassIdx()... Tried to kill shrub id:" + grassID + " but grasses.Count: " + grasses.Count);
            return;
        }

        if (grasses[grassID] == null)
        {
            //Debug.Log(name + ".KillGrassIdx()... grasses[grassID] for id:" + grassID + " is null!");
            return;
        }
        if (grasses[grassID].gameObject == null)
        {
            //Debug.Log(name + ".KillGrassIdx()... grasses[grassID].gameObject for id:" + grassID + " is null!");
            return;
        }

        if (grassID >= 0 && grassID < grasses.Count)
            obj = grasses[grassID].gameObject;

        if (obj != null)
        {
            for (int i = obj.transform.childCount - 1; i >= 0; i--)
                Destroy(obj.transform.GetChild(i).gameObject);

            grasses.RemoveAt(grassID);
            Destroy(obj.gameObject);
        }

        if (debugDetailed && debugShrubs)
            Debug.Log("KillGrassIdx()... id:" + grassID);
    }

    /// <summary>
    /// Kills given shrub.
    /// </summary>
    /// <param name="shrubID">Identifier.</param>
    private void KillShrubIdx(int shrubID)
    {
        GameObject obj = null;

        if (shrubID < 0 || shrubID >= shrubs.Count)
        {
            Debug.Log(name + ".KillShrubIdx()... Tried to kill shrub id:" + shrubID + " but shrubs.Count: "+shrubs.Count);
            return;
        }

        if(shrubs[shrubID] == null)
        {
            Debug.Log(name + ".KillShrubIdx()... shrubs[shrubID] for id:" + shrubID + " is null!");
            return;
        }
        if (shrubs[shrubID].gameObject == null)
        {
            Debug.Log(name + ".KillShrubIdx()... shrubs[shrubID].gameObject for id:" + shrubID + " is null!");
            return;
        }

        if (shrubID >= 0 && shrubID < shrubs.Count)
            obj = shrubs[shrubID].gameObject;

        if (obj != null)
        {
            for (int i = obj.transform.childCount - 1; i >= 0; i--)
                Destroy(obj.transform.GetChild(i).gameObject);

            shrubs.RemoveAt(shrubID);
            Destroy(obj.gameObject);
        }

        if (debugDetailed && debugShrubs)
            Debug.Log("KillShrub()... id:" + shrubID);
    }
    #endregion

    #region Fire
    /// <summary>
    /// Ignites the fire.
    /// </summary>
    /// <param name="fireTimeIdx">Time index of fire.</param>
    /// <param name="useThresholds">Whether to use thresholds to determine whether to start fire (true) or simply start fire (false).</param>
    public void IgniteTerrain(int fireTimeIdx, bool useThresholds)
    {
        if (!terrainBurning && !terrainBurnt)
        {
            if (fireTimeIdx + 1 > GameController.Instance.GetDates().Count - 2)
            {
                Debug.Log(name + ".IgniteTerrain()...  cancelling burn... fire time after data length!  fireTimeIdx:" + fireTimeIdx);
                return;
            }

            SetVegetationToDieFromFire(fireTimeIdx);

            if (cubeObject.activeSelf == false)                 // Don't ignite fire if cube hidden
                return;

            int frameRate = 30;

            int frameLength;
            float fireLengthInSec = settings.MaxFireLengthInSec;                                           

            // Ignite cube terrain cells immediately, since no cube-level spread data
            if (settings.AutoPauseOnFire)
            {
                frameLength = (int)settings.MaxFireLengthInSec * frameRate;
                frameLength = Mathf.Clamp(frameLength, settings.MinFireFrameLength, frameLength);       // Hold to minimum frame length
                fireManager.IgniteTerrain(terrain, timeStep, fireLengthInSec, 0);
            }
            else
            {
                frameLength = (int)settings.MaxFireLengthInSec * frameRate / timeStep;
                frameLength = Mathf.Clamp(frameLength, settings.MinFireFrameLength, frameLength);       // Hold to minimum frame length

                if (debugFire)
                    Debug.Log(name + ".IgniteTerrain()... timeStep:" + timeStep + " frameRate:" + frameRate + " settings.MaxFireLength:" + settings.MaxFireLengthInSec + " fireLengthInFrames:" + frameLength + " time:" + Time.time);

                fireLengthInSec = frameLength / frameRate;                                              // Calculate fire length in seconds

                fireManager.IgniteTerrain(terrain, timeStep, fireLengthInSec, 0);
            }

            if (debugFire)
                Debug.Log(name + ".IgniteTerrain()... timeStep:" + timeStep + " frameRate:" + frameRate  + " fireLengthInFrames:" + frameLength + " time:" + Time.time);

            SetShrubsToBurn(frameLength);

            if (dataType == CubeDataType.Veg2)
                SetTreesToBurn(frameLength);

            terrainBurning = true;
        }
        else
        {
            Debug.Log(name + ".IgniteFire()... ERROR Couldn't ignite since already burning / burnt!");
        }
    }

    public SERI_FireManager GetFireManager()
    {
        return fireManager;
    }

    /// <summary>
    /// Cleans up dead firs.
    /// </summary>
    private void CleanUpDeadFirs()
    {
        List<int> removeList = new List<int>();
        for (int i = 0; i < firs.Count; i++)
        {
            if (firs[i].destroyed)
            {
                //Debug.Log(name + ".CleanUpDeadFirs()... i:" + i + " firs[i].destroyed: " + firs[i].destroyed + "  Loc ID:" + firs[i].locationID);
                removeList.Add(i);
                activeFirLocations.Remove(firs[i].locationID);
                DestroyFir(firs[i]);
            }
        }

        //if (debugFire || debugTrees)
        //Debug.Log(name + ".CleanUpDeadFirs()... will remove " + removeList.Count + " firs");

        var descending = removeList.OrderByDescending(i => i);
        removeList = descending.ToList<int>();

        if (removeList.Count > 0)
        {
            foreach (int i in removeList)
            {
                firs.RemoveAt(i);
            }
        }
    }

    /// <summary>
    /// Cleans up burnt vegetation.
    /// </summary>
    private void CleanUpBurntVegetation()
    {
        List<int> removeList = new List<int>();
        for (int i = 0; i < shrubs.Count; i++)
        {
            if (shrubs[i] == null)
            {
                removeList.Add(i);
            }
        }

        var descendingOrder = removeList.OrderByDescending(i => i);
        removeList = descendingOrder.ToList<int>();

        if (removeList.Count > 0)
        {
            if (debugShrubs || debugFire)
                Debug.Log(name + ".CleanUpBurntVegetation()... will remove " + removeList.Count + " shrubs");

            foreach (int i in removeList)
            {
                shrubs.RemoveAt(i);
            }
        }
    }

    /// <summary>
    /// Set vegetation to die from fire
    /// </summary>
    /// <param name="fireTimeIdx">Time index of fire</param>
    private void SetVegetationToDieFromFire(int fireTimeIdx)            // TO DO: Fix for web (?)
    {
        if (dataType == CubeDataType.Veg1)
        {
            float fireLeafCarbon = ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx);        // Read carbon data at fireTimeIdx
            float fireStemCarbon = ReadData((int)DataColumnIdx.StemCarbonOver, fireTimeIdx);

            float shrubCarbonInData = fireStemCarbon + fireLeafCarbon;    // Get combined stem + leaf carbon in data
                                                                          //float shrubCarbonInData = StemCarbon + LeafCarbon;    // Get combined stem + leaf carbon in data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();      // Get carbon amount represented by shrubs in current simulation
            shrubsToKill = (int)Mathf.Round((shrubCarbonInViz - shrubCarbonInData) / shrubAverageCarbonAmount);
        }
        else if (dataType == CubeDataType.Veg2)
        {
            float fireLeafCarbonOver = ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx);
            float fireLeafCarbonUnder = ReadData((int)DataColumnIdx.LeafCarbonUnder, fireTimeIdx);
            float fireStemCarbonOver = ReadData((int)DataColumnIdx.StemCarbonOver, fireTimeIdx);
            float fireStemCarbonUnder = ReadData((int)DataColumnIdx.StemCarbonUnder, fireTimeIdx);

            float combinedCarbonOverInData = fireStemCarbonOver + fireLeafCarbonOver;       // Get combined stem + leaf carbon in overstory data
            float combinedCarbonUnderInData = fireStemCarbonUnder + fireLeafCarbonUnder;    // Get combined stem + leaf carbon in understory data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();                      // Get carbon amount represented by shrubs in current simulation
            float treeCarbonInViz = GetTreeCarbonAmountVisualized();                        // Get carbon amount represented by trees in current simulation

            shrubsToKill = (int)Mathf.Round((shrubCarbonInViz - combinedCarbonUnderInData) / shrubAverageCarbonAmount);
            firsToKill = (int)Mathf.Round((treeCarbonInViz - combinedCarbonOverInData) / treeAverageCarbonAmount);
        }
        else if (dataType == CubeDataType.Agg)
        {
            float fireLeafCarbonOver = ReadData((int)AggregateDataColumnIdx.LeafCarbonOver, fireTimeIdx);
            float fireLeafCarbonUnder = ReadData((int)AggregateDataColumnIdx.LeafCarbonUnder, fireTimeIdx);
            float fireStemCarbonOver = ReadData((int)AggregateDataColumnIdx.StemCarbonOver, fireTimeIdx);
            float fireStemCarbonUnder = ReadData((int)AggregateDataColumnIdx.StemCarbonUnder, fireTimeIdx);

            float combinedCarbonOverInData = fireStemCarbonOver + fireLeafCarbonOver;       // Get combined stem + leaf carbon in overstory data
            float combinedCarbonUnderInData = fireStemCarbonUnder + fireLeafCarbonUnder;    // Get combined stem + leaf carbon in understory data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();                      // Get carbon amount represented by shrubs in current simulation
            float treeCarbonInViz = GetTreeCarbonAmountVisualized();                        // Get carbon amount represented by trees in current simulation

            shrubsToKill = (int)Mathf.Round((shrubCarbonInViz - combinedCarbonUnderInData) / shrubAverageCarbonAmount);
            firsToKill = (int)Mathf.Round((treeCarbonInViz - combinedCarbonOverInData) / treeAverageCarbonAmount);
            //Debug.Log(name + ".IgniteFire()...  treeCarbonInViz:" + treeCarbonInViz + " fireStemCarbonOver:" + fireStemCarbonOver + " fireLeafCarbonOver:" + fireLeafCarbonOver);
            //Debug.Log(name + ".IgniteFire()...  shrubCarbonInViz:" + shrubCarbonInViz + " fireStemCarbonUnder:" + fireStemCarbonUnder + " fireLeafCarbonUnder:" + fireLeafCarbonUnder);
            //Debug.Log(name + ".IgniteFire()...  shrubsToKill:" + shrubsToKill + " firsToKill:" + firsToKill + " startFire:" + startFire);
        }
    }

    /// <summary>
    /// Set shrubs to burn
    /// </summary>
    /// <param name="fireLengthInFrames"></param>
    private void SetShrubsToBurn(int fireLengthInFrames)
    {
        foreach (ShrubController shrubController in shrubs)                // Select shrubs to burn
        {
            GameObject shrub = shrubController.gameObject;

            SERI_FireNodeChain chain = shrub.GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;

            if (shrubsToKill > 0)                       // Burn given number of firs
            {
                chain.enabled = true;                   // Make sure burning is enabled for shrub
                chain.Ignite(shrub.transform.position, fireLengthInFrames);
                shrubsToKill--;
            }
            else
            {
                chain.enabled = false;                  // Disable burning for shrub
            }

            shrubsToKill--;
        }

        shrubsToKill = 0;                                   // Reset number of shrubs to kill
    }

    /// <summary>
    /// Set trees to burn
    /// </summary>
    /// <param name="fireLengthInFrames"></param>
    private void SetTreesToBurn(int fireLengthInFrames)
    {
        if (dataType == CubeDataType.Veg2)
        {
            List<FirController> aliveTrees = GetAliveTrees();

            if (debugFire || debugTrees)
                Debug.Log(name + ".SetTreesToBurn()... fireLengthInFrames:" + fireLengthInFrames + " aliveTrees.Count:" + aliveTrees.Count + " firsToKill:" + firsToKill + " shrubsToKill:" + shrubsToKill + " time:" + Time.time);

            for (int i = aliveTrees.Count - 1; i > 0f; i--)      // Select firs to burn starting from last idx
            {
                FirController fir = aliveTrees[i];

                if (firsToKill > 0)                         // Burn given number of firs
                {
                    fir.fireNodeChain.enabled = true;       // Enable burning for tree
                    fir.Ignite(true, fireLengthInFrames);
                    firsToKill--;
                }
                else
                {
                    fir.fireNodeChain.enabled = false;      // Disable burning for tree
                }
            }

            firsToKill = 0;                                 // Reset number of firs to kill
        }
    }

    /// <summary>
    /// Checks if fire still burning.
    /// </summary>
    /// <returns><c>true</c>, if burning was stilled, <c>false</c> otherwise.</returns>
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
    /// Returns whether cube is burning
    /// </summary>
    /// <returns><c>true</c>, if cube is burning, <c>false</c> otherwise.</returns>
    public bool IsBurning()
    {
        return terrainBurning;
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
    /// Find whether fire should burn at date (CAW Installation).
    /// </summary>
    /// <returns><c>true</c>, if fire should burn at date, <c>false</c> otherwise.</returns>
    /// <param name="date">Date.</param>
    public bool ShouldBurnFireOnDate(Vector3 date)
    {
        if (date.Equals(new Vector3(7, 15, 1969)))
        {
            switch (name)
            {
                case "CubeA":
                    if (warmingDegrees == 2 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeB":
                    return false;
                case "CubeC":
                    return true;
                case "CubeD":
                    return false;
                case "CubeE":
                    if (warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeF":
                    if (warmingDegrees == 2 || warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                default:
                    return false;
            }
        }
        else if (date.Equals(new Vector3(11, 20, 1988)))
        {
            switch (name)
            {
                case "CubeA":               // A
                    if (warmingDegrees == 1 || warmingDegrees == 2 || warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeF":                       // F
                    if (warmingDegrees == 1 || warmingDegrees == 2 || warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeE":                       // E
                    if (warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeD":                       // D
                    if (warmingDegrees == 1 || warmingDegrees == 2 || warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                case "CubeC":                       // C
                    return true;
                case "CubeB":                       // B
                    if (warmingDegrees == 2 || warmingDegrees == 4 || warmingDegrees == 6)
                        return true;
                    else
                        return false;
                default:
                    return false;
            }
        }
        return false;
    }
    #endregion

    #region Animation

    /// <summary>
    /// Starts animated movement / growth from start point to destination point.
    /// </summary>
    /// <param name="startPos">Start position.</param>
    /// <param name="destPos">Destination position.</param>
    /// <param name="animationType">Animation type.</param>
    public void StartAnimation(Vector3 startPos, Vector3 destPos, CubeAnimationType animationType)
    {
        animating = true;
        animationStartTime = Time.time;
        animationEndTime = Time.time + animationLength;
        startPosition = startPos;
        startPosition.x += cubeWidth / 2f;
        targetPosition = destPos;
        targetPosition.x += cubeWidth / 2f;

        if (animationType == CubeAnimationType.shrink)
        {
            startScale = animatedCubeFullScale;
            halfTargetScale = new Vector3(startScale.x / 2f, startScale.y / 2f, startScale.z / 2f);
            targetScale = new Vector3(0, 0, 0);
        }
        else if (animationType == CubeAnimationType.grow)
        {
            startScale = new Vector3(0, 0, 0);
            targetScale = animatedCubeFullScale;
            halfTargetScale = new Vector3(targetScale.x / 4f, targetScale.y / 4f, targetScale.z / 4f);
        }
        else if (animationType == CubeAnimationType.still)
        {
            startScale = cubeObject.transform.localScale;
            targetScale = cubeObject.transform.localScale;
            halfTargetScale = cubeObject.transform.localScale;
        }

        cubeObject.SetActive(false);
        animated = Instantiate(animationPrefab, transform, false);
        animated.transform.position = startPosition;
        animated.transform.localScale = startScale;
    }
    #endregion

    #region Terrain
    /// <summary>
    /// Assigns the default splatmap (Editor).
    /// </summary>
    private float[,,] CreateUnburntSplatmap()
    {
        //Debug.Log(transform.parent.name + " AssignDefaultSplatmap()...");

        UnityEngine.TerrainData terrainData = terrain.terrainData;

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

                //splatWeights[0] = 0f;
                //splatWeights[0] = 0.5f;

                // Texture[0] Grass (No Snow)
                splatWeights[0] = Mathf.Clamp01((terrainData.heightmapResolution - height));            //  Stronger at lower altitudes

                // Texture[1]  Grass (Snow)
                splatWeights[1] = 1f;// - splatWeights[2];

                // Note "steepness" is unbounded, so we "normalise" it by dividing by the extent of heightmap height and scale factor
                // Subtract result from 1.0 to give greater weighting to flat surfaces
                splatWeights[3] = Mathf.Clamp01(steepness * steepness / (terrainData.heightmapResolution / 5.0f));          // Weight to steeper terrain

                // Texture[3] increases with height but only on surfaces facing positive Z axis 
                splatWeights[2] = 0f;

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

        // Assign new splatmap to terrain
        //terrainData.SetAlphamaps(0, 0, splatmapData);
    }

    /// <summary>
    /// Transitions to default splatmap.
    /// </summary>
    void TransitionToUnburntSplatmap()
    {
        // Get a reference to the terrain data
        UnityEngine.TerrainData terrainData = terrain.terrainData;

        // Splatmap data is stored internally as a 3d array of floats, so declare a new empty array ready for your custom splatmap data:
        float[,,] splatmapData = new float[terrainData.alphamapWidth, terrainData.alphamapHeight, terrainData.alphamapLayers];

        float pos = MapValue(timeIdx - fireRegrowthStartTimeIdx, 0, fireGrassRegrowthLength, 0f, 1f);

        if (pos >= 1f)                   // Check if burn finished
        {
            if (debugFire)
                Debug.Log(name + "... Ended fire animation   Time:"+Time.time);

            ResetTerrainSplatmap();
            lastBurnEndedTime = Time.time;
        }
        else
        {
            if (debugFire)
                Debug.Log(name + "... Updating fire transition... fireRegrowthStartTimeIdx:" + fireRegrowthStartTimeIdx + " pos:" + pos + " time:" + Time.time);

            for (int y = 0; y < terrainData.alphamapHeight; y++)
            {
                for (int x = 0; x < terrainData.alphamapWidth; x++)
                {
                    for (int i = 0; i < terrainData.alphamapLayers; i++)                // Assign interpolated value to each terrain texture
                    {
                        float val = Mathf.Lerp(burntSplatmap[x, y, i], unburntSplatmap[x, y, i], pos);
                        splatmapData[x, y, i] = val;
                    }
                }
            }

            terrain.terrainData.SetAlphamaps(0, 0, splatmapData);           // Assign new splatmap to terrain
        }
    }

    /// <summary>
    /// Resets terrain splatmap.
    /// </summary>
    public void ResetTerrainSplatmap()
    {
        terrain.terrainData.SetAlphamaps(0, 0, unburntSplatmap);
        terrainBurnt = false;
    }

    /// <summary>
    /// Assigns the default splatmap (Editor).
    /// </summary>
    private float[,,] CreateBurntSplatmap()
    {
        // Get a reference to the terrain data
        UnityEngine.TerrainData terrainData = terrain.terrainData;

        // Splatmap data is stored internally as a 3d array of floats, so declare a new empty array ready for your custom splatmap data:
        float[,,] splatmapData = new float[terrainData.alphamapWidth, terrainData.alphamapHeight, terrainData.alphamapLayers];

        for (int y = 0; y < terrainData.alphamapHeight; y++)
        {
            for (int x = 0; x < terrainData.alphamapWidth; x++)
            {
                float[] splatWeights = new float[terrainData.alphamapLayers];

                splatWeights[0] = 0f;
                splatWeights[1] = 0f;
                splatWeights[2] = 1f;
                splatWeights[3] = 0f;

                // Sum of all textures weights must add to 1, so calculate normalization factor from sum of weights
                float z = splatWeights.Sum();

                // Loop through each terrain texture
                for (int i = 0; i < terrainData.alphamapLayers; i++)
                {
                    splatWeights[i] /= z;                       // Normalize so that sum of all texture weights = 1
                    splatmapData[x, y, i] = splatWeights[i];    // Assign this point to the splatmap array
                }

                //Debug.Log(" x:" + x + " y:" + y);
            }
        }

        return splatmapData;
    }

    /// <summary>
    /// Saves the unburnt terrain.
    /// </summary>
    private float[,,] GetTerrainSplatmap()
    {
        UnityEngine.TerrainData terrainData = terrain.terrainData;
        //unburntSplatmap = terrainData.GetAlphamaps(0, 0 , terrainData.alphamapHeight, terrainData.alphamapLayers);
        return terrainData.GetAlphamaps(0, 0, terrainData.alphamapHeight, terrainData.alphamapLayers);
    }

    #endregion

    #region Resetting
    /// <summary>
    /// Resets the cube to initial state.
    /// </summary>
    public void ResetCube()
    {
        ResetTerrainSplatmap();

        KillAllTrees(true);
        KillAllShrubs(true);
        ClearAllLitter();
        SetInitParameterValues();

        snowManager.snowValue = 0f;
    }
    #endregion

    #region Utilities

    /// <summary>
    /// Gets random value within range, excluding given middle range.
    /// </summary>
    /// <returns>The random excluding range.</returns>
    /// <param name="lower">Lower bound.</param>
    /// <param name="upper">Upper bound.</param>
    /// <param name="excludeLower">Exclude lower bound.</param>
    /// <param name="excludeUpper">Exclude upper bound.</param>
    private static float GetRandomExcludingMiddle(float lower, float upper, float excludeLower, float excludeUpper)
    {
        if (excludeLower < lower || excludeUpper > upper)
        {
            Debug.Log("GetRandomExcludingRange()... while loop ERROR 1...");
            throw new System.Exception();      // -- TEST

            //return 0f;
        }

        float rand = Random.Range(lower, upper);

        int count = 0;
        while (rand > excludeLower && rand < excludeUpper)        // Avoid excluded range
        {
            rand = Random.Range(lower, upper);
            if (++count > 200)
            {
                Debug.Log("GetRandomExcludingRange()... while loop ERROR 2...");
                throw new System.Exception();      // -- TEST

                //break;
            }
        }
        return rand;
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
    /// Text asset to list.
    /// </summary>
    /// <returns>The asset to list.</returns>
    /// <param name="ta">Ta.</param>
    private List<string> TextAssetToList(TextAsset ta)
    {
        return new List<string>(ta.text.Split('\n'));   // Convert TextAsset to list
    }

    #endregion

    #region Data
    /// <summary>
    /// Gets the data.
    /// </summary>
    /// <returns>The data.</returns>
    public float[,] GetCurrentData()
    {
        //Debug.Log(transform.name + " GetCurrentData... warmingIdx:" + warmingIdx);

        if (settings.BuildForWeb)
            return null;
        else
            return dataArray[warmingIdx];
    }


    /// <summary>
    /// Check whether data exists.
    /// </summary>
    /// <returns>Whether data array is null</returns>
    public bool DataExists()
    {
        if (settings.BuildForWeb)
            return true;                // TO DO: Improve
        else
            return dataArray != null;
    }

    /// <summary>
    /// Gets the data.
    /// </summary>
    /// <returns>The data.</returns>
    /// <param name="index">Cube index.</param>
    public float[,] GetDataForWarmingIdx(int index)
    {
        if (settings.BuildForWeb)       // Note: ignores index in build for web mode
        {
            float[,] result = new float[dataRows.Length, (int)DataColumnIdx.Day - 1];
            int count = 0;
            foreach(CubeData row in dataRows)
            {
                //Debug.Log(name + ".GetDataForWarmingIdx()... BuildforWeb... #" + count + " row.GetArray().Length:" + row.GetArray().Length + " vs. (int)DataColumnIdx.Day:" + (int)DataColumnIdx.Day);
                //Debug.Log(name + ".GetDataForWarmingIdx()... dataRows.Length:" + dataRows.Length +" result.GetLength(0):" + result.GetLength(0) + " result.GetLength(1):" + result.GetLength(1));

                float[] array = GetArrayForRow(row);
                for (int i = 0; i < (int)DataColumnIdx.Day - 1; i++)
                {
                    //result[count, i] = row.GetArray()[i];
                    result[count, i] = array[i];
                }
                count++;
            }

            return result;
        }
        else
            return dataArray[index];
    }

    public float[] GetArrayForRow(CubeData row)
    {
        float[] arr = new float[22];
        arr[0] = row.dateIdx;
        arr[1] = row.snow;
        arr[2] = row.evap;
        arr[3] = row.netpsn;
        arr[4] = row.depthToGW;
        arr[5] = row.vegAccessWater;
        arr[6] = row.Qout;
        arr[7] = row.litter;
        arr[8] = row.soil;
        arr[9] = row.heightOver;
        arr[10] = row.transOver;
        arr[11] = row.heightUnder;
        arr[12] = row.transUnder;
        arr[13] = row.leafCOver;
        arr[14] = row.stemCOver;
        arr[15] = row.rootCOver;
        arr[16] = row.leafCUnder;
        arr[17] = row.stemCUnder;
        arr[18] = row.rootCUnder;
        return arr;
    }

    /// <summary>
    /// Updates the minimum and maximum values of data parameters from current data file.
    /// </summary>
    //public void FindParameterRangesForCurrentWarmingIdx()
    //{
    //    float[,] cubeData = GetCurrentData();
    //    CalculateSoilRanges(cubeData, true);
    //    CalculateParameterRanges(cubeData, true);
    //}

    /// <summary>
    /// Updates the minimum and maximum values of data parameters from all warming scenario data files for this cube.
    /// </summary>
    public void FindParameterRanges()
    {
        if (settings.BuildForWeb)
        {
            //float[,] cubeData = GetDataForWarmingIdx(0);
            CalculateSoilRangesForWeb(false);
            CalculateParameterRangesForWeb(false);
        }
        else
        {
            for (int w=0; w<warmingRange; w++)
            {
                float[,] cubeData = GetDataForWarmingIdx(w);
                CalculateSoilRanges(cubeData, false);
                CalculateParameterRanges(cubeData, false);
            }
        }
    }

    /// <summary>
    /// Updates water access min / max values.
    /// </summary>
    /// <param name="cubeData">Cube data.</param>
    private void CalculateSoilRanges(float[,] cubeData, bool resetValues)
    {
        int rows = cubeData.GetLength(0);
        int row = 0;                                      // Row

        int w = (int)DataColumnIdx.WaterAccess;     // Water Access Column
        int d = (int)DataColumnIdx.DepthToGW;       // Depth to G.W. Column

        if (dataType == CubeDataType.Agg)
        {
            w = (int)AggregateDataColumnIdx.WaterAccess;     // Water Access Column
            d = (int)AggregateDataColumnIdx.DepthToGW;       // Depth to G.W. Column
        }

        if (resetValues)
        {
            WaterAccessMin = 100000f;         // Set Min. waterAccess 
            WaterAccessMax = -100000f;         // Set Max. waterAccess 
            DepthToGWMin = 100000f;           // Set Min. depthToGW
            DepthToGWMax = -100000f;           // Set Max. depthToGW 
        }

        while (row < rows - 1)
        {
            float val = cubeData[row, w];
            if (val < WaterAccessMin)
                WaterAccessMin = val;
            if (val > WaterAccessMax)
                WaterAccessMax = val;

            float val2 = cubeData[row, d];
            if (val2 < DepthToGWMin)
                DepthToGWMin = val2;
            if (val2 > DepthToGWMax)
                DepthToGWMax = val2;

            row++;
        }

        //Debug.Log(" WaterAccessMin:" + WaterAccessMin + " WaterAccessMax:" + WaterAccessMax);
        //Debug.Log(" DepthToGWMin:" + DepthToGWMin + " DepthToGWMax:" + DepthToGWMax);

        soilController.SetMinMaxRanges(WaterAccessMin, WaterAccessMax, DepthToGWMin, DepthToGWMax);
    }

    /// <summary>
    /// Updates the parameter ranges (min/max values).
    /// </summary>
    /// <param name="cubeData">Cube data.</param>
    private void CalculateParameterRanges(float[,] cubeData, bool resetValues)
    {
        if (debugDetailed && debugTrees)
            Debug.Log("CalculateParameterRanges()... Time:" + Time.time);

        int rows = cubeData.GetLength(0);
        int i = 0;                                              // Data Row

        int s = (int)DataColumnIdx.StreamLevel;             // Stream Level Column
        int sn = (int)DataColumnIdx.Snow;                   // Root Carbon Column
        int t = (int)DataColumnIdx.TransOver;               // Net Transpiration Column
        int lt = (int)DataColumnIdx.Litter;                 // Litter Column
        int psn = (int)DataColumnIdx.NetPsn;                 // Litter Column
        int l = (int)DataColumnIdx.LeafCarbonOver;          // Leaf Carbon Column
        int stC = (int)DataColumnIdx.StemCarbonOver;        // Stem Carbon Column
        int r = (int)DataColumnIdx.RootCarbonOver;          // Root Carbon Column

        if (dataType == CubeDataType.Agg)
        {
            s = (int)AggregateDataColumnIdx.StreamLevel;             // Stream Level Column
            sn = (int)AggregateDataColumnIdx.Snow;                   // Root Carbon Column
            lt = (int)AggregateDataColumnIdx.Litter;                 // Litter Column
            psn = (int)AggregateDataColumnIdx.NetPsn;                 // Litter Column
        }

        if (resetValues)
        {
            StreamHeightMin = 100000f;
            StreamHeightMax = -100000f;
            SnowAmountMin = 100000f;
            SnowAmountMax = -100000f;
            LitterMin = 100000f;
            LitterMax = -100000f;
            NetPhotosynthesisMin = 100000f;
            NetPhotosynthesisMax = -100000f;

            LeafCarbonOverMin = 100000f;
            LeafCarbonOverMax = -100000f;
            LeafCarbonUnderMin = 100000f;
            LeafCarbonUnderMax = -100000f;

            StemCarbonOverMin = 100000f;
            StemCarbonOverMax = -100000f;
            StemCarbonUnderMin = 100000f;
            StemCarbonUnderMax = -100000f;
            RootsCarbonOverMin = 100000f;
            RootsCarbonOverMax = -100000f;
            RootsCarbonUnderMin = 100000f;
            RootsCarbonUnderMax = -100000f;

            TransOverMin = 100000f;
            TransOverMax = -100000f;
            TransUnderMin = 100000f;
            TransUnderMax = -100000f;
        }

        while (i < rows - 1)
        {
            float val = cubeData[i, s];
            if (val < StreamHeightMin)
                StreamHeightMin = val;
            if (val > StreamHeightMax)
                StreamHeightMax = val;

            val = cubeData[i, sn];
            if (val < SnowAmountMin)
                SnowAmountMin = val;
            if (val > SnowAmountMax)
                SnowAmountMax = val;

            val = cubeData[i, lt];
            if (val < LitterMin)
                LitterMin = val;
            if (val > LitterMax)
                LitterMax = val;

            val = cubeData[i, psn];
            if (val < NetPhotosynthesisMin)
                NetPhotosynthesisMin = val;
            if (val > NetPhotosynthesisMax)
                NetPhotosynthesisMax = val;

            int t_o = (int)DataColumnIdx.TransOver;               // Net Transpiration (Overstory) Column
            int t_u = (int)DataColumnIdx.TransUnder;               // Net Transpiration (Overstory) Column

            int l_o = (int)DataColumnIdx.LeafCarbonOver;          // Leaf Carbon (Overstory) Column
            int stC_o = (int)DataColumnIdx.StemCarbonOver;        // Stem Carbon (Overstory) Column
            int r_o = (int)DataColumnIdx.RootCarbonOver;          // Root Carbon (Overstory) Column
            int l_u = (int)DataColumnIdx.LeafCarbonUnder;          // Leaf Carbon (Overstory) Column
            int stC_u = (int)DataColumnIdx.StemCarbonUnder;        // Stem Carbon (Overstory) Column
            int r_u = (int)DataColumnIdx.RootCarbonUnder;          // Root Carbon (Overstory) Column

            switch (dataType)
            {
                case CubeDataType.Veg1:
                    //TransOverMin = 100000f;
                    //TransOverMax = -100000f;

                    //LeafCarbonOverMin = 100000f;
                    //LeafCarbonOverMax = -100000f;
                    //StemCarbonOverMin = 100000f;
                    //StemCarbonOverMax = -100000f;
                    //RootsCarbonOverMin = 100000f;
                    //RootsCarbonOverMax = -100000f;

                    val = cubeData[i, t];
                    if (val < TransOverMin)
                        TransOverMin = val;
                    if (val > TransOverMax)
                        TransOverMax = val;

                    val = cubeData[i, l];
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = cubeData[i, stC];
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = cubeData[i, r];
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;
                    break;

                case CubeDataType.Veg2:
                    //LeafCarbonOverMin = 100000f;
                    //LeafCarbonOverMax = -100000f;
                    //LeafCarbonUnderMin = 100000f;
                    //LeafCarbonUnderMax = -100000f;

                    //StemCarbonOverMin = 100000f;
                    //StemCarbonOverMax = -100000f;
                    //StemCarbonUnderMin = 100000f;
                    //StemCarbonUnderMax = -100000f;
                    //RootsCarbonOverMin = 100000f;
                    //RootsCarbonOverMax = -100000f;
                    //RootsCarbonUnderMin = 100000f;
                    //RootsCarbonUnderMax = -100000f;

                    //TransOverMin = -100000f;
                    //TransUnderMin = 100000f;
                    //TransOverMax = -100000f;
                    //TransUnderMax = 100000f;

                    //t_o = (int)DataColumnIdx.TransOver;               // Net Transpiration (Overstory) Column
                    //t_u = (int)DataColumnIdx.TransUnder;               // Net Transpiration (Overstory) Column

                    //l_o = (int)DataColumnIdx.LeafCarbonOver;          // Leaf Carbon (Overstory) Column
                    //stC_o = (int)DataColumnIdx.StemCarbonOver;        // Stem Carbon (Overstory) Column
                    //r_o = (int)DataColumnIdx.RootCarbonOver;          // Root Carbon (Overstory) Column
                    //l_u = (int)DataColumnIdx.LeafCarbonUnder;          // Leaf Carbon (Overstory) Column
                    //stC_u = (int)DataColumnIdx.StemCarbonUnder;        // Stem Carbon (Overstory) Column
                    //r_u = (int)DataColumnIdx.RootCarbonUnder;          // Root Carbon (Overstory) Column

                    val = cubeData[i, t_o];
                    if (val < TransOverMin)
                        TransOverMin = val;
                    if (val > TransOverMax)
                        TransOverMax = val;

                    val = cubeData[i, t_u];
                    if (val < TransUnderMin)
                        TransUnderMin = val;
                    if (val > TransUnderMax)
                        TransUnderMax = val;

                    val = cubeData[i, l_o];
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = cubeData[i, stC_o];
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = cubeData[i, r_o];
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;

                    val = cubeData[i, l_u];
                    if (val < LeafCarbonUnderMin)
                        LeafCarbonUnderMin = val;
                    if (val > LeafCarbonUnderMax)
                        LeafCarbonUnderMax = val;

                    val = cubeData[i, stC_u];
                    if (val < StemCarbonUnderMin)
                        StemCarbonUnderMin = val;
                    if (val > StemCarbonUnderMax)
                        StemCarbonUnderMax = val;

                    val = cubeData[i, r_u];
                    if (val < RootsCarbonUnderMin)
                        RootsCarbonUnderMin = val;
                    if (val > RootsCarbonUnderMax)
                        RootsCarbonUnderMax = val;
                    break;

                case CubeDataType.Agg:
                    t = (int)AggregateDataColumnIdx.Trans;               // Net Transpiration (Overstory) Column

                    l_o = (int)AggregateDataColumnIdx.LeafCarbonOver;          // Leaf Carbon (Overstory) Column
                    stC_o = (int)AggregateDataColumnIdx.StemCarbonOver;        // Stem Carbon (Overstory) Column
                    r_o = (int)AggregateDataColumnIdx.RootCarbonOver;          // Root Carbon (Overstory) Column
                    l_u = (int)AggregateDataColumnIdx.LeafCarbonUnder;          // Leaf Carbon (Overstory) Column
                    stC_u = (int)AggregateDataColumnIdx.StemCarbonUnder;        // Stem Carbon (Overstory) Column
                    r_u = (int)AggregateDataColumnIdx.RootCarbonUnder;          // Root Carbon (Overstory) Column

                    val = cubeData[i, t];
                    if (val < NetTranspirationMin)
                        NetTranspirationMin = val;
                    if (val > NetTranspirationMax)
                        NetTranspirationMax = val;

                    val = cubeData[i, l_o];
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = cubeData[i, stC_o];
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = cubeData[i, r_o];
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;

                    val = cubeData[i, l_u];
                    if (val < LeafCarbonUnderMin)
                        LeafCarbonUnderMin = val;
                    if (val > LeafCarbonUnderMax)
                        LeafCarbonUnderMax = val;

                    val = cubeData[i, stC_u];
                    if (val < StemCarbonUnderMin)
                        StemCarbonUnderMin = val;
                    if (val > StemCarbonUnderMax)
                        StemCarbonUnderMax = val;

                    val = cubeData[i, r_u];
                    if (val < RootsCarbonUnderMin)
                        RootsCarbonUnderMin = val;
                    if (val > RootsCarbonUnderMax)
                        RootsCarbonUnderMax = val;
                    break;
            }

            i++;
        }
    }

    /// <summary>
    /// Updates water access min / max values.
    /// </summary>
    private void CalculateSoilRangesForWeb(bool resetValues)
    {
        if (this.dataRows == null)
        {
            Debug.Log(name + ".CalculateSoilRangesForWeb()... ERROR no cubeData!");
        }
        int rows = dataRows.Length;
        int row = 0;                                      // Row

        //int w = (int)DataColumnIdx.WaterAccess;     // Water Access Column
        //int d = (int)DataColumnIdx.DepthToGW;       // Depth to G.W. Column

        //if (dataType == CubeDataType.Agg)
        //{
        //    w = (int)AggregateDataColumnIdx.WaterAccess;     // Water Access Column
        //    d = (int)AggregateDataColumnIdx.DepthToGW;       // Depth to G.W. Column
        //}

        if (resetValues)
        {
            WaterAccessMin = 100000f;         // Set Min. waterAccess 
            WaterAccessMax = -100000f;         // Set Max. waterAccess 
            DepthToGWMin = 100000f;           // Set Min. depthToGW
            DepthToGWMax = -100000f;           // Set Max. depthToGW 
        }

        while (row < rows - 1)
        {
            float val = dataRows[row].vegAccessWater;
            if (val < WaterAccessMin)
                WaterAccessMin = val;
            if (val > WaterAccessMax)
                WaterAccessMax = val;

            float val2 = dataRows[row].depthToGW;
            if (val2 < DepthToGWMin)
                DepthToGWMin = val2;
            if (val2 > DepthToGWMax)
                DepthToGWMax = val2;

            row++;
        }

        //Debug.Log(" WaterAccessMin:" + WaterAccessMin + " WaterAccessMax:" + WaterAccessMax);
        //Debug.Log(" DepthToGWMin:" + DepthToGWMin + " DepthToGWMax:" + DepthToGWMax);

        soilController.SetMinMaxRanges(WaterAccessMin, WaterAccessMax, DepthToGWMin, DepthToGWMax);
    }

    /// <summary>
    /// Updates the parameter ranges (min/max values).
    /// </summary>
    /// <param name="cubeData">Cube data.</param>
    private void CalculateParameterRangesForWeb(bool resetValues)
    {
        if (debugDetailed && debugTrees)
            Debug.Log("CalculateParameterRangesForWeb()... Time:" + Time.time);

        if (this.dataRows == null)
        {
            Debug.Log(name + ".CalculateParameterRangesForWeb()... ERROR no dataRows!");
        }

        int rows = dataRows.Length;
        int i = 0;                                              // Data Row

        //int s = (int)DataColumnIdx.StreamLevel;             // Stream Level Column    // Qout
        //int sn = (int)DataColumnIdx.Snow;                   // Root Carbon Column     // snow
        //int t = (int)DataColumnIdx.TransOver;               // Net Transpiration Column
        //int lt = (int)DataColumnIdx.Litter;                 // Litter Column          // litter
        //int psn = (int)DataColumnIdx.NetPsn;                 // Litter Column         // netpsn
        //int l = (int)DataColumnIdx.LeafCarbonOver;          // Leaf Carbon Column
        //int stC = (int)DataColumnIdx.StemCarbonOver;        // Stem Carbon Column
        //int r = (int)DataColumnIdx.RootCarbonOver;          // Root Carbon Column

        //if (dataType == CubeDataType.Agg)
        //{
        //    s = (int)AggregateDataColumnIdx.StreamLevel;             // Stream Level Column
        //    sn = (int)AggregateDataColumnIdx.Snow;                   // Root Carbon Column
        //    lt = (int)AggregateDataColumnIdx.Litter;                 // Litter Column
        //    psn = (int)AggregateDataColumnIdx.NetPsn;                 // Litter Column
        //}

        if (resetValues)
        {
            StreamHeightMin = 100000f;
            StreamHeightMax = -100000f;
            SnowAmountMin = 100000f;
            SnowAmountMax = -100000f;
            LitterMin = 100000f;
            LitterMax = -100000f;
            NetPhotosynthesisMin = 100000f;
            NetPhotosynthesisMax = -100000f;

            LeafCarbonOverMin = 100000f;
            LeafCarbonOverMax = -100000f;
            LeafCarbonUnderMin = 100000f;
            LeafCarbonUnderMax = -100000f;

            StemCarbonOverMin = 100000f;
            StemCarbonOverMax = -100000f;
            StemCarbonUnderMin = 100000f;
            StemCarbonUnderMax = -100000f;
            RootsCarbonOverMin = 100000f;
            RootsCarbonOverMax = -100000f;
            RootsCarbonUnderMin = 100000f;
            RootsCarbonUnderMax = -100000f;

            TransOverMin = 100000f;
            TransOverMax = -100000f;
            TransUnderMin = 100000f;
            TransUnderMax = -100000f;
        }

        while (i < rows - 1)
        {
            float val = dataRows[i].Qout;
            if (val < StreamHeightMin)
                StreamHeightMin = val;
            if (val > StreamHeightMax)
                StreamHeightMax = val;

            val = dataRows[i].snow;
            if (val < SnowAmountMin)
                SnowAmountMin = val;
            if (val > SnowAmountMax)
                SnowAmountMax = val;

            val = dataRows[i].litter;
            if (val < LitterMin)
                LitterMin = val;
            if (val > LitterMax)
                LitterMax = val;

            val = dataRows[i].netpsn;
            if (val < NetPhotosynthesisMin)
                NetPhotosynthesisMin = val;
            if (val > NetPhotosynthesisMax)
                NetPhotosynthesisMax = val;

            int t_o = (int)DataColumnIdx.TransOver;               // Net Transpiration (Overstory) Column
            int t_u = (int)DataColumnIdx.TransUnder;               // Net Transpiration (Overstory) Column

            int l_o = (int)DataColumnIdx.LeafCarbonOver;          // Leaf Carbon (Overstory) Column
            int stC_o = (int)DataColumnIdx.StemCarbonOver;        // Stem Carbon (Overstory) Column
            int r_o = (int)DataColumnIdx.RootCarbonOver;          // Root Carbon (Overstory) Column
            int l_u = (int)DataColumnIdx.LeafCarbonUnder;          // Leaf Carbon (Overstory) Column
            int stC_u = (int)DataColumnIdx.StemCarbonUnder;        // Stem Carbon (Overstory) Column
            int r_u = (int)DataColumnIdx.RootCarbonUnder;          // Root Carbon (Overstory) Column

            switch (dataType)
            {
                case CubeDataType.Veg1:
                    //TransOverMin = 100000f;
                    //TransOverMax = -100000f;

                    //LeafCarbonOverMin = 100000f;
                    //LeafCarbonOverMax = -100000f;
                    //StemCarbonOverMin = 100000f;
                    //StemCarbonOverMax = -100000f;
                    //RootsCarbonOverMin = 100000f;
                    //RootsCarbonOverMax = -100000f;

                    val = dataRows[i].transOver;
                    if (val < TransOverMin)
                        TransOverMin = val;
                    if (val > TransOverMax)
                        TransOverMax = val;

                    val = dataRows[i].leafCOver;
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = dataRows[i].stemCOver;
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = dataRows[i].rootCOver;
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;
                    break;

                case CubeDataType.Veg2:
                    val = dataRows[i].transOver;
                    if (val < TransOverMin)
                        TransOverMin = val;
                    if (val > TransOverMax)
                        TransOverMax = val;

                    val = dataRows[i].transUnder;
                    if (val < TransUnderMin)
                        TransUnderMin = val;
                    if (val > TransUnderMax)
                        TransUnderMax = val;

                    val = dataRows[i].leafCOver;
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = dataRows[i].stemCOver;
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = dataRows[i].rootCOver;
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;

                    val = dataRows[i].leafCUnder;
                    if (val < LeafCarbonUnderMin)
                        LeafCarbonUnderMin = val;
                    if (val > LeafCarbonUnderMax)
                        LeafCarbonUnderMax = val;

                    val = dataRows[i].stemCUnder;
                    if (val < StemCarbonUnderMin)
                        StemCarbonUnderMin = val;
                    if (val > StemCarbonUnderMax)
                        StemCarbonUnderMax = val;

                    val = dataRows[i].rootCUnder;
                    if (val < RootsCarbonUnderMin)
                        RootsCarbonUnderMin = val;
                    if (val > RootsCarbonUnderMax)
                        RootsCarbonUnderMax = val;
                    break;

                case CubeDataType.Agg:
                    //t = (int)AggregateDataColumnIdx.Trans;               // Net Transpiration (Overstory) Column

                    //l_o = (int)AggregateDataColumnIdx.LeafCarbonOver;          // Leaf Carbon (Overstory) Column
                    //stC_o = (int)AggregateDataColumnIdx.StemCarbonOver;        // Stem Carbon (Overstory) Column
                    //r_o = (int)AggregateDataColumnIdx.RootCarbonOver;          // Root Carbon (Overstory) Column
                    //l_u = (int)AggregateDataColumnIdx.LeafCarbonUnder;          // Leaf Carbon (Overstory) Column
                    //stC_u = (int)AggregateDataColumnIdx.StemCarbonUnder;        // Stem Carbon (Overstory) Column
                    //r_u = (int)AggregateDataColumnIdx.RootCarbonUnder;          // Root Carbon (Overstory) Column

                    val = dataRows[i].transOver;
                    if (val < NetTranspirationMin)
                        NetTranspirationMin = val;
                    if (val > NetTranspirationMax)
                        NetTranspirationMax = val;

                    val = dataRows[i].leafCOver;
                    if (val < LeafCarbonOverMin)
                        LeafCarbonOverMin = val;
                    if (val > LeafCarbonOverMax)
                        LeafCarbonOverMax = val;

                    val = dataRows[i].stemCOver;
                    if (val < StemCarbonOverMin)
                        StemCarbonOverMin = val;
                    if (val > StemCarbonOverMax)
                        StemCarbonOverMax = val;

                    val = dataRows[i].rootCOver;
                    if (val < RootsCarbonOverMin)
                        RootsCarbonOverMin = val;
                    if (val > RootsCarbonOverMax)
                        RootsCarbonOverMax = val;

                    val = dataRows[i].leafCUnder;
                    if (val < LeafCarbonUnderMin)
                        LeafCarbonUnderMin = val;
                    if (val > LeafCarbonUnderMax)
                        LeafCarbonUnderMax = val;

                    val = dataRows[i].stemCUnder;
                    if (val < StemCarbonUnderMin)
                        StemCarbonUnderMin = val;
                    if (val > StemCarbonUnderMax)
                        StemCarbonUnderMax = val;

                    val = dataRows[i].rootCUnder;
                    if (val < RootsCarbonUnderMin)
                        RootsCarbonUnderMin = val;
                    if (val > RootsCarbonUnderMax)
                        RootsCarbonUnderMax = val;
                    break;
            }

            i++;
        }
    }

    /// <summary>
    /// Sets ranges of visualization parameters for each tree controller.
    /// </summary>
    private void SetTreeParameterRanges()
    {
        if (debugDetailed && debugTrees)
            Debug.Log("SetParameterRanges()...");

        float netTransMin = TransOverMin;
        float netTransMax = TransOverMax;
        if (dataType == CubeDataType.Agg)
        {
            netTransMin = NetTranspirationMin;
            netTransMax = NetTranspirationMax;
        }
        float leafCarbonMin = LeafCarbonOverMin;
        float leafCarbonMax = LeafCarbonOverMax;
        float stemCarbonMin = StemCarbonOverMin;
        float stemCarbonMax = StemCarbonOverMax;
        float rootsCarbonMin = RootsCarbonOverMin;
        float rootsCarbonMax = RootsCarbonOverMax;

        for (int i = 0; i < firs.Count; i++)
        {
            firs[i].SetMinMaxRanges( netTransMin, netTransMax, leafCarbonMin, leafCarbonMax,
                                     stemCarbonMin, stemCarbonMax, rootsCarbonMin, rootsCarbonMax );
        }
    }

    /// <summary>
    /// Gets cube data in given column at given time index.
    /// </summary>
    /// <returns>The data for given time index.</returns>
    /// <param name="col">Column index.</param>
    /// <param name="timeIndex">Time index.</param>
    public float ReadData(int col, int timeIndex)
    {
        timeIndex++;            // Added 12-9-24

        //Debug.Log(name + ".ReadData()... timeIndex:" + timeIndex + "warmingIdx: " + warmingIdx);

        if (settings.BuildForWeb)
        {
            if (!cubeData.ContainsKey(timeIndex))
            {
                Debug.Log("ReadData()... ERROR: cubeData has no key timeIndex: "+timeIndex);
                return 0f;
            }

            switch (col) {
                case (int)DataColumnIdx.Snow:
                    return cubeData[timeIndex].snow;
                case (int)DataColumnIdx.DepthToGW:
                    return cubeData[timeIndex].depthToGW;
                case (int)AggregateDataColumnIdx.LeafCarbonOver:
                    return cubeData[timeIndex].leafCOver;
                case (int)AggregateDataColumnIdx.LeafCarbonUnder:
                    return cubeData[timeIndex].leafCUnder;
                case (int)AggregateDataColumnIdx.StemCarbonOver:
                    return cubeData[timeIndex].stemCOver;
                case (int)AggregateDataColumnIdx.StemCarbonUnder:
                    return cubeData[timeIndex].stemCUnder;

                //case (int)DataColumnIdx.Snow:
                //    return cubeData[timeIndex].Snow;
                //case (int)DataColumnIdx.Snow:
                //    return cubeData[timeIndex].Snow;
                //case (int)DataColumnIdx.Snow:
                //    return cubeData[timeIndex].Snow;
                //case (int)DataColumnIdx.Snow:
                //    return cubeData[timeIndex].Snow;
                //case (int)DataColumnIdx.Snow:
                //    return cubeData[timeIndex].Snow;
                default:
                    break;
            }
        }
        else
        {
            if (dataArray != null)
                return GetCurrentData()[timeIndex, col];
            else
            {
                if (debugCubes || debugDetailed || debugAggregate)
                    Debug.LogError("dataArray is null!");
            }
        }

        return 0f;
    }


    /// <summary>
    /// Processes RHESSys cube data file (TXT).
    /// Creates data array from text file in format [lineIdx, Snow, Evap...]
    /// </summary>
    /// <param name="newDataFile">New data file.</param>
    public void ProcessDataTextAsset(TextAsset newDataFile, int wIdx)
    {
        //dataType = newDataType;
        List<string> rawData = TextAssetToList(newDataFile);

        int columns = System.Enum.GetNames(typeof(DataColumnIdx)).Length;

        if (isAggregate)
            columns = System.Enum.GetNames(typeof(AggregateDataColumnIdx)).Length;

        //Debug.Log(name + ".ProcessDataTextAsset()... dataType:" + dataType + " columns:" + columns + " name:" + newDataFile.name + " isAggregate:" + isAggregate);

        float[,] dataArr = new float[dataLength, columns];

        string[] tempData = new string[columns];

        //Debug.Log(name+">>> dataLength:" + dataLength + " columns:" + columns+ " tempData.length:"+ tempData.Length+ " isAggregate:"+ isAggregate);

        if (name.Contains("CubeF") && !settings.BuildForWeb)      // Temp. hack
        {
            GameController.Instance.dataDates = new List<DateModel>();
        }

        for (int row = 1; row < dataLength; row++)                      // Store data in 'data' 2D array
        {
            tempData = rawData[row].Split(' ');

            if(name.Contains("CubeF") && !settings.BuildForWeb)      // Temp. hack
            {
                DateModel newDate = new DateModel();
                newDate.year = int.Parse(tempData[0].Split('-')[0]);
                newDate.month = int.Parse(tempData[0].Split('-')[0]);
                newDate.day = int.Parse(tempData[0].Split('-')[0]);
                GameController.Instance.dataDates.Add(newDate);
            }
            //dataDates[row - 1] = tempData[0];                           // Store date string
            dataArr[row - 1, 0] = row - 1;                              // Store line index as first element in row

            for (int col = 1; col < columns; col++)
            {                                                           // Store data fields
                dataArr[row - 1, col] = float.Parse(tempData[col]);     // Store data in array starting with second column (idx 1)
            }
        }

        dataFiles[wIdx] = newDataFile;
        dataArray[wIdx] = dataArr;
    }

    public float GetLeafCarbon()
    {
        if (dataType == CubeDataType.Veg1)
            return LeafCarbonOver;
        else
            return LeafCarbonOver + LeafCarbonUnder;
    }

    public float GetStemCarbon()
    {
        if (dataType == CubeDataType.Veg1)
            return StemCarbonOver;
        else
            return StemCarbonOver + StemCarbonUnder;
    }

    public float GetRootsCarbon()
    {
        if (dataType == CubeDataType.Veg1)
            return RootsCarbonOver;
        else
            return RootsCarbonOver + RootsCarbonUnder;
    }

    public float GetNetTranspiration()
    {
        if (dataType == CubeDataType.Veg1)
            return TransOver;
        else if (dataType == CubeDataType.Veg2)
            return TransOver + TransUnder;
        else if (dataType == CubeDataType.Agg)
            return NetTranspiration;
        return NetTranspiration;
    }

    /// <summary>
    /// Gets the tree carbon factor.
    /// </summary>
    /// <returns>The tree carbon factor.</returns>
    public float GetTreeCarbonFactor()
    {
        if (isAggregate)
            return settings.CubeATreeCarbonFactor;
        else
            return settings.TreeCarbonFactor;
    }

    /// <summary>
    /// Gets the roots carbon factor.
    /// </summary>
    /// <returns>The tree carbon factor.</returns>
    public float GetShrubCarbonFactor()
    {
        if (isAggregate)
            return settings.CubeAShrubCarbonFactor;
        else
            return settings.ShrubCarbonFactor;
    }

    /// <summary>
    /// Gets the roots carbon factor.
    /// </summary>
    /// <returns>The tree carbon factor.</returns>
    public float GetRootsCarbonFactor()
    {
        if (isAggregate)
            return settings.CubeARootsCarbonFactor;
        else
            return settings.RootsCarbonFactor;
    }

    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetNetTranspirationVisualized()
    {
        float etAmount = 0f;

        for (int x = 0; x < firs.Count; x++)
        {
            etAmount += firs[x].GetTranspirationVisualized();
        }

        foreach (ShrubController shrub in shrubs)
        {
            ParticleSystem.EmissionModule em = shrub.pSystem.emission;
            etAmount += em.rateOverTime.constant;
        }

        return etAmount;
    }

    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetStemCarbonAmountVisualized()                        // -- Unused
    {
        //float etAmount = 0f;

        //for (int x = 0; x < firs.Count; x++)
        //{
        //    etAmount += firs[x].GetCarbonAmount();
        //}

        return 0f;
    }
    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetSnowAmountVisualized()                            // -- Unused
    {
        float snowAmount = 0f;

        //for (int x = 0; x < firs.Count; x++)
        //{
        //    etAmount += firs[x].GetCarbonAmount();
        //}

        return 0f;
    }
    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetNetPsnAmountVisualized()                           // -- Unused
    {
        float netPsnAmount = 0f;

        //for (int x = 0; x < firs.Count; x++)
        //{
        //    etAmount += firs[x].GetCarbonAmount();
        //}

        return 0f;
    }
    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetWaterAccessVisualized()                           // -- Unused
    {
        float etAmount = 0f;

        //for (int x = 0; x < firs.Count; x++)
        //{
        //    etAmount += firs[x].GetCarbonAmount();
        //}

        return 0f;
    }

    /// <summary>
    /// Gets the carbon amount represented by currently living trees.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    public float GetTreeCarbonAmountVisualized()
    {
        float treeCarbonAmount = 0f;

        for (int x = 0; x < firs.Count; x++)
        {
            treeCarbonAmount += firs[x].GetCarbonAmount();
        }

        return treeCarbonAmount;
    }

    /// <summary>
    /// Gets the carbon amount represented by currently living shrubs.
    /// </summary>
    /// <returns>The shrub carbon amount.</returns>
    public float GetShrubCarbonAmountVisualized()
    {
        float shrubCarbonAmount = 0f;

        int count = 0;
        foreach (ShrubController shrub in shrubs)
        {
            Renderer rend = shrub.rend;
            //Renderer rend = GetShrubRenderer(shrub);                                                          // Renderer for determining bounds
            //Debug.Log(transform.name + " rend.bounds.size.y:" + rend.bounds.size.y + " vs transform.localScale.y:" + shrub.transform.localScale.y);

            if (rend != null)
                shrubCarbonAmount += rend.bounds.size.y * GetShrubCarbonFactor();
            //shrubCarbonAmount += shrub.transform.localScale.y * shrubCarbonFactor;

            count++;
        }

        return shrubCarbonAmount;
    }

    /// <summary>
    /// Gets the roots carbon amount currently visualized.
    /// </summary>
    /// <returns>The roots amount.</returns>
    public float GetRootsCarbonVisualized()
    {
        float rootsAmount = 0f;

        //for (int x = 0; x < settings.MaxTrees; x++)    // Instantiate tree prefabs
        for (int x = 0; x < firs.Count; x++)    // Instantiate tree prefabs
        {
            rootsAmount += firs[x].GetRootsCarbon();
        }

        return rootsAmount;
    }

    /// <summary>
    /// Gets the litter amount currently visualized.
    /// </summary>
    /// <returns>The litter amount.</returns>
    public float GetLitterAmountVisualized()
    {
        // -- TO DO

        //foreach()

        return 0f;
    }

    /// <summary>
    /// Gets the data array.
    /// </summary>
    /// <returns>The data array.</returns>
    public float[][,] GetDataArray()
    {
        return dataArray;
    }

    /// <summary>
    /// Gets the length of the data.
    /// </summary>
    /// <returns>The data length.</returns>
    public int GetDataLength()                    // Get data length
    {
        if (settings.BuildForWeb)
        {
            if(cubeData != null)
                return cubeData.Count;
        }

        return dataLength;
    }

    public int GetWarmingIdx()
    {
        return warmingIdx;
    }

    /// <summary>
    /// Gets the data dates.
    /// </summary>
    /// <returns>The data dates.</returns>
    //public List<DateModel> GetDataDates()
    //{
    //    return dataDates;
    //}

    /// <summary>
    /// Gets the data dates.
    /// </summary>z
    /// <returns>The data dates.</returns>
    //public void SetDataDates(string[] newDataDates)
    //{
    //    dataDates = newDataDates;
    //}

    /// <summary>
    /// Shows model data display for cube.
    /// </summary>
    public void ShowStatistics()
    {
        //if (!settings.BuildForWeb)
            displayObject.SetActive(true);
    }

    /// <summary>
    /// Shows model data display for cube.
    /// </summary>
    public void HideStatistics()
    {
        //if (!settings.BuildForWeb)
            displayObject.SetActive(false);
    }
    #endregion

    #region Time
    /// <summary>
    /// Gets the first date year.
    /// </summary>
    /// <returns>The first date year.</returns>
    //public int GetFirstDateYear()
    //{
    //    return int.Parse(dataDates[0].Split('-')[0]);
    //}

    /// <summary>
    /// Gets the last date year.
    /// </summary>
    /// <returns>The last date year.</returns>
    //public int GetLastDateYear()
    //{
    //    return int.Parse(dataDates[dataDates.Length - 2].Split('-')[0]);
    //}

    /// <summary>
    /// Gets the last date year.
    /// </summary>
    /// <returns>The last date year.</returns>
    //public int GetLastDateMonth()
    //{
    //    return int.Parse(dataDates[dataDates.Length - 2].Split('-')[1]);
    //}

    ///// <summary>
    ///// Gets the last date year.
    ///// </summary>
    ///// <returns>The last date year.</returns>
    //public int GetLastDateDay()
    //{
    //    return int.Parse(dataDates[dataDates.Length - 2].Split('-')[1]);
    //}

    /// <summary>
    /// Gets the first date year.
    /// </summary>
    /// <returns>The first date year.</returns>
    //public int GetFirstDateMonth()
    //{
    //    return int.Parse(dataDates[0].Split('-')[1]);
    //}

    ///// <summary>
    ///// Gets the first date year.
    ///// </summary>
    ///// <returns>The first date year.</returns>
    //public int GetFirstDateDay()
    //{
    //    return int.Parse(dataDates[0].Split('-')[2]);
    //}

    #endregion

    #region GUI
    /// <summary>
    /// Shows the label.
    /// </summary>
    public void ShowLabel()
    {
        cubeLabel.SetActive(true);
    }

    /// <summary>
    /// Hides the label.
    /// </summary>
    public void HideLabel()
    {
        cubeLabel.SetActive(false);
    }

    /// <summary>
    /// Updates the data display.
    /// </summary>
    public void UpdateStatistics()
    {
        //if (settings.BuildForWeb)
        //    return;

        float netTrans = GetNetTranspiration();
        float leafCarbon = GetLeafCarbon();
        float stemCarbon = GetStemCarbon();
        //float rootsCarbon = (dataType == CubeDataType.Veg1) ? RootsCarbon : RootsCarbonOver;

        float netTransMin = (dataType == CubeDataType.Veg1) ? TransOverMin : TransOverMin + TransUnderMin;
        float netTransMax = (dataType == CubeDataType.Veg1) ? TransOverMax : TransOverMax + TransUnderMax;
        float leafCarbonMin = (dataType == CubeDataType.Veg1) ? LeafCarbonOverMin : LeafCarbonOverMin + LeafCarbonUnderMin;
        float leafCarbonMax = (dataType == CubeDataType.Veg1) ? LeafCarbonOverMax : LeafCarbonOverMax + LeafCarbonUnderMax;
        float stemCarbonMin = (dataType == CubeDataType.Veg1) ? StemCarbonOverMin : StemCarbonOverMin + StemCarbonUnderMin;
        float stemCarbonMax = (dataType == CubeDataType.Veg1) ? StemCarbonOverMax : StemCarbonOverMax + StemCarbonUnderMax;
        //float rootsCarbonMin = (dataType == CubeDataType.Veg1) ? RootsCarbonMin : RootsCarbonOverMin;
        //float rootsCarbonMax = (dataType == CubeDataType.Veg1) ? RootsCarbonMax : RootsCarbonOverMax;

        netTransSlider.value = MapValue(netTrans, netTransMin, netTransMax, netTransSlider.minValue, netTransSlider.maxValue);
        //plantCarbonSlider.value = MapValue(stemCarbon + leafCarbon, stemCarbonMin + leafCarbonMin, stemCarbonMax + leafCarbonMax, plantCarbonSlider.minValue, plantCarbonSlider.maxValue);
        snowAmountSlider.value = MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, snowAmountSlider.minValue, snowAmountSlider.maxValue);
        //psnSlider.value = MapValue(NetPhotosynthesis, NetPhotosynthesisMin, NetPhotosynthesisMax, psnSlider.minValue, psnSlider.maxValue);
        waterAccessSlider.value = MapValue(WaterAccess, soilController.WaterAccessMin, soilController.WaterAccessMax, waterAccessSlider.minValue, waterAccessSlider.maxValue);

        //Debug.Log(name + ".UpdateModelDisplay() dataType:"+ dataType+" netTrans:" + netTrans + " netTransMin:" + netTransMin + " netTransMax:" + netTransMax + " DataColumnIdx.TransOver:" + ReadData((int)DataColumnIdx.TransOver, timeIdx));
        //Debug.Log(name + ".UpdateModelDisplay() netTrans:" + netTrans + " plantCarbon:" + (stemCarbon + leafCarbon) + " plantCarbonMin:" + (leafCarbonMin+ stemCarbonMin)
        //    + " plantCarbonMax:" + (leafCarbonMax + stemCarbonMax) + " DataColumnIdx.LeafCarbonOver:" + ReadData((int)DataColumnIdx.LeafCarbonOver, timeIdx));

        float netTransInViz = GetNetTranspirationVisualized();
        float plantCarbonInViz = GetTreeCarbonAmountVisualized() + GetShrubCarbonAmountVisualized();
        //float snowAmountInViz = GetSnowAmountVisualized();
        //float netPhotosynthesisInViz = GetNetPsnAmountVisualized();
        //float waterAccessInViz = GetWaterAccessVisualized();

        netTransSliderDebug.value = MapValue(netTransInViz, netTransMin, netTransMax, netTransSlider.minValue, netTransSlider.maxValue);
        //plantCarbonSliderDebug.value = MapValue(plantCarbonInViz, stemCarbonMin + leafCarbonMin, stemCarbonMax + leafCarbonMax, plantCarbonSlider.minValue, plantCarbonSlider.maxValue);

        //snowAmountSliderDebug.value = MapValue(snowAmountInViz, SnowAmountMin, SnowAmountMax, snowAmountSlider.minValue, snowAmountSlider.maxValue);
        //psnSliderDebug.value = MapValue(netPhotosynthesisInViz, NetPhotosynthesisMin, NetPhotosynthesisMax, psnSlider.minValue, psnSlider.maxValue);
        //waterAccessSliderDebug.value = MapValue(waterAccessInViz, soilController.WaterAccessMin, soilController.WaterAccessMax, waterAccessSlider.minValue, waterAccessSlider.maxValue);
        //dtgSlider.value = MapValue(DepthToGW, soilController.DepthToGWMin, soilController.DepthToGWMax, psnSlider.minValue, psnSlider.maxValue);
    }
    #endregion

    #region Classes
    public class HandleTextFile
    {
        public HandleTextFile() { }

        static public void WriteString(string str)
        {
            //string path = "Assets/Resources/test.txt";
            string path = debugOutputPath;

            //Write some text to the test.txt file
            StreamWriter writer = new StreamWriter(path, true);
            writer.WriteLine(str);
            writer.Close();

            //Re-import the file to update the reference in the editor
            //AssetDatabase.ImportAsset(path);
            //TextAsset asset = (TextAsset)Resources.Load("test");

            //Print the text from the file
            //Debug.Log(asset.text);
        }

        static public void ClearFile()
        {
            //string path = "Assets/Resources/test.txt";
            string path = debugOutputPath;

            File.WriteAllText(path, System.String.Empty);
            //StreamWriter writer = new StreamWriter(path, true);
            //writer.
            //writer.Close();

            //Re-import the file to update the reference in the editor
            //AssetDatabase.ImportAsset(path);
            //TextAsset asset = (TextAsset)Resources.Load("test");
        }

        //static string ReadString()
        //{
        //    string path = "Assets/Resources/test.txt";

        //    //Read the text from directly from the test.txt file
        //    StreamReader reader = new StreamReader(path);
        //    Debug.Log(reader.ReadToEnd());
        //    reader.Close();
        //}
    }


    /// <summary>
    /// Class representing vegetation species type, containing prefabs at different growth stages.
    /// </summary>
    [System.Serializable]
    public class Species
    {

        public string name = "Tree";
        public bool isShrub = false;
        public List<GameObject> list;               // Prefabs at different growth stages (i.e. idx 0: small to idx n: large)
    }

    /// <summary>
    /// Vegetation species list for this cube.
    /// </summary>
    [System.Serializable]
    public class VegetationList
    {
        public List<Species> species;
    }
    #endregion

    #region Debugging
    public void SetModelDebugMode(bool mode)
    {
        if (mode)
        {
            netTransSliderDebug.gameObject.SetActive(true);
            plantCarbonSliderDebug.gameObject.SetActive(true);
        }
    }


    /// <summary>
    /// Prints debug message on screen.
    /// </summary>
    /// <param name="str">String.</param>
    public void DebugMessage(string str, int month, int day, int year)
    {
        //Debug.Log("PRINTING DEBUG MESSAGE: " + str+" messageManager null? :"+(messageManager == null));

        str += " " + Time.time;

        //try
        //{
        //    month = GetCurrentMonth();
        //    day = GetCurrentDayInMonth();
        //    year = GetCurrentYear();
        //}
        //catch (NullReferenceException e)
        //{
        //    //
        //}

        UI_Message message = new UI_Message(str, new Vector3(month, day, year), timeIdx,
                                             new List<int>(), settings.MessageFramesLength, 15,
                                             new List<int>(), UI_Message.UI_MessageType.debug);

        if (messageManager != null)
            messageManager.DisplayDebugMessage(message, timeIdx);

        HandleTextFile.WriteString(message.GetMessage());
    }

    #endregion

}
