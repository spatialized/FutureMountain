using System.Collections.Generic;
using System.IO;

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

        // ---- Multi-member scenario fields (used by Central Coast v2; optional and
        // unused by Big Creek v1, which leaves them null/empty). ----

        /// <summary>
        /// Identifier for a single scenario member/run within a profile (e.g.
        /// "single-warming-sample"). Lets multiple bundles of the same profile be
        /// imported and stored side by side.
        /// </summary>
        public string ScenarioRunId { get; set; }

        /// <summary>
        /// Warming/climate-case index for this scenario member. Null when not
        /// applicable. The current Central Coast sample has no warming token, so it
        /// is imported with an explicit assumed value of 0.
        /// </summary>
        public int? WarmingIdx { get; set; }

        /// <summary>
        /// Base folder that the entries in <see cref="Files"/> are resolved against.
        /// Keeps the source bundle location out of code so the same config shape can
        /// point at different members by changing only this value.
        /// </summary>
        public string SourceRoot { get; set; }

        /// <summary>
        /// Field/column delimiter for source files (e.g. "," for Central Coast CSVs).
        /// Null/empty preserves legacy whitespace-delimited behavior.
        /// </summary>
        public string Delimiter { get; set; }

        /// <summary>
        /// Logical file role -> file name, resolved relative to <see cref="SourceRoot"/>.
        /// Central Coast members share these role names and the same file names, so a
        /// new member is configured by changing <see cref="SourceRoot"/>,
        /// <see cref="ScenarioRunId"/>, and <see cref="WarmingIdx"/> only.
        /// </summary>
        public Dictionary<string, string> Files { get; set; }

        /// <summary>
        /// Resolves the explicit profile for this scenario, defaulting to
        /// Big Creek v1 when <see cref="ScenarioProfile"/> is missing or unknown.
        /// </summary>
        public ScenarioProfileKind GetProfileKind()
            => ScenarioProfiles.ResolveOrDefault(ScenarioProfile);

        /// <summary>
        /// Resolves a logical file role to a full path under <see cref="SourceRoot"/>.
        /// Returns null when the role is not configured.
        /// </summary>
        public string GetSourceFilePath(string role)
        {
            if (Files == null || string.IsNullOrWhiteSpace(role)
                || !Files.TryGetValue(role, out var name) || string.IsNullOrWhiteSpace(name))
                return null;

            var root = string.IsNullOrWhiteSpace(SourceRoot) ? "." : SourceRoot;
            return Path.GetFullPath(Path.Combine(root, name));
        }
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
