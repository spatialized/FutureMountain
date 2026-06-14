using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 precomputed terrain frame (table <c>TerrainData</c>).
    ///
    /// One row per (scenarioRunId, warmingIdx, year, month). The <c>_dataList</c>
    /// field is a flat JSON float array in row-major order (index = row * gridWidth
    /// + col). Each element encodes vegetation intensity and burn signal as:
    ///   value = vegIntensity + burnSignal * 100
    /// where vegIntensity is in [0,1] and burnSignal is 0 or 1.
    ///
    /// Central Coast frames use gridWidth/gridHeight (not gridSize) because the
    /// patch map raster is 396 x 301 (rectangular). gridSize is set to 0.
    /// Big Creek TerrainData rows are in a separate table/context and are untouched.
    /// </summary>
    [Table("TerrainData")]
    [Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(year), nameof(month))]
    public class TerrainDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }

        // gridSize = 0 for Central Coast (non-square); use gridWidth/gridHeight.
        public int gridSize { get; set; }
        public int gridWidth { get; set; }
        public int gridHeight { get; set; }

        // ~30 m per pixel for Pch30rip90upRN.tiff
        public int pixelGrainSize { get; set; }

        // Decimal precision stored in _dataList values
        public int decimalPrecision { get; set; }

        [Column(TypeName = "longtext")]
        public string _dataList { get; set; }
    }
}
