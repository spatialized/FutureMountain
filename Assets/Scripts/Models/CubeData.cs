using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assets.Scripts.Models
{
    [Serializable]
    public class CubeData
    {
        //public int Id;
        //public int DateIdx;
        //public int WarmingIdx;
        //public int PatchIdx;
        //public float Snow;
        //public float Evap;
        //public float NetPsn;
        //public float DepthToGW;
        //public float VegAccessWater;
        //public float Qout;
        //public float Litter;
        //public float Soil;
        //public float HeightOver;
        //public float TransOver;
        //public float HeightUnder;
        //public float TransUnder;
        //public float LeafCOver;
        //public float StemCOver;
        //public float RootCOver;
        //public float LeafCUnder;
        //public float StemCUnder;
        //public float RootCUnder;

        public int id;
        public int dateIdx;
        public int warmingIdx;
        public int patchIdx;
        public float snow;
        public float evap;
        public float netpsn;
        public float depthToGW;
        public float vegAccessWater;
        public float Qout;
        public float litter;
        public float soil;
        public float heightOver;
        public float transOver;
        public float heightUnder;
        public float transUnder;
        public float leafCOver;
        public float stemCOver;
        public float rootCOver;
        public float leafCUnder;
        public float stemCUnder;
        public float rootCUnder;
    }

    [Serializable]
    public class CubeDataModelList
    {
        public CubeData[] rows;
    }

    //myObject = JsonUtility.FromJson<CubeDataRowList>("{\"rows\":" + www.text + "}");

    //"id":1514816,"dateIdx":1,"warmingIdx":0,"patchIdx":-1,"snow":0,"evap":0,"netpsn":0,"depthToGW":1689,
    //"vegAccessWater":348,"qout":0,"litter":1,"soil":12,"heightOver":19,"transOver":3,"heightUnder":2,
    //"transUnder":0,"leafCOver":1,"stemCOver":5,"rootCOver":4,"leafCUnder":0,"stemCUnder":1,"rootCUnder":1

    //[{"id":1516317,
    //"dateIdx":1502,
    //"warmingIdx":0,
    //"patchIdx":-1,
    //"snow":0,
    //"evap":0,
    //"netpsn":0,
    //"depthToGW":1852,
    //"vegAccessWater":189,
    //"qout":0,
    //"litter":1,
    //"soil":12,
    //"heightOver":19,
    //"transOver":1,
    //"heightUnder":2,
    //"transUnder":0,
    //"leafCOver":1,
    //"stemCOver":5,
    //"rootCOver":4,
    //"leafCUnder":0,
    //"stemCUnder":1,
    //"rootCUnder":1},
}
