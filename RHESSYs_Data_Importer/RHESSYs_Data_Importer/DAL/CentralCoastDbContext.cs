using Microsoft.EntityFrameworkCore;
using RHESSYs_Data_Importer.Models;
using RHESSYs_Data_Importer.Models.CentralCoast;

namespace RHESSYs_Data_Importer.DAL
{
    /// <summary>
    /// Database context for the Central Coast v2 profile.
    ///
    /// All Central Coast tables live in one database (e.g. centralcoast_rhessys),
    /// so they are exposed from a single context. Big Creek v1 keeps its existing
    /// per-table contexts and database; this context does not touch them.
    /// Table names are set via [Table(...)] on each model and match the original
    /// Big Creek naming style.
    /// </summary>
    public class CentralCoastDbContext : DbContext
    {
        private readonly string _connectionString;

        public CentralCoastDbContext() : this(ConnectionHelper.GetConnectionString())
        {
        }

        public CentralCoastDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        public CentralCoastDbContext(DbContextOptions<CentralCoastDbContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // The [Index] attributes on the models drive the migration, but
            // OnModelCreating is the authoritative place for any additional
            // constraints or composite indexes added in future iterations.
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var cs = _connectionString ?? ConnectionHelper.GetConnectionString();
                var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));
                optionsBuilder.UseMySql(cs, serverVersion, mySqlOptions =>
                {
                    // Transient resiliency: retry automatically on dropped/interrupted
                    // connections (e.g. a VPN reconnect mid-import) instead of silently
                    // losing a batch of rows.
                    mySqlOptions.EnableRetryOnFailure(
                        maxRetryCount: 10,
                        maxRetryDelay: TimeSpan.FromSeconds(30),
                        errorNumbersToAdd: null);

                    // Large aggregate scans over multi-million-row StratumData
                    // (e.g. the globalMaxPlantC Max() during terrain generation)
                    // exceed the default 30s command timeout on the production
                    // server. Allow up to 10 minutes per command.
                    mySqlOptions.CommandTimeout(600);
                });
            }
        }

        public DbSet<Date> Dates { get; set; }
        public DbSet<CubeDataRow> CubeData { get; set; }
        public DbSet<WaterDataRow> WaterData { get; set; }
        public DbSet<FireDataRow> FireData { get; set; }
        public DbSet<StratumDataRow> StratumData { get; set; }
        public DbSet<PatchDataRow> PatchData { get; set; }
        public DbSet<TerrainDataRow> TerrainData { get; set; }
        public DbSet<ImportRun> ImportRun { get; set; }
    }
}
