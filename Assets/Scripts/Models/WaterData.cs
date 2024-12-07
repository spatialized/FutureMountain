using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assets.Scripts.Models
{
    [Serializable]
    public class WaterData
    {
        public int index { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public float qBase { get; set; }
        public float qWarm1 { get; set; }
        public float qWarm2 { get; set; }
        public float qWarm4 { get; set; }
        public float qWarm6 { get; set; }
        public int precipitation { get; set; }
    }

}
