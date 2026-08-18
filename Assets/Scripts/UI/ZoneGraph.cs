 using UnityEngine;
using XCharts.Runtime;

/// <summary>
/// Drives the Quest zone graph: shows one zone cube's per-year series in an
/// XCharts LineChart, switchable by variable.
/// </summary>
public class ZoneGraph : MonoBehaviour
{
    public LineChart chart;                                                 // assign the LineChart

    private CubeController cube;
    private CubeController.ZoneGraphVariable variable =
CubeController.ZoneGraphVariable.Biomass;

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
        Debug.Log("OnVariableDropdown index=" + index + " var=" +
  (CubeController.ZoneGraphVariable)index);
        variable = (CubeController.ZoneGraphVariable)index;
        Refresh();
    }

    // Back to ZoneCube overview -> hide the graph.
    public void HideGraph()
    {
        cube = null;
        gameObject.SetActive(false);
    }

    private void Refresh()
    {
        if (chart == null || cube == null) return;
        gameObject.SetActive(true);

        var series = cube.GetYearlySeries(variable);

        chart.RemoveData();                          // clean slate (removes old serie + data)
        chart.AddSerie<Line>(variable.ToString());   // one Line serie

        foreach (var pt in series)
        {
            chart.AddXAxisData(pt.label);            // "Year 1", "Year 2", ...
            chart.AddData(0, pt.value);              // serie 0 y-value
        }
    }
}