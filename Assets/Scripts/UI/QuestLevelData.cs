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

    public bool textInput = false;                      // answered by typing in a text box (no auto-grading yet; non-empty advances)
}

[CreateAssetMenu(fileName = "QuestLevel", menuName = "Quest/Quest Level")]
public class QuestLevelData : ScriptableObject
{
    public string title;
    public bool lockZoomOut = false;   // Level 1: keep the player on the aggregate cube
    // Graph variable control (one field):
    //   -1  = free, CLIMATE dropdown (Precip/Wind/Temperature/Humidity/Evaporation/TMin)
    //   -2  = free, VEGETATION dropdown (Biomass/NPP/GPP/Respiration/Transpiration/Height)
    //   >=0 = LOCK the graph to that ZoneGraphVariable (cast from int) and hide the dropdown
    public int graphVariableMode = -1;
    public int lockedScenario = -1;        // Quest2: force this scenario (0=WRF,1=HadGEM,2=RSClim) + disable the scenario dropdown; -1 = free
    public int lockedSpeedStep = -1;       // Quest: lock the speed slider to a step (0=Daily,1=Weekly,2=Monthly,3=Yearly) + disable it; -1 = free
    public bool graphSelectable = false;   // Quest: can the player click the graph to pick answers (hover tooltip stays on either way)
    public bool allowSideBySide = true;   // mode 2: same cube in different scenarios (CC V3)
    public bool allowDifferentCubes = true;   // mode 1: different cubes in the same scenario (CC V3)
    [TextArea] public string opening;
    [TextArea] public string ending;    // shown after the last question is answered, before advancing to the next level
    public string[] defaultOptions;     // L3: North / South / High / Low / Riparian
    public List<QuestQuestion> questions;
}