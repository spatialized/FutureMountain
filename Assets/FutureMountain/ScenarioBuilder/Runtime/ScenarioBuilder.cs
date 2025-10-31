using UnityEngine;

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
            Debug.Log($"Building scenario: {scenarioId}");
        }
    }
}
