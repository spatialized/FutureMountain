using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ScenarioYears
{
    public int[] years;   // "Year N" numbers for one scenario
}
[System.Serializable]
public class QuestQuestion
{
    [TextArea] public string prompt;    // Description / question text
    public string[] options;            // Empty -> use the level's defaultOptions
    public int correctIndex;            // Index of the correct option

    public bool graphSelect = false;                    // Level 1: answered by selecting years on the graph
    public List<ScenarioYears> correctYearsByScenario;  // index 0=WRF, 1=HADGEM, 2=CNRM
}

[CreateAssetMenu(fileName = "QuestLevel", menuName = "Quest/Quest Level")]
public class QuestLevelData : ScriptableObject
{
    public string title;
    public bool lockZoomOut = false;   // Level 1: keep the player on the aggregate cube
    public bool graphPrecipOnly = false;   // Level 1: lock the graph to precipitation + hide the variable dropdown
    public bool graphVegVariables = false; // Level 3: dropdown shows the vegetation set (Biomass/NPP/GPP/Respiration/Transpiration/Height)
    public int lockedScenario = -1;        // Quest2: force this scenario (0=WRF,1=HadGEM,2=RSClim) + disable the scenario dropdown; -1 = free
    public int lockedGraphVariable = -1;   // Quest2: lock the graph to one ZoneGraphVariable (cast from int) + hide dropdown; -1 = not locked
    public bool allowSideBySide = true;   // mode 2: same cube in different scenarios (CC V3)
    public bool allowDifferentCubes = true;   // mode 1: different cubes in the same scenario (CC V3)
    [TextArea] public string opening;
    [TextArea] public string ending;    // shown after the last question is answered, before advancing to the next level
    public string[] defaultOptions;     // L3: North / South / High / Low / Riparian
    public List<QuestQuestion> questions;
}