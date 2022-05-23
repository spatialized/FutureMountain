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
        public float snow { get; set; }
        public float evap { get; set; }
        public float netpsn { get; set; }
        public float depthToGW { get; set; }
        public float vegAccessWater { get; set; }
        public float Qout { get; set; }
        public float litter { get; set; }
        public float soil { get; set; }
        public float heightOver { get; set; }
        public float transOver { get; set; }
        public float heightUnder { get; set; }
        public float transUnder { get; set; }
        public float leafCOver { get; set; }
        public float stemCOver { get; set; }
        public float rootCOver { get; set; }
        public float leafCUnder { get; set; }
        public float stemCUnder { get; set; }
        public float rootCUnder { get; set; }
        public CubeData() { }
    }
}
