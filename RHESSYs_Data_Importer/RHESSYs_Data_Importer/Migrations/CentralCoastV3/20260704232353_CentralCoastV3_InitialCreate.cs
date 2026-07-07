using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RHESSYs_Data_Importer.Migrations.CentralCoastV3
{
    /// <inheritdoc />
    public partial class CentralCoastV3_InitialCreate : Migration
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
                    scenarioIdx = table.Column<int>(type: "int", nullable: false),
                    dateIdx = table.Column<int>(type: "int", nullable: false),
                    basinID = table.Column<int>(type: "int", nullable: false),
                    zoneID = table.Column<int>(type: "int", nullable: false),
                    patchID = table.Column<long>(type: "bigint", nullable: false),
                    coverfract = table.Column<float>(type: "float", nullable: false),
                    litterc = table.Column<float>(type: "float", nullable: false),
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
                    netpsnOver = table.Column<float>(type: "float", nullable: false),
                    gppOver = table.Column<float>(type: "float", nullable: false),
                    respOver = table.Column<float>(type: "float", nullable: false),
                    heightOver = table.Column<float>(type: "float", nullable: false),
                    transOver = table.Column<float>(type: "float", nullable: false),
                    leafCOver = table.Column<float>(type: "float", nullable: false),
                    stemCOver = table.Column<float>(type: "float", nullable: false),
                    rootCOver = table.Column<float>(type: "float", nullable: false),
                    rootdepthCOver = table.Column<float>(type: "float", nullable: false),
                    laiOver = table.Column<float>(type: "float", nullable: false),
                    netpsnUnder = table.Column<float>(type: "float", nullable: false),
                    gppUnder = table.Column<float>(type: "float", nullable: false),
                    respUnder = table.Column<float>(type: "float", nullable: false),
                    heightUnder = table.Column<float>(type: "float", nullable: false),
                    transUnder = table.Column<float>(type: "float", nullable: false),
                    leafCUnder = table.Column<float>(type: "float", nullable: false),
                    rootCUnder = table.Column<float>(type: "float", nullable: false),
                    rootdepthUnder = table.Column<float>(type: "float", nullable: false),
                    laiUnder = table.Column<float>(type: "float", nullable: false),
                    tmax = table.Column<float>(type: "float", nullable: false),
                    tmin = table.Column<float>(type: "float", nullable: false),
                    relHumidity = table.Column<float>(type: "float", nullable: false),
                    windSpeed = table.Column<float>(type: "float", nullable: false),
                    windDirection = table.Column<float>(type: "float", nullable: false),
                    burn = table.Column<float>(type: "float", nullable: false),
                    fire = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CubeData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_CubeData_scenarioRunId_scenarioIdx_dateIdx_zoneID_patchID",
                table: "CubeData",
                columns: new[] { "scenarioRunId", "scenarioIdx", "dateIdx", "zoneID", "patchID" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CubeData");
        }
    }
}
