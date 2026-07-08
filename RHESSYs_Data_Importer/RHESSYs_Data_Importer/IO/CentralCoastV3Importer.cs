using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Globalization;
using BitMiracle.LibTiff.Classic; // BitMiracle.LibTiff.NET package
using Newtonsoft.Json;
using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.DAL;
using RHESSYs_Data_Importer.Models;
using RHESSYs_Data_Importer.Models.CentralCoastV3;
using System.Buffers;

namespace RHESSYs_Data_Importer.IO
{
    /// <summary>
    /// Central Coast v3 import orchestration.
    ///
    /// Each Import* method reads a configured source file, maps CSV columns to
    /// the EF model, attaches provenance fields, and writes through
    /// <see cref="CentralCoastV3DAL"/>.
    /// </summary>
    public static class CentralCoastV3Importer
    {
       public static void ImportCubeData(ScenarioConfig config, bool dryRun = false)
        {
           ImportCubeAggregateData(config, dryRun);
           var dateIndex = BuildDateIndex(config);
           int scenarioIdx = config.ScenarioIdx ?? 0;
           string scenarioRunId = config.ScenarioRunId ?? string.Empty;

           foreach (var role in new[] {"cubePatchDaily01", "cubePatchDaily02"})
           {
               var path = config.GetSourceFilePath(role);
               if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
               {
                   Console.WriteLine($"[WARN] {role} file not found: {path}");
                   continue;
               }

                var dal = new CentralCoastV3DAL();

                using var reader = new StreamReader(path);

                var colMap = BuildColumnIndex(reader.ReadLine());

                const int ChunkSize = 5000;
                var chunk = new List<CubeDataRowV3>(ChunkSize);
                int imported =0, saved =0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if(string.IsNullOrWhiteSpace(line))
                        continue;
                    
                    var parts = line.Split(',');
                    
                    int y = GetInt(parts, colMap, "year");
                    int m = GetInt(parts, colMap, "month");
                    int d = GetInt(parts, colMap, "day");
                    DateTime dt;
                    try
                    {
                        dt = new DateTime(y, m, d);
                    }
                    catch { throw new InvalidOperationException($"[{role}] row {imported +1}: bad date: {y}-{m}-{d}"); }
                    
                    if(!dateIndex.TryGetValue(dt, out var didx))
                        throw new InvalidOperationException($"[{role}] row {imported +1}:  date {dt:yyyy-MM-dd} not in calendar");
                    
                    var row = new CubeDataRowV3
                    {
                        scenarioRunId = scenarioRunId,
                        scenarioIdx = scenarioIdx,
                        importRunId = 0,
                        dateIdx = didx,
                        zoneID = GetInt(parts, colMap, "zoneID"),
                        patchID = GetInt(parts, colMap, "patchID"),
                        
                        coverfract = GetFloat(parts, colMap, "coverfract"),
                        litterc    = GetFloat(parts, colMap, "litterC"),
                        soilc      = GetFloat(parts, colMap, "soilC"),
                        depthToGW  = GetFloat(parts, colMap, "depthToGW"),
                        canopyevap = GetFloat(parts, colMap, "canopyevap"),
                        streamflow = GetFloat(parts, colMap, "streamflow"),
                        rootdepth  = GetFloat(parts, colMap, "rootdepth"),
                        groundevap = GetFloat(parts, colMap, "groundevap"),
                        vegAccessWater = GetFloat(parts, colMap, "vegAccessWater"),
                        Qin  = GetFloat(parts, colMap, "Qin"),
                        Qout = GetFloat(parts, colMap, "Qout"),
                        rain = GetFloat(parts, colMap, "rain"),

                        netpsnOver     = GetFloat(parts, colMap, "netpsnOver"),
                        gppOver        = GetFloat(parts, colMap, "GPP_over"),
                        respOver       = GetFloat(parts, colMap, "respOver"),
                        heightOver     = GetFloat(parts, colMap, "heightOver"),
                        transOver      = GetFloat(parts, colMap, "transOver"),
                        leafCOver      = GetFloat(parts, colMap, "leafC_over"),
                        stemCOver      = GetFloat(parts, colMap, "stemC_over"),
                        rootCOver      = GetFloat(parts, colMap, "rootC_over"),
                        rootdepthCOver = GetFloatAny(parts, colMap, "rootdepthOver", "rootdepthC_over"),
                        laiOver        = GetFloat(parts, colMap, "laiOver"),

                        netpsnUnder    = GetFloat(parts, colMap, "netpsnUnder"),
                        gppUnder       = GetFloat(parts, colMap, "GPP_under"),
                        respUnder      = GetFloat(parts, colMap, "respUnder"),
                        heightUnder    = GetFloat(parts, colMap, "heightUnder"),
                        transUnder     = GetFloat(parts, colMap, "transUnder"),
                        leafCUnder     = GetFloat(parts, colMap, "leafC_under"),
                        rootCUnder     = GetFloat(parts, colMap, "rootC_under"),
                        rootdepthUnder = GetFloat(parts, colMap, "rootdepthUnder"),
                        laiUnder       = GetFloat(parts, colMap, "laiUnder"),

                        tmax          = GetFloat(parts, colMap, "tmax"),
                        tmin          = GetFloat(parts, colMap, "tmin"),
                        relHumidity   = GetFloat(parts, colMap, "RH"),
                        windSpeed     = GetFloat(parts, colMap, "wind_speed"),
                        windDirection = GetFloat(parts, colMap, "wind_direction"),

                        burn = GetFloat(parts, colMap, "burned"),
                        fire = GetFloat(parts, colMap, "fire"),
                    };

                    imported++;
                    if (!dryRun)
                    {
                        chunk.Add(row);
                        if (chunk.Count >= ChunkSize)
                        {
                            dal.AddCubeDataRows(chunk);
                            saved += chunk.Count;
                            chunk.Clear();
                            Console.WriteLine($"[CubeData/{role}] {imported:N0} processed, {saved:N0} written...");
                        }
                    }
                }

                if (!dryRun && chunk.Count > 0) saved += dal.AddCubeDataRows(chunk);
                  Console.WriteLine($"[CubeData/{role}] {(dryRun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
            }
        }
        private static void ImportCubeAggregateData(ScenarioConfig config, bool dryRun)
        {
            var path = config.GetSourceFilePath("cubeAggregateDaily");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] cubeAggregateDaily file not found: {path}");
                return;
            }

            var dateIndex = BuildDateIndex(config);
            int scenarioIdx = config.ScenarioIdx ?? 0;
            string scenarioRunId = config.ScenarioRunId ?? "";

            var dal = new CentralCoastV3DAL();
            using var reader = new StreamReader(path);
            var colMap = BuildColumnIndex(reader.ReadLine());

            const int ChunkSize = 5000;
            var chunk = new List<CubeDataRowV3>(ChunkSize);
            int imported = 0, saved = 0;
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line)) continue;
                var parts = line.Split(',');

                int y = GetInt(parts, colMap, "year");
                int m = GetInt(parts, colMap, "month");
                int d = GetInt(parts, colMap, "day");
                DateTime dt;
                try { dt = new DateTime(y, m, d); }
                catch { throw new InvalidOperationException($"[aggregate] row {imported + 1}: bad date {y}-{m}-{d}"); }
                if (!dateIndex.TryGetValue(dt, out var didx))
                    throw new InvalidOperationException($"[aggregate] row {imported + 1}: date {dt:yyyy-MM-dd} not in calendar");

                var row = new CubeDataRowV3
                {
                    scenarioRunId = scenarioRunId,
                    scenarioIdx   = scenarioIdx,
                    importRunId   = 0,
                    dateIdx       = didx,
                    zoneID        = -1, 
                    patchID       = -1, 

                    litterc        = GetFloat(parts, colMap, "litterC"),
                    soilc          = GetFloat(parts, colMap, "soilC"),
                    depthToGW      = GetFloat(parts, colMap, "depthToGW"),
                    groundevap     = GetFloat(parts, colMap, "groundevap"),
                    canopyevap     = GetFloat(parts, colMap, "canopyevap"),
                    streamflow     = GetFloat(parts, colMap, "streamflow"),
                    vegAccessWater = GetFloat(parts, colMap, "vegAccessWater"),
                    rain           = GetFloat(parts, colMap, "rain"),
                    rootdepth      = GetFloat(parts, colMap, "rootdepth"),

                    transOver  = GetFloat(parts, colMap, "transpiration"),
                    netpsnOver = GetFloat(parts, colMap, "netpsn"),
                    gppOver    = GetFloat(parts, colMap, "GPP"),
                    respOver   = GetFloat(parts, colMap, "respiration"),
                    heightOver = GetFloat(parts, colMap, "height"),
                    leafCOver  = GetFloat(parts, colMap, "leafC"),
                    stemCOver  = GetFloat(parts, colMap, "stemC"),
                    rootCOver  = GetFloat(parts, colMap, "rootC"),
                };

                imported++;
                if (!dryRun)
                {
                    chunk.Add(row);
                    if (chunk.Count >= ChunkSize)
                    {
                        saved += dal.AddCubeDataRows(chunk);
                        chunk.Clear();
                    }
                }
            }
            if (!dryRun && chunk.Count > 0) saved += dal.AddCubeDataRows(chunk);
            Console.WriteLine($"[CubeData/aggregate] {(dryRun ? "Would import" : "Imported")} {imported:N0} aggregate rows from {Path.GetFileName(path)}.");
        }
        public static void ImportDates(ScenarioConfig config, bool dryRun = false)
        {
            var dateIndex = BuildDateIndex(config);
            var calendar = dateIndex.OrderBy(kv => kv.Value).Select(kv => kv.Key).ToList();
            Console.WriteLine($"[Dates] Derived {calendar.Count:N0} distinct dates: " + $"{calendar[0]:yyyy-MM-dd} – {calendar[^1]:yyyy-MM-dd}.");

            var dal = new CentralCoastV3DAL();

            int existing = dal.GetDatesCount();
            if (existing == calendar.Count)
            {
                Console.WriteLine($"[Dates] Database already has {existing:N0} dates; skipping import.");
                return;
            }
            if (existing > 0)
            {
                Console.WriteLine($"[Dates] Database has {existing:N0} dates, but calendar has {calendar.Count:N0}. " + "TRUNCATE the Dates table and re-run --dates.");
                return;
            }
            if(dryRun)
            {
                Console.WriteLine($"[Dates] Would import {calendar.Count:N0} dates into the database.");
                return;
            }

            var rows = new List<Date>(calendar.Count);
            foreach (var dt in calendar)
                rows.Add(new Date {date = dt, year = dt.Year, month = dt.Month, day = dt.Day});
            
            int inserted = dal.AddDateRows(rows);
            Console.WriteLine($"[Dates] Inserted {inserted:N0} rows.");
        }
        private static Dictionary<DateTime, int> BuildDateIndex(ScenarioConfig config)
        {
            var path = config.GetSourceFilePath("cubeAggregateDaily");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
                throw new InvalidOperationException($"cubeAggregateDaily file not found: {path}");
            
            var dates = new SortedSet<DateTime>();
            using var reader = new StreamReader(path);
            var colMap = BuildColumnIndex(reader.ReadLine()); 
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if(string.IsNullOrWhiteSpace(line))
                    continue;
                var parts = line.Split(',');
                int y = GetInt(parts, colMap, "year");
                int m = GetInt(parts, colMap, "month");
                int d = GetInt(parts, colMap, "day");
                try { dates.Add(new DateTime(y, m, d)); } catch{}
            }
            var map =new Dictionary<DateTime, int>(dates.Count);
            int i = 1;
            foreach(var dt in dates)
                map[dt] = i++;
            return map;
        }
        private static Dictionary<string, int> BuildColumnIndex(string headerLine)
        {
            var map = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            var headers = headerLine.Split(',');
            for (int i = 0; i < headers.Length; i++)
            {
                var key = headers[i].Trim().Trim('"');
                if (!string.IsNullOrWhiteSpace(key) && !map.ContainsKey(key))
                    map[key] = i;
            }               
            return map;
        }

        public static void ImportPatchMapData(ScenarioConfig config, bool dryRun = false)
        {
            var path = config.GetSourceFilePath("patchFamilyRaster");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                Console.WriteLine($"[WARN] patchFamilyRaster file not found: {path}");
                return;
            }

            var pixelsByZone = new Dictionary<int, List<int[]>>();
            int gridWidth = 0, gridHeight = 0;
            
            using (var tiff = Tiff.Open(path, "r"))
            {
                if (tiff == null)
                {
                    Console.WriteLine($"[WARN] Failed to open TIFF file: {path}");
                    return;
                }
            
                gridWidth = tiff.GetField(TiffTag.IMAGEWIDTH)[0].ToInt();
                gridHeight = tiff.GetField(TiffTag.IMAGELENGTH)[0].ToInt();

                int scanlineSize = tiff.ScanlineSize();
                byte[] buf = new byte[scanlineSize];

                for (int row = 0; row < gridHeight; row++)
                {
                    tiff.ReadScanline(buf, row);
                    for (int col = 0; col < gridWidth; col++)
                    {
                        int byteOffset = col * 2;
                        if (byteOffset + 1 >= buf.Length)
                            continue;
                        int value = buf[byteOffset] | (buf[byteOffset + 1] << 8);
                        if (value ==65535) // NoData value
                            continue;
                        if (!pixelsByZone.TryGetValue(value, out var list))
                        {
                            list = new List<int[]>();
                            pixelsByZone[value] = list;
                        }
                        list.Add(new int[] { col, row });
                    }
                }
            }

            int totalPixels =pixelsByZone.Values.Sum(list => list.Count);
            Console.WriteLine($"[PatchData] Decoded {pixelsByZone.Count:N0} unique zoneIDs from {gridWidth}x{gridHeight} grid ({totalPixels:N0} pixels).");

            if (dryRun)
            {
                Console.WriteLine($"[PatchData] Dry run: would write {pixelsByZone.Count:N0} rows to PatchData.");
                return;
            }

            var dal = new CentralCoastV3DAL();
            var batch = new List<PatchDataRowV3>(pixelsByZone.Count);

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
                    centroidCol,
                    centroidRow,
                    boundingBox = new { colMin, colMax, rowMin, rowMax },
                    pixels
                };

                 batch.Add(new PatchDataRowV3
                {
                    scenarioRunId = config.ScenarioRunId ?? "",
                    importRunId = 0,
                    zoneID = zoneID,
                    data = JsonConvert.SerializeObject(footprint)
                });
            }

            int savedRows = dal.AddPatchDataRows(batch);
            Console.WriteLine($"[PatchData] Imported {savedRows:N0} of {batch.Count:N0} rows.");
            if (savedRows != batch.Count)
                Console.WriteLine($"[ERROR] PatchData import incomplete: {batch.Count - savedRows:N0} rows NOT saved.");
       }

        private static string GetSafe(string[] parts, int idx) 
            => (parts != null && idx >= 0 && idx < parts.Length) ? parts[idx].Trim().Trim('"') : "";
        private static int GetInt(string[] parts, Dictionary<string, int> col, string name)
            => col.TryGetValue(name, out var i) && int.TryParse(GetSafe(parts, i), out var v) ? v : 0;
         private static long GetLong(string[] parts, Dictionary<string, int> col, string name)
            => col.TryGetValue(name, out var i) && long.TryParse(GetSafe(parts, i), out var v) ? v : 0;
        private static float GetFloat(string[] parts, Dictionary<string, int> col, string name)
            => col.TryGetValue(name, out var i)
                    && float.TryParse(GetSafe(parts, i), NumberStyles.Any, CultureInfo.InvariantCulture, out var v) ? v : 0f;
        
        private static float GetFloatAny(string[] parts, Dictionary<string, int> col, params string[] names)
        {
            foreach (var n in names)
                if (col.ContainsKey(n)) return GetFloat(parts, col, n);
            return 0f;
        }
    
    }
}
