// -----------------------------------------------------------------------
// <copyright file="TriangleSampler.cs">
// Original Triangle code by Jonathan Richard Shewchuk, http://www.cs.cmu.edu/~quake/triangle.html
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using System.Collections;
using System.Collections.Generic;
using TriangleNet.Topology;

namespace TriangleNet
{
    /// <summary>
    ///     Used for triangle sampling in the <see cref="TriangleLocator" /> class.
    /// </summary>
    internal class TriangleSampler : IEnumerable<Triangle>
    {
        // Empirically chosen factor.
        private const int samplefactor = 11;

        private readonly Mesh mesh;

        // Number of random samples for point location (at least 1).
        private int samples = 1;

        // Number of triangles in mesh.
        private int triangleCount;

        public TriangleSampler(Mesh mesh)
        {
            this.mesh = mesh;
        }

        public IEnumerator<Triangle> GetEnumerator()
        {
            return mesh.triangles.Sample(samples).GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        /// <summary>
        ///     Reset the sampler.
        /// </summary>
        public void Reset()
        {
            samples = 1;
            triangleCount = 0;
        }

        /// <summary>
        ///     Update sampling parameters if mesh changed.
        /// </summary>
        public void Update()
        {
            int count = mesh.triangles.Count;

            if (triangleCount != count)
            {
                triangleCount = count;

                // The number of random samples taken is proportional to the cube root
                // of the number of triangles in the mesh.  The next bit of code assumes
                // that the number of triangles increases monotonically (or at least
                // doesn't decrease enough to matter).
                while (samplefactor * samples * samples * samples < count) samples++;
            }
        }
    }
}