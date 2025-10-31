using UnityEditor;
using UnityEngine;

namespace FutureMountain.ScenarioBuilder.Editor
{
    /// <summary>
    /// Scenario Wizard provides a simple entry point to build scenarios.
    /// This is the initial scaffolding; future phases will add config loading and automated scene generation.
    /// </summary>
    public class ScenarioWizard : EditorWindow
    {
        private string scenarioId = "BigCreek";

        /// <summary>
        /// Opens the Scenario Wizard window from the Unity menu.
        /// </summary>
        [MenuItem("Future Mountain/Scenario Wizard")]
        private static void ShowWindow()
        {
            var window = GetWindow<ScenarioWizard>();
            window.titleContent = new GUIContent("Scenario Wizard");
            window.minSize = new Vector2(360, 120);
            window.Show();
        }

        /// <summary>
        /// Draws the Scenario Wizard UI.
        /// </summary>
        private void OnGUI()
        {
            EditorGUILayout.LabelField("Scenario Builder", EditorStyles.boldLabel);
            EditorGUILayout.Space();

            scenarioId = EditorGUILayout.TextField("Scenario Id", scenarioId);

            EditorGUILayout.Space();

            if (GUILayout.Button("Build Scenario", GUILayout.Height(30)))
            {
                FutureMountain.ScenarioBuilder.ScenarioBuilder.BuildScenario(scenarioId);
            }
        }
    }
}
