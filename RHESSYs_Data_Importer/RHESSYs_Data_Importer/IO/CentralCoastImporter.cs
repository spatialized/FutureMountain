using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using BitMiracle.LibTiff.Classic; // BitMiracle.LibTiff.NET package
using Newtonsoft.Json;
using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.DAL;
using RHESSYs_Data_Importer.Models;
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
        /// <summary>
        /// Derives the calendar once per import session and caches it so all
        /// import methods within one run share the same <c>dateIdx</c> mapping.
        /// </summary>
        private static Dictionary<DateTime, int>? _dateIndexCache;
        private static string? _dateIndexCacheKey;

        private static Dictionary<DateTime, int> GetDateIndex(ScenarioConfig config)
        {
            var key = config.ScenarioRunId + "|" + config.GetSourceFilePath("cubeAggregateDaily");
            if (_dateIndexCache != null && _dateIndexCacheKey == key)
                return _dateIndexCache;
            _dateIndexCache = CentralCoastCalendar.BuildDateIndex(config);
            _dateIndexCacheKey = key;
            return _dateIndexCache;
        }

        /// <summary>
        /// Derives the daily calendar from <c>cubeAggregateDaily</c> and
        /// populates the shared <c>Dates</c> table.  Idempotent: if the table
        /// already contains a consistent calendar it is left untouched.
        /// </summary>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the existing <c>Dates</c> table content does not match the
        /// derived calendar (wrong count or date range). Clear the table manually
        /// and re-run with <c>--dates</c>.
        /// </exception>
        public static void ImportDates(ScenarioConfig config, bool dryrun = false)
        {
            Console.WriteLine("[Dates] Deriving calendar from cubeAggregateDaily...");
            List<DateTime> calendar;
            try
            {
                calendar = CentralCoastCalendar.DeriveCalendar(config);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] {ex.Message}");
                return;
            }

            Console.WriteLine($"[Dates] Derived {calendar.Count:N0} distinct dates: " +
                              $"{calendar[0]:yyyy-MM-dd} – {calendar[^1]:yyyy-MM-dd}.");

            if (dryrun)
            {
                Console.WriteLine($"[Dates] Would insert {calendar.Count:N0} rows (dry run).");
                return;
            }

            var dal = new CentralCoastDAL();
            bool alreadyValid;
            try
            {
                alreadyValid = dal.EnsureDatesCalendarValid(calendar);
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine($"[ERROR] {ex.Message}");
                throw;
            }

            if (alreadyValid)
            {
                Console.WriteLine($"[Dates] Table already consistent ({calendar.Count:N0} rows). Skipping insert.");
                return;
            }

            // Build Date objects — EF will assign identity IDs sequentially.
            var rows = new List<Date>(calendar.Count);
            for (int i = 0; i < calendar.Count; i++)
            {
                var dt = calendar[i];
                rows.Add(new Date
                {
                    date  = dt,
                    year  = dt.Year,
                    month = dt.Month,
                    day   = dt.Day,
                });
            }

            int inserted = dal.AddDateRows(rows);
            Console.WriteLine($"[Dates] Inserted {inserted:N0} rows.");
        }

        /// <summary>
        /// Ensures the <c>Dates</c> table is populated and consistent before
        /// running imports that depend on <c>dateIdx</c>.  If the table is empty
        /// it is automatically populated; if it is non-empty but mismatched an
        /// exception is thrown.
        /// </summary>
        public static void EnsureOrPopulateDates(ScenarioConfig config, bool dryrun = false)
        {
            List<DateTime> calendar;
            try
            {
                calendar = CentralCoastCalendar.DeriveCalendar(config);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] Cannot derive calendar: {ex.Message}");
                throw;
            }

            var dal = new CentralCoastDAL();
            bool alreadyValid;
            try
            {
                alreadyValid = dal.EnsureDatesCalendarValid(calendar);
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine($"[ERROR] {ex.Message}");
                throw;
            }

            if (alreadyValid)
            {
                Console.WriteLine($"[Dates] Pre-import check: table consistent ({calendar.Count:N0} rows). OK.");
                return;
            }

            if (dryrun)
            {
                Console.WriteLine($"[Dates] Table is empty — would auto-populate {calendar.Count:N0} rows (dry run).");
                return;
            }

            Console.WriteLine($"[Dates] Table is empty — auto-populating from calendar ({calendar.Count:N0} rows)...");
            var rows = new List<Date>(calendar.Count);
            for (int i = 0; i < calendar.Count; i++)
            {
                var dt = calendar[i];
                rows.Add(new Date { date = dt, year = dt.Year, month = dt.Month, day = dt.Day });
            }
            int inserted = dal.AddDateRows(rows);
            Console.WriteLine($"[Dates] Auto-populated {inserted:N0} rows.");
        }

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

            const int ChunkSize = 5_000;
            var chunk = new List<WaterDataRow>(ChunkSize);
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

                // Compute dateIdx from day/month/year — required; fail loudly if absent or unmapped
                if (dayIdx < 0 || monthIdx < 0 || yearIdx < 0)
                    throw new InvalidOperationException(
                        "[WaterData] Source file is missing day/month/year column(s). Cannot compute dateIdx.");

                if (!int.TryParse(GetSafe(parts, dayIdx),   out var day)   ||
                    !int.TryParse(GetSafe(parts, monthIdx), out var month) ||
                    !int.TryParse(GetSafe(parts, yearIdx),  out var year))
                    throw new InvalidOperationException(
                        $"[WaterData] Row {imported + 1}: could not parse day/month/year from '" +
                        $"{GetSafe(parts, dayIdx)}/{GetSafe(parts, monthIdx)}/{GetSafe(parts, yearIdx)}'.");

                DateTime wdt;
                try { wdt = new DateTime(year, month, day); }
                catch { throw new InvalidOperationException(
                    $"[WaterData] Row {imported + 1}: invalid date {year}-{month:D2}-{day:D2}."); }

                var widx = GetDateIndex(config);
                if (!widx.TryGetValue(wdt, out var wdi))
                    throw new InvalidOperationException(
                        $"[WaterData] Row {imported + 1}: date {wdt:yyyy-MM-dd} not found in derived calendar.");
                row.dateIdx = wdi;

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
                {
                    chunk.Add(row);
                    if (chunk.Count >= ChunkSize)
                    {
                        dal.AddWaterDataRows(chunk);
                        chunk.Clear();
                        Console.WriteLine($"[WaterData] {imported:N0} rows written...");
                    }
                }
            }

            if (!dryrun && chunk.Count > 0)
                dal.AddWaterDataRows(chunk);

            Console.WriteLine($"[WaterData] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Imports daily cube patch files (<c>cube_p_patch1.csv</c>,
        /// <c>cube_p_patch2.csv</c>) into the <c>CubeData</c> table.
        /// Also imports the daily aggregate cube file (<c>cube_agg_p.csv</c>)
        /// with <c>patchID = -1</c>, matching the legacy Big Creek aggregate
        /// cube convention used by Unity.
        /// Stratum columns (overstory/understory) are not populated here;
        /// they are filled by the stratum importer (CCV2-09).
        /// </summary>
        public static void ImportCubePatchData(ScenarioConfig config, bool dryrun = false)
        {
            ImportCubeAggregateData(config, dryrun);

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

                const int ChunkSize = 5_000;
                var chunk = new List<CubeDataRow>(ChunkSize);
                int imported = 0;
                int savedRows = 0;
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

                    // Compute dateIdx — required; fail loudly if absent or unmapped
                    if (dayIdx < 0 || monthIdx < 0 || yearIdx < 0)
                        throw new InvalidOperationException(
                            $"[CubeData/{role}] Source file is missing day/month/year column(s). Cannot compute dateIdx.");

                    if (!int.TryParse(GetSafe(parts, dayIdx),   out var day)   ||
                        !int.TryParse(GetSafe(parts, monthIdx), out var month) ||
                        !int.TryParse(GetSafe(parts, yearIdx),  out var year))
                        throw new InvalidOperationException(
                            $"[CubeData/{role}] Row {imported + 1}: could not parse day/month/year from '" +
                            $"{GetSafe(parts, dayIdx)}/{GetSafe(parts, monthIdx)}/{GetSafe(parts, yearIdx)}'.");

                    DateTime cdt;
                    try { cdt = new DateTime(year, month, day); }
                    catch { throw new InvalidOperationException(
                        $"[CubeData/{role}] Row {imported + 1}: invalid date {year}-{month:D2}-{day:D2}."); }

                    var cidx = GetDateIndex(config);
                    if (!cidx.TryGetValue(cdt, out var cdi))
                        throw new InvalidOperationException(
                            $"[CubeData/{role}] Row {imported + 1}: date {cdt:yyyy-MM-dd} not found in derived calendar.");
                    row.dateIdx = cdi;

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
                    {
                        chunk.Add(row);
                        if (chunk.Count >= ChunkSize)
                        {
                            savedRows += dal.AddCubeDataRows(chunk);
                            chunk.Clear();
                            Console.WriteLine($"[CubeData/{role}] {imported:N0} rows processed, {savedRows:N0} rows written...");
                        }
                    }
                }

                if (!dryrun && chunk.Count > 0)
                    savedRows += dal.AddCubeDataRows(chunk);

                if (!dryrun && savedRows != imported)
                    Console.WriteLine($"[ERROR] [CubeData/{role}] Saved {savedRows:N0} of {imported:N0} source rows.");

                Console.WriteLine($"[CubeData/{role}] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
            }
        }

        private static void ImportCubeAggregateData(ScenarioConfig config, bool dryrun = false)
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
            var colMap = BuildColumnIndex(headers);
            int dayIdx = GetColumnIndex(colMap, "day");
            int monthIdx = GetColumnIndex(colMap, "month");
            int yearIdx = GetColumnIndex(colMap, "year");

            const int ChunkSize = 5_000;
            var chunk = new List<CubeDataRow>(ChunkSize);
            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');
                if (dayIdx < 0 || monthIdx < 0 || yearIdx < 0)
                    throw new InvalidOperationException(
                        "[CubeData/cubeAggregateDaily] Source file is missing day/month/year column(s). Cannot compute dateIdx.");

                if (!int.TryParse(GetSafe(parts, dayIdx), out var day) ||
                    !int.TryParse(GetSafe(parts, monthIdx), out var month) ||
                    !int.TryParse(GetSafe(parts, yearIdx), out var year))
                    throw new InvalidOperationException(
                        $"[CubeData/cubeAggregateDaily] Row {imported + 1}: could not parse day/month/year.");

                DateTime dt;
                try { dt = new DateTime(year, month, day); }
                catch
                {
                    throw new InvalidOperationException(
                        $"[CubeData/cubeAggregateDaily] Row {imported + 1}: invalid date {year}-{month:D2}-{day:D2}.");
                }

                var dateIndex = GetDateIndex(config);
                if (!dateIndex.TryGetValue(dt, out var dateIdx))
                    throw new InvalidOperationException(
                        $"[CubeData/cubeAggregateDaily] Row {imported + 1}: date {dt:yyyy-MM-dd} not found in derived calendar.");

                var liveStem = GetFloat(parts, colMap, "cs_live_stemc");
                var deadStem = GetFloat(parts, colMap, "cs_dead_stemc");
                var fineRoot = GetFloat(parts, colMap, "cs_frootc");
                var liveRoot = GetFloat(parts, colMap, "cs_live_crootc");
                var deadRoot = GetFloat(parts, colMap, "cs_dead_crootc");
                var evaporation = GetFloat(parts, colMap, "evaporation");
                var surfaceEvap = GetFloat(parts, colMap, "evaporation_surf");
                var streamflow = GetFloat(parts, colMap, "streamflow");

                var row = new CubeDataRow
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    warmingIdx = config.WarmingIdx ?? 0,
                    importRunId = 0,
                    dateIdx = dateIdx,
                    basinID = GetInt(parts, colMap, "basinID"),
                    hillID = -1,
                    zoneID = -1,
                    patchID = -1,
                    coverfract = GetFloat(parts, colMap, "family_pct_cover"),
                    litterc = GetFloat(parts, colMap, "litter_cs_totalc"),
                    burn = GetFloat(parts, colMap, "burn"),
                    soilc = GetFloat(parts, colMap, "soil_cs_totalc"),
                    depthToGW = GetFloat(parts, colMap, "sat_deficit_z"),
                    canopyevap = evaporation - surfaceEvap,
                    streamflow = streamflow,
                    rootdepth = GetFloat(parts, colMap, "rootzone_depth"),
                    groundevap = surfaceEvap,
                    vegAccessWater = GetFloat(parts, colMap, "rz_storage"),
                    Qin = 0,
                    Qout = streamflow,
                    rain = GetFloat(parts, colMap, "rain"),
                    netpsnOver = GetFloat(parts, colMap, "cs_net_psn"),
                    heightOver = GetFloat(parts, colMap, "epv_height"),
                    leafCOver = GetFloat(parts, colMap, "cs_leafc") + GetFloat(parts, colMap, "cs_leafc_store"),
                    stemCOver = liveStem + deadStem,
                    rootCOver = fineRoot + liveRoot + deadRoot
                };

                imported++;
                if (!dryrun)
                {
                    chunk.Add(row);
                    if (chunk.Count >= ChunkSize)
                    {
                        dal.AddCubeDataRows(chunk);
                        chunk.Clear();
                        Console.WriteLine($"[CubeData/cubeAggregateDaily] {imported:N0} aggregate rows written...");
                    }
                }
            }

            if (!dryrun && chunk.Count > 0)
                dal.AddCubeDataRows(chunk);

            Console.WriteLine($"[CubeData/cubeAggregateDaily] {(dryrun ? "Would import" : "Imported")} {imported:N0} aggregate rows from {Path.GetFileName(path)}.");
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

                if (dryrun)
                {
                    string line;
                    while ((line = reader.ReadLine()) != null)
                    {
                        if (string.IsNullOrWhiteSpace(line)) continue;
                        var parts = line.Split(',');
                        if (int.TryParse(GetSafe(parts, zoneIdx), out _) &&
                            long.TryParse(GetSafe(parts, patchIdx), out _))
                            updated++;
                        else
                            skipped++;
                    }
                    Console.WriteLine($"[CubeData/{def.Role}] Would update {updated:N0} rows, skipped {skipped:N0}.");
                    continue;
                }

                // Bulk strategy: load all CubeData for this scenario into memory once,
                // apply updates, then flush in chunks — avoids one SELECT+UPDATE per row.
                Console.WriteLine($"[CubeData/{def.Role}] Loading existing rows into memory...");
                var (db, lookup) = dal.OpenCubeDataLookup(
                    config.ScenarioRunId ?? "", config.WarmingIdx ?? 0);

                var touchedRows = new HashSet<CubeDataRow>();
                string sline;
                while ((sline = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(sline)) continue;

                    var parts = sline.Split(',');

                    int dateIdx = 0;
                    if (dayIdx >= 0 && monthIdx >= 0 && yearIdx >= 0 &&
                        int.TryParse(GetSafe(parts, dayIdx), out var day) &&
                        int.TryParse(GetSafe(parts, monthIdx), out var month) &&
                        int.TryParse(GetSafe(parts, yearIdx), out var year))
                    {
                        try
                        {
                            var dt = new DateTime(year, month, day);
                            var calIdx = GetDateIndex(config);
                            dateIdx = calIdx.TryGetValue(dt, out var di) ? di : 0;
                        }
                        catch { dateIdx = 0; }
                    }

                    if (!int.TryParse(GetSafe(parts, zoneIdx), out var zoneID) ||
                        !long.TryParse(GetSafe(parts, patchIdx), out var patchID))
                    {
                        skipped++;
                        continue;
                    }

                    if (!lookup.TryGetValue((dateIdx, zoneID, patchID), out var row))
                    {
                        skipped++;
                        continue;
                    }

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
                    foreach (var kvp in floatPropMap)
                    {
                        if (kvp.Key < 0 || kvp.Key >= parts.Length) continue;
                        var raw = parts[kvp.Key]?.Trim();
                        if (!string.IsNullOrWhiteSpace(raw) && float.TryParse(raw, out var f))
                            typeof(CubeDataRow).GetProperty(kvp.Value)?.SetValue(row, f);
                    }
                    updated++;
                    touchedRows.Add(row);
                }

                int saved = CentralCoastDAL.SaveCubeDataRows(db, touchedRows);
                db.Dispose();
                Console.WriteLine($"[CubeData/{def.Role}] Updated {updated:N0} rows (saved {saved:N0}), skipped {skipped:N0}.");
            }
        }

        /// <summary>
        /// Imports the monthly basin burn file (<c>bm.csv</c>) into the
        /// <c>BurnData</c> table as <c>level = "basin"</c> rows.
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

            var batch = new List<BurnDataRow>();
            int imported = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');

                var row = new BurnDataRow
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
                dal.AddBurnDataRows(batch);

            Console.WriteLine($"[BurnData/basin] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Imports the monthly all-patch burn file
        /// (<c>spatial_data_point_patchvar.csv</c>) into the <c>BurnData</c>
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

            const int ChunkSize = 10_000;
            var batch = new List<BurnDataRow>(ChunkSize);
            int imported = 0;
            int savedRows = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var parts = line.Split(',');

                var row = new BurnDataRow
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
                {
                    batch.Add(row);
                    if (batch.Count >= ChunkSize)
                    {
                        savedRows += dal.AddBurnDataRows(batch);
                        batch.Clear();
                        Console.WriteLine($"[BurnData/patch] {imported:N0} rows processed, {savedRows:N0} rows written...");
                    }
                }
            }

            if (!dryrun && batch.Count > 0)
                savedRows += dal.AddBurnDataRows(batch);

            if (!dryrun && savedRows != imported)
                Console.WriteLine($"[ERROR] [BurnData/patch] Saved {savedRows:N0} of {imported:N0} source rows.");

            Console.WriteLine($"[BurnData/patch] {(dryrun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
        }

        /// <summary>
        /// Central Coast v2 fire-frame import entry point.
        ///
        /// FireData is reserved for Unity-compatible instantaneous fire playback
        /// frames: event date, landscape fire grid dimensions, and serialized
        /// FireDataPoint values containing patch/zone id, spread, and iter/order.
        ///
        /// The current Central Coast source bundle has monthly BurnData, but not
        /// fire-frame spread/iter source files. This method is intentionally
        /// present so <c>--fire</c> has a concrete pipeline hook and can report
        /// the missing source roles clearly.
        /// </summary>
        public static void ImportFireData(ScenarioConfig config, bool dryrun = false)
        {
            var spreadIterPath = config.GetSourceFilePath("fireFrameSpreadIter");

            bool hasSpreadIterRole = !string.IsNullOrWhiteSpace(spreadIterPath);

            if (!hasSpreadIterRole)
            {
                Console.WriteLine("[FireData] Central Coast fire-frame import scaffold is active.");
                Console.WriteLine("[FireData] No Central Coast fire-frame source is configured yet; 0 FireData rows written.");
                Console.WriteLine("[FireData] FireData will use existing PatchData as the landscape patch/zone grid map.");
                Console.WriteLine("[FireData] Expected ScenarioConfig file role when source data exists:");
                Console.WriteLine("[FireData]   fireFrameSpreadIter -> event rows with date, patch/zone id, spread, and iter/order");
                Console.WriteLine("[FireData] Monthly RHESSys burn remains separate and is imported with --burn into BurnData.");
                return;
            }

            bool spreadIterExists = File.Exists(spreadIterPath);

            if (!spreadIterExists)
            {
                Console.WriteLine($"[FireData][WARN] fireFrameSpreadIter file not found: {spreadIterPath}");
                Console.WriteLine("[FireData] 0 FireData rows written.");
                return;
            }

            Console.WriteLine("[FireData][ERROR] Central Coast fire-frame source roles are configured and files exist, but the concrete parser has not been wired for this source format yet.");
            Console.WriteLine("[FireData][ERROR] Do not import these files as BurnData. FireData requires Unity fire-frame records with spread/iter playback data.");
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
            int saved = 0;
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
                        saved += dal.AddStratumDataRows(chunk);
                        chunk.Clear();
                        Console.WriteLine($"[StratumData] {imported:N0} rows read, {saved:N0} saved...");
                    }
                }
            }

            if (!dryrun && chunk.Count > 0)
                saved += dal.AddStratumDataRows(chunk);

            if (dryrun)
            {
                Console.WriteLine($"[StratumData] Would import {imported:N0} rows from {Path.GetFileName(path)}.");
            }
            else
            {
                Console.WriteLine($"[StratumData] Imported {saved:N0} of {imported:N0} source rows from {Path.GetFileName(path)}.");
                if (saved != imported)
                    Console.WriteLine($"[ERROR] StratumData import incomplete: {imported - saved:N0} rows were NOT saved. Re-run the import before generating terrain.");
            }
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
            var batch = new List<PatchDataRow>(pixelsByZone.Count);

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

                batch.Add(row);
            }

            int savedRows = dal.AddPatchDataRows(batch);
            Console.WriteLine($"[PatchData] Imported {savedRows:N0} of {batch.Count:N0} source rows.");
            if (savedRows != batch.Count)
                Console.WriteLine($"[ERROR] PatchData import incomplete: {batch.Count - savedRows:N0} rows were NOT saved. Re-run the import before generating terrain.");
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

            if (dryrun)
            {
                Console.WriteLine($"[TerrainData] Dry run: terrain generation skipped (PatchData/StratumData not yet in DB).");
                return;
            }

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
                    .Max(s => (float?)s.total_plantc) ?? 1f;
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

                // Step 4b: aggregate BurnData for this (year, month)
                Dictionary<int, float> maxBurnByZone;
                using (var db = new CentralCoastDbContext())
                {
                    maxBurnByZone = db.BurnData
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

        private static Dictionary<string, int> BuildColumnIndex(string[] headers)
        {
            var result = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < headers.Length; i++)
            {
                var normalized = headers[i].Trim().Replace('.', '_');
                if (!result.ContainsKey(normalized))
                    result.Add(normalized, i);
            }
            return result;
        }

        private static int GetColumnIndex(Dictionary<string, int> colMap, string name)
        {
            return colMap.TryGetValue(name, out var idx) ? idx : -1;
        }

        private static int GetInt(string[] parts, Dictionary<string, int> colMap, string name)
        {
            var idx = GetColumnIndex(colMap, name);
            return int.TryParse(GetSafe(parts, idx), out var value) ? value : 0;
        }

        private static float GetFloat(string[] parts, Dictionary<string, int> colMap, string name)
        {
            var idx = GetColumnIndex(colMap, name);
            return float.TryParse(GetSafe(parts, idx), out var value) ? value : 0f;
        }

        private static string GetSafe(string[] parts, int index)
        {
            if (parts == null || index < 0 || index >= parts.Length)
                return string.Empty;
            return parts[index]?.Trim() ?? string.Empty;
        }
    }
}
