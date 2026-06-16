using System;
using System.Collections.Generic;
using System.IO;
using RHESSYs_Data_Importer.Configuration;

namespace RHESSYs_Data_Importer.IO
{
    /// <summary>
    /// Derives the canonical daily calendar for a Central Coast V2 scenario
    /// by reading <c>day</c>, <c>month</c>, <c>year</c> columns from the
    /// configured <c>cubeAggregateDaily</c> CSV file.
    ///
    /// The resulting calendar maps each distinct <see cref="DateTime"/> to a
    /// 1-based <c>dateIdx</c> (sorted ascending). This is the single source of
    /// truth for <c>dateIdx</c> used by all CCV2 importers and the <c>Dates</c>
    /// table population.
    /// </summary>
    public static class CentralCoastCalendar
    {
        /// <summary>
        /// Derives the sorted daily calendar from the cubeAggregateDaily file.
        /// </summary>
        /// <returns>
        /// A list of distinct dates sorted ascending, where
        /// <c>result[0]</c> maps to <c>dateIdx = 1</c>.
        /// </returns>
        /// <exception cref="InvalidOperationException">
        /// Thrown if the file is missing, unreadable, or contains no parseable dates.
        /// </exception>
        public static List<DateTime> DeriveCalendar(ScenarioConfig config)
        {
            var path = config.GetSourceFilePath("cubeAggregateDaily");
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
                throw new InvalidOperationException(
                    $"[Calendar] cubeAggregateDaily file not found: {path}");

            return DeriveCalendarFromFile(path);
        }

        /// <summary>
        /// Builds a <see cref="Dictionary{DateTime,int}"/> mapping each date to
        /// its 1-based <c>dateIdx</c>, derived from the sorted calendar.
        /// </summary>
        public static Dictionary<DateTime, int> BuildDateIndex(ScenarioConfig config)
        {
            var calendar = DeriveCalendar(config);
            var map = new Dictionary<DateTime, int>(calendar.Count);
            for (int i = 0; i < calendar.Count; i++)
                map[calendar[i]] = i + 1; // 1-based
            return map;
        }

        // ------------------------------------------------------------------ //

        private static List<DateTime> DeriveCalendarFromFile(string path)
        {
            var dates = new SortedSet<DateTime>();

            using var reader = new StreamReader(path);
            string headerLine = reader.ReadLine();
            if (string.IsNullOrWhiteSpace(headerLine))
                throw new InvalidOperationException(
                    $"[Calendar] cubeAggregateDaily file has an empty header: {path}");

            var headers = headerLine.Split(',');
            int dayIdx = -1, monthIdx = -1, yearIdx = -1;
            for (int i = 0; i < headers.Length; i++)
            {
                var h = headers[i].Trim().ToLowerInvariant();
                if (h == "day")   dayIdx   = i;
                else if (h == "month") monthIdx = i;
                else if (h == "year")  yearIdx  = i;
            }

            if (dayIdx < 0 || monthIdx < 0 || yearIdx < 0)
                throw new InvalidOperationException(
                    "[Calendar] cubeAggregateDaily is missing day/month/year columns.");

            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (string.IsNullOrWhiteSpace(line)) continue;
                var parts = line.Split(',');
                if (int.TryParse(GetSafe(parts, dayIdx),   out var d) &&
                    int.TryParse(GetSafe(parts, monthIdx), out var m) &&
                    int.TryParse(GetSafe(parts, yearIdx),  out var y))
                {
                    try { dates.Add(new DateTime(y, m, d)); }
                    catch { /* skip unparseable dates */ }
                }
            }

            if (dates.Count == 0)
                throw new InvalidOperationException(
                    "[Calendar] cubeAggregateDaily contained no parseable dates.");

            return new List<DateTime>(dates);
        }

        private static string GetSafe(string[] parts, int index)
        {
            if (parts == null || index < 0 || index >= parts.Length)
                return string.Empty;
            return parts[index]?.Trim() ?? string.Empty;
        }
    }
}
