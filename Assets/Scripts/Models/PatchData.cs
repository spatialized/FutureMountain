using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Assets.Scripts.Models
{
    public class PatchDataRecord
    {
        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        public int id { get; set; }
        public int patchID { get; set; }
        public string _data { get; set; } //Contains PatchPointCollection data;

        public PatchPointCollection Data
        {
            get
            {
                return JsonConvert.DeserializeObject<PatchPointCollection>(string.IsNullOrEmpty(_data)
                    ? "{}"
                    : _data);
            }
            set { _data = value.ToString(); }
        }

        public void SetData(PatchPointCollection newData)
        {
            try
            {
                _data = JsonConvert.SerializeObject(newData);
            }
            catch (Exception ex)
            {
                Console.WriteLine("SetData()... ERROR... ex:" + ex.Message);
            }
        }
    }


    /// <summary>
    /// Patch point collection.
    /// </summary>
    [Serializable]
    public class PatchPointCollection
    {
        public int id { get; set; }

        public int patchID { get; set; }
        public List<PatchPoint> points; // Points in collection

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchPointCollection"/> class.
        /// </summary>
        public PatchPointCollection(int newPatchID)
        {
            patchID = newPatchID;
            points = new List<PatchPoint>();
        }

        /// <summary>
        /// Adds point to collection.
        /// </summary>
        /// <param name="newPoint">New point.</param>
        public void AddPoint(PatchPoint newPoint)
        {
            points.Add(newPoint);
        }

        /// <summary>
        /// Adds point to collection.
        /// </summary>
        /// <param name="newPoint">New point.</param>
        public bool ContainsPoint(PatchPoint newPoint)
        {
            return points.Contains(newPoint);
        }

        /// <summary>
        /// Clears the points.
        /// </summary>
        public void ClearPoints()
        {
            points = new List<PatchPoint>();
        }

        /// <summary>
        /// Gets the points.
        /// </summary>
        /// <returns>The points.</returns>
        public List<PatchPoint> GetPoints()
        {
            return points;
        }

        /// <summary>
        /// Gets the patch identifier.
        /// </summary>
        /// <returns>The patch identifier.</returns>
        public int GetPatchID()
        {
            return patchID;
        }
    }

    /// <summary>
    /// Point on terrain associated with a patch ID.
    /// </summary>
    [Serializable]
    public class PatchPoint
    {
        public int id { get; set; }

        public int patchID { get; set; }
        public Vector2 location { get; set; } // Patch grid location (col, row in data file)
        public Vector2 fireLocation { get; set; } // Fire grid location
        public Vector2 alphamapLoc { get; set; } // Alphamap grid location
        public Vector3 utm { get; set; } // UTM location

        /// <summary>
        /// Initializes a new instance of the <see cref="T:LandscapeController.PatchPoint"/> class.
        /// </summary>
        /// <param name="newPatchID">New patch identifier.</param>
        /// <param name="newLocation">New location.</param>
        /// <param name="newUTM">New utm.</param>
        public PatchPoint(int newPatchID, Vector2 newLocation, Vector2 newFireLocation, Vector2 newAlphamapLocation, Vector3 newUTM)
        {
            patchID = newPatchID;
            location = newLocation;
            fireLocation = newFireLocation;
            alphamapLoc = newAlphamapLocation;
            utm = newUTM;
        }

        /// <summary>
        /// Gets the patch identifier.
        /// </summary>
        /// <returns>The patch identifier.</returns>
        public int GetPatchID()
        {
            return patchID;
        }

        /// <summary>
        /// Gets the patch grid location.
        /// </summary>
        /// <returns>The location.</returns>
        public Vector2 GetLocation()
        {
            return location;
        }

        /// <summary>
        /// Gets the fire grid location.
        /// </summary>
        /// <returns>The location.</returns>
        public Vector2 GetFireGridLocation()
        {
            return fireLocation;
        }

        /// <summary>
        /// Gets the alphamap location.
        /// </summary>
        /// <returns>The location.</returns>
        public Vector2 GetAlphamapLocation()
        {
            return alphamapLoc;
        }

        /// <summary>
        /// Gets X coord.
        /// </summary>
        /// <returns>The x.</returns>
        public int X()
        {
            return (int)location.y;
        }

        /// <summary>
        /// Gets Y coord.
        /// </summary>
        /// <returns>The y.</returns>
        public int Y()
        {
            return (int)location.y;
        }

        /// <summary>
        /// Gets the UTM Location.
        /// </summary>
        /// <returns>The UTM Location.</returns>
        public Vector3 GetUTMLocation()
        {
            return utm;
        }
    }
}
