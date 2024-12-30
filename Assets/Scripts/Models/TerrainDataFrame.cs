using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Assets.Scripts.Models
{
    /// <summary>
    /// Terrain data frame.
    /// </summary>
    [Serializable]
    public class TerrainDataFrame
    {
        //[Key]
        //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; } = 0;

        public int year { get; set; }
        public int month { get; set; }
        public int gridHeight { get; set; }
        public int gridWidth { get; set; }
        public int pixelGrainSize { get; set; }
        public int decimalPrecision { get; set; }
        public int[] dataList { get; set; }

        public TerrainDataFrame(int newMonth, int newYear, int newGridHeight, int newGridWidth,
            int newPixelGrainSize, int newDecimalPrecision,
            int[] newDataList) //, FireDataPointCollection[,] newDataGrid)
        {
            year = newYear;
            month = newMonth;
            dataList = newDataList;
            gridHeight = newGridHeight;
            gridWidth = newGridWidth;
            pixelGrainSize = newPixelGrainSize;
            decimalPrecision = newDecimalPrecision;
            dataList = newDataList;
        }

        public int GetYear()
        {
            return year;
        }

        public int GetMonth()
        {
            return month;
        }

        public int GetPixelGrainSize()
        {
            return pixelGrainSize;
        }

        public int GetDecimalPrecision()
        {
            return decimalPrecision;
        }

        public int GetGridHeight()
        {
            return gridHeight;
        }

        public int GetGridWidth()
        {
            return gridWidth;
        }

        public int[] GetDataList()
        {
            return dataList;
        }

        public TerrainDataFrameJSONRecord GetJsonRecord()
        {
            TerrainDataFrameJSONRecord jsonRecord = new TerrainDataFrameJSONRecord();
            //jsonRecord.id = id;
            jsonRecord.year = year;
            jsonRecord.month = month;
            jsonRecord.gridHeight = gridHeight;
            jsonRecord.gridWidth = gridWidth;
            jsonRecord.pixelGrainSize = pixelGrainSize;
            jsonRecord.decimalPrecision = decimalPrecision;

            jsonRecord.SetDataList(dataList);
            return jsonRecord;
        }
    }



    public class TerrainDataFrameJSONRecord
    {
        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        //[Key]
        //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int gridHeight { get; set; }
        public int gridWidth { get; set; }
        public int pixelGrainSize { get; set; }
        public int decimalPrecision { get; set; }

        public string _dataList { get; set; }        //Contains int[] dataList;

        //[NotMapped]
        public int[] DataList
        {
            get
            {
                return JsonConvert.DeserializeObject<int[]>(string.IsNullOrEmpty(_dataList) ? "{}" : _dataList);
            }
            set
            {
                _dataList = value.ToString();
            }
        }

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
