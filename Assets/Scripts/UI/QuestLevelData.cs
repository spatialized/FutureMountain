using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class QuestQuestion
{
    [TextArea] public string prompt;    // Description / question text
    public string[] options;            // Empty -> use the level's defaultOptions
    public int correctIndex;            // Index of the correct option
}

[CreateAssetMenu(fileName = "QuestLevel", menuName = "Quest/Quest Level")]
public class QuestLevelData : ScriptableObject
{
    [TextArea] public string opening;
    public string[] defaultOptions;     // L3: North / South / High / Low / Riparian
    public List<QuestQuestion> questions;
}