// -----------------------------------------------------------------------
// <copyright file="DebugWriter.cs" company="">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using System;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Text;
using TriangleNet.Geometry;
using TriangleNet.Topology;

namespace TriangleNet.IO
{
    /// <summary>
    ///     Writes a the current mesh into a text file.
    /// </summary>
    /// <remarks>
    ///     File format:
    ///     num_nodes
    ///     id_1 nx ny mark
    ///     ...
    ///     id_n nx ny mark
    ///     num_segs
    ///     id_1 p1 p2 mark
    ///     ...
    ///     id_n p1 p2 mark
    ///     num_tris
    ///     id_1 p1 p2 p3 n1 n2 n3
    ///     ...
    ///     id_n p1 p2 p3 n1 n2 n3
    /// </remarks>
    internal class DebugWriter
    {
        private static readonly NumberFormatInfo nfi = CultureInfo.InvariantCulture.NumberFormat;

        private int iteration;
        private string session;
        private StreamWriter stream;
        private string tmpFile;
        private int triangles;
        private int[] vertices;

        /// <summary>
        ///     Start a new session with given name.
        /// </summary>
        /// <param name="name">Name of the session (and output files).</param>
        public void Start(string session)
        {
            iteration = 0;
            this.session = session;

            if (stream != null) throw new Exception("A session is active. Finish before starting a new.");

            tmpFile = Path.GetTempFileName();
            stream = new StreamWriter(tmpFile);
        }

        /// <summary>
        ///     Write complete mesh to file.
        /// </summary>
        public void Write(Mesh mesh, bool skip = false)
        {
            WriteMesh(mesh, skip);

            triangles = mesh.Triangles.Count;
        }

        /// <summary>
        ///     Finish this session.
        /// </summary>
        public void Finish()
        {
            Finish(session + ".mshx");
        }

        private void Finish(string path)
        {
            if (stream != null)
            {
                stream.Flush();
                stream.Dispose();
                stream = null;

                string header = "#!N" + iteration + Environment.NewLine;

                using (var gzFile = new FileStream(path, FileMode.Create))
                {
                    using (var gzStream = new GZipStream(gzFile, CompressionMode.Compress, false))
                    {
                        byte[] bytes = Encoding.UTF8.GetBytes(header);
                        gzStream.Write(bytes, 0, bytes.Length);


                        bytes = File.ReadAllBytes(tmpFile);
                        gzStream.Write(bytes, 0, bytes.Length);
                    }
                }

                File.Delete(tmpFile);
            }
        }

        private void WriteGeometry(IPolygon geometry)
        {
            stream.WriteLine("#!G{0}", iteration++);
        }

        private void WriteMesh(Mesh mesh, bool skip)
        {
            // Mesh may have changed, but we choose to skip
            if (triangles == mesh.triangles.Count && skip) return;

            // Header line
            stream.WriteLine("#!M{0}", iteration++);

            Vertex p1, p2, p3;

            if (VerticesChanged(mesh))
            {
                HashVertices(mesh);

                // Number of vertices.
                stream.WriteLine("{0}", mesh.vertices.Count);

                foreach (Vertex v in mesh.vertices.Values)
                    // Vertex number, x and y coordinates and marker.
                    stream.WriteLine("{0} {1} {2} {3}", v.id, v.x.ToString(nfi), v.y.ToString(nfi), v.label);
            }
            else
            {
                stream.WriteLine("0");
            }

            // Number of segments.
            stream.WriteLine("{0}", mesh.subsegs.Count);

            var subseg = default(Osub);
            subseg.orient = 0;

            foreach (SubSegment item in mesh.subsegs.Values)
            {
                if (item.hash <= 0) continue;

                subseg.seg = item;

                p1 = subseg.Org();
                p2 = subseg.Dest();

                // Segment number, indices of its two endpoints, and marker.
                stream.WriteLine("{0} {1} {2} {3}", subseg.seg.hash, p1.id, p2.id, subseg.seg.boundary);
            }

            Otri tri = default, trisym = default;
            tri.orient = 0;

            int n1, n2, n3, h1, h2, h3;

            // Number of triangles.
            stream.WriteLine("{0}", mesh.triangles.Count);

            foreach (Triangle item in mesh.triangles)
            {
                tri.tri = item;

                p1 = tri.Org();
                p2 = tri.Dest();
                p3 = tri.Apex();

                h1 = p1 == null ? -1 : p1.id;
                h2 = p2 == null ? -1 : p2.id;
                h3 = p3 == null ? -1 : p3.id;

                // Triangle number, indices for three vertices.
                stream.Write("{0} {1} {2} {3}", tri.tri.hash, h1, h2, h3);

                tri.orient = 1;
                tri.Sym(ref trisym);
                n1 = trisym.tri.hash;

                tri.orient = 2;
                tri.Sym(ref trisym);
                n2 = trisym.tri.hash;

                tri.orient = 0;
                tri.Sym(ref trisym);
                n3 = trisym.tri.hash;

                // Neighboring triangle numbers.
                stream.WriteLine(" {0} {1} {2}", n1, n2, n3);
            }
        }

        private bool VerticesChanged(Mesh mesh)
        {
            if (vertices == null || mesh.Vertices.Count != vertices.Length) return true;

            int i = 0;
            foreach (Vertex v in mesh.Vertices)
                if (v.id != vertices[i++])
                    return true;

            return false;
        }

        private void HashVertices(Mesh mesh)
        {
            if (vertices == null || mesh.Vertices.Count != vertices.Length) vertices = new int[mesh.Vertices.Count];

            int i = 0;
            foreach (Vertex v in mesh.Vertices) vertices[i++] = v.id;
        }

        #region Singleton pattern

        // Explicit static constructor to tell C# compiler
        // not to mark type as beforefieldinit
        static DebugWriter()
        {
        }

        private DebugWriter()
        {
        }

        public static DebugWriter Session { get; } = new();

        #endregion
    }
}