// /**
//  * Created by Pawel Homenko on  10/2023
//  */

using System.Collections.Generic;
using TriangleNet.Geometry;
using TriangleNet.Topology;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class MeshTriangulationToVertices
    {
        /*    private Dictionary<int, int> _vertsDictionary = new Dictionary<int, int>();

            private int GetNewVertex(Vertex vertex, List<Vector3> verts)
            {
                if (_vertsDictionary.TryGetValue(vertex.id, out int newVertex))
                    return newVertex;

                int id = verts.Count;
                _vertsDictionary.Add(vertex.id, id);
                verts.Add(new Vector3((float)vertex.x, (float)vertex.z, (float)vertex.y));
                return id;
            }
    */

        public static void GenerateVerticesIndices(TriangleNet.Mesh mesh, List<int> indices, List<Vector3> vertices)
        {
            indices.Clear();
            vertices.Clear();
            //_vertsDictionary.Clear();

            for (int i = 0; i < mesh.vertices.Count; i++)
            {
                Vertex vertex = mesh.vertices[i];
                vertices.Add(new Vector3((float)vertex.x, (float)vertex.z, (float)vertex.y));
            }

            foreach (Triangle triangle in mesh.triangles)
            {
                indices.Add(triangle.vertices[2].id);
                indices.Add(triangle.vertices[1].id);
                indices.Add(triangle.vertices[0].id);
            }

/*


            foreach (Triangle triangle in mesh.triangles)
            {
                Vertex vertex = mesh.vertices[triangle.vertices[2].id];

                indices.Add(GetNewVertex(vertex, vertices));

                vertex = mesh.vertices[triangle.vertices[1].id];
                indices.Add(GetNewVertex(vertex, vertices));


                vertex = mesh.vertices[triangle.vertices[0].id];
                indices.Add(GetNewVertex(vertex, vertices));
            }
            */
        }
    }
}