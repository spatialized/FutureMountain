using TriangleNet.Topology.DCEL;

namespace TriangleNet.Voronoi
{
    public interface IVoronoiFactory
    {
        void Initialize(int vertexCount, int edgeCount, int faceCount);

        void Reset();

        Vertex CreateVertex(double x, double y);

        HalfEdge CreateHalfEdge(Vertex origin, Face face);

        Face CreateFace(Geometry.Vertex vertex);
    }
}