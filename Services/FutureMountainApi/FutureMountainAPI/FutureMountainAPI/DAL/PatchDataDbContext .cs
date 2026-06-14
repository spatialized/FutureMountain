using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Protocols;
using FutureMountainAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureMountainAPI.DAL

{
    /// <summary>
    /// The patch data database context.
    /// </summary>
    //[DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class PatchDataDbContext : DbContext
    {
        //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";

        public PatchDataDbContext()
        {
        }

        public PatchDataDbContext(DbContextOptions<PatchDataDbContext> options) : base(options)
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

        public DbSet<PatchDataRecord> PatchData { get; set; }
    }

}