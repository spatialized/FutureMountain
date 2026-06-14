using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace RHESSYs_Data_Importer.DAL
{
    /// <summary>
    /// Design-time factory for <see cref="CentralCoastDbContext"/>.
    ///
    /// Used exclusively by <c>dotnet ef migrations add</c> and
    /// <c>dotnet ef database update</c>. It targets the local
    /// <c>futuremtn_central_coast</c> schema so that migration generation
    /// and schema application work without a running import config.
    ///
    /// This connection string is for local development only. Production
    /// and CI deployments apply migrations via their own connection, passed
    /// through <see cref="ConnectionHelper"/> at runtime.
    /// </summary>
    public class CentralCoastDbContextFactory : IDesignTimeDbContextFactory<CentralCoastDbContext>
    {
        public CentralCoastDbContext CreateDbContext(string[] args)
        {
            const string cs =
                "Server=127.0.0.1;Port=3306;Database=futuremtn_central_coast;" +
                "User=admin;Password=Historic-valley;CharSet=utf8mb4;";

            var optionsBuilder = new DbContextOptionsBuilder<CentralCoastDbContext>();
            // Use a pinned server version so migration generation does not require
            // a live database connection (ServerVersion.AutoDetect would open a socket).
            var serverVersion = new MySqlServerVersion(new Version(8, 0, 36));
            optionsBuilder.UseMySql(cs, serverVersion);
            return new CentralCoastDbContext(optionsBuilder.Options);
        }
    }
}
