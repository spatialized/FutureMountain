// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using static Unity.Mathematics.math;

namespace NatureManufacture.RAM
{
    public static class RamMath
    {
        private const float Epsilon = 0.00001f;

        public struct MinimumDistanceVector
        {
            public float Distance;
            public Vector2 Point;
            public Vector2 Vertice;
        }

        public static Vector3 GaussianBlur(List<Vector3> data, int currentIndex, float strength, int blurSize, bool loop = false)
        {
            Vector3 blurredDirection = Vector3.zero;
            float totalWeight = 0f;

            for (int i = -blurSize; i <= blurSize; i++)
            {
                int neighborIndex = currentIndex + i;
                if (loop)
                {
                    if (neighborIndex < 0) neighborIndex = data.Count - 1;
                    if (neighborIndex >= data.Count) neighborIndex = 0;
                }
                else
                    neighborIndex = Mathf.Clamp(neighborIndex, 0, data.Count - 1);

                float weight = Mathf.Exp(-(i * i) / (2 * strength * strength));


                blurredDirection += data[neighborIndex] * weight;


                totalWeight += weight;
            }

          

            return blurredDirection / totalWeight;
        }
        
        public static float GaussianBlurFloat(List<float> values, int index, float strength, int size)
        {
            float sum = 0;
            float weightSum = 0;
            int count = values.Count-1;

            for (int i = -size; i <= size; i++)
            {
                int neighborIndex = index + i;
                neighborIndex = Mathf.Clamp(neighborIndex, 0, count);

                float weight = Mathf.Exp(-(i * i) / (2 * strength * strength));
                sum += values[neighborIndex] * weight;
                weightSum += weight;
            }

            return sum / weightSum;
        }

        public static List<MinimumDistanceVector> CalculateVectorBorderDistances(Vector3[] vertices, NmSpline nmSpline)
        {
            List<Vector2> vertices2d = GetVertices2d(vertices);
            List<Vector2> lines = GetLines2d(nmSpline.Points);

            int vertCount = vertices.Length;

            List<MinimumDistanceVector> minimumDistanceVectors = new();
            for (int i = 0; i < vertCount; i++)
            {
                minimumDistanceVectors.Add(MinDist(vertices2d, lines, nmSpline, i));
            }

            return minimumDistanceVectors;
        }

        public static MinimumDistanceVector MinDist(List<Vector2> vertices2d, List<Vector2> lines, NmSpline nmSpline, int i)
        {
            float minDist = float.MaxValue;
            Vector2 minPoint = vertices2d[i];

            for (int k = 0; k < nmSpline.Points.Count; k++)
            {
                int idOne = k;
                int idTwo = (k + 1) % lines.Count;
                float dist = DistancePointLine(vertices2d[i], lines[idOne], lines[idTwo], out Vector2 point);

                if (!(minDist > dist)) continue;

                minDist = dist;
                minPoint = point;
            }

            return new MinimumDistanceVector
            {
                Distance = minDist,
                Point = minPoint,
                Vertice = vertices2d[i]
            };
        }


        public static List<Vector2> GetVertices2d(Vector3[] vertices)
        {
            List<Vector2> vert2 = new();
            for (int i = 0; i < vertices.Length; i++) vert2.Add(new Vector2(vertices[i].x, vertices[i].z));
            return vert2;
        }

        public static List<Vector2> GetLines2d(List<NmSplinePoint> nmSplinePoints)
        {
            List<Vector2> lines = new();
            for (int i = 0; i < nmSplinePoints.Count; i++) lines.Add(new Vector2(nmSplinePoints[i].Position.x, nmSplinePoints[i].Position.z));
            return lines;
        }

        public static float DistancePointLine(Vector3 point, Vector3 lineStart, Vector3 lineEnd)
        {
            return Vector3.Distance(ProjectPointLine(point, lineStart, lineEnd), point);
        }

        public static float DistancePointLine(Vector3 point, Vector3 lineStart, Vector3 lineEnd, out Vector3 closestPoint)
        {
            closestPoint = ProjectPointLine(point, lineStart, lineEnd);
            return Vector3.Distance(closestPoint, point);
        }

        public static float DistancePointLine(Vector2 point, Vector2 lineStart, Vector2 lineEnd)
        {
            return Vector3.Distance(ProjectPointLine(point, lineStart, lineEnd), point);
        }

        public static float DistancePointLine(Vector2 point, Vector2 lineStart, Vector2 lineEnd, out Vector2 closestPoint)
        {
            closestPoint = ProjectPointLine(point, lineStart, lineEnd);
            return Vector3.Distance(closestPoint, point);
        }

        public static Vector3 ProjectPointLine(Vector3 point, Vector3 lineStart, Vector3 lineEnd)
        {
            Vector3 rhs = point - lineStart;
            Vector3 vector2 = lineEnd - lineStart;
            Vector3 lhs = vector2.normalized;
            float magnitude = vector2.magnitude;

            if (!(magnitude > 1E-06f)) return lineStart;

            float num2 = Mathf.Clamp(Vector3.Dot(lhs, rhs), 0f, magnitude);
            return lineStart + lhs * num2;
        }

        public static Vector3 CalculateNormal(Vector3 tangent, Vector3 up)
        {
            Vector3 binormal = Vector3.Cross(up, tangent);
            return Vector3.Cross(tangent, binormal).normalized;
        }

        public static bool AreLinesIntersecting(Vector3 l1P1, Vector3 l1P2, Vector3 l2P1, Vector3 l2P2,
            bool shouldIncludeEndPoints = true)
        {
            bool isIntersecting = false;

            float denominator = (l2P2.z - l2P1.z) * (l1P2.x - l1P1.x) - (l2P2.x - l2P1.x) * (l1P2.z - l1P1.z);

            //Make sure the denominator is > 0, if not the lines are parallel
            if (denominator != 0f)
            {
                float uA = ((l2P2.x - l2P1.x) * (l1P1.z - l2P1.z) - (l2P2.z - l2P1.z) * (l1P1.x - l2P1.x)) /
                           denominator;
                float uB = ((l1P2.x - l1P1.x) * (l1P1.z - l2P1.z) - (l1P2.z - l1P1.z) * (l1P1.x - l2P1.x)) /
                           denominator;

                //Are the line segments intersecting if the end points are the same
                if (shouldIncludeEndPoints)
                {
                    //Is intersecting if u_a and u_b are between 0 and 1 or exactly 0 or 1
                    if (uA >= 0f + Epsilon && uA <= 1f - Epsilon && uB >= 0f + Epsilon && uB <= 1f - Epsilon) isIntersecting = true;
                }
                else
                {
                    //Is intersecting if u_a and u_b are between 0 and 1
                    if (uA > 0f + Epsilon && uA < 1f - Epsilon && uB > 0f + Epsilon && uB < 1f - Epsilon) isIntersecting = true;
                }
            }

            return isIntersecting;
        }

        public static float Remap(float s, float a1, float a2, float b1, float b2)
        {
            return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
        }

        public static Vector3 GetCatmullRomPosition(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
        {
            Vector3 a = 2f * p1;
            Vector3 b = p2 - p0;
            Vector3 c = 2f * p0 - 5f * p1 + 4f * p2 - p3;
            Vector3 d = -p0 + 3f * p1 - 3f * p2 + p3;

            Vector3 pos = 0.5f * (a + b * t + c * (t * t) + d * (t * t * t));

            return pos;
        }

        public static Vector3 GetCatmullRomTangent(float t, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3)
        {
            return 0.5f * (-p0 + p2 + (2f * p0 - 5f * p1 + 4f * p2 - p3) * (2f * t) +
                           (-p0 + 3f * p1 - 3f * p2 + p3) * (3f * t * t));
        }

        public static float FindMaxCurveValue(AnimationCurve curve)
        {
            float maxTime = float.MinValue;
            float maxValue = float.MinValue;

            for (int i = 0; i < curve.keys.Length; i++)
            {
                if (!(curve.keys[i].time > maxTime)) continue;

                maxTime = curve.keys[i].time;
                maxValue = curve.keys[i].value;
            }

            return maxValue;
        }

        public static float CalculateDistanceBetweenBounds(Bounds bounds1, Bounds bounds2)
        {
            if (bounds1.Intersects(bounds2))
            {
                // If they intersect, the distance is 0
                return 0f;
            }

            // Find the point on bounds1 that is closest to bounds2
            Vector3 pointOnBounds1 = bounds1.ClosestPoint(bounds2.center);

            // Find the point on bounds2 that is closest to bounds1
            Vector3 pointOnBounds2 = bounds2.ClosestPoint(bounds1.center);

            // Calculate the distance between the two points


            float distance = Vector3.Distance(pointOnBounds1, pointOnBounds2);

            return distance;
        }
    }
}