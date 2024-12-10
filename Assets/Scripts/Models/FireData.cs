using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Assets.Scripts.Models
{
    [Serializable]
    public class FireDataFrameJSONRecord
    {
        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        //[Key]
        //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public int gridHeight { get; set; }
        public int gridWidth { get; set; }

        public string _dataList { get; set; } //Contains List<FireDataPoint> dataList;

        public List<FireDataPoint> DataList
        {
            get
            {
                return JsonConvert.DeserializeObject<List<FireDataPoint>>(string.IsNullOrEmpty(_dataList)
                    ? "{}"
                    : _dataList);
            }
            set { _dataList = value.ToString(); }
        }

        public void SetDataList(List<FireDataPoint> newDataList)
        {
            try
            {
                _dataList = JsonConvert.SerializeObject(newDataList);
            }
            catch (Exception ex)
            {
                Console.WriteLine("SetDataList()... ERROR... ex:" + ex.Message);
            }
        }
    }
}
