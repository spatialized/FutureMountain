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
    /// The cube data database context.
    /// </summary>
    public class DatesDbContext : DbContext
    {
        private readonly string _connectionString;

        public DatesDbContext() : this(ConnectionHelper.GetConnectionString())
        {
        }

        public DatesDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        public DatesDbContext(DbContextOptions<CubeDataDbContext> options) : base(options)
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

        public DbSet<Date> Dates { get; set; }
    }

}
