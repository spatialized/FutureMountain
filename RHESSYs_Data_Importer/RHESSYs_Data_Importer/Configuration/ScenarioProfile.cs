using System;

namespace RHESSYs_Data_Importer.Configuration
{
    /// <summary>
    /// Known importer data-model profiles.
    ///
    /// A profile is an explicit, curated description of a scenario's data model.
    /// The importer must select a profile explicitly (via scenario config) and
    /// must NOT infer the data model from table names or from which files happen
    /// to be present on disk.
    /// </summary>
    public enum ScenarioProfileKind
    {
        /// <summary>Existing Big Creek data model (legacy default).</summary>
        BigCreekV1,

        /// <summary>Central Coast v2 RHESSys-derived data model.</summary>
        CentralCoastV2
    }

    /// <summary>
    /// Canonical names and resolution helpers for <see cref="ScenarioProfileKind"/>.
    /// </summary>
    public static class ScenarioProfiles
    {
        public const string BigCreekV1 = "BigCreekV1";
        public const string CentralCoastV2 = "CentralCoastV2";

        /// <summary>
        /// Big Creek v1 is the default so existing configs that omit an explicit
        /// scenarioProfile keep their current behavior unchanged.
        /// </summary>
        public const ScenarioProfileKind DefaultKind = ScenarioProfileKind.BigCreekV1;

        /// <summary>
        /// Attempts to resolve a configured profile string to a known profile.
        /// Returns false for null/empty/unknown values without throwing.
        /// </summary>
        public static bool TryResolve(string value, out ScenarioProfileKind kind)
        {
            kind = DefaultKind;
            if (string.IsNullOrWhiteSpace(value))
                return false;

            switch (value.Trim().ToLowerInvariant())
            {
                case "bigcreekv1":
                case "bigcreek":
                case "bigcreek_v1":
                    kind = ScenarioProfileKind.BigCreekV1;
                    return true;
                case "centralcoastv2":
                case "centralcoast":
                case "centralcoast_v2":
                    kind = ScenarioProfileKind.CentralCoastV2;
                    return true;
                default:
                    return false;
            }
        }

        /// <summary>
        /// Resolves a configured profile string, falling back to the default
        /// (Big Creek v1) when the value is null/empty/unknown.
        /// </summary>
        public static ScenarioProfileKind ResolveOrDefault(string value)
            => TryResolve(value, out var kind) ? kind : DefaultKind;

        /// <summary>Returns true when the value names a known profile.</summary>
        public static bool IsKnown(string value) => TryResolve(value, out _);

        public static string ToCanonicalString(ScenarioProfileKind kind) => kind switch
        {
            ScenarioProfileKind.CentralCoastV2 => CentralCoastV2,
            _ => BigCreekV1
        };
    }
}
