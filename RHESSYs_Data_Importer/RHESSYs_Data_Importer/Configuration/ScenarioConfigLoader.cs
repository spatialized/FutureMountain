using System;
using System.IO;
using System.Text.Json;

namespace RHESSYs_Data_Importer.Configuration
{
    public static class ScenarioConfigLoader
    {
        public static ScenarioConfig Load(string path)
        {
            if (!File.Exists(path))
                throw new FileNotFoundException($"Scenario config not found: {path}");

            var json = File.ReadAllText(path);
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            return JsonSerializer.Deserialize<ScenarioConfig>(json, options)
                   ?? throw new InvalidOperationException("Failed to parse scenario config JSON.");
        }
    }
}
