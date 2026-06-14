using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Protocols;
using RHESSYs_Data_Importer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RHESSYs_Data_Importer.DAL
{
    /// <summary>
    /// The water data database context.
    /// </summary>
    public class WaterDataDbContext : DbContext
    {
        //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";
        private readonly string _connectionString;

        public WaterDataDbContext() : this(ConnectionHelper.GetConnectionString())
        {
        }

        public WaterDataDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        public WaterDataDbContext(DbContextOptions<WaterDataDbContext> options) : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var cs = _connectionString ?? ConnectionHelper.GetConnectionString();
                optionsBuilder.UseMySql(cs, ServerVersion.AutoDetect(cs));
            }
        }

        public DbSet<WaterDataFrame> WaterData { get; set; }
    }

}
