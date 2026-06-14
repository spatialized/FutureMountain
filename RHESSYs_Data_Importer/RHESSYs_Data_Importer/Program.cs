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
bool importStratumData = importAll;

// Data Folders
string folderAggregate = Path.GetFullPath("../Data/BigCreek/aggregate");
string folderCubes = Path.GetFullPath("../Data/BigCreek/fire_cubes");
string folderWater = Path.GetFullPath("../Data/BigCreek/water");
string folderFire = Path.GetFullPath("../Data/BigCreek/fire");
string folderPatchData = Path.GetFullPath("../Data/BigCreek/patch_data");
string folderTerrainData = Path.GetFullPath("../Data/BigCreek/terrain_data");

ScenarioConfig? activeConfig = null;
FileDiscoveryResult? discovered = null;

Console.WriteLine("-- RHESSYS Data Importer v2.0 --");
Console.WriteLine("-- by David Gordon --");
Console.WriteLine("");
Console.WriteLine("Running...");
{
    ScenarioConfig config;
    // --config <path> overrides the default config file
    string configPath = "ScenarioConfig_BigCreek.json";
    int configArgIdx = Array.IndexOf(Environment.GetCommandLineArgs(), "--config");
    if (configArgIdx >= 0 && configArgIdx + 1 < Environment.GetCommandLineArgs().Length)
        configPath = Environment.GetCommandLineArgs()[configArgIdx + 1];

    if (File.Exists(configPath))
    {
        config = ScenarioConfigLoader.Load(configPath);
        Console.WriteLine($"Loaded scenario: {config.ScenarioName}");

        // Resolve the explicit data-model profile. Behavior must be driven by the
        // profile, never inferred from table names or which files are present.
        ScenarioProfileKind profileKind;
        try
        {
            profileKind = config.GetProfileKind();
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine($"[ERROR] {ex.Message}");
            Console.WriteLine("Import aborted.");
            return;
        }

        if (string.IsNullOrWhiteSpace(config.ScenarioProfile))
            Console.WriteLine($"[INFO] No scenarioProfile set. Defaulting to {ScenarioProfiles.ToCanonicalString(profileKind)}.");
        Console.WriteLine($"Scenario profile: {ScenarioProfiles.ToCanonicalString(profileKind)}");

        Console.WriteLine($"Database: {config.Database.Name} @ {config.Database.Host}:{config.Database.Port}");
        // Make connection string available to all DbContexts.
        // If the config has no password, check appsettings.Local.json (gitignored) for one.
        var dbCs = config.Database.GetConnectionString();
        if (string.IsNullOrEmpty(config.Database.Password))
        {
            var localPw = ConnectionHelper.GetLocalPassword();
            if (!string.IsNullOrEmpty(localPw))
                dbCs = dbCs.Replace("password=;", $"password={localPw};");
        }
        ConnectionHelper.SetOverride(dbCs);
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
bool flagStratum = arguments.Contains("--stratum");
bool flagDates = arguments.Contains("--dates");

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

    // Central Coast pre-import validation
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        Console.WriteLine("[AUTO MODE] Running Central Coast validation...");
        var validation = CentralCoastValidator.Validate(activeConfig);
        validation.Print();
        if (!validation.IsValid && !force)
        {
            Console.WriteLine("[AUTO MODE] Validation failed. Use --force to proceed anyway.");
            return;
        }
        Console.WriteLine("[AUTO MODE] Validation passed. Starting import...");
    }

    // Set category imports based on flags; if none specified, import all
    bool anyCategoryFlag = flagCubes || flagPatch || flagTerrain || flagFire || flagWater || flagClimate || flagStratum || flagDates;
    if (anyCategoryFlag)
    {
        importCubeData = flagCubes;
        importPatchData = flagPatch;
        importTerrainData = flagTerrain;
        importFireData = flagFire;
        importWaterData = flagWater;
        importStratumData = flagStratum;
        importDates = flagDates;
        // Climate not yet implemented; placeholder only
    }
    else
    {
        importCubeData = true;
        importPatchData = true;
        importTerrainData = true;
        importFireData = true;
        importWaterData = true;
        importStratumData = true;
        importDates = true;
    }
}

// -- TO DO: Check that Dates table exists
//           Check that CubeData table exists

if (importDates)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        Console.WriteLine("[AUTO MODE] --- Importing dates ---");
        CentralCoastImporter.ImportDates(activeConfig, dryrun);
    }
    else
    {
        TextFileInput.ReadDates(folderAggregate);
    }
}
if(importCubeData)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        CentralCoastImporter.EnsureOrPopulateDates(activeConfig, dryrun);
        Console.WriteLine("[AUTO MODE] --- Importing cube patch data ---");
        CentralCoastImporter.ImportCubePatchData(activeConfig, dryrun);
        Console.WriteLine("[AUTO MODE] --- Importing cube stratum data ---");
        CentralCoastImporter.ImportCubeStratumData(activeConfig, dryrun);
    }
    else if (activeConfig != null && discovered != null && discovered.Count("cube") > 0)
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
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        CentralCoastImporter.EnsureOrPopulateDates(activeConfig, dryrun);
        Console.WriteLine("[AUTO MODE] --- Importing water data ---");
        CentralCoastImporter.ImportWaterData(activeConfig, dryrun);
    }
    else
    {
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would import Water data (legacy)");
        else
            TextFileInput.ReadWaterData(folderWater);
    }
}
if (importFireData)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        Console.WriteLine("[AUTO MODE] --- Importing fire data ---");
        CentralCoastImporter.ImportBasinBurnData(activeConfig, dryrun);
        CentralCoastImporter.ImportPatchBurnData(activeConfig, dryrun);
    }
    else
    {
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would import Fire data (legacy)");
        else
            TextFileInput.ReadFireData(folderFire);
    }
}
if (importPatchData)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        Console.WriteLine("[AUTO MODE] --- Importing patch data ---");
        CentralCoastImporter.ImportPatchMapData(activeConfig, dryrun);
    }
    else
    {
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would import Patch data (legacy)");
        else
            TextFileInput.ReadPatchData(folderPatchData);
    }
}
if (importStratumData)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        // CCV2: stratum must run before terrain generation
        Console.WriteLine("[AUTO MODE] --- Importing stratum carbon data ---");
        CentralCoastImporter.ImportStratumCarbonData(activeConfig, dryrun);
    }
    else
    {
        Console.WriteLine("[INFO] Stratum import not implemented for legacy profiles.");
    }
}
if (importTerrainData)
{
    if (activeConfig != null && activeConfig.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
    {
        // CCV2: terrain generation reads from PatchData, StratumData, FireData
        // -- must run after patch, stratum, and fire imports
        Console.WriteLine("[AUTO MODE] --- Generating terrain data ---");
        CentralCoastImporter.GenerateTerrainData(activeConfig, dryrun);
    }
    else
    {
        if (dryrun)
            Console.WriteLine("[DRY RUN] Would import Terrain data (legacy)");
        else
            TextFileInput.ReadTerrainData(folderTerrainData);
    }
}

Console.WriteLine("Finished importing data successfully...");

// See https://aka.ms/new-console-template for more information
