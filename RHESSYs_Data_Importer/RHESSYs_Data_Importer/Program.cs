// Program to import RHESSYs data into MSSQL or MySQL database
// Note: Change USE_MYSQL compilation symbol to switch between MySQL and MSSQL

using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.DAL;
using RHESSYs_Data_Importer.IO;
using RHESSYs_Data_Importer.Wizard;
using System.Linq;

bool importAll = false;
bool importDates = importAll;
bool importCubeData = importAll;
bool importWaterData = importAll;
bool importFireData = importAll;
bool importPatchData = importAll;
bool importTerrainData = importAll;

// Data Folders
string folderAggregate = "C:\\Users\\Redux\\Documents\\FutureMountain\\aggregate";      
string folderCubes = "C:\\Users\\Redux\\Documents\\FutureMountain\\fire_cubes";
string folderWater = "C:\\Users\\Redux\\Documents\\FutureMountain\\water";
string folderFire = "C:\\Users\\Redux\\Documents\\FutureMountain\\fire";
string folderPatchData = "C:\\Users\\Redux\\Documents\\FutureMountain\\patch_data";
string folderTerrainData = "C:\\Users\\Redux\\Documents\\FutureMountain\\terrain_data";

ScenarioConfig? activeConfig = null;
FileDiscoveryResult? discovered = null;

Console.WriteLine("-- RHESSYS Data Importer v2.0 --");
Console.WriteLine("-- by David Gordon --");
Console.WriteLine("");
Console.WriteLine("Running...");
{
    ScenarioConfig config;
    const string defaultConfigPath = "ScenarioConfig_BigCreek.json";

    if (File.Exists(defaultConfigPath))
    {
        config = ScenarioConfigLoader.Load(defaultConfigPath);
        Console.WriteLine($"Loaded scenario: {config.ScenarioName}");
        Console.WriteLine($"Database: {config.Database.Name} @ {config.Database.Host}:{config.Database.Port}");
        // Make connection string available to all DbContexts
        ConnectionHelper.SetOverride(config.Database.GetConnectionString());
        activeConfig = config;

        // Dynamic file discovery
        discovered = FileDiscovery.FindFiles(config);
        foreach (var warn in discovered.Warnings)
            Console.WriteLine(warn);

        Console.WriteLine("-- File Discovery Summary --");
        foreach (var cat in new[] { "cube", "patch", "terrain", "fire", "water", "climate" })
        {
            var count = discovered.Count(cat);
            Console.WriteLine($"{cat}: {count} files");
        }
    }
    else
    {
        Console.WriteLine("No ScenarioConfig.json found. Running legacy Big Creek importer...");
    }
}

// Parse flags for automation
var arguments = Environment.GetCommandLineArgs().Skip(1).ToArray();
bool auto = arguments.Contains("--auto");
bool dryrun = arguments.Contains("--dryrun");
bool force = arguments.Contains("--force");
bool flagCubes = arguments.Contains("--cubes");
bool flagPatch = arguments.Contains("--patch");
bool flagTerrain = arguments.Contains("--terrain");
bool flagFire = arguments.Contains("--fire");
bool flagWater = arguments.Contains("--water");
bool flagClimate = arguments.Contains("--climate");

if (!auto)
{
    if (activeConfig != null)
    {
        WizardRunner.Run(activeConfig, dryrun);
        return;
    }
    // No config available: continue legacy flow below
}
else
{
    Console.WriteLine("[AUTO MODE] Starting headless import...");
    if (dryrun) Console.WriteLine("[AUTO MODE] Dry run enabled (no DB writes)");
    if (force) Console.WriteLine("[AUTO MODE] Force flag enabled");

    // Set category imports based on flags; if none specified, import all
    bool anyCategoryFlag = flagCubes || flagPatch || flagTerrain || flagFire || flagWater || flagClimate;
    if (anyCategoryFlag)
    {
        importCubeData = flagCubes;
        importPatchData = flagPatch;
        importTerrainData = flagTerrain;
        importFireData = flagFire;
        importWaterData = flagWater;
        // Climate not yet implemented; placeholder only
    }
    else
    {
        importCubeData = true;
        importPatchData = true;
        importTerrainData = true;
        importFireData = true;
        importWaterData = true;
    }
}

// -- TO DO: Check that Dates table exists
//           Check that CubeData table exists

if(importDates)
    TextFileInput.ReadDates(folderAggregate);
if(importCubeData)
{
    if (activeConfig != null && discovered != null && discovered.Count("cube") > 0)
    {
        if (dryrun)
            Console.WriteLine($"[DRY RUN] Would import {discovered.Count("cube")} cube file(s)");
        else
            TextFileInput.ReadCubeDataFiles(discovered.FilesByCategory["cube"], activeConfig);
    }
    else if (activeConfig != null && discovered != null && discovered.Count("cube") == 0)
    {
        Console.WriteLine("[WARN] No cube files discovered via config. Falling back to legacy cube importer.");
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would run legacy cube importer (no config-discovered files)");
        else
            TextFileInput.ReadCubeData(folderAggregate, folderCubes);
    }
    else
    {
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would run legacy cube importer (no config loaded)");
        else
            TextFileInput.ReadCubeData(folderAggregate, folderCubes);
    }
}
if (importWaterData)
{
    if (dryrun)
        Console.WriteLine("[DRY RUN] Would import Water data (legacy)");
    else
        TextFileInput.ReadWaterData(folderWater);
}
if (importFireData)
{
    if (dryrun)
        Console.WriteLine("[DRY RUN] Would import Fire data (legacy)");
    else
        TextFileInput.ReadFireData(folderFire);
}
if (importPatchData)
{
    if (dryrun)
        Console.WriteLine("[DRY RUN] Would import Patch data (legacy)");
    else
        TextFileInput.ReadPatchData(folderPatchData);
}
if (importTerrainData)
{
    if (dryrun)
        Console.WriteLine("[DRY RUN] Would import Terrain data (legacy)");
    else
        TextFileInput.ReadTerrainData(folderTerrainData);
}

Console.WriteLine("Finished importing data successfully...");

// See https://aka.ms/new-console-template for more information
