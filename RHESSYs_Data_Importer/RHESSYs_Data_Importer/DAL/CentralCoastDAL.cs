using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using RHESSYs_Data_Importer.Models.CentralCoast;

namespace RHESSYs_Data_Importer.DAL
{
    /// <summary>
    /// Data access layer for Central Coast v2 tables.
    /// Uses <see cref="CentralCoastDbContext"/> for all writes.
    /// </summary>
    public class CentralCoastDAL
    {
        private readonly string _connectionString;

        public CentralCoastDAL() : this(ConnectionHelper.GetConnectionString())
        {
        }

        public CentralCoastDAL(string connectionString)
        {
            _connectionString = connectionString;
        }

        public bool AddWaterDataRow(WaterDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.WaterData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddWaterDataRow failed: {ex.Message}");
                return false;
            }
        }

        public bool AddCubeDataRow(CubeDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.CubeData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddCubeDataRow failed: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Finds the existing <see cref="CubeDataRow"/> matching the composite
        /// key and applies the supplied updater. Used by the stratum importer
        /// to fill overstory/understory columns after the patch importer has
        /// created the base rows.
        /// </summary>
        public bool UpdateCubeDataStratum(int dateIdx, int zoneID, long patchID,
            string scenarioRunId, int warmingIdx, Action<CubeDataRow> updater)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                var row = db.CubeData.FirstOrDefault(r =>
                    r.dateIdx == dateIdx &&
                    r.zoneID == zoneID &&
                    r.patchID == patchID &&
                    r.scenarioRunId == scenarioRunId &&
                    r.warmingIdx == warmingIdx);
                if (row == null)
                    return false;
                updater(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] UpdateCubeDataStratum failed: {ex.Message}");
                return false;
            }
        }

        public bool AddFireDataRow(FireDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.FireData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddFireDataRow failed: {ex.Message}");
                return false;
            }
        }

        public bool AddStratumDataRow(StratumDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.StratumData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddStratumDataRow failed: {ex.Message}");
                return false;
            }
        }
    }
}
