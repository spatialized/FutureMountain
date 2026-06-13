using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using RHESSYs_Data_Importer.Configuration;

namespace RHESSYs_Data_Importer.IO
{
    /// <summary>
    /// Validates Central Coast v2 source files before import.
    ///
    /// Performs streaming validation so large files (e.g. 3.4M and 6.8M rows)
    /// do not exhaust memory. Reports row counts, date ranges, expected
    /// zoneIDs, and per-day/per-month row counts.
    /// </summary>
    public static class CentralCoastValidator
    {
        // Expected constants from the current sample bundle.
        private static readonly DateTime ExpectedDailyStart = new(1987, 07, 01);
        private static readonly DateTime ExpectedDailyEnd = new(2019, 06, 30);
        private static readonly int ExpectedDailyCount = 11688;
        private static readonly int ExpectedMonthlyCount = 384;
        private static readonly int ExpectedRowsPerCubeDay = 5;
        private static readonly int[] ExpectedZoneIDs = new[] { 12166, 12771, 6492, 18891, 10071 };
        private static readonly long ExpectedPatchCount = 8954;
        private static readonly long ExpectedStratumCount = 17908;

        /// <summary>
        /// Validates all configured Central Coast source files and returns a report.
        /// </summary>
        public static ValidationReport Validate(ScenarioConfig config)
        {
            var report = new ValidationReport();
            report.Info.Add($"Validating scenario: {config.ScenarioName} ({config.ScenarioProfile})");
            report.Info.Add($"ScenarioRunId: {config.ScenarioRunId}, WarmingIdx: {config.WarmingIdx}");

            if (config.Files == null || config.Files.Count == 0)
            {
                report.Errors.Add("No file roles configured in scenario config.");
                return report;
            }

            foreach (var role in config.Files.Keys.OrderBy(k => k))
            {
                var path = config.GetSourceFilePath(role);
                if (string.IsNullOrWhiteSpace(path))
                {
                    report.Errors.Add($"File role '{role}' is not mapped to a path.");
                    continue;
                }

                var result = ValidateFile(role, path);
                report.Files[role] = result;

                if (!result.Exists)
                {
                    report.Errors.Add($"File not found for role '{role}': {path}");
                    continue;
                }

                // Row-count checks
                if (!result.IsRowCountValid)
                {
                    report.Warnings.Add(
                        $"{role}: row count {result.RowCount:N0} does not match expected {result.ExpectedRowCount:N0}.");
                }

                // Daily date-range checks
                if (result.FirstDate.HasValue && result.LastDate.HasValue)
                {
                    if (role.StartsWith("cube", StringComparison.OrdinalIgnoreCase) ||
                        role.StartsWith("water", StringComparison.OrdinalIgnoreCase))
                    {
                        if (result.FirstDate.Value != ExpectedDailyStart)
                            report.Warnings.Add($"{role}: first date {result.FirstDate.Value:yyyy-MM-dd} != expected {ExpectedDailyStart:yyyy-MM-dd}.");
                        if (result.LastDate.Value != ExpectedDailyEnd)
                            report.Warnings.Add($"{role}: last date {result.LastDate.Value:yyyy-MM-dd} != expected {ExpectedDailyEnd:yyyy-MM-dd}.");
                    }
                    else if (role.StartsWith("basin", StringComparison.OrdinalIgnoreCase) ||
                             role.StartsWith("patch", StringComparison.OrdinalIgnoreCase) ||
                             role.StartsWith("stratum", StringComparison.OrdinalIgnoreCase))
                    {
                        // Monthly files: check year/month range
                        if (result.FirstDate.Value.Year != 1987 || result.FirstDate.Value.Month != 7)
                            report.Warnings.Add($"{role}: first month {result.FirstDate.Value:yyyy-MM} != expected 1987-07.");
                        if (result.LastDate.Value.Year != 2019 || result.LastDate.Value.Month != 6)
                            report.Warnings.Add($"{role}: last month {result.LastDate.Value:yyyy-MM} != expected 2019-06.");
                    }
                }

                // Cube-specific checks
                if (role.StartsWith("cubePatch", StringComparison.OrdinalIgnoreCase) ||
                    role.StartsWith("cubeStratum", StringComparison.OrdinalIgnoreCase))
                {
                    if (result.RowsPerDay.HasValue && result.RowsPerDay.Value != ExpectedRowsPerCubeDay)
                        report.Warnings.Add($"{role}: rows per day {result.RowsPerDay.Value} != expected {ExpectedRowsPerCubeDay}.");

                    var missingZoneIds = ExpectedZoneIDs.Except(result.ZoneIDs).ToList();
                    if (missingZoneIds.Count > 0)
                        report.Warnings.Add($"{role}: missing expected zoneIDs: {string.Join(", ", missingZoneIds)}.");
                }

                // Patch burn count check
                if (role.Equals("patchMonthlyBurn", StringComparison.OrdinalIgnoreCase))
                {
                    if (result.UniquePatchCount != ExpectedPatchCount)
                        report.Warnings.Add($"{role}: unique patch count {result.UniquePatchCount:N0} != expected {ExpectedPatchCount:N0}.");
                }

                // Stratum carbon count check
                if (role.Equals("stratumMonthlyCarbon", StringComparison.OrdinalIgnoreCase))
                {
                    if (result.UniqueStratumCount != ExpectedStratumCount)
                        report.Warnings.Add($"{role}: unique stratum count {result.UniqueStratumCount:N0} != expected {ExpectedStratumCount:N0}.");
                }
            }

            return report;
        }

        private static FileValidationResult ValidateFile(string role, string path)
        {
            var result = new FileValidationResult
            {
                Role = role,
                FilePath = path,
                Exists = File.Exists(path),
                ExpectedRowCount = GetExpectedRowCount(role)
            };

            if (!result.Exists)
                return result;

            // Stream the file: read header, count rows, sample dates/IDs.
            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                result.Headers = Array.Empty<string>();
                return result;
            }

            result.Headers = headerLine.Split(',');
            var colMap = BuildColumnIndexMap(result.Headers);

            // Pre-resolve common column indices so they are in scope for the
            // entire while body (avoids CS0103 from out-var scoping rules).
            colMap.TryGetValue("year", out var yIdx);
            colMap.TryGetValue("month", out var mIdx);
            colMap.TryGetValue("day", out var dIdx);
            colMap.TryGetValue("zoneid", out var zIdx);
            colMap.TryGetValue("zone_id", out var zIdxAlt);
            colMap.TryGetValue("patchid", out var pIdx);
            colMap.TryGetValue("patch_id", out var pIdxAlt);
            colMap.TryGetValue("stratumid", out var sIdx);
            colMap.TryGetValue("stratum_id", out var sIdxAlt);

            // For large files we only fully count rows; for small files we
            // also sample the first/last dates and IDs.
            string line;
            long rowIndex = 0;
            DateTime? firstDate = null;
            DateTime? lastDate = null;
            var zoneIds = new HashSet<int>();
            var patchIds = new HashSet<long>();
            var stratumIds = new HashSet<long>();

            // Sampling state for per-day row detection
            DateTime? prevDate = null;
            int dayRowCount = 0;
            var dayRowCounts = new List<int>();

            // For monthly files, sample only the first month to count unique IDs
            bool firstMonthOnly = role.Equals("patchMonthlyBurn", StringComparison.OrdinalIgnoreCase) ||
                                  role.Equals("stratumMonthlyCarbon", StringComparison.OrdinalIgnoreCase);
            bool pastFirstMonth = false;

            while ((line = reader.ReadLine()) != null)
            {
                rowIndex++;
                var parts = line.Split(',');

                // Extract date from row
                if (yIdx >= 0 && mIdx >= 0)
                {
                    if (int.TryParse(GetSafe(parts, yIdx), out var year) &&
                        int.TryParse(GetSafe(parts, mIdx), out var month))
                    {
                        int day = 1;
                        if (dIdx >= 0)
                            int.TryParse(GetSafe(parts, dIdx), out day);

                        try
                        {
                            var dt = new DateTime(year, month, day);
                            if (!firstDate.HasValue)
                                firstDate = dt;
                            lastDate = dt;

                            if (firstMonthOnly)
                            {
                                if (!firstDate.HasValue || (year == firstDate.Value.Year && month == firstDate.Value.Month))
                                {
                                    // Still in first month
                                }
                                else
                                {
                                    pastFirstMonth = true;
                                }
                            }
                        }
                        catch { /* ignore invalid dates */ }
                    }
                }

                // zoneID sampling (cube files)
                int zoneCol = zIdx >= 0 ? zIdx : zIdxAlt;
                if (zoneCol >= 0)
                {
                    if (int.TryParse(GetSafe(parts, zoneCol), out var zid))
                        zoneIds.Add(zid);
                }

                // Per-day row counting for cube files
                if (yIdx >= 0 && mIdx >= 0 && dIdx >= 0)
                {
                    if (int.TryParse(GetSafe(parts, yIdx), out var year) &&
                        int.TryParse(GetSafe(parts, mIdx), out var month) &&
                        int.TryParse(GetSafe(parts, dIdx), out var day))
                    {
                        try
                        {
                            var dt = new DateTime(year, month, day);
                            if (prevDate.HasValue && dt != prevDate.Value)
                            {
                                dayRowCounts.Add(dayRowCount);
                                dayRowCount = 0;
                            }
                            prevDate = dt;
                            dayRowCount++;
                        }
                        catch { }
                    }
                }

                // patchID sampling
                if (!pastFirstMonth)
                {
                    int patchCol = pIdx >= 0 ? pIdx : pIdxAlt;
                    if (patchCol >= 0 && long.TryParse(GetSafe(parts, patchCol), out var pid))
                        patchIds.Add(pid);
                }

                // stratumID sampling
                if (!pastFirstMonth)
                {
                    int stratumCol = sIdx >= 0 ? sIdx : sIdxAlt;
                    if (stratumCol >= 0 && long.TryParse(GetSafe(parts, stratumCol), out var sid))
                        stratumIds.Add(sid);
                }
            }

            result.RowCount = rowIndex;
            result.FirstDate = firstDate;
            result.LastDate = lastDate;
            result.ZoneIDs = zoneIds.ToList();
            result.UniquePatchCount = patchIds.Count;
            result.UniqueStratumCount = stratumIds.Count;

            if (dayRowCounts.Count > 0)
            {
                // Use the mode (most common) as the rows-per-day figure
                result.RowsPerDay = dayRowCounts
                    .GroupBy(c => c)
                    .OrderByDescending(g => g.Count())
                    .Select(g => g.Key)
                    .FirstOrDefault();
            }
            else if (dayRowCount > 0)
            {
                result.RowsPerDay = dayRowCount;
            }

            return result;
        }

        private static long GetExpectedRowCount(string role)
        {
            return role.ToLowerInvariant() switch
            {
                "cubeaggregatedaily" => 11688,
                "cubepatchdaily01" => 58440,
                "cubepatchdaily02" => 58440,
                "cubestratumover01" => 58440,
                "cubestratumover02" => 58440,
                "cubestratumunder01" => 58440,
                "cubestratumunder02" => 58440,
                "basinmonthlyburn" => 384,
                "patchmonthlyburn" => 3438336,
                "stratummonthlycarbon" => 6876672,
                _ => 0
            };
        }

        private static Dictionary<string, int> BuildColumnIndexMap(string[] headers)
        {
            var map = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < headers.Length; i++)
                map[headers[i].Trim().ToLowerInvariant()] = i;
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
