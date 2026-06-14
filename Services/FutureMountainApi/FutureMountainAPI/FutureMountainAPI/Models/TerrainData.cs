using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace FutureMountainAPI.Models
{
    [Serializable]
    public class TerrainDataFrameJSONRecord
    {
        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        //[Key]
        //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int gridSize { get; set; }
        public int pixelGrainSize { get; set; }
        public int decimalPrecision { get; set; }

        public string _dataList { get; set; } //Contains int[] dataList;

        //[NotMapped]
        //public int[] DataList
        //{
        //    get { return JsonConvert.DeserializeObject<int[]>(string.IsNullOrEmpty(_dataList) ? "{}" : _dataList); }
        //    set { _dataList = value.ToString(); }
        //}

        public void SetDataList(int[] newDataList)
        {
            try
            {
                _dataList = JsonConvert.SerializeObject(newDataList);
            }
            catch (Exception ex)
            {
                Console.WriteLine("SetData()... ERROR... ex:" + ex.Message);
            }
        }
    }
}
