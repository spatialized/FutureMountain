#if UNITY_EDITOR
 using UnityEditor;
 using UnityEditor.SceneManagement;
#endif
 using System.IO;
 using UnityEngine;
 using UnityEngine.SceneManagement;

namespace FutureMountain.ScenarioBuilder
{
    /// <summary>
    /// Central entry point for building scenarios.
    /// In future phases, this will parse configuration data and orchestrate scene creation.
    /// </summary>
    public static class ScenarioBuilder
    {
        /// <summary>
        /// Kicks off the scenario build process for the given scenario identifier.
        /// </summary>
        /// <param name="scenarioId">Logical identifier for the scenario to build.</param>
        public static void BuildScenario(string scenarioId)
        {
            if (string.IsNullOrEmpty(scenarioId))
            {
                Debug.LogError("Scenario ID is null or empty.");
                return;
            }

            var configAssetPath = $"Assets/FutureMountain/Scenarios/{scenarioId}/config.json";
            var config = ScenarioConfig.Load(configAssetPath);
            if (config == null)
            {
                Debug.LogError($"Failed to load scenario config for '{scenarioId}' at {configAssetPath}.");
                return;
            }

#if UNITY_EDITOR
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            scene.name = $"{scenarioId}_Generated";

            int count = 0;
            if (config.cubeDefinitions != null)
            {
                foreach (var def in config.cubeDefinitions)
                {
                    if (def == null) continue;
                    var cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    cube.name = string.IsNullOrEmpty(def.id) ? "Cube" : def.id;
                    if (def.position != null && def.position.Length >= 3)
                    {
                        cube.transform.position = new Vector3(def.position[0], def.position[1], def.position[2]);
                    }
                }
                count = config.cubeDefinitions.Count;
            }

            var destDirAssetPath = $"Assets/FutureMountain/Scenarios/{scenarioId}/Scenes/Generated";
            string fullDirPath;
            if (destDirAssetPath.StartsWith("Assets/"))
            {
                var rel = destDirAssetPath.Substring("Assets/".Length);
                fullDirPath = Path.Combine(Application.dataPath, rel);
            }
            else
            {
                fullDirPath = Path.Combine(Application.dataPath, destDirAssetPath);
            }
            if (!Directory.Exists(fullDirPath))
            {
                Directory.CreateDirectory(fullDirPath);
            }
            AssetDatabase.Refresh();

            var dstSceneAssetPath = $"{destDirAssetPath}/{scenarioId}_Auto.unity";
            if (!EditorSceneManager.SaveScene(scene, dstSceneAssetPath))
            {
                Debug.LogError($"Failed to save generated scene to {dstSceneAssetPath}");
                return;
            }

            Debug.Log($"Generated {count} cubes for {scenarioId}.");
#else
            Debug.LogWarning("BuildScenario can only run in the Unity Editor.");
#endif
        }
    }
}
