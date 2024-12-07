using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;
using static CubeController;

/// <summary>
/// Class for managing Unity web requests
/// </summary>
public class WebManager : MonoBehaviour
{
    private static bool runOnLocal = false;                 // Run on local (true) or remote (false) server
    private static bool debug = false;
    private static bool debugDetailed = false;

    private static WebManager _instance;
    public static WebManager Instance { get { return _instance; } }

    private static string connectionStringBase = runOnLocal ? "https://localhost:7273/api/" : "https://data.futuremtn.org/api/";
    //private static string connectionStringBase = runOnLocal ? "http://localhost:5056/api/" : "http://192.168.0.32:5550/api/";
    private static string apiPathCubes = "cubedata/";
    private static string apiPathWater = "waterdata/";
    private static string apiPathDates = "dates/";

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    //public void RequestCubeData(int patchIdx, int warmingIdx, int timeIdxStart, int timeIdxEnd, Action<string> callback)
    //{
    //    string uri = connectionStringBase + apiPathCubes + patchIdx + "/" + warmingIdx + "/" + timeIdxStart + "/" + timeIdxEnd;
    //    if (debug)
    //        Debug.Log("RequestCubeData()... uri:  " + uri);

    //    Coroutine coroutine = this.StartCoroutine(this.GetRequest(uri, callback));
    //}

    // Gets all data rows for given Patch Id and Warming Idx
    public Coroutine RequestCubeData(int patchIdx, int warmingIdx, Action<string> callback)
    {
        string uri = connectionStringBase + apiPathCubes + patchIdx + "/" + warmingIdx;

        if(debug)
            Debug.Log("RequestCubeData()... uri:  " + uri);

        return this.StartCoroutine(this.GetRequest(uri, callback));
    }


    // Gets precipitation data for given data index
    public Coroutine RequestWaterData(int index, Action<string> callback)
    {
        string uri = connectionStringBase + apiPathWater + index;

        if (debug)
            Debug.Log("RequestWaterData()... uri:  " + uri);

        return this.StartCoroutine(this.GetRequest(uri, callback));
    }

    // Gets precipitation data for given data index
    public Coroutine GetTimelineWaterData(Action<string> callback)
    {
        string uri = connectionStringBase + apiPathWater + "total";

        if (debug)
            Debug.Log("GetTimelineWaterData()... uri:  " + uri);

        return this.StartCoroutine(this.GetRequest(uri, callback));
    }

    

    // Unused
    public Coroutine GetDateIndex(int year, int month, int day, Action<string> callback)
    {
        string uri = connectionStringBase + apiPathDates + year + "/" + month + "/" + day;
        if(debug)
            Debug.Log("GetDateIndex()... uri:  " + uri);

        return this.StartCoroutine(this.GetRequest(uri, callback));
    }

    public Coroutine GetDataDates(Action<string> callback)
    {
        string uri = connectionStringBase + apiPathDates;
        if(debug)
            Debug.Log("GetDataDates()... uri:  " + uri);

        return this.StartCoroutine(this.GetRequest(uri, callback));
    }

    private IEnumerator GetRequest(string uri, Action<string> callback)
    {
        using (UnityWebRequest webRequest = UnityWebRequest.Get(uri))
        {
            webRequest.SetRequestHeader("Access-Control-Allow-Origin", "*");

            // Request and wait for the desired page.
            yield return webRequest.SendWebRequest();

            var data = webRequest.downloadHandler.text;

            if (debug && debugDetailed)
                Debug.Log("GetRequest()... uri: " + uri);

            if (webRequest.result == UnityWebRequest.Result.ConnectionError)
            {
                Debug.Log("GetRequest()... Connection Error: " + webRequest.error);
            }
            else
            {
                if(debug && debugDetailed)
                    Debug.Log("GetRequest()... data: " + data);

                if (callback != null)
                    callback(data);
            }
        }
    }


    //date snow evap netpsn depthtogw vegaccesswater Qout litter soil height_over trans_over height_under trans_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
    /// <summary>
    /// Cube data parameter columns used in simulation
    /// </summary>
    private enum DataColumnIdx
    {
        Date = 0,
        Snow = 1,
        Evap = 2,
        NetPsn = 3,
        DepthToGW = 4,
        WaterAccess = 5,
        StreamLevel = 6,
        Litter = 7,
        SoilCarbon = 8,
        HeightOver = 9,
        TransOver = 10,
        HeightUnder = 11,
        TransUnder = 12,
        LeafCarbonOver = 13,
        StemCarbonOver = 14,
        RootCarbonOver = 15,
        LeafCarbonUnder = 16,
        StemCarbonUnder = 17,
        RootCarbonUnder = 18,
        Year = 19,
        Month = 20,
        Day = 21
    };

    //  date snow evap netpsn depthtogw vegaccesswater Qout litter soil height_over trans height_under leafc_over stemc_over rootc_over leafc_under stemc_under rootc_under year month day
    private enum AggregateDataColumnIdx
    {
        Date = 0,
        Snow = 1,
        Evap = 2,
        NetPsn = 3,
        DepthToGW = 4,
        WaterAccess = 5,
        StreamLevel = 6,
        Litter = 7,
        SoilCarbon = 8,
        HeightOver = 9,
        Trans = 10,
        HeightUnder = 11,
        //TransUnder = 12,
        LeafCarbonOver = 13,
        StemCarbonOver = 14,
        RootCarbonOver = 15,
        LeafCarbonUnder = 16,
        StemCarbonUnder = 17,
        RootCarbonUnder = 18,
        Year = 19,
        Month = 20,
        Day = 21
    }
}
