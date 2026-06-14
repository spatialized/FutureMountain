using System;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RHESSYs_Data_Importer.Migrations.CentralCoast
{
    /// <inheritdoc />
    public partial class CentralCoast_InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterDatabase()
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "CubeData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    dateIdx = table.Column<int>(type: "int", nullable: false),
                    basinID = table.Column<int>(type: "int", nullable: false),
                    hillID = table.Column<int>(type: "int", nullable: false),
                    zoneID = table.Column<int>(type: "int", nullable: false),
                    patchID = table.Column<long>(type: "bigint", nullable: false),
                    coverfract = table.Column<float>(type: "float", nullable: false),
                    litterc = table.Column<float>(type: "float", nullable: false),
                    burn = table.Column<float>(type: "float", nullable: false),
                    soilc = table.Column<float>(type: "float", nullable: false),
                    depthToGW = table.Column<float>(type: "float", nullable: false),
                    canopyevap = table.Column<float>(type: "float", nullable: false),
                    streamflow = table.Column<float>(type: "float", nullable: false),
                    rootdepth = table.Column<float>(type: "float", nullable: false),
                    groundevap = table.Column<float>(type: "float", nullable: false),
                    vegAccessWater = table.Column<float>(type: "float", nullable: false),
                    Qin = table.Column<float>(type: "float", nullable: false),
                    Qout = table.Column<float>(type: "float", nullable: false),
                    rain = table.Column<float>(type: "float", nullable: false),
                    stratumIDOver = table.Column<long>(type: "bigint", nullable: false),
                    vegParmIDOver = table.Column<int>(type: "int", nullable: false),
                    consumedCOver = table.Column<float>(type: "float", nullable: false),
                    mortCOver = table.Column<float>(type: "float", nullable: false),
                    netpsnOver = table.Column<float>(type: "float", nullable: false),
                    heightOver = table.Column<float>(type: "float", nullable: false),
                    transOver = table.Column<float>(type: "float", nullable: false),
                    leafCOver = table.Column<float>(type: "float", nullable: false),
                    stemCOver = table.Column<float>(type: "float", nullable: false),
                    rootCOver = table.Column<float>(type: "float", nullable: false),
                    rootdepthCOver = table.Column<float>(type: "float", nullable: false),
                    laiOver = table.Column<float>(type: "float", nullable: false),
                    stratumIDUnder = table.Column<long>(type: "bigint", nullable: false),
                    vegParmIDUnder = table.Column<int>(type: "int", nullable: false),
                    consumedCUnder = table.Column<float>(type: "float", nullable: false),
                    mortCUnder = table.Column<float>(type: "float", nullable: false),
                    transUnder = table.Column<float>(type: "float", nullable: false),
                    netpsnUnder = table.Column<float>(type: "float", nullable: false),
                    heightUnder = table.Column<float>(type: "float", nullable: false),
                    leafCUnder = table.Column<float>(type: "float", nullable: false),
                    stemCUnder = table.Column<float>(type: "float", nullable: false),
                    rootCUnder = table.Column<float>(type: "float", nullable: false),
                    rootdepthUnder = table.Column<float>(type: "float", nullable: false),
                    laiUnder = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CubeData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "Dates",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    date = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    year = table.Column<int>(type: "int", nullable: false),
                    month = table.Column<int>(type: "int", nullable: false),
                    day = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Dates", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "FireData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    sourceFile = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    year = table.Column<int>(type: "int", nullable: false),
                    month = table.Column<int>(type: "int", nullable: false),
                    level = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    basinID = table.Column<int>(type: "int", nullable: false),
                    hillID = table.Column<int>(type: "int", nullable: true),
                    zoneID = table.Column<int>(type: "int", nullable: true),
                    patchID = table.Column<long>(type: "bigint", nullable: true),
                    burn = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FireData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "ImportRun",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    scenarioName = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    scenarioProfile = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    scenarioRunId = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    databaseName = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    sourceRoot = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    startedUtc = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    finishedUtc = table.Column<DateTime>(type: "datetime(6)", nullable: true),
                    status = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    filesImported = table.Column<int>(type: "int", nullable: false),
                    rowsImported = table.Column<long>(type: "bigint", nullable: false),
                    notes = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ImportRun", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "PatchData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    zoneID = table.Column<int>(type: "int", nullable: false),
                    data = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PatchData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "StratumData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    sourceFile = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    year = table.Column<int>(type: "int", nullable: false),
                    month = table.Column<int>(type: "int", nullable: false),
                    basinID = table.Column<int>(type: "int", nullable: false),
                    hillID = table.Column<int>(type: "int", nullable: false),
                    zoneID = table.Column<int>(type: "int", nullable: false),
                    patchID = table.Column<long>(type: "bigint", nullable: false),
                    stratumID = table.Column<long>(type: "bigint", nullable: false),
                    totalc = table.Column<float>(type: "float", nullable: false),
                    total_plantc = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StratumData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "TerrainData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    year = table.Column<int>(type: "int", nullable: false),
                    month = table.Column<int>(type: "int", nullable: false),
                    gridSize = table.Column<int>(type: "int", nullable: false),
                    gridWidth = table.Column<int>(type: "int", nullable: false),
                    gridHeight = table.Column<int>(type: "int", nullable: false),
                    pixelGrainSize = table.Column<int>(type: "int", nullable: false),
                    decimalPrecision = table.Column<int>(type: "int", nullable: false),
                    _dataList = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TerrainData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "WaterData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    dateIdx = table.Column<int>(type: "int", nullable: false),
                    basinID = table.Column<int>(type: "int", nullable: false),
                    streamflow = table.Column<float>(type: "float", nullable: false),
                    rain = table.Column<float>(type: "float", nullable: false),
                    evaporation = table.Column<float>(type: "float", nullable: false),
                    evaporation_surf = table.Column<float>(type: "float", nullable: false),
                    exfiltration_unsat_zone = table.Column<float>(type: "float", nullable: false),
                    exfiltration_sat_zone = table.Column<float>(type: "float", nullable: false),
                    transpiration_sat_zone = table.Column<float>(type: "float", nullable: false),
                    transpiration_unsat_zone = table.Column<float>(type: "float", nullable: false),
                    sat_deficit_z = table.Column<float>(type: "float", nullable: false),
                    rz_storage = table.Column<float>(type: "float", nullable: false),
                    rootzone_depth = table.Column<float>(type: "float", nullable: false),
                    family_pct_cover = table.Column<float>(type: "float", nullable: false),
                    burn = table.Column<float>(type: "float", nullable: false),
                    litter_cs_totalc = table.Column<float>(type: "float", nullable: false),
                    soil_cs_totalc = table.Column<float>(type: "float", nullable: false),
                    cs_net_psn = table.Column<float>(type: "float", nullable: false),
                    epv_height = table.Column<float>(type: "float", nullable: false),
                    cs_leafc = table.Column<float>(type: "float", nullable: false),
                    cs_leafc_store = table.Column<float>(type: "float", nullable: false),
                    cs_live_stemc = table.Column<float>(type: "float", nullable: false),
                    cs_dead_stemc = table.Column<float>(type: "float", nullable: false),
                    cs_frootc = table.Column<float>(type: "float", nullable: false),
                    cs_live_crootc = table.Column<float>(type: "float", nullable: false),
                    cs_dead_crootc = table.Column<float>(type: "float", nullable: false),
                    fe_canopy_target_prop_c_consumed = table.Column<float>(type: "float", nullable: false),
                    fe_canopy_target_prop_c_remain_adjusted = table.Column<float>(type: "float", nullable: false),
                    fe_canopy_target_prop_c_remain_adjusted_leafc = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WaterData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_CubeData_scenarioRunId_warmingIdx_dateIdx_zoneID_patchID",
                table: "CubeData",
                columns: new[] { "scenarioRunId", "warmingIdx", "dateIdx", "zoneID", "patchID" });

            migrationBuilder.CreateIndex(
                name: "IX_FireData_scenarioRunId_warmingIdx_year_month_zoneID_patchID",
                table: "FireData",
                columns: new[] { "scenarioRunId", "warmingIdx", "year", "month", "zoneID", "patchID" });

            migrationBuilder.CreateIndex(
                name: "IX_PatchData_scenarioRunId_zoneID",
                table: "PatchData",
                columns: new[] { "scenarioRunId", "zoneID" });

            migrationBuilder.CreateIndex(
                name: "IX_StratumData_scenarioRunId_warmingIdx_year_month_stratumID",
                table: "StratumData",
                columns: new[] { "scenarioRunId", "warmingIdx", "year", "month", "stratumID" });

            migrationBuilder.CreateIndex(
                name: "IX_TerrainData_scenarioRunId_warmingIdx_year_month",
                table: "TerrainData",
                columns: new[] { "scenarioRunId", "warmingIdx", "year", "month" });

            migrationBuilder.CreateIndex(
                name: "IX_WaterData_scenarioRunId_warmingIdx_dateIdx",
                table: "WaterData",
                columns: new[] { "scenarioRunId", "warmingIdx", "dateIdx" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CubeData");

            migrationBuilder.DropTable(
                name: "Dates");

            migrationBuilder.DropTable(
                name: "FireData");

            migrationBuilder.DropTable(
                name: "ImportRun");

            migrationBuilder.DropTable(
                name: "PatchData");

            migrationBuilder.DropTable(
                name: "StratumData");

            migrationBuilder.DropTable(
                name: "TerrainData");

            migrationBuilder.DropTable(
                name: "WaterData");
        }
    }
}
