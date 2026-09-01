using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoastV3
{
    /// <summary>
    /// Central Coast v3 daily per-cube row (table <c>CubeData</c>).
    /// This file contains the main entry point for the CentralCoastV3 scenario.
    /// Built by joining the daily cube patch file with the overstory and
    /// understory stratum files on (year, month, day, zoneID, patchID). Patch
    /// members 01 and 02 remain SEPARATE rows (keyed by patchID); only the
    /// overstory/understory strata are merged into columns.
    ///
    /// Sources: cube_p_patch{1,2}.csv, cubes_sc_over_patch{1,2}.csv,
    /// cube_sc_under_patch{1,2}.csv.
    /// </summary>
    [Table("CubeData")]
    [Index(nameof(scenarioRunId), nameof(scenarioIdx), nameof(dateIdx), nameof(zoneID), nameof(patchID))]
    public class CubeDataRowV3
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        // Provenance / scenario member
        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        //public int warmingIdx { get; set; }
        public int scenarioIdx { get; set; }

        // Date and spatial identity
        public int dateIdx { get; set; }
        public int basinID { get; set; }
        //public int hillID { get; set; }
        public int zoneID { get; set; }
        public long patchID { get; set; }

        // Patch hydrology (cube_p_patch*)
        public float coverfract { get; set; }
        public float litterc { get; set; }
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
        //public long stratumIDOver { get; set; }
        //public int vegParmIDOver { get; set; }
        //public float consumedCOver { get; set; }
        //public float mortCOver { get; set; }
        public float netpsnOver { get; set; }
        public float gppOver { get; set; }
        public float respOver { get; set; }
        public float heightOver { get; set; }
        public float transOver { get; set; }
        public float leafCOver { get; set; }
        public float stemCOver { get; set; }
        public float rootCOver { get; set; }
        public float rootdepthCOver { get; set; }
        public float laiOver { get; set; }

        // Understory stratum (cube_sc_under_patch*)
        //public long stratumIDUnder { get; set; }
        //public int vegParmIDUnder { get; set; }
       // public float consumedCUnder { get; set; }
        //public float mortCUnder { get; set; }
        public float netpsnUnder { get; set; }
        public float gppUnder { get; set; }
        public float respUnder { get; set; }
        public float heightUnder { get; set; }
        public float transUnder { get; set; }
        public float leafCUnder { get; set; }
        public float rootCUnder { get; set; }
        public float rootdepthUnder { get; set; }
        public float laiUnder { get; set; }

        // Weather data
        public float tmax { get; set; }
        public float tmin { get; set; }
        public float relHumidity { get; set; }
        public float windSpeed { get; set; }
        public float windDirection { get; set; }

        // Fire data
        public float burn { get; set; }
        public float fire { get; set; }

        // Newer RHESSys columns (present from the 8-3-2026 bundle onward).
        // Older bundles lack these headers, so GetFloat resolves them to 0.
        public float ind_died { get; set; }   // individuals that died this step
        public float fcover { get; set; }      // fractional vegetation cover

        // Aggregate-cube fire & stem-loss columns (present in aggregate_cube_bd.csv only).
        // Patch files lack these headers, so GetFloat resolves them to 0 for patch rows.
        public float cells_burned { get; set; }    // number of 50x50m cells burned
        public float pctWS_burned { get; set; }    // percent of watershed burned (0-100)
        public float dstem { get; set; }           // stem carbon lost this step
        public float fractstemloss { get; set; }   // fraction of stem carbon lost (= dstem/stemC)

    }
}
