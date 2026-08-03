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

                        // Newer columns; absent in pre-8-3-2026 files, GetFloat -> 0.
                        ind_died = GetFloat(parts, colMap, "ind_died"),
                        fcover   = GetFloat(parts, colMap, "fcover"),
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

       public static void ImportPatchMonthly(ScenarioConfig config, bool dryRun = false)
        {
            int scenarioIdx = config.ScenarioIdx ?? 0;
            string scenarioRunId = config.ScenarioRunId ?? "";

            foreach (var role in new[] { "allPatchMonthly01", "allPatchMonthly02" })
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
                var chunk = new List<PatchMonthlyRowV3>(ChunkSize);
                int imported = 0, saved = 0;
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line)) continue;
                    var parts = line.Split(',');

                    var row = new PatchMonthlyRowV3
                    {
                        scenarioRunId = scenarioRunId,
                        scenarioIdx   = scenarioIdx,
                        importRunId   = 0,

                        year   = GetInt(parts, colMap, "year"),
                        month  = GetInt(parts, colMap, "month"),
                        wy     = GetInt(parts, colMap, "wy"),
                        zoneID = GetInt(parts, colMap, "zoneID"),
                        patchID = GetLong(parts, colMap, "patchID"),

                        totalCover  = GetFloat(parts, colMap, "totalCover"),
                        totalCunder = GetFloat(parts, colMap, "totalCunder"),
                        plantCover  = GetFloat(parts, colMap, "plantCover"),
                        plantCunder = GetFloat(parts, colMap, "plantCunder"),

                        burned = GetFloat(parts, colMap, "burned"),
                        fire   = GetFloat(parts, colMap, "fire"),
                    };

                    imported++;
                    if (!dryRun)
                    {
                        chunk.Add(row);
                        if (chunk.Count >= ChunkSize)
                        {
                            saved += dal.AddPatchMonthlyRows(chunk);
                            chunk.Clear();
                            if (imported % 500000 == 0)
                                Console.WriteLine($"[PatchMonthly/{role}] {imported:N0} processed, {saved:N0} written...");
                        }
                    }
                }
                if (!dryRun && chunk.Count > 0) saved += dal.AddPatchMonthlyRows(chunk);
                Console.WriteLine($"[PatchMonthly/{role}] {(dryRun ? "Would import" : "Imported")} {imported:N0} rows from {Path.GetFileName(path)}.");
            }
        }

         public static void GenerateTerrainData(ScenarioConfig config, bool dryRun = false)
        {
            const int GridWidth = 396;
            const int GridHeight = 301;
            const int PixelGrainSize = 30;
            const int DecimalPrecision = 4;
            int scale = (int)Math.Pow(10, DecimalPrecision); 
            const int TotalPixels = GridWidth * GridHeight; // 119,196

            var scenarioRunId = config.ScenarioRunId ?? "";
            int scenarioIdx = config.ScenarioIdx ?? 0;

            if (dryRun)
            {
                Console.WriteLine("[TerrainData] Dry run: terrain generation skipped.");
                return;
            }

            // Step 1: PatchData → zoneID -> row*GridWidth + col
            Console.WriteLine($"[TerrainData] Loading PatchData footprints for scenarioRunId={scenarioRunId}...");
            var zonePixels = new Dictionary<int, List<int>>();
            using (var db = new CentralCoastV3DbContext())
            {
                var patchRows = db.PatchData.Where(p => p.scenarioRunId == scenarioRunId).ToList();
                foreach (var prow in patchRows)
                {
                    if (string.IsNullOrWhiteSpace(prow.data)) continue;
                    dynamic footprint = Newtonsoft.Json.JsonConvert.DeserializeObject<dynamic>(prow.data);
                    var pixelList = new List<int>();
                    foreach (var px in footprint.pixels)   // px = [col, row]
                    {
                        int col = (int)px[0];
                        int row = (int)px[1];
                        pixelList.Add(row * GridWidth + col);
                    }
                    zonePixels[prow.zoneID] = pixelList;
                }
            }
            Console.WriteLine($"[TerrainData] Loaded {zonePixels.Count:N0} zoneID footprints.");

            // Step 2: globalMaxPlantC —— max plantCover + plantCunder
            float globalMaxPlantC;
            using (var db = new CentralCoastV3DbContext())
            {
                globalMaxPlantC = db.PatchMonthly
                    .Where(s => s.scenarioRunId == scenarioRunId && s.scenarioIdx == scenarioIdx)
                    .Max(s => (float?)(s.plantCover + s.plantCunder)) ?? 1f;
            }
            if (globalMaxPlantC <= 0f) globalMaxPlantC = 1f;
            Console.WriteLine($"[TerrainData] globalMaxPlantC = {globalMaxPlantC:F4}");

            // Step 3: (year, month)
            List<(int year, int month)> timePeriods;
            using (var db = new CentralCoastV3DbContext())
            {
                timePeriods = db.PatchMonthly
                    .Where(s => s.scenarioRunId == scenarioRunId && s.scenarioIdx == scenarioIdx)
                    .Select(s => new { s.year, s.month })
                    .Distinct()
                    .OrderBy(x => x.year).ThenBy(x => x.month)
                    .ToList()
                    .Select(x => (x.year, x.month))
                    .ToList();
            }
            Console.WriteLine($"[TerrainData] {timePeriods.Count:N0} monthly frames to generate.");

            var dal = new CentralCoastV3DAL();
            var terrainBatch = new List<TerrainDataRowV3>();
            int written = 0;

            foreach (var (year, month) in timePeriods)
            {
                // Step 4a: plant C mean by zone
                Dictionary<int, float> meanPlantCByZone;
                using (var db = new CentralCoastV3DbContext())
                {
                    meanPlantCByZone = db.PatchMonthly
                        .Where(s => s.scenarioRunId == scenarioRunId && s.scenarioIdx == scenarioIdx
                                    && s.year == year && s.month == month)
                        .GroupBy(s => s.zoneID)
                        .Select(g => new { zoneID = g.Key, meanC = g.Average(s => s.plantCover + s.plantCunder) })
                        .ToDictionary(x => x.zoneID, x => x.meanC);
                }

                // Step 4b: max burn by zone
                Dictionary<int, float> maxBurnByZone;
                using (var db = new CentralCoastV3DbContext())
                {
                    maxBurnByZone = db.PatchMonthly
                        .Where(s => s.scenarioRunId == scenarioRunId && s.scenarioIdx == scenarioIdx
                                    && s.year == year && s.month == month)
                        .GroupBy(s => s.zoneID)
                        .Select(g => new { zoneID = g.Key, maxBurn = g.Max(s => s.burned) })
                        .ToDictionary(x => x.zoneID, x => x.maxBurn);
                }

                // Step 4c: draw grid
                int[] output = new int[TotalPixels]; 
                foreach (var kvp in zonePixels)
                {
                    int zoneID = kvp.Key;
                    float meanC = meanPlantCByZone.TryGetValue(zoneID, out var mc) ? mc : 0f;
                    float maxBurn = maxBurnByZone.TryGetValue(zoneID, out var mb) ? mb : 0f;

                    float vegIntensity = Math.Clamp(meanC / globalMaxPlantC, 0f, 1f);
                    float burnSignal = maxBurn > 0f ? 1f : 0f;
                    int value = (int)Math.Round((vegIntensity + burnSignal * 100f) * scale); 
                    foreach (int idx in kvp.Value)
                        if (idx >= 0 && idx < TotalPixels)
                            output[idx] = value;
                }

                // Step 4d: save
                terrainBatch.Add(new TerrainDataRowV3
                {
                    scenarioRunId = scenarioRunId,
                    scenarioIdx = scenarioIdx,
                    year = year,
                    month = month,
                    gridSize = 0,
                    gridWidth = GridWidth,
                    gridHeight = GridHeight,
                    pixelGrainSize = PixelGrainSize,
                    decimalPrecision = DecimalPrecision,
                    _dataList = Newtonsoft.Json.JsonConvert.SerializeObject(output)
                });
                written++;

                // Step 4e: batch write every 24 frames
                if (terrainBatch.Count >= 24)
                {
                    dal.AddTerrainDataRows(terrainBatch);
                    terrainBatch.Clear();
                    Console.WriteLine($"[TerrainData] {written:N0}/{timePeriods.Count:N0} frames written...");
                }
            }

            if (terrainBatch.Count > 0)
                dal.AddTerrainDataRows(terrainBatch);

            Console.WriteLine($"[TerrainData] Generated {written:N0} TerrainData rows.");
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
