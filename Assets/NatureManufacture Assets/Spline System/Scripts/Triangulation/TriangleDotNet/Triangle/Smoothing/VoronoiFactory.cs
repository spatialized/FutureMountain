using System;
using TriangleNet.Topology.DCEL;
using TriangleNet.Voronoi;

namespace TriangleNet.Smoothing
{
    /// <summary>
    ///     Factory which re-uses objects in the smoothing loop to enhance performance.
    /// </summary>
    /// <remarks>
    ///     See <see cref="SimpleSmoother" />.
    /// </remarks>
    internal class VoronoiFactory : IVoronoiFactory
    {
        private readonly ObjectPool<HalfEdge> edges = new();
        private readonly ObjectPool<Face> faces = new();
        private readonly ObjectPool<Vertex> vertices = new();

        public void Initialize(int vertexCount, int edgeCount, int faceCount)
        {
            vertices.Capacity = vertexCount;
            edges.Capacity = edgeCount;
            faces.Capacity = faceCount;

            for (int i = vertices.Count; i < vertexCount; i++) vertices.Put(new Vertex(0, 0));


            for (int i = edges.Count; i < edgeCount; i++) edges.Put(new HalfEdge(null));

            for (int i = faces.Count; i < faceCount; i++) faces.Put(new Face(null));

            Reset();
        }

        public void Reset()
        {
            vertices.Release();
            edges.Release();
            faces.Release();
        }

        public Vertex CreateVertex(double x, double y)
        {
            if (vertices.TryGet(out Vertex vertex))
            {
                vertex.x = x;
                vertex.y = y;
                vertex.leaving = null;

                return vertex;
            }

            vertex = new Vertex(x, y);

            vertices.Put(vertex);

            return vertex;
        }

        public HalfEdge CreateHalfEdge(Vertex origin, Face face)
        {
            if (edges.TryGet(out HalfEdge edge))
            {
                edge.origin = origin;
                edge.face = face;
                edge.next = null;
                edge.twin = null;

                if (face is { edge: null }) face.edge = edge;

                return edge;
            }

            edge = new HalfEdge(origin, face);

            edges.Put(edge);

            return edge;
        }

        public Face CreateFace(Geometry.Vertex vertex)
        {
            if (faces.TryGet(out Face face))
            {
                face.id = vertex.id;
                face.generator = vertex;
                face.edge = null;

                return face;
            }

            face = new Face(vertex);

            faces.Put(face);

            return face;
        }

        private class ObjectPool<T> where T : class
        {
            private int index;

            private T[] pool;

            public ObjectPool(int capacity = 3)
            {
                index = 0;
                Count = 0;

                pool = new T[capacity];
            }

            public int Count { get; private set; }


            public int Capacity
            {
                set => Resize(value);
            }

            public bool TryGet(out T obj)
            {
                if (index < Count)
                {
                    obj = pool[index++];

                    return true;
                }

                obj = null;

                return false;
            }

            public void Put(T obj)
            {
                int capacity = pool.Length;

                if (capacity <= Count) Resize(2 * capacity);

                pool[Count++] = obj;

                index++;
            }

            public void Release()
            {
                index = 0;
            }

            private void Resize(int size)
            {
                if (size > Count) Array.Resize(ref pool, size);
            }
        }
    }
}