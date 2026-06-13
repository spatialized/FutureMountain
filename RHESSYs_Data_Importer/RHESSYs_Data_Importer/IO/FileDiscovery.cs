using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using RHESSYs_Data_Importer.Configuration;

namespace RHESSYs_Data_Importer.IO
{
    public class FileDiscoveryResult
    {
        public Dictionary<string, List<string>> FilesByCategory { get; } = new(StringComparer.OrdinalIgnoreCase);
        public List<string> Warnings { get; } = new();

        public int Count(string category) => FilesByCategory.TryGetValue(category, out var list) ? list.Count : 0;
        public IEnumerable<string> Categories => FilesByCategory.Keys;
    }

    public static class FileDiscovery
    {
        private static readonly string[] Categories = new[] { "cube", "patch", "terrain", "fire", "water", "climate" };

        public static FileDiscoveryResult FindFiles(ScenarioConfig config)
        {
            var result = new FileDiscoveryResult();
            if (config.InputFolders == null || config.InputFolders.Count == 0)
            {
                result.Warnings.Add("[WARN] No input folders defined in ScenarioConfig.");
                return result;
            }
            if (config.FilePatterns == null || config.FilePatterns.Count == 0)
            {
                result.Warnings.Add("[WARN] No file patterns defined in ScenarioConfig.");
                return result;
            }

            // Normalize folder paths
            var normalizedFolders = config.InputFolders
                .Select(kv => new KeyValuePair<string, string>(kv.Key, NormalizeFolder(kv.Value)))
                .ToList();

            foreach (var folder in normalizedFolders)
            {
                if (!Directory.Exists(folder.Value))
                {
                    result.Warnings.Add($"[WARN] Input folder not found: {folder.Key} -> {folder.Value}");
                }
            }

            foreach (var category in Categories)
            {
                var files = new List<string>();
                if (!config.FilePatterns.TryGetValue(category, out var pattern) || string.IsNullOrWhiteSpace(pattern))
                {
                    result.Warnings.Add($"[WARN] No file pattern provided for category '{category}'.");
                    result.FilesByCategory[category] = files;
                    continue;
                }

                foreach (var folder in normalizedFolders)
                {
                    var dir = folder.Value;
                    try
                    {
                        if (Directory.Exists(dir))
                        {
                            // Search only top-level of each provided folder
                            files.AddRange(Directory.GetFiles(dir, pattern, SearchOption.TopDirectoryOnly));
                        }
                    }
                    catch (Exception ex)
                    {
                        result.Warnings.Add($"[WARN] Error searching folder '{dir}' for '{category}' with pattern '{pattern}': {ex.Message}");
                    }
                }

                if (files.Count == 0)
                {
                    result.Warnings.Add($"[WARN] No files matched for category '{category}' using pattern '{pattern}' in any input folder.");
                }

                // De-duplicate and normalize separators
                result.FilesByCategory[category] = files
                    .Select(f => Path.GetFullPath(f))
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToList();
            }

            return result;
        }

        private static string NormalizeFolder(string path)
        {
            // Expand to full path relative to current working directory
            var full = Path.GetFullPath(path);
            return full.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        }
    }
}
