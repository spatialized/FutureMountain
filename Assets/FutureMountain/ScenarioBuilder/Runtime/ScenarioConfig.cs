using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace FutureMountain.ScenarioBuilder
{
    /// <summary>
    /// Placeholder for scenario configuration model.
    /// Will encapsulate JSON-serializable data used to drive automated scene generation.
    /// </summary>
    [System.Serializable]
    public class ScenarioConfig
    {
        /// <summary>
        /// Logical identifier for the scenario.
        /// </summary>
        public string id;

        /// <summary>
        /// List of cube placeholder definitions for quick verification of pipeline.
        /// </summary>
        public List<CubeDefinition> cubeDefinitions;

        /// <summary>
        /// Loads a ScenarioConfig from the given path. Accepts "Assets/..." relative paths or absolute paths.
        /// </summary>
        /// <param name="path">Project-relative asset path (preferred) or absolute file path.</param>
        /// <returns>Parsed ScenarioConfig instance or null on failure.</returns>
        public static ScenarioConfig Load(string path)
        {
            try
            {
                var normalized = path.Replace("\\", "/");
                string fullPath;
                if (Path.IsPathRooted(normalized))
                {
                    fullPath = normalized;
                }
                else if (normalized.StartsWith("Assets/"))
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
                    Debug.LogWarning($"Scenario config not found at path: {fullPath}");
                    return null;
                }

                var json = File.ReadAllText(fullPath);
                return JsonUtility.FromJson<ScenarioConfig>(json);
            }
            catch (System.Exception ex)
            {
                Debug.LogError($"Failed to load ScenarioConfig from {path}: {ex}");
                return null;
            }
        }
    }

    /// <summary>
    /// Definition for a placeholder cube to instantiate in the scene.
    /// </summary>
    [System.Serializable]
    public class CubeDefinition
    {
        public string id;
        public float[] position;
    }
}
