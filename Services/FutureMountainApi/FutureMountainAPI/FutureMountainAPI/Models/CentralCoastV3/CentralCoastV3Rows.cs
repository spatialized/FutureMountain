using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.Models.CentralCoast
{
    [Table("CubeData")]
    [Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(dateIdx), nameof(zoneID), nameof(patchID))]
    public class CentralCoastCubeDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }
        public int dateIdx { get; set; }
        public int basinID { get; set; }
        public int hillID { get; set; }
        public int zoneID { get; set; }
        public long patchID { get; set; }
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

    [Table("WaterData")]
    [Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(dateIdx))]
    public class CentralCoastWaterDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }
        public int dateIdx { get; set; }
        public int basinID { get; set; }
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
        public float burn { get; set; }
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
        public float fe_canopy_target_prop_c_consumed { get; set; }
        public float fe_canopy_target_prop_c_remain_adjusted { get; set; }
        public float fe_canopy_target_prop_c_remain_adjusted_leafc { get; set; }
    }

    [Table("PatchData")]
    [Index(nameof(scenarioRunId), nameof(zoneID))]
    public class CentralCoastPatchDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int importRunId { get; set; }
        public string scenarioRunId { get; set; }
        public int zoneID { get; set; }

        [Column("data", TypeName = "longtext")]
        public string data { get; set; }
    }

    [Table("TerrainData")]
    [Index(nameof(scenarioRunId), nameof(warmingIdx), nameof(year), nameof(month))]
    public class CentralCoastTerrainDataRow
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int gridSize { get; set; }
        public int gridWidth { get; set; }
        public int gridHeight { get; set; }
        public int pixelGrainSize { get; set; }
        public int decimalPrecision { get; set; }

        [Column(TypeName = "longtext")]
        public string _dataList { get; set; }
    }
}
