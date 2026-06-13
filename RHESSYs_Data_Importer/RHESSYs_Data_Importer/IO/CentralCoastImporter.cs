using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using BitMiracle.LibTiff.Classic; // BitMiracle.LibTiff.NET package
using Newtonsoft.Json;
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
        /// Imports daily cube stratum files (overstory and understory for
        /// patch 01 and 02) and merges them into the existing <c>CubeData</c>
        /// rows created by <see cref="ImportCubePatchData"/>.
        ///
        /// Matches on (scenarioRunId, warmingIdx, dateIdx, zoneID, patchID).
        /// </summary>
        public static void ImportCubeStratumData(ScenarioConfig config, bool dryrun = false)
        {
            var fileDefs = new[]
            {
                new { Role = "cubeStratumOver01", IsOverstory = true, PatchSuffix = "01" },
                new { Role = "cubeStratumOver02", IsOverstory = true, PatchSuffix = "02" },
                new { Role = "cubeStratumUnder01", IsOverstory = false, PatchSuffix = "01" },
                new { Role = "cubeStratumUnder02", IsOverstory = false, PatchSuffix = "02" },
            };

            foreach (var def in fileDefs)
            {
                var path = config.GetSourceFilePath(def.Role);
                if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
                {
                    Console.WriteLine($"[WARN] {def.Role} file not found: {path}");
                    continue;
                }

                var dal = new CentralCoastDAL();
                using var reader = new StreamReader(path);
                string headerLine = reader.ReadLine();
                if (string.IsNullOrWhiteSpace(headerLine))
                {
                    Console.WriteLine($"[WARN] {def.Role} file has empty header.");
                    continue;
                }

                var headers = headerLine.Split(',');
                var colMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < headers.Length; i++)
                    colMap[headers[i].Trim()] = i;

                // Key columns -- use -1 sentinel; 0 would silently read column 0 on miss
                int dayIdx     = colMap.TryGetValue("day",        out var _dIdx)  ? _dIdx  : -1;
                int monthIdx   = colMap.TryGetValue("month",      out var _moIdx) ? _moIdx : -1;
                int yearIdx    = colMap.TryGetValue("year",       out var _yrIdx) ? _yrIdx : -1;
                int zoneIdx    = colMap.TryGetValue("zoneID",     out var _znIdx) ? _znIdx : -1;
                int patchIdx   = colMap.TryGetValue("patchID",    out var _ptIdx) ? _ptIdx : -1;
                int stratumIdx = colMap.TryGetValue("stratumID",  out var _stIdx) ? _stIdx : -1;
                int vegIdx     = colMap.TryGetValue("veg_parm_ID",out var _vgIdx) ? _vgIdx : -1;

                if (dayIdx < 0 || monthIdx < 0 || yearIdx < 0 || zoneIdx < 0 || patchIdx < 0)
                {
                    Console.WriteLine($"[WARN] {def.Role}: missing required column(s) (day/month/year/zoneID/patchID). Skipping file.");
                    continue;
                }

                // Stratum-specific columns: CSV name -> model property name
                var stratumPropMap = def.IsOverstory
                    ? new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
                    {
                        { "consumedCOver", "consumedCOver" },
                        { "mortCOver", "mortCOver" },
                        { "netpsnOver", "netpsnOver" },
                        { "heightOver", "heightOver" },
                        { "transOver", "transOver" },
                        { "leafCOver", "leafCOver" },
                        { "stemCOver", "stemCOver" },
                        { "rootCOver", "rootCOver" },
                        { "rootdepthCOver", "rootdepthCOver" },
                        { "laiOver", "laiOver" },
                    }
                    : new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
                    {
                        { "consumedCUnder", "consumedCUnder" },
                        { "mortCUnder", "mortCUnder" },
                        { "transUnder", "transUnder" },
                        { "netpsnUnder", "netpsnUnder" },
                        { "heightUnder", "heightUnder" },
                        { "leafCUnder", "leafCUnder" },
                        { "stemCUnder", "stemCUnder" },
                        { "rootCUnder", "rootCUnder" },
                        { "rootdepthUnder", "rootdepthUnder" },
                        { "laiUnder", "laiUnder" },
                    };

                // Build column index -> property name map for float columns
                var floatPropMap = new Dictionary<int, string>();
                foreach (var kvp in stratumPropMap)
                {
                    if (colMap.TryGetValue(kvp.Key, out var idx))
                        floatPropMap[idx] = kvp.Value;
                }

                int updated = 0;
                int skipped = 0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line))
                        continue;

                    var parts = line.Split(',');

                    // Compute dateIdx
                    int dateIdx = 0;
                    if (dayIdx >= 0 && monthIdx >= 0 && yearIdx >= 0 &&
                        int.TryParse(GetSafe(parts, dayIdx), out var day) &&
                        int.TryParse(GetSafe(parts, monthIdx), out var month) &&
                        int.TryParse(GetSafe(parts, yearIdx), out var year))
                    {
                        try
                        {
                            var dt = new DateTime(year, month, day);
                            dateIdx = (dt - DailyStart).Days + 1;
                        }
                        catch { dateIdx = 0; }
                    }

                    // Parse spatial key
                    if (!int.TryParse(GetSafe(parts, zoneIdx), out var zoneID) ||
                        !long.TryParse(GetSafe(parts, patchIdx), out var patchID))
                    {
                        skipped++;
                        continue;
                    }

                    if (dryrun)
                    {
                        updated++;
                        continue;
                    }

                    Action<CubeDataRow> updater = row =>
                    {
                        // stratumID and veg_parm_ID map to different properties
                        // depending on whether this is an overstory or understory file
                        if (stratumIdx >= 0 && long.TryParse(GetSafe(parts, stratumIdx), out var sid))
                        {
                            if (def.IsOverstory) row.stratumIDOver = sid;
                            else row.stratumIDUnder = sid;
                        }
                        if (vegIdx >= 0 && int.TryParse(GetSafe(parts, vegIdx), out var vid))
                        {
                            if (def.IsOverstory) row.vegParmIDOver = vid;
                            else row.vegParmIDUnder = vid;
                        }

                        // Float stratum columns
                        foreach (var kvp in floatPropMap)
                        {
                            int col = kvp.Key;
                            var propName = kvp.Value;
                            if (col < 0 || col >= parts.Length)
                                continue;
                            var raw = parts[col]?.Trim();
                            if (string.IsNullOrWhiteSpace(raw))
                                continue;
                            if (float.TryParse(raw, out var f))
                            {
                                var prop = typeof(CubeDataRow).GetProperty(propName);
                                prop?.SetValue(row, f);
                            }
                        }
                    };

                    if (dal.UpdateCubeDataStratum(dateIdx, zoneID, patchID,
                        config.ScenarioRunId ?? "", config.WarmingIdx ?? 0, updater))
                        updated++;
                    else
                        skipped++;
                }

                Console.WriteLine($"[CubeData/{def.Role}] {(dryrun ? "Would update" : "Updated")} {updated:N0} rows, skipped {skipped:N0}.");
            }
        }

        /// <summary>
        /// Imports the monthly basin burn file (<c>bm.csv</c>) into the
        /// <c>FireData</c> table as <c>level = "basin"</c> rows.
        /// </summary>
        public static void ImportBasinBurnData(ScenarioConfig config, bool dryrun = false)
        {
            var path = config.GetSourceFilePath("basinMonthlyBurn");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] basinMonthlyBurn file not found: {path}");
                return;
            }

            var dal = new CentralCoastDAL();
            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                Console.WriteLine("[WARN] basinMonthlyBurn file has empty header.");
                return;
            }

            var headers = headerLine.Split(',');
            var colMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < headers.Length; i++)
                colMap[headers[i].Trim()] = i;

            int mIdx   = colMap.TryGetValue("month",   out var _mIdx)   ? _mIdx   : -1;
            int yIdx   = colMap.TryGetValue("year",    out var _yIdx)   ? _yIdx   : -1;
            int bIdx   = colMap.TryGetValue("basinID", out var _bIdx)   ? _bIdx   : -1;
            int burnIdx = colMap.TryGetValue("burn",   out var _burnIdx) ? _burnIdx : -1;

            if (mIdx < 0 || yIdx < 0 || bIdx < 0 || burnIdx < 0)
            {
                Console.WriteLine($"[WARN] basinMonthlyBurn: missing required column(s). mIdx={mIdx} yIdx={yIdx} bIdx={bIdx} burnIdx={burnIdx}. Skipping file.");
                return;
            }

            var batch = new List<FireDataRow>();
            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');

                var row = new FireDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    warmingIdx = config.WarmingIdx ?? 0,
                    importRunId = 0,
                    sourceFile = Path.GetFileName(path),
                    level = "basin",
                    hillID = null,
                    zoneID = null,
                    patchID = null
                };

                if (int.TryParse(GetSafe(parts, mIdx), out var month))
                    row.month = month;
                if (int.TryParse(GetSafe(parts, yIdx), out var year))
                    row.year = year;
                if (int.TryParse(GetSafe(parts, bIdx), out var basinID))
                    row.basinID = basinID;
                if (float.TryParse(GetSafe(parts, burnIdx), out var burn))
                    row.burn = burn;

                imported++;
                if (!dryrun)
                    batch.Add(row);
            }

            if (!dryrun && batch.Count > 0)
                dal.AddFireDataRows(batch);

            Console.WriteLine($"[FireData/basin] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Imports the monthly all-patch burn file
        /// (<c>spatial_data_point_patchvar.csv</c>) into the <c>FireData</c>
        /// table as <c>level = "patch"</c> rows.
        /// </summary>
        public static void ImportPatchBurnData(ScenarioConfig config, bool dryrun = false)
        {
            var path = config.GetSourceFilePath("patchMonthlyBurn");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] patchMonthlyBurn file not found: {path}");
                return;
            }

            var dal = new CentralCoastDAL();
            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                Console.WriteLine("[WARN] patchMonthlyBurn file has empty header.");
                return;
            }

            var headers = headerLine.Split(',');
            var colMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < headers.Length; i++)
                colMap[headers[i].Trim()] = i;

            int mIdx    = colMap.TryGetValue("month",   out var _mIdx2)   ? _mIdx2   : -1;
            int yIdx    = colMap.TryGetValue("year",    out var _yIdx2)   ? _yIdx2   : -1;
            int bIdx    = colMap.TryGetValue("basinID", out var _bIdx2)   ? _bIdx2   : -1;
            int hIdx    = colMap.TryGetValue("hillID",  out var _hIdx2)   ? _hIdx2   : -1;
            int zIdx    = colMap.TryGetValue("zoneID",  out var _zIdx2)   ? _zIdx2   : -1;
            int pIdx    = colMap.TryGetValue("patchID", out var _pIdx2)   ? _pIdx2   : -1;
            int burnIdx = colMap.TryGetValue("burn",    out var _burnIdx2) ? _burnIdx2 : -1;

            if (mIdx < 0 || yIdx < 0 || zIdx < 0 || pIdx < 0 || burnIdx < 0)
            {
                Console.WriteLine($"[WARN] patchMonthlyBurn: missing required column(s). mIdx={mIdx} yIdx={yIdx} zIdx={zIdx} pIdx={pIdx} burnIdx={burnIdx}. Skipping file.");
                return;
            }

            var batch = new List<FireDataRow>();
            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');

                var row = new FireDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    warmingIdx = config.WarmingIdx ?? 0,
                    importRunId = 0,
                    sourceFile = Path.GetFileName(path),
                    level = "patch"
                };

                if (mIdx >= 0 && int.TryParse(GetSafe(parts, mIdx), out var month))
                    row.month = month;
                if (yIdx >= 0 && int.TryParse(GetSafe(parts, yIdx), out var year))
                    row.year = year;
                if (bIdx >= 0 && int.TryParse(GetSafe(parts, bIdx), out var basinID))
                    row.basinID = basinID;
                if (hIdx >= 0 && int.TryParse(GetSafe(parts, hIdx), out var hillID))
                    row.hillID = hillID;
                if (zIdx >= 0 && int.TryParse(GetSafe(parts, zIdx), out var zoneID))
                    row.zoneID = zoneID;
                if (pIdx >= 0 && long.TryParse(GetSafe(parts, pIdx), out var patchID))
                    row.patchID = patchID;
                if (burnIdx >= 0 && float.TryParse(GetSafe(parts, burnIdx), out var burn))
                    row.burn = burn;

                imported++;
                if (!dryrun)
                    batch.Add(row);
            }

            if (!dryrun && batch.Count > 0)
                dal.AddFireDataRows(batch);

            Console.WriteLine($"[FireData/patch] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Imports the monthly all-stratum carbon file
        /// (<c>spatial_data_point_stratvar.csv</c>) into the
        /// <c>StratumData</c> table.
        /// </summary>
        public static void ImportStratumCarbonData(ScenarioConfig config, bool dryrun = false)
        {
            var path = config.GetSourceFilePath("stratumMonthlyCarbon");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] stratumMonthlyCarbon file not found: {path}");
                return;
            }

            var dal = new CentralCoastDAL();
            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                Console.WriteLine("[WARN] stratumMonthlyCarbon file has empty header.");
                return;
            }

            var headers = headerLine.Split(',');
            var propertyMap = BuildPropertyMap<StratumDataRow>(headers);

            // Pre-resolve key columns
            int mIdx = -1, yIdx = -1;
            for (int i = 0; i < headers.Length; i++)
            {
                var h = headers[i].Trim().ToLowerInvariant();
                if (h == "month") mIdx = i;
                else if (h == "year") yIdx = i;
            }

            const int ChunkSize = 10_000;
            var chunk = new List<StratumDataRow>(ChunkSize);
            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');
                var row = new StratumDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    warmingIdx = config.WarmingIdx ?? 0,
                    importRunId = 0,
                    sourceFile = Path.GetFileName(path)
                };

                if (mIdx >= 0 && int.TryParse(GetSafe(parts, mIdx), out var month))
                    row.month = month;
                if (yIdx >= 0 && int.TryParse(GetSafe(parts, yIdx), out var year))
                    row.year = year;

                // Map remaining columns via reflection
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
                {
                    chunk.Add(row);
                    if (chunk.Count >= ChunkSize)
                    {
                        dal.AddStratumDataRows(chunk);
                        chunk.Clear();
                        Console.WriteLine($"[StratumData] {imported:N0} rows written...");
                    }
                }
            }

            if (!dryrun && chunk.Count > 0)
                dal.AddStratumDataRows(chunk);

            Console.WriteLine($"[StratumData] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Decodes <c>Pch30rip90upRN.tiff</c> into one <c>PatchData</c> row
        /// per unique <c>zoneID</c>. Each row stores the full pixel footprint
        /// (col, row pairs), bounding box, centroid, and pixel count serialized
        /// as JSON in the <c>data</c> column.
        ///
        /// Coordinates are zero-based (col, row) with origin at upper-left of
        /// the TIFF. Nodata value 65535 is skipped.
        /// </summary>
        public static void ImportPatchMapData(ScenarioConfig config, bool dryrun = false)
        {
            var path = config.GetSourceFilePath("patchFamilyRaster");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] patchFamilyRaster file not found: {path}");
                return;
            }

            // keyed by zoneID -> list of [col, row]
            var pixelsByZone = new Dictionary<int, List<int[]>>();

            int gridWidth = 0;
            int gridHeight = 0;

            using (var tiff = Tiff.Open(path, "r"))
            {
                if (tiff == null)
                {
                    Console.WriteLine($"[ERROR] Could not open TIFF: {path}");
                    return;
                }

                gridWidth = tiff.GetField(TiffTag.IMAGEWIDTH)[0].ToInt();
                gridHeight = tiff.GetField(TiffTag.IMAGELENGTH)[0].ToInt();

                int scanlineSize = tiff.ScanlineSize();
                byte[] buf = new byte[scanlineSize];

                for (int row = 0; row < gridHeight; row++)
                {
                    tiff.ReadScanline(buf, row);
                    // Each pixel is a 16-bit unsigned value (2 bytes, little-endian)
                    for (int col = 0; col < gridWidth; col++)
                    {
                        int byteOffset = col * 2;
                        if (byteOffset + 1 >= buf.Length)
                            continue;
                        int value = buf[byteOffset] | (buf[byteOffset + 1] << 8);
                        if (value == 65535)
                            continue; // nodata

                        if (!pixelsByZone.TryGetValue(value, out var list))
                        {
                            list = new List<int[]>();
                            pixelsByZone[value] = list;
                        }
                        list.Add(new[] { col, row });
                    }
                }
            }

            int totalPixels = pixelsByZone.Values.Sum(l => l.Count);
            Console.WriteLine($"[PatchData] Decoded {pixelsByZone.Count:N0} unique zoneIDs from {gridWidth}x{gridHeight} grid ({totalPixels:N0} total non-nodata pixels).");

            if (dryrun)
            {
                Console.WriteLine($"[PatchData] Dry run: would write {pixelsByZone.Count:N0} rows to PatchData.");
                return;
            }

            var dal = new CentralCoastDAL();
            int written = 0;

            foreach (var kvp in pixelsByZone)
            {
                int zoneID = kvp.Key;
                var pixels = kvp.Value;

                int colMin = pixels.Min(p => p[0]);
                int colMax = pixels.Max(p => p[0]);
                int rowMin = pixels.Min(p => p[1]);
                int rowMax = pixels.Max(p => p[1]);
                double centroidCol = pixels.Average(p => p[0]);
                double centroidRow = pixels.Average(p => p[1]);

                var footprint = new
                {
                    zoneID,
                    gridWidth,
                    gridHeight,
                    pixelCount = pixels.Count,
                    centroidCol = Math.Round(centroidCol, 2),
                    centroidRow = Math.Round(centroidRow, 2),
                    boundingBox = new { colMin, colMax, rowMin, rowMax },
                    pixels
                };

                var row = new PatchDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    importRunId = 0,
                    zoneID = zoneID,
                    data = JsonConvert.SerializeObject(footprint)
                };

                dal.AddPatchDataRow(row);
                written++;
            }

            Console.WriteLine($"[PatchData] Imported {written:N0} rows.");
        }

        /// <summary>
        /// Generates precomputed <c>TerrainData</c> frames for Central Coast v2.
        ///
        /// For each unique (year, month) in <c>StratumData</c>, reads all
        /// <c>PatchData</c> footprints, aggregates mean <c>total_plantc</c> and
        /// max <c>burn</c> per <c>zoneID</c>, and writes one <c>TerrainDataRow</c>
        /// containing a flat 396x301 float array encoded as
        /// <c>vegIntensity + burnSignal * 100</c>.
        ///
        /// See <c>Docs/CentralCoastV2/TerrainDataPlan.md</c> for full design.
        /// </summary>
        public static void GenerateTerrainData(ScenarioConfig config, bool dryrun = false)
        {
            const int GridWidth = 396;
            const int GridHeight = 301;
            const int PixelGrainSize = 30;
            const int DecimalPrecision = 4;
            const int TotalPixels = GridWidth * GridHeight; // 119,196

            var scenarioRunId = config.ScenarioRunId ?? "";
            int warmingIdx = config.WarmingIdx ?? 0;

            Console.WriteLine($"[TerrainData] Loading PatchData footprints for scenarioRunId={scenarioRunId}...");

            // Step 1: load all PatchData pixel lists into memory
            // zoneID -> flat array of linear indices (row * GridWidth + col)
            var zonePixels = new Dictionary<int, List<int>>();
            using (var db = new CentralCoastDbContext())
            {
                var patchRows = db.PatchData
                    .Where(p => p.scenarioRunId == scenarioRunId)
                    .ToList();

                foreach (var prow in patchRows)
                {
                    if (string.IsNullOrWhiteSpace(prow.data))
                        continue;

                    dynamic footprint = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(prow.data);
                    var pixelList = new List<int>();
                    foreach (var px in footprint.pixels)
                    {
                        int col = (int)px[0];
                        int row = (int)px[1];
                        pixelList.Add(row * GridWidth + col);
                    }
                    zonePixels[prow.zoneID] = pixelList;
                }
            }

            Console.WriteLine($"[TerrainData] Loaded {zonePixels.Count:N0} zoneID footprints.");

            // Step 2: compute globalMaxPlantC across all months/zones
            float globalMaxPlantC;
            using (var db = new CentralCoastDbContext())
            {
                globalMaxPlantC = db.StratumData
                    .Where(s => s.scenarioRunId == scenarioRunId && s.warmingIdx == warmingIdx)
                    .Select(s => s.total_plantc)
                    .DefaultIfEmpty(1f)
                    .Max();
            }

            if (globalMaxPlantC <= 0f) globalMaxPlantC = 1f;
            Console.WriteLine($"[TerrainData] globalMaxPlantC = {globalMaxPlantC:F4}");

            // Step 3: enumerate distinct (year, month) pairs
            List<(int year, int month)> timePeriods;
            using (var db = new CentralCoastDbContext())
            {
                timePeriods = db.StratumData
                    .Where(s => s.scenarioRunId == scenarioRunId && s.warmingIdx == warmingIdx)
                    .Select(s => new { s.year, s.month })
                    .Distinct()
                    .OrderBy(x => x.year).ThenBy(x => x.month)
                    .ToList()
                    .Select(x => (x.year, x.month))
                    .ToList();
            }

            Console.WriteLine($"[TerrainData] {timePeriods.Count:N0} monthly frames to generate.");
            if (dryrun)
            {
                Console.WriteLine($"[TerrainData] Dry run: would write {timePeriods.Count:N0} TerrainData rows.");
                return;
            }

            var dal = new CentralCoastDAL();
            var terrainBatch = new List<TerrainDataRow>();
            int written = 0;

            foreach (var (year, month) in timePeriods)
            {
                // Step 4a: aggregate StratumData for this (year, month)
                Dictionary<int, float> meanPlantCByZone;
                using (var db = new CentralCoastDbContext())
                {
                    meanPlantCByZone = db.StratumData
                        .Where(s => s.scenarioRunId == scenarioRunId &&
                                    s.warmingIdx == warmingIdx &&
                                    s.year == year &&
                                    s.month == month)
                        .GroupBy(s => s.zoneID)
                        .Select(g => new { zoneID = g.Key, meanC = g.Average(s => s.total_plantc) })
                        .ToDictionary(x => x.zoneID, x => x.meanC);
                }

                // Step 4b: aggregate FireData for this (year, month)
                Dictionary<int, float> maxBurnByZone;
                using (var db = new CentralCoastDbContext())
                {
                    maxBurnByZone = db.FireData
                        .Where(f => f.scenarioRunId == scenarioRunId &&
                                    f.warmingIdx == warmingIdx &&
                                    f.year == year &&
                                    f.month == month &&
                                    f.level == "patch" &&
                                    f.zoneID != null)
                        .GroupBy(f => f.zoneID!.Value)
                        .Select(g => new { zoneID = g.Key, maxBurn = g.Max(f => f.burn) })
                        .ToDictionary(x => x.zoneID, x => x.maxBurn);
                }

                // Step 4c: build output float array
                float[] output = new float[TotalPixels]; // default 0.0

                foreach (var kvp in zonePixels)
                {
                    int zoneID = kvp.Key;

                    float meanC = meanPlantCByZone.TryGetValue(zoneID, out var mc) ? mc : 0f;
                    float maxBurn = maxBurnByZone.TryGetValue(zoneID, out var mb) ? mb : 0f;

                    float vegIntensity = Math.Clamp(meanC / globalMaxPlantC, 0f, 1f);
                    float burnSignal = maxBurn > 0f ? 1f : 0f;
                    float value = (float)Math.Round(vegIntensity + burnSignal * 100f, DecimalPrecision);

                    foreach (int idx in kvp.Value)
                    {
                        if (idx >= 0 && idx < TotalPixels)
                            output[idx] = value;
                    }
                }

                // Step 4d: serialize and write
                string dataList = Newtonsoft.Json.JsonConvert.SerializeObject(output);

                var row = new TerrainDataRow
                {
                    scenarioRunId = scenarioRunId,
                    warmingIdx = warmingIdx,
                    year = year,
                    month = month,
                    gridSize = 0,
                    gridWidth = GridWidth,
                    gridHeight = GridHeight,
                    pixelGrainSize = PixelGrainSize,
                    decimalPrecision = DecimalPrecision,
                    _dataList = dataList
                };

                terrainBatch.Add(row);
                written++;

                if (written % 12 == 0)
                    Console.WriteLine($"[TerrainData] {written:N0}/{timePeriods.Count:N0} frames written...");
            }

            if (terrainBatch.Count > 0)
                dal.AddTerrainDataRows(terrainBatch);

            Console.WriteLine($"[TerrainData] Generated {written:N0} TerrainData rows.");
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
