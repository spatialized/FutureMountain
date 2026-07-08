 using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoastV3
{
    /// <summary>
    /// Central Coast v3 whole-watershed monthly per-patch data (table PatchMonthly).
    /// Source: allPatches_p1m.csv / allPatches_p2m.csv. Feeds terrain generation:
    /// vegetation intensity from plantCover+plantCunder, burn signal from burned.
    /// One row per (year, month, zoneID, patchID) per source file.
    /// </summary>
    [Table("PatchMonthly")]
    [Index(nameof(scenarioRunId), nameof(scenarioIdx), nameof(year), nameof(month), nameof(zoneID))]
    public class PatchMonthlyRowV3
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int scenarioIdx { get; set; }

        public int year { get; set; }
        public int month { get; set; }
        public int wy { get; set; }          // water year
        public int zoneID { get; set; }
        public long patchID { get; set; }

        public float totalCover { get; set; }
        public float totalCunder { get; set; }
        public float plantCover { get; set; }
        public float plantCunder { get; set; }

        public float burned { get; set; }
        public float fire { get; set; }
    }
}