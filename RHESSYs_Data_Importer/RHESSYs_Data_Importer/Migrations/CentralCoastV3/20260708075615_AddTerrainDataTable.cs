using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RHESSYs_Data_Importer.Migrations.CentralCoastV3
{
    /// <inheritdoc />
    public partial class AddTerrainDataTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TerrainData",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    scenarioRunId = table.Column<string>(type: "varchar(255)", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    scenarioIdx = table.Column<int>(type: "int", nullable: false),
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

            migrationBuilder.CreateIndex(
                name: "IX_TerrainData_scenarioRunId_scenarioIdx_year_month",
                table: "TerrainData",
                columns: new[] { "scenarioRunId", "scenarioIdx", "year", "month" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TerrainData");
        }
    }
}
