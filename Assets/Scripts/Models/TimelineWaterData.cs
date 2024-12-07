using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assets.Scripts.Models
{
    [Serializable]
    public class TimelineWaterData
    {
        public PrecipByYear[] years { get; set; }
    }

    public class PrecipByYear
    {
        public int year { get; set; }
        public int precipitation { get; set; }
    }
}
