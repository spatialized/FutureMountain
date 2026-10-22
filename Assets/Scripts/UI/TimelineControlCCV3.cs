using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using Assets.Scripts.Models;

// CC V3 timeline: a self-contained subclass of TimelineControl.
// GameController still drives it as a TimelineControl (GetComponent returns this subclass),
// but it ignores ALL of the base's legacy visuals (bar row, fire/message icon groups, precip
// label, legacy date Text). Instead it shows a vertical year slider + adaptive decade ticks and
// a TMP date label, so none of those legacy Inspector fields need to be assigned.
// BigCreek keeps using the base class unchanged.
public class TimelineControlCCV3 : TimelineControl
{
    [Header("CC V3 slider")]
    public Slider slider;                 // vertical, Whole Numbers, Direction = Bottom To Top
    public TMPro.TMP_Text dateText;       // TMP date label (replaces the legacy UI.Text)

    [Header("Ticks")]
    public RectTransform tickParent;      // sized to the slider's Handle Slide Area
    public GameObject tickPrefab;         // a thin horizontal Image
    public float tickLength = 12f;        // normal tick width
    public float tickLengthDecade = 28f;  // year 1 and every 10th year are longer
    public float tickThickness = 2f;

    private bool syncing = false;         // true while we set slider.value in code
    private int pendingYear = -1;         // year the user picked; don't fight the handle until the sim reaches it
    private List<int> fireYearsCCV3;      // calendar years with a fire; their ticks are drawn red
    private int fireBaseYear = -1;        // calendar year of tick 0 (NOT the base startYear, which drives the slider)
    private static readonly Color FireTickColor = new Color(0.90f, 0.23f, 0.16f, 1f);

    // Replaces base.Awake so none of the legacy asserts / off-screen parking run.
    protected override void Awake()
    {
        selectedID = -1;
        clickedID = -1;
        raycaster = GetComponentInParent<GraphicRaycaster>();   // base pointer handlers use it (harmless: CC V3 has no bars)
    }

    // --- creation: only record the year count + build the slider ticks, no bars ---

    public override void CreateTimelineWeb(PrecipByYear[] waterData, int warmingIdx,
                                           int warmingDegrees, List<int> newFireYears, List<int> newMessageYears)
    {
        if (waterData != null && waterData.Length > 0) fireBaseYear = waterData[0].year;   // fire mapping only; NOT the slider base
        fireYearsCCV3 = newFireYears;
        SetupYears((waterData != null) ? waterData.Length : 0);
    }

    public override void CreateTimeline(List<WaterDataYear> waterData, int warmingIdx,
                                        int warmingDegrees, List<int> newFireYears, List<int> newMessageYears)
    {
        if (waterData != null && waterData.Count > 0) fireBaseYear = waterData[0].GetYear();
        fireYearsCCV3 = newFireYears;
        SetupYears((waterData != null) ? waterData.Count : 0);
    }

    public override void CreateTestTimeline(int startYearArg, int endYearArg, int warmingIdx,
                                            int warmingDegrees, List<int> newFireYears, List<int> newMessageYears)
    {
        fireBaseYear = startYearArg;
        fireYearsCCV3 = newFireYears;
        SetupYears(endYearArg - startYearArg + 1);
    }

    private void SetupYears(int count)
    {
        resolution = count;                 // inherited; YearCount reads this
        string fyDbg = (fireYearsCCV3 == null) ? "none" : string.Join(",", fireYearsCCV3);
        Debug.Log("[TLV3] SetupYears count:" + count + " fireBaseYear:" + fireBaseYear + " fireYears:[" + fyDbg + "]");
        if (slider != null)
        {
            slider.wholeNumbers = true;
            slider.minValue = 0;
            slider.maxValue = Mathf.Max(0, count - 1);
        }
        BuildTicks(count);
    }

    // --- per-frame update from GameController: advance the year + move the handle ---

    public override void UpdateSimulation(int curYear)
    {
        if (simulationYear == curYear) return;
        simulationYear = curYear;
        if (startYear < 0) startYear = simulationYear;   // first year seen becomes the base year

        if (slider == null) return;
        int cur = CurrentYearIndex;                      // inherited getter

        if (pendingYear >= 0)                            // waiting for the sim to reach the picked year
        {
            if (cur == pendingYear) pendingYear = -1;
            return;                                      // don't move the handle while waiting
        }
        if ((int)slider.value != cur)                    // follow the sim
        {
            syncing = true;
            slider.value = cur;
            syncing = false;
        }
    }

    public override void SetTimelineText(string newText)
    {
        if (dateText != null) dateText.text = newText;   // GameController feeds the current date here each frame
    }

    // Update the fire years (per active scenario) and recolour the ticks. Cheap: rebuilds the ~43 ticks.
    public override void SetFireYears(List<int> years)
    {
        fireYearsCCV3 = years;
        if (resolution > 0) BuildTicks(resolution);
    }

    // --- neutralize the legacy visual methods GameController still calls ---
    public override void ShowMessages() { }
    public override void HideMessages() { }
    public override void ClearTimeline() { }
    public override void ResetTimeline()
    {
        simulationYear = -1;
        startYear = -1;
        pendingYear = -1;
        if (slider != null) { syncing = true; slider.value = 0; syncing = false; }
    }

    // Wire to the Slider's On Value Changed (Single) -> dynamic float.
    public void OnYearSlider(float v)
    {
        if (syncing) return;                             // ignore our own follow-the-sim updates
        pendingYear = (int)v;
        clickedID = (int)v;                              // inherited; GameController reads it and jumps the year
    }

    // One horizontal tick per year along the slider track; year 1 and every 10th are longer.
    private void BuildTicks(int count)
    {
        if (tickParent == null || tickPrefab == null || count <= 0) return;

        for (int i = tickParent.childCount - 1; i >= 0; i--)
            Destroy(tickParent.GetChild(i).gameObject);   // clear any previous ticks

        for (int i = 0; i < count; i++)
        {
            GameObject go = Instantiate(tickPrefab, tickParent);
            go.SetActive(true);
            RectTransform rt = go.GetComponent<RectTransform>();

            // The slider shows year 1 (1977) at the TOP and the last year at the bottom, so place tick i=0 near the
            // top and increase downward. tickInset pulls both ends inward to match the handle's real travel range
            // (the handle can't reach the very edges because of its own size).
            float t = (count == 1) ? 0.5f : 1f - (float)i / (count - 1);
            rt.anchorMin = new Vector2(0.5f, t);
            rt.anchorMax = new Vector2(0.5f, t);
            rt.pivot     = new Vector2(0f, 0.5f);                     // grow to the right
            rt.anchoredPosition = Vector2.zero;

            int yearNumber = i + 1;                                   // relative year number: 1..N
            bool decade = (yearNumber == 1) || (yearNumber % 10 == 0);

            // Fire years (any cube burned) get a red, longer, thicker tick so students can scrub to them.
            bool fire = fireYearsCCV3 != null && fireBaseYear >= 0 && fireYearsCCV3.Contains(fireBaseYear + i);
            float len = (fire || decade) ? tickLengthDecade : tickLength;
            rt.sizeDelta = new Vector2(len, fire ? tickThickness + 2f : tickThickness);
            if (fire)
            {
                Image img = go.GetComponent<Image>();
                if (img != null) img.color = FireTickColor;
            }
        }
    }
}
