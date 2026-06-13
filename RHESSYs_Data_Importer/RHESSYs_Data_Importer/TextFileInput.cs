using System;
using System.IO;
using RHESSYs_Data_Importer.Models;
using RHESSYs_Data_Importer.DAL;
using System.Diagnostics;
using System.Resources;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using RHESSYs_Data_Importer.Models.RHESSYs_Data_Importer.Models;
using System.Linq;
using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.Parsing;

public static class TextFileInput
{
    /// <summary>
    /// Initializes cube data arrays from data file.
    /// </summary>
    /// <param name="dataFile">Data file.</param>
    public static void ReadCubeData(string folderAggregate, string folderCubes)
    {
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            Console.WriteLine("Importing files from folder: "+ folderAggregate);

            foreach (string file in Directory.EnumerateFiles(folderAggregate))
            {
                int patchIdx = -1;
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);
                //Console.WriteLine("Found data file: " + fileName);

                if (fileName.Contains("hist"))
                {
                    warmingIdx = 0;
                }
                else
                {
                    string[] parts = file.Split('.')[0].Split("_fire");
                    string warmingStr = parts[0].Substring(parts[0].Length-1);
                    int warmingDegrees = int.Parse(warmingStr);
                    warmingIdx = WarmingDegreesToIndex(warmingDegrees);
                }
                //Console.WriteLine("Set warmingIdx: " + warmingIdx);

                List<string> lines = ReadLinesFromFile(file);
                //Console.WriteLine("Read " + lines.Count +" lines from file "+fileName);

                int count = 0;
                foreach (string line in lines)
                {
                    if (count > 0)
                        AddDataPoint(line, count, warmingIdx, patchIdx);

                    count++;
                }
            }

            Console.WriteLine("Importing files from folder: " + folderCubes);

            foreach (string file in Directory.EnumerateFiles(folderCubes))
            {
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);

                string[] parts = fileName.Split('_');
                string patchIdxStr = parts[0].Split('p')[1];
                int patchIdx = int.Parse(patchIdxStr);

                if (fileName.Contains("hist"))
                {
                    warmingIdx = 0;
                }
                else
                {
                    parts = file.Split('.')[0].Split("_fire");
                    string warmingStr = parts[0].Substring(parts[0].Length - 1);
                    int warmingDegrees = int.Parse(warmingStr);

                    Console.WriteLine("Set patchIdx: " + patchIdx);
                    warmingIdx = WarmingDegreesToIndex(warmingDegrees);
                }

                List<string> lines = ReadLinesFromFile(file);
                int count = 0;
                foreach (string line in lines)
                {
                    if (count > 0)
                        AddDataPoint(line, count, warmingIdx, patchIdx);

                    count++;
                }
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("Exception: " + e.Message);
        }
        finally
        {
            Console.WriteLine("Executing finally block.");
        }

        void AddDataPoint(string line, int newDateIdx, int newWarmingIdx, int newPatchIdx)
        {
            string[] str = line.Split(' ');

            CubeDataPoint data = new CubeDataPoint();

            if(newPatchIdx == -1)
            {
                //data.id; Primary key --> add in SQL Server
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = float.Parse(str[1]);
                data.evap = float.Parse(str[2]);
                data.netpsn = float.Parse(str[3]);
                data.depthToGW = float.Parse(str[4]); ;
                data.vegAccessWater = float.Parse(str[5]);
                data.Qout = float.Parse(str[6]);
                data.litter = float.Parse(str[7]);
                data.soil = float.Parse(str[8]);
                data.heightOver = float.Parse(str[9]);
                data.transOver = float.Parse(str[10]);
                data.heightUnder = float.Parse(str[11]);
                //data.transUnder = float.Parse(str[12]);       // Not in data
                data.leafCOver = float.Parse(str[12]);
                data.stemCOver = float.Parse(str[13]);
                data.rootCOver = float.Parse(str[14]);
                data.leafCUnder = float.Parse(str[15]);
                data.stemCUnder = float.Parse(str[16]);
                data.rootCUnder = float.Parse(str[17]);
            }
            else
            {
                //data.id; Primary key --> add in SQL Server
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = float.Parse(str[1]);
                data.evap = float.Parse(str[2]);
                data.netpsn = float.Parse(str[3]);
                data.depthToGW = float.Parse(str[4]); ;
                data.vegAccessWater = float.Parse(str[5]);
                data.Qout = float.Parse(str[6]);
                data.litter = float.Parse(str[7]);
                data.soil = float.Parse(str[8]);
                data.heightOver = float.Parse(str[9]);
                data.transOver = float.Parse(str[10]);
                data.heightUnder = float.Parse(str[11]);
                data.transUnder = float.Parse(str[12]);
                data.leafCOver = float.Parse(str[13]);
                data.stemCOver = float.Parse(str[14]);
                data.rootCOver = float.Parse(str[15]);
                data.leafCUnder = float.Parse(str[16]);
                data.stemCUnder = float.Parse(str[17]);
                data.rootCUnder = float.Parse(str[18]);
            }

            dal.AddDataPoint(data); 
        }
    }

    public static void ReadCubeDataFiles(IEnumerable<string> files, ScenarioConfig config)
    {
        RHESSYsDAL dal = new RHESSYsDAL();
        var columnMap = config.ColumnMapping != null && config.ColumnMapping.ContainsKey("cube")
            ? config.ColumnMapping["cube"]
            : new Dictionary<string, string>();

        foreach (var file in files)
        {
            try
            {
                string fileName = Path.GetFileNameWithoutExtension(file);

                int warmingIdx = -1;
                int patchIdx = -1;

                // Infer warming and patch from filename when possible
                if (fileName.Contains("hist"))
                {
                    warmingIdx = 0;
                }
                else if (fileName.Contains("_fire"))
                {
                    var parts = fileName.Split('.')[0].Split("_fire");
                    if (parts[0].Length > 0)
                    {
                        var last = parts[0].Last();
                        if (char.IsDigit(last)) warmingIdx = WarmingDegreesToIndex(int.Parse(last.ToString()));
                    }
                }

                // Patch id in names like p1234_2veg_...
                if (fileName.StartsWith("p", StringComparison.OrdinalIgnoreCase))
                {
                    var parts = fileName.Split('_');
                    if (parts.Length > 0)
                    {
                        var p = parts[0];
                        var digits = new string(p.Skip(1).TakeWhile(char.IsDigit).ToArray());
                        if (int.TryParse(digits, out var pid)) patchIdx = pid;
                    }
                }

                var lines = ReadLinesFromFile(file);
                if (lines.Count == 0) continue;

                var header = lines.FirstOrDefault(l => !string.IsNullOrWhiteSpace(l)) ?? string.Empty;
                var mapper = new ColumnMapper(header, columnMap);

                if (mapper.MatchedCount == 0)
                {
                    Console.WriteLine($"[ERROR] No valid columns matched the mapping for file {Path.GetFileName(file)}. Falling back to legacy parsing.");
                    int idx = 0;
                    foreach (var line in lines)
                    {
                        if (idx > 0 && !string.IsNullOrWhiteSpace(line))
                            AddDataPointLegacy(line, idx, warmingIdx, patchIdx);
                        idx++;
                    }
                    continue;
                }

                // Warn for missing targets
                if (columnMap != null && columnMap.Count > 0)
                {
                    var expectedTargets = new HashSet<string>(columnMap.Values, StringComparer.OrdinalIgnoreCase);
                    var presentTargets = new HashSet<string>(mapper.MappedFields, StringComparer.OrdinalIgnoreCase);
                    foreach (var target in expectedTargets)
                        if (!presentTargets.Contains(target))
                            Console.WriteLine($"[WARN] Column '{target}' not found in header for file {Path.GetFileName(file)}");
                }

                int count = 0;
                foreach (var line in lines)
                {
                    if (count > 0 && !string.IsNullOrWhiteSpace(line))
                        AddDataPointMapped(line, count, warmingIdx, patchIdx, mapper, Path.GetFileName(file));
                    count++;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[WARN] Failed to process file '{file}': {ex.Message}");
            }
        }

        void AddDataPointLegacy(string line, int newDateIdx, int newWarmingIdx, int newPatchIdx)
        {
            string[] str = line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            CubeDataPoint data = new CubeDataPoint();

            if (newPatchIdx == -1)
            {
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = SafeFloat(str, 1);
                data.evap = SafeFloat(str, 2);
                data.netpsn = SafeFloat(str, 3);
                data.depthToGW = SafeFloat(str, 4);
                data.vegAccessWater = SafeFloat(str, 5);
                data.Qout = SafeFloat(str, 6);
                data.litter = SafeFloat(str, 7);
                data.soil = SafeFloat(str, 8);
                data.heightOver = SafeFloat(str, 9);
                data.transOver = SafeFloat(str, 10);
                data.heightUnder = SafeFloat(str, 11);
                data.leafCOver = SafeFloat(str, 12);
                data.stemCOver = SafeFloat(str, 13);
                data.rootCOver = SafeFloat(str, 14);
                data.leafCUnder = SafeFloat(str, 15);
                data.stemCUnder = SafeFloat(str, 16);
                data.rootCUnder = SafeFloat(str, 17);
            }
            else
            {
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = SafeFloat(str, 1);
                data.evap = SafeFloat(str, 2);
                data.netpsn = SafeFloat(str, 3);
                data.depthToGW = SafeFloat(str, 4);
                data.vegAccessWater = SafeFloat(str, 5);
                data.Qout = SafeFloat(str, 6);
                data.litter = SafeFloat(str, 7);
                data.soil = SafeFloat(str, 8);
                data.heightOver = SafeFloat(str, 9);
                data.transOver = SafeFloat(str, 10);
                data.heightUnder = SafeFloat(str, 11);
                data.transUnder = SafeFloat(str, 12);
                data.leafCOver = SafeFloat(str, 13);
                data.stemCOver = SafeFloat(str, 14);
                data.rootCOver = SafeFloat(str, 15);
                data.leafCUnder = SafeFloat(str, 16);
                data.stemCUnder = SafeFloat(str, 17);
                data.rootCUnder = SafeFloat(str, 18);
            }
            dal.AddDataPoint(data);
        }

        float SafeFloat(string[] parts, int idx) => (idx >= 0 && idx < parts.Length && float.TryParse(parts[idx], out var f)) ? f : 0f;

        void AddDataPointMapped(string line, int newDateIdx, int newWarmingIdx, int newPatchIdx, ColumnMapper mapper, string fileName)
        {
            string[] parts = line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            CubeDataPoint data = new CubeDataPoint
            {
                dateIdx = newDateIdx,
                warmingIdx = newWarmingIdx,
                patchIdx = newPatchIdx,
                snow = mapper.GetFloat(parts, "snow"),
                evap = mapper.GetFloat(parts, "evap"),
                netpsn = mapper.GetFloat(parts, "netpsn"),
                depthToGW = mapper.GetFloat(parts, "depthToGW"),
                vegAccessWater = mapper.GetFloat(parts, "vegAccessWater"),
                Qout = mapper.GetFloat(parts, "Qout"),
                litter = mapper.GetFloat(parts, "litter"),
                soil = mapper.GetFloat(parts, "soil"),
                heightOver = mapper.GetFloat(parts, "heightOver"),
                transOver = mapper.GetFloat(parts, "transOver"),
                heightUnder = mapper.GetFloat(parts, "heightUnder"),
                transUnder = mapper.GetFloat(parts, "transUnder"),
                leafCOver = mapper.GetFloat(parts, "leafCOver"),
                stemCOver = mapper.GetFloat(parts, "stemCOver"),
                rootCOver = mapper.GetFloat(parts, "rootCOver"),
                leafCUnder = mapper.GetFloat(parts, "leafCUnder"),
                stemCUnder = mapper.GetFloat(parts, "stemCUnder"),
                rootCUnder = mapper.GetFloat(parts, "rootCUnder")
            };
            dal.AddDataPoint(data);
        }
    }

    public static void ReadCubeData(string folderAggregate, string folderCubes, ScenarioConfig config)
    {
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            Console.WriteLine("Importing files from folder: " + folderAggregate);

            foreach (string file in Directory.EnumerateFiles(folderAggregate))
            {
                int patchIdx = -1;
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);

                if (fileName.Contains("hist"))
                {
                    warmingIdx = 0;
                }
                else
                {
                    string[] partsName = file.Split('.')[0].Split("_fire");
                    string warmingStr = partsName[0].Substring(partsName[0].Length - 1);
                    int warmingDegrees = int.Parse(warmingStr);
                    warmingIdx = WarmingDegreesToIndex(warmingDegrees);
                }

                List<string> lines = ReadLinesFromFile(file);
                var header = lines.FirstOrDefault(l => !string.IsNullOrWhiteSpace(l)) ?? string.Empty;
                var columnMap = config.ColumnMapping != null && config.ColumnMapping.ContainsKey("cube")
                    ? config.ColumnMapping["cube"]
                    : new Dictionary<string, string>();
                var mapper = new ColumnMapper(header, columnMap);

                if (mapper.MatchedCount == 0)
                {
                    Console.WriteLine($"[ERROR] No valid columns matched the mapping for file {Path.GetFileName(file)}. Falling back to legacy parsing.");
                    // Fallback to legacy parsing
                    int countLegacy = 0;
                    foreach (var line in lines)
                    {
                        if (countLegacy > 0)
                            AddDataPointLegacy(line, countLegacy, warmingIdx, patchIdx);
                        countLegacy++;
                    }
                    continue;
                }

                // Warn for missing mapped fields
                if (columnMap != null && columnMap.Count > 0)
                {
                    var expectedTargets = new HashSet<string>(columnMap.Values, StringComparer.OrdinalIgnoreCase);
                    var presentTargets = new HashSet<string>(mapper.MappedFields, StringComparer.OrdinalIgnoreCase);
                    foreach (var target in expectedTargets)
                    {
                        if (!presentTargets.Contains(target))
                        {
                            Console.WriteLine($"[WARN] Column '{target}' not found in header for file {Path.GetFileName(file)}");
                        }
                    }
                }

                int count = 0;
                foreach (string line in lines)
                {
                    if (count > 0 && !string.IsNullOrWhiteSpace(line))
                        AddDataPointMapped(line, count, warmingIdx, patchIdx, mapper, Path.GetFileName(file));

                    count++;
                }
            }

            Console.WriteLine("Importing files from folder: " + folderCubes);

            foreach (string file in Directory.EnumerateFiles(folderCubes))
            {
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);

                string[] parts = fileName.Split('_');
                string patchIdxStr = parts[0].Split('p')[1];
                int patchIdx = int.Parse(patchIdxStr);

                if (fileName.Contains("hist"))
                {
                    warmingIdx = 0;
                }
                else
                {
                    parts = file.Split('.')[0].Split("_fire");
                    string warmingStr = parts[0].Substring(parts[0].Length - 1);
                    int warmingDegrees = int.Parse(warmingStr);

                    Console.WriteLine("Set patchIdx: " + patchIdx);
                    warmingIdx = WarmingDegreesToIndex(warmingDegrees);
                }

                List<string> lines = ReadLinesFromFile(file);
                var header = lines.FirstOrDefault(l => !string.IsNullOrWhiteSpace(l)) ?? string.Empty;
                var columnMap = config.ColumnMapping != null && config.ColumnMapping.ContainsKey("cube")
                    ? config.ColumnMapping["cube"]
                    : new Dictionary<string, string>();
                var mapper = new ColumnMapper(header, columnMap);

                if (mapper.MatchedCount == 0)
                {
                    Console.WriteLine($"[ERROR] No valid columns matched the mapping for file {Path.GetFileName(file)}. Falling back to legacy parsing.");
                    // Fallback to legacy parsing
                    int countLegacy = 0;
                    foreach (var line in lines)
                    {
                        if (countLegacy > 0)
                            AddDataPointLegacy(line, countLegacy, warmingIdx, patchIdx);
                        countLegacy++;
                    }
                    continue;
                }

                // Warn for missing mapped fields
                if (columnMap != null && columnMap.Count > 0)
                {
                    var expectedTargets = new HashSet<string>(columnMap.Values, StringComparer.OrdinalIgnoreCase);
                    var presentTargets = new HashSet<string>(mapper.MappedFields, StringComparer.OrdinalIgnoreCase);
                    foreach (var target in expectedTargets)
                    {
                        if (!presentTargets.Contains(target))
                        {
                            Console.WriteLine($"[WARN] Column '{target}' not found in header for file {Path.GetFileName(file)}");
                        }
                    }
                }

                int count2 = 0;
                foreach (string line in lines)
                {
                    if (count2 > 0 && !string.IsNullOrWhiteSpace(line))
                        AddDataPointMapped(line, count2, warmingIdx, patchIdx, mapper, Path.GetFileName(file));

                    count2++;
                }
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("Exception: " + e.Message);
        }
        finally
        {
            Console.WriteLine("Executing finally block.");
        }

        void AddDataPointLegacy(string line, int newDateIdx, int newWarmingIdx, int newPatchIdx)
        {
            string[] str = line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            CubeDataPoint data = new CubeDataPoint();

            if (newPatchIdx == -1)
            {
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = float.Parse(str[1]);
                data.evap = float.Parse(str[2]);
                data.netpsn = float.Parse(str[3]);
                data.depthToGW = float.Parse(str[4]);
                data.vegAccessWater = float.Parse(str[5]);
                data.Qout = float.Parse(str[6]);
                data.litter = float.Parse(str[7]);
                data.soil = float.Parse(str[8]);
                data.heightOver = float.Parse(str[9]);
                data.transOver = float.Parse(str[10]);
                data.heightUnder = float.Parse(str[11]);
                data.leafCOver = float.Parse(str[12]);
                data.stemCOver = float.Parse(str[13]);
                data.rootCOver = float.Parse(str[14]);
                data.leafCUnder = float.Parse(str[15]);
                data.stemCUnder = float.Parse(str[16]);
                data.rootCUnder = float.Parse(str[17]);
            }
            else
            {
                data.dateIdx = newDateIdx;
                data.warmingIdx = newWarmingIdx;
                data.patchIdx = newPatchIdx;
                data.snow = float.Parse(str[1]);
                data.evap = float.Parse(str[2]);
                data.netpsn = float.Parse(str[3]);
                data.depthToGW = float.Parse(str[4]);
                data.vegAccessWater = float.Parse(str[5]);
                data.Qout = float.Parse(str[6]);
                data.litter = float.Parse(str[7]);
                data.soil = float.Parse(str[8]);
                data.heightOver = float.Parse(str[9]);
                data.transOver = float.Parse(str[10]);
                data.heightUnder = float.Parse(str[11]);
                data.transUnder = float.Parse(str[12]);
                data.leafCOver = float.Parse(str[13]);
                data.stemCOver = float.Parse(str[14]);
                data.rootCOver = float.Parse(str[15]);
                data.leafCUnder = float.Parse(str[16]);
                data.stemCUnder = float.Parse(str[17]);
                data.rootCUnder = float.Parse(str[18]);
            }
            dal.AddDataPoint(data);
        }

        void AddDataPointMapped(string line, int newDateIdx, int newWarmingIdx, int newPatchIdx, ColumnMapper mapper, string fileName)
        {
            string[] parts = line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            CubeDataPoint data = new CubeDataPoint
            {
                dateIdx = newDateIdx,
                warmingIdx = newWarmingIdx,
                patchIdx = newPatchIdx,
                snow = mapper.GetFloat(parts, "snow"),
                evap = mapper.GetFloat(parts, "evap"),
                netpsn = mapper.GetFloat(parts, "netpsn"),
                depthToGW = mapper.GetFloat(parts, "depthToGW"),
                vegAccessWater = mapper.GetFloat(parts, "vegAccessWater"),
                Qout = mapper.GetFloat(parts, "Qout"),
                litter = mapper.GetFloat(parts, "litter"),
                soil = mapper.GetFloat(parts, "soil"),
                heightOver = mapper.GetFloat(parts, "heightOver"),
                transOver = mapper.GetFloat(parts, "transOver"),
                heightUnder = mapper.GetFloat(parts, "heightUnder"),
                transUnder = mapper.GetFloat(parts, "transUnder"),
                leafCOver = mapper.GetFloat(parts, "leafCOver"),
                stemCOver = mapper.GetFloat(parts, "stemCOver"),
                rootCOver = mapper.GetFloat(parts, "rootCOver"),
                leafCUnder = mapper.GetFloat(parts, "leafCUnder"),
                stemCUnder = mapper.GetFloat(parts, "stemCUnder"),
                rootCUnder = mapper.GetFloat(parts, "rootCUnder")
            };
            dal.AddDataPoint(data);
        }
    }

    private static int WarmingDegreesToIndex(int warmingDegrees)
    {
        int warmingIdx;

        switch (warmingDegrees)
        {
            case 0:
                warmingIdx = 0;
                break;
            case 1:
                warmingIdx = 1;
                break;
            case 2:
                warmingIdx = 2;
                break;
            case 4:
                warmingIdx = 3;
                break;
            case 6:
                warmingIdx = 4;
                break;
            default:
                warmingIdx = -1;
                break;
        }

        return warmingIdx;
    }

    public static void ReadWaterData(string folderWater)
    {
        // List<WaterDataYear> waterData;          // List of formatted water data by warming idx.
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            //TextAsset patchExtTextAsset = (TextAsset)Resources.Load("WaterData/WaterData");
            string text = ReadFile(folderWater + "/" + "WaterData.json");
            List<WaterDataYear> waterData = JsonConvert.DeserializeObject<List<WaterDataYear>>(text);
            foreach (WaterDataYear year in waterData)
            {
                foreach (WaterDataMonth month in year.GetMonths())
                {
                    foreach (WaterDataFrame frame in month.GetFrames())
                    {
                        try
                        {
                            frame.index++;
                            dal.AddWaterDataFrame(frame);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("ReadWaterData()... ERROR... ex: "+ex.Message);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            //Debug.Log("InitializeData()... waterData ERROR: " + e.Message);
        }
    }

    public static void ReadFireData(string folderFire)
    {
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            // fireDataList_0.json
            foreach (string file in Directory.EnumerateFiles(folderFire))
            {
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);
                Console.WriteLine("ReadFireData()... fileName: " + fileName);

                string[] parts = file.Split('.')[0].Split("_fire");
                string warmingStr = parts[0].Substring(parts[0].Length - 1);
                warmingIdx = int.Parse(warmingStr);
                //int warmingDegrees = int.Parse(warmingStr);
                //warmingIdx = WarmingDegreesToIndex(warmingDegrees);

                //string text = ReadFile(folderPath + "/" + "fireDataList_0.json");
                string text = ReadFile(file);

                List<FireDataFrameRecord> fireData = JsonConvert.DeserializeObject<List<FireDataFrameRecord>>(text);
                List<FireDataFrameJSONRecord> jsonRecords = ConvertFireDataFrameRecordsToJSONRecords(fireData, warmingIdx);

                foreach (FireDataFrameJSONRecord record in jsonRecords)
                {
                    try
                    {
                        dal.AddFireDataFrame(record);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("ReadFireData()... ERROR... ex: " + ex.Message);
                    }
                }
            }
        }
        catch (Exception e)
        {
            //Debug.Log("InitializeData()... waterData ERROR: " + e.Message);
        }
    }

    public static void ReadTerrainData(string folderTerrain)
    {
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            // fireDataList_0.json  terrain_warm1_1942_10_4_4.json
            foreach (string file in Directory.EnumerateFiles(folderTerrain))
            {
                int warmingIdx = -1;

                string fileName = Path.GetFileNameWithoutExtension(file);
                Console.WriteLine("ReadTerrainData()... fileName: " + fileName);

                string[] parts = fileName.Split('.')[0].Split("_");
                string warmingStr = parts[1].Substring(parts[1].Length - 1);
                warmingIdx = int.Parse(warmingStr);

                string yearStr = parts[2];
                int year = int.Parse(yearStr);

                string monthStr = parts[3];
                int month = int.Parse(monthStr);

                string grainSizeStr = parts[4];
                int grainSize = int.Parse(grainSizeStr);

                string decPrecStr = parts[5];
                int decPrec = int.Parse(decPrecStr);

                string text = ReadFile(file);

                int[] flatArray = JsonConvert.DeserializeObject<int[]>(text);
                //int[,,] unflattened = Unflatten1DIntArrayTo3D(flatArray, inputWidth, 4);

                int gridHeight = 512 / grainSize;

                TerrainData terrainData = new TerrainData(month, year, gridHeight, 
                    grainSize, decPrec, flatArray);

                TerrainDataFrameJSONRecord jsonRecord = ConvertTerrainDataFrameRecordToJSONRecord(terrainData, 
                    warmingIdx, year, month, grainSize, decPrec);

                try
                {
                    dal.AddTerrainDataFrame(jsonRecord);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("ReadTerrainData()... ERROR... ex: " + ex.Message);
                }
            }
        }
        catch (Exception e)
        {
            //Debug.Log("InitializeData()... Terrain Data ERROR: " + e.Message);
        }
    }

    //private static int[,,] Unflatten1DIntArrayTo3D(int[] array, int terrainWidth, int zCount)
    //{
    //    int xCount = terrainWidth;
    //    int yCount = terrainWidth;
    //    //int zCount = 4;

    //    var output = new int[xCount, yCount, zCount];
    //    var index = 0;
    //    for (var x = 0; x < xCount; x++)
    //    for (var y = 0; y < yCount; y++)
    //    for (var z = 0; z < zCount; z++)
    //        output[x, y, z] = array[index++];

    //    return output;
    //}

    private static TerrainDataFrameJSONRecord ConvertTerrainDataFrameRecordToJSONRecord(TerrainData frame, int warmingIdx, int year, int month,
        int grainSize, int decimalPrecision)
    {
        TerrainDataFrameJSONRecord result = new TerrainDataFrameJSONRecord();

        TerrainDataFrameJSONRecord jsonRecord = frame.GetJsonRecord();
        jsonRecord.warmingIdx = warmingIdx;
        jsonRecord.year = year;
        jsonRecord.month = month;
        jsonRecord.gridSize = frame.gridSize;
        jsonRecord.pixelGrainSize = grainSize;
        jsonRecord.decimalPrecision = decimalPrecision;

        return jsonRecord;
    }

    private static List<FireDataFrameJSONRecord> ConvertFireDataFrameRecordsToJSONRecords(List<FireDataFrameRecord> frames, int warmingIdx)
    {
        List<FireDataFrameJSONRecord> results = new List<FireDataFrameJSONRecord>();

        foreach (FireDataFrameRecord record in frames)
        {
            FireDataFrameJSONRecord jsonRecord = record.GetJsonRecord();
            jsonRecord.warmingIdx = warmingIdx;
            results.Add(jsonRecord);
        }

        return results;
    }
    //private string ExportPatchExtents(Dictionary<int, PatchPointCollection> extents, string fileName, string path)
    //{
    //    if (path.Equals(""))
    //        path = EditorUtility.SaveFolderPanel("Choose a directory to save the landscape data files:", "", "");

    //    string json = JsonConvert.SerializeObject(extents, Formatting.None,
    //        new JsonSerializerSettings()
    //        {
    //            ReferenceLoopHandling = ReferenceLoopHandling.Ignore
    //        });

    //    File.WriteAllText(path + "/" + fileName + ".json", json);
    //    return path;
    //}

    public static void ReadPatchData(string folderPath)
    {
        // List<WaterDataYear> waterData;          // List of formatted water data by warming idx.
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            //TextAsset patchExtTextAsset = (TextAsset)Resources.Load("WaterData/WaterData");
            string text = ReadFile(folderPath + "/" + "PatchData.json");
            Dictionary<int, PatchPointCollection> patchData = JsonConvert.DeserializeObject<Dictionary<int, PatchPointCollection>>(text);
            foreach (int i in patchData.Keys)
            {
                try
                {
                    PatchPointCollection coll = patchData[i];
                    coll.id++;
                    dal.AddPatchData(i, coll);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("ReadWaterData()... ERROR... ex: " + ex.Message);
                }
            }
        }
        catch (Exception ex)
        {
            //Debug.Log("InitializeData()... waterData ERROR: " + e.Message);
        }
    }


    /// <summary>
    /// Initializes cube data arrays from data file.
    /// </summary>
    /// <param name="dataFile">Data file.</param>
    public static void ReadDates(string folderAggregate)
    {
        RHESSYsDAL dal = new RHESSYsDAL();

        try
        {
            foreach (string file in Directory.EnumerateFiles(folderAggregate))
            {
                string fileName = Path.GetFileNameWithoutExtension(file);
                Console.WriteLine("Importing dates from file: " + fileName);

                if (fileName.Contains("hist"))      // Take first file
                {
                    List<string> lines = ReadLinesFromFile(file);
                    Console.WriteLine("Read " + lines.Count + " lines from file " + fileName);

                    int count = 0;
                    foreach (string line in lines)
                    {
                        if (count > 0)
                            AddDate(line);

                        if(count % 10000 == 0 && count > 0)
                            Console.WriteLine("Added " + count + " dates from file " + fileName);

                        count++;
                    }
                }
            }

        }
        catch (Exception e)
        {
            Console.WriteLine("Exception: " + e.Message);
        }
        finally
        {
            Console.WriteLine("Finished...");
        }

        void AddDate(string line)
        {
            string[] str = line.Split(' ');

            Date date = new Date();

            //date.id; Primary key --> add in SQL Server
            date.year = int.Parse(str[18]);
            date.month = int.Parse(str[19]);
            date.day = int.Parse(str[20]);
            date.date = new DateTime(date.year, date.month, date.day);

            dal.AddDate(date);
        }
    }

    /// <summary>
    /// Text asset to list.
    /// </summary>
    /// <returns>The asset to list.</returns>
    /// <param name="ta">Ta.</param>
    private static List<string> ReadLinesFromFile(string filePath)
    {
        List<string> lines = new List<string>();
        string line;

        //Console.WriteLine("ReadLinesFromFile()... filePath: " + filePath);

        // Pass the file path and file name to the StreamReader constructor
        StreamReader sr = new StreamReader(filePath);
        // Read the first line of text

        int ct = 0;
        line = sr.ReadLine();
        // Continue to read until you reach end of file
        while (line != null)
        {
            //Console.WriteLine(line);
            lines.Add(line);

            //Read the next line
            line = sr.ReadLine();
        }

        sr.Close();        // Close file
        return lines;
    }

    /// <summary>
    /// Text asset to list.
    /// </summary>
    /// <returns>The asset to list.</returns>
    /// <param name="ta">Ta.</param>
    private static string ReadFile(string filePath)
    {
        //List<string> lines = new List<string>();
        string text;

        //Console.WriteLine("ReadFile()... filePath: " + filePath);

        // Pass the file path and file name to the StreamReader constructor
        StreamReader sr = new StreamReader(filePath);
        // Read the first line of text

        int ct = 0;
        text = sr.ReadToEnd();
        // Continue to read until you reach end of file
        //while (text != null)
        //{
        //    //Console.WriteLine(line);
        //    lines.Add(text);

        //    //Read the next line
        //    text = sr.ReadLine();
        //}

        sr.Close();        // Close file
        return text;
    }
}
