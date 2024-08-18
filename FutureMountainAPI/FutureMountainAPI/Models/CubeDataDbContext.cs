// REMOTE
//using MySql.Data.Entity;
using Microsoft.EntityFrameworkCore;
//using MySql.Data.EntityFrameworkCore;
//using System.Data.Entity;
//using DbContext = System.Data.Entity.DbContext;

// LOCAL
//using Microsoft.EntityFrameworkCore;
//using Microsoft.EntityFrameworkCore.SqlServer.Infrastructure.Internal;
//using DbContext = Microsoft.EntityFrameworkCore.DbContext;

namespace FutureMountainAPI
{
    /// REMOTE

    /// /// <summary>
    /// The cube data database context.
    /// </summary>
    //[DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class CubeDataDbContext : DbContext
    {
        //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";

        public CubeDataDbContext()
        {
        }

        public CubeDataDbContext(DbContextOptions<CubeDataDbContext> options) : base(options)
        {
        }

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString;
        //    optionsBuilder.UseSqlServer(connectionString);
        //}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json")
                .Build();

            string connectionString = configuration.GetConnectionString("CubeDataDbContext");

            // Sql Server
            //optionsBuilder.UseSqlServer(configuration.GetConnectionString("CubeDataDbContext"));

            // MySQL
            optionsBuilder.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<CubeData> CubeData { get; set; }
    }
}
