using System;
using Assets.Scripts.Models;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Numerics;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;
using Random = UnityEngine.Random;
using Unity.VisualScripting.Antlr3.Runtime.Tree;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;

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
    public GameObject drivewayPrefab;          // Driveway to spawn

    private GameObject houseObj;

    /* Vegetation Prefabs */
    [Header("Vegetation Prefabs")]
    public VegetationList vegetation;            // All vegetation game objects in cube
    private List<List<GameObject>> treeList;     // List of tree game object lists
    private List<List<GameObject>> shrubList;    // List of shrub game object lists
    private List<GameObject> shrubPrefabs;       // Shrub prefabs           // -- TEMPORARY      

    public GameObject deadTreePrefab;            // Dead tree prefab (shared fallback for species with no deadPrefab)
    private List<GameObject> deadTreePrefabsBySpecies;   // Per-species dead prefabs, index-aligned with treeList
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
    public int fireRegrowthLength = 160;    // Frames to regrow grass   -- TEMP.
    private int riverFireGapWidth = 6;
    private int houseDefensibleWidth = 10;

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
    private SimulationSettings settings;            // Simulation settings
    private int shrubCount;                         // Current number of grown shrubs in cube
    private float minShrubFullSize = 0.8f;          // Min. shrub grown size (m.)
    private float maxShrubFullSize = 2f;            // Max. shrub grown size (m.)
    private float minGrassFullSize = 3f;            // Max. shrub grown size (m.)
    private float maxGrassFullSize = 5.5f;          // Max. shrub grown size (m.)
    private float shrubGrowthIncrement = 0.015f;    // Shrub growth increment per frame
    private float grassGrowthIncrement = 0.01f;     // Shrub growth increment per frame

    private float maxETSpeed = 11f;

    /* Timing */
    protected int timeIdx = 0;                        // Current index of simulation in data time series
    private int firGrowthWaitTime = 30;             // Frames to wait between tree instantiations (avoid spawning too many all at once)
    private int shrubGrowthWaitTime = 10;           // Frames to wait between shrub instantiations (avoid spawning too many all at once)
    private float grassGrowthPercentChance = 10f;   // Likelihood (out of 100) of spawning grass patch
    private int lastFirGrownTimeIdx = 0;            // Time at which tree most recently started growing
    private int lastShrubGrownTimeIdx = 0;          // Time at which tree most recently started growing
    private int lastDataUpdate = 0;                 // Time at which carbon data was most recently compared to carbon visualized in simulation
    private int lastKilledTreeFrame = 0;            // Time at which tree most recently started dying       -- OBSOLETE
    //private int vegetationDataWaitFrames = 2;     // Frames to wait between checks whether visualized carbon amount is more than carbon in data
    private int timeStep;                           // Simulation time step (days per frame)

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
    private Dictionary<int, CubeData> cubeDataP2;
    private bool p1Loaded = false;   // member 01 (patch1) data loaded
    protected bool p2Loaded = false;   // member 02 (patch2) data loaded
    public bool useCentralCoastPatches = false;   // Enable per-patch (patch1/patch2) growth. CC display cubes only.
    // Central Coast tuning: multiplies grass count on a grass-dominated patch. Inspector-tunable.
    public float grassPatchDensityScale = 1f;
    public int maxGrassesPerPatch = 300;
    public int maxGrassGrowthPerStep = 5;   // Cap grass spawned per update so a carbon spike can't freeze the editor
    // Central Coast: fixed background grass fill. Replaces the random 2..250 roll so that patch-driven grass (GrowPatchOverstory) is actually visible against it.
    public int ccBackgroundGrassPatches = 60;
    // Central Coast: per-cube carbon calibration. Each display cube stands for a different patch
        // area and density, so one shared factor cannot fit a dense riparian cube and a sparse
        // chaparral cube at once. 0 = fall back to the shared settings value.
        public float cubeTreeCarbonFactorOverride = 0f;
      // Central Coast: overstory carbon must fall this fraction below the visualised amount before
      // drought kills trees. Without it every small carbon wobble queued a kill and trees died
      // constantly. Fire deaths are handled separately by IgniteFire / SetTreesToBurn.
      public float droughtDeathThreshold = 0.25f;

    private CubeData[] dataRows;             // Data rows for calculating paramater ranges
    private int dataBuffer = 500;                 // Frames of cube data to preload

    private int dataLength;                     // Data file line count

    public int warmingIdx;                     // Current warming index
    public int warmingDegrees;                 // Current warming degrees
    public int warmingRange;                   // Warming range (idx values for data -- unused in Web)

    /* Display + UI */
    private GameObject displayObject;           // UI Display game object
    private GameObject displayPanel;            // UI Display panel object

    //- Update data display bars((ET), (PSN), (SA), (PC) and (WA).)

    private Slider netTransSlider;
    //private Slider psnSlider;
    //private Slider snowAmountSlider;
    private Slider plantCarbonSlider;
    //private Slider waterAccessSlider;

    private Slider netTransSliderDebug;
    //private Slider psnSliderDebug;
    //private Slider snowAmountSliderDebug;
    private Slider plantCarbonSliderDebug;
    //private Slider waterAccessSliderDebug;
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
    [SerializeField]
    private float snowMeltRate = 0.075f;            // Snow melt rate
    private float snowScalingFactor = 1.8f;         // Snow scaling factor

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
    public bool hasStream = false;               // Whether cube has a stream
    public bool hasHouse = false;                // Whether cube has a stream
    public GameObject streamObject;              // Stream object
    public GameObject streamFaceObject;          // Stream face object
    public float StreamHeight { get; set; }      // Stream height (QOut)
    public float streamFullHeight = 8.3f;        // Height (transform.position.y) of stream spline at full water level
    public float streamZeroHeight = 6.5f;        // Height (transform.position.y) of stream spline at zero water level
    public float streamFaceFullScale = 2.6f;     // Scale (transform.scale.y) of stream face at full water level
    public float streamFaceZeroScale = 0f;       // Scale of stream face for zero water level
    // Streamflow is heavily skewed: most days sit near the minimum and a few storms reach the peak, so a
    // linear map leaves the water pinned at the bed. Values below 1 lift ordinary flows into a visible
    // range without changing their order; 1 = linear (BigCreek behaviour).
    public float streamLevelCurve = 1f;
    protected float StreamHeightMin = 100000f;     // Min. stream level in current data file
    protected float StreamHeightMax = -100000f;    // Max. stream level in current data file

    private float WaterAccessMin = 100000f;
    private float WaterAccessMax = -100000f;
    private float DepthToGWMin = 100000f;
    private float DepthToGWMax = -100000f;

    public float streamCenter = 25f;             // Stream center position in cube (0f-50f)
    public float streamWidth = 10f;              // Stream width (m.)
    public float houseCenter = 25f;             // House center position in cube (0f-50f)
    public float houseWidth = 25f;              // House width (m.)
    public float drivewayWidth = 5f;              // Driveway width (m.)

    /* Vegetation */
    protected List<FirController> firs;                // Array of all fir controllers
    private ManzanitaController[] manzanitas;    // Array of all fir controllers
    private List<ShrubController> shrubs;         // List of active (simple) shrub objects
    private List<GameObject> grasses;         // List of active (simple) shrub objects

    private List<GameObject> litter;             // List of active (simple) shrub objects
    protected Vector3[] firLocations;              // Tree locations
    private List<int> activeFirLocations;        // Used fir location IDs
    public int firsToKill = 0;                   // Trees to kill
    private int[] firsToKillBySpecies;           // Central Coast: per-species kill queue, indexed by speciesIdx
     private int[] lastFirGrownTimeIdxBySpecies;  // Central Coast: per-species growth throttle so patch1 can't starve patch2
    public int shrubsToKill = 0;                 // Shrubs to kill
    public int grassesToKill = 0;            // Grass patches to kill
    public float LeafCarbonOver;                 // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    public float LeafCarbonUnder;                // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    public float StemCarbonOver;                 // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    public float StemCarbonUnder;                // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    public float IndDiedOver;                   //Overstory individual died flag
    private int lastDeathTimeIdx = -1;           // Central Coast: last timeIdx whose ind_died deaths were queued (avoids re-queuing on a paused frame)

    //public float LeafCarbon { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float StemCarbon { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    //public float LeafCarbonOver { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float LeafCarbonUnder { get; set; }           // Leaf carbon amount (Used for tree/bush leaf amount and grass height)
    //public float StemCarbonOver { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?
    //public float StemCarbonUnder { get; set; }           // Stem carbon amount (Used for tree height)    -- Also tree trunk thickness?

    private float LeafCarbonOverMin = 100000f;      // Leaf carbon (overstory) minimum value in data
    private float LeafCarbonOverMax = -100000f;     // Leaf carbon (overstory) maximum value in data
    private float p2CarbonMax = 0f;                 // patch2 (second member) max overstory carbon (leafC+stemC), for carbon-scaled recovery
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
    private int cubeInitialGrassPatches = 250;      // Initial grass patches in cube
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

    //date snow evap netpsn depthtogw vegaccesswater qout litter soil height trans leafc stemc rootc year month day
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

    //date snow evap netpsn depthtogw vegaccesswater qout litter soil height_over trans_over height_under trans_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
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

    //  date snow evap netpsn depthtogw vegaccesswater qout litter soil height_over trans height_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
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

        if(debugCubes && debugDetailed)
            Debug.Log(name+".StartSimulation()... simulationOn: "+simulationOn);

        timeIdx = startTimeIdx;
        timeStep = curTimeStep;

        //cubeObject.SetActive(true);

        // Initial update of data parameters
        if (settings.BuildForWeb)
            UpdateDataFromWeb(timeIdx, true, true);         
        else
            UpdateCurrentData(timeIdx);

        soilController.UpdateParams(timeStep, WaterAccess, DepthToGW);      // Initial update of soil parameters
        if (settings != null && settings.SnowEnabled)
            snowManager.snowValue = Mathf.Clamp(MathUtil.MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, 0f, snowScalingFactor), 0f, snowScalingFactor);
        else
            ResetSnow();

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
            
            // if (debugTrees && debugDetailed)
            //     Debug.Log(transform.name + ".GrowInitialVegetation()... treeAverageCarbonAmount:" + treeAverageCarbonAmount + " combinedCarbonOver:" + combinedCarbonOver + " treesToGrow:" + treesToGrow);

            // for (int i = 0; i < treesToGrow; i++)            /* Grow Initial Trees */
            // {
            //     bool spawned = GrowAFir(true);
            //     if (!spawned)
            //     {
            //         if (debugTrees)
            //             Debug.Log(transform.name + ".GrowInitialVegetation()... Couldn't grow tree!");
            //         break;
            //     }
            // }

             GrowInitialOverstory(combinedCarbonOver);

            /* Grow Initial Shrubs */
            int shrubsToGrow = (int)Mathf.Round(combinedCarbonUnder / shrubAverageCarbonAmount);        // Use Understory Data for Shrubs
            for (int i = 0; i < shrubsToGrow; i++)
            {
                GrowAShrub(true);
            }

            //UpdateShrubParticleSystems();
            //UpdateShrubRenderers();
        }

        GrowInitialGrassLayer();

        //Debug.Log(name + ".GrowInitialVegetation()... dataType: "+ dataType);
    }

    /// <summary>
    /// Grows the initial grass layer. BigCreek scatters grass patches randomly; CubeController_CCV3
    /// overrides this with a deterministic fill so the Central Coast understory reads consistently.
    /// </summary>
    protected virtual void GrowInitialGrassLayer()
    {
        GrowInitialGrass(cubeInitialGrassPatches);       // BigCreek: unchanged random fill
    }

        private int GetTreeSpeciesIndex(string speciesName)
    {
        if (speciesName != null && treeSpeciesIndexByName.TryGetValue(speciesName, out int idx))
            return idx;
        return -1; 
    }

    // patch 1 & 2 mixed together per percentage
    // private void GrowOverstoryByPatch(float combinedCarbonOver)
    // {
    //     int treesToGrow = (int)Mathf.Round(combinedCarbonOver / treeAverageCarbonAmount);
    //     float p1Percent = (patch1 != null) ? patch1.percent : 100f;

    //     for (int i = 0; i < treesToGrow; i++)
    //     {
    //         // randomly select patch 1 or patch 2 based on percentage
    //         PatchDisplayInfo patch = (patch2 != null && Random.value * 100f >= p1Percent) ? patch2 : patch1;

    //         int speciesIdx = (patch != null) ? GetTreeSpeciesIndex(patch.overstorySpecies) : 0;
    //         if (speciesIdx < 0) continue;   // Skip if species not found

    //         bool spawned = GrowAFir(true, speciesIdx);
    //         if (!spawned) break;
    //     }
    // }

     // Grows overstory plants for patch1/patch2, mixed by area percentage.
    // private void GrowOverstoryByPatch(float combinedCarbonOver)
    // {
    //     int treesToGrow = (int)Mathf.Round(combinedCarbonOver / treeAverageCarbonAmount);
    //     float p1Percent = (patch1 != null) ? patch1.percent : 100f;

    //     Debug.Log($"[VEG2] {name} p1:{(patch1 != null ? patch1.overstorySpecies + " " + patch1.percent + "%" : "NULL")} p2:{(patch2!= null ? patch2.overstorySpecies + " " + patch2.percent + "%" : "NULL")}");
    //      string ts = "";
    //     foreach (var kv in treeSpeciesIndexByName) ts += kv.Key + "=" + kv.Value + "  ";
    //     Debug.Log($"[VEG3] {name} treeSpecies:[{ts}] chaparralIdx:{GetTreeSpeciesIndex("Chaparral")} oakIdx:{GetTreeSpeciesIndex("Oak")}");

    //     for (int i = 0; i < treesToGrow; i++)
    //     {
    //         // Randomly assign this slot to patch1 or patch2 based on area percentage.
    //         PatchDisplayInfo patch = (patch2 != null && Random.value * 100f >= p1Percent) ? patch2 : patch1;

    //         // Grass-dominated patch: grow grass instead of trees.
    //         if (patch != null && patch.overstorySpecies == "Grass")
    //         {
    //             GrowAGrassPatch(true);
    //             continue;
    //         }

    //         int speciesIdx = (patch != null) ? GetTreeSpeciesIndex(patch.overstorySpecies) : 0;
    //         if (speciesIdx < 0) continue;   // Species not found in vegetation list, skip.

    //         // bool spawned = GrowAFir(true, speciesIdx);
    //         // if (!spawned) break;
    //         bool spawned = GrowAFir(true, speciesIdx);
    //         if (!spawned) continue;   // One failed slot shouldn't stop the whole loop
    //     }
    // }

//     private void GrowOverstoryByPatch(float combinedCarbonOver)
//   {
//       int treesToGrow = (int)Mathf.Round(combinedCarbonOver / treeAverageCarbonAmount);
//       float p1Percent = (patch1 != null) ? patch1.percent : 100f;

//       int grownP1 = 0, grownP2 = 0, fails = 0;   // TEMP diagnostic

//       for (int i = 0; i < treesToGrow; i++)
//       {
//           PatchDisplayInfo patch = (patch2 != null && Random.value * 100f >= p1Percent) ? patch2 : patch1;

//           // Grass-dominated patch: grow grass instead of trees.
//           if (patch != null && patch.overstorySpecies == "Grass")
//           {
//               GrowAGrassPatch(true);
//               continue;
//           }

//           int speciesIdx = (patch != null) ? GetTreeSpeciesIndex(patch.overstorySpecies) : 0;
//           if (speciesIdx < 0) continue;

//           bool spawned = GrowAFir(true, speciesIdx);
//           if (spawned) { if (patch == patch1) grownP1++; else grownP2++; }   // TEMP
//           else fails++;                                                       // TEMP: no more break
//       }

//       // TEMP diagnostic
//       Debug.Log($"[VEG4] {name} {(patch1 != null ? patch1.overstorySpecies : "?")}:{grownP1} {(patch2 != null ? patch2.overstorySpecies : "?")}:{grownP2} fails:{fails} / {treesToGrow}");
//   }

    /// <summary>
    /// Grows the initial overstory from carbon. BigCreek grows a single tree species sized by the
    /// combined overstory carbon; CubeController_CCV3 grows each patch (patch1 / patch2) from its own
    /// carbon and area percentage.
    /// </summary>
    protected virtual void GrowInitialOverstory(float combinedCarbonOver)
    {
        int count = (int)Mathf.Round(combinedCarbonOver / treeAverageCarbonAmount);
        for (int i = 0; i < count; i++)
            if (!GrowAFir(true, 0)) break;
    }

    // // Grows one patch's overstory from its own carbon, scaled by its area percentage.
    // private void GrowPatchOverstory(PatchDisplayInfo patch, float carbonOver)
    // {
    //     if (patch == null) return;

    //     int count = (int)Mathf.Round(carbonOver / treeAverageCarbonAmount * patch.percent / 100f);
    //     for (int i = 0; i < count; i++)
    //     {
    //         // Grass-dominated patch: grow grass instead of trees.
    //         if (patch.overstorySpecies == "Grass")
    //         {
    //             GrowAGrassPatch(true);
    //             continue;
    //         }

    //         int speciesIdx = GetTreeSpeciesIndex(patch.overstorySpecies);
    //         if (speciesIdx < 0) continue;

    //         GrowAFir(true, speciesIdx);   // No break: one failed slot shouldn't stop the rest
    //     }

    //     Debug.Log($"[PATCH] {name} {patch.overstorySpecies} carbon:{carbonOver:F3} pct:{patch.percent} count:{count}");
    // }

    
      // Grows one patch's overstory from its own carbon, scaled by its area percentage.
      protected void GrowPatchOverstory(PatchDisplayInfo patch, float carbonOver)
    {
        if (patch == null) return;

        // Migrated path: the patch defines its overstory as one or more tree species. Grow a fixed
        // number of individuals per species (N_stems * percentInPatch) from cube_info; carbon drives
        // per-tree SIZE over time (GrowTree), not the head count.
        if (patch.overstory != null && patch.overstory.Count > 0)
        {
            foreach (Species sp in patch.overstory)
            {
                if (sp == null) continue;
                int speciesIdx = sp.runtimeSpeciesIdx;
                if (speciesIdx < 0) continue;

                int stems = Mathf.Clamp(Mathf.RoundToInt(patch.nStems * sp.percentInPatch / 100f),
                                        0, MaxTreesForCube());
                for (int i = 0; i < stems; i++)
                    GrowAFir(true, speciesIdx);   // No break: one failed slot shouldn't stop the rest
            }
            return;
        }

        // Legacy path: single overstorySpecies (or grass), count derived from carbon. Pre-migration
        // cubes and grass-only patches (overstory empty, overstorySpecies = "Grass") use this.
        bool isGrassPatch = (patch.overstorySpecies == "Grass");
        float avgCarbon = isGrassPatch ? grassAverageCarbonAmount : treeAverageCarbonAmount;
        if (avgCarbon <= 0f) return;

        int count = (int)Mathf.Round(carbonOver / avgCarbon * patch.percent / 100f);

        if (isGrassPatch)
            count = Mathf.Clamp((int)(count * grassPatchDensityScale), 0, maxGrassesPerPatch);
        else
            count = Mathf.Clamp(count, 0, MaxTreesForCube());

        for (int i = 0; i < count; i++)
        {
            if (isGrassPatch)
            {
                GrowAGrassPatch(true);
                continue;
            }

            int speciesIdx = GetTreeSpeciesIndex(patch.overstorySpecies);
            if (speciesIdx < 0) continue;

            GrowAFir(true, speciesIdx);
        }
    }

    // Reads patch2 (second member) overstory carbon at the given 0-based sim time index.
    protected float GetOverstoryCarbonP2(int idx)
    {
        if (cubeDataP2 == null) return 0f;
        if (cubeDataP2.TryGetValue(idx + 1, out CubeData row))   // +1: 0-based timeIdx -> 1-based dateIdx
            return row.leafCOver + row.stemCOver;
        return 0f;
    }

    // Reads a patch's individuals-died at the given 0-based sim time index. Works for either member's
    // data dict (cubeData = patch1, cubeDataP2 = patch2); both are keyed by 1-based dateIdx, hence +1.
    protected float GetIndDied(Dictionary<int, CubeData> data, int idx)
    {
        if (data != null && data.TryGetValue(idx + 1, out CubeData row))   // +1: 0-based timeIdx -> 1-based dateIdx
            return row.ind_died;
        return 0f;
    }

    // Overstory height (m) at the given 0-based sim time index. Picks the member's dict internally
    // (both are private, so callers pass a flag instead of the dict). patch2=false -> this cube's rows.
    protected float GetHeightOver(int idx, bool patch2)
    {
        Dictionary<int, CubeData> data = patch2 ? cubeDataP2 : cubeData;
        if (data != null && data.TryGetValue(idx + 1, out CubeData row))   // +1: 0-based -> 1-based dateIdx
            return row.heightOver;
        return 0f;
    }

    // Central Coast: turn each patch's per-step ind_died (individuals that died that day) into queued
    // kills, split across the patch's overstory species by percentInPatch. Processed once per timeIdx
    // so a paused frame can't re-queue the same deaths.
    protected void QueuePatchIndDiedDeaths()
      {
          if (timeIdx <= lastDeathTimeIdx) return;      // no forward progress (also blocks re-queue on a paused frame)

          int from = lastDeathTimeIdx + 1;              // sum every day since last processed, so timeStep jumps can't skip single-day events
          lastDeathTimeIdx = timeIdx;

          float p1 = 0f, p2 = 0f;
          for (int k = from; k <= timeIdx; k++)
          {
              p1 += GetIndDied(cubeData, k);            // patch1 = this cube's own data
              p2 += GetIndDied(cubeDataP2, k);          // patch2 = second member
          }

          QueueIndDiedForPatch(patch1, p1);
          QueueIndDiedForPatch(patch2, p2);

      }

    private void QueueIndDiedForPatch(PatchDisplayInfo patch, float indDied)
    {
        if (patch == null || patch.overstory == null || patch.overstory.Count == 0) return;
        if (firsToKillBySpecies == null) return;

        int deaths = Mathf.RoundToInt(indDied);
        if (deaths <= 0) return;

        foreach (Species sp in patch.overstory)
        {
            if (sp == null) continue;
            int idx = sp.runtimeSpeciesIdx;
            if (idx < 0 || idx >= firsToKillBySpecies.Length) continue;

            int share = Mathf.RoundToInt(deaths * sp.percentInPatch / 100f);
            // Kill immediately, not via the per-frame drain: during a fire the veg update (and thus the
            // drain) is suppressed (UpdateVegetation only runs when !terrainBurning), so a queued
            // fire-date death would never drain. ind_died is explicit data — apply it in full right now.
            firsToKillBySpecies[idx] += share;
            while (firsToKillBySpecies[idx] > 0)
            {
                if (!KillAFir(false, idx)) break;   // kills one (animated) + decrements; clears queue if none left
            }
        }

        Debug.Log($"[DEATH] {name} patch:{(patch != null ? patch.overstorySpecies : "?")} ind_died:{indDied} deaths:{deaths} queued:{string.Join(",", firsToKillBySpecies)}");
    }
    
    /// <summary>
    /// Central Coast hook: lets a subclass rebuild <see cref="vegetation"/>.species just before the
    /// tree/shrub lists are built (e.g. flattening per-patch overstory lists into the flat list).
    /// Base does nothing, so BigCreek keeps its Inspector-assigned vegetation.species unchanged.
    /// </summary>
    protected virtual void PrepareVegetationList() { }

    /// <summary>
    /// Per-cube tree budget (size of the tree location pool). Base returns the global cap; a subclass
    /// (Central Coast) can raise it so a cube shows its own literal stem count without touching the
    /// global MaxTrees or BigCreek.
    /// </summary>
    protected virtual int MaxTreesForCube()
    {
        return settings.MaxTrees;
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
        if (lastFirGrownTimeIdxBySpecies != null)
              System.Array.Clear(lastFirGrownTimeIdxBySpecies, 0, lastFirGrownTimeIdxBySpecies.Length);

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
        if(housePrefab && drivewayPrefab)
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
        PrepareVegetationList();            // CC hook: may rebuild vegetation.species from per-patch overstory. Base: no-op.
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
                deadTreePrefabsBySpecies.Add(species.deadPrefab);   // Kept index-aligned with treeList; null = use the shared prefab
                treeSpeciesIndexByName[species.name] = treeList.Count - 1;
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
        grassAverageCarbonAmount = shrubAverageCarbonAmount * 0.01f;

        // lodGroup = treeList[0][treeList[0].Count - 1];
        // lod0 = lodGroup.transform.GetChild(0).gameObject as GameObject;
        // float fullTreeHeight = lod0.transform.GetComponent<Renderer>().bounds.size.y;            // Get height of prefab (m.)
        // lodGroup = treeList[0][treeList[0].Count - 1];
        // float fullTreeHeight = lodGroup.GetComponentInChildren<Renderer>().bounds.size.y;
        // treeAverageCarbonAmount = (settings.MaxTreeFullHeightScale + settings.MinTreeFullHeightScale) / 2f * fullTreeHeight * GetTreeCarbonFactor();    // -- WHY CAUSES FREEZING BUG??
        
        // Default height; avoids out-of-range when a cube has no tree species (e.g. grass-only or aggregate).
        float fullTreeHeight = 1f;
        if (treeList.Count > 0 && treeList[0].Count > 0)
        {
            lodGroup = treeList[0][treeList[0].Count - 1];
            Renderer treeRend = lodGroup.GetComponentInChildren<Renderer>();
            if (treeRend != null) fullTreeHeight = treeRend.bounds.size.y;
        }
        treeAverageCarbonAmount = (settings.MaxTreeFullHeightScale + settings.MinTreeFullHeightScale) / 2f * fullTreeHeight *
        GetTreeCarbonFactor();
        firsToKillBySpecies = new int[Mathf.Max(1, treeList.Count)];
        lastFirGrownTimeIdxBySpecies = new int[Mathf.Max(1, treeList.Count)];
        
        burntSplatmap = CreateBurntSplatmap();
        unburntSplatmap = CreateUnburntSplatmap();
        ResetTerrainSplatmap();

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

        ResetFireManager();
        //fireManager.Initialize(pooler, firePrefab, fireGridCenterLocation, cubeObject.transform.position, null, null, false, true, settings.BuildForWeb);
        //if(hasStream)
        //    fireManager.DisableFireCells(true, 5);
        //else if(hasHouse)
        //    fireManager.DisableFireCells(false, 5);

        HideStatistics();

        emissions = new List<ParticleSystem.EmissionModule>();
        UpdateETList();

        firstRun = false;
        //Debug.Log(name+".Initialize()... firePrefab == null? " + (firePrefab == null));
    }

    public void ResetFireManager()
    {
        if (settings != null && !settings.FireEnabled)
            return;

        try
        {
            fireManager.Reset();
            fireManager.Initialize(pooler, firePrefab, fireGridCenterLocation, cubeObject.transform.position, null, null, false, true);
            if (hasStream)
                fireManager.DisableFireCells(true, riverFireGapWidth);
            else if (hasHouse)
                fireManager.DisableFireCells(false, houseDefensibleWidth);
        }
        catch (Exception e)
        {
            Debug.LogError(name + ".ResetFireManager()... " + e.Message);
        }
    }

    /// <summary>
    /// Enter Side-by-Side Mode
    /// </summary>
    /// <param name="sideBySideStatsPanel">Statistics panel to use for cube</param>
    public void EnterSideBySide(int newTimeIdx, GameObject sideBySideStatsPanel, int newWarmingIdx)
    {
        timeIdx = newTimeIdx;
        SetWarmingIdx(newWarmingIdx);

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
        // Create house
        //Vector3 loc = new Vector3(8.6f, 7f, -20.4f);
        //Vector3 loc = new Vector3(0f, 7f, -30f);
        Vector3 loc = new Vector3(5f, 5.3f, -25f);
        Vector3 rot = housePrefab.transform.rotation.eulerAngles;
        rot.y = -90f;
        houseObj = Instantiate(housePrefab, Vector3.zero, Quaternion.Euler(rot), cubeObject.transform);
        houseObj.transform.localPosition = loc;

        // Create defensible spaces
        float startX = 1f;
        float startZ = -20f;
        float drivewayWidth = 4f;
        float drivewayHeight = 8f;

        for (int y = 0; y < 3; y++)
        {
            for (int x = 0; x < 6; x++)
            {
                loc = new Vector3(startX + y * drivewayHeight, 5.3f, startZ - x * drivewayWidth);
                rot = drivewayPrefab.transform.rotation.eulerAngles;
                rot.y = 0f;
                houseObj = Instantiate(drivewayPrefab, Vector3.zero, Quaternion.Euler(rot), cubeObject.transform);
                houseObj.transform.localPosition = loc;
            }
        }

        // Create driveway
        loc = new Vector3(startX + 3f * drivewayHeight, 5.3f, startZ - 1f * drivewayWidth);
        rot = drivewayPrefab.transform.rotation.eulerAngles;
        rot.y = 0f;
        houseObj = Instantiate(drivewayPrefab, Vector3.zero, Quaternion.Euler(rot), cubeObject.transform);
        houseObj.transform.localPosition = loc;


        //loc = new Vector3(5f, 5.3f, -20f);
        //rot = drivewayPrefab.transform.rotation.eulerAngles;
        //rot.y = 0f;
        //houseObj = Instantiate(drivewayPrefab, Vector3.zero, Quaternion.Euler(rot), cubeObject.transform);
        //houseObj.transform.localPosition = loc;

        //houseObj.transform.rotation = Quaternion.Euler(rot);

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
        deadTreePrefabsBySpecies = new List<GameObject>();   // Parallel to treeList; entries may be null
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
        plantCarbonSlider = statsPanel.transform.Find("PlantCarbonSlider").GetComponent<Slider>() as Slider;
        //snowAmountSlider = statsPanel.transform.Find("SnowAmountSlider").GetComponent<Slider>() as Slider;
        //psnSlider = statsPanel.transform.Find("PSNSlider").GetComponent<Slider>() as Slider;
        //waterAccessSlider = statsPanel.transform.Find("WaterAccessSlider").GetComponent<Slider>() as Slider;

        netTransSliderDebug = statsPanel.transform.Find("NetTransSliderDebug").GetComponent<Slider>() as Slider;
        netTransSliderDebug.gameObject.SetActive(false);
        plantCarbonSliderDebug = statsPanel.transform.Find("PlantCarbonSliderDebug").GetComponent<Slider>() as Slider;
        plantCarbonSliderDebug.gameObject.SetActive(false);
        //snowAmountSliderDebug = statsPanel.transform.Find("SnowAmountSliderDebug").GetComponent<Slider>() as Slider;
        //snowAmountSliderDebug.gameObject.SetActive(false);
        //psnSliderDebug = statsPanel.transform.Find("PSNSliderDebug").GetComponent<Slider>() as Slider;
        //psnSliderDebug.gameObject.SetActive(false);
        //waterAccessSliderDebug = statsPanel.transform.Find("WaterAccessSliderDebug").GetComponent<Slider>() as Slider;
        //waterAccessSliderDebug.gameObject.SetActive(false);

        Assert.IsNotNull(netTransSlider);
        Assert.IsNotNull(plantCarbonSlider);
        //Assert.IsNotNull(snowAmountSlider);
        //Assert.IsNotNull(psnSlider);
        //Assert.IsNotNull(waterAccessSlider);
    }

    /// <summary>
    /// Creates the trees.
    /// </summary>
    private void CreateTreeLocations()
    {
        // firLocations = new Vector3[settings.MaxTrees];
        firLocations = new Vector3[MaxTreesForCube()];
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

            for (int i = start; i < MaxTreesForCube(); i++)
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
        else if (hasHouse)                  // Create trees for cube with house
        {
            switch (settings.MinFrontTrees)
            {
                case 1:
                    goto default;

                case 2:
                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
                    firLocations[0] = new Vector3(randX, 0, cubeFront);        //  Front tree 1
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;

                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
                    firLocations[1] = new Vector3(randX, 0, cubeFront);        //  Front tree 2
                    firLocations[1].y = terrain.SampleHeight(firLocations[1]) + terrain.GetPosition().y;

                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;
                    firLocations[1].x += offsetX;
                    firLocations[1].z += offsetZ;

                    start = 2;
                    break;

                default:
                    randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + (houseWidth * 0.5f));
                    firLocations[0] = new Vector3(randX, 0, cubeFront);        //  Front tree 
                    firLocations[0].y = terrain.SampleHeight(firLocations[0]) + terrain.GetPosition().y;
                    firLocations[0].x += offsetX;
                    firLocations[0].z += offsetZ;

                    start = 1;
                    break;
            }

            for (int i = start; i < MaxTreesForCube(); i++)
            {
                randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
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
                        randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
                        randZ = Random.Range(cubeZMin, cubeZMax);
                        randX += offsetX;
                        randZ += offsetZ;
                    }
                    if (++count > whileLoopMaxCount)
                    {
                        Debug.Log(transform.name + ".CreateTrees()... Tried 100 tree locations and none found within min spacing distance!");
                        throw new System.Exception();     
                    }
                }

                firLocations[i] = new Vector3(randX, 0f, randZ);
                firLocations[i].y = terrain.SampleHeight(firLocations[i]) + terrain.GetPosition().y;
            }
        }
        else                     // Create trees for cube without stream or house
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

            for (int i = start; i < MaxTreesForCube(); i++)
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

        // Central Coast clusters patch1 into groves (near the stream if the cube has one); BigCreek does not.
        ClusterTreeLocations(offsetX, offsetZ, cubeZMin, cubeZMax);

        firs = new List<FirController>();
    }

    /// <summary>
    /// Re-orders <see cref="firLocations"/> after they are created. BigCreek leaves them as-is;
    /// CubeController_CCV3 sorts them into stream-hugging groves so patch1 fills the riparian strip
    /// and patch2 fills the outer banks.
    /// </summary>
    protected virtual void ClusterTreeLocations(float offsetX, float offsetZ, float cubeZMin, float cubeZMax) { }

    // // Distance from p to the closest clump center (for Central Coast patch1 clustering).
    // private float NearestClumpDist(Vector3 p, Vector3[] centers)
    // {
    //     float min = float.MaxValue;
    //     foreach (Vector3 c in centers)
    //     {
    //         float d = Vector3.Distance(p, c);
    //         if (d < min) min = d;
    //     }
    //     return min;
    // }
    
    // Anisotropic distance to the nearest clump center. On a stream cube the cross-stream (X)
    // term dominates, so the sort runs "near the stream" -> "far from the stream" on BOTH banks;
    // the weakened along-stream (Z) term only groups trees into groves. Plain distance otherwise.
    protected float NearestClumpDist(Vector3 p, Vector3[] centers)
    {
        float zWeight = hasStream ? 0.25f : 1f;
        float min = float.MaxValue;
        foreach (Vector3 c in centers)
        {
            float dx = p.x - c.x;
            float dz = (p.z - c.z) * zWeight;
            float d = Mathf.Sqrt(dx * dx + dz * dz);
            if (d < min) min = d;
        }
        return min;
    }

    /// <summary>
    /// Sets the warming index.
    /// </summary>
    /// <param name="newWarmingIdx">New warming index.</param>
    public void SetWarmingIdx(int newWarmingIdx)
    {
        warmingIdx = newWarmingIdx;

        switch (warmingIdx)
        {
            case 0:                 // Baseline
                SetWarmingDegrees(0, false);
                break;
            case 1:                 // 1 Degree
                SetWarmingDegrees(1, false);
                break;
            case 2:                 // 2 Degrees
                SetWarmingDegrees(2, false);
                break;
            case 4:                 // 4 Degrees
                SetWarmingDegrees(4, false);
                break;
            case 6:                 // 6 Degrees
                SetWarmingDegrees(6, false);
                break;
        }
    }

    /// <summary>
    /// Set warming degrees
    /// </summary>
    /// <param name="newWarmingDegrees">New warming degree amount</param>
    /// <param name="setIndex">Flag to set index as well</param>
    public void SetWarmingDegrees(int newWarmingDegrees, bool setIndex)
    {
        warmingDegrees = newWarmingDegrees;

        if (!setIndex)
            return;

        switch (newWarmingDegrees)
        {
            case 0:                 // Baseline
                warmingIdx = 0;
                break;
            case 1:                 // 1 Degree
                warmingIdx = 1;
                break;
            case 2:                 // 2 Degrees
                warmingIdx = 2;
                break;
            case 4:                 // 4 Degrees
                warmingIdx = 3;
                break;
            case 6:                 // 6 Degrees
                warmingIdx = 4;
                break;
        }
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
    public void InitializeDataFile(TextAsset dataFile)
    {
        //if (settings.BuildForWeb)
        //    return;
        
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
            fir.UpdateETSimulationSpeed(Mathf.Clamp(timeStep, 0f, maxETSpeed));
        }

        foreach (ShrubController shrub in shrubs)
        {
            if (shrub != null)
                shrub.UpdateETSimulationSpeed(Mathf.Clamp(timeStep, 0f, maxETSpeed));
        }
    }

    /// <summary>
    /// Updates the vegetation from data.
    /// </summary>
    public void UpdateVegetationFromData()
    {
        if (!simulationOn)
            return;

        if (settings.BuildForWeb && !HasDataRow(timeIdx))
        {
            Debug.LogWarning(name + ".UpdateVegetationFromData()... Missing cube data for timeIdx:" + timeIdx + ". Skipping vegetation reset.");
            return;
        }

        ResetCube();
        //Debug.Log(name + ".UpdateVegetationFromData()... ");
        UpdateCurrentData(timeIdx);         // Added 12/23/24
        GrowInitialVegetation();
    }

    /// <summary>
    /// Updates the animation.
    /// </summary>
    public void UpdateAnimation()
    {
        float pos = MathUtil.MapValue(Time.time, animationStartTime, animationEndTime, 0f, 1f);

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
                float pos1 = MathUtil.MapValue(pos, 0f, 0.5f, 0f, 1f);
                animated.transform.localScale = Vector3.Lerp(startScale, halfTargetScale, pos1);
            }
            else
            {
                float pos2 = MathUtil.MapValue(pos, 0.5f, 1f, 0f, 1f);
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

        bool validDataTime = settings.BuildForWeb ? HasDataRow(timeIdx) : (timeIdx >= 0 && timeIdx < dataLength);
        if (validDataTime)
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

            if (settings == null || settings.SnowEnabled)
            {
                if (snowValue > 0.0001f)
                    snowValue = Mathf.Clamp(snowValue - snowMeltRate * Mathf.Sqrt(timeStep), 0f, 100000f);      // Melt snow

                /* Add snow from current data */
                if (timeStep == 1)
                {
                    snowValue = Mathf.Clamp(snowValue + MathUtil.MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, snowValueMin, snowValueMax), snowValueMin, snowValueMax);
                }
                else
                {
                    float combinedSnow = 0f;
                    int step = 0;
                    for (int i = 0; i < timeStep; i++)
                    {
                        int idx = timeIdx - i;
                        if (idx < 0)
                        {
                            continue;
                        }

                        float amount = ReadData((int)DataColumnIdx.Snow, idx);
                        float val = Mathf.Clamp(MathUtil.MapValue(amount, SnowAmountMin, SnowAmountMax, snowValueMin, snowValueMax), snowValueMin, snowValueMax);
                        combinedSnow += val;
                        step++;

                        //if (transform.name.Contains("CubeB"))
                        //    Debug.Log(transform.name + " Snow... val:" + val + " combinedSnow:" + combinedSnow);
                        //Debug.Log(transform.name + " GetCurrentData... amount:" + amount);
                        //Debug.Log(transform.name + " GetCurrentData... snowValueMin:" + snowValueMin + "  snowValueMax:" + snowValueMax);
                        //Debug.Log(transform.name + " GetCurrentData... SnowAmountMin:" + SnowAmountMin + "  SnowAmountMax:" + SnowAmountMax);
                    }

                    if (step == 0)
                        return;

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
            }
            else
            {
                ResetSnow();
            }
            //if (name.Equals("CubeC") || name.Equals("CubeC_Side"))
            //{
            //    if (GameController.Instance.sideBySideMode)
            //    {
            //        Debug.Log(name + ".snowManager.snowValue: " + snowManager.snowValue+ " from SnowAmount:"+ SnowAmount);
            //        CubeData row = GetDataRow(timeIdx);
            //        Debug.Log(name+">>> row.snow: "+ row.snow);
            //    }
            //}

            QueuePatchIndDiedDeaths();
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
            if (settings.BuildForWeb)
                Debug.LogWarning(name + ".UpdateVegetationBehavior()... Missing cube data for timeIdx:" + timeIdx + ". Skipping vegetation update.");
            else if (debugCubes && debugDetailed)
                Debug.Log("UpdateSimulation()... Invalid time index!  timeIdx: " + timeIdx);
        }

        if ((settings == null || settings.SnowEnabled) && snowValue > 0)
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

                SetToBurnt();
                //terrain.terrainData.SetAlphamaps(0, 0, burntSplatmap);      // Set burnt terrain splatmap

                //fireRegrowthStartTimeIdx = timeIdx;                         // Time idx when last fire ended
                //terrainBurning = false;
                //terrainBurnt = true;

                //ResetFireManager();         // Added 12-27-24
            }
        }
    }

    public void SetToBurnt()
    {
        terrain.terrainData.SetAlphamaps(0, 0, burntSplatmap);      // Set burnt terrain splatmap

        fireRegrowthStartTimeIdx = timeIdx;                         // Time idx when last fire ended
        terrainBurning = false;
        terrainBurnt = true;

        ResetFireManager();         // Added 12-27-24

        OnFireExtinguished();       // Hook: Central Coast kills any still-burning trees now (no trailing burn)
    }

    /// <summary>
    /// Called once when the cube's fire goes out. BigCreek does nothing extra (ignited trees finish
    /// their own burn); CubeController_CCV3 overrides this to kill any still-burning trees immediately
    /// so the fire stopping and the trees dying happen together, with no lingering burn.
    /// </summary>
    protected virtual void OnFireExtinguished() { }

    /// <summary>
    /// Updates the stream from simulation data.
    /// </summary>
    private void UpdateStream()
    {
        if (!simulationOn)
            return;

        float streamPos = ComputeStreamPos();       // Normalised water level; 1 = full. CubeController_CCV3 can return >1 to flood.
        // Lower-bounded only: a Central Coast flood (streamPos > 1) lifts the water above streamFullHeight.
        // BigCreek's streamPos never exceeds 1, so its result is identical to the old clamp.
        float streamSplineHeight = Mathf.Max(MathUtil.MapValue(streamPos, 0f, 1f, streamZeroHeight, streamFullHeight), streamZeroHeight);
        float streamFaceScale = Mathf.Max(MathUtil.MapValue(streamPos, 0f, 1f, streamFaceZeroScale, streamFaceFullScale), streamFaceZeroScale);

        streamObject.transform.localPosition = new Vector3(streamObject.transform.localPosition.x,
                                                            streamSplineHeight,
                                                            streamObject.transform.localPosition.z);

        streamFaceObject.transform.localScale = new Vector3(streamFaceObject.transform.localScale.x,
                                                             streamFaceScale,
                                                             streamFaceObject.transform.localScale.z);

        if (debugStream)
            Debug.Log($"{transform.parent.name} UpdateStream()... StreamHeight:{StreamHeight:E3} " +
                      $"range:[{StreamHeightMin:E3}, {StreamHeightMax:E3}] " +
                      $"streamPos:{streamPos:F3} splineY:{streamObject.transform.localPosition.y:F2} " +
                      $"faceScaleY:{streamFaceObject.transform.localScale.y:F2}");
    }

    /// <summary>
    /// Computes the normalised water level [0,1] for the stream spline/face. The base class uses the
    /// BigCreek response (log-scaled qout); CubeController_CCV3 overrides it with the Central Coast
    /// response (raw streamflow normalised, then a tunable power curve).
    /// </summary>
    protected virtual float ComputeStreamPos()
    {
        // BigCreek: qout is heavily skewed, so a log scale spreads the low end before normalising.
        return Mathf.Clamp(MathUtil.MapValue(Mathf.Log(StreamHeight) * 20f, StreamHeightMin, StreamHeightMax, 0f, 1f), 0f, 1f);
    }

    /// <summary>
    /// Handle vegetation growth in response to data       
    /// </summary>
    private void UpdateVegetation()
    {
        if (!simulationOn)
            return;

        UpdateVegetationCore();                 // Species-balance step; overridden by the Central Coast subclass

        GrowRoots();
        GrowShrubs();
        GrowGrass();
    }

    /// <summary>
    /// Per-frame vegetation balance step. The base class runs the BigCreek /
    /// aggregate single-patch behaviour; CubeController_CCV3 overrides this to
    /// balance each patch (patch1 / patch2) against its own carbon.
    /// </summary>
    protected virtual void UpdateVegetationCore()
    {
        UpdateVegetationDefault();              // BigCreek / aggregate: original single-patch behaviour
    }

    /// <summary>
    /// Central Coast vegetation balance. Each patch's overstory is balanced against its own carbon
    /// (patch1 from this cube's rows, patch2 from the second member's rows) so neither species starves
    /// the other, and grass stands in for the whole understory because no Central Coast species is
    /// flagged isShrub.
    /// </summary>
    protected void UpdateVegetationCentralCoast()
    {
        QueuePatchIndDiedDeaths();     // Central Coast: turn this step's ind_died into queued kills before draining
        if (firsToKillBySpecies != null)                     // Each patch has its own kill queue
        {
            for (int s = 0; s < firsToKillBySpecies.Length; s++)
            {
                if (firsToKillBySpecies[s] > 0)
                    KillAFir(false, s);
            }
        }

        if (shrubsToKill > 0)                                // Inert unless a fire queued shrubs
            KillAShrub();

        if (grassesToKill > 0)
            KillAGrassPatch();

        UpdatePatchOverstory(patch1, StemCarbonOver + LeafCarbonOver, StemCarbonOverMax + LeafCarbonOverMax);
        UpdatePatchOverstory(patch2, GetOverstoryCarbonP2(timeIdx), p2CarbonMax);

        UpdateCentralCoastGrass();
        UpdateOverstoryHeights();      // Central Coast: drive each tree's target height from its patch's heightOver
    }
    // Central Coast hook: set each tree's full-grown height from data heightOver. Base does nothing.
      protected virtual void UpdateOverstoryHeights() { }

    /// <summary>
    /// BigCreek / aggregate vegetation balance. Unchanged from the original single-patch behaviour.
    /// </summary>
    private void UpdateVegetationDefault()
    {
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
                if (Random.Range(0f, 100f) <= grassGrowthPercentChance)
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
                if (Random.Range(0f, 100f) <= grassGrowthPercentChance)
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
    }

    // Central Coast: grow-only recovery of a migrated patch's overstory. Deaths come from ind_died
    // (explicit data); recovery has no data, so it's computed — each species regrows toward a
    // carbon-scaled target capped at its N_stems share. Throttled so it fills in gradually.
    private void RecoverPatchOverstory(PatchDisplayInfo patch, float patchCarbonNow, float patchCarbonMax)
    {
        if (patch == null || patch.overstory == null || patch.overstory.Count == 0) return;
        if (firsToKillBySpecies == null || lastFirGrownTimeIdxBySpecies == null) return;

        float fullness = (patchCarbonMax > 0f) ? Mathf.Clamp01(patchCarbonNow / patchCarbonMax) : 0f;

        foreach (Species sp in patch.overstory)
        {
            if (sp == null) continue;
            int idx = sp.runtimeSpeciesIdx;
            if (idx < 0 || idx >= firsToKillBySpecies.Length) continue;
            if (firsToKillBySpecies[idx] > 0) continue;   // let all pending ind_died kills apply first — don't refill a death in progress

            int cap = Mathf.RoundToInt(patch.nStems * sp.percentInPatch / 100f);   // N_stems cap for this species
            int target = Mathf.RoundToInt(cap * fullness);                          // carbon-scaled target (<= cap)
            int alive = GetAliveTrees(idx).Count;

            // Grow only (never kill here — deaths are ind_died's job). Throttled.
             if (alive < target && (timeIdx - lastFirGrownTimeIdxBySpecies[idx] > firGrowthWaitTime))
              {
                  if (GrowAFir(false, idx))
                  {
                      lastFirGrownTimeIdxBySpecies[idx] = timeIdx;
                      Debug.Log($"[RECOVER] {name} sp{idx} +1 → {alive + 1}/{target}  full{fullness:F2}  t{timeIdx}");
                  }
              }
        }
    }

    /// <summary>
    /// Central Coast: balances one patch's overstory independently against its own carbon.
    /// </summary>
    /// <param name="patch">Patch display info (species + area percentage).</param>
    /// <param name="patchCarbonRaw">Unscaled stem + leaf overstory carbon for this patch.</param>
    /// <param name="patchCarbonMax">Maximum carbon capacity for this patch.</param>
    private void UpdatePatchOverstory(PatchDisplayInfo patch, float patchCarbonRaw, float patchCarbonMax)
    {
    if (patch == null) return;
    if (patch.overstory != null && patch.overstory.Count > 0)
    {
        RecoverPatchOverstory(patch, patchCarbonRaw, patchCarbonMax);   // grow-only recovery toward carbon-scaled N_stems; deaths come from ind_died
        return;
    }
    if (patch.overstorySpecies == "Grass") return;    // Grass-dominated patch: handled by UpdateCentralCoastGrass

    if (firsToKillBySpecies == null || lastFirGrownTimeIdxBySpecies == null) return;   // Initialize() hasn't run yet

    int speciesIdx = GetTreeSpeciesIndex(patch.overstorySpecies);
    if (speciesIdx < 0 || speciesIdx >= firsToKillBySpecies.Length) return;

    float carbonInData = patchCarbonRaw * patch.percent / 100f;
    float carbonInViz = GetTreeCarbonAmountVisualized(speciesIdx);          // What the stand is worth right now
    float carbonAtMaturity = GetTreePotentialCarbonVisualized(speciesIdx);  // What it will be worth fully grown
    float halfStep = treeAverageCarbonAmount * 0.5f;

    // Plant against carbon at maturity, not current carbon: saplings contribute almost nothing
    // today, so comparing carbonInViz here re-plants every frame until the stand is overstocked
    // and then has to be culled, which is why trees never reached full size.
    if (carbonAtMaturity < carbonInData - halfStep)
    {
        // Per-species throttle: a shared lastFirGrownTimeIdx lets patch1 consume every growth
        // slot before patch2 ever gets a turn.
        if (timeIdx - lastFirGrownTimeIdxBySpecies[speciesIdx] > firGrowthWaitTime)
        {
            if (GrowAFir(false, speciesIdx))
            {
                lastFirGrownTimeIdxBySpecies[speciesIdx] = timeIdx;
            }
            else if (debugTrees)
            {
                Debug.Log($"[PATCHBAL] {name} sp{speciesIdx}({patch.overstorySpecies}) couldn't grow — " +
                            $"cube may be at MaxTrees:{settings.MaxTrees} activeLocations:{activeFirLocations.Count}");
            }
        }
    }
    else if (carbonAtMaturity > carbonInData + halfStep)
    {
        // This branch is drought death only. Fire deaths run through IgniteFire / SetTreesToBurn,
        // so skip while the cube is burning or still in its post-fire recovery window, otherwise
        // the fire's carbon crash would be charged to drought as well. Requiring a large shortfall
        // stops ordinary carbon wobble from queueing a kill every few frames.
        bool fireInvolved = terrainBurning || terrainBurnt;
        bool bigEnoughDrop = (carbonAtMaturity - carbonInData) > carbonInData * droughtDeathThreshold;

        if (!fireInvolved && bigEnoughDrop && firsToKillBySpecies[speciesIdx] == 0)
        {
            int toKill = (int)Mathf.Round((carbonAtMaturity - carbonInData) / treeAverageCarbonAmount);
            int aliveOfSpecies = GetAliveTrees(speciesIdx).Count;
            // Clamp(x, 1, 0) would queue a kill that can never run, so guard the empty case.
            firsToKillBySpecies[speciesIdx] = (aliveOfSpecies > 0) ? Mathf.Clamp(toKill, 1, aliveOfSpecies) : 0;
        }
    }

    if (debugTrees)
    {
        // grown = how far the stand is from maturity (1.0 = every tree full size).
        // needed = trees required at full size to hit the target; compare with settings.MaxTrees.
        int aliveNow = GetAliveTrees(speciesIdx).Count;
        float grown = (carbonAtMaturity > 0f) ? carbonInViz / carbonAtMaturity : 0f;
        float needed = (treeAverageCarbonAmount > 0f) ? carbonInData / treeAverageCarbonAmount : -1f;

        Debug.Log($"[PATCHBAL] {name} t:{timeIdx} sp{speciesIdx}({patch.overstorySpecies}) " +
                $"viz:{carbonInViz:F3} mature:{carbonAtMaturity:F3} data:{carbonInData:F3} " +
                $"avg:{treeAverageCarbonAmount:F4} alive:{aliveNow} grown:{grown:F2} " +
                $"needed:{needed:F0}/{settings.MaxTrees} toKill:{firsToKillBySpecies[speciesIdx]} burnt:{terrainBurnt}");
    }
    }
    /// <summary>
      /// Central Coast grass balance. CC has no shrub layer (no species is flagged isShrub), so grass
      /// is the entire understory: balance it against understory carbon, plus patch2's overstory carbon
      /// when that patch is grass-dominated. Mirrors the tree/shrub feedback loop used elsewhere.
      /// </summary>
      private void UpdateCentralCoastGrass()
      {
          if (grassAverageCarbonAmount <= 0f || grasses == null) return;

          float grassCarbonInData = StemCarbonUnder + LeafCarbonUnder;   // NOTE: V3 has no stemCUnder column, so this is leaf carbon only

          if (patch2 != null && patch2.overstorySpecies == "Grass")
              grassCarbonInData += GetOverstoryCarbonP2(timeIdx) * patch2.percent / 100f;

          float grassCarbonInViz = GetGrassCarbonAmountVisualized();
          float halfStep = grassAverageCarbonAmount * 0.5f;

          if (grassCarbonInViz < grassCarbonInData - halfStep)
          {
              int toGrow = (int)((grassCarbonInData - grassCarbonInViz) / grassAverageCarbonAmount);
              toGrow = Mathf.Clamp(toGrow, 0, maxGrassGrowthPerStep);
              for (int i = 0; i < toGrow; i++)
                  GrowAGrassPatch(false);
          }
          else if (grassCarbonInViz > grassCarbonInData + halfStep)
          {
              grassesToKill = (int)((grassCarbonInViz - grassCarbonInData) / grassAverageCarbonAmount);
              grassesToKill = Mathf.Clamp(grassesToKill, 0, grasses.Count);
          }

          if (debugTrees)
              Debug.Log($"[GRASS] {name} viz:{grassCarbonInViz:F3} data:{grassCarbonInData:F3} " +
                        $"avg:{grassAverageCarbonAmount:F5} count:{grasses.Count} toKill:{grassesToKill}");
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
            if (obj == null)        // Destroyed elsewhere (litter is collected scene-wide); drop it.
            {
                removeList.Add(obj);
                continue;
            }

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

    public void UpdateDataFromWeb(int newTimeIdx, bool first, bool full) 
    {
        if (full)  // Always true
        {
            p1Loaded = false;
          p2Loaded = false;
            Debug.Log(name + ".UpdateDataFromWeb()... patchID:"+ patchID+" warmingIdx: " + warmingIdx);
            WebManager.Instance.RequestCubeData(patchID, warmingIdx, this.FinishUpdateDataFromWeb);

            RequestExtraPatchData(warmingIdx);   // Central Coast loads its second patch member here; base does nothing
        }
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
        //Debug.Log(name + ".UpdateDataRowsFromJSON()... rows[0].DateIdx: " + rows[0].dateIdx + " rows[0].VegAccessWater" + rows[0].vegAccessWater + " rows[0].Evap: " + rows[0].evap + " rows[0].DepthToGW: " + rows[0].depthToGW);
        //Debug.Log(name + ".UpdateDataRowsFromJSON()... rows[5].DateIdx: " + rows[5].dateIdx + " rows[5].VegAccessWater" + rows[5].vegAccessWater + " rows[5].Evap: " + rows[5].evap + " rows[5].DepthToGW: " + rows[5].depthToGW);
        //Debug.Log(name + ".UpdateDataRowsFromJSON()... rows[5].DateIdx: " + rows[5].dateIdx + " rows[5].qout" + rows[5].qout + " rows[5].snow: " + rows[5].snow + " rows[5].DepthToGW: " + rows[5].depthToGW);

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

    /// <summary>
    /// Finish cube data update data from web 
    /// </summary>
    /// <param name="jsonString">Cube data JSON string returned by API</param>
    private void FinishUpdateDataFromWeb(string jsonString) 
    {
        UpdateDataRowsFromJSON(jsonString);     // Update data for parameter range finding
        FindParameterRanges();
        UpdateDataFromJSON(jsonString);         // Sets cubeData
        p1Loaded = true;

        // Grow only when all needed members are loaded (so we never reset later).
        if (ReadyToGrowFromData())
            UpdateVegetationFromData();
    }

    /// <summary>
    /// Central Coast override: request the cube's second patch member (patchID + 1). Base loads a
    /// single member, so it does nothing extra.
    /// </summary>
    protected virtual void RequestExtraPatchData(int warmingIdx) { }

    /// <summary>
    /// Whether all data needed to grow vegetation has arrived. Base loads a single member so it is
    /// always ready; CubeController_CCV3 waits until the second patch member has loaded too.
    /// </summary>
    protected virtual bool ReadyToGrowFromData()
    {
        return true;
    }

    // Loads the second patch member's data, then re-grows so patch2 uses its own carbon.
    protected void FinishUpdateDataFromWebP2(string jsonString)
    {
        CubeDataModelList rowsObj = JsonUtility.FromJson<CubeDataModelList>("{\"rows\":" + jsonString + "}");
        cubeDataP2 = LoadData(rowsObj.rows);
        p2Loaded = true;

        p2CarbonMax = 0f;
        foreach (CubeData r in cubeDataP2.Values)
        {
            float c = r.leafCOver + r.stemCOver;
            if (c > p2CarbonMax) p2CarbonMax = c;
        }

        // Both members now loaded: grow once (no repeated reset).
        if (p1Loaded)
            UpdateVegetationFromData();
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
            if (row == null)
                return;

            //Debug.Log("UpdateCurrentData()... timeIdx: " + timeIdx+ " row.soil:" + row.soil);

            if (dataType == CubeDataType.Veg1)
            {
                SnowAmount = row.snow;
                DepthToGW = row.depthToGW;
                WaterAccess = row.vegAccessWater;
                StreamHeight = (float)row.qout;
                Litter = row.litter;
                NetPhotosynthesis = row.netpsn;
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
                StreamHeight = row.qout;
                Litter = row.litter;
                NetPhotosynthesis = row.netpsn;
                TransOver = row.transOver;
                TransUnder = row.transUnder;
                LeafCarbonOver = row.leafCOver;
                LeafCarbonUnder = row.leafCUnder;
                StemCarbonOver = row.stemCOver;
                StemCarbonUnder = row.stemCUnder;
                RootsCarbonOver = row.rootCOver;
                RootsCarbonUnder = row.rootCUnder;
                IndDiedOver = row.ind_died;
    
            }
            else if (dataType == CubeDataType.Agg)
            {
                SnowAmount = row.snow;
                DepthToGW = row.depthToGW;
                WaterAccess = row.vegAccessWater;
                StreamHeight = row.qout;
                Litter = row.litter;
                NetPhotosynthesis = row.netpsn;
                NetTranspiration = row.transOver;
                LeafCarbonOver = row.leafCOver;
                LeafCarbonUnder = row.leafCUnder;
                StemCarbonOver = row.stemCOver;
                StemCarbonUnder = row.stemCUnder;
                RootsCarbonOver = row.rootCOver;
                RootsCarbonUnder = row.rootCUnder;
            }

            //if(name.Contains("CubeA"))
            //    Debug.Log(name + ".UpdateCurrentData()... StreamHeight:" + StreamHeight);
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
                NetPhotosynthesis = ReadData((int)DataColumnIdx.NetPsn, timeIdx);
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
                NetPhotosynthesis = ReadData((int)DataColumnIdx.NetPsn, timeIdx);
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
                NetPhotosynthesis = ReadData((int)DataColumnIdx.NetPsn, timeIdx);
                NetTranspiration = ReadData((int)AggregateDataColumnIdx.Trans, timeIdx);
                LeafCarbonOver = ReadData((int)AggregateDataColumnIdx.LeafCarbonOver, timeIdx);
                LeafCarbonUnder = ReadData((int)AggregateDataColumnIdx.LeafCarbonUnder, timeIdx);
                StemCarbonOver = ReadData((int)AggregateDataColumnIdx.StemCarbonOver, timeIdx);
                StemCarbonUnder = ReadData((int)AggregateDataColumnIdx.StemCarbonUnder, timeIdx);
                RootsCarbonOver = ReadData((int)AggregateDataColumnIdx.RootCarbonOver, timeIdx);
                RootsCarbonUnder = ReadData((int)AggregateDataColumnIdx.RootCarbonUnder, timeIdx);
            }
        }

        if (settings != null && !settings.SnowEnabled)
            SnowAmount = 0f;
    }

    /// <summary>
    /// Get current cube data by time index
    /// </summary>
    /// <param name="timeIdx"></param>
    /// <returns></returns>
    CubeData GetDataRow(int timeIdx)
    {
        if (cubeData == null || cubeData.Count == 0)
        {
            Debug.LogWarning(name + ".GetDataRow()... No cube data loaded.");
            return null;
        }

        CubeData row;
        if (cubeData.TryGetValue(timeIdx, out row))
            return row;

        if (timeIdx == 0 && cubeData.TryGetValue(1, out row))
        {
            Debug.LogWarning(name + ".GetDataRow()... Missing timeIdx 0, using timeIdx 1.");
            return row;
        }

        Debug.LogWarning(name + ".GetDataRow()... Missing cube data for timeIdx:" + timeIdx + " cubeData.Count:" + cubeData.Count);
        return null;
    }

    private bool HasDataRow(int timeIdx)
    {
        if (cubeData == null || cubeData.Count == 0)
            return false;

        return cubeData.ContainsKey(timeIdx) || (timeIdx == 0 && cubeData.ContainsKey(1));
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
    /// <summary>
    /// Gets the dead/snag prefab for a tree species, falling back to the cube's shared one when that
    /// species has no dedicated model assigned.
    /// </summary>
    /// <param name="speciesIdx">Index into treeList.</param>
    /// <returns>The dead tree prefab to use.</returns>
    private GameObject GetDeadTreePrefab(int speciesIdx)
    {
        if (deadTreePrefabsBySpecies != null
            && speciesIdx >= 0 && speciesIdx < deadTreePrefabsBySpecies.Count
            && deadTreePrefabsBySpecies[speciesIdx] != null)
        {
            return deadTreePrefabsBySpecies[speciesIdx];
        }

        return deadTreePrefab;
    }

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

        GameObject speciesDeadPrefab = GetDeadTreePrefab(prefabListID);   // Oak and chaparral leave different snags

        if (speciesDeadPrefab != null)
        {
            GameObject newDeadTreePrefab = Instantiate(speciesDeadPrefab, firLocations[treeID], newRotation, newTree.transform);
            newDeadTreePrefab.transform.localRotation = newRotation;
            newDeadTreePrefab.name = "LODGroup_DeadTree";
            newDeadTreePrefab.SetActive(false);
        }
        else
        {
            // Without this child the tree cannot switch to a dead model, so death would crash later in
            // TreeController.HideDeadTreeObjects. Fail loudly here where the cause is still visible.
            Debug.LogError($"{name}.InstantiateTreeFromPrefab()... no dead tree prefab for species {prefabListID}. " +
                           $"Assign Species[{prefabListID}].deadPrefab, or the cube's shared Dead Tree Prefab.");
        }

        /* Add roots */
        for (int i = 0; i < rootsPrefabs.Count; i++)
        {
            GameObject rootsPrefab = rootsPrefabs[i];
            float rootsY = settings.RootsYOffsetFactor;
            GameObject newRoots = Instantiate(rootsPrefab, newTree.transform);       // Create root object from prefab
            newRoots.transform.localPosition = new Vector3(0f, rootsY, 0f);
            newRoots.transform.localRotation = Quaternion.Euler(180f, 0f, 0f);
            newRoots.name = "Roots_" + i;

            Assert.IsNotNull(newRoots);
            newRoots.SetActive(false);
        }

        newTree.AddComponent<FirController>();

        FirController firController = newTree.GetComponent<FirController>() as FirController;
        firController.InitializeSettings(settings);
        firController.InitializeGeometry();
        //firController.InitializePrefabs(treeList[0], rootsPrefabs, deadTreePrefab);
        firController.InitializePrefabs(treeList[prefabListID], rootsPrefabs, speciesDeadPrefab);
        firController.locationID = treeID;

        GameObject treeFireNodeChain = Instantiate(fireNodeChainPrefab, newTree.transform);         // Add fire node chain to tree

        //SERI_FireNodeChain nodeChain = newTree.GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;
        SERI_FireNodeChain nodeChain = treeFireNodeChain.GetComponent<SERI_FireNodeChain>() as SERI_FireNodeChain;
        firController.InitFireNodeChain(nodeChain);

        nodeChain.fireNodes = new SERI_FireNode[1];
        nodeChain.fireNodes[0] = treeFireNodeChain.transform.GetChild(0).GetComponent<SERI_FireNode>();
        nodeChain.Initialize(settings != null && settings.FireEnabled ? fireManager : null, true, true);

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
    /// Whether new tree slots for the given species should fill from the far (last) end of the sorted
    /// location list. BigCreek always fills from the near end; CubeController_CCV3 fills patch2
    /// (speciesIdx &gt; 0) from the far end so the understory species never crowds the riparian strip.
    /// </summary>
    protected virtual bool FillTreeSlotsFromFarEnd(int speciesIdx)
    {
        return false;
    }

    /// <summary>
    /// Grows a fir tree.
    /// </summary>
    private bool GrowAFir(bool immediate, int speciesIdx = 0)
    {
        //if (speciesIdx < 0 || speciesIdx >= treeList.Count) speciesIdx = 0; 
        // No valid tree species for this cube (e.g. grass-only or aggregate): can't grow a tree.
        if (treeList == null || treeList.Count == 0) return false;
        if (speciesIdx < 0 || speciesIdx >= treeList.Count) speciesIdx = 0;
        if (treeList[speciesIdx] == null || treeList[speciesIdx].Count == 0) return false;

        if (debugTrees && debugDetailed)
            Debug.Log(transform.name + " CubeController.GrowAFir()...  Growing fir" + (immediate ? " immediately..." : " at time:" + Time.time));

        // int index = 0;
        // while (activeFirLocations.Contains(index))
        // {
        //     index++;
        //     if (index >= settings.MaxTrees)
        //     {
        //         if (debugTrees)
        //             Debug.Log(name + ".GrowAFir()... Can't grow tree, max trees already grown!  activeFirLocations:" + activeFirLocations.Count);
        //         return false;
        //     }
        //     if (index > 1000)
        //     {
        //         Debug.Log(name + ".GrowAFir()... While loop error");
        //         return false;
        //     }
        // }

         // Central Coast: firLocations are sorted nearest-stream-first (see CreateTreeLocations).
          // Patch1 (sp0) fills from the near end; patch2 (sp1) fills from the far end,
          // so understory species never crowd the riparian strip.
          bool fillFromFarEnd = FillTreeSlotsFromFarEnd(speciesIdx);

          int index;
          if (fillFromFarEnd)
          {
              index = MaxTreesForCube() - 1;
              while (activeFirLocations.Contains(index))
              {
                  index--;
                  if (index < 0)
                  {
                      if (debugTrees)
                          Debug.Log(name + ".GrowAFir()... Can't grow tree, max trees already grown! activeFirLocations:" + activeFirLocations.Count);
                      return false;
                  }
              }
          }
          else
          {
              index = 0;
              while (activeFirLocations.Contains(index))
              {
                  index++;
                  if (index >= MaxTreesForCube())
                  {
                      if (debugTrees)
                          Debug.Log(name + ".GrowAFir()... Can't grow tree, max trees already grown! activeFirLocations:" + activeFirLocations.Count);
                      return false;
                  }
                  if (index > 1000)
                  {
                      Debug.Log(name + ".GrowAFir()... While loop error");
                      return false;
                  }
              }
          }

        Quaternion newRotation = Quaternion.Euler(new Vector3(0, Random.Range(0, 360), 0));

        /* Instantiate fir */
        GameObject treePrefab = treeList[speciesIdx][treeList[speciesIdx].Count - 1];
        //GameObject newTree = InstantiateTreeFromPrefab(index, 0, firLocations[index], newRotation, gameObject.transform);
        GameObject newTree = InstantiateTreeFromPrefab(index, speciesIdx, firLocations[index], newRotation, gameObject.transform);

        newTree.name = "Tree_sp" + speciesIdx + "_" + index;   // sp0 = patch1 species, sp1 = patch2 species
        FirController firController = newTree.GetComponent<FirController>();
        firController.speciesIdx = speciesIdx;   // Needed for per-patch carbon balance
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
        //float cubeZMin = settings.CubeTreePadding;                  // Min. local Z coord where shrubs grow
        float cubeZMin = 0.1f;                                        // Min. local Z coord where shrubs grow
        float cubeZMax = cubeWidth - settings.CubeTreePadding;        // Max. local Z coord where shrubs grow

        if (hasStream)                                   // Set shrub locations based on stream
        {
            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
            float randZ = Random.Range(cubeZMin, cubeZMax);

            if(Random.Range(0f, 100f) < settings.CubeShrubZonePreferencePercent)
            {
                //cubeZMax = settings.CubeShrubZoneDepth; // TESTING
                cubeZMin = cubeZMin += settings.CubeShrubZoneDepth; // TESTING
                randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, streamCenter - streamWidth * 0.5f, streamCenter + streamWidth * 0.5f);
                randZ = Random.Range(cubeZMin, cubeZMax);
            }

            randX += offsetX;
            randZ += offsetZ;
            grassLocation = new Vector3(randX, 0f, randZ);
            grassLocation.y = terrain.SampleHeight(grassLocation) + terrain.GetPosition().y;
            AddGrass(grassLocation, immediate);
        }
        else if (hasHouse)                                   // Set shrub locations based on house
        {
            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
            float randZ = Random.Range(cubeZMin, cubeZMax);

            if (Random.Range(0f, 100f) < settings.CubeShrubZonePreferencePercent)
            {
                //cubeZMax = settings.CubeShrubZoneDepth; // TESTING
                cubeZMin = cubeZMin += settings.CubeShrubZoneDepth; // TESTING
                randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
                randZ = Random.Range(cubeZMin, cubeZMax);
            }

            randX += offsetX;
            randZ += offsetZ;
            grassLocation = new Vector3(randX, 0f, randZ);
            grassLocation.y = terrain.SampleHeight(grassLocation) + terrain.GetPosition().y;
            AddGrass(grassLocation, immediate);
        }
        else                                              // Set shrub locations without stream or house
        {
            float randX = Random.Range(cubeXMin, cubeXMax);
            float randZ = Random.Range(cubeZMin, cubeZMax);

            if (Random.Range(0f, 100f) < settings.CubeShrubZonePreferencePercent)
            {
                //cubeZMax = settings.CubeShrubZoneDepth; // TESTING
                cubeZMin = cubeZMin += settings.CubeShrubZoneDepth; // TESTING
                randX = Random.Range(cubeXMin, cubeXMax);
                randZ = Random.Range(cubeZMin, cubeZMax);
            }

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

    // Grows an exact number of grass patches. Unlike GrowInitialGrass this does not randomise the
      // count, so the Central Coast background fill stays comparable between runs and between cubes.
      protected void GrowGrassPatches(int count)
      {
          for (int i = 0; i < count; i++)
              GrowAGrassPatch(true);
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

        // Same as AddShrub: a grass prefab with no fire node chain simply won't burn.
        SERI_FireNodeChain grassFireChain = newGrassObj.GetComponent<SERI_FireNodeChain>();
        if (grassFireChain != null)
            grassFireChain.Initialize(settings != null && settings.FireEnabled ? fireManager : null, false, true);
        else
            Debug.LogWarning($"{name}.AddGrass()... grass prefab '{grassPrefab.name}' has no SERI_FireNodeChain component; it will not burn.");

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
        else if (hasHouse)                                   // Set shrub locations based on house
        {
            float randX = GetRandomExcludingMiddle(cubeXMin, cubeXMax, houseCenter - houseWidth * 0.5f, houseCenter + houseWidth * 0.5f);
            float randZ = Random.Range(cubeZMin, cubeZMax);
            randX += offsetX;
            randZ += offsetZ;
            shrubLocation = new Vector3(randX, 0f, randZ);
            shrubLocation.y = terrain.SampleHeight(shrubLocation) + terrain.GetPosition().y;
            AddShrub(shrubLocation, immediate);
        }
        else                                              // Set shrub locations without stream or house
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
        if (shrubPrefabs == null || shrubPrefabs.Count == 0)   // No shrub prefabs available (CC seperate trees & shrubs in Patch 1 and 2)
        return;
        GameObject shrubPrefab;

        /* Choose random shrub prefab */
        int randIdx = (int)Mathf.Round(Random.Range(0f, shrubPrefabs.Count - 1f));
        shrubPrefab = shrubPrefabs[randIdx];

        if (shrubPrefab == null)
        {
            Debug.LogWarning(name + ".AddShrub()... ERROR shrubPrefab at idx " + randIdx + " is null!");
            return;                                          // Instantiating null throws; nothing to add
        }
        Quaternion newRotation = new Quaternion(0f, 0f, 0f, 0f);
        GameObject newShrubObj = Instantiate(shrubPrefab, location, newRotation, cubeObject.transform);     // Instantiate shrub
        newRotation.eulerAngles.Set(0f, Random.Range(0f, 360f), 0f);                                     // Choose random rotation
        newShrubObj.transform.localRotation = newRotation;

        newShrubObj.AddComponent<ShrubController>();

        // A shrub prefab without a fire node chain can't burn, but it shouldn't take the whole cube's
        // initialisation down with it.
        SERI_FireNodeChain shrubFireChain = newShrubObj.GetComponent<SERI_FireNodeChain>();
        if (shrubFireChain != null)
            shrubFireChain.Initialize(settings != null && settings.FireEnabled ? fireManager : null, false, true);
        else
            Debug.LogWarning($"{name}.AddShrub()... shrub prefab '{shrubPrefab.name}' has no SERI_FireNodeChain component; it will not burn.");

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
        if (firsToKillBySpecies != null)                                          // Central Coast: clear the per-patch queues too
            System.Array.Clear(firsToKillBySpecies, 0, firsToKillBySpecies.Length); // deaths re-accumulate after a reset/regrow
            lastKilledTreeFrame = timeIdx; 
            lastDeathTimeIdx = -1; // Central Coast: let ind_died deaths re-accumulate after a reset/regrow

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
    protected List<FirController> GetAliveTrees()
    {
        List<FirController> result = new List<FirController>();
        foreach (FirController fir in firs)
        {
            if (fir.IsAlive())
                result.Add(fir);
        }
        return result;
    }
    /// <summary>
    /// Returns alive trees of one species (Central Coast per-patch balance).
    /// </summary>
    private List<FirController> GetAliveTrees(int speciesIdx)
    {
        List<FirController> result = new List<FirController>();
        foreach (FirController fir in firs)
        {
            if (fir.IsAlive() && fir.speciesIdx == speciesIdx)
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
      /// Central Coast: kills a tree of a given species, so each patch's overstory decays on its own data
      /// instead of the shared random pick used by KillAFir(bool).
      /// </summary>
      private bool KillAFir(bool immediate, int speciesIdx)
      {
          List<FirController> aliveTrees = GetAliveTrees(speciesIdx);

          if (aliveTrees.Count == 0)
          {
              firsToKillBySpecies[speciesIdx] = 0;   // Nothing left to kill; clear the queue
              return false;
          }

          FirController fir = aliveTrees[Random.Range(0, aliveTrees.Count)];
          fir.Kill(immediate);

          if (immediate)
              activeFirLocations.Remove(fir.locationID);

          lastKilledTreeFrame = timeIdx;
          firsToKillBySpecies[speciesIdx]--;

          UpdateETList();
          return true;
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
            Debug.Log(name + ".IgniteTerrain()... ERROR Couldn't ignite since already burning / burnt!");
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
    protected virtual void SetVegetationToDieFromFire(int fireTimeIdx)            // TO DO: Fix for web (?)
    {
        if (dataType == CubeDataType.Veg1)
        {
            // float fireLeafCarbon = ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx);        // Read carbon data at fireTimeIdx
            // float fireStemCarbon = ReadData((int)DataColumnIdx.StemCarbonOver, fireTimeIdx);
            float fireLeafCarbon, fireStemCarbon;
            if (settings.BuildForWeb)
            {
                CubeData fireRow = GetDataRow(fireTimeIdx + 1);   // web： Get data row at fireTimeIdx + 1 (since fireTimeIdx is 0-based, and data rows are 1-based)
                fireLeafCarbon = fireRow != null ? fireRow.leafCOver : 0f;
                fireStemCarbon = fireRow != null ? fireRow.stemCOver : 0f;
            }
            else   // bigcreek
            {
                fireLeafCarbon = ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx);
                fireStemCarbon = ReadData((int)DataColumnIdx.StemCarbonOver, fireTimeIdx);
            }
                

            float shrubCarbonInData = fireStemCarbon + fireLeafCarbon;    // Get combined stem + leaf carbon in data
                                                                          //float shrubCarbonInData = StemCarbon + LeafCarbon;    // Get combined stem + leaf carbon in data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();      // Get carbon amount represented by shrubs in current simulation
            shrubsToKill = (int)Mathf.Round((shrubCarbonInViz - shrubCarbonInData) / shrubAverageCarbonAmount);
             Debug.Log($"[V3FIRE] DieFromFire idx:{fireTimeIdx} " +
            $"leafCoverRead:{ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx)} " +
            $"treeViz:{GetTreeCarbonAmountVisualized()} shrubViz:{GetShrubCarbonAmountVisualized()} " +
            $"firsToKill:{firsToKill} shrubsToKill:{shrubsToKill}");
        }
        else if (dataType == CubeDataType.Veg2)
        {
            // float fireLeafCarbonOver = ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx);
            // float fireLeafCarbonUnder = ReadData((int)DataColumnIdx.LeafCarbonUnder, fireTimeIdx);
            // float fireStemCarbonOver = ReadData((int)DataColumnIdx.StemCarbonOver, fireTimeIdx);
            // float fireStemCarbonUnder = ReadData((int)DataColumnIdx.StemCarbonUnder, fireTimeIdx);

            float fireLeafCarbonOver, fireLeafCarbonUnder, fireStemCarbonOver, fireStemCarbonUnder;
            if (settings.BuildForWeb)
            {
                CubeData fireRow = GetDataRow(fireTimeIdx + 1);
                fireLeafCarbonOver  = fireRow != null ? fireRow.leafCOver  : 0f;
                fireLeafCarbonUnder = fireRow != null ? fireRow.leafCUnder : 0f;
                fireStemCarbonOver  = fireRow != null ? fireRow.stemCOver  : 0f;
                fireStemCarbonUnder = fireRow != null ? fireRow.stemCUnder : 0f;
            }
            else
            {
                fireLeafCarbonOver  = ReadData((int)DataColumnIdx.LeafCarbonOver,  fireTimeIdx);
                fireLeafCarbonUnder = ReadData((int)DataColumnIdx.LeafCarbonUnder, fireTimeIdx);
                fireStemCarbonOver  = ReadData((int)DataColumnIdx.StemCarbonOver,  fireTimeIdx);
                fireStemCarbonUnder = ReadData((int)DataColumnIdx.StemCarbonUnder, fireTimeIdx);
            }

            float combinedCarbonOverInData = fireStemCarbonOver + fireLeafCarbonOver;       // Get combined stem + leaf carbon in overstory data
            float combinedCarbonUnderInData = fireStemCarbonUnder + fireLeafCarbonUnder;    // Get combined stem + leaf carbon in understory data
            float shrubCarbonInViz = GetShrubCarbonAmountVisualized();                      // Get carbon amount represented by shrubs in current simulation
            float treeCarbonInViz = GetTreeCarbonAmountVisualized();                        // Get carbon amount represented by trees in current simulation

            shrubsToKill = (int)Mathf.Round((shrubCarbonInViz - combinedCarbonUnderInData) / shrubAverageCarbonAmount);
            firsToKill = (int)Mathf.Round((treeCarbonInViz - combinedCarbonOverInData) / treeAverageCarbonAmount);
            Debug.Log($"[V3FIRE] DieFromFire idx:{fireTimeIdx} " +
            $"leafCoverRead:{ReadData((int)DataColumnIdx.LeafCarbonOver, fireTimeIdx)} " +
            $"treeViz:{GetTreeCarbonAmountVisualized()} shrubViz:{GetShrubCarbonAmountVisualized()} " +
            $"firsToKill:{firsToKill} shrubsToKill:{shrubsToKill}");
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
    /// Central Coast: works out how many trees the fire should take, per patch, on the same
    /// percent-scaled maturity basis as UpdatePatchOverstory. The shared path compares every species'
    /// current carbon against patch1's raw (unscaled) carbon, which makes the difference negative, so
    /// firsToKill came out <= 0 and SetTreesToBurn disabled burning on every tree instead of igniting it.
    /// </summary>
    /// <param name="fireTimeIdx">Time index of the fire.</param>
    protected void SetCentralCoastVegetationToDieFromFire(int fireTimeIdx)
    {
        firsToKill = 0;

        CubeData fireRow = GetDataRow(fireTimeIdx + 1);          // +1: 0-based timeIdx -> 1-based dateIdx
        float carbonP1AfterFire = (fireRow != null) ? fireRow.leafCOver + fireRow.stemCOver : 0f;

        QueuePatchFireDeaths(patch1, carbonP1AfterFire);
        QueuePatchFireDeaths(patch2, GetOverstoryCarbonP2(fireTimeIdx));

        if (debugFire || debugTrees)
            Debug.Log($"[CCFIRE] {name} fireIdx:{fireTimeIdx} carbonP1After:{carbonP1AfterFire:F3} " +
                      $"carbonP2After:{GetOverstoryCarbonP2(fireTimeIdx):F3} firsToKill:{firsToKill}");
    }

    /// <summary>
    /// Adds one patch's share of fire deaths to the shared firsToKill counter consumed by SetTreesToBurn.
    /// </summary>
    /// <param name="patch">Patch display info (species + area percentage).</param>
    /// <param name="patchCarbonRaw">Unscaled overstory carbon for this patch at the time of the fire.</param>
    private void QueuePatchFireDeaths(PatchDisplayInfo patch, float patchCarbonRaw)
    {
        if (patch == null || patch.overstorySpecies == "Grass") return;
        if (firsToKillBySpecies == null || treeAverageCarbonAmount <= 0f) return;

        int speciesIdx = GetTreeSpeciesIndex(patch.overstorySpecies);
        if (speciesIdx < 0 || speciesIdx >= firsToKillBySpecies.Length) return;

        float carbonAfterFire = patchCarbonRaw * patch.percent / 100f;      // What the patch is worth once burnt
        float carbonNow = GetTreePotentialCarbonVisualized(speciesIdx);     // What the standing trees are worth

        int toKill = (int)Mathf.Round((carbonNow - carbonAfterFire) / treeAverageCarbonAmount);
        toKill = Mathf.Clamp(toKill, 0, GetAliveTrees(speciesIdx).Count);

        firsToKill += toKill;

        if (debugFire || debugTrees)
            Debug.Log($"[CCFIRE] {name} sp{speciesIdx}({patch.overstorySpecies}) " +
                      $"standing:{carbonNow:F3} afterFire:{carbonAfterFire:F3} toKill:{toKill}");
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

            // BigCreek's loop stops before index 0, so one tree always survives even a total burn.
            // Keep that quirk for BigCreek; CubeController_CCV3 overrides this to reach the whole list.
            int lastBurnableIdx = LastBurnableTreeIndex();

            for (int i = aliveTrees.Count - 1; i >= lastBurnableIdx; i--)      // Select firs to burn starting from last idx
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
    /// Lowest tree index the fire loop will ignite. BigCreek stops before index 0 so one tree always
    /// survives even a total burn; CubeController_CCV3 overrides this to 0 so a full burn clears the cube.
    /// </summary>
    protected virtual int LastBurnableTreeIndex()
    {
        return 1;
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

    // centralCoastV3 data-driven fire. If fire > 0, then burn.
        public bool ShouldBurnFireFromData(int timeIdx)
    {
        CubeData row = GetDataRow(timeIdx + 1);
        return row != null && row.fire > 0f;
    }

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

        float pos = MathUtil.MapValue(timeIdx - fireRegrowthStartTimeIdx, 0, fireRegrowthLength, 0f, 1f);

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

        ResetSnow();
    }

    public void ResetSnow()
    {
        snowValue = 0f;
        SnowAmount = 0f;

        if (snowManager != null)
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
        arr[6] = row.qout;
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

        //int s = (int)DataColumnIdx.StreamLevel;             // Stream Level Column    // qout
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
            float val = dataRows[i].qout;
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
                    if (val < TransOverMin)
                        TransOverMin = val;
                    if (val > TransOverMax)
                        TransOverMax = val;

                    val = dataRows[i].transUnder;
                    if (val < TransUnderMin)
                        TransUnderMin = val;
                    if (val > TransUnderMax)
                        TransUnderMax = val;

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
    // BigCreek: aggregate cubes use their own factor, everything else the shared factor.
    // CubeController_CCV3 overrides this to add the per-cube saturation override.
    public virtual float GetTreeCarbonFactor()
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
            try
            {
                ParticleSystem.EmissionModule em = shrub.pSystem.emission;
                etAmount += em.rateOverTime.constant;
            }
            catch (Exception ex)
            {
                Debug.Log(name+"... ERROR ex:"+ex.Message);
            }
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
    /// Gets the carbon represented by living trees of one species (Central Coast per-patch balance).
    /// </summary>
    public float GetTreeCarbonAmountVisualized(int speciesIdx)
    {
        float treeCarbonAmount = 0f;
        for (int x = 0; x < firs.Count; x++)
        {
            if (firs[x] != null && firs[x].speciesIdx == speciesIdx)
                treeCarbonAmount += firs[x].GetCarbonAmount();
        }
        return treeCarbonAmount;
    }

    /// <summary>
    /// Gets the carbon that living trees of one species will represent once fully grown. Planting
    /// decisions use this so saplings already count toward the target and the stand isn't overplanted.
    /// </summary>
    /// <returns>The carbon amount at maturity.</returns>
    public float GetTreePotentialCarbonVisualized(int speciesIdx)
    {
        float treeCarbonAmount = 0f;
        for (int x = 0; x < firs.Count; x++)
        {
            if (firs[x] != null && firs[x].speciesIdx == speciesIdx)
                treeCarbonAmount += firs[x].GetPotentialCarbonAmount();
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
      /// Gets the carbon amount represented by currently visualized grass patches.
      /// </summary>
      /// <returns>The grass carbon amount.</returns>
      public float GetGrassCarbonAmountVisualized()
      {
          float grassCarbonAmount = 0f;

          if (grasses == null)
              return 0f;

          foreach (GameObject grass in grasses)
          {
              if (grass == null) continue;

              LODGroup lod = grass.GetComponent<LODGroup>();
              if (lod == null) continue;

              LOD[] lods = lod.GetLODs();
              if (lods.Length == 0 || lods[0].renderers.Length == 0) continue;

              Renderer rend = lods[0].renderers[0];
              if (rend != null)
                  grassCarbonAmount += rend.bounds.size.y * GetShrubCarbonFactor();
          }

          return grassCarbonAmount;
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

        netTransSlider.value = MathUtil.MapValue(netTrans, netTransMin, netTransMax, netTransSlider.minValue, netTransSlider.maxValue);
        plantCarbonSlider.value = MathUtil.MapValue(stemCarbon + leafCarbon, stemCarbonMin + leafCarbonMin, stemCarbonMax + leafCarbonMax, plantCarbonSlider.minValue, plantCarbonSlider.maxValue);
        //snowAmountSlider.value = MathUtil.MapValue(SnowAmount, SnowAmountMin, SnowAmountMax, snowAmountSlider.minValue, snowAmountSlider.maxValue);
        //psnSlider.value = MathUtil.MapValue(NetPhotosynthesis, NetPhotosynthesisMin, NetPhotosynthesisMax, psnSlider.minValue, psnSlider.maxValue);
        //waterAccessSlider.value = MathUtil.MapValue(WaterAccess, soilController.WaterAccessMin, soilController.WaterAccessMax, waterAccessSlider.minValue, waterAccessSlider.maxValue);

        //Debug.Log(name + ".UpdateModelDisplay() dataType:"+ dataType+" netTrans:" + netTrans + " netTransMin:" + netTransMin + " netTransMax:" + netTransMax + " DataColumnIdx.TransOver:" + ReadData((int)DataColumnIdx.TransOver, timeIdx));
        //Debug.Log(name + ".UpdateModelDisplay() netTrans:" + netTrans + " plantCarbon:" + (stemCarbon + leafCarbon) + " plantCarbonMin:" + (leafCarbonMin+ stemCarbonMin)
        //    + " plantCarbonMax:" + (leafCarbonMax + stemCarbonMax) + " DataColumnIdx.LeafCarbonOver:" + ReadData((int)DataColumnIdx.LeafCarbonOver, timeIdx));

        float netTransInViz = GetNetTranspirationVisualized();
        float plantCarbonInViz = GetTreeCarbonAmountVisualized() + GetShrubCarbonAmountVisualized();
        //float snowAmountInViz = GetSnowAmountVisualized();
        //float netPhotosynthesisInViz = GetNetPsnAmountVisualized();
        //float waterAccessInViz = GetWaterAccessVisualized();

        netTransSliderDebug.value = MathUtil.MapValue(netTransInViz, netTransMin, netTransMax, netTransSlider.minValue, netTransSlider.maxValue);
        plantCarbonSliderDebug.value = MathUtil.MapValue(plantCarbonInViz, stemCarbonMin + leafCarbonMin, stemCarbonMax + leafCarbonMax, plantCarbonSlider.minValue, plantCarbonSlider.maxValue);

        //snowAmountSliderDebug.value = MathUtil.MapValue(snowAmountInViz, SnowAmountMin, SnowAmountMax, snowAmountSlider.minValue, snowAmountSlider.maxValue);
        //psnSliderDebug.value = MathUtil.MapValue(netPhotosynthesisInViz, NetPhotosynthesisMin, NetPhotosynthesisMax, psnSlider.minValue, psnSlider.maxValue);
        //waterAccessSliderDebug.value = MathUtil.MapValue(waterAccessInViz, soilController.WaterAccessMin, soilController.WaterAccessMax, waterAccessSlider.minValue, waterAccessSlider.maxValue);
        //dtgSlider.value = MathUtil.MapValue(DepthToGW, soilController.DepthToGWMin, soilController.DepthToGWMax, psnSlider.minValue, psnSlider.maxValue);
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
        public GameObject deadPrefab;               // Dead/snag model for this species. Leave empty to use the cube's shared deadTreePrefab.
        [Range(0f, 100f)] public float percentInPatch = 100f; //// Share of this patch's overstory stems (community mix). Split N_stems across species.
        [System.NonSerialized] public int runtimeSpeciesIdx = -1;   // flat treeList index assigned in PrepareVegetationList (per-patch, no name collision)
    }
    // [System.Serializable]
    // public class PatchDisplayInfo
    // {
    //     public string overstorySpecies = "Chaparral";   // "Oak" / "Chaparral" / "Grass"
    //     [Range(0f, 100f)] public float percent = 50f;    // Percent of patch area covered by this species
    // }
    [System.Serializable]
      public class PatchDisplayInfo
      {
          [Range(0f, 100f)] public float percent = 50f;   // Percent of the cube's area this patch covers
          public int nStems = 0;                          // Initial overstory individuals in this patch (cube_info N_stems)
          public List<Species> overstory;                 // Overstory species in this patch (each has its own prefabs + deadPrefab). Preferred.
          public bool understoryIsGrass = true;           // Understory layer is grass

          public string overstorySpecies = "Chaparral";   // "Oak" / "Chaparral" / "Grass" LEGACY single-species name. Used only while overstory is empty, so nothing breaks pre-migration.
      }
    public PatchDisplayInfo patch1;
    public PatchDisplayInfo patch2;
    private Dictionary<string, int> treeSpeciesIndexByName = new Dictionary<string, int>();
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
