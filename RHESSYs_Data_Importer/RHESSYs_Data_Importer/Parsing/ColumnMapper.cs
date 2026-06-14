using System;
using System.Collections.Generic;
using System.Linq;

namespace RHESSYs_Data_Importer.Parsing
{
    public class ColumnMapper
    {
        private readonly Dictionary<string, int> _columnIndices;

        public ColumnMapper(string headerLine, Dictionary<string, string> columnMap)
        {
            var headers = headerLine
                .Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            _columnIndices = new();

            foreach (var kvp in columnMap)
            {
                var sourceName = kvp.Key.ToLowerInvariant();
                var targetName = kvp.Value;
                var index = Array.FindIndex(headers, h => h.Equals(sourceName, StringComparison.OrdinalIgnoreCase));
                if (index >= 0)
                    _columnIndices[targetName] = index;
            }
        }

        public string? GetValue(string[] values, string field)
        {
            if (_columnIndices.TryGetValue(field, out var idx) && idx >= 0 && idx < values.Length)
                return values[idx];
            return null;
        }

        public float GetFloat(string[] values, string field)
            => float.TryParse(GetValue(values, field), out var f) ? f : 0f;

        public int MatchedCount => _columnIndices.Count;
        public IEnumerable<string> MappedFields => _columnIndices.Keys;
    }
}
