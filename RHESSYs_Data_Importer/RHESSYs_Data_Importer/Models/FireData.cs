using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace RHESSYs_Data_Importer.Models
{
    /// <summary>
    /// Fire data frame.
    /// </summary>
    [Serializable]
    public class FireDataFrameRecord
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; } = 0;

        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public int gridHeight { get; set; }
        public int gridWidth { get; set; }
        public List<FireDataPoint> dataList { get; set; }

        //public FireDataFrameRecord(int newDay, int newMonth, int newYear, int newGridHeight, int newGridWidth,
        //    List<FireDataPoint> newDataList) //, FireDataPointCollection[,] newDataGrid)
        //{
        //    year = newYear;
        //    month = newMonth;
        //    day = newDay;
        //    dataList = newDataList;
        //    gridSize = newGridHeight;
        //    gridWidth = newGridWidth;
        //}

        public int GetYear()
        {
            return year;
        }

        public int GetMonth()
        {
            return month;
        }

        //public void SetDay(int newDay)
        //{
        //    day = newDay;
        //}
        public int GetDay()
        {
            return day;
        }

        public int GetGridHeight()
        {
            return gridHeight;
        }

        public int GetGridWidth()
        {
            return gridWidth;
        }

        public List<FireDataPoint> GetDataList()
        {
            return dataList;
        }

        public FireDataFrameJSONRecord GetJsonRecord()
        {
            FireDataFrameJSONRecord jsonRecord = new FireDataFrameJSONRecord();
            jsonRecord.year = year;
            jsonRecord.month = month;
            jsonRecord.day = day;
            jsonRecord.gridHeight = gridHeight;
            jsonRecord.gridWidth = gridWidth;
            //jsonRecord.id = id;

            jsonRecord.SetDataList(dataList);
            return jsonRecord;
        }
    }

    /// <summary>
    /// Data point on fire grid associated with a PatchPoint.
    /// </summary>
    [Serializable]
    public class FireDataPoint : IComparable<FireDataPoint>
    {
        //[Key] 
        //private int id;
        public Vector2 gridLocation { get; set; }
        public int patchId { get; set; }
        public float spread { get; set; }
        public int iter { get; set; }

        /// <summary>
        /// Constructor 
        /// </summary>
        /// <param name="patchPoint">Position in terrain alphamap grid</param>
        /// <param name="newSpread"></param>
        /// <param name="newIter"></param>
        //public FireDataPoint(Vector2 newGridLocation, int newPatchId, float newSpread, int newIter)
        //{
        //    gridLocation = newGridLocation;
        //    patchId = newPatchId;
        //    spread = newSpread;
        //    iter = newIter;

        //    //gridLocation = patchPoint.GetFireGridLocation();
        //    //patchId = patchPoint.GetPatchID();
        //}

        ///// <summary>
        ///// Constructor 
        ///// </summary>
        ///// <param name="patchPoint">Position in terrain alphamap grid</param>
        ///// <param name="newSpread"></param>
        ///// <param name="newIter"></param>
        //public FireDataPoint(PatchPoint patchPoint, float newSpread, int newIter)
        //{
        //    spread = newSpread;
        //    iter = newIter;

        //    gridLocation = patchPoint.GetFireGridLocation();
        //    patchId = patchPoint.GetPatchID();
        //}

        //public PatchPoint GetPatchPoint()
        //{
        //    return patchPoint;
        //}

        public Vector2 GetGridPosition()
        {
            return gridLocation;
            //return patchPoint.GetFireGridLocation();
        }

        ///// <summary>
        ///// Gets X coord.
        ///// </summary>
        ///// <returns>The x.</returns>
        //public int X()
        //{
        //    return (int)gridLocation.x;
        //    //return (int)patchPoint.GetFireGridLocation().x;
        //}

        ///// <summary>
        ///// Gets Y coord.
        ///// </summary>
        ///// <returns>The y.</returns>
        //public int Y()
        //{
        //    return (int)gridLocation.y;
        //    //return (int)patchPoint.GetFireGridLocation().y;
        //}

        public float GetSpread()
        {
            return spread;
        }

        public int GetIter()
        {
            return iter;
        }

        public int GetPatchID()
        {
            return patchId;
            //return patchPoint.GetPatchID();
        }

        public int CompareTo(FireDataPoint that)
        {
            return this.GetIter().CompareTo(that.GetIter());
        }
    }


    public class FireDataFrameJSONRecord
    {
        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int warmingIdx { get; set; }
        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public int gridHeight { get; set; }
        public int gridWidth { get; set; }

        public string _dataList { get; set; }        //Contains List<FireDataPoint> dataList;

        [NotMapped]
        public List<FireDataPoint> DataList
        {
            get
            {
                return JsonConvert.DeserializeObject<List<FireDataPoint>>(string.IsNullOrEmpty(_dataList) ? "{}" : _dataList);
            }
            set
            {
                _dataList = value.ToString();
            }
        }

        public void SetDataList(List<FireDataPoint> newDataList)
        {
            try
            {
                _dataList = JsonConvert.SerializeObject(newDataList);
            }
            catch (Exception ex)
            {
                Console.WriteLine("SetData()... ERROR... ex:"+ex.Message);
            }
        }
    }
}
