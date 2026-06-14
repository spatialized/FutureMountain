using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 monthly burn row (table <c>FireData</c>).
    ///
    /// Combines monthly basin burn (bm.csv) and monthly all-patch burn
    /// (spatial_data_point_patchvar.csv). The <c>level</c> column discriminates
    /// the two: "basin" rows leave hillID/zoneID/patchID null. Monthly data is
    /// interpolated to daily at runtime using the existing snow/terrain
    /// interpolation; no new runtime mechanism is introduced.
    /// </summary>
    [Table("FireData")]
    [Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(year), nameof(month), nameof(zoneID), nameof(patchID))]
    public class FireDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }
        public string sourceFile { get; set; }

        // Month
        public int year { get; set; }
        public int month { get; set; }

        // "basin" or "patch"
        public string level { get; set; }

        // Spatial identity (null for basin-level rows)
        public int basinID { get; set; }
        public int? hillID { get; set; }
        public int? zoneID { get; set; }
        public long? patchID { get; set; }

        public float burn { get; set; }
    }
}
