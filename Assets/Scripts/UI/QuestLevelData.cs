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
    [TextArea] public string opening;
    public string[] defaultOptions;     // L3: North / South / High / Low / Riparian
    public List<QuestQuestion> questions;
}