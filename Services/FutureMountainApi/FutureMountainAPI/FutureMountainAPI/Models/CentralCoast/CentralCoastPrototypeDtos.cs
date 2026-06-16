namespace FutureMountainAPI.Models.CentralCoast
{
    public class CentralCoastCubeDataPrototypeDto
    {
        public int id { get; set; }
        public int dateIdx { get; set; }
        public int warmingIdx { get; set; }
        public int patchIdx { get; set; }
        public float snow { get; set; }
        public float evap { get; set; }
        public float netpsn { get; set; }
        public float depthToGW { get; set; }
        public float vegAccessWater { get; set; }
        public float qout { get; set; }
        public float litter { get; set; }
        public float soil { get; set; }
        public float heightOver { get; set; }
        public float transOver { get; set; }
        public float heightUnder { get; set; }
        public float transUnder { get; set; }
        public float leafCOver { get; set; }
        public float stemCOver { get; set; }
        public float rootCOver { get; set; }
        public float leafCUnder { get; set; }
        public float stemCUnder { get; set; }
        public float rootCUnder { get; set; }

        public static CentralCoastCubeDataPrototypeDto FromRow(CentralCoastCubeDataRow row)
        {
            return new CentralCoastCubeDataPrototypeDto
            {
                id = row.id,
                dateIdx = row.dateIdx,
                warmingIdx = row.warmingIdx,
                patchIdx = (int)row.patchID,
                snow = 0,
                evap = row.canopyevap + row.groundevap,
                netpsn = row.netpsnOver + row.netpsnUnder,
                depthToGW = row.depthToGW,
                vegAccessWater = row.vegAccessWater,
                qout = row.Qout,
                litter = row.litterc,
                soil = row.soilc,
                heightOver = row.heightOver,
                transOver = row.transOver,
                heightUnder = row.heightUnder,
                transUnder = row.transUnder,
                leafCOver = row.leafCOver,
                stemCOver = row.stemCOver,
                rootCOver = row.rootCOver,
                leafCUnder = row.leafCUnder,
                stemCUnder = row.stemCUnder,
                rootCUnder = row.rootCUnder
            };
        }
    }

    public class CentralCoastPatchDataPrototypeDto
    {
        public int id { get; set; }
        public int patchID { get; set; }
        public string _data { get; set; }

        public static CentralCoastPatchDataPrototypeDto FromRow(CentralCoastPatchDataRow row)
        {
            return new CentralCoastPatchDataPrototypeDto
            {
                id = row.id,
                patchID = row.zoneID,
                _data = row.data
            };
        }
    }
}
