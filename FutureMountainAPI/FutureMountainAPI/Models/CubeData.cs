using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureMountainAPI
{

    public class CubeData
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        public int dateIdx { get; set; }
        public int warmingIdx { get; set; }
        public int patchIdx { get; set; }
        public decimal snow { get; set; }
        public decimal evap { get; set; }
        public decimal netpsn { get; set; }
        public decimal depthToGW { get; set; }
        public decimal vegAccessWater { get; set; }
        public decimal Qout { get; set; }
        public decimal litter { get; set; }
        public decimal soil { get; set; }
        public decimal heightOver { get; set; }
        public decimal transOver { get; set; }
        public decimal heightUnder { get; set; }
        public decimal transUnder { get; set; }
        public decimal leafCOver { get; set; }
        public decimal stemCOver { get; set; }
        public decimal rootCOver { get; set; }
        public decimal leafCUnder { get; set; }
        public decimal stemCUnder { get; set; }
        public decimal rootCUnder { get; set; }
        public CubeData() { }
    }
}
