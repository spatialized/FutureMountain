using FutureMountainAPI.Models.CentralCoastV3;
using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI.DAL
{
    public class CentralCoastV3DbContext : DbContext
    {
        public CentralCoastV3DbContext()
        {
        }

        public CentralCoastV3DbContext(DbContextOptions<CentralCoastV3DbContext> options) : base(options)
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

            string connectionString = configuration.GetConnectionString("CentralCoastV3DbContext");
            optionsBuilder.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<Date> Dates { get; set; }
        public DbSet<CentralCoastV3CubeDataRow> CubeData { get; set; }
        // public DbSet<CentralCoastV3WaterDataRow> WaterData { get; set; }
        // public DbSet<CentralCoastV3PatchDataRow> PatchData { get; set; }

        public DbSet<CentralCoastV3TerrainDataRow> TerrainData { get; set; }
    }
}
