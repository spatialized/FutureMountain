using UnityEngine;
using UnityEngine.Assertions;
using System;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using UnityEngine.UI;
using static CubeController;
using Assets.Scripts.Models;

/// <summary>
/// Game controller.
/// </summary>
public class GameController : MonoBehaviour
{
    /* Debugging */
    private bool debugGame = true;                  // Debug messages on / off
    private bool debugModel = false;                // Debug model (graph) display
    private bool debugFire = true;                  // Debug fire
    private bool debugWeb = true;

    private bool debugDetailed = true;              // Detailed debugging
    private bool debugMessages = false;             // Debug messages on / off

    private int lastDebugMessageFrame = -1;         // Last debug message printed frame (for delayed debug messages)
    private static string debugOutputPath = "/Users/davidgordon/Desktop/debug.txt";     // Debug output filepath
    private int debugMessageMinLength = 15;         // Debug message min. length in frames

    #region Fields
    /* Game Controller */
    private static GameController _instance;
    public static GameController Instance { get { return _instance; } }

    /* Data */
    private static bool fireCubes = true;           // Fire Cubes (default)     -- TO DO: Remove

    /* Game Settings */
    private SimulationSettings settings;            // Game / simulation settings

    /* Game Objects */
    [Header("Prefabs")]
    public GameObject etPrefab;                     // Tree Evapotrans. prefab 
    public GameObject shrubETPrefab;                // Shrub Evapotrans. prefab 
    public GameObject firePrefab;                   // Fire prefab object
    public GameObject animationCubePrefab;          // Cube prefab for animation

    /* Snow Settings */
    public float maxSnowAmount = 1.0f;              // Max. snow amount

    /* SERI Data */
    private Vector3[] fireDates;                    // List of fire dates
    private List<int> fireFrames;                   // List of time indices of fires (CAW Installation Data)
    private List<int> fireYears;                    // List of fire years
    private Vector3[] messageDates;                 // List of message dates
    private List<int> messageFrames;                // List of message indices of fires (CAW Installation Data)
    private List<int> messageYears;                 // List of message years

    private bool usePatchIDsForFire = false;        // Use cube patchIDs burned in landscape when determining to start fire    Note: OFF for unsynced simulation

    /* Game States */
    [Header("Game State")]
    private bool initialized = false;               // Simulation initialized state
    private bool started = false;                   // Simulation started state
    private bool starting = false;                  // Starting simulation

    [SerializeField]
    private bool paused = false;                    // User-driven Paused state

    [SerializeField]
    private bool pausedAuto = false;                // Fire-driven Paused state
    private bool hideUI = false;                    // UI hidden state
    private bool landscapeIsSetup = false;          // Landscape data prepared state
    private bool endSimulation = false;             // End simulation flag
    private bool exitGame = false;                  // Exit game flag
    private bool showResumeButton = false;          // Show resume button when paused 

    [Header("Messages")]
    public TextAsset messagesFile;                  // UI Messages text file
    public TextAsset fireMessagesFile;              // UI Messages text file

    /* Camera */
    [Header("Camera")]
    public Camera sceneCamera;                      // Main scene camera
    public CameraController cameraController;       // Main camera controller

    /* Sun */
    [Header("Environment")]
    public Light sunLight;                          // Directional light
    private int sunTransitionDirection = 1;         // 1: Summer to Winter   -1: Winter to Summer
    private int sunTransitionStart = -1;            // Start day of year of sun transition
    private int sunTransitionEnd = -1;              // Start day of year of sun transition
    private int sunTransitionLength;                // Sun transition length

    private float summerLightIntensity = 1.525f;    // Summer light intensity
    private float winterLightIntensity = 1.3f;      // Winter light intensity

    private float summerAltitudeAngle = 71.35f;     // Altitude angle of sun during summer      (Data from http://www.suncalc.org/)
    private float summerAzimuthAngle = 132.65f;     // Azimuth angle of sun during summer
    private float winterAltitudeAngle = 29.48f;     // Altitude angle of sun during winter
    private float winterAzimuthAngle = 181.19f;     // Azimuth angle of sun during winter

    public Horizon.HorizonMaster horizonMaster;      // Horizon Master object

    /* Snow */
    [Header("Snow")]
    public float terrainSnowAmountFactor = 1.0f;    // Terrain snow amount factor
    private GameObject snowManagerObject;           // Snow manager object
    private SnowManager snowManagerTerrain;         // Snow manager
    private float snowAmount = 0.0f;                // Current snow amount on large landscape

    /* Timing */
    private int timeIdx = 0;                                                 // Index of current day
    private int cubeStartYear = 0, cubeStartMonth = 1, cubeStartDay = 1;     // Start month and day in cubes data
    private int endTimeIdx;                                                  // End of simulation in days
    private int cubeEndYear = 0, cubeEndMonth = 1, cubeEndDay = 1;           // Start month and day in cubes data

    private int timeStep;                           // Simulation time step (days per frame)
    private float timeSpeed = 0.125f;               // How often to invoke rapid timed events

    private float lastSimulationUpdate = 0f;        // Last simulation time when daily update was called

    IEnumerator landscapeInitializer;               // Landscape initializer enumerator

    /* Data */
    [Header("Data")]
    public LandscapeData landscapeDataList;         // Data for landscape
    public CubeDataList aggregateCubeDataList;      // Data for aggregate cube
    public CubeDataList cubeDataList;               // Data for cubes
    //private string[] dataDates;                     // Dates (taken from Cube 1) -- OBSOLETE
    public List<DateModel> dataDates;               // List of dates in model data
    public Dictionary<Vector3, int> dateLookup;      // Date idx reference

    /* Simulation */
    public bool sideBySideMode = false;                      // Side-by-Side mode flag
    public int sbsIdx = -1;                            // Side-by-Side cube index

    private bool displaySeasons = true;                       // Display seasons flag
    private int simulationStartYear, simulationEndYear;       // Start + end year
    private int simulationStartMonth, simulationEndMonth;     // Start + end month
    private int simulationStartDay, simulationEndDay;         // Start + end day

    //private string curDate = "";                              // Current date as string 
    private DateModel curDate = new DateModel();              // Current date  
    private int warmingIdx = 0;                               // Current warming index (0-4)
    private int warmingDegrees = 0;                           // Current warming degrees (0, 1, 2, 4, 6)

    /* Objects */
    [Header("Objects")]
    public GameObject landscapeObject;                        // Large Landscape Object
    public GameObject aggregateCubeObject;                    // Aggregate Cube
    public GameObject aggregateCubeObject_Side;               // Aggregate Side Cube

    public GameObject cube1Object;                            // Cube 1 Object
    public GameObject cube1Object_Side;                       // Side Cube 1 Object
    public GameObject cube2Object;                            // Cube 2 Object 
    public GameObject cube2Object_Side;                       // Side Cube 2 Object 
    public GameObject cube3Object;                            // Cube 3 Object 
    public GameObject cube3Object_Side;                       // Side Cube 3 Object 
    public GameObject cube4Object;                            // Cube 4 Object 
    public GameObject cube4Object_Side;                       // Side Cube 4 Object 
    public GameObject cube5Object;                            // Cube 5 Object 
    public GameObject cube5Object_Side;                       // Side Cube 5 Object 

    public GameObject cube1Stats;                             // Side-by-Side Mode Cube #1 statistics
    public GameObject cube2Stats;                             // Side-by-Side Mode Cube #2 statistics
    public GameObject warmingLevelText;                       // Side-by-Side Mode Warming Level Text

    /* Controllers */
    public LandscapeController landscapeController;           // Large Landscape Controller
    private CubeController aggregateCubeController;           // Aggregate Cube Controller
    private CubeController aggregateSideCubeController;       // Aggregat Side Cube Controllr
    private CubeController[] cubes;                           // Cube Controllers
    private CubeController[] sideCubes;                       // Side-by-Side Cube Controllers

    /* Layers Settings */
    private bool displayET = true;                            // Display evap./trans. flag
    private bool displaySoils = true;                         // Display soils flag
    private bool displayStreams = true;                       // Display streams flag
    private bool displayCubes = true;                         // Display cubes flag

    /* UI */
    [Header("UI")]
    public Canvas setupUICanvas;                              // Setup UI canvas
    public Canvas simulationUICanvas;                         // Simulation UI canvas 
    public Canvas controlsUICanvas;                           // Show Controls Button UI canvas
    public Canvas sideBySideCanvas;                           // Side-by-Side Mode UI Canvas
    public GameObject introPanel;                              // Intro Text Panel
    public Canvas loadingCanvas;                           // Side-by-Side Mode UI Canvas
    public GameObject loadingTextObject;                       // Loading Text Object
    public Text loadingTextField;                              // Loading Text 

    private GameObject uiObject;                              // UI Object containing canvases
    private Vector3 uiObjectDefaultPosition;
    private bool uiObjectHidden = false;

    /* UI Timeline */
    public GameObject uiTimelineObject;                      // UI Timeline Object
    private TimelineControl uiTimeline;                       // UI Timeline

    /* UI Messages */
    public UI_MessageManager messageManager;                 // Message manager

    /* UI Buttons */
    private GameObject showControlsToggleObject;              // Toggle button for showing controls
    private GameObject showModelDataToggleObject;                 // Toggle button for model data display
    private GameObject storyModeToggleObject;                 // Story mode toggle button
    private GameObject sideBySideModeToggleObject;            // Side-by-Side Mode toggle button
    private GameObject exitSideBySideButtonObject;            // Exit Side-by-Side Mode button object
    private GameObject pauseButtonObject;                     // End button object
    private GameObject zoomOutButtonObject;                   // Zoom out button object
    private GameObject endButtonObject;                       // End button object

    private GameObject cubesToggleObject;                     // Toggle button for cubes visibility     // -- UNUSED
    private GameObject seasonsToggleObject;                   // Toggle button for seasons              // -- UNUSED
    private GameObject flyCameraButtonObject;                 // Fly camera toggle object               // -- UNUSED

    /* UI Sliders */
    private GameObject warmingKnobObject;                     // Large warming knob
    private WarmingKnobSlider warmingKnobSlider;              // Large warming knob slider object
    private GameObject warmingKnob1Object;                    // Side-by-Side warming knob 1
    private WarmingKnobSlider warmingKnob1Slider;              // Large warming knob slider object
    private GameObject warmingKnob2Object;                    // Side-by-Side warming knob 2
    private WarmingKnobSlider warmingKnob2Slider;              // Large warming knob slider object
    private GameObject timeKnobObject;                        // Time scale knob
    private TimeKnobSlider timeKnobSlider;                    // Time knob slider object

    /* UI Graphics */
    private GameObject blankScreenObject;                     // Blank screen UI object

    /* UI Text */
    private bool showControls = true;                         // Show controls setting
    private bool displayModel = false;                        // Display model data setting
    private bool storyMode = true;                            // Show "story" messages

    #endregion

    #region DataTypes
    /* UI Layers */
    private enum LayerType                                    // Simulation display layers 
    {
        Cube,
        Landscape,
        Soil,
        Streams,
        UI
    };
    #endregion

    #region Initialization
    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    /// <summary>
    /// Start this instance. 
    /// </summary>
    void Start()
    {
        started = false;
        paused = true;

        InitializeGame();
    }

    void test1(string jsonString)
    {
        Debug.Log("jsonString:" + jsonString);
    }

    /// <summary>
    /// Initializes main game objects.
    /// </summary>
    private void InitializeGame()
    {
        // Test Web API
        WebManager.Instance.RequestData(-1, 1, 1, 10, this.test1);

        /// END TESTING

        /* Set Main Game Objects */
        //mainGameObject = transform.parent.gameObject;
        Assert.IsNotNull(cameraController);

        Assert.IsNotNull(landscapeController);

        /* Initialize UI objects */
        Assert.IsNotNull(setupUICanvas);
        Assert.IsNotNull(simulationUICanvas);
        Assert.IsNotNull(introPanel);
        introPanel.SetActive(true);

        Assert.IsNotNull(controlsUICanvas);
        controlsUICanvas.enabled = false;

        Assert.IsNotNull(sideBySideCanvas);
        Assert.IsNotNull(loadingCanvas);

        loadingTextObject = loadingCanvas.transform.Find("LoadingPanel").transform.Find("LoadingText").gameObject;
        loadingTextField = loadingTextObject.GetComponent<Text>() as Text;
        loadingCanvas.enabled = false;
        loadingCanvas.gameObject.SetActive(false);
        loadingTextObject.gameObject.SetActive(false);

        uiObject = GameObject.FindWithTag("UI");
        Assert.IsNotNull(uiObject);
        uiObjectDefaultPosition = uiObject.transform.localPosition;
        uiObjectHidden = false;

        Assert.IsNotNull(uiTimelineObject);
        uiTimeline = uiTimelineObject.GetComponent<TimelineControl>() as TimelineControl;
        Assert.IsNotNull(uiTimeline);
        uiTimeline.Initialize(this);

        pauseButtonObject = GameObject.Find("PauseButton");
        zoomOutButtonObject = GameObject.Find("ZoomOutButton");
        exitSideBySideButtonObject = GameObject.Find("ExitSideBySideButton");
        zoomOutButtonObject.SetActive(false);

        endButtonObject = GameObject.Find("EndButton");
        showControlsToggleObject = GameObject.Find("ShowControlsToggle");
        showModelDataToggleObject = GameObject.Find("ShowModelDataToggle");
        storyModeToggleObject = GameObject.Find("StoryModeToggle");
        sideBySideModeToggleObject = GameObject.Find("SideBySideToggle");
        seasonsToggleObject = GameObject.Find("ShowSeasonsToggle");
        flyCameraButtonObject = GameObject.Find("FlyCameraToggle");
        cubesToggleObject = GameObject.Find("ShowCubesToggle");

        messageManager = new UI_MessageManager();      // Create MessageManager

        seasonsToggleObject.GetComponent<Toggle>().isOn = displaySeasons;
        showControlsToggleObject.GetComponent<Toggle>().isOn = showControls;
        showModelDataToggleObject.GetComponent<Toggle>().isOn = displayModel;
        storyModeToggleObject.GetComponent<Toggle>().isOn = storyMode;
        sideBySideModeToggleObject.GetComponent<Toggle>().isOn = sideBySideMode;

        flyCameraButtonObject.GetComponent<Toggle>().isOn = false;
        cubesToggleObject.GetComponent<Toggle>().isOn = true;

        Assert.IsNotNull(endButtonObject);
        Assert.IsNotNull(seasonsToggleObject);
        Assert.IsNotNull(showModelDataToggleObject);
        Assert.IsNotNull(showControlsToggleObject);
        Assert.IsNotNull(sideBySideModeToggleObject);
        Assert.IsNotNull(storyModeToggleObject);
        Assert.IsNotNull(flyCameraButtonObject);
        Assert.IsNotNull(zoomOutButtonObject);
        Assert.IsNotNull(pauseButtonObject);
        Assert.IsNotNull(exitSideBySideButtonObject);

        pauseButtonObject.SetActive(false);
        exitSideBySideButtonObject.SetActive(false);

        warmingKnobObject = GameObject.Find("WarmingKnob");
        warmingKnobSlider = warmingKnobObject.GetComponent<WarmingKnobSlider>() as WarmingKnobSlider;
        warmingKnobSlider.respondToUser = true;

        warmingKnob1Object = GameObject.Find("WarmingKnob1");
        warmingKnob1Slider = warmingKnob1Object.GetComponent<WarmingKnobSlider>() as WarmingKnobSlider;
        warmingKnob1Slider.respondToUser = true;
        warmingKnob1Object.SetActive(false);

        warmingKnob2Object = GameObject.Find("WarmingKnob2");
        warmingKnob2Slider = warmingKnob2Object.GetComponent<WarmingKnobSlider>() as WarmingKnobSlider;
        warmingKnob2Slider.respondToUser = true;
        warmingKnob2Object.SetActive(false);

        timeKnobObject = GameObject.Find("TimeKnob");
        timeKnobObject.SetActive(true);
        timeKnobSlider = timeKnobObject.GetComponent<TimeKnobSlider>() as TimeKnobSlider;

        blankScreenObject = GameObject.Find("BlankScreen");     // -- OBSOLETE
        Assert.IsNotNull(blankScreenObject);
        //Assert.IsNotNull(largeTerrainMaterial);

        /* Load Settings */
        settings = GameObject.Find("Settings").GetComponent<SimulationSettings>() as SimulationSettings;
        Assert.IsNotNull(settings);

        debugGame = settings.DebugGame;
        debugFire = settings.DebugFire;
        debugModel = settings.DebugModel;
        debugDetailed = settings.DebugDetailed;

        /* Initialize Snow Managers */
        snowManagerObject = GameObject.Find("SnowManager_Landscape");
        snowManagerTerrain = snowManagerObject.GetComponent<SnowManager>() as SnowManager;
        Assert.IsNotNull(snowManagerObject);
        Assert.IsNotNull(snowManagerTerrain);
        Assert.IsNotNull(horizonMaster);

        //SetSnowAmount(0.0f);

        /* Initialize Cube Objects */
        Assert.IsNotNull(cube1Object);
        Assert.IsNotNull(cube2Object);
        Assert.IsNotNull(cube3Object);
        Assert.IsNotNull(cube4Object);
        Assert.IsNotNull(cube5Object);
        Assert.IsNotNull(cube1Object_Side);
        Assert.IsNotNull(cube2Object_Side);
        Assert.IsNotNull(cube3Object_Side);
        Assert.IsNotNull(cube4Object_Side);
        Assert.IsNotNull(cube5Object_Side);
        Assert.IsNotNull(aggregateCubeObject);
        Assert.IsNotNull(aggregateCubeObject_Side);

        Assert.IsNotNull(cube1Stats);
        Assert.IsNotNull(cube2Stats);
        cube1Stats.SetActive(false);
        cube2Stats.SetActive(false);

        Assert.IsNotNull(warmingLevelText);

        warmingLevelText.SetActive(false);

        cubes = new CubeController[5];
        sideCubes = new CubeController[5];
        cubes[0] = cube1Object.GetComponent<CubeController>() as CubeController;
        cubes[1] = cube2Object.GetComponent<CubeController>() as CubeController;
        cubes[2] = cube3Object.GetComponent<CubeController>() as CubeController;
        cubes[3] = cube4Object.GetComponent<CubeController>() as CubeController;
        cubes[4] = cube5Object.GetComponent<CubeController>() as CubeController;
        sideCubes[0] = cube1Object_Side.GetComponent<CubeController>() as CubeController;
        sideCubes[1] = cube2Object_Side.GetComponent<CubeController>() as CubeController;
        sideCubes[2] = cube3Object_Side.GetComponent<CubeController>() as CubeController;
        sideCubes[3] = cube4Object_Side.GetComponent<CubeController>() as CubeController;
        sideCubes[4] = cube5Object_Side.GetComponent<CubeController>() as CubeController;
        aggregateCubeController = aggregateCubeObject.GetComponent<CubeController>() as CubeController;
        aggregateSideCubeController = aggregateCubeObject_Side.GetComponent<CubeController>() as CubeController;

        /* Initialize Side-by-Side Cubes */
        for (int i = 0; i < cubes.Length; i++)
        {
            CubeController cube = cubes[i];
            CubeController sideCube = sideCubes[i];

            Assert.IsNotNull(cube);
            Assert.IsNotNull(sideCube);

            cube.simulationOn = true;

            cube.SetupObjects();
            sideCube.SetupObjects();

            Vector3 newPos = sideCube.transform.position;   // Offset side cube from original
            newPos.x -= settings.SideBySideModeXOffset;
            sideCube.transform.position = newPos;

            sideCube.gameObject.SetActive(false);
        }

        if (debugMessages)
            HandleTextFile.ClearFile();

        Assert.IsNotNull(aggregateCubeController);
        aggregateCubeController.SetupObjects();
        aggregateCubeController.simulationOn = true;

        Assert.IsNotNull(aggregateSideCubeController);
        aggregateSideCubeController.SetupObjects();
        aggregateSideCubeController.gameObject.SetActive(false);

        HideCubes(true, -1);
        HideSideCubes();
        SetPaused(true);

        PauseButton.pauseEvent += SetPaused;

        StartInitializingLandscape();
    }

    /// <summary>
    /// Setups the landscape.
    /// </summary>
    private void StartInitializingLandscape()
    {
        if (!landscapeIsSetup)
            SetupLandscape();

        if (landscapeController.LandscapeSimulationIsOn())
        {
            landscapeInitializer = landscapeController.InitializeData(settings);    // Begin initializing landscape if landscapeSimulationOn
            StartCoroutine(landscapeInitializer);
        }
        else
        {
            landscapeController.InitSplatmaps();
            landscapeController.ResetTerrainSplatmap();                // Assign default splatmap
            initialized = true;
        }
    }

    /// <summary>
    /// Prepares the extents data to be loaded and formatted.
    /// </summary>
    public void SetupLandscape()
    {
        landscapeController.SetupController(landscapeDataList, !settings.CubeDataOnly);
        landscapeIsSetup = true;
    }

    /// <summary>
    /// Starts Next Simulation Run
    /// </summary>
    public void StartSimulationRun()
    {
        starting = true;
        StartCoroutine(RunStartSimulation());
    }

    /// <summary>
    /// Starts the simulation.
    /// </summary>
    private IEnumerator RunStartSimulation()
    {
        if (!started)
        {
            if (landscapeController.LandscapeSimulationIsOn())
            {
                if (!landscapeController.PatchDataExists())
                {
                    landscapeController.initialized = false;
                    initialized = false;

                    Debug.Log("StartSimulationRun()... ERROR landscapeController.patchesData == null!... Quitting...");
                    Debug.Log("  StartSimulationRun()... extentsData == null?" + (landscapeController.GetExtentsData() == null));
                    Debug.Log("  StartSimulationRun()... landscapeData == null?" + (landscapeController.GetCurrentSimulationData() == null));

                    exitGame = true;

                    yield break;
                }
            }

            yield return null;

            int initTimeStep = (int)timeKnobSlider.timeScale;
            UpdateTimeStep(initTimeStep, true);              // Update time step and speed slider

            if (debugGame)
                Debug.Log(name + ".StartSimulationRun()...");
            if (debugMessages)
                DebugMessage(name + ".StartSimulationRun()...", true);

            SetPaused(false);
            pauseButtonObject.SetActive(true);

            sceneCamera.enabled = true;
            sunLight.enabled = true;

            controlsUICanvas.enabled = false;
            setupUICanvas.enabled = false;
            simulationUICanvas.enabled = false;
            sideBySideCanvas.enabled = false;
            loadingCanvas.enabled = true;
            loadingCanvas.gameObject.SetActive(true);
            loadingTextObject.gameObject.SetActive(true);

            introPanel.SetActive(false);

            int idx = fireCubes ? 5 : 0;
            //int warmingRange = cubeDataList.data[idx].list.Count;           // Find warming range

            warmingIdx = warmingKnobSlider.GetWarmingIndex();               // Get current warming index from knob
            warmingDegrees = warmingKnobSlider.GetWarmingDegrees();         // Get current warming degrees from knob

            warmingKnobSlider.respondToUser = false;

            yield return null;

            //int offset = fireCubes ? 5 : 0;                                  // Use fire or non-fire data
            //idx = offset;

            //if (settings.BuildForWeb)
            //{

            //}


            if (settings.BuildForWeb)
            {
                WebManager.Instance.GetDataDates(this.SetDataDatesAndFinishStarting);
            }
            else
            {
                StartCoroutine(FinishStarting());
            }

            //endTimeIdx = GetLastTimeIdx();
            //if (cube1Object != null)
            //{
            //    cubes[0].SetWarmingRange(warmingRange);
            //    cubes[0].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        cubes[0].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            cubes[0].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    cubes[0].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    cubes[0].SetWarmingIdx(warmingIdx);
            //    cubes[0].SetWarmingDegrees(warmingDegrees);

            //    if (!settings.BuildForWeb)
            //        cubes[0].FindParameterRanges();

            //    cubes[0].SetModelDebugMode(debugModel);

            //    //else
            //    //{
            //        //SetDataDatesFromFile(); // -- TO DO
            //        //dataDates = cubes[0].GetDataDates();                 // Dates by time index
            //    //}

            //    //Debug.Log("Set dataDates... length: " + dataDates.Length);
            //    //string[] firstDateFields = dataDates[0].Split('-');  // Save data file headings
            //    cubeStartYear = dataDates[0].year;
            //    cubeStartMonth = dataDates[0].month;
            //    cubeStartDay = dataDates[0].day;

            //    //string[] lastDateFields = dataDates[dataDates.Length - 2].Split('-');
            //    cubeEndYear = dataDates[dataDates.Count - 2].year;
            //    cubeEndMonth = dataDates[dataDates.Count - 2].month;
            //    cubeEndDay = dataDates[dataDates.Count - 2].day;

            //    // Setup side-by-side comparison cube
            //    sideCubes[0].SetWarmingRange(warmingRange);
            //    sideCubes[0].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        sideCubes[0].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[0].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    sideCubes[0].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    sideCubes[0].SetWarmingIdx(warmingIdx);
            //    sideCubes[0].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        sideCubes[0].FindParameterRanges();
            //    sideCubes[0].SetModelDebugMode(debugModel);

            //    sideCubes[0].gameObject.SetActive(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Cube1!");
            //}

            //yield return null;

            //idx = 1 + offset;
            //if (cube2Object != null)
            //{
            //    cubes[1].SetWarmingRange(warmingRange);
            //    cubes[1].InitializeData(cubeDataList.data[idx].list[0]);

            //    int count = 0;
            //    foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //    {
            //        cubes[1].ProcessDataTextAsset(cubeDataText, count);
            //        count++;
            //    }
            //    cubes[1].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    cubes[1].SetWarmingIdx(warmingIdx);
            //    cubes[1].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        cubes[1].FindParameterRanges();
            //    cubes[1].SetModelDebugMode(debugModel);

            //    // Setup side-by-side comparison cube
            //    sideCubes[1].SetWarmingRange(warmingRange);
            //    sideCubes[1].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        //sideCubes[1].UpdateDataFromWeb(timeIdx);
            //    }
            //    else
            //    {
            //        count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[1].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    sideCubes[1].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    sideCubes[1].SetWarmingIdx(warmingIdx);
            //    sideCubes[1].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        sideCubes[1].FindParameterRanges();
            //    sideCubes[1].SetModelDebugMode(debugModel);

            //    sideCubes[1].gameObject.SetActive(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Cube2!");
            //}

            //yield return null;

            //idx = 2 + offset;
            //if (cube3Object != null)
            //{
            //    cubes[2].SetWarmingRange(warmingRange);
            //    cubes[2].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        cubes[2].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            cubes[2].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }
            //    cubes[2].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    cubes[2].SetWarmingIdx(warmingIdx);
            //    cubes[2].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        cubes[2].FindParameterRanges();
            //    cubes[2].SetModelDebugMode(debugModel);

            //    // Setup side-by-side comparison cube
            //    sideCubes[2].SetWarmingRange(warmingRange);
            //    sideCubes[2].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        //sideCubes[2].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[2].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    sideCubes[2].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    sideCubes[2].SetWarmingIdx(warmingIdx);
            //    sideCubes[2].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        sideCubes[2].FindParameterRanges();
            //    sideCubes[2].SetModelDebugMode(debugModel);

            //    sideCubes[2].gameObject.SetActive(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Cube3!");
            //}

            //yield return null;

            //idx = 3 + offset;
            //if (cube4Object != null)
            //{
            //    cubes[3].SetWarmingRange(warmingRange);
            //    cubes[3].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        cubes[3].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            cubes[3].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }
            //    cubes[3].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    cubes[3].SetWarmingIdx(warmingIdx);
            //    cubes[3].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        cubes[3].FindParameterRanges();
            //    cubes[3].SetModelDebugMode(debugModel);

            //    // Setup side-by-side comparison cube
            //    sideCubes[3].SetWarmingRange(warmingRange);
            //    sideCubes[3].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        //sideCubes[3].UpdateDataFromWeb(timeIdx);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[3].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    sideCubes[3].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    sideCubes[3].SetWarmingIdx(warmingIdx);
            //    sideCubes[3].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        sideCubes[3].FindParameterRanges();
            //    sideCubes[3].SetModelDebugMode(debugModel);

            //    sideCubes[3].gameObject.SetActive(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Cube4!");
            //}

            //yield return null;

            //idx = 4 + offset;
            //if (cube5Object != null)
            //{
            //    cubes[4].SetWarmingRange(warmingRange);
            //    cubes[4].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        cubes[4].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[4].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }
            //    cubes[4].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    cubes[4].SetWarmingIdx(warmingIdx);
            //    cubes[4].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        cubes[4].FindParameterRanges();
            //    cubes[4].SetModelDebugMode(debugModel);

            //    // Setup side-by-side comparison cube
            //    sideCubes[4].SetWarmingRange(warmingRange);
            //    sideCubes[4].InitializeData(cubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        //sideCubes[4].UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int count = 0;
            //        foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
            //        {
            //            sideCubes[4].ProcessDataTextAsset(cubeDataText, count);
            //            count++;
            //        }
            //    }

            //    sideCubes[4].Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    sideCubes[4].SetWarmingIdx(warmingIdx);
            //    sideCubes[4].SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        sideCubes[4].FindParameterRanges();
            //    sideCubes[4].SetModelDebugMode(debugModel);

            //    sideCubes[4].gameObject.SetActive(false);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Cube5!");
            //}

            //yield return null;

            //offset = fireCubes ? 1 : 0;
            //idx = offset;
            //if (aggregateCubeObject != null)
            //{
            //    aggregateCubeController.SetWarmingRange(warmingRange);
            //    aggregateCubeController.InitializeData(aggregateCubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        aggregateCubeController.UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int counter = 0;
            //        foreach (TextAsset cubeDataText in aggregateCubeDataList.data[idx].list)
            //        {
            //            aggregateCubeController.ProcessDataTextAsset(cubeDataText, counter);
            //            counter++;
            //        }
            //    }

            //    aggregateCubeController.Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    aggregateCubeController.SetWarmingIdx(warmingIdx);
            //    aggregateCubeController.SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        aggregateCubeController.FindParameterRanges();
            //    aggregateCubeController.SetModelDebugMode(debugModel);

            //    aggregateSideCubeController.SetWarmingRange(warmingRange);
            //    aggregateSideCubeController.InitializeData(aggregateCubeDataList.data[idx].list[0]);

            //    if (settings.BuildForWeb)
            //    {
            //        aggregateSideCubeController.UpdateDataFromWeb(timeIdx, true);
            //    }
            //    else
            //    {
            //        int counter = 0;
            //        foreach (TextAsset cubeDataText in aggregateCubeDataList.data[idx].list)
            //        {
            //            aggregateSideCubeController.ProcessDataTextAsset(cubeDataText, counter);
            //            counter++;
            //        }
            //    }

            //    aggregateSideCubeController.Initialize(etPrefab, shrubETPrefab, firePrefab);
            //    aggregateSideCubeController.SetWarmingIdx(warmingIdx);
            //    aggregateSideCubeController.SetWarmingDegrees(warmingDegrees);
            //    if (!settings.BuildForWeb)
            //        aggregateSideCubeController.FindParameterRanges();
            //    aggregateSideCubeController.SetModelDebugMode(debugModel);
            //}
            //else
            //{
            //    Debug.Log(name + ".StartSimulationRun()... No Aggregate Cube!");
            //}

            //yield return null;

            ///* Initialize UI Messages */
            //List<UI_Message> messages = LoadMessagesFile(messagesFile, false);                 // Load messages
            //List<UI_Message> fireMessages = LoadMessagesFile(fireMessagesFile, true);          // Load fire messages 
            //List<UI_Message> currentMessages = new List<UI_Message>();                         // List of messages currently displayed

            //GameObject[] cubeLabels = new GameObject[6];
            //cubeLabels[0] = aggregateCubeController.cubeLabel;
            //for (int i = 0; i < 5; i++)
            //    cubeLabels[i + 1] = cubes[i].cubeLabel;

            //messageManager.Initialize(messages, fireMessages, cubeLabels);                      // Create MessageManager
            //messageManager.ClearMessages();
            //messageManager.messagePanel.SetActive(true);

            //Debug.Log(name + ".StartSimulationRun()... Initialized messageManager...");

            //yield return null;

            //if (landscapeController.updateDate)
            //{
            //    int startIdx = 0;
            //    startIdx = GetTimeIdxForDay(landscapeController.simulationStartDay, landscapeController.simulationStartMonth, landscapeController.simulationStartYear);

            //    Debug.Log("Setting start time index from streamflow file: startIdx:" + startIdx + " landscapeController.startYear:" + landscapeController.simulationStartYear + " month:" + landscapeController.simulationStartMonth);
            //    if (debugMessages)
            //        DebugMessage("Setting start time index from streamflow file: startIdx:" + startIdx + " landscapeController.startYear:" + landscapeController.simulationStartYear + " month:" + landscapeController.simulationStartMonth, true);

            //    simulationStartYear = landscapeController.simulationStartYear;
            //    simulationEndYear = GetLastDateYear();

            //    simulationStartMonth = landscapeController.simulationStartMonth;
            //    simulationStartDay = landscapeController.simulationStartDay;

            //    timeIdx = startIdx;                                             // Set timeIdx to beginning frame of streamflow data 
            //}
            //else
            //{
            //    simulationStartYear = cubeStartYear;
            //    simulationStartMonth = cubeStartMonth;
            //    simulationStartDay = cubeStartDay;

            //    simulationEndYear = cubeEndYear;
            //    simulationEndMonth = cubeEndMonth;
            //    simulationEndDay = cubeEndDay;

            //    timeIdx = 0;                                                    // Set timeIdx to beginning frame of extents data 
            //}

            //Debug.Log(name + ".StartSimulationRun()... Initialized simulation dates...");

            //yield return null;

            ///* Set Fire Dates for CAW Installation */
            //fireDates = new Vector3[2];
            //fireDates[0] = new Vector3(7, 15, 1969);
            //fireDates[1] = new Vector3(11, 20, 1988);

            //fireFrames = new List<int>();
            //fireYears = new List<int>();

            //int ct = 0;
            //foreach (Vector3 date in fireDates)
            //{
            //    fireFrames.Add(GetTimeIdxForDay((int)date.y, (int)date.x, (int)date.z));
            //    fireYears.Add((int)date.z);
            //    ct++;
            //}

            //yield return null;

            //Assert.IsNotNull(landscapeDataList);
            //landscapeController.SetupFires(fireDates, warmingIdx);

            //yield return null;

            //ShowCubes(false);

            //landscapeController.SetSnowVisibility(landscapeController.LandscapeSimulationIsOn());
            //landscapeController.ResetBackgroundSnow();

            ///* Set Message Dates for CAW Installation */

            //yield return null;

            //messageDates = new Vector3[messages.Count];
            //for (int i = 0; i < messages.Count; i++)
            //{
            //    UI_Message message = messages[i];
            //    if (message.AppliesToWarmingDegrees(warmingDegrees))
            //        messageDates[i] = message.GetDate();

            //    //Debug.Log("Added message #"+i+" at:" + message.GetDate()+ " :" + message.GetMessage());
            //}

            //messageYears = new List<int>();

            //foreach (Vector3 date in messageDates)
            //{
            //    //messageFrames.Add(GetTimeIdxForDay((int)date.y, (int)date.x, (int)date.z));
            //    messageYears.Add((int)date.z);
            //    ct++;
            //}

            //yield return null;

            ///* Create Timeline */
            //if (landscapeController.LandscapeSimulationIsOn())
            //    uiTimeline.CreateTimeline(landscapeController.GetWaterData(), warmingIdx, warmingDegrees, fireYears, messageYears);
            //else
            //    uiTimeline.CreateTestTimeline(simulationStartYear, simulationEndYear, warmingIdx, warmingDegrees, fireYears, messageYears);

            //if (debugGame)
            //    Debug.Log(name + ".StartSimulationRun()... Created timeline... ");

            //yield return null;

            ///* Set Initial Sun Position */
            //InitSunTransition();

            ///* Show / Hide Data Display */
            //if (displayModel)
            //    ShowStatistics();
            //else
            //    HideStatistics();

            //starting = false;
        }
        else
        {
            if (debugGame)
                Debug.Log("Called StartSimulationRun() while already running!");
        }
    }

    public IEnumerator FinishStarting()
    {
        Debug.Log(name+".FinishStarting()...");

        int offset = fireCubes ? 5 : 0;                                  // Use fire or non-fire data
        int idx = offset;
        int warmingRange = cubeDataList.data[idx].list.Count;           // Find warming range

        endTimeIdx = GetLastTimeIdx();

        Debug.Log("FinishStarting()... endTimeIdx: "+ endTimeIdx);

        if (cube1Object != null)
        {
            cubes[0].SetWarmingRange(warmingRange);
            cubes[0].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                cubes[0].UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    cubes[0].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            cubes[0].Initialize(etPrefab, shrubETPrefab, firePrefab);
            cubes[0].SetWarmingIdx(warmingIdx);
            cubes[0].SetWarmingDegrees(warmingDegrees);

            if (!settings.BuildForWeb)
                cubes[0].FindParameterRanges();

            cubes[0].SetModelDebugMode(debugModel);

            //else
            //{
            //SetDataDatesFromFile(); // -- TO DO
            //dataDates = cubes[0].GetDataDates();                 // Dates by time index
            //}

            //Debug.Log("Set dataDates... length: " + dataDates.Length);
            //string[] firstDateFields = dataDates[0].Split('-');  // Save data file headings
            cubeStartYear = dataDates[0].year;
            cubeStartMonth = dataDates[0].month;
            cubeStartDay = dataDates[0].day;

            //string[] lastDateFields = dataDates[dataDates.Length - 2].Split('-');
            cubeEndYear = dataDates[dataDates.Count - 2].year;
            cubeEndMonth = dataDates[dataDates.Count - 2].month;
            cubeEndDay = dataDates[dataDates.Count - 2].day;

            // Setup side-by-side comparison cube
            sideCubes[0].SetWarmingRange(warmingRange);
            sideCubes[0].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                sideCubes[0].UpdateDataFromWeb(timeIdx, true, true); ;
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[0].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            sideCubes[0].Initialize(etPrefab, shrubETPrefab, firePrefab);
            sideCubes[0].SetWarmingIdx(warmingIdx);
            sideCubes[0].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                sideCubes[0].FindParameterRanges();
            sideCubes[0].SetModelDebugMode(debugModel);

            sideCubes[0].gameObject.SetActive(false);
        }
        else
        {
            Debug.Log(name + ".FinishStarting()... No Cube1!");
        }

        yield return null;

        idx = 1 + offset;
        if (cube2Object != null)
        {
            cubes[1].SetWarmingRange(warmingRange);
            cubes[1].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                cubes[1].UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    cubes[1].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            cubes[1].Initialize(etPrefab, shrubETPrefab, firePrefab);
            cubes[1].SetWarmingIdx(warmingIdx);
            cubes[1].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                cubes[1].FindParameterRanges();
            cubes[1].SetModelDebugMode(debugModel);

            // Setup side-by-side comparison cube
            sideCubes[1].SetWarmingRange(warmingRange);
            sideCubes[1].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                //sideCubes[1].UpdateDataFromWeb(timeIdx);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[1].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            sideCubes[1].Initialize(etPrefab, shrubETPrefab, firePrefab);
            sideCubes[1].SetWarmingIdx(warmingIdx);
            sideCubes[1].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                sideCubes[1].FindParameterRanges();
            sideCubes[1].SetModelDebugMode(debugModel);

            sideCubes[1].gameObject.SetActive(false);
        }
        else
        {
            Debug.Log(name + ".FinishStarting()... No Cube2!");
        }

        yield return null;

        idx = 2 + offset;
        if (cube3Object != null)
        {
            cubes[2].SetWarmingRange(warmingRange);
            cubes[2].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                cubes[2].UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    cubes[2].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }
            cubes[2].Initialize(etPrefab, shrubETPrefab, firePrefab);
            cubes[2].SetWarmingIdx(warmingIdx);
            cubes[2].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                cubes[2].FindParameterRanges();
            cubes[2].SetModelDebugMode(debugModel);

            // Setup side-by-side comparison cube
            sideCubes[2].SetWarmingRange(warmingRange);
            sideCubes[2].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                //sideCubes[2].UpdateDataFromWeb(timeIdx, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[2].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            sideCubes[2].Initialize(etPrefab, shrubETPrefab, firePrefab);
            sideCubes[2].SetWarmingIdx(warmingIdx);
            sideCubes[2].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                sideCubes[2].FindParameterRanges();
            sideCubes[2].SetModelDebugMode(debugModel);

            sideCubes[2].gameObject.SetActive(false);
        }
        else
        {
            Debug.Log(name + ".FinishStarting()... No Cube3!");
        }

        yield return null;

        idx = 3 + offset;
        if (cube4Object != null)
        {
            cubes[3].SetWarmingRange(warmingRange);
            cubes[3].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                cubes[3].UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    cubes[3].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }
            cubes[3].Initialize(etPrefab, shrubETPrefab, firePrefab);
            cubes[3].SetWarmingIdx(warmingIdx);
            cubes[3].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                cubes[3].FindParameterRanges();
            cubes[3].SetModelDebugMode(debugModel);

            // Setup side-by-side comparison cube
            sideCubes[3].SetWarmingRange(warmingRange);
            sideCubes[3].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                //sideCubes[3].UpdateDataFromWeb(timeIdx);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[3].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            sideCubes[3].Initialize(etPrefab, shrubETPrefab, firePrefab);
            sideCubes[3].SetWarmingIdx(warmingIdx);
            sideCubes[3].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                sideCubes[3].FindParameterRanges();
            sideCubes[3].SetModelDebugMode(debugModel);

            sideCubes[3].gameObject.SetActive(false);
        }
        else
        {
            Debug.Log(name + ".FinishStarting()... No Cube4!");
        }

        yield return null;

        idx = 4 + offset;
        if (cube5Object != null)
        {
            cubes[4].SetWarmingRange(warmingRange);
            cubes[4].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                cubes[4].UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[4].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }
            cubes[4].Initialize(etPrefab, shrubETPrefab, firePrefab);
            cubes[4].SetWarmingIdx(warmingIdx);
            cubes[4].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                cubes[4].FindParameterRanges();
            cubes[4].SetModelDebugMode(debugModel);

            // Setup side-by-side comparison cube
            sideCubes[4].SetWarmingRange(warmingRange);
            sideCubes[4].InitializeData(cubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                //sideCubes[4].UpdateDataFromWeb(timeIdx, true);
            }
            else
            {
                int count = 0;
                foreach (TextAsset cubeDataText in cubeDataList.data[idx].list)
                {
                    sideCubes[4].ProcessDataTextAsset(cubeDataText, count);
                    count++;
                }
            }

            sideCubes[4].Initialize(etPrefab, shrubETPrefab, firePrefab);
            sideCubes[4].SetWarmingIdx(warmingIdx);
            sideCubes[4].SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                sideCubes[4].FindParameterRanges();
            sideCubes[4].SetModelDebugMode(debugModel);

            sideCubes[4].gameObject.SetActive(false);
        }
        else
        {
            Debug.Log(name + ".FinishStarting()... No Cube5!");
        }

        yield return null;

        offset = fireCubes ? 1 : 0;
        idx = offset;
        if (aggregateCubeObject != null)
        {
            aggregateCubeController.SetWarmingRange(warmingRange);
            aggregateCubeController.InitializeData(aggregateCubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                aggregateCubeController.UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int counter = 0;
                foreach (TextAsset cubeDataText in aggregateCubeDataList.data[idx].list)
                {
                    aggregateCubeController.ProcessDataTextAsset(cubeDataText, counter);
                    counter++;
                }
            }

            aggregateCubeController.Initialize(etPrefab, shrubETPrefab, firePrefab);
            aggregateCubeController.SetWarmingIdx(warmingIdx);
            aggregateCubeController.SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                aggregateCubeController.FindParameterRanges();
            aggregateCubeController.SetModelDebugMode(debugModel);

            aggregateSideCubeController.SetWarmingRange(warmingRange);
            aggregateSideCubeController.InitializeData(aggregateCubeDataList.data[idx].list[0]);

            if (settings.BuildForWeb)
            {
                aggregateSideCubeController.UpdateDataFromWeb(timeIdx, true, true);
            }
            else
            {
                int counter = 0;
                foreach (TextAsset cubeDataText in aggregateCubeDataList.data[idx].list)
                {
                    aggregateSideCubeController.ProcessDataTextAsset(cubeDataText, counter);
                    counter++;
                }
            }

            aggregateSideCubeController.Initialize(etPrefab, shrubETPrefab, firePrefab);
            aggregateSideCubeController.SetWarmingIdx(warmingIdx);
            aggregateSideCubeController.SetWarmingDegrees(warmingDegrees);
            if (!settings.BuildForWeb)
                aggregateSideCubeController.FindParameterRanges();
            aggregateSideCubeController.SetModelDebugMode(debugModel);
        }
        else
        {
            Debug.Log(name + ".StartSimulationRun()... No Aggregate Cube!");
        }

        yield return null;

        /* Initialize UI Messages */
        List<UI_Message> messages = LoadMessagesFile(messagesFile, false);                 // Load messages
        List<UI_Message> fireMessages = LoadMessagesFile(fireMessagesFile, true);          // Load fire messages 
        List<UI_Message> currentMessages = new List<UI_Message>();                         // List of messages currently displayed

        GameObject[] cubeLabels = new GameObject[6];
        cubeLabels[0] = aggregateCubeController.cubeLabel;
        for (int i = 0; i < 5; i++)
            cubeLabels[i + 1] = cubes[i].cubeLabel;

        messageManager.Initialize(messages, fireMessages, cubeLabels);                      // Create MessageManager
        messageManager.ClearMessages();
        messageManager.messagePanel.SetActive(true);

        Debug.Log(name + ".FinishStarting()... Initialized messageManager...");

        yield return null;

        if (landscapeController.updateDate)
        {
            int startIdx = 0;
            startIdx = GetTimeIdxForDay(landscapeController.simulationStartDay, landscapeController.simulationStartMonth, landscapeController.simulationStartYear);

            Debug.Log("Setting start time index from streamflow file: startIdx:" + startIdx + " landscapeController.startYear:" + landscapeController.simulationStartYear + " month:" + landscapeController.simulationStartMonth);
            if (debugMessages)
                DebugMessage("Setting start time index from streamflow file: startIdx:" + startIdx + " landscapeController.startYear:" + landscapeController.simulationStartYear + " month:" + landscapeController.simulationStartMonth, true);

            simulationStartYear = landscapeController.simulationStartYear;
            simulationEndYear = GetLastDateYear();

            simulationStartMonth = landscapeController.simulationStartMonth;
            simulationStartDay = landscapeController.simulationStartDay;

            timeIdx = startIdx;                                             // Set timeIdx to beginning frame of streamflow data 
        }
        else
        {
            simulationStartYear = cubeStartYear;
            simulationStartMonth = cubeStartMonth;
            simulationStartDay = cubeStartDay;

            simulationEndYear = cubeEndYear;
            simulationEndMonth = cubeEndMonth;
            simulationEndDay = cubeEndDay;

            timeIdx = 0;                                                    // Set timeIdx to beginning frame of extents data 
        }

        Debug.Log(name + ".FinishStarting()... Initialized simulation dates...");

        yield return null;

        /* Set Fire Dates for CAW Installation */
        fireDates = new Vector3[2];
        fireDates[0] = new Vector3(7, 15, 1969);
        fireDates[1] = new Vector3(11, 20, 1988);

        fireFrames = new List<int>();
        fireYears = new List<int>();

        int ct = 0;
        foreach (Vector3 date in fireDates)
        {
            fireFrames.Add(GetTimeIdxForDay((int)date.y, (int)date.x, (int)date.z));
            fireYears.Add((int)date.z);
            ct++;
        }

        yield return null;

        Assert.IsNotNull(landscapeDataList);
        landscapeController.SetupFires(fireDates, warmingIdx);

        yield return null;

        ShowCubes(false);

        landscapeController.SetSnowVisibility(landscapeController.LandscapeSimulationIsOn());
        landscapeController.ResetBackgroundSnow();

        /* Set Message Dates for CAW Installation */

        yield return null;

        messageDates = new Vector3[messages.Count];
        for (int i = 0; i < messages.Count; i++)
        {
            UI_Message message = messages[i];
            if (message.AppliesToWarmingDegrees(warmingDegrees))
                messageDates[i] = message.GetDate();

            //Debug.Log("Added message #"+i+" at:" + message.GetDate()+ " :" + message.GetMessage());
        }

        messageYears = new List<int>();

        foreach (Vector3 date in messageDates)
        {
            //messageFrames.Add(GetTimeIdxForDay((int)date.y, (int)date.x, (int)date.z));
            messageYears.Add((int)date.z);
            ct++;
        }

        yield return null;

        /* Create Timeline */
        if (landscapeController.LandscapeSimulationIsOn())
            uiTimeline.CreateTimeline(landscapeController.GetWaterData(), warmingIdx, warmingDegrees, fireYears, messageYears);
        else
            uiTimeline.CreateTestTimeline(simulationStartYear, simulationEndYear, warmingIdx, warmingDegrees, fireYears, messageYears);

        if (debugGame)
            Debug.Log(name + ".FinishStarting()... Created timeline... ");

        yield return null;

        /* Set Initial Sun Position */
        InitSunTransition();

        /* Show / Hide Data Display */
        if (displayModel)
            ShowStatistics();
        else
            HideStatistics();

        starting = false;

        loadingCanvas.enabled = false;
        loadingCanvas.gameObject.SetActive(false);

        controlsUICanvas.enabled = true;
        simulationUICanvas.enabled = true;
    }

    //public void SetDataDatesFromFile()        // TO DO
    //{

    //}

    public void SetDataDatesAndFinishStarting(string jsonString)
    {
        if (debugWeb)
            Debug.Log(name+".SetDataDatesAndFinishStarting()...");

        DateList datesObj = JsonUtility.FromJson<DateList>("{\"dates\":" + jsonString + "}");
        DateModel[] dates = datesObj.dates;
        dataDates = new List<DateModel>(dates);

        if (debugWeb)
            Debug.Log("Set dataDates... dataDates[0].month:" + dataDates[0].month+" dataDates[10].year:" + dataDates[10].year);

        dateLookup = new Dictionary<Vector3, int>();
        foreach(DateModel date in dataDates)
        {
            Vector3 vec = new Vector3(date.year, date.month, date.day);
            int id = date.id;

            dateLookup.Add(vec, id);
        }

        if (debugWeb)
            Debug.Log("Set dateLookup...");

        //dataDates = JsonUtility.FromJson<List<DateModel>>(jsonString);

        //cubes[0].SetDataDates(dataDates);
        //sideCubes[0].SetDataDates(dataDates);
        //cubes[1].SetDataDates(dataDates);
        //sideCubes[1].SetDataDates(dataDates);
        //cubes[2].SetDataDates(dataDates);
        //sideCubes[2].SetDataDates(dataDates);
        //cubes[3].SetDataDates(dataDates);
        //sideCubes[3].SetDataDates(dataDates);
        //cubes[4].SetDataDates(dataDates);
        //sideCubes[4].SetDataDates(dataDates);
        //aggregateCubeController.SetDataDates(dataDates);
        //aggregateSideCubeController.SetDataDates(dataDates);

        StartCoroutine(FinishStarting());
    }

    /// <summary>
    /// Load messages file
    /// </summary>
    /// <param name="file">File to load</param>
    /// <param name="fire">Fire message flag</param>
    /// <returns></returns>
    private List<UI_Message> LoadMessagesFile(TextAsset file, bool fire)
    {
        //  Debug.Log(name + ".LoadMessagesFile()... name:" + file.name+" fire? "+fire);

        List<string> rawData = TextAssetToList(file);

        List<UI_Message> result = new List<UI_Message>();

        int dataLength = rawData.Count - 1;                    // Set data length (raw data length - 1 for blank space at end)
                                                               //dataDates = new string[dataLength];
                                                               // 1969-07-15 0C 2
                                                               // The 1969 fire is a smaller low severity fire.  (Fire severity determines how much plant material or biomass is removed from the landscape).The 1969 fire does remove some shrub biomass in c). Even under extreme warming scenarios, the 1969 fire is restricted to understory vegetation -and does not spread to the overstory or "crown."

        // 1969-07-15 6C 2
        //  Notice that under an extreme warming scenario(+6C) a threshold is reached and fire severity dramatically increases and substantial biomass is lost in c)

        for (int row = 0; row < dataLength;)                      // Store data in 'data' 2D array
        {
            string tempData = rawData[row];
            string[] parts = tempData.Split(' ');
            string[] dateParts = parts[0].Split('-');
            int year = int.Parse(dateParts[0]);
            int month = int.Parse(dateParts[1]);
            int day = int.Parse(dateParts[2]);
            int idx = GetTimeIdxForDay(day, month, year);

            string[] warmingParts = parts[1].Split(',');
            List<int> warmingIdxList = new List<int>();
            foreach (string s in warmingParts)
            {
                char[] trim = { 'C' };
                string str = s.TrimEnd(trim);
                int warm = int.Parse(str);
                warmingIdxList.Add(warm);
            }

            string[] cubeParts = parts[2].Split(',');
            List<int> cubeIdxList = new List<int>();
            foreach (string s in cubeParts)
            {
                int cube = int.Parse(s);
                cubeIdxList.Add(cube);
            }

            row++;

            string messageString = rawData[row];

            row += 2;

            UI_Message.UI_MessageType fireMessageType = (fire ? UI_Message.UI_MessageType.fire : UI_Message.UI_MessageType.general);
            UI_Message message = new UI_Message(messageString, new Vector3(month, day, year), idx, warmingIdxList, settings.MessageFramesLength,
                                                 settings.MessageMinLength, cubeIdxList,
                                                 fireMessageType);

            //Debug.Log("message... messageString: " + messageString + " date:" + (new Vector3(month, day, year)) + " cubeIdxList[0]:" + cubeIdxList[0]);
            result.Add(message);
        }

        return result;
    }

    #endregion

    #region GameModes
    /// <summary>
    /// Enter Side-by-Side Mode
    /// </summary>
    /// <param name="idx">Cube index to show in Side-by-Side Mode</param>

    public void EnterSideBySideMode(int idx)
    {
        if(idx == -1)
        {
            // TO DO: Aggregeate Cube
        }

        if (idx < 0 || idx > 4)
            return;

        sbsIdx = idx;

        HideCubes(false, idx);

        CubeController cube = cubes[idx];
        CubeController sideCube = sideCubes[idx];

        cube.EnterSideBySide(cube1Stats);

        sideCube.gameObject.SetActive(true);

        sideCube.StartSimulation(timeIdx, timeStep);
        sideCube.messageManager = messageManager;

        sideCube.EnterSideBySide(cube2Stats);

        warmingKnob1Object.SetActive(true);
        warmingKnob1Slider.enabled = true;
        warmingKnob2Object.SetActive(true);
        warmingKnob2Slider.enabled = true;
        warmingKnobObject.SetActive(false);

        exitSideBySideButtonObject.SetActive(true);

        if (displayModel)
        {
            cube1Stats.SetActive(true);
            cube2Stats.SetActive(true);
        }
        else
        {
            cube1Stats.SetActive(false);
            cube2Stats.SetActive(false);
        }
        
        sideBySideCanvas.enabled = true;
        sideBySideMode = true;
        sideBySideModeToggleObject.GetComponent<Toggle>().isOn = false;
    }

    /// <summary>
    /// Enter Side-by-Side Mode
    /// </summary>
    /// <param name="idx">Cube index to show in Side-by-Side Mode</param>
    public void ExitSideBySideMode()
    {
        CubeController sideCube = sideCubes[sbsIdx];
        sideCube.gameObject.SetActive(true);
        sideCube.StopSimulation();

        HideSideCubes();

        warmingKnob1Object.SetActive(false);
        warmingKnob1Slider.enabled = false;
        warmingKnob2Object.SetActive(false);
        warmingKnob2Slider.enabled = false;
        warmingKnobObject.SetActive(true);
        //warmingKnobSlider.enabled = false;

        cube1Stats.SetActive(false);
        cube2Stats.SetActive(false);
        warmingLevelText.SetActive(false);

        foreach (CubeController cube in cubes)
        {
            cube.ResetStatsPanel();
        }

        ShowCubes(false);

        cameraController.StartResetZoom();

        exitSideBySideButtonObject.SetActive(false);
        zoomOutButtonObject.SetActive(false);

        sideBySideCanvas.enabled = true;
        sideBySideMode = false;
    }

    #endregion

    #region UpdateMethods
    /// <summary>
    /// Update this instance.
    /// </summary>
    void Update()
    {
        if (starting)
            return;

        if (timeIdx - lastDebugMessageFrame >= 30)
        {
            lastDebugMessageFrame = timeIdx;
        }

        if (exitGame)
        {
            Application.Quit();
        }

        if (initialized)
        {
            bool animating = false;
            foreach (CubeController cube in cubes)                                      /* Update cube animation */
            {
                if (cube.animating)
                {
                    cube.UpdateAnimation();
                    animating = true;
                }
            }
            foreach (CubeController cube in sideCubes)                                  /* Update side cube animation */
            {
                if (cube.animating)
                {
                    cube.UpdateAnimation();
                    animating = true;
                }
            }

            if (aggregateCubeController.animating)
            {
                aggregateCubeController.UpdateAnimation();
                animating = true;
            }

            if (!animating)
            {
                if (started)                                                               /* Update Game */
                {
                    CameraController.GamePauseState cState = cameraController.pauseState;

                    if (cState == CameraController.GamePauseState.pause)                    /* Update Pausing based on Camera */
                    {
                        if (!paused)
                            SetPaused(true);
                        cameraController.pauseState = CameraController.GamePauseState.idle;
                    }
                    if (cState == CameraController.GamePauseState.unpause)
                    {
                        if (paused)
                            SetPaused(false);
                        cameraController.pauseState = CameraController.GamePauseState.idle;
                    }

                    if (Time.time - lastSimulationUpdate > timeSpeed)                         /* Update Simulation */
                    {
                        if (!paused && !pausedAuto)
                            timeIdx += timeStep;

                        UpdateSimulation();

                        if (!paused && !pausedAuto)
                        {
                            UpdateLighting();

                            if (displayModel || sideBySideMode)
                            {
                                aggregateCubeController.UpdateStatistics();
                                foreach (CubeController cube in cubes)
                                {
                                    cube.UpdateStatistics();
                                }

                                if (sideBySideMode)
                                {
                                    foreach (CubeController cube in sideCubes)
                                    {
                                        cube.UpdateStatistics();
                                    }
                                }
                            }

                            UpdateUIText();

                            uiTimeline.UpdateSimulation( GetCurrentYear() );                  // Update timeline 

                            if (uiTimeline.clickedID >= 0 && uiTimeline.clickedID < simulationEndYear - simulationStartYear)
                            {
                                SetTimePosition(uiTimeline.clickedID);
                            }
                            uiTimeline.clickedID = -1;
                        }
                    }
                    else if (displaySeasons)                                                /* Update lighting between simulation frames */
                    {
                        if (!paused && !pausedAuto)
                        {
                            uiTimeline.UpdateSimulation( GetCurrentYear() );                  // Update timeline 
                            if (uiTimeline.clickedID >= 0 && uiTimeline.clickedID < simulationEndYear - simulationStartYear)
                            {
                                SetTimePosition(uiTimeline.clickedID);
                            }
                            uiTimeline.clickedID = -1;

                            UpdateLighting();                                               /* Update lighting between simulation frames */
                        }
                    }

                    /* Handle Keyboard Input */
                    if (Input.GetKeyDown(KeyCode.H))
                    {
                        SetHideUI(!uiObjectHidden);
                    }
                    if (Input.GetKeyDown(KeyCode.P))
                    {
                        SetPaused(!paused);
                    }
                    if (Input.GetKeyDown(KeyCode.E))
                    {
                        SetDisplayET(!displayET);
                    }
                }
                else if (!paused)                                               /* Call StartSimulation() for cubes */
                {
                    if (debugDetailed)
                        Debug.Log("Update()... Calling StartSimulation() for Game Objects... warmingIdx:" + warmingIdx+ " warmingDegrees:" + warmingDegrees);

                    landscapeController.StartSimulation(timeIdx, simulationStartYear, simulationStartMonth, simulationStartDay, timeStep, warmingIdx, settings.MinFireFrameLength, settings.ImmediateFireTimeThreshold);
                    cubes[0].StartSimulation(timeIdx, timeStep);
                    cubes[1].StartSimulation(timeIdx, timeStep);
                    cubes[2].StartSimulation(timeIdx, timeStep);
                    cubes[3].StartSimulation(timeIdx, timeStep);
                    cubes[4].StartSimulation(timeIdx, timeStep);
                    cubes[0].messageManager = messageManager;
                    cubes[1].messageManager = messageManager;
                    cubes[2].messageManager = messageManager;
                    cubes[3].messageManager = messageManager;
                    cubes[4].messageManager = messageManager;

                    aggregateCubeController.StartSimulation(timeIdx, timeStep);
                    aggregateCubeController.messageManager = messageManager;

                    started = true;
                    //startTime = Time.time;
                }
            }
        }
        else                                               // Check if landscapeController is initialized yet
        {
            if (landscapeController.initialized)
            {
                Debug.Log(name + ".Update()...  landscapeController.initialized:" + landscapeController.initialized + "  Stopping coroutine landscapeInitializer... landscapeController.patchesData null? " + (landscapeController.GetPatchesData() == null) + " landscapeController.extentsData null? " + (landscapeController.GetExtentsData() == null) + " landscapeController.landscapeData null? " + (landscapeController.GetCurrentSimulationData() == null));

                StopCoroutine(landscapeInitializer);
                initialized = true;
            }
        }
    }

    /// <summary>
    /// Updates the simulation at timeStep.
    /// </summary>
    void UpdateSimulation()
    {
        if (timeIdx > endTimeIdx || endSimulation)
        {
            if (debugGame)
                Debug.Log("UpdateSimulation().. Ended... timeIdx:" + timeIdx + " curDate:" + curDate.ToString() + " endTimeIdx:" + endTimeIdx);
            if (debugGame && debugMessages)
                DebugMessage("UpdateSimulation().. Ended... timeIdx:" + timeIdx + " curDate:" + curDate.ToString() + " endTimeIdx:" + endTimeIdx, true);

            EndSimulationRun();
            return;
        }
        else
        {
            if (timeIdx >= 0 && timeIdx < dataDates.Count)
            {
                curDate = dataDates[timeIdx];
            }
            else
            {
                Debug.Log(name + ".UpdateSimulation()... ERROR... curDate: " + curDate.ToString() + "... timeIdx:" + timeIdx + " out of dataDates range, Count:" + dataDates.Count);
                if (debugMessages)
                    DebugMessage(name + ".UpdateSimulation()... ERROR... curDate: " + curDate.ToString() + "... timeIdx:" + timeIdx + " out of dataDates range, Count:" + dataDates.Count, false);
            }

            if (!FireBurning() && !pausedAuto)
            {
                UpdateFireIgnition();
            }
        }

        int year = GetCurrentYear();
        int month = GetCurrentMonth();
        int day = GetCurrentDayInMonth();

        if (month == -1)
        {
            endSimulation = true;
            Debug.Log("Update()... ERROR month set to -1... Ending simulation");
            if (debugMessages)
                DebugMessage("Update()... ERROR month set to -1... Ending simulation", true);
            return;
        }

        bool burning = FireBurning();

        /* Update Landscape */
        if (!paused)
        {
            landscapeController.UpdateLandscape(timeIdx, year, month, day, timeStep, pausedAuto);
            if (burning)
                landscapeController.UpdateFire(timeStep);
        }

        /* Update Cubes */
        foreach (CubeController cube in cubes)                                      /* Update cube simulation */
        {
            if (cube.simulationOn)
            {
                if (!paused && !pausedAuto)
                    cube.UpdateVegetationBehavior(timeIdx, timeStep);
                if (burning)
                    cube.UpdateFire(timeStep);
            }
        }

        foreach (CubeController cube in sideCubes)                                  /* Update side cube simulation */
        {
            if (cube.simulationOn)
            {
                if (!paused && !pausedAuto)
                    cube.UpdateVegetationBehavior(timeIdx, timeStep);
                if (burning)
                    cube.UpdateFire(timeStep);
            }
        }

        if(timeStep > 7)
        {
            UpdateETSpeed();
        }
        else if(timeStep % 2 == 1)
        {
            if(timeIdx % 3 == 0)
                UpdateETSpeed();
        }
        else
        {
            if (timeIdx % 4 == 0)
                UpdateETSpeed();
        }

        bool fireBurning = FireBurning();
        if (!fireBurning)
            pausedAuto = false;

        /* Update Screen Messages */
        if (storyMode)
            messageManager.UpdateSimulation(timeIdx, year, month, day, timeStep, paused, warmingDegrees);

        /* Update Aggregate Cube */
        if (!paused && !pausedAuto)
            aggregateCubeController.UpdateVegetationBehavior(timeIdx, timeStep);
        if (fireBurning)
            aggregateCubeController.UpdateFire(timeStep);

        lastSimulationUpdate = Time.time;                                 // Set last simulation update time
    }

    /// <summary>
    /// Checks whether fire should be ignited on current date and ignites fire if needed
    /// </summary>
    private void UpdateFireIgnition()
    {
        bool igniteFire = false;
        int fireFrameIdx = 0;

        if (fireFrames.Contains(timeIdx))                               // Check if fire on current day
        {
            fireFrameIdx = fireFrames.IndexOf(timeIdx);
            if (debugFire)
                Debug.Log(name + ".UpdateSimulation()... Will ignite fire at index:" + fireFrameIdx + " ==> timeIdx:" + timeIdx);

            igniteFire = true;
        }
        else if (timeStep > 1)                                           // Check if fire between current day and previous day (current day - timeStep)
        {
            for (int i = timeIdx; i >= timeIdx - timeStep; i--)
            {
                if (fireFrames.Contains(i))
                {
                    fireFrameIdx = fireFrames.IndexOf(i);
                    if (debugFire)
                        Debug.Log(name + ".UpdateSimulation()... Will ignite fire at index:" + fireFrameIdx + " FireBurning():" + FireBurning() + " ==> timeIdx:" + timeIdx + " Time.time:" + Time.time);

                    igniteFire = true;
                }
            }
        }

        if (igniteFire)
        {
            Vector3 date = fireDates[fireFrameIdx];
            int fireTimeIdx = fireFrames[fireFrameIdx];

            if (settings.AutoPauseOnFire)                                    // Auto Pause on fire
                pausedAuto = true;

            landscapeController.IgniteTerrain(date, timeStep, settings.AutoPauseOnFire, settings.MaxFireLengthInSec, fireFrameIdx);        // Start fire in large landscape

            if (landscapeController.LandscapeSimulationIsOn())
            {
                for (int i=0; i<cubes.Length; i++)
                {
                    CubeController cube = cubes[i];
                    CubeController sideCube = sideCubes[i];

                    if (cube.simulationOn)
                    {
                        if (usePatchIDsForFire)                                  // Currently OFF since using unsynced simulation data
                        {
                            List<int> patchIDsToBurn = landscapeController.GetPatchesToBurnForDate(date);
                            if (patchIDsToBurn.Contains(cube.patchID))
                            {
                                if (debugFire)
                                    Debug.Log(name + ".Igniting fire at patchID:" + cube.patchID + " name:" + cube.name + " patchIDsToBurn.Count:" + patchIDsToBurn.Count);

                                cube.IgniteTerrain(fireTimeIdx, false);
                                sideCube.IgniteTerrain(fireTimeIdx, false);
                            }
                            else
                            {
                                if (debugFire)
                                    Debug.Log("Won't ignite fire at patchID:" + cube.patchID + " name:" + cube.name + " patchIDsToBurn.Count:" + patchIDsToBurn.Count);
                            }
                        }
                        else
                        {
                            if (debugFire)
                                Debug.Log(cube.name + ".ShouldBurnFireAtDate()? " + cube.ShouldBurnFireOnDate(date) + " date:" + date);
                            if (cube.ShouldBurnFireOnDate(date))                // Only burn cube if in (manual) list of cubes to burn for fire
                            {
                                cube.IgniteTerrain(fireTimeIdx, false);

                                if (sideCube.simulationOn)
                                    sideCube.IgniteTerrain(fireTimeIdx, false);
                            }
                        }
                    }
                }
            }
            else
            {
                for (int i = 0; i < cubes.Length; i++)
                {
                    CubeController cube = cubes[i];
                    CubeController sideCube = sideCubes[i];

                    if (cube.simulationOn)
                    {
                        if (usePatchIDsForFire)
                        {
                            cube.IgniteTerrain(fireTimeIdx, false);
                        }
                        else
                        {
                            if (debugGame)
                                Debug.Log(cube.name + ".ShouldBurnFireAtDate()? " + cube.ShouldBurnFireOnDate(date) + " date:" + date);
                            if (cube.ShouldBurnFireOnDate(date))                // Only burn cube if in (manual) list of cubes to burn for fire
                            {
                                cube.IgniteTerrain(fireTimeIdx, false);

                                if (sideCube.simulationOn)
                                    sideCube.IgniteTerrain(fireTimeIdx, false);
                            }
                        }
                    }
                }
            }

            if (aggregateCubeController.ShouldBurnFireOnDate(date))
            {
                aggregateCubeController.IgniteTerrain(fireTimeIdx, false);                         // Start fire in aggregate cube
                if(aggregateSideCubeController.simulationOn)
                    aggregateSideCubeController.IgniteTerrain(fireTimeIdx, false);                     // Start fire in aggregate side cube
            }
        }

        foreach (CubeController cube in cubes)          // Check if cube data exists
        {
            if (!cube.DataExists())
            {
                Debug.Log("No data exists for cube: " + cube.name);
                endSimulation = true;
            }
        }

        foreach (CubeController cube in sideCubes)
        {
            if (!cube.DataExists())
            {
                Debug.Log("No data exists for side cube: " + cube.name);
                endSimulation = true;
            }
        }

        if (debugGame && debugDetailed)
            Debug.Log("UpdateSimulation()... Current Date:" + curDate.ToString() + " timeIdx:" + timeIdx + " endTimeIdx:" + endTimeIdx);
    }

    /// <summary>
    /// Updates the time step increment and adjusts ET particle systems to correspond.
    /// </summary>
    /// <param name="newTimeStep">New time step.</param>
    private void UpdateTimeStep(int newTimeStep, bool updateSlider)
    {
        timeStep = newTimeStep;

        UpdateETSpeed();

        if (updateSlider)
        {
            timeKnobSlider.SetValue(timeStep);
        }
    }

    private void UpdateETSpeed()
    {
        foreach (CubeController cube in cubes)
        {
            if (cube.simulationOn)
            {
                cube.UpdateETSpeed(timeStep);
            }
        }

        foreach (CubeController cube in sideCubes)
        {
            if (cube.simulationOn)
            {
                cube.UpdateETSpeed(timeStep);
            }
        }

        if (aggregateCubeController.simulationOn)
            aggregateCubeController.UpdateETSpeed(timeStep);
        if (aggregateSideCubeController.simulationOn)
            aggregateSideCubeController.UpdateETSpeed(timeStep);
    }

    /// <summary>
    /// Simulates sunlight changes over the year
    /// </summary>
    private void UpdateLighting()
    {
        UpdateSunTransition();
    }

    #endregion

    #region GUI
    /// <summary>
    /// Draw GUI Layer
    /// </summary>
    private void OnGUI()
    {
        if (paused)
        {
            if (started)
            {
                if (showResumeButton)
                {
                    if (GUI.Button(new Rect(Screen.width / 2 - 60, Screen.height / 2, 150, 100), "Resume..."))
                    {
                        SetPaused(false);
                    }
                }
            }
        }
    }

    /// <summary>
    /// Updates the UIT ext.
    /// </summary>
    private void UpdateUIText()
    {
        int date = 0;
        try
        {
            string strDate = curDate.ToString().Split('-')[0];
            if (!strDate.Equals(""))
                date = int.Parse(strDate);
            else
            {
                Debug.Log("UpdateUIText()... Incorrect Date... curDate:" + curDate.ToString() + " timeIdx:" + timeIdx);
            }
        }
        catch (Exception e)
        {
            Debug.Log("UpdateUIText()... exception:" + e + " >> curDate:" + curDate.ToString());
            if (debugMessages)
            {
                DebugMessage("UpdateUIText()... exception:" + e, true);
            }
        }

        uiTimeline.SetTimelineText(curDate.ToString());
    }

    /// <summary>
    /// Sets the UI hidden state.
    /// </summary>
    /// <param name="newState">If set to <c>true</c> new state.</param>
    public void SetHideUI(bool newState)
    {
        if (debugDetailed)
            Debug.Log("SetHideUI()... " + newState);

        hideUI = newState;

        if (hideUI)
        {
            uiObject.SetActive(false);
            uiObjectHidden = true;
        }
        else
        {
            uiObject.SetActive(true);
            uiObjectHidden = false;
        }
    }

    /// <summary>
    /// Shows/hides the UI controls.
    /// </summary>
    public void ShowControls(bool value)
    {
        simulationUICanvas.enabled = value;
        simulationUICanvas.gameObject.SetActive(value);
    }

    /// <summary>
    /// Shows the data panel.
    /// </summary>
    private void ShowStatistics()
    {
        if (sideBySideMode)
            return;

        aggregateCubeController.ShowStatistics();
        foreach (CubeController cube in cubes)
        {
            if (cube.simulationOn)
            {
                cube.ShowStatistics();
            }
        }

        foreach (CubeController cube in sideCubes)
        {
            if (cube.simulationOn)
            {
                cube.ShowStatistics();
            }
        }
    }

    /// <summary>
    /// Hides the data panel.
    /// </summary>
    private void HideStatistics()
    {
        if (sideBySideMode)
            return;

        aggregateCubeController.HideStatistics();
        foreach (CubeController cube in cubes)
        {
            cube.HideStatistics();
        }
    }

    /// <summary>
    /// Shows the messages panel.
    /// </summary>
    private void ShowMessages()
    {
        if (messageManager == null)
            return;
        if (messageManager.messagePanel == null)
            return;
        messageManager.messagePanel.SetActive(true);
    }

    /// <summary>
    /// Hides the data panel.
    /// </summary>
    private void HideMessages()
    {
        if (messageManager == null)
            return;
        if (messageManager.messagePanel == null)
            return;
        messageManager.messagePanel.SetActive(false);
    }

    #endregion

    #region Timeline
    /// <summary>
    /// Sets the time position from selected timeline year.
    /// </summary>
    /// <param name="selectedYearIdx">Selected year index.</param>
    private void SetTimePosition(int selectedYearIdx)
    {
        timeIdx = GetTimeIdxForDay(1, 1, selectedYearIdx + simulationStartYear);        // Go to selected year 

        if (debugGame)
            Debug.Log(name+".SetTimePosition()... selectedYearIdx:" + selectedYearIdx + " new timeIdx:" + timeIdx);
        
        foreach (CubeController cube in cubes)
        {
            if (cube.simulationOn)
            {
                cube.UpdateVegetationFromData();
            }
        }
        
        aggregateCubeController.UpdateVegetationFromData();
        landscapeController.ResetBurntState();
        landscapeController.UpdateLandscape(timeIdx, GetCurrentYear(), GetCurrentMonth(), GetCurrentDayInMonth(), timeStep, pausedAuto);
    }
    
    public int GetTimeIdx()
    {
        return timeIdx;
    }

    /// <summary>
    /// Gets time index associated with given day, month and year.
    /// </summary>
    /// <returns>The time index for day.</returns>
    /// <param name="day">Day.</param>
    /// <param name="month">Month.</param>
    /// <param name="year">Year.</param>
    private int GetTimeIdxForDay(int day, int month, int year)      // TO DO: Use API
    {
        int idx = 0;

        DateModel check = dataDates[0];
        int curYear = check.year;
        int curMonth = check.month;
        int curDay = check.day;

        while (day != curDay || month != curMonth || year != curYear)
        {
            idx++;

            if (idx >= dataDates.Count)
            {
                Debug.Log("GetTimeIdxForDay()... Couldn't find time index for day:" + day + " month:" + month + " year:" + year);
                break;
            }

            check = dataDates[idx];

            curYear = check.year;
            curMonth = check.month;
            curDay = check.day;
        }

        //string[] curDateFields = dataDates[idx].Split('-');            // Save data file headings
        //int curYear = int.Parse(curDateFields[0]);
        //int curMonth = int.Parse(curDateFields[1]);
        //int curDay = int.Parse(curDateFields[2]);

        //while (day != curDay || month != curMonth || year != curYear)
        //{
        //    idx++;

        //    if (idx >= dataDates.Length)
        //    {
        //        Debug.Log("GetTimeIdxForDay()... Couldn't find time index for day:" + day + " month:" + month + " year:" + year);
        //        break;
        //    }

        //    curDateFields = dataDates[idx].Split('-');        // Save data file headings
        //    curYear = int.Parse(curDateFields[0]);
        //    curMonth = int.Parse(curDateFields[1]);
        //    curDay = int.Parse(curDateFields[2]);
        //}



        return idx;
    }

    /// <summary>
    /// Gets day of year for given month, day pair.
    /// </summary>
    /// <param name="month">Month.</param>
    /// <param name="day">Day.</param>
    private int GetDayOfYear(int month, int day, int year)
    {
        return new DateTime(year, month, day).DayOfYear;
    }

    /// <summary>
    /// Handles time slider input.
    /// </summary>
    /// <param name="newValue">New value.</param>
    public void HandleTimeSliderInput(int newValue)
    {
        UpdateTimeStep(newValue, false);
    }

    /// <summary>
    /// Gets the current day of year.                                       // -- CHECK FOR VALID INDEX
    /// </summary>
    /// <returns>The current day of year.</returns>
    private int GetCurrentDayOfYear()
    {
        if (timeIdx < dataDates.Count)
        {
            //string[] curDateFields = dataDates[timeIdx].Split('-');            // Save data file headings
            //int curYear = int.Parse(curDateFields[0]);
            //int curMonth = int.Parse(curDateFields[1]);
            //int curDay = int.Parse(curDateFields[2]);

            int curYear = dataDates[timeIdx].year;
            int curMonth = dataDates[timeIdx].month;
            int curDay = dataDates[timeIdx].day;

            return GetDayOfYear(curMonth, curDay, curYear);
        }

        Debug.Log(name + "GetCurrentDayOfYear()... Failed!  timeIdx: " + timeIdx + " dataDatesCube1.Length:" + dataDates.Count + " endTimeIdx:" + endTimeIdx);
        if (debugMessages)
            DebugMessage(name + "GetCurrentDayOfYear()... Failed!  timeIdx: " + timeIdx + " dataDatesCube1.Length:" + dataDates.Count + " endTimeIdx:" + endTimeIdx, true);

        return 1;
    }

    /// <summary>
    /// Gets the current day in current month.
    /// </summary>
    /// <returns>The current day in month.</returns>
    private int GetCurrentDayInMonth()
    {
        if (timeIdx > dataDates.Count)
        {
            Debug.Log("ERROR... timeIdx > dataDates.Count");
            return -1;
        }

        //string[] curDateFields;
        DateModel cur = dataDates[timeIdx];            // Save data file headings
        if (timeIdx < dataDates.Count - 2)
            return cur.day;

        Debug.Log("ERROR: Can't get current day in month... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx);

        if (debugMessages)
            DebugMessage("ERROR: Can't get current day in month... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx, true);

        cur = dataDates[dataDates.Count - 2];
        return cur.day;
    }

    /// <summary>
    /// Gets the current month.
    /// </summary>
    /// <returns>The current month.</returns>
    private int GetCurrentMonth()
    {
        if (timeIdx > dataDates.Count)
        {
            Debug.Log("ERROR... timeIdx > dataDates.Count");
            return -1;
        }

        //string[] curDateFields;
        DateModel cur = dataDates[timeIdx];            // Save data file headings
        if (timeIdx < dataDates.Count - 2)
            return cur.month;

        Debug.Log("ERROR: Can't get current month... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx);

        if (debugMessages)
            DebugMessage("ERROR: Can't get current month... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx, true);

        cur = dataDates[dataDates.Count - 2];
        return cur.month;
    }

    /// <summary>
    /// Gets the current year.
    /// </summary>
    /// <returns>The current year.</returns>
    private int GetCurrentYear()
    {
        if (timeIdx > dataDates.Count)
        {
            Debug.Log("ERROR... timeIdx > dataDates.Count");
            return -1;
        }

        //string[] curDateFields;
        DateModel cur = dataDates[timeIdx];            // Save data file headings
        if (timeIdx < dataDates.Count - 2)
            return cur.year;

        Debug.Log("ERROR: Can't get current year... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx);

        if (debugMessages)
            DebugMessage("ERROR: Can't get current year... timeIdx:" + timeIdx + " > dataDates.Count:" + dataDates.Count + " endTimeIdx:" + endTimeIdx, true);

        cur = dataDates[dataDates.Count - 2];
        return cur.year;
    }

    public int GetEndTimeIdx()
    {
        return endTimeIdx;
    }
    #endregion

    #region Controls
    /// <summary>
    /// Sets the paused state.
    /// </summary>
    /// <param name="newState">If set to <c>true</c> new state.</param>
    public void SetPaused(bool newState)
    {
        if (debugDetailed)
            Debug.Log("SetPaused()... " + newState);

        paused = newState;

        endButtonObject.SetActive(!newState);
        seasonsToggleObject.SetActive(!newState);
        flyCameraButtonObject.SetActive(!newState);
        cubesToggleObject.SetActive(!newState);

        foreach (CubeController cube in cubes)
        {
            if (cube.simulationOn)
            {
                if (paused)
                    cube.UpdateETSpeed(0);
                else
                    cube.UpdateETSpeed(timeStep);
            }
        }

        if (aggregateCubeController.simulationOn)
        {
            if (paused)
                aggregateCubeController.UpdateETSpeed(0);
            else
                aggregateCubeController.UpdateETSpeed(timeStep);
        }

        foreach (CubeController cube in sideCubes)
        {
            if (cube.simulationOn)
            {
                if (paused)
                    cube.UpdateETSpeed(0);
                else
                    cube.UpdateETSpeed(timeStep);
            }
        }

        if (aggregateSideCubeController.simulationOn)
        {
            if (paused)
                aggregateCubeController.UpdateETSpeed(0);
            else
                aggregateCubeController.UpdateETSpeed(timeStep);
        }

        uiTimelineObject.SetActive(!newState);
    }

    /// <summary>
    /// Sets the display ET state.
    /// </summary>
    /// <param name="newState">If set to <c>true</c> new state.</param>
    public void SetDisplayET(bool newState)
    {
        displayET = newState;
        foreach(CubeController cube in cubes)
        {
            cube.SetDisplayET(newState);
        }
        foreach (CubeController cube in sideCubes)
        {
            cube.SetDisplayET(newState);
        }
        
        aggregateCubeController.SetDisplayET(newState);
        aggregateSideCubeController.SetDisplayET(newState);
    }

    /// <summary>
    /// Toggles the data display.
    /// </summary>
    public void ToggleShowControls(GameObject toggleObject)
    {
        Toggle toggle = toggleObject.GetComponent<Toggle>();
        bool state = toggle.isOn;
        showControls = state;
        ShowControls(showControls);
    }

    /// <summary>
    /// Toggles the data display.
    /// </summary>
    public void ToggleModelDisplay(GameObject toggleObject)
    {
        Toggle toggle = toggleObject.GetComponent<Toggle>();
        bool state = toggle.isOn;

        displayModel = state;

        if (displayModel)
            ShowStatistics();
        else
            HideStatistics();
    }

    public List<DateModel> GetDates()
    {
        return dataDates;
    }

    public int GetDateIdxForDate(int year, int month, int day)
    {
        if(year > 0 && month > 0 && day > 0)
            return dateLookup[new Vector3(year, month, day)];
        else
        {
            Debug.Log("GetDateIdxForDate()... ERROR: year / month / day cannot be zero!");
            return -1;
        }
    }

    public int GetLastDateYear()
    {
        return dataDates[dataDates.Count - 1].year;
    }

    public int GetLastTimeIdx()
    {
        return dataDates[dataDates.Count - 1].id;
    }

    /// <summary>
    /// Returns whether model (graphs) is currently displayed
    /// </summary>
    /// <returns></returns>
    public bool DisplayModel()
    {
        return displayModel;
    }

    /// <summary>
    /// Toggles the data display.
    /// </summary>
    public void ToggleStoryMode(GameObject toggleObject)
    {
        Toggle toggle = toggleObject.GetComponent<Toggle>();
        bool state = toggle.isOn;

        storyMode = state;

        if (storyMode)
            ShowMessages();
        else
            HideMessages();
    }

    /// <summary>
    /// Toggles the cube display.
    /// </summary>
    /// <param name="toggleObject">Toggle object.</param>
    public void ToggleCubeDisplay(GameObject toggleObject)
    {
        if (!CubesAreAnimating())
        {
            Toggle toggle = toggleObject.GetComponent<Toggle>();
            bool state = toggle.isOn;

            Debug.Log("ToggleCubeDisplay()... No cubes are animating... new state:" + state);

            displayCubes = state;

            if (displayCubes)
                ShowCubes(false);
            else
                HideCubes(false, -1);
        }
    }

    /// <summary>
    /// Shows the cubes.
    /// </summary>
    private void ShowCubes(bool immediate)
    {
        if (immediate)
        {
            aggregateCubeController.cubeObject.SetActive(true);
            cubes[0].cubeObject.SetActive(true);
            cubes[1].cubeObject.SetActive(true);
            cubes[2].cubeObject.SetActive(true);
            cubes[3].cubeObject.SetActive(true);
            cubes[4].cubeObject.SetActive(true);
        }
        else
        {
            foreach (CubeController cube in cubes)
            {
                if (landscapeController.LandscapeSimulationIsOn())
                {
                    if (cube.patchID != -1)
                    {
                        Vector2 utm = landscapeController.GetPatchUTMLocation(cube.patchID);
                        if (!utm.Equals(new Vector3(0, 0, 0)))
                        {
                            Vector3 pos = landscapeController.GetWorldPositionOfUTMLocation(utm);
                            cube.StartAnimation(pos, cube.defaultPosition, CubeController.CubeAnimationType.grow);
                        }
                        else cube.StartAnimation(new Vector3(0, 0, 0), cube.defaultPosition, CubeController.CubeAnimationType.grow);
                    }
                }
                else
                {
                    cube.StartAnimation(new Vector3(0, 0, 0), cube.defaultPosition, CubeController.CubeAnimationType.grow);
                }
            }

            aggregateCubeController.StartAnimation(aggregateCubeController.defaultPosition, aggregateCubeController.defaultPosition, CubeController.CubeAnimationType.grow);
        }
    }

    /// <summary>
    /// Hides the cubes.
    /// </summary>
    private void HideCubes(bool immediate, int exceptCube)
    {
        aggregateCubeController.cubeObject.SetActive(false);

        for(int i=0; i<5; i++)
        {
            if(i != exceptCube)
            {
                cubes[i].cubeObject.SetActive(false);
            }
        }

        if (!immediate && initialized)
        {
            for (int i = 0; i < 5; i++)
            {
                if (i == exceptCube)
                    continue;

                CubeController cube = cubes[i];

                if (landscapeController.LandscapeSimulationIsOn())
                {
                    if (cube.patchID != -1)
                    {
                        Vector2 utm = landscapeController.GetPatchUTMLocation(cube.patchID);
                        Vector3 pos = landscapeController.GetWorldPositionOfUTMLocation(utm);
                        cube.StartAnimation(cube.defaultPosition, pos, CubeController.CubeAnimationType.shrink);
                    }
                }
                else
                {
                    cube.StartAnimation(cube.defaultPosition, new Vector3(0, 0, 0), CubeController.CubeAnimationType.shrink);
                }
            }

            aggregateCubeController.StartAnimation(aggregateCubeController.defaultPosition, aggregateCubeController.defaultPosition, CubeController.CubeAnimationType.shrink);
        }
    }

    /// <summary>
    /// Hides the cubes.
    /// </summary>
    private void HideSideCubes()
    {
        for (int i = 0; i < 5; i++)
        {
            sideCubes[i].cubeObject.SetActive(false);
        }

        aggregateSideCubeController.cubeObject.SetActive(false);
    }
    #endregion

    #region Resetting
    /// <summary>
    /// Reset camera zoom
    /// </summary>
    public void ResetCameraZoom()
    {
        sideBySideModeToggleObject.SetActive(true);
        zoomOutButtonObject.SetActive(false);
        CameraController camControl = sceneCamera.GetComponent<CameraController>() as CameraController;
        camControl.StartResetZoom();
    }

    public void SetSideByToggleActive(bool state)
    {
        sideBySideModeToggleObject.SetActive(state);
    }

    public void SetZoomOutButtonActive(bool state)
    {
        zoomOutButtonObject.SetActive(state);
    }

    /// <summary>
    /// Reset fire managers
    /// </summary>
    public void ResetFireManagers()
    {
        landscapeController.GetFireManager().Reset();

        //if (settings.BuildForWeb)
        //    return;

        aggregateCubeController.GetFireManager().Reset();
        foreach (CubeController cube in cubes)
        {
            cube.GetFireManager().Reset();
        }
        foreach (CubeController cube in sideCubes)
        {
            cube.GetFireManager().Reset();
        }

    }

    /// <summary>
    /// Resets the simulation.
    /// </summary>
    public void EndSimulationRun()
    {
        if (debugGame)
            Debug.Log("EndSimulationRun()...  dailyTimeIdx: " + timeIdx + " endTimeIdx:" + endTimeIdx);

        timeIdx = 0;
        started = false;
        hideUI = false;                    // UI hidden state
        SetPaused(true);

        landscapeController.ResetBackgroundSnow();
        landscapeController.SetSnowVisibility(false);

        CameraController camControl = sceneCamera.GetComponent<CameraController>() as CameraController;
        camControl.ResetPosition();             // Reset camera position immediately
        zoomOutButtonObject.SetActive(false);

        showControlsToggleObject.GetComponent<Toggle>().isOn = true;
        showModelDataToggleObject.GetComponent<Toggle>().isOn = false;
        flyCameraButtonObject.GetComponent<Toggle>().isOn = false;
        cubesToggleObject.GetComponent<Toggle>().isOn = true;
        camControl.SetCameraFlyMode(false);

        ToggleModelDisplay(showModelDataToggleObject);

        uiTimeline.ClearTimeline();
        messageManager.ClearMessages();
        messageManager.ClearLabels();

        ResetCubes();
        HideCubes(true, -1);
        HideSideCubes();
        ResetFireManagers();

        pauseButtonObject.SetActive(false);
        warmingKnobSlider.respondToUser = true;

        setupUICanvas.enabled = true;
        simulationUICanvas.enabled = true;
        controlsUICanvas.enabled = false;
        sideBySideCanvas.enabled = false;
        loadingCanvas.enabled = false;
        loadingCanvas.gameObject.SetActive(false);
        loadingTextObject.SetActive(false);

        introPanel.SetActive(true);

        endSimulation = false;
    }

    /// <summary>
    /// Resets the cubes.
    /// </summary>
    private void ResetCubes()
    {
        aggregateCubeController.ResetCube();
        aggregateSideCubeController.ResetCube();
        foreach (CubeController cube in cubes)
        {
            cube.ResetCube();
        }
        foreach (CubeController cube in sideCubes)
        {
            cube.ResetCube();
        }
    }

    /// <summary>
    /// Sets Side-By-Side Warming Level for Original (Left) or Compared (Right) Cube
    /// </summary>
    /// <param name="newIdx"></param>
    /// <param name="newDegrees"></param>
    /// <param name="isComparedCube"></param>
    public void SetSBSWarmingLevel(int newIdx, int newDegrees, bool isComparedCube)
    {
        if(settings.DebugGame)
            Debug.Log("SetSBSWarmingLevel()... newIdx: " + newIdx + " newDegrees:" + newDegrees);

        if (isComparedCube)
        {
            if (newIdx == sideCubes[sbsIdx].GetWarmingIdx())
                return;

            sideCubes[sbsIdx].ResetCube();
            sideCubes[sbsIdx].SetWarmingIdx(newIdx);
            sideCubes[sbsIdx].SetWarmingDegrees(newDegrees);
            sideCubes[sbsIdx].StartSimulation(timeIdx, timeStep);
        }
        else
        {
            if (newIdx == cubes[sbsIdx].GetWarmingIdx())
                return;

            cubes[sbsIdx].ResetCube();
            cubes[sbsIdx].SetWarmingIdx(newIdx);
            cubes[sbsIdx].SetWarmingDegrees(newDegrees);
            cubes[sbsIdx].StartSimulation(timeIdx, timeStep);
        }
    }

    #endregion

    #region Data
    /// <summary>
    /// Gets combined vegetation amount.
    /// </summary>
    /// <returns>The vegetation amount.</returns>
    private float GetVegetationAmount()
    {
        float vegetationAmount = 0f;

        vegetationAmount += cubes[0].GetTreeCarbonAmountVisualized();
        vegetationAmount += cubes[1].GetTreeCarbonAmountVisualized();
        vegetationAmount += cubes[2].GetTreeCarbonAmountVisualized();
        vegetationAmount += cubes[3].GetTreeCarbonAmountVisualized();
        vegetationAmount += cubes[4].GetTreeCarbonAmountVisualized();

        return vegetationAmount;
    }

    /// <summary>
    /// Gets combined carbon amount represented by root heights for trees in all cubes.
    /// </summary>
    /// <returns>The roots carbon amount.</returns>
    private float GetCombinedRootsYCarbon()
    {
        float rootsAmount = 0f;

        rootsAmount += cubes[0].GetRootsCarbonVisualized();
        rootsAmount += cubes[1].GetRootsCarbonVisualized();
        rootsAmount += cubes[2].GetRootsCarbonVisualized();
        rootsAmount += cubes[3].GetRootsCarbonVisualized();
        rootsAmount += cubes[4].GetRootsCarbonVisualized();

        return rootsAmount;
    }
    #endregion

    #region Fire
    /// <summary>
    /// Checks whether a fire is burning.
    /// </summary>
    /// <returns><c>true</c>, if fire is burning, <c>false</c> otherwise.</returns>
    private bool FireBurning()
    {
        foreach (CubeController cube in cubes)              // Check if cube(s) are still burning
        {
            if (cube.IsBurning())
                return true;
        }

        foreach (CubeController cube in sideCubes)
        {
            if (cube.IsBurning())
                return true;
        }

        if (aggregateCubeController.IsBurning())
            return true;
        if (aggregateSideCubeController.IsBurning())
            return true;

        if (landscapeController.IsBurning())
            return true;

        return false;
    }
    #endregion

    #region Animation
    /// <summary>
    /// Cubeses the are animating.
    /// </summary>
    /// <returns><c>true</c>, if are animating was cubesed, <c>false</c> otherwise.</returns>
    private bool CubesAreAnimating()
    {
        foreach (CubeController cube in cubes)
        {
            if (cube.animating)
            {
                return true;
            }
        }
        foreach (CubeController cube in sideCubes)
        {
            if (cube.animating)
            {
                return true;
            }
        }

        if (aggregateCubeController.animating || aggregateSideCubeController.animating)
            return true;
        else
            return false;
    }

    public int GetTimeStep()
    {
        return timeStep;
    }

    #endregion

    #region Environment
    /// <summary>
    /// Updates the sun angle based on current day in year.
    /// </summary>
    private void InitSunTransition()
    {
        /* Set starting sun transition direction */
        if (simulationStartMonth == 6)
        {
            if (simulationStartDay <= 21)
                sunTransitionDirection = -1;
            else
                sunTransitionDirection = 1;
        }
        else if (simulationStartMonth == 12)
        {
            if (simulationStartDay <= 21)
                sunTransitionDirection = 1;
            else
                sunTransitionDirection = -1;
        }
        else if (simulationStartMonth > 6)
        {
            sunTransitionDirection = 1;
        }
        else if (simulationStartMonth < 6)
        {
            sunTransitionDirection = -1;
        }

        UpdateSunTransition();
    }

    /// <summary>
    /// Updates the sun transition.
    /// </summary>
    private void UpdateSunTransition()
    {
        int curDayOfYear = GetCurrentDayOfYear();
        float newAltitudeAngle = 0f, newAzimuthAngle = 0f;
        float newSunIntensity = 0f;

        int month = GetCurrentMonth();
        int day = GetCurrentDayInMonth();
        int year = GetCurrentYear();

        if (month == -1)
            return;

        if (sunTransitionDirection == 1)                    // Summer to Winter Transition
        {
            int pos;
            if (month < 6)
                pos = curDayOfYear + sunTransitionEnd + 10;
            else
                pos = curDayOfYear - sunTransitionStart;

            float dist = (float)pos / (float)sunTransitionLength;
            float intensityDist = (float)pos * 2f / (float)sunTransitionLength;

            if (pos < sunTransitionLength)
            {
                newAltitudeAngle = Mathf.Lerp(summerAltitudeAngle, winterAltitudeAngle, dist);
                newAzimuthAngle = Mathf.Lerp(summerAzimuthAngle, winterAzimuthAngle, dist) + 180f;   // Adjust orientation
                if (intensityDist < 1f)
                    newSunIntensity = Mathf.Lerp(summerLightIntensity, winterLightIntensity, intensityDist);
                else
                    newSunIntensity = winterLightIntensity;
            }
            else if (pos == sunTransitionLength)                            // Finished transition to winter
            {
                newAltitudeAngle = winterAltitudeAngle;
                newAzimuthAngle = winterAzimuthAngle + 180f;
                newSunIntensity = winterLightIntensity;

                sunTransitionStart = GetDayOfYear(12, 21, simulationStartYear - 1);       // Last Winter Solstice
                sunTransitionEnd = GetDayOfYear(6, 21, simulationStartYear);              // Next Summer Solstice
                sunTransitionLength = 10 + sunTransitionEnd;

                sunTransitionDirection = -1;
            }
            else if (pos > sunTransitionLength)             // Already started transition back to summer
            {
                sunTransitionStart = GetDayOfYear(12, 21, simulationStartYear - 1);       // Last Winter Solstice
                sunTransitionEnd = GetDayOfYear(6, 21, simulationStartYear);              // Next Summer Solstice
                sunTransitionLength = 10 + sunTransitionEnd;

                if (month == 12)
                    pos = curDayOfYear - sunTransitionStart;
                else
                    pos = curDayOfYear + 10;

                dist = (float)pos / (float)sunTransitionLength;

                newAltitudeAngle = Mathf.Lerp(winterAltitudeAngle, summerAltitudeAngle, dist);
                newAzimuthAngle = Mathf.Lerp(winterAzimuthAngle, summerAzimuthAngle, dist) + 180f;   // Adjust orientation
                newSunIntensity = Mathf.Lerp(winterLightIntensity, summerLightIntensity, dist);

                sunTransitionDirection = -1;
            }
        }
        else                                                    // Winter to Summer Transition
        {
            int pos;
            if (month == 12)
                pos = curDayOfYear - sunTransitionStart;
            else
                pos = curDayOfYear + 10;

            float dist = (float)pos / (float)sunTransitionLength;
            float intensityDist = (float)pos * 2f / (float)sunTransitionLength;

            if (pos < sunTransitionLength)
            {
                newAltitudeAngle = Mathf.Lerp(winterAltitudeAngle, summerAltitudeAngle, dist);
                newAzimuthAngle = Mathf.Lerp(winterAzimuthAngle, summerAzimuthAngle, dist) + 180f;   // Adjust orientation
                if (intensityDist < 1f)
                    newSunIntensity = Mathf.Lerp(winterLightIntensity, summerLightIntensity, intensityDist);
                else
                    newSunIntensity = summerLightIntensity;
            }
            else if (pos == sunTransitionLength)                // Finished transition to summer
            {
                newAltitudeAngle = summerAltitudeAngle;
                newAzimuthAngle = summerAzimuthAngle + 180f;
                newSunIntensity = summerLightIntensity;

                sunTransitionStart = GetDayOfYear(6, 21, simulationStartYear);            // Last Summer Solstice
                sunTransitionEnd = GetDayOfYear(12, 21, simulationStartYear);             // Next Winter Solstice
                sunTransitionLength = sunTransitionEnd - sunTransitionStart;

                sunTransitionDirection = 1;
            }
            else if (pos > sunTransitionLength)                 // Already started transition back to winter
            {
                sunTransitionStart = GetDayOfYear(6, 21, simulationStartYear);            // Last Summer Solstice
                sunTransitionEnd = GetDayOfYear(12, 21, simulationStartYear);             // Next Winter Solstice
                sunTransitionLength = sunTransitionEnd - sunTransitionStart;

                pos = curDayOfYear - sunTransitionStart;
                dist = (float)pos / (float)sunTransitionLength;

                newAltitudeAngle = Mathf.Lerp(summerAltitudeAngle, winterAltitudeAngle, dist);
                newAzimuthAngle = Mathf.Lerp(summerAzimuthAngle, winterAzimuthAngle, dist) + 180f;   // Adjust orientation
                newSunIntensity = Mathf.Lerp(summerLightIntensity, winterLightIntensity, dist);

                sunTransitionDirection = 1;
            }
        }

        if (newAzimuthAngle > 360f)
            newAzimuthAngle -= 360f;
        else if (newAzimuthAngle < -360f)
            newAzimuthAngle += 360f;

        sunLight.transform.localEulerAngles = new Vector3(newAltitudeAngle, newAzimuthAngle, sunLight.transform.localEulerAngles.z);
        sunLight.intensity = newSunIntensity;
    }

    ///// <summary>
    ///// Toggles the data display.
    ///// </summary>
    //private void ToggleSeasons(GameObject toggleObject)
    //{
    //    Toggle toggle = toggleObject.GetComponent<Toggle>();
    //    bool state = toggle.isOn;

    //    displaySeasons = state;
    //}

    #endregion

    #region Utilities
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

    #region Classes
    /// <summary>
    /// Date class.
    /// </summary>
    public class Date
    {
        public static int day { get; set; }
        public static int month { get; set; }
        public static int year { get; set; }
        Date(int newMonth, int newDay, int newYear)
        {
            day = newDay;
            month = newMonth;
            year = newYear;
        }
    }

    /// <summary>
    /// Class representing vegetation species type, containing prefabs at different growth stages.
    /// </summary>
    [System.Serializable]
    public class CubeData
    {
        public string name = "Cube";
        public List<TextAsset> list;               // Prefabs at different growth stages (i.e. idx 0: small to idx n: large)
    }

    /// <summary>
    /// Vegetation species list for this cube.
    /// </summary>
    [System.Serializable]
    public class CubeDataList
    {
        public List<CubeData> data;
    }

    /// <summary>
    /// List of model data for multiple RHESSys simulation runs.
    /// </summary>
    [System.Serializable]
    public class LandscapeData
    {
        public TextAsset patches;                   // Patch location info file
        public TextAsset[] extents;                 // Data files showing snowfall and carbon per patch
        public TextAsset streamflowAnnual;
        public TextAsset streamflowDaily;
    }

    /// <summary>
    /// Class for text file handling
    /// </summary>
    public class HandleTextFile
    {
        public HandleTextFile() { }

        static public void WriteString(string str)
        {
            string path = debugOutputPath;

            StreamWriter writer = new StreamWriter(path, true);
            writer.WriteLine(str);
            writer.Close();
        }

        static public void ClearFile()
        {
            string path = debugOutputPath;

            File.WriteAllText(path, String.Empty);
        }
    }

    #endregion

    #region Debugging
    /// <summary>
    /// Prints debug message on screen.
    /// </summary>
    /// <param name="str">String.</param>
    public void DebugMessage(string str, bool ignoreDate)
    {
        int month = 0;
        int day = 0;
        int year = 0;

        str += " " + Time.time;

        if (!ignoreDate)
        {
            try
            {
                month = GetCurrentMonth();
                day = GetCurrentDayInMonth();
                year = GetCurrentYear();

                if (month == -1)
                    return;
            }
            catch (System.Exception e)
            {
                Debug.Log("DebugMessage()... ERROR e:" + e);
                month = 0;
                day = 0;
                year = 0;
            }
        }

        UI_Message message = new UI_Message(str, new Vector3(month, day, year), timeIdx,
                                             new List<int>(), settings.MessageFramesLength, debugMessageMinLength,
                                             new List<int>(), UI_Message.UI_MessageType.debug);

        if (messageManager != null)
            messageManager.DisplayDebugMessage(message, timeIdx);

        HandleTextFile.WriteString(message.GetMessage());
    }
    #endregion

    #region Termination
    private void OnDisable()
    {
        PauseButton.pauseEvent -= SetPaused;
    }

    void OnApplicationQuit()
    {
        landscapeController.ResetBackgroundSnow();
        landscapeController.SetSnowVisibility(false);
    }
    #endregion
}
