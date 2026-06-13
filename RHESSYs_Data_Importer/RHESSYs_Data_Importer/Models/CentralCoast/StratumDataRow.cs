using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 monthly whole-landscape stratum carbon row
    /// (table <c>StratumData</c>).
    ///
    /// Source: spatial_data_point_stratvar.csv (~6.9M rows per member). Kept
    /// separate from CubeData because it spans every stratum in the watershed
    /// (~17,908), not just the five detailed cubes.
    /// </summary>
    [Table("StratumData")]
    public class StratumDataRow
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

        // Spatial identity
        public int basinID { get; set; }
        public int hillID { get; set; }
        public int zoneID { get; set; }
        public long patchID { get; set; }
        public long stratumID { get; set; }

        public float totalc { get; set; }
        public float total_plantc { get; set; }
    }
}
