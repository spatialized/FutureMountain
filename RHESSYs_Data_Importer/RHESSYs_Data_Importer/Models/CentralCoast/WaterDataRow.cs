using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 daily basin/aggregate row (table <c>WaterData</c>).
    ///
    /// Source: cube_agg_p.csv (whole-watershed daily). Its <c>streamflow</c> is the
    /// basin streamflow that drives the large-landscape river, so the aggregate
    /// file maps to WaterData rather than CubeData. Unlike Big Creek's
    /// per-warming columns, warming is represented per row via <c>warmingIdx</c>.
    ///
    /// Source column dots are mapped to underscores (e.g. cs.net_psn -> cs_net_psn).
    /// </summary>
    [Table("WaterData")]
    public class WaterDataRow
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

        // Hydrology
        public float streamflow { get; set; }
        public float rain { get; set; }
        public float evaporation { get; set; }
        public float evaporation_surf { get; set; }
        public float exfiltration_unsat_zone { get; set; }
        public float exfiltration_sat_zone { get; set; }
        public float transpiration_sat_zone { get; set; }
        public float transpiration_unsat_zone { get; set; }
        public float sat_deficit_z { get; set; }
        public float rz_storage { get; set; }
        public float rootzone_depth { get; set; }
        public float family_pct_cover { get; set; }

        // Burn
        public float burn { get; set; }

        // Carbon
        public float litter_cs_totalc { get; set; }
        public float soil_cs_totalc { get; set; }
        public float cs_net_psn { get; set; }
        public float epv_height { get; set; }
        public float cs_leafc { get; set; }
        public float cs_leafc_store { get; set; }
        public float cs_live_stemc { get; set; }
        public float cs_dead_stemc { get; set; }
        public float cs_frootc { get; set; }
        public float cs_live_crootc { get; set; }
        public float cs_dead_crootc { get; set; }

        // Fire effects
        public float fe_canopy_target_prop_c_consumed { get; set; }
        public float fe_canopy_target_prop_c_remain_adjusted { get; set; }
        public float fe_canopy_target_prop_c_remain_adjusted_leafc { get; set; }
    }
}
