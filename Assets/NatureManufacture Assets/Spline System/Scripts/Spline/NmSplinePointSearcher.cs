// /**
//  * Created by Pawel Homenko on  05/2023
//  */

using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class NmSplinePointSearcher
    {
        private readonly NmSpline _nmSpline;

        public NmSplinePointSearcher(NmSpline nmSpline)
        {
            _nmSpline = nmSpline;
        }

        private NmSplinePoint[] PointsArray { get; set; }

        private Dictionary<float, NmSplinePoint> Positions { get; } = new();


        public NmSplinePoint FindPositionByDistance(Vector3 position, float distance, int searchFrom, out int lastId)
        {
            //Find clossest point to the position in the spline after a search from point

            //Debug.Log($"----Search started---- {PointsArray.Length}");
            for (int i = searchFrom; i < PointsArray.Length - 1; i++)
            {
                Vector3 pointPosition = PointsArray[i].Position + _nmSpline.transform.position;
                Vector3 nextPointPosition = PointsArray[i + 1].Position + _nmSpline.transform.position;

                float firstDistance = Vector3.Distance(position, pointPosition);
                float secondDistance = Vector3.Distance(position, nextPointPosition);

                float distanceToLine = RamMath.DistancePointLine(position, pointPosition, nextPointPosition);

                //Debug.Log($"i {i} distance {distance} firstDistance {firstDistance} secondDistance {secondDistance} distanceToLine {distanceToLine}");


                if (!(Mathf.Abs(firstDistance - distance) < 0.0001f)
                    && !(Mathf.Abs(secondDistance - distance) < 0.0001f)
                    && (!(firstDistance <= distance)
                        || !(secondDistance >= distance))
                    && (!(firstDistance > distance)
                        || !(secondDistance > distance)
                        || !(distanceToLine < distance))) continue;
                //get lerp value

                (Vector3 _, float lerpValue) = FindPointOnSegment(pointPosition, nextPointPosition, position, distance);

                NmSplinePoint newSplinePoint = InterpolateSplinePointProperties(PointsArray[i], PointsArray[i + 1], lerpValue);
                newSplinePoint.Position += _nmSpline.transform.position;

                //if (_nmSpline.IsSnapping)
                //    SnapPoint(newSplinePoint);

                lastId = i;

                //Debug.Log($"----Position Found---- {newSplinePoint.Position}  searchFrom {searchFrom} distance calculated {Vector3.Distance(position, newSplinePoint.Position)}");
                return newSplinePoint;
            }


            lastId = -1;
            NmSplinePoint point = InterpolateSplinePointProperties(PointsArray[0], PointsArray[0], 0);
            point.Position += _nmSpline.transform.position;

            //Debug.Log($"Position not found {position} searchFrom {searchFrom}");
            return point;
        }

        private static (Vector3 point, float lerp) FindPointOnSegment(Vector3 firstPoint, Vector3 secondPoint, Vector3 position, float d)
        {
            Vector3 ab = secondPoint - firstPoint;
            Vector3 ac = firstPoint - position;

            float a = Vector3.Dot(ab, ab);
            float b = 2 * Vector3.Dot(ab, ac);
            float c = Vector3.Dot(ac, ac) - d * d;

            float discriminant = b * b - 4 * a * c;
            if (discriminant < 0)
            {
                return (firstPoint, 0);
            }

            // Solve quadratic equation for t
            float sqrtDiscriminant = Mathf.Sqrt(discriminant);
            float t1 = (-b + sqrtDiscriminant) / (2 * a);
            float t2 = (-b - sqrtDiscriminant) / (2 * a);

            float t;
            if (t1 is >= 0 and <= 1 && t2 is >= 0 and <= 1)
            {
                t = Mathf.Max(t1, t2);
            }
            else
                t = t1 is >= 0 and <= 1 ? t1 : (t2 is >= 0 and <= 1 ? t2 : 0);

            //Debug.Log($"t1 {t1} t2 {t2} t {t}");

            // Compute point D
            return (firstPoint + t * ab, t);
        }

        public NmSplinePoint FindPosition(float lengthToFind, int searchFrom, out int lastID)
        {
            if (PointsArray == null || PointsArray.Length == 0)
            {
                Debug.LogError("No points in array to search. Use GenerateArrayForDistanceSearch to generate array");
                lastID = 0;
                return new NmSplinePoint();
            }


            if (_nmSpline.IsLooping) lengthToFind %= _nmSpline.Length;


            if (Positions.TryGetValue(lengthToFind, out NmSplinePoint newSplinePoint))
            {
                //Debug.Log($"dict found");
                lastID = newSplinePoint.ID;
                return newSplinePoint;
            }

            if (!_nmSpline.IsLooping)
            {
                if (lengthToFind < 0)
                {
                    //calculate point based on first point and second point
                    NmSplinePoint firstPoint = _nmSpline.Points[0];
                    NmSplinePoint secondPoint = _nmSpline.Points[1];

                    float lerpValue = GetLerpValue(lengthToFind, secondPoint, firstPoint);
                    newSplinePoint = GetNewSplinePoint(lengthToFind, firstPoint, secondPoint, lerpValue, false);
                    lastID = 0;
                    return newSplinePoint;
                }

                if (lengthToFind > _nmSpline.Length)
                {
                    lengthToFind -= _nmSpline.Length;


                    //calculate point based on last point and second last point
                    NmSplinePoint lastPoint = _nmSpline.Points[^1];
                    NmSplinePoint secondLastPoint = _nmSpline.Points[^2];


                    float lerpValue = GetLastLerpValue(lengthToFind, secondLastPoint, lastPoint);

                    newSplinePoint = GetNewSplinePoint(lengthToFind, secondLastPoint, lastPoint, lerpValue, false);

                    lastID = PointsArray.Length - 2;
                    return newSplinePoint;
                }
            }

            newSplinePoint = new NmSplinePoint();


            int index = BinarySearch(PointsArray, lengthToFind, searchFrom);
            if (index != -1)
            {
                newSplinePoint = FindNewSplinePoint(lengthToFind, index);

                newSplinePoint.ID = index;
                lastID = index;
                return newSplinePoint;
            }


            switch (_nmSpline.IsLooping)
            {
                case false when lengthToFind <= 0:

                    newSplinePoint = FindNewSplinePoint(lengthToFind, 0);
                    lastID = -1;
                    return newSplinePoint;

                case false when lengthToFind >= _nmSpline.Length:

                    newSplinePoint = FindNewSplinePoint(lengthToFind, PointsArray.Length - 2);
                    lastID = -2;
                    return newSplinePoint;

                case true:

                    NmSplinePoint lastPoint = PointsArray[^1];
                    NmSplinePoint splinePoint = PointsArray[^2];
                    NmSplinePoint splinePointFirst = PointsArray[0];

                    float lerpValue = GetLastLerpValue(lengthToFind, splinePoint, lastPoint);

                    newSplinePoint = GetNewSplinePoint(lengthToFind, splinePointFirst, splinePoint, lerpValue);

                    AdditionalDataNewPosition(lengthToFind, lerpValue, 0, PointsArray.Length - 1);

                    lastID = -3;
                    return newSplinePoint;

                default:
                    lastID = -4;
                    return newSplinePoint;
            }
        }

        private void AdditionalDataNewPosition(float lengthToFind, float lerpValue, int firstIndex, int secondIndex)
        {
            foreach (NmSplineDataBase additionalData in _nmSpline.AdditionalDataList)
            {
                additionalData.AddSearchData(lengthToFind, lerpValue, firstIndex, secondIndex);
            }
        }

        private NmSplinePoint FindNewSplinePoint(float lengthToFind, int index)
        {
            NmSplinePoint splinePointFirst = PointsArray[index];
            NmSplinePoint splinePoint = PointsArray[index + 1];

            float lerpValue = GetLerpValue(lengthToFind, splinePoint, splinePointFirst);

            NmSplinePoint newSplinePoint = GetNewSplinePoint(lengthToFind, splinePointFirst, splinePoint, lerpValue);
            AdditionalDataNewPosition(lengthToFind, lerpValue, index, index + 1);


            return newSplinePoint;
        }

        private NmSplinePoint GetNewSplinePoint(float lengthToFind, NmSplinePoint splinePointFirst, NmSplinePoint splinePoint, float lerpValue, bool addToList = true)
        {
            NmSplinePoint newSplinePoint = InterpolateSplinePointProperties(splinePointFirst, splinePoint, lerpValue);
            newSplinePoint.Position += _nmSpline.transform.position;

            if (_nmSpline.IsSnapping)
                SnapPoint(newSplinePoint);

            if (addToList)
                Positions.Add(lengthToFind, newSplinePoint);
            return newSplinePoint;
        }

        private static int BinarySearch(NmSplinePoint[] pointsArray, float lengthToFind, int searchFrom = 0)
        {
            int low = searchFrom;
            int high = pointsArray.Length - 1;
            while (low <= high)
            {
                int mid = low + (high - low) / 2;
                // Debug.Log($" mid {mid} low {low} high {high} ");
                if (mid < pointsArray.Length - 1 && pointsArray[mid].Distance <= lengthToFind && pointsArray[mid + 1].Distance > lengthToFind)
                    //Debug.Log($"Found {mid}");
                    return mid;


                //if (mid < pointsArray.Length - 1)
                //    Debug.Log($"lengthToFind {lengthToFind} pointsArray[mid].Distance {pointsArray[mid].Distance} pointsArray[mid + 1].Distance {pointsArray[mid + 1].Distance}");

                if (pointsArray[mid].Distance > lengthToFind)
                    high = mid - 1;
                else
                    low = mid + 1;
            }

            // return -1 or any appropriate value when not found
            return -1;
        }

        private static void SnapPoint(NmSplinePoint newSplinePoint)
        {
            if (Physics.Raycast(newSplinePoint.Position + Vector3.up * 1000, Vector3.down, out RaycastHit raycastHit)) newSplinePoint.Position = raycastHit.point;
        }

        private float GetLastLerpValue(float lengthToFind, NmSplinePoint splinePoint, NmSplinePoint lastPoint)
        {
            float distance = _nmSpline.Length - splinePoint.Distance;
            float distanceBasePoint = lastPoint.Distance + lengthToFind - splinePoint.Distance;
            float lerpValue = distanceBasePoint / distance;
            return lerpValue;
        }

        private static float GetLerpValue(float lengthToFind, NmSplinePoint splinePoint, NmSplinePoint splinePointFirst)
        {
            float distance = splinePoint.Distance - splinePointFirst.Distance;
            float distanceBasePoint = lengthToFind - splinePointFirst.Distance;
            float lerpValue = distanceBasePoint / distance;
            return lerpValue;
        }

        private static NmSplinePoint InterpolateSplinePointProperties(NmSplinePoint pointFirst, NmSplinePoint pointSecond, float lerpValue)
        {
            var newSplinePoint = new NmSplinePoint
            {
                Position = Vector3.LerpUnclamped(pointFirst.Position, pointSecond.Position, lerpValue),
                Width = Mathf.LerpUnclamped(pointFirst.Width, pointSecond.Width, lerpValue),
                Tangent = Vector3.LerpUnclamped(pointFirst.Tangent, pointSecond.Tangent, lerpValue),
                Normal = Vector3.LerpUnclamped(pointFirst.Normal, pointSecond.Normal, lerpValue),
                Binormal = Vector3.LerpUnclamped(pointFirst.Binormal, pointSecond.Binormal, lerpValue),
                Orientation = Quaternion.SlerpUnclamped(pointFirst.Orientation, pointSecond.Orientation, lerpValue),
                Rotation = Quaternion.SlerpUnclamped(pointFirst.Rotation, pointSecond.Rotation, lerpValue)
            };

            return newSplinePoint;
        }

        public void ClearPositions()
        {
            Positions.Clear();
        }


        public void GenerateArrayForDistanceSearch(List<NmSplinePoint> points)
        {
            PointsArray = points.ToArray();
        }
    }
}