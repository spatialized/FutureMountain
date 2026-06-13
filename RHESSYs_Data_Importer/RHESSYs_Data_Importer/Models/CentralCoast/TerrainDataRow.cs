using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 terrain frame (table <c>TerrainData</c>).
    ///
    /// DEFERRED: defined for parity with Big Creek so the schema is complete and
    /// future terrain/landscape work has a home. Not populated in phase 1. Source
    /// would be dem30mSBFRbound.tiff plus derived splatmaps.
    /// </summary>
    [Table("TerrainData")]
    public class TerrainDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }

        public int year { get; set; }
        public int month { get; set; }

        public int gridSize { get; set; }
        public float pixelGrainSize { get; set; }
        public int decimalPrecision { get; set; }

        [Column(TypeName = "longtext")]
        public string data { get; set; }
    }
}
