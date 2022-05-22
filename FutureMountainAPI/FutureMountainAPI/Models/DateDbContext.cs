using Microsoft.EntityFrameworkCore;

namespace FutureMountainAPI
{

    /// <summary>
    /// The cube data database context.
    /// </summary>
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
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
                .AddJsonFile("appsettings.json")
                .Build();
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("CubeDataDbContext"));
        }

        public DbSet<Date> Dates { get; set; }
    }
}
