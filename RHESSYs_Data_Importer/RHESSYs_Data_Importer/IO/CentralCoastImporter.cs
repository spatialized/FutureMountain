using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.DAL;
using RHESSYs_Data_Importer.Models.CentralCoast;

namespace RHESSYs_Data_Importer.IO
{
    /// <summary>
    /// Central Coast v2 import orchestration.
    ///
    /// Each Import* method reads a configured source file, maps CSV columns to
    /// the EF model, attaches provenance fields, and writes through
    /// <see cref="CentralCoastDAL"/>.
    /// </summary>
    public static class CentralCoastImporter
    {
        private static readonly DateTime DailyStart = new(1987, 7, 1);

        /// <summary>
        /// Imports the daily aggregate basin file (<c>cube_agg_p.csv</c>) into
        /// the <c>WaterData</c> table.
        /// </summary>
        public static void ImportWaterData(ScenarioConfig config, bool dryrun = false)
        {
            var path = config.GetSourceFilePath("cubeAggregateDaily");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] cubeAggregateDaily file not found: {path}");
                return;
            }

            var dal = new CentralCoastDAL();
            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                Console.WriteLine("[WARN] cubeAggregateDaily file has empty header.");
                return;
            }

            var headers = headerLine.Split(',');
            var propertyMap = BuildPropertyMap<WaterDataRow>(headers);

            // day/month/year are consumed for dateIdx, not stored on the model.
            int dayIdx = -1, monthIdx = -1, yearIdx = -1;
            for (int i = 0; i < headers.Length; i++)
            {
                var h = headers[i].Trim().ToLowerInvariant();
                if (h == "day") dayIdx = i;
                else if (h == "month") monthIdx = i;
                else if (h == "year") yearIdx = i;
            }

            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');
                var row = new WaterDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    warmingIdx = config.WarmingIdx ?? 0,
                    importRunId = 0 // TODO: create ImportRun record
                };

                // Compute dateIdx from day/month/year if available
                if (dayIdx >= 0 && monthIdx >= 0 && yearIdx >= 0 &&
                    int.TryParse(GetSafe(parts, dayIdx), out var day) &&
                    int.TryParse(GetSafe(parts, monthIdx), out var month) &&
                    int.TryParse(GetSafe(parts, yearIdx), out var year))
                {
                    try
                    {
                        var dt = new DateTime(year, month, day);
                        row.dateIdx = (dt - DailyStart).Days + 1;
                    }
                    catch
                    {
                        row.dateIdx = imported + 1;
                    }
                }
                else
                {
                    row.dateIdx = imported + 1;
                }

                // Map CSV columns to model properties
                foreach (var kvp in propertyMap)
                {
                    int col = kvp.Key;
                    var prop = kvp.Value;
                    if (col < 0 || col >= parts.Length)
                        continue;

                    var raw = parts[col]?.Trim();
                    if (string.IsNullOrWhiteSpace(raw))
                        continue;

                    try
                    {
                        if (prop.PropertyType == typeof(float))
                        {
                            if (float.TryParse(raw, out var f))
                                prop.SetValue(row, f);
                        }
                        else if (prop.PropertyType == typeof(int))
                        {
                            if (int.TryParse(raw, out var i))
                                prop.SetValue(row, i);
                        }
                        else if (prop.PropertyType == typeof(string))
                        {
                            prop.SetValue(row, raw);
                        }
                    }
                    catch { /* ignore parse failures for individual cells */ }
                }

                imported++;
                if (!dryrun)
                    dal.AddWaterDataRow(row);
            }

            Console.WriteLine($"[WaterData] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Imports daily cube patch files (<c>cube_p_patch1.csv</c>,
        /// <c>cube_p_patch2.csv</c>) into the <c>CubeData</c> table.
        /// Stratum columns (overstory/understory) are not populated here;
        /// they are filled by the stratum importer (CCV2-09).
        /// </summary>
        public static void ImportCubePatchData(ScenarioConfig config, bool dryrun = false)
        {
            foreach (var role in new[] { "cubePatchDaily01", "cubePatchDaily02" })
            {
                var path = config.GetSourceFilePath(role);
                if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
                {
                    Console.WriteLine($"[WARN] {role} file not found: {path}");
                    continue;
                }

                var dal = new CentralCoastDAL();
                using var reader = new StreamReader(path);
                string headerLine = reader.ReadLine();
                if (string.IsNullOrWhiteSpace(headerLine))
                {
                    Console.WriteLine($"[WARN] {role} file has empty header.");
                    continue;
                }

                var headers = headerLine.Split(',');
                var propertyMap = BuildPropertyMap<CubeDataRow>(headers);

                // Resolve day/month/year indices for dateIdx
                int dayIdx = -1, monthIdx = -1, yearIdx = -1;
                for (int i = 0; i < headers.Length; i++)
                {
                    var h = headers[i].Trim().ToLowerInvariant();
                    if (h == "day") dayIdx = i;
                    else if (h == "month") monthIdx = i;
                    else if (h == "year") yearIdx = i;
                }

                int imported = 0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line))
                        continue;

                    var parts = line.Split(',');
                    var row = new CubeDataRow
                    {
                        scenarioRunId = config.ScenarioRunId ?? "",
                        warmingIdx = config.WarmingIdx ?? 0,
                        importRunId = 0
                    };

                    // Compute dateIdx
                    if (dayIdx >= 0 && monthIdx >= 0 && yearIdx >= 0 &&
                        int.TryParse(GetSafe(parts, dayIdx), out var day) &&
                        int.TryParse(GetSafe(parts, monthIdx), out var month) &&
                        int.TryParse(GetSafe(parts, yearIdx), out var year))
                    {
                        try
                        {
                            var dt = new DateTime(year, month, day);
                            row.dateIdx = (dt - DailyStart).Days + 1;
                        }
                        catch
                        {
                            row.dateIdx = imported + 1;
                        }
                    }
                    else
                    {
                        row.dateIdx = imported + 1;
                    }

                    // Map CSV columns to model properties
                    foreach (var kvp in propertyMap)
                    {
                        int col = kvp.Key;
                        var prop = kvp.Value;
                        if (col < 0 || col >= parts.Length)
                            continue;

                        var raw = parts[col]?.Trim();
                        if (string.IsNullOrWhiteSpace(raw))
                            continue;

                        try
                        {
                            if (prop.PropertyType == typeof(float))
                            {
                                if (float.TryParse(raw, out var f))
                                    prop.SetValue(row, f);
                            }
                            else if (prop.PropertyType == typeof(int))
                            {
                                if (int.TryParse(raw, out var i))
                                    prop.SetValue(row, i);
                            }
                            else if (prop.PropertyType == typeof(long))
                            {
                                if (long.TryParse(raw, out var l))
                                    prop.SetValue(row, l);
                            }
                            else if (prop.PropertyType == typeof(string))
                            {
                                prop.SetValue(row, raw);
                            }
                        }
                        catch { }
                    }

                    imported++;
                    if (!dryrun)
                        dal.AddCubeDataRow(row);
                }

                Console.WriteLine($"[CubeData/{role}] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
            }
        }

        /// <summary>
        /// Builds a map from CSV column index to writable property for the
        /// given model type. Header dots are normalized to underscores to
        /// match the C# property names (e.g. <c>cs.net_psn</c> ->
        /// <c>cs_net_psn</c>).
        /// </summary>
        private static Dictionary<int, PropertyInfo> BuildPropertyMap<T>(string[] headers)
        {
            var map = new Dictionary<int, PropertyInfo>();
            var props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => p.CanWrite && p.SetMethod?.IsPublic == true)
                .ToDictionary(
                    p => p.Name,
                    p => p,
                    StringComparer.OrdinalIgnoreCase);

            for (int i = 0; i < headers.Length; i++)
            {
                var normalized = headers[i].Trim().Replace('.', '_');
                if (props.TryGetValue(normalized, out var prop))
                {
                    // Skip provenance/computed fields that are set explicitly
                    var name = prop.Name.ToLowerInvariant();
                    if (name is "id" or "importrunid" or "scenariorunid" or "warmingidx" or "dateidx")
                        continue;

                    map[i] = prop;
                }
            }
            return map;
        }

        private static string GetSafe(string[] parts, int index)
        {
            if (parts == null || index < 0 || index >= parts.Length)
                return string.Empty;
            return parts[index]?.Trim() ?? string.Empty;
        }
    }
}
