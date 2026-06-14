using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RHESSYs_Data_Importer.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
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
                    dateIdx = table.Column<int>(type: "int", nullable: false),
                    warmingIdx = table.Column<int>(type: "int", nullable: false),
                    patchIdx = table.Column<int>(type: "int", nullable: false),
                    snow = table.Column<float>(type: "float", nullable: false),
                    evap = table.Column<float>(type: "float", nullable: false),
                    netpsn = table.Column<float>(type: "float", nullable: false),
                    depthToGW = table.Column<float>(type: "float", nullable: false),
                    vegAccessWater = table.Column<float>(type: "float", nullable: false),
                    Qout = table.Column<float>(type: "float", nullable: false),
                    litter = table.Column<float>(type: "float", nullable: false),
                    soil = table.Column<float>(type: "float", nullable: false),
                    heightOver = table.Column<float>(type: "float", nullable: false),
                    transOver = table.Column<float>(type: "float", nullable: false),
                    heightUnder = table.Column<float>(type: "float", nullable: false),
                    transUnder = table.Column<float>(type: "float", nullable: false),
                    leafCOver = table.Column<float>(type: "float", nullable: false),
                    stemCOver = table.Column<float>(type: "float", nullable: false),
                    rootCOver = table.Column<float>(type: "float", nullable: false),
                    leafCUnder = table.Column<float>(type: "float", nullable: false),
                    stemCUnder = table.Column<float>(type: "float", nullable: false),
                    rootCUnder = table.Column<float>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CubeData", x => x.id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CubeData");
        }
    }
}
