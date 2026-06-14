using System;
using System.Collections.Generic;
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
        /// Inserts a batch of <see cref="CubeDataRow"/> rows in a single
        /// <c>SaveChanges</c> call.
        /// </summary>
        public int AddCubeDataRows(IEnumerable<CubeDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.CubeData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddCubeDataRows failed: {ex.Message}");
                return 0;
            }
        }

        /// <summary>
        /// Inserts a batch of <see cref="WaterDataRow"/> rows in a single
        /// <c>SaveChanges</c> call.
        /// </summary>
        public int AddWaterDataRows(IEnumerable<WaterDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.WaterData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddWaterDataRows failed: {ex.Message}");
                return 0;
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

        /// <summary>
        /// Loads all <see cref="CubeDataRow"/> rows for the given scenario into
        /// a dictionary keyed on <c>(dateIdx, zoneID, patchID)</c>.
        /// Used by the stratum importer to apply in-memory updates before a
        /// single bulk <see cref="SaveCubeDataRows"/> flush.
        /// </summary>
        public (CentralCoastDbContext db, Dictionary<(int dateIdx, int zoneID, long patchID), CubeDataRow> lookup)
            OpenCubeDataLookup(string scenarioRunId, int warmingIdx)
        {
            var db = new CentralCoastDbContext(_connectionString);
            var lookup = db.CubeData
                .Where(r => r.scenarioRunId == scenarioRunId && r.warmingIdx == warmingIdx)
                .ToDictionary(r => (r.dateIdx, r.zoneID, r.patchID));
            return (db, lookup);
        }

        /// <summary>
        /// Saves all tracked changes in <paramref name="db"/> in chunks of
        /// <paramref name="chunkSize"/> to avoid oversized transactions.
        /// The caller is responsible for disposing <paramref name="db"/>.
        /// </summary>
        public static int SaveCubeDataRows(CentralCoastDbContext db, int chunkSize = 5_000)
        {
            var changed = db.ChangeTracker.Entries<CubeDataRow>()
                .Where(e => e.State == Microsoft.EntityFrameworkCore.EntityState.Modified)
                .ToList();

            int total = 0;
            for (int i = 0; i < changed.Count; i += chunkSize)
            {
                foreach (var e in changed.Skip(i).Take(chunkSize))
                    e.State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                total += db.SaveChanges();
            }
            return total;
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

        public bool AddPatchDataRow(PatchDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.PatchData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddPatchDataRow failed: {ex.Message}");
                return false;
            }
        }

        public bool AddTerrainDataRow(TerrainDataRow row)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.TerrainData.Add(row);
                return db.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddTerrainDataRow failed: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Inserts a batch of <see cref="FireDataRow"/> rows in a single
        /// <c>SaveChanges</c> call. Preferred over <see cref="AddFireDataRow"/>
        /// for bulk file imports to avoid per-row round-trips.
        /// </summary>
        public int AddFireDataRows(IEnumerable<FireDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.FireData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddFireDataRows failed: {ex.Message}");
                return 0;
            }
        }

        /// <summary>
        /// Inserts a batch of <see cref="StratumDataRow"/> rows in a single
        /// <c>SaveChanges</c> call.
        /// </summary>
        public int AddStratumDataRows(IEnumerable<StratumDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.StratumData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddStratumDataRows failed: {ex.Message}");
                return 0;
            }
        }

        /// <summary>
        /// Inserts a batch of <see cref="PatchDataRow"/> rows in a single
        /// <c>SaveChanges</c> call.
        /// </summary>
        public int AddPatchDataRows(IEnumerable<PatchDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.PatchData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddPatchDataRows failed: {ex.Message}");
                return 0;
            }
        }

        /// <summary>
        /// Inserts a batch of <see cref="TerrainDataRow"/> rows in a single
        /// <c>SaveChanges</c> call.
        /// </summary>
        public int AddTerrainDataRows(IEnumerable<TerrainDataRow> rows)
        {
            try
            {
                using var db = new CentralCoastDbContext(_connectionString);
                db.TerrainData.AddRange(rows);
                return db.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] AddTerrainDataRows failed: {ex.Message}");
                return 0;
            }
        }
    }
}
