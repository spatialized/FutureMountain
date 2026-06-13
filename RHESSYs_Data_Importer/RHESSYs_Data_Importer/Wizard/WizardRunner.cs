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
            Console.WriteLine("Use existing database or create a new one?");
            Console.WriteLine("  [1] Use existing");
            Console.WriteLine("  [2] Create new database");
            Console.Write("> ");
            var dbChoice = Console.ReadLine();
            if (dbChoice == "2")
            {
                Helpers.DatabaseHelper.CreateNewDatabase(config);
            }

            // 3. Detect files
            var discovery = FileDiscovery.FindFiles(config);
            foreach (var warn in discovery.Warnings)
                Console.WriteLine(warn);

            Console.WriteLine("\nDetected Files:");
            foreach (var cat in new[] { "cube", "patch", "terrain", "fire", "water", "climate" })
            {
                Console.WriteLine($"  {cat}: {discovery.Count(cat)} file(s)");
            }

            // 4. Confirm which categories to import
            var selected = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            while (true)
            {
                Console.WriteLine("\nSelect which data types to import:");
                Console.WriteLine("  [1] Cube");
                Console.WriteLine("  [2] Patch");
                Console.WriteLine("  [3] Terrain");
                Console.WriteLine("  [4] Fire");
                Console.WriteLine("  [5] Water");
                Console.WriteLine("  [6] Climate");
                Console.WriteLine("  [0] Done selecting");
                Console.Write("> ");
                var sel = Console.ReadLine();
                if (sel == "0") break;
                switch (sel)
                {
                    case "1": selected.Add("cube"); break;
                    case "2": selected.Add("patch"); break;
                    case "3": selected.Add("terrain"); break;
                    case "4": selected.Add("fire"); break;
                    case "5": selected.Add("water"); break;
                    case "6": selected.Add("climate"); break;
                    default:
                        Console.WriteLine("[WARN] Unknown selection.");
                        break;
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

            foreach (var cat in new[] { "patch", "terrain", "fire", "water", "climate" })
            {
                if (!selected.Contains(cat)) continue;
                var count = discovery.Count(cat);
                Console.WriteLine($"[{cat}] {count} file(s)");
                if (dryrun) continue;
                Console.WriteLine($"[INFO] Import for category '{cat}' not yet implemented in wizard mode.");
            }
        }
    }
}
