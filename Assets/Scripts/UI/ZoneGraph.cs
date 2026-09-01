using UnityEngine;
using XCharts.Runtime;
using UnityEngine.EventSystems;
using System.Collections.Generic;

/// <summary>
/// Drives the Quest zone graph: shows one zone cube's per-year series in an
/// XCharts LineChart, switchable by variable.
/// </summary>
public class ZoneGraph : MonoBehaviour
{
    public LineChart chart;                                                 // assign the LineChart
    public bool selectable = false;   // Level 1: allow clicking years on the graph

    private CubeController cube;
    private CubeController.ZoneGraphVariable variable = CubeController.ZoneGraphVariable.Precip;
    
    public Color selectedColor = new Color(1f, 0.4f, 0.4f);   // highlight color for selected years
    private const int ScenarioCount = 3;
    private HashSet<int>[] selectedByScenario = { new HashSet<int>(), new HashSet<int>(), new HashSet<int>() };
    private int currentScenario = 0;
    private bool pendingRefresh = false;
    private bool suppressed = false;
    public Color normalColor = new Color(0.3f, 0.6f, 1f);   // unselected point/bar color

    void Start()
    {
        if (selectable && chart != null)
        {
            chart.EnsureChartComponent<Tooltip>();
            chart.forceOpenRaycastTarget = true;     // make the chart actually receive clicks
            chart.onSerieClick = OnSerieClicked;      // fires when a data point is clicked (auto-opens raycast too)
            Debug.Log("ZoneGraph: click handler registered, selectable=" + selectable);
        }
    }

    void Update()
    {
        if (pendingRefresh) { pendingRefresh = false; Refresh(); }
    }

    public void SetSuppressed(bool s)
    {
        suppressed = s;
        gameObject.SetActive(!s && cube != null);   // stay hidden until a cube is actually selected (L3: wait for zoom-in)
        if (!s) pendingRefresh = true;
    }

    // GameController calls this when the scenario dropdown changes.
    public void SetScenario(int scenarioIdx)
    {
        currentScenario = Mathf.Clamp(scenarioIdx, 0, ScenarioCount - 1);
    }

    // For validation (Step 3): the selected year indices of one scenario.
    public HashSet<int> GetSelectedYears(int scenarioIdx)
    {
        return (scenarioIdx >= 0 && scenarioIdx < ScenarioCount) ? selectedByScenario[scenarioIdx] : null;
    }

    private void OnSerieClicked(SerieEventData evt)
    {
        int idx = evt.dataIndex;
        if (idx < 0) return;
        var set = selectedByScenario[currentScenario];
        bool nowSel = set.Add(idx);
        if (!nowSel) set.Remove(idx);        // toggle

        var serie = chart.GetSerie(0);
        var sd = (serie != null) ? serie.GetSerieData(idx) : null;
        if (sd != null)
            sd.EnsureComponent<ItemStyle>().color = nowSel ? (Color32)selectedColor : (Color32)normalColor;
        chart.RefreshChart();               // redraw visuals only, no rebuild
    }

    // Player zoomed into a cube -> show that cube's graph.
    public void ShowCube(CubeController newCube)
    {
        cube = newCube;
        Refresh();
    }

    // Dropdown option order MUST match the ZoneGraphVariable enum order
    // (Biomass, NPP, Transpiration, Height, Respiration, ET).
    public void OnVariableDropdown(int index)
    {
        Debug.Log("OnVariableDropdown index=" + index + " var=" + (CubeController.ZoneGraphVariable)index);
        variable = (CubeController.ZoneGraphVariable)index;
        Refresh();
        var yAxis = chart.EnsureChartComponent<YAxis>();
        yAxis.axisLabel.numericFormatter = "F2";
        chart.EnsureChartComponent<Tooltip>().numericFormatter = "F2";   // hover tooltip to 2 decimals
    }

    // Back to ZoneCube overview -> hide the graph.
    public void HideGraph()
    {
        cube = null;
        gameObject.SetActive(false);
    }

   private void Refresh()
    {
        if (chart == null || cube == null || suppressed) return;
        gameObject.SetActive(true);

        chart.RemoveData();

        if (variable == CubeController.ZoneGraphVariable.Temperature)
          {
              var smax = cube.GetYearlySeries(CubeController.ZoneGraphVariable.Temperature);
              var smin = cube.GetYearlySeries(CubeController.ZoneGraphVariable.TMin);
            chart.AddSerie<Line>("MaxT");
            chart.AddSerie<Line>("MinT");
            for (int i = 0; i < smax.Count; i++)
            {
                chart.AddXAxisData(smax[i].label);
                chart.AddData(0, smax[i].value);                 // serie 0 = MaxT
                if (i < smin.Count) chart.AddData(1, smin[i].value);  // serie 1 = MinT
            }
        }
        else if (variable == CubeController.ZoneGraphVariable.Precip)
        {
            // Precip: bar chart (clickable bars).
            var s = cube.GetYearlySeries(CubeController.ZoneGraphVariable.Precip);
            chart.AddSerie<Bar>("Precip");
            for (int i = 0; i < s.Count; i++)
            {
                chart.AddXAxisData(s[i].label);
                var sd = chart.AddData(0, s[i].value);
                if (selectable && sd != null)
                      sd.EnsureComponent<ItemStyle>().color =
                          selectedByScenario[currentScenario].Contains(i) ? (Color32)selectedColor : (Color32)normalColor;
            }
        }
        else
        {
            // Wind / Humidity / Evaporation: single line.
            var s = cube.GetYearlySeries(variable);
            chart.AddSerie<Line>(variable.ToString());
            for (int i = 0; i < s.Count; i++)
            {
                chart.AddXAxisData(s[i].label);
                var sd = chart.AddData(0, s[i].value);
                if (selectable && sd != null && selectedByScenario[currentScenario].Contains(i))
                    sd.EnsureComponent<ItemStyle>().color = selectedColor;
            }
        }

        var yAxis = chart.EnsureChartComponent<YAxis>();
        yAxis.axisLabel.numericFormatter = "F2";

        chart.RefreshChart();
        chart.EnsureChartComponent<Legend>();   // shows "MaxT" / "MinT" labels
    }

    public void ClearSelections()
    {
        for (int s = 0; s < ScenarioCount; s++) selectedByScenario[s].Clear();
        pendingRefresh = true;   // redraw without highlights
    }
}