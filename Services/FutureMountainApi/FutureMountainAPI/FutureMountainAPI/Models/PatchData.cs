using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Numerics;

namespace FutureMountainAPI.Models
{
    public class PatchDataRecord
    {
        /// <summary>
        /// Patch point collection.
        /// </summary>
        [Serializable]
        public class PatchPointCollection
        {
            [Key]
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
            [Key]
            [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
            public int id { get; set; } = 0;

            public int patchID { get; set; }
            public SERI_Vector2 location { get; set; } // Patch grid location (col, row in data file)
            public SERI_Vector2 fireLocation { get; set; } // Fire grid location
            public SERI_Vector2 alphamapLoc { get; set; } // Alphamap grid location
            public SERI_Vector3 utm { get; set; } // UTM location

            /// <summary>
            /// Initializes a new instance of the <see cref="T:LandscapeController.PatchPoint"/> class.
            /// </summary>
            /// <param name="newPatchID">New patch identifier.</param>
            /// <param name="newLocation">New location.</param>
            /// <param name="newUTM">New utm.</param>
            //public PatchPoint(int newPatchID, SERI_Vector2 newLocation, SERI_Vector2 newFireLocation, SERI_Vector2 newAlphamapLocation, SERI_Vector3 newUTM)
            //{
            //    patchID = newPatchID;
            //    location = newLocation;
            //    fireLocation = newFireLocation;
            //    alphamapLoc = newAlphamapLocation;
            //    utm = newUTM;
            //}

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
            public SERI_Vector2 GetLocation()
            {
                return location;
            }

            /// <summary>
            /// Gets the fire grid location.
            /// </summary>
            /// <returns>The location.</returns>
            public SERI_Vector2 GetFireGridLocation()
            {
                return fireLocation;
            }

            /// <summary>
            /// Gets the alphamap location.
            /// </summary>
            /// <returns>The location.</returns>
            public SERI_Vector2 GetAlphamapLocation()
            {
                return alphamapLoc;
            }

            /// <summary>
            /// Gets X coord.
            /// </summary>
            /// <returns>The x.</returns>
            public int X()
            {
                return (int)location.X;
            }

            /// <summary>
            /// Gets Y coord.
            /// </summary>
            /// <returns>The y.</returns>
            public int Y()
            {
                return (int)location.Y;
            }

            /// <summary>
            /// Gets the UTM Location.
            /// </summary>
            /// <returns>The UTM Location.</returns>
            public SERI_Vector3 GetUTMLocation()
            {
                return utm;
            }
        }

        // https://learn.microsoft.com/en-us/ef/core/modeling/backing-field
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        public int patchID { get; set; }
        public string _data { get; set; } //Contains PatchPointCollection data;

        [NotMapped]
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
}
