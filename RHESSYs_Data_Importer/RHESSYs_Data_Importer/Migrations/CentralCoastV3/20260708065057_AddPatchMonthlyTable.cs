using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RHESSYs_Data_Importer.Migrations.CentralCoastV3
{
    /// <inheritdoc />
    public partial class AddPatchMonthlyTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PatchMonthly",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    importRunId = table.Column<int>(type: "int", nullable: false),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    scenarioIdx = table.Column<int>(type: "int", nullable: false),
                    year = table.Column<int>(type: "int", nullable: false),
                    month = table.Column<int>(type: "int", nullable: false),
                    wy = table.Column<int>(type: "int", nullable: false),
                    zoneID = table.Column<int>(type: "int", nullable: false),
                    patchID = table.Column<long>(type: "bigint", nullable: false),
                    totalCover = table.Column<float>(type: "float", nullable: false),
                    totalCunder = table.Column<float>(type: "float", nullable: false),
                    plantCover = table.Column<float>(type: "float", nullable: false),
                    plantCunder = table.Column<float>(type: "float", nullable: false),
                    burned = table.Column<float>(type: "float", nullable: false),
                    fire = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PatchMonthly", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_PatchMonthly_scenarioRunId_scenarioIdx_year_month_zoneID",
                table: "PatchMonthly",
                columns: new[] { "scenarioRunId", "scenarioIdx", "year", "month", "zoneID" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PatchMonthly");
        }
    }
}
