using System.Collections.Generic;

namespace RHESSYs_Data_Importer.Configuration
{
    public class ScenarioConfig
    {
        public string ScenarioName { get; set; }
        public string Description { get; set; }
        public string Version { get; set; }

        /// <summary>
        /// Explicit data-model profile for this scenario (e.g. "BigCreekV1" or
        /// "CentralCoastV2"). When omitted, the importer defaults to Big Creek v1
        /// so existing configs keep their current behavior.
        /// </summary>
        public string ScenarioProfile { get; set; }

        public DatabaseConfig Database { get; set; }
        public Dictionary<string, string> InputFolders { get; set; }
        public Dictionary<string, string> FilePatterns { get; set; }
        public Dictionary<string, Dictionary<string, string>> ColumnMapping { get; set; }
        public Dictionary<string, List<string>> Transforms { get; set; }
        public ScenarioFlags Flags { get; set; }
        public List<string> OutputTables { get; set; }

        /// <summary>
        /// Resolves the explicit profile for this scenario, defaulting to
        /// Big Creek v1 when <see cref="ScenarioProfile"/> is missing or unknown.
        /// </summary>
        public ScenarioProfileKind GetProfileKind()
            => ScenarioProfiles.ResolveOrDefault(ScenarioProfile);
    }

    public class DatabaseConfig
    {
        public string Name { get; set; }
        public string Host { get; set; }
        public int Port { get; set; }
        public string User { get; set; }
        public string Password { get; set; }
        public string Charset { get; set; }
        public string Collation { get; set; }

        public string GetConnectionString() =>
            $"server={Host};port={Port};database={Name};user={User};password={Password};charset={Charset};";

        public string GetAdminConnectionString() =>
            $"server={Host};port={Port};user={User};password={Password};charset={Charset};";
    }

    public class ScenarioFlags
    {
        public bool HasFire { get; set; }
        public int VegetationLayers { get; set; }
    }
}
