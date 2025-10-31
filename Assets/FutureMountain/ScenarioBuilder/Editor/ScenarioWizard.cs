using System.IO;
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
                var configAssetPath = $"Assets/FutureMountain/Scenarios/{scenarioId}/config.json";
                var normalized = configAssetPath.Replace("\\", "/");
                string fullPath;
                if (normalized.StartsWith("Assets/"))
                {
                    var rel = normalized.Substring("Assets/".Length);
                    fullPath = Path.Combine(Application.dataPath, rel);
                }
                else
                {
                    fullPath = Path.Combine(Application.dataPath, normalized);
                }

                if (!File.Exists(fullPath))
                {
                    EditorUtility.DisplayDialog(
                        "Scenario Config Missing",
                        $"Config not found at:\n{configAssetPath}\n\nPlease create the file and try again.",
                        "OK");
                    return;
                }

                FutureMountain.ScenarioBuilder.ScenarioBuilder.BuildScenario(scenarioId);
            }
        }
    }
}
