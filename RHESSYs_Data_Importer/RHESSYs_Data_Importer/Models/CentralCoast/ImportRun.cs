using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RHESSYs_Data_Importer.Models.CentralCoast
{
    /// <summary>
    /// Central Coast v2 import provenance / batch marker (table <c>ImportRun</c>).
    ///
    /// One row per import execution. The <c>id</c> is referenced by data rows via
    /// their <c>importRunId</c>, enabling clean re-imports
    /// (delete where importRunId = X), debugging of partial/failed runs, and
    /// row-count verification.
    /// </summary>
    [Table("ImportRun")]
    public class ImportRun
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public string scenarioName { get; set; }
        public string scenarioProfile { get; set; }
        public string scenarioRunId { get; set; }
        public int warmingIdx { get; set; }

        public string databaseName { get; set; }
        public string sourceRoot { get; set; }

        public DateTime startedUtc { get; set; }
        public DateTime? finishedUtc { get; set; }

        // running | succeeded | failed | dryrun
        public string status { get; set; }

        public int filesImported { get; set; }
        public long rowsImported { get; set; }

        [Column(TypeName = "longtext")]
        public string notes { get; set; }
    }
}
