using System;
using System.Collections.Generic;
using System.Linq;

namespace RHESSYs_Data_Importer.IO
{
    /// <summary>
    /// Validation result for a single source file.
    /// </summary>
    public class FileValidationResult
    {
        public string Role { get; set; }
        public string FilePath { get; set; }
        public bool Exists { get; set; }
        public long RowCount { get; set; }
        public long ExpectedRowCount { get; set; }
        public string[] Headers { get; set; }
        public string[] MissingHeaders { get; set; } = Array.Empty<string>();

        /// <summary>First date found in the file (for daily) or year-month.</summary>
        public DateTime? FirstDate { get; set; }

        /// <summary>Last date found in the file (for daily) or year-month.</summary>
        public DateTime? LastDate { get; set; }

        /// <summary>Unique zoneIDs found (cube files only).</summary>
        public List<int> ZoneIDs { get; set; } = new();

        /// <summary>Unique patchIDs found (patch-level files only).</summary>
        public long UniquePatchCount { get; set; }

        /// <summary>Unique stratumIDs found (stratum-level files only).</summary>
        public long UniqueStratumCount { get; set; }

        /// <summary>Rows per day (daily cube files only).</summary>
        public int? RowsPerDay { get; set; }

        public bool IsRowCountValid => !Exists || RowCount == ExpectedRowCount;
    }

    /// <summary>
    /// Aggregated validation report for a Central Coast import.
    /// </summary>
    public class ValidationReport
    {
        public List<string> Errors { get; } = new();
        public List<string> Warnings { get; } = new();
        public List<string> Info { get; } = new();

        public Dictionary<string, FileValidationResult> Files { get; } = new(StringComparer.OrdinalIgnoreCase);

        public bool IsValid => Errors.Count == 0;

        public void Print()
        {
            Console.WriteLine("\n=== Central Coast Import Validation Report ===\n");

            foreach (var info in Info)
                Console.WriteLine($"[INFO] {info}");

            foreach (var file in Files.Values.OrderBy(f => f.Role))
            {
                Console.WriteLine($"  {file.Role}: {file.FilePath}");
                if (!file.Exists)
                {
                    Console.WriteLine($"    [ERROR] File not found.");
                    continue;
                }
                Console.WriteLine($"    Rows: {file.RowCount:N0} (expected: {file.ExpectedRowCount:N0})");
                if (!file.IsRowCountValid)
                    Console.WriteLine($"    [WARN] Row count mismatch.");
                if (file.FirstDate.HasValue && file.LastDate.HasValue)
                    Console.WriteLine($"    Date range: {file.FirstDate.Value:yyyy-MM-dd} to {file.LastDate.Value:yyyy-MM-dd}");
                if (file.RowsPerDay.HasValue)
                    Console.WriteLine($"    Rows per day: {file.RowsPerDay.Value}");
                if (file.ZoneIDs.Count > 0)
                    Console.WriteLine($"    ZoneIDs: {string.Join(", ", file.ZoneIDs.OrderBy(z => z))}");
                if (file.UniquePatchCount > 0)
                    Console.WriteLine($"    Unique patches: {file.UniquePatchCount:N0}");
                if (file.UniqueStratumCount > 0)
                    Console.WriteLine($"    Unique strata: {file.UniqueStratumCount:N0}");
                if (file.MissingHeaders.Length > 0)
                    Console.WriteLine($"    [WARN] Missing headers: {string.Join(", ", file.MissingHeaders)}");
            }

            foreach (var warn in Warnings)
                Console.WriteLine($"[WARN] {warn}");

            foreach (var err in Errors)
                Console.WriteLine($"[ERROR] {err}");

            Console.WriteLine($"\nValidation result: {(IsValid ? "PASSED" : "FAILED")}");
            Console.WriteLine($"  Errors:   {Errors.Count}");
            Console.WriteLine($"  Warnings: {Warnings.Count}");
            Console.WriteLine($"  Info:     {Info.Count}");
        }
    }
}
