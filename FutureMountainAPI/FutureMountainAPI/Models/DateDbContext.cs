using Microsoft.EntityFrameworkCore;
//using MySql.Data.EntityFrameworkCore;
//using System.Data.Entity;
//using DbContext = System.Data.Entity.DbContext;

// LOCAL
//using DbContext = Microsoft.EntityFrameworkCore.DbContext;

namespace FutureMountainAPI
{
    // REMOTE
    /// <summary>
    /// The cube data database context.
    /// </summary>
    //[DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class DateDbContext : DbContext
    {
        //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";

        public DateDbContext()
        {
        }

        public DateDbContext(DbContextOptions<DateDbContext> options) : base(options)
        {
        }

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString;
        //    optionsBuilder.UseSqlServer(connectionString);
        //}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            // Local
            //string connectionString = "Server=DESKTOP-BGU64QR\\SQLEXPRESS;Initial Catalog=FutureMountain;User ID=REDACTED_USER;password=REDACTED_PASSWORD;";
            // Remote
            string connectionString = "Server=REDACTED_HOST:16751;User ID=REDACTED_USER;Password=REDACTED_PASSWORD;Database=defaultdb";

            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json")
                .Build();
            optionsBuilder.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<Date> Dates { get; set; }

        // LOCAL
        ///// <summary>
        ///// The cube data database context.
        ///// </summary>
        //[DbConfigurationType(typeof(MySqlEFConfiguration))]
        //public class DateDbContext : DbContext
        //{
        //    //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";

        //    public DateDbContext()
        //    {
        //    }

        //    public DateDbContext(DbContextOptions<DateDbContext> options) : base(options)
        //    {
        //    }

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["CubeDataDbContext"].ConnectionString;
        //    optionsBuilder.UseSqlServer(connectionString);
        //}

        //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //    {
        //        // Local
        //        //string connectionString = "Server=DESKTOP-BGU64QR\\SQLEXPRESS;Initial Catalog=FutureMountain;User ID=REDACTED_USER;password=REDACTED_PASSWORD;";
        //        // Remote
        //        string connectionString = "Server=REDACTED_HOST:16751;User ID=REDACTED_USER;Password=REDACTED_PASSWORD;Database=futuremountain";

        //        IConfigurationRoot configuration = new ConfigurationBuilder()
        //            .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
        //            .AddJsonFile("appsettings.json")
        //            .Build();
        //        optionsBuilder.UseSqlServer(connectionString);
        //    }

        //    public Microsoft.EntityFrameworkCore.DbSet<Date> Dates { get; set; }
    }
}
