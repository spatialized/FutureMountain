using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class RamVertexColors
    {
        public struct LakeBlend
        {
            public float Blend;
            public bool IsLake;
        }

        private RamSpline ramSpline;


        public RamVertexColors(RamSpline ramSpline)
        {
            this.ramSpline = ramSpline;
        }

        public void ManageVertexColor(Color[] colors, Vector3[] normals, int index)
        {
            
      
            if (ramSpline.VertexPainterData.OverridenColors) return;


            Vector3 normal = normals[index];
            float red = ramSpline.BaseProfile.redColorCurve.Evaluate(normal.y);
            float green = ramSpline.BaseProfile.greenColorCurve.Evaluate(normal.y);
            float blue = ramSpline.BaseProfile.blueColorCurve.Evaluate(normal.y);
            float alpha = ramSpline.BaseProfile.alphaColorCurve.Evaluate(normal.y);

           // Debug.Log($"normal.y: {normal.y} red: {red} green: {green} blue: {blue} alpha: {alpha}");
            colors[index] = new Color(red, green, blue, alpha);
        }


        public static Color[] CheckColors(Color[] colors, int vertCount)
        {
            if (colors != null && colors.Length == vertCount) return colors;

            colors = new Color[vertCount];

            for (int i = 0; i < colors.Length; i++) colors[i] = Color.black;

            return colors;
        }

        public List<LakeBlend> GetLakesBlend(MeshRenderer meshRenderer)
        {
            //find all lakes that bounds collide with ramspline
            LakePolygon[] lakes = Object.FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);


            List<LakeBlend> blends = new();

            //generate base list for each spline point
            for (int i = 0; i < ramSpline.NmSpline.Points.Count; i++)
            {
                blends.Add(new LakeBlend());
            }


            var ray = new Ray
            {
                direction = Vector3.down
            };


            ramSpline.VertexPainterData.OverridenColors = true;

            foreach (LakePolygon lake in lakes)
            {
                if (!meshRenderer.bounds.Intersects(lake.MeshRenderer.bounds)) continue;

                var meshCollider = lake.gameObject.AddComponent<MeshCollider>();

                for (int i = 0; i < ramSpline.NmSpline.Points.Count; i++)
                {
                    NmSplinePoint point = ramSpline.NmSpline.Points[i];
                    Vector3 position = point.Position + ramSpline.transform.position;
                    ray.origin = position + Vector3.up * 1000;

                    //distance = Vector3.Distance(vertices[i], meshCollider.ClosestPoint(vertices[i]));

                    bool hitted = meshCollider.Raycast(ray, out RaycastHit hit, 2000);

                    if (!hitted) continue;


                    float yDistance = position.y - hit.point.y;
                    float blend = Mathf.Clamp01(yDistance);

                    SetBlend(blends, i, blend);
                }

                Object.DestroyImmediate(meshCollider);
            }

            return blends;
        }

        private static void SetBlend(List<LakeBlend> blends, int i, float blend)
        {
            LakeBlend lakeBlend = blends[i];
            lakeBlend.Blend = blend;
            lakeBlend.IsLake = true;
            blends[i] = lakeBlend;
        }

        public static void GenerateBlendWithLakePolygon(RamSpline ramSpline)
        {
            //find all lakes that bounds collide with ramspline
            LakePolygon[] lakes = Object.FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);
            var ramMeshRenderer = ramSpline.GetComponent<MeshRenderer>();

            Mesh mesh = ramSpline.meshFilter.sharedMesh;

            Vector3[] vertices = mesh.vertices;

            Color[] colors = mesh.colors;
            //List<Vector4> uv4 = new();
            /*mesh.GetUVs(4, uv4);

            if (uv4.Count == 0)
            {
                for (int i = 0; i < vertices.Length; i++)
                {
                    uv4.Add(Vector4.zero);
                }
            }*/


            float vertLength = vertices.Length;
            var ray = new Ray
            {
                direction = Vector3.down
            };

            ramSpline.VertexPainterData.OverridenColors = true;

            foreach (LakePolygon lake in lakes)
            {
                if (!ramMeshRenderer.bounds.Intersects(lake.GetComponent<MeshRenderer>().bounds)) continue;


                Debug.Log($"Lake bounds intersects with ram spline bounds {lake.name}");

                var meshCollider = lake.gameObject.AddComponent<MeshCollider>();

                for (int i = 0; i < vertLength; i++)
                {
                    ray.origin = vertices[i] + Vector3.up * 1000;

                    //distance = Vector3.Distance(vertices[i], meshCollider.ClosestPoint(vertices[i]));

                    bool hited = meshCollider.Raycast(ray, out RaycastHit hit, 2000);

                    if (!hited) continue;


                    float yDistance = vertices[i].y - hit.point.y;


                    colors[i].a = Mathf.Clamp01(yDistance);
                    //colors[i].r = Mathf.Clamp01(yDistance);

                    // uv4[i] = new Vector4(-yDistance, 0, 0, 0);
                }

                Object.DestroyImmediate(meshCollider);
            }

            mesh.SetColors(colors);
            // mesh.SetUVs(4, uv4);
        }
    }
}