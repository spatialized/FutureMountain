using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Protocols;
using RHESSYs_Data_Importer.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RHESSYs_Data_Importer.Models.RHESSYs_Data_Importer.Models;

namespace RHESSYs_Data_Importer.DAL
{
    /// <summary>
    /// The terrain data database context.
    /// </summary>
    public class TerrainDataDbContext : DbContext
    {
        //private const string connectionString = "Server=localhost\\SQLEXPRESS;Database=EFCore;Trusted_Connection=True;";
        private readonly string _connectionString;

        public TerrainDataDbContext() : this(ConnectionHelper.GetConnectionString())
        {
        }

        public TerrainDataDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        public TerrainDataDbContext(DbContextOptions<TerrainDataDbContext> options) : base(options)
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

        public DbSet<TerrainDataFrameJSONRecord> TerrainData { get; set; }
    }

}
