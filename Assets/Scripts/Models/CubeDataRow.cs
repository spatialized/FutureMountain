using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assets.Scripts.Models
{
    //myObject = JsonUtility.FromJson<CubeDataRowList>("{\"rows\":" + www.text + "}");

    [Serializable]
    public class CubeDataRow
    {
        public int DateIdx { get; set; }
        public float Snow { get; set; }
        public float Evap { get; set; }
        public float NetPsn { get; set; }
        public float DepthToGW { get; set; }
        public float WaterAccess { get; set; }
        public float StreamLevel { get; set; }
        public float Litter { get; set; }
        public float SoilCarbon { get; set; }
        public float HeightOver { get; set; }
        public float TransOver { get; set; }
        public float HeightUnder { get; set; }
        public float TransUnder { get; set; }
        public float LeafCarbonOver { get; set; }
        public float StemCarbonOver { get; set; }
        public float RootCarbonOver { get; set; }
        public float LeafCarbonUnder { get; set; }
        public float StemCarbonUnder { get; set; }
        public float RootCarbonUnder { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }

        public CubeDataRow() { }

        public float[] GetArray()
        {
            float[] arr = new float[22];
            arr[0] = DateIdx;
            arr[1] = Snow;
            arr[2] = Evap;
            arr[3] = NetPsn;
            arr[4] = DepthToGW;
            arr[5] = WaterAccess;
            arr[6] = StreamLevel;
            arr[7] = Litter;
            arr[8] = SoilCarbon;
            arr[9] = HeightOver;
            arr[10] = TransOver;
            arr[11] = HeightUnder;
            arr[12] = TransUnder;
            arr[13] = LeafCarbonOver;
            arr[14] = StemCarbonOver;
            arr[15] = RootCarbonOver;
            arr[16] = LeafCarbonUnder;
            arr[17] = StemCarbonUnder;
            arr[18] = RootCarbonUnder;
            arr[19] = Year;
            arr[20] = Month;
            arr[21] = Day;
            return arr;
        }
    }

    [Serializable]
    public class CubeDataRowList
    {
        public CubeDataRow[] rows;
    }
}
