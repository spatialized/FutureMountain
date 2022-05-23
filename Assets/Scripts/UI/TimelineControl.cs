//using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;
using UnityEngine.EventSystems;

public class TimelineControl : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    /* Debugging */
    private bool debugTimeline = false;

    /* Game Objects */
    GameController gameController;
    UI_MessageManager messageManager;

    /* Prefabs */
    public GameObject fireIconPrefab;
    public GameObject messageIconPrefab;
    public GameObject yearTextLabelPrefab;
    public GameObject graphBarPrefab;
    public GameObject timelineLayoutGroup;

    /* Geometry */
    private static float heightScale = 0.33f;         // Works on Optoma projector 1920x1080 was .00044
    private static float barWidthScale = 1f;      // Works on Optoma projector 1920x1080

    GraphicRaycaster raycaster;
    PointerEventData pointerEventData;
    //EventSystem eventSystem;

    private int resolution;
    private static float widthFactor = 0.5f;                        // Timeline width factor
    private static float xOffset = 242f;                            // Timeline x offset
    private static float yOffset = 22f;                             // Timeline y offset
    private float dateYOffset = yOffset * 0.45f;                    // Offset of date text from bottom of screen
    private float fireYOffset = yOffset * 4f;                       // Offset of event icons from bottom of screen
    private float messageYOffset = yOffset * 2.95f;                 // Offset of event icons from bottom of screen

    /* Text */
    private GameObject uiTimelineDateTextObject;                    // UI Date Text Object
    private Text uiTimelineDateTextField;                           // UI Date Text Object

    /* Time */
    private int simulationYear = -1;                                // Current year in simulation
    private int startYear = -1;
    private GameObject[] points;

    /* Selection */
    public int selectedID { get; set; }                       // Selected bar ID
    public int clickedID { get; set; }                        // Clicked bar ID, used by GameController to update year

    /* Event Icons */
    List<int> fireYears;
    List<int> messageYears;
    List<GameObject> fireIcons;
    List<GameObject> messageIcons;

    /* Color */
    Color32 defaultColor = new Color32(150, 245, 250, 255);         // Year default color
    Color32 currentYearColor = new Color32(243, 243, 143, 255);     // Current year color
    Color32 yearUnderCursorColor = new Color32(65, 113, 205, 255);         // Year under cursor color

    /// <summary>
    /// Called when instance is created.
    /// </summary>
    private void Awake()
    {
        selectedID = -1;                       // Selected bar ID
        clickedID = -1;                        // Clicked bar ID

        Assert.IsNotNull(fireIconPrefab);
        Assert.IsNotNull(messageIconPrefab);

        uiTimelineDateTextObject = GameObject.Find("TimelineText");
        Assert.IsNotNull(uiTimelineDateTextObject);
        uiTimelineDateTextField = uiTimelineDateTextObject.GetComponent<Text>() as Text;
        Assert.IsNotNull(uiTimelineDateTextField);

        Vector3 pos = transform.position;
        pos.y = yOffset * 1.85f;
        //pos.y = initYOffset;
        transform.position = pos;

        raycaster = GetComponentInParent<GraphicRaycaster>();
        //eventSystem = GetComponent<EventSystem>();

        pos = uiTimelineDateTextObject.transform.position;
        pos.y = 30000f;
        uiTimelineDateTextObject.transform.position = pos;

        if(debugTimeline)
            Debug.Log("Screen.width:" + Screen.width+ " Screen.height:" + Screen.height);
    }

    public void Initialize(GameController newGameController)
    {
        if(debugTimeline)
            Debug.Log("TimelineControl.Initialize()");
        gameController = newGameController;
        //messageManager = gameController.messageManager;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        //m_PointerEventData = new PointerEventData(m_EventSystem);            // Set up the new Pointer Event
        pointerEventData = eventData;
        pointerEventData.position = Input.mousePosition;                       // Set the Pointer Event Position to that of the mouse position

        //Create a list of Raycast Results
        List<RaycastResult> results = new List<RaycastResult>();

        //Raycast using the Graphics Raycaster and mouse click position
        raycaster.Raycast(pointerEventData, results);

        int id = -1;
        foreach (RaycastResult hit in results)                                  // For every result returned, output the name of the GameObject on the Canvas hit by the Ray
        {
            string n = hit.gameObject.name;

            switch (hit.gameObject.tag)
            {
                case "TimelineBar":
                    string[] parts = n.Split('_');
                    id = int.Parse(parts[1]);                                   // Find index of year to jump to

                    if (id != -1)
                    {
                        if (id == selectedID)
                        {
                            SetColorForYear(selectedID + startYear, currentYearColor);
                            clickedID = id;
                            if(debugTimeline)
                                Debug.Log(name + ".OnPointerClick()... Clicked on selectedID " + selectedID+" == year:"+(selectedID + startYear));
                        }
                    }
                    
                    break;

                case "TimelineMessage":
                    string yearStr = n.Remove(0,8);
                    yearStr = yearStr.Remove(yearStr.Length - 2);
                    int year = int.Parse(yearStr);
                    string warmStr = n.Remove(0,n.Length-1);
                    int warmingDegrees = int.Parse(warmStr);

                    UI_Message message = messageManager.GetMessageForYearAndWarmDegrees(year, warmingDegrees);

                    clickedID = year - startYear;                    // Go to message at year

                    Debug.Log("Found message: " + " at idx:" + message.GetMessageTextIdx() + " at time idx:" + message.GetTimeIdx()+" at year:"+ year+" startYear:"+startYear + " clickedID:" + clickedID);
                    Debug.Log("  >> " + message.GetMessage() + " at warmingIdx:" + message.GetWarmingIdxList()[0] + " at warmingDegrees:"+ warmingDegrees + message.GetTimeIdx());

                    break;

                case "TimelineFire":
                    string fireYearStr = n.Remove(0, 5);
                    int fireYear = int.Parse(fireYearStr);

                    clickedID = fireYear - startYear;                    // Go to fire year at fireYear
                    Debug.Log(name + ".OnPointerClick()...  Clicked on fire " + hit.gameObject.name + " fireYearStr: " + fireYearStr + " fireYear:" + fireYear + " startYear:" + startYear+ " clickedID:"+ clickedID);

                    break;

                default:
                    break;
            }
        }
    }

    /// <summary>
    /// Pointer entered timeline graph bar callback
    /// </summary>
    /// <param name="eventData"></param>
    public void OnPointerEnter(PointerEventData eventData)
    {
        pointerEventData = eventData;
        pointerEventData.position = Input.mousePosition;                     //Set the Pointer Event Position to that of the mouse position

        List<RaycastResult> results = new List<RaycastResult>();
        raycaster.Raycast(pointerEventData, results);

        int id = -1;
        foreach (RaycastResult hit in results)        //For every result returned, output the name of the GameObject on the Canvas hit by the Ray
        {
            string n = hit.gameObject.name;

            switch (hit.gameObject.tag)
            {
                case "TimelineBar":
                    string[] parts = n.Split('_');
                    id = int.Parse(parts[1]);                                // Find index of year to jump to

                    if (id != -1)
                    {
                        if (id != selectedID)
                        {
                            if (selectedID != -1)
                            {
                                if (selectedID >= 0 && selectedID < resolution)
                                    SetColorForYear(selectedID + startYear, defaultColor);  // Set previously selected year to default color
                            }

                            SetColorForYear(id + startYear, yearUnderCursorColor);
                            selectedID = id;
                        }
                    }

                    break;
                case "TimelineMessage":
                    //n = "Message_" + year + "_" + warmingIdx;
                    //string yearStr = n.Remove(0, 8);
                    //yearStr = yearStr.Remove(yearStr.Length - 2);
                    //int year = int.Parse(yearStr);
                    //string warmStr = n.Remove(0, n.Length - 1);
                    //int warmingIdx = int.Parse(warmStr);

                    ////Debug.Log(name + ".OnPointerClick()...  Clicked on message "+hit.gameObject.name+ " warmStr:" + warmStr + " yearStr: "+yearStr+ " year:"+year+" warmingIdx:"+warmingIdx);

                    //UI_Message message = messageManager.GetMessageForYearAndWarmingIdx(year, warmingIdx);

                    //// Go to message at year

                    //Debug.Log("Found message: " + message.GetMessage() + " at idx:" + message.GetMessageTextIdx() + " at time idx:" + message.GetTimeIdx());
                    break;
                case "TimelineFire":
                    //string fireYearStr = n.Remove(0, 5);
                    //int fireYear = int.Parse(fireYearStr);

                    //Debug.Log(name + ".OnPointerClick()...  Clicked on fire " + hit.gameObject.name + " fireYearStr: " + fireYearStr + " fireYear:" + fireYear);

                    // Go to fire year at fireYear

                    //Debug.Log(name + ".OnPointerClick()... Clicked on fire... " + hit.gameObject.name + " fireYearStr: " + fireYearStr);
                    break;
                default:
                    break;
            }
        }
    }

    /// <summary>
    /// Handles pointer exit event
    /// </summary>
    /// <param name="eventData"></param>
    public void OnPointerExit(PointerEventData eventData)
    {
        pointerEventData = eventData;
        pointerEventData.position = Input.mousePosition;            //Set the Pointer Event Position to that of the mouse position

        //Create a list of Raycast Results
        List<RaycastResult> results = new List<RaycastResult>();

        //Raycast using the Graphics Raycaster and mouse click position
        raycaster.Raycast(pointerEventData, results);

        int id = -1;
        foreach (RaycastResult hit in results)        //For every result returned, output the name of the GameObject on the Canvas hit by the Ray
        {
            string n = hit.gameObject.name;
            string check = n.Remove(n.Length - 3);
            n = hit.gameObject.name;
            //Debug.Log("Hit " + hit.gameObject.name+ " check:"+ check);
            if (check.Equals("Point"))
            {
                string[] parts = n.Split('_');
                id = int.Parse(parts[1]);                                // Find index of year to jump to

                if (id != -1)
                {
                    if (id == selectedID)
                    {
                        SetColorForYear(selectedID + startYear, defaultColor);
                        Debug.Log(name + ".OnPointerExit()... (de)selectedID " + selectedID);
                        selectedID = -1;
                    }
                }
            }
            else
            {
                Debug.Log("Exited wasn't Point!  hit:" + hit.gameObject.name + ".");
            }
        }
    }

    /// <summary>
    /// Updates the simulation.
    /// </summary>
    /// <param name="curYear">Current year.</param>
    public void UpdateSimulation(int curYear)
    {
        if (simulationYear != curYear)
        {
            SetColorForYear(simulationYear, defaultColor);                    // Set previous year to default color

            if(debugTimeline)
                Debug.Log(name + ".UpdateSimulation()... year:" + simulationYear + "   set to curYear:" + curYear);

            simulationYear = curYear;

            if (startYear == -1)
                startYear = simulationYear;

            SetColorForYear(simulationYear, currentYearColor);

            Vector3 pos = points[simulationYear - startYear].transform.position;
            pos.y = dateYOffset;
            uiTimelineDateTextObject.transform.position = pos;              // Update position of date
        }
    }

    /// <summary>
    /// Creates the timeline.
    /// </summary>
    public void CreateTimeline(List<WaterDataYear> waterData, int warmingIdx, int warmingDegrees, List<int> newFireYears, List<int> newMessageYears)
    {
        messageManager = gameController.messageManager;

        resolution = waterData.Count;                      // Set resolution to number of years of water data
        startYear = waterData[0].GetYear();

        points = new GameObject[resolution];
        fireYears = newFireYears;
        messageYears = newMessageYears;

        float minPrecip = 100000f;
        float maxPrecip = -100000f;
        float minStreamflow = 100000f;
        float maxStreamflow = -100000f;

        foreach (WaterDataYear wYear in waterData)
        {
            float precip = wYear.GetTotalPrecipitation();
            float streamflow = wYear.GetTotalStreamflow(warmingIdx);

            if (precip > maxPrecip)
            {
                maxPrecip = precip;
            }
            if (streamflow > maxStreamflow)
            {
                maxStreamflow = streamflow;
            }
            if (precip < minPrecip)
            {
                minPrecip = precip;
            }
            if (streamflow < minStreamflow)
            {
                minStreamflow = streamflow;
            }
        }

        fireIcons = new List<GameObject>();
        messageIcons = new List<GameObject>();

        Vector3 scale = new Vector3(1f, 0f, 1f);
        //Vector3 scale = new Vector3(barWidthScale, 0f, 1f);

        Vector3 position;
        position.z = 0f;

        for (int i = 0; i < resolution; i++)
        {
            WaterDataYear waterYear = waterData[i];
            float precip = waterYear.GetTotalPrecipitation();                   // Set data for current day

            position.x = 0;
            position.y = 0;       // ADDED

            GameObject point = Instantiate(graphBarPrefab, position, new Quaternion(), transform) as GameObject;
            Transform pt = point.GetComponent<Transform>();

            pt.localScale = scale;                                      // Set width to default and height to 0
            float prevHeight = pt.localScale.y;
            float scaleDelta = MapValue(precip, 0f, maxPrecip, 0f, heightScale);
            pt.localScale += new Vector3(0f, scaleDelta, 0f);

            pt.name = "Point_" + i;
            points[i] = pt.gameObject;

            pt.parent = timelineLayoutGroup.transform;                          // Added

            Image image = points[i].GetComponent<Image>() as Image;
            image.color = defaultColor;

            position = pt.position;
            float step = Screen.width * widthFactor / resolution;       
            position.x = (i + 0.5f) * step - 1f + xOffset;

            position.y = fireYOffset;

            if (fireYears.Contains(i + startYear))
            {
                GameObject fireIcon = Instantiate(fireIconPrefab, position, fireIconPrefab.transform.rotation, transform);           // Instantiate fire icon at each fire year
                fireIcon.name = "Fire_" + (i + startYear);
                fireIcons.Add(fireIcon);
            }

            position.y = messageYOffset;

            if (messageYears.Contains(i + startYear))
            {
                GameObject messageIcon = Instantiate(messageIconPrefab, position, fireIconPrefab.transform.rotation, transform);     // Instantiate message icon at each message year
                messageIcon.name = "Message_" + (i + startYear) + "_" + warmingDegrees;
                messageIcons.Add(messageIcon);
            }
        }

        //Debug.Log("AFTER fireIcons.Count:" + fireIcons.Count);
    }

    /// <summary>
    /// Creates the test timeline for when landscapeSimulationOn is off.
    /// </summary>
    /// <param name="startYear">Start year.</param>
    /// <param name="endYear">End year.</param>
    /// <param name="warmingIdx">Warm index.</param>
    /// <param name="newFireYears">New fire years.</param>
    /// <param name="newMessageYears">New message years.</param>
    public void CreateTestTimeline(int startYear, int endYear, int warmingIdx, int warmingDegrees, List<int> newFireYears, List<int> newMessageYears)
    {
        messageManager = gameController.messageManager;

        resolution = endYear - startYear + 1;                      // Set resolution to number of years in range

        points = new GameObject[resolution];
        fireYears = newFireYears;
        messageYears = newMessageYears;

        Vector3 scale = new Vector3(1f, 0f, 1f);
        Vector3 position;

        position.z = 0f;

        float minPrecip = 0f;
        float maxPrecip = 10f;
        //float minStreamflow = 0f;
        //float maxStreamflow = 10f;

        fireIcons = new List<GameObject>();
        messageIcons = new List<GameObject>();

        //float xOffset = (Screen.width - Screen.width * widthFactor) / 2f;
        //float xOffset = (1280 - 1280 * widthFactor) / 2f;
        //float xOffset = 400;

        for (int i = 0; i < resolution; i++)
        {
            float precip = Random.Range(minPrecip, maxPrecip);

            position.x = 0;
            position.y = 0;       // ADDED

            GameObject point = Instantiate(graphBarPrefab, position, new Quaternion(), transform) as GameObject;
            Transform pt = point.GetComponent<Transform>();

            pt.parent = timelineLayoutGroup.transform;                          // Added

            pt.localScale = scale;                                      // Set width to default and height to 0
            float prevHeight = pt.localScale.y;                                         
            float scaleDelta = MapValue(precip, 0f, maxPrecip, 0f, heightScale);
            pt.localScale += new Vector3(0f, scaleDelta, 0f);

            pt.name = "Point_" + i;
            points[i] = pt.gameObject;

            Image image = points[i].GetComponent<Image>() as Image;
            image.color = defaultColor;

            position = pt.position;

            float step = Screen.width * widthFactor / resolution;       
            position.x = (i + 0.5f) * step - 1f + xOffset;

            position.y = fireYOffset;

            if (fireYears.Contains(i + startYear))
            {
                GameObject fireIcon = Instantiate(fireIconPrefab, position, fireIconPrefab.transform.rotation, transform);           // Instantiate fire icon at each fire year
                fireIcon.name = "Fire_" + (i + startYear);
                fireIcons.Add(fireIcon);
            }

            position.y = messageYOffset;

            if (messageYears.Contains(i + startYear))
            {
                GameObject messageIcon = Instantiate(messageIconPrefab, position, fireIconPrefab.transform.rotation, transform);     // Instantiate message icon at each message year
                messageIcon.name = "Message_" + (i + startYear) + "_" + warmingDegrees;
                messageIcons.Add(messageIcon);
            }
        }
    }

    /// <summary>
    /// Clears the timeline.
    /// </summary>
    public void ClearTimeline()
    {
        foreach (GameObject point in points)
        {
            Destroy(point);
        }
        foreach (GameObject obj in fireIcons)
        {
            Destroy(obj);
        }
        foreach (GameObject obj in messageIcons)
        {
            Destroy(obj);
        }

        Vector3 pos = uiTimelineDateTextObject.transform.position;
        pos.y = 30000f;
        uiTimelineDateTextObject.transform.position = pos;
    }

    /// <summary>
    /// Sets the timeline text.
    /// </summary>
    /// <param name="newText">New text.</param>
    public void SetTimelineText(string newText)
    {
        uiTimelineDateTextField.text = newText;
    }

    /// <summary>
    /// Sets the color.
    /// </summary>
    /// <param name="yearIdx">Year index.</param>
    /// <param name="color">Color.</param>
    private void SetColorForYear(int yearIdx, Color32 color)
    {
        int idx = yearIdx - startYear;
        if (idx < 0 || idx >= points.Length)
        {
            Debug.Log("SetColorForYear()... ERROR idx:" + idx + " points Length:" + points.Length);
        }
        else
        {
            for (int i = 0; i < resolution; i++)
            {
                if (i == idx) continue;
                Image img = points[i].GetComponent<Image>() as Image;
                img.color = defaultColor;
            }
            Image image = points[idx].GetComponent<Image>() as Image;
            image.color = color;
        }
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
}
