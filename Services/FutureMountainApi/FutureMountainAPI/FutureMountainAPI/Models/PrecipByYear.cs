using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FutureMountainAPI.Models
{
    /// <summary>
    /// Water data frame.
    /// </summary>
    //[Serializable]
    public class PrecipByYear
    {
        public int year { get; set; }
        public float precipitation { get; set; }

        public int GetYear()
        {
            return year;
        }

        public float GetPrecipitation()
        {
            return precipitation;
        }
    }
    
}
