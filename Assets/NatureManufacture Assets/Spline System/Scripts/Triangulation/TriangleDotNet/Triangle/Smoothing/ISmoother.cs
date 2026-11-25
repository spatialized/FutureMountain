// -----------------------------------------------------------------------
// <copyright file="ISmoother.cs">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using TriangleNet.Meshing;

namespace TriangleNet.Smoothing
{
    /// <summary>
    ///     Interface for mesh smoothers.
    /// </summary>
    public interface ISmoother
    {
        void Smooth(IMesh mesh);
        void Smooth(IMesh mesh, int limit);
    }
}