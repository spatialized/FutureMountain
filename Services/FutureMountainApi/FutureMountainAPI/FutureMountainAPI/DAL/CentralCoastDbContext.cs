using FutureMountainAPI.Models.CentralCoast;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.DAL
{
    public class CentralCoastDbContext : DbContext
    {
        public CentralCoastDbContext()
        {
        }

        public CentralCoastDbContext(DbContextOptions<CentralCoastDbContext> options) : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (optionsBuilder.IsConfigured)
            {
                return;
            }

            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json")
                .Build();

            string connectionString = configuration.GetConnectionString("CentralCoastDbContext");
            optionsBuilder.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<Date> Dates { get; set; }
        public DbSet<CentralCoastCubeDataRow> CubeData { get; set; }
        public DbSet<CentralCoastWaterDataRow> WaterData { get; set; }
        public DbSet<CentralCoastPatchDataRow> PatchData { get; set; }
        public DbSet<CentralCoastTerrainDataRow> TerrainData { get; set; }
    }
}
