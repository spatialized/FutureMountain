namespace FutureMountainAPI.Models.CentralCoastV3
{
    public class CentralCoastV3CubeDataPrototypeDto
    {
        public int id { get; set; }
        public int dateIdx { get; set; }
        public int scenarioIdx { get; set; }
        public int patchIdx { get; set; }

        public float snow { get; set; }
        //public float groundevap { get; set; }
        //public float canopyevap { get; set; }
        public float evap { get; set; } // groudevap + canopyevap + transOver +transUnder
        public float netpsn { get; set; } // netpsnOver + netpsnUnder
        public float depthToGW { get; set; }
        public float vegAccessWater { get; set; }
        public float qout { get; set; }
        public float litter { get; set; }
        public float soil { get; set; }
       
        public float heightOver { get; set; }
        public float transOver { get; set; }
        public float leafCOver { get; set; }
        public float stemCOver { get; set; }
        public float rootCOver { get; set; }
        public float rootdepthCOver { get; set; }
        public float laiOver { get; set; }
        //public float gppOver { get; set; }
        //public float respOver { get; set; } 
        //public float netpsnOver { get; set; }

        public float heightUnder { get; set; }
        public float transUnder { get; set; }
        public float leafCUnder { get; set; }
        public float stemCUnder { get; set; } // May not be available in V3, set to 0f
        public float rootCUnder { get; set; }
        public float rootdepthUnder { get; set; }
        public float laiUnder { get; set; }
        //public float gppUnder { get; set; } 
        //public float respUnder { get; set; } 
        //public float netpsnUnder { get; set; }

        // public float tmax { get; set; }
        // public float tmin { get; set; }
        // public float relHumidity { get; set; }
        // public float windSpeed { get; set; }
        // public float windDirection { get; set; }

        public float burn { get; set; }
        public float fire { get; set; } 

        public static CentralCoastV3CubeDataPrototypeDto FromRow(CentralCoastV3CubeDataRow row)
        {
            return new CentralCoastV3CubeDataPrototypeDto
            {
                  id = row.id,
                  dateIdx = row.dateIdx,
                  scenarioIdx = row.scenarioIdx,
                  patchIdx = (int)row.patchID,

                  snow = 0f,
                  //groundevap = row.groundevap,
                  //canopyevap = row.canopyevap,
                  evap = row.canopyevap + row.groundevap + row.transOver + row.transUnder,
                  depthToGW = row.depthToGW,
                  vegAccessWater = row.vegAccessWater,
                  qout = row.Qout,
                  litter = row.litterc,
                  soil = row.soilc,
                  netpsn = row.netpsnOver + row.netpsnUnder,

                  heightOver = row.heightOver,
                  transOver = row.transOver,
                  leafCOver = row.leafCOver,
                  stemCOver = row.stemCOver,
                  rootCOver = row.rootCOver,
                  rootdepthCOver = row.rootdepthCOver,
                  laiOver = row.laiOver,
                  //gppOver = row.gppOver,
                  //respOver = row.respOver,
                  //netpsnOver = row.netpsnOver,

                  heightUnder = row.heightUnder,
                  transUnder = row.transUnder,
                  leafCUnder = row.leafCUnder,
                  stemCUnder = 0f,
                  rootCUnder = row.rootCUnder,
                  rootdepthUnder = row.rootdepthUnder,
                  laiUnder = row.laiUnder,
                  //gppUnder = row.gppUnder,
                  //respUnder = row.respUnder,
                  //netpsnUnder = row.netpsnUnder,

                //   tmax = row.tmax,
                //   tmin = row.tmin,
                //   relHumidity = row.relHumidity,
                //   windSpeed = row.windSpeed,
                //   windDirection = row.windDirection,

                  burn = row.burn,
                  fire = row.fire
            };
        }
    }

    // public class CentralCoastPatchDataPrototypeDto
    // {
    //     public int id { get; set; }
    //     public int patchID { get; set; }
    //     public string _data { get; set; }

    //     public static CentralCoastPatchDataPrototypeDto FromRow(CentralCoastPatchDataRow row)
    //     {
    //         return new CentralCoastPatchDataPrototypeDto
    //         {
    //             id = row.id,
    //             patchID = row.zoneID,
    //             _data = row.data
    //         };
    //     }
    // }
}
