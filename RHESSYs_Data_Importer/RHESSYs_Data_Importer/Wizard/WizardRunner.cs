using System;
using System.Collections.Generic;
using System.Linq;
using RHESSYs_Data_Importer.Configuration;
using RHESSYs_Data_Importer.IO;

namespace RHESSYs_Data_Importer.Wizard
{
    public static class WizardRunner
    {
        public static void Run(ScenarioConfig config, bool dryrun = false)
        {
            Console.WriteLine("---------------------------------");
            Console.WriteLine(" RHESSys Data Importer Wizard");
            Console.WriteLine("---------------------------------");

            // 1. Confirm Scenario
            Console.WriteLine($"Loaded scenario: {config.ScenarioName}");
            Console.WriteLine($"Scenario profile: {ScenarioProfiles.ToCanonicalString(config.GetProfileKind())}");
            Console.WriteLine($"Database: {config.Database.Name} @ {config.Database.Host}:{config.Database.Port}");
            Console.WriteLine();
            Console.WriteLine("Options:");
            Console.WriteLine("  [1] Continue with this scenario");
            Console.WriteLine("  [2] Load another config (enter path)");
            Console.WriteLine("  [3] Exit");
            Console.Write("> ");
            var choice = Console.ReadLine();
            if (choice == "2")
            {
                Console.Write("Enter path to ScenarioConfig JSON: ");
                var path = Console.ReadLine();
                try
                {
                    if (!string.IsNullOrWhiteSpace(path))
                    {
                        config = ScenarioConfigLoader.Load(path);
                        Console.WriteLine($"Loaded scenario: {config.ScenarioName}");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[ERROR] Failed to load config: {ex.Message}");
                    return;
                }
            }
            else if (choice == "3")
            {
                return;
            }

            // 2. Confirm database usage
            Console.WriteLine("Use existing database/schema or open setup guidance?");
            Console.WriteLine("  [1] Use existing");
            Console.WriteLine("  [2] Show schema setup guidance");
            Console.Write("> ");
            var dbChoice = Console.ReadLine();
            if (dbChoice == "2")
            {
                if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
                {
                    Console.WriteLine();
                    Console.WriteLine("[CentralCoastV2] Create/select schema 'futuremtn_central_coast' in MySQL Workbench,");
                    Console.WriteLine("then run Database/Schema/CentralCoastV2_schema.sql against that schema.");
                    Console.WriteLine("Do not create Central Coast tables in defaultdb.");
                }
                else
                {
                    Helpers.DatabaseHelper.CreateNewDatabase(config);
                }
            }

            // 3. Detect files
            var discovery = FileDiscovery.FindFiles(config);
            foreach (var warn in discovery.Warnings)
                Console.WriteLine(warn);

            Console.WriteLine("\nDetected Files:");
            if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
                Console.WriteLine("  dates: derived from cubeAggregateDaily");

            foreach (var cat in new[] { "cube", "patch", "terrain", "burn", "fire", "water", "climate", "stratum" })
            {
                if (cat == "stratum" && config.GetProfileKind() != ScenarioProfileKind.CentralCoastV2)
                    continue;
                Console.WriteLine($"  {cat}: {discovery.Count(cat)} file(s)");
            }

            // 3b. Central Coast validation (dry-run report)
            if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
            {
                Console.WriteLine("\n[CentralCoastV2] Running pre-import validation...");
                var validation = CentralCoastValidator.Validate(config);
                validation.Print();

                if (!validation.IsValid)
                {
                    Console.WriteLine("\nValidation failed. Continue anyway? [y/N]");
                    var cont = Console.ReadLine();
                    if (!string.Equals(cont, "y", StringComparison.OrdinalIgnoreCase))
                    {
                        Console.WriteLine("Import canceled.");
                        return;
                    }
                }
            }

            // 4. Confirm which categories to import
            var selected = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            while (true)
            {
                Console.WriteLine("\nSelect which data types to import:");
                if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
                {
                    Console.WriteLine("  [1] Dates");
                    Console.WriteLine("  [2] Cube");
                    Console.WriteLine("  [3] Water");
                    Console.WriteLine("  [4] Burn");
                    Console.WriteLine("  [5] Patch");
                    Console.WriteLine("  [6] Stratum");
                    Console.WriteLine("  [7] Terrain");
                    Console.WriteLine("  [8] Fire (configured fire-frame source)");
                }
                else
                {
                    Console.WriteLine("  [1] Cube");
                    Console.WriteLine("  [2] Patch");
                    Console.WriteLine("  [3] Terrain");
                    Console.WriteLine("  [4] Fire");
                    Console.WriteLine("  [5] Water");
                    Console.WriteLine("  [6] Climate");
                }
                Console.WriteLine("  [0] Done selecting");
                Console.Write("> ");
                var sel = Console.ReadLine();
                if (sel == "0") break;
                if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
                {
                    switch (sel)
                    {
                        case "1": selected.Add("dates"); break;
                        case "2": selected.Add("cube"); break;
                        case "3": selected.Add("water"); break;
                        case "4": selected.Add("burn"); break;
                        case "5": selected.Add("patch"); break;
                        case "6": selected.Add("stratum"); break;
                        case "7": selected.Add("terrain"); break;
                        case "8": selected.Add("fire"); break;
                        default: Console.WriteLine("[WARN] Unknown selection."); break;
                    }
                }
                else
                {
                    switch (sel)
                    {
                        case "1": selected.Add("cube"); break;
                        case "2": selected.Add("patch"); break;
                        case "3": selected.Add("terrain"); break;
                        case "4": selected.Add("fire"); break;
                        case "5": selected.Add("water"); break;
                        case "6": selected.Add("climate"); break;
                        default: Console.WriteLine("[WARN] Unknown selection."); break;
                    }
                }
            }

            // 5. Preview column mappings (if any)
            Console.WriteLine("\nPreview column mapping for CubeDataPoint? [Y/n]");
            var preview = Console.ReadLine();
            if (!string.Equals(preview, "n", StringComparison.OrdinalIgnoreCase))
            {
                if (config.ColumnMapping != null && config.ColumnMapping.TryGetValue("cube", out var map))
                {
                    Console.WriteLine("Cube column mapping (source -> target):");
                    foreach (var kv in map)
                        Console.WriteLine($"  {kv.Key} -> {kv.Value}");
                }
                else
                {
                    Console.WriteLine("[INFO] No cube mapping defined in config.");
                }
            }

            // 6. Confirm and run import
            Console.WriteLine("\nReady to start import? [Y/n]");
            var startKey = Console.ReadLine();
            if (!string.Equals(startKey, "n", StringComparison.OrdinalIgnoreCase))
            {
                Console.WriteLine("\nStarting import...");
                RunSelectedImports(config, discovery, selected, dryrun);
            }
            else
            {
                Console.WriteLine("\nImport canceled.");
            }
        }

        private static void RunSelectedImports(ScenarioConfig config, FileDiscoveryResult discovery, HashSet<string> selected, bool dryrun)
        {
            if (config.GetProfileKind() == ScenarioProfileKind.CentralCoastV2)
            {
                RunCentralCoastImports(config, discovery, selected, dryrun);
                return;
            }

            if (selected.Contains("cube"))
            {
                var files = discovery.FilesByCategory.ContainsKey("cube") ? discovery.FilesByCategory["cube"] : new List<string>();
                Console.WriteLine($"[Cube] {files.Count} file(s)");
                if (!dryrun)
                {
                    if (files.Count > 0)
                        TextFileInput.ReadCubeDataFiles(files, config);
                    else
                        Console.WriteLine("[WARN] No cube files discovered.");
                }
            }

            string[] catOrder = new[] { "patch", "terrain", "fire", "water", "climate", "stratum" };

            foreach (var cat in catOrder)
            {
                if (!selected.Contains(cat)) continue;
                var count = discovery.Count(cat);
                Console.WriteLine($"[{cat}] {count} file(s)");

                if (!dryrun)
                    Console.WriteLine($"[INFO] Import for category '{cat}' not yet implemented in wizard mode.");
            }
        }

        private static void RunCentralCoastImports(ScenarioConfig config, FileDiscoveryResult discovery, HashSet<string> selected, bool dryrun)
        {
            string[] catOrder = new[] { "dates", "cube", "water", "burn", "fire", "patch", "stratum", "terrain" };

            foreach (var cat in catOrder)
            {
                if (!selected.Contains(cat)) continue;

                if (cat == "dates")
                    Console.WriteLine("[dates] derived from cubeAggregateDaily");
                else
                    Console.WriteLine($"[{cat}] {discovery.Count(cat)} file(s)");

                switch (cat)
                {
                    case "dates":
                        CentralCoastImporter.ImportDates(config, dryrun);
                        break;
                    case "cube":
                        CentralCoastImporter.EnsureOrPopulateDates(config, dryrun);
                        CentralCoastImporter.ImportCubePatchData(config, dryrun);
                        CentralCoastImporter.ImportCubeStratumData(config, dryrun);
                        break;
                    case "water":
                        CentralCoastImporter.EnsureOrPopulateDates(config, dryrun);
                        CentralCoastImporter.ImportWaterData(config, dryrun);
                        break;
                    case "burn":
                        CentralCoastImporter.ImportBasinBurnData(config, dryrun);
                        CentralCoastImporter.ImportPatchBurnData(config, dryrun);
                        break;
                    case "fire":
                        Console.WriteLine("[INFO] No fire-frame source is configured for this scenario. Use burn for monthly RHESSys burn data.");
                        break;
                    case "patch":
                        CentralCoastImporter.ImportPatchMapData(config, dryrun);
                        break;
                    case "stratum":
                        CentralCoastImporter.ImportStratumCarbonData(config, dryrun);
                        break;
                    case "terrain":
                        Console.WriteLine("[TerrainData] Requires completed PatchData, BurnData, and StratumData.");
                        CentralCoastImporter.GenerateTerrainData(config, dryrun);
                        break;
                }
            }
        }
    }
}
