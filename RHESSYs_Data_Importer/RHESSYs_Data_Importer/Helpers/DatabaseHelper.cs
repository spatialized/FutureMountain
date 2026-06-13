using System;
using RHESSYs_Data_Importer.Configuration;

namespace RHESSYs_Data_Importer.Helpers
{
    public static class DatabaseHelper
    {
        public static void CreateNewDatabase(ScenarioConfig config)
        {
            // Placeholder implementation to avoid extra driver dependencies.
            // This logs the intended action; swap to a real implementation with MySqlConnector/MySql.Data if desired.
            var dbName = config.Database.Name + "_test";
            Console.WriteLine($"[INFO] (Simulated) Would create new database: {dbName} on {config.Database.Host}:{config.Database.Port}");
            Console.WriteLine("[INFO] Implement real DB creation using MySqlConnector if needed.");
        }

        public static bool IsDatabaseEmpty(string connectionString)
        {
            Console.WriteLine("[INFO] (Simulated) Checking if database is empty.");
            // Return false to be conservative by default.
            return false;
        }
    }
}
