using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 static patch-family spatial extents (table <c>PatchData</c>).
    ///
    /// Decoded from the patch-family raster (Pch30rip90upRN.tiff) into the existing
    /// PatchPointCollection contract (data-grid location, fire-grid location,
    /// alphamap location, UTM, pixel members), serialized in <c>data</c>. Spatial
    /// extents are climate-independent, so there is no warmingIdx. The raster
    /// decoder is a later task; this fixes the table shape.
    /// </summary>
    [Table("PatchData")]
    [Index(nameof(scenarioRunId), nameof(zoneID))]
    public class PatchDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }

        // Patch-family identity (raster value)
        public int zoneID { get; set; }

        // Serialized PatchPointCollection (JSON)
        [Column(TypeName = "longtext")]
        public string data { get; set; }
    }
}
