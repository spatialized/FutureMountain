using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 daily per-cube row (table <c>CubeData</c>).
    ///
    /// Built by joining the daily cube patch file with the overstory and
    /// understory stratum files on (year, month, day, zoneID, patchID). Patch
    /// members 01 and 02 remain SEPARATE rows (keyed by patchID); only the
    /// overstory/understory strata are merged into columns.
    ///
    /// Sources: cube_p_patch{1,2}.csv, cubes_sc_over_patch{1,2}.csv,
    /// cube_sc_under_patch{1,2}.csv.
    /// </summary>
    [Table("CubeData")]
    public class CubeDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }

        // Date and spatial identity
        public int dateIdx { get; set; }
        public int basinID { get; set; }
        public int hillID { get; set; }
        public int zoneID { get; set; }
        public long patchID { get; set; }

        // Patch hydrology (cube_p_patch*)
        public float coverfract { get; set; }
        public float litterc { get; set; }
        public float burn { get; set; }
        public float soilc { get; set; }
        public float depthToGW { get; set; }
        public float canopyevap { get; set; }
        public float streamflow { get; set; }
        public float rootdepth { get; set; }
        public float groundevap { get; set; }
        public float vegAccessWater { get; set; }
        public float Qin { get; set; }
        public float Qout { get; set; }
        public float rain { get; set; }

        // Overstory stratum (cubes_sc_over_patch*)
        public long stratumIDOver { get; set; }
        public int vegParmIDOver { get; set; }
        public float consumedCOver { get; set; }
        public float mortCOver { get; set; }
        public float netpsnOver { get; set; }
        public float heightOver { get; set; }
        public float transOver { get; set; }
        public float leafCOver { get; set; }
        public float stemCOver { get; set; }
        public float rootCOver { get; set; }
        public float rootdepthCOver { get; set; }
        public float laiOver { get; set; }

        // Understory stratum (cube_sc_under_patch*)
        public long stratumIDUnder { get; set; }
        public int vegParmIDUnder { get; set; }
        public float consumedCUnder { get; set; }
        public float mortCUnder { get; set; }
        public float transUnder { get; set; }
        public float netpsnUnder { get; set; }
        public float heightUnder { get; set; }
        public float leafCUnder { get; set; }
        public float stemCUnder { get; set; }
        public float rootCUnder { get; set; }
        public float rootdepthUnder { get; set; }
        public float laiUnder { get; set; }
    }
}
