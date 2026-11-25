// -----------------------------------------------------------------------
// <copyright file="Polygon.cs" company="">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------


using System;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

namespace TriangleNet.Geometry
{
    using Random = Random;

    /// <summary>
    ///     A polygon represented as a planar straight line graph.
    /// </summary>
    public class Polygon : IPolygon
    {
        private const int RandomSeed = 110503;


        /// <summary>
        ///     Initializes a new instance of the <see cref="Polygon" /> class.
        /// </summary>
        public Polygon()
            : this(3)
        {
        }

        /// <summary>
        ///     Initializes a new instance of the <see cref="Polygon" /> class.
        /// </summary>
        /// <param name="capacity">The default capacity for the points list.</param>
        /// <param name="markers">Use point and segment markers.</param>
        public Polygon(int capacity = 3, bool markers = false)
        {
            // Debug.Log(_random);
            Random.InitState(RandomSeed);

            Points = new List<Vertex>(capacity);
            Holes = new List<Point>();
            Regions = new List<RegionPointer>();

            Segments = new List<ISegment>();

            HasPointMarkers = markers;
            HasSegmentMarkers = markers;
        }

        /// <inheritdoc />
        public int Count => Points.Count;

        /// <inheritdoc />
        public List<Vertex> Points { get; }

        /// <inheritdoc />
        public List<Point> Holes { get; }

        /// <inheritdoc />
        public List<RegionPointer> Regions { get; }

        /// <inheritdoc />
        public List<ISegment> Segments { get; }

        /// <inheritdoc />
        public bool HasPointMarkers { get; set; }

        /// <inheritdoc />
        public bool HasSegmentMarkers { get; set; }

        [Obsolete("Use polygon.Add(contour) method instead.")]
        public void AddContour(IEnumerable<Vertex> points, int marker = 0,
            bool hole = false, bool convex = false)
        {
            Add(new Contour(points, marker, convex), hole);
        }

        [Obsolete("Use polygon.Add(contour) method instead.")]
        public void AddContour(IEnumerable<Vertex> points, int marker, Point hole)
        {
            Add(new Contour(points, marker), hole);
        }

        /// <inheritdoc />
        public Rectangle Bounds()
        {
            // NOTE: ported for unity
            List<Point> points = Points.ConvertAll(x => (Point)x);


            var bounds = new Rectangle();
            bounds.Expand(points);

            return bounds;
        }

        /// <summary>
        ///     Add a vertex to the polygon.
        /// </summary>
        /// <param name="vertex">The vertex to insert.</param>
        public void Add(Vertex vertex)
        {
            Points.Add(vertex);
        }

        /// <summary>
        ///     Add a segment to the polygon.
        /// </summary>
        /// <param name="segment">The segment to insert.</param>
        /// <param name="insert">If true, both endpoints will be added to the points list.</param>
        public void Add(ISegment segment, bool insert = false)
        {
            Segments.Add(segment);

            if (insert)
            {
                Points.Add(segment.GetVertex(0));
                Points.Add(segment.GetVertex(1));
            }
        }

        /// <summary>
        ///     Add a segment to the polygon.
        /// </summary>
        /// <param name="segment">The segment to insert.</param>
        /// <param name="index">The index of the segment endpoint to add to the points list (must be 0 or 1).</param>
        public void Add(ISegment segment, int index)
        {
            Segments.Add(segment);

            Points.Add(segment.GetVertex(index));
        }

        /// <summary>
        ///     Add a contour to the polygon.
        /// </summary>
        /// <param name="contour">The contour to insert.</param>
        /// <param name="hole">Treat contour as a hole.</param>
        public void Add(Contour contour, bool hole = false)
        {
            if (hole)
            {
                Add(contour, contour.FindInteriorPoint());
            }
            else
            {
                Points.AddRange(contour.Points);
                Segments.AddRange(contour.GetSegments());
            }
        }

        /// <summary>
        ///     Add a contour to the polygon.
        /// </summary>
        /// <param name="contour">The contour to insert.</param>
        /// <param name="hole">Point inside the contour, making it a hole.</param>
        public void Add(Contour contour, Point hole)
        {
            Points.AddRange(contour.Points);
            Segments.AddRange(contour.GetSegments());

            Holes.Add(hole);
        }


        public static int GetRandomNext(int minValue, int maxValue)
        {
            //NMToDo: check if this is correct

            //int next = Random.Range(minValue, maxValue);
            //get midle value between min and max
            int next = (minValue + maxValue) / 2;


            return next;
        }
        public static int GetRandomNextFull(int minValue, int maxValue)
        {
            //NMToDo: check if this is correct

            int next = Random.Range(minValue, maxValue);
            //get midle value between min and max
            //int next = (minValue + maxValue) / 2;


            return next;
        }
    }
}