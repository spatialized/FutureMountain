// -----------------------------------------------------------------------
// <copyright file="BadSubseg.cs" company="">
// Original Triangle code by Jonathan Richard Shewchuk, http://www.cs.cmu.edu/~quake/triangle.html
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using TriangleNet.Geometry;
using TriangleNet.Topology;

namespace TriangleNet.Meshing.Data
{
    /// <summary>
    ///     A queue used to store encroached subsegments.
    /// </summary>
    /// <remarks>
    ///     Each subsegment's vertices are stored so that we can check whether a
    ///     subsegment is still the same.
    /// </remarks>
    internal class BadSubseg
    {
        public Vertex org, dest; // Its two vertices.
        public Osub subseg; // An encroached subsegment.

        public override int GetHashCode()
        {
            return subseg.seg.hash;
        }

        public override string ToString()
        {
            return string.Format("B-SID {0}", subseg.seg.hash);
        }
    }
}