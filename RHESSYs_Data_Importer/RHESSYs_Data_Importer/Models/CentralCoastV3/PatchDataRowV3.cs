using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoastV3
{
    /// <summary>
    /// Central Coast v3 static patch-family spatial extents (table <c>PatchData</c>).
    ///
    /// One row per unique <c>zoneID</c> decoded from patch-family rasters by
    /// <c>CentralCoastImporter.ImportPatchMapData</c>. The <c>data</c> column
    /// contains a JSON blob with the following shape (see
    /// Docs/CentralCoastV3/InitialPatchMapping.md):
    /// <code>
    /// {
    ///   "zoneID": 3497,
    ///   "gridWidth": 396,
    ///   "gridHeight": 301,
    ///   "pixelCount": 12,
    ///   "centroidCol": 198.3,
    ///   "centroidRow": 142.7,
    ///   "boundingBox": { "colMin": 195, "colMax": 202, "rowMin": 139, "rowMax": 147 },
    ///   "pixels": [[195,139],[196,140], ...]
    /// }
    /// </code>
    /// Pixel coordinates are zero-based (col, row) with origin at upper-left of
    /// the TIFF. Spatial extents are climate-independent; there is no warmingIdx.
    /// </summary>
    [Table("PatchData")]
    [Index(nameof(scenarioRunId), nameof(zoneID))]
    public class PatchDataRowV3
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
