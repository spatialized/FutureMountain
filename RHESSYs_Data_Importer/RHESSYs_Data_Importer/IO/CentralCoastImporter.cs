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

                // Key columns
                colMap.TryGetValue("day", out var dayIdx);
                colMap.TryGetValue("month", out var monthIdx);
                colMap.TryGetValue("year", out var yearIdx);
                colMap.TryGetValue("zoneID", out var zoneIdx);
                colMap.TryGetValue("patchID", out var patchIdx);
                colMap.TryGetValue("stratumID", out var stratumIdx);
                colMap.TryGetValue("veg_parm_ID", out var vegIdx);

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

            colMap.TryGetValue("month", out var mIdx);
            colMap.TryGetValue("year", out var yIdx);
            colMap.TryGetValue("basinID", out var bIdx);
            colMap.TryGetValue("burn", out var burnIdx);

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

                if (mIdx >= 0 && int.TryParse(GetSafe(parts, mIdx), out var month))
                    row.month = month;
                if (yIdx >= 0 && int.TryParse(GetSafe(parts, yIdx), out var year))
                    row.year = year;
                if (bIdx >= 0 && int.TryParse(GetSafe(parts, bIdx), out var basinID))
                    row.basinID = basinID;
                if (burnIdx >= 0 && float.TryParse(GetSafe(parts, burnIdx), out var burn))
                    row.burn = burn;

                imported++;
                if (!dryrun)
                    dal.AddFireDataRow(row);
            }

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

            colMap.TryGetValue("month", out var mIdx);
            colMap.TryGetValue("year", out var yIdx);
            colMap.TryGetValue("basinID", out var bIdx);
            colMap.TryGetValue("hillID", out var hIdx);
            colMap.TryGetValue("zoneID", out var zIdx);
            colMap.TryGetValue("patchID", out var pIdx);
            colMap.TryGetValue("burn", out var burnIdx);

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
                    dal.AddFireDataRow(row);
            }

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
                    dal.AddStratumDataRow(row);
            }

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
