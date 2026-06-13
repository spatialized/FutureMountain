using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 raster provenance (table <c>RasterMetadata</c>).
    ///
    /// Records the spatial reference / decode parameters of the two .tiff inputs
    /// (patch-family map and DEM) so raster-derived data (PatchData, future
    /// TerrainData) is reproducible. Optional in phase 1; populated when the raster
    /// decoder is implemented.
    /// </summary>
    [Table("RasterMetadata")]
    public class RasterMetadata
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }

        // "patchFamily" or "dem"
        public string role { get; set; }
        public string fileName { get; set; }

        public int gridColumns { get; set; }
        public int gridRows { get; set; }
        public float pixelScaleMeters { get; set; }
        public long nodataValue { get; set; }
        public float minValue { get; set; }
        public float maxValue { get; set; }
        public int validIdCount { get; set; }

        public string sourceMetadata { get; set; }
    }
}
