// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace NatureManufacture.RAM
{
    public class NmSpline : MonoBehaviour
    {
        public enum SplineSide
        {
            Center,
            Up,
            Down
        }


        public Transform Transform => transform;

        public bool IsSnapping
        {
            get => snapToTerrain == 1;
            set => snapToTerrain = value ? 1 : 0;
        }

        public float SnapToTerrain
        {
            get => snapToTerrain;
            set => snapToTerrain = value;
        }

        public float Width
        {
            get => width;
            set => width = value;
        }

        public bool IsLooping
        {
            get => isLooping;
            set => isLooping = value;
        }

        public List<RamControlPoint> MainControlPoints
        {
            get => mainControlPoints ??= new List<RamControlPoint>();
            set => mainControlPoints = value;
        }

        public List<NmSplinePoint> ControlPointsParameters
        {
            get => controlPointsParameters ??= new List<NmSplinePoint>();
            set => controlPointsParameters = value;
        }

        public List<Vector3> ControlPointsPositionUp
        {
            get => controlPointsPositionUp ??= new List<Vector3>();
            set => controlPointsPositionUp = value;
        }

        public List<Vector3> ControlPointsPositionDown
        {
            get => controlPointsPositionDown ??= new List<Vector3>();
            set => controlPointsPositionDown = value;
        }

        public List<NmSplinePoint> Points
        {
            get => points ??= new List<NmSplinePoint>();
            set => points = value;
        }

        public List<NmSplinePoint> PointsUp
        {
            get => pointsUp ??= new List<NmSplinePoint>();
            set => pointsUp = value;
        }

        public List<NmSplinePoint> PointsDown
        {
            get => pointsDown ??= new List<NmSplinePoint>();
            set => pointsDown = value;
        }


        public bool UseRotation
        {
            get => useRotation;
            set => useRotation = value;
        }

        public bool UseWidth
        {
            get => useWidth;
            set => useWidth = value;
        }

        public bool UseSplinePointDensity
        {
            get => useSplinePointDensity;
            set => useSplinePointDensity = value;
        }

        public bool UseSplineWidthDensity
        {
            get => useSplineWidthDensity;
            set => useSplineWidthDensity = value;
        }

        public bool UseMeshCurve
        {
            get => useMeshCurve;
            set => useMeshCurve = value;
        }

        public bool UsePointSnap
        {
            get => usePointSnap;
            set => usePointSnap = value;
        }

        public float Length
        {
            get => length;
            set => length = value;
        }

        public int SelectedPosition
        {
            get => selectedPosition;
            set => selectedPosition = value;
        }

        public List<NmSplineDataBase> AdditionalDataList
        {
            get => additionalDataList;
            set => additionalDataList = value;
        }

        [SerializeField] private List<RamControlPoint> mainControlPoints = new();
        [SerializeField] private List<NmSplinePoint> controlPointsParameters = new();
        [SerializeField] private List<NmSplineDataBase> additionalDataList = new();

        [SerializeField] private List<Vector3> controlPointsPositionUp = new();
        [SerializeField] private List<Vector3> controlPointsPositionDown = new();

        [SerializeField] private List<NmSplinePoint> points = new();
        [SerializeField] private List<NmSplinePoint> pointsUp = new();
        [SerializeField] private List<NmSplinePoint> pointsDown = new();


        [SerializeField] private float snapToTerrain;
        [SerializeField] private float width = 1;
        [SerializeField] private bool isLooping;
        [SerializeField] private float length;

        [SerializeField] private bool useRotation = true;
        [SerializeField] private bool useWidth = true;
        [SerializeField] private bool useSplinePointDensity = true;
        [SerializeField] private bool useSplineWidthDensity = true;
        [SerializeField] private bool useMeshCurve = true;
        [SerializeField] private bool usePointSnap = true;

        [SerializeField] private bool dataSet;

        [SerializeField] private int selectedPosition;
        private NmSplinePointSearcher _nmSplinePointSearcher;


        public UnityEvent NmSplineChanged { get; set; }

        public NmSplinePointSearcher NmSplinePointSearcher => _nmSplinePointSearcher ??= new NmSplinePointSearcher(this);


        public void SetData(float snapToTerrainNew = 0, float widthNew = 1, bool isLoopingNew = false, bool useRotationNew = true, bool useWidthNew = true, bool useSplinePointDensityNew = true,
            bool useSplineWidthDensityNew = true,
            bool useMeshCurveNew = true,
            bool usePointSnapNew = true, bool changeLastData = false)
        {
            if (dataSet && !changeLastData)
                return;

            dataSet = true;
            snapToTerrain = snapToTerrainNew;
            width = widthNew;
            isLooping = isLoopingNew;
            useRotation = useRotationNew;
            useWidth = useWidthNew;
            useSplinePointDensity = useSplinePointDensityNew;
            useSplineWidthDensity = useSplineWidthDensityNew;
            useMeshCurve = useMeshCurveNew;
            usePointSnap = usePointSnapNew;
        }

        public void SetData(NmSpline oldSpline, bool changeLastData = false)
        {
            if (dataSet && !changeLastData)
                return;

            dataSet = true;
            snapToTerrain = oldSpline.snapToTerrain;
            width = oldSpline.width;
            isLooping = oldSpline.isLooping;
            useRotation = oldSpline.useRotation;
            useWidth = oldSpline.useWidth;
            useSplinePointDensity = oldSpline.useSplinePointDensity;
            useSplineWidthDensity = oldSpline.useSplineWidthDensity;
            useMeshCurve = oldSpline.useMeshCurve;
            usePointSnap = oldSpline.usePointSnap;

            foreach (RamControlPoint mainControlPoint in oldSpline.MainControlPoints)
            {
                mainControlPoints.Add(new RamControlPoint(mainControlPoint));
            }

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.GenerateMainControlPointsData(MainControlPoints.Count);
            }
        }

        public bool PrepareSpline()
        {
            GetAdditionalDataList();
            CheckForNanRotation();

            ClearDataLists();

            return true;
        }

        private void GetAdditionalDataList()
        {
            GetComponents<NmSplineDataBase>(AdditionalDataList);

            foreach (NmSplineDataBase additionalDataBase in AdditionalDataList)
            {
                additionalDataBase.GenerateMainControlPointsData(MainControlPoints.Count);
            }
        }

        #region PointManagement

        /// <summary>
        ///     Add point at end of spline
        /// </summary>
        /// <param name="position">New point position</param>
        public void AddPoint(Vector4 position)
        {
            if (position.w == 0 || Width > 0)
            {
                position.w = MainControlPoints.Count > 0 ? MainControlPoints[^1].position.w : Width;
            }

            MainControlPoints.Add(new RamControlPoint(position, Quaternion.identity, SnapToTerrain, new AnimationCurve(MeshCurveKeyFrames.GetPointMeshCurveKeyFrames(MainControlPoints.Count - 1, MainControlPoints))));
            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.AddPointAtEnd();
            }
        }

        /// <summary>
        ///     Add point at end of spline
        /// </summary>
        /// <param name="position">New point position</param>
        /// <param name="pointSnapToTerrain">Snap points to terrain</param>
        /// <param name="pointWidth">Data to lerp in points, stored in w value</param>
        /// <param name="meshCurve"></param>
        public void AddPoint(Vector4 position, bool pointSnapToTerrain, float pointWidth = 0, AnimationCurve meshCurve = null)
        {
            float snap = Mathf.Clamp01(pointSnapToTerrain ? 1 : 0 + MainControlPoints.Count > 0 ? MainControlPoints[^1].snap : 0);
            if (position.w == 0)
            {
                position.w = MainControlPoints.Count > 0 ? MainControlPoints[^1].position.w : (pointWidth > 0 ? pointWidth : 4);
            }


            MainControlPoints.Add(new RamControlPoint(position, Quaternion.identity, snap, meshCurve ?? new AnimationCurve(MeshCurveKeyFrames.GetPointMeshCurveKeyFrames(MainControlPoints.Count - 1, MainControlPoints))));

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.AddPointAtEnd();
            }
        }

        /// <summary>
        ///     Add point at end of spline
        /// </summary>
        public void AddPointAtEnd()
        {
            AddPointAtEnd(Width);
        }

        /// <summary>
        ///     Add point at end of spline
        /// </summary>
        public void AddPointAtEnd(float pointWidth)
        {
            int i = MainControlPoints.Count - 1;
            Vector4 position = Vector3.zero;
            position.w = pointWidth;
            float snap = 0;


            if (MainControlPoints.Count > 0)
            {
                position = MainControlPoints[i].position;
                snap = MainControlPoints[i].snap;
            }

            if (i < MainControlPoints.Count - 1 && MainControlPoints.Count > i + 1)
            {
                Vector4 positionSecond = MainControlPoints[i + 1].position;
                if (Vector3.Distance(positionSecond, position) > 0)
                    position = (position + positionSecond) * 0.5f;
                else
                    position.x += 1;
            }
            else if (MainControlPoints.Count > 1 && i == MainControlPoints.Count - 1)
            {
                Vector4 positionSecond = MainControlPoints[i - 1].position;
                if (Vector3.Distance(positionSecond, position) > 0)
                    position = position + (position - positionSecond);
                else
                    position.x += 1;
            }
            else if (MainControlPoints.Count > 0)
            {
                position.x += 1;
            }


            MainControlPoints.Add(new RamControlPoint(position, Quaternion.identity, snap, new AnimationCurve(MeshCurveKeyFrames.GetPointMeshCurveKeyFrames(MainControlPoints.Count - 1, MainControlPoints))));

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.AddPointAtEnd();
            }
        }


        /// <summary>
        ///     Add point in the middle of the spline
        /// </summary>
        /// <param name="i">Point id</param>
        public void AddPointAfter(int i)
        {
            AddPointAfter(i, IsSnapping);
        }

        /// <summary>
        ///     Add point in the middle of the spline
        /// </summary>
        /// <param name="i">Point id</param>
        /// <param name="pointSnapToTerrain">Snap to terrain</param>
        public void AddPointAfter(int i, bool pointSnapToTerrain)
        {
            Vector4 position = i == -1 ? MainControlPoints[0].position : MainControlPoints[i].position;
            float snap = pointSnapToTerrain ? 1 : 0;

            Quaternion rotation = Quaternion.identity;


            if (i < MainControlPoints.Count - 1 && MainControlPoints.Count > i + 1)
            {
                rotation = Quaternion.Slerp(MainControlPoints[i].rotation, MainControlPoints[i + 1].rotation, 0.5f);
                snap = MainControlPoints[i + 1].snap > snap ? MainControlPoints[i + 1].snap : snap;
                Vector4 positionSecond = MainControlPoints[i + 1].position;
                if (Vector3.Distance(positionSecond, position) > 0)
                    position = (position + positionSecond) * 0.5f;
                else
                    position.x += 1;
            }
            else if (MainControlPoints.Count > 1 && i == MainControlPoints.Count - 1)
            {
                rotation = Quaternion.Slerp(MainControlPoints[i - 1].rotation, MainControlPoints[i].rotation, 0.5f);
                snap = MainControlPoints[i - 1].snap > snap ? MainControlPoints[i - 1].snap : snap;
                Vector4 positionSecond = MainControlPoints[i - 1].position;
                if (Vector3.Distance(positionSecond, position) > 0)
                    position = position + (position - positionSecond);
                else
                    position.x += 1;
            }
            else
            {
                snap = MainControlPoints[i].snap > snap ? MainControlPoints[i].snap : snap;
                position.x += 1;
            }


            MainControlPoints.Insert(i + 1, new RamControlPoint(position, rotation, snap, new AnimationCurve(MeshCurveKeyFrames.GetPointMeshCurveKeyFrames(i, MainControlPoints))));

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.AddPointAfter(i);
            }
        }

        /// <summary>
        ///     Changes point position, if new position doesn't have width old width will be taken
        /// </summary>
        /// <param name="i">Point id</param>
        /// <param name="position">New position</param>
        public void ChangePointPosition(int i, Vector4 position)
        {
            Vector4 oldPos = MainControlPoints[i].position;

            if (position.w == 0)
                position.w = oldPos.w;

            MainControlPoints[i].position = position;
        }

        /// <summary>
        ///     Removes all points in spline
        /// </summary>
        public void RemoveAllPoints()
        {
            ClearDataLists();
            MainControlPoints.Clear();
            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.RemoveAllData();
            }
        }

        /// <summary>
        ///    Removes all points in spline
        /// </summary>
        public void Clear()
        {
            RemoveAllPoints();
        }


        /// <summary>
        ///     Removes point in spline
        /// </summary>
        /// <param name="i"></param>
        public void RemovePoint(int i)
        {
            if (i >= MainControlPoints.Count) return;

            MainControlPoints.RemoveAt(i);

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.RemoveData(i);
            }
        }

        /// <summary>
        ///     Removes points from point id forward
        /// </summary>
        /// <param name="fromID">Point id</param>
        public void RemovePoints(int fromID = -1)
        {
            if (MainControlPoints.Count == 0)
                return;

            int pointsCount = MainControlPoints.Count - 1;
            for (int i = pointsCount; i > fromID; i--) RemovePoint(i);

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.RemoveDataFrom(fromID);
            }
        }

        /// <summary>
        /// Removes Last Control Point
        /// </summary>
        public void RemoveLastPoint()
        {
            if (MainControlPoints.Count == 0)
                return;


            MainControlPoints.RemoveAt(MainControlPoints.Count - 1);

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.RemoveLastData();
            }
        }

        /// <summary>
        /// Reverse  Main Control Points list
        /// </summary>
        public void ReversePoints()
        {
            MainControlPoints.Reverse();
            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.ReverseData();
            }
        }

        #endregion

        /// <summary>
        /// Generates entire spline with side splines
        /// </summary>
        /// <param name="pointsDensity">Density of points per part of spline</param>
        public void GenerateFullSpline(float pointsDensity)
        {
            if (MainControlPoints.Count < 2)
                return;


            //Calculate side splines control points
            CalculateCatmullRomSideSplines();

            //Calculates main points, tangents, normals etc
            CalculateCatmullRomSplineParameters(pointsDensity);


            CalculateSplinePositions(pointsDensity, SplineSide.Up);

            CalculateSplinePositions(pointsDensity, SplineSide.Down);

            //Prepairs array for faster distance based search of points on spline
            GenerateArrayForDistanceSearch();
        }

        /// <summary>
        /// Checks if any of control points has NaN rotation
        /// </summary>
        public void CheckForNanRotation()
        {
            bool nanError = false;
            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                if (float.IsNaN(MainControlPoints[i].position.x) || float.IsNaN(MainControlPoints[i].position.y) ||
                    float.IsNaN(MainControlPoints[i].position.z) || float.IsNaN(MainControlPoints[i].position.w))
                {
                    MainControlPoints[i].rotation = Quaternion.identity;
                    nanError = true;
                }

                if (MainControlPoints[i].rotation.x == 0 && MainControlPoints[i].rotation.y == 0 &&
                    MainControlPoints[i].rotation.z == 0 && MainControlPoints[i].rotation.w == 0)
                {
                    MainControlPoints[i].rotation = Quaternion.identity;
                    nanError = true;
                }

                MainControlPoints[i].rotation = Quaternion.Euler(MainControlPoints[i].rotation.eulerAngles);
                if (nanError)
                    MainControlPoints[i].orientation = Quaternion.identity;
            }
        }

        /// <summary>
        /// Calculates control points for side spline
        /// </summary>
        public void CalculateCatmullRomSideSplines()
        {
            ControlPointsPositionUp.Clear();
            ControlPointsPositionDown.Clear();

            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                ControlPointsPositionUp.Add(MainControlPoints[i].position);
                ControlPointsPositionDown.Add(MainControlPoints[i].position);
            }

            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                if (!IsLooping && i > MainControlPoints.Count - 2) continue;

                CalculateCatmullRomSideSplines(i);
            }
        }

        public List<NmSplinePoint> CalculateCatmullRomPointList(float pointsDensity, SplineSide splineSide)
        {
            List<NmSplinePoint> pointsList = new List<NmSplinePoint>();

            Vector3 p0;
            Vector3 p1;
            Vector3 p2;
            Vector3 p3;


            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                if (!IsLooping && i > MainControlPoints.Count - 2) continue;

                switch (splineSide)
                {
                    case SplineSide.Center:
                        GetControlPointsPositions(MainControlPoints, i, out p0, out p1, out p2, out p3);
                        break;
                    case SplineSide.Up:
                        GetControlPointsPositions(ControlPointsPositionUp, i, out p0, out p1, out p2, out p3);
                        break;
                    case SplineSide.Down:
                        GetControlPointsPositions(ControlPointsPositionDown, i, out p0, out p1, out p2, out p3);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(splineSide), splineSide, null);
                }


                CalculateCatmullRomSpline(i, pointsDensity, p0, p1, p2, p3, ref pointsList);
            }

            return pointsList;
        }

        public void CalculateCatmullRomSideSplines(int pos)
        {
            GetControlPointsPositions(MainControlPoints, pos, out Vector3 p0, out Vector3 p1, out Vector3 p2, out Vector3 p3);

            int tValueMax = 0;
            if (pos == MainControlPoints.Count - 2) tValueMax = 1;


            for (int tValue = 0; tValue <= tValueMax; tValue++)
            {
                //Vector3 newPos = GetCatmullRomPosition(tValue, p0, p1, p2, p3);
                Vector3 tangent = RamMath.GetCatmullRomTangent(tValue, p0, p1, p2, p3).normalized;
                Vector3 normal = RamMath.CalculateNormal(tangent, Vector3.up);


                Quaternion orientation;
                if (normal == tangent && normal == Vector3.zero)
                    orientation = Quaternion.identity;
                else
                    orientation = Quaternion.LookRotation(tangent, normal);


                orientation *= Quaternion.Lerp(MainControlPoints[pos].rotation, MainControlPoints[ClampListPos(pos + 1)].rotation, tValue);

                Vector3 posUp = (Vector3)MainControlPoints[pos + tValue].position + orientation * (0.5f * (useWidth ? MainControlPoints[pos + tValue].position.w : 1) * Vector3.right);
                Vector3 posDown = (Vector3)MainControlPoints[pos + tValue].position + orientation * (0.5f * (useWidth ? MainControlPoints[pos + tValue].position.w : 1) * Vector3.left);


                MainControlPoints[pos + tValue].orientation = orientation;
                ControlPointsPositionUp[pos + tValue] = posUp;
                ControlPointsPositionDown[pos + tValue] = posDown;
            }
        }

        /// <summary>
        /// Calculates main spline points, tangents, normals etc
        /// </summary>
        /// <param name="pointsDensity">Density of points per part of spline</param>
        public void CalculateCatmullRomSplineParameters(float pointsDensity)
        {
            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                if (!IsLooping && i > MainControlPoints.Count - 2) continue;

                CalculateCatmullRomSplineParameters(i, pointsDensity);
            }
        }

        public void CalculateSplinePositions(float pointsDensity, SplineSide splineSide)
        {
            switch (splineSide)
            {
                case SplineSide.Center:
                    Points.Clear();
                    Points.AddRange(CalculateCatmullRomPointList(pointsDensity, splineSide));
                    break;
                case SplineSide.Up:
                    PointsUp.Clear();
                    PointsUp.AddRange(CalculateCatmullRomPointList(pointsDensity, splineSide));
                    break;
                case SplineSide.Down:
                    PointsDown.Clear();
                    PointsDown.AddRange(CalculateCatmullRomPointList(pointsDensity, splineSide));
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(splineSide), splineSide, null);
            }
        }

        public void CalculateCatmullRomSplineParameters(int pos, float pointsDensity)
        {
            GetControlPointsPositions(MainControlPoints, pos, out Vector3 p0, out Vector3 p1, out Vector3 p2, out Vector3 p3);

            float density = pointsDensity * MainControlPoints[pos].additionalDensityU;


            int loops = Mathf.FloorToInt(density);
            //Debug.Log(loops);

            float i;

            float start = 0;
            if (pos > 0)
                start = 1;

            //if (IsLooping)
            //     start = 1;

            for (i = start; i <= loops; i++)
            {
                float t = i * (1 / density);
                CalculatePointParameters(MainControlPoints, pos, p0, p1, p2, p3, t);
            }

            if (i < loops)
            {
                i = loops;
                float t = i * (1 / density);
                CalculatePointParameters(MainControlPoints, pos, p0, p1, p2, p3, t);
            }
        }

        public void CalculateCatmullRomSpline(int pos, float pointsDensity, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, ref List<NmSplinePoint> pointsPart)
        {
            float density = pointsDensity * MainControlPoints[pos].additionalDensityU;


            int loops = Mathf.FloorToInt(density);
            //Debug.Log(loops);

            int i;

            int start = 0;
            if (pos > 0)
                start = 1;

            if (IsLooping)
                start = 1;

            for (i = start; i <= loops; i++)
            {
                float t = i * (1 / density);
                CalculatePointPosition(p0, p1, p2, p3, t, ref pointsPart);
            }


            if (i < loops)
            {
                i = loops;
                float t = i * (1 / density);
                CalculatePointPosition(p0, p1, p2, p3, t, ref pointsPart);
            }
        }

        private void GetControlPointsPositions(List<RamControlPoint> controlPointsPart, int pos, out Vector3 p0, out Vector3 p1, out Vector3 p2, out Vector3 p3)
        {
            List<Vector3> pointsPositions = new List<Vector3>();
            foreach (var controlPoint in controlPointsPart)
            {
                pointsPositions.Add(controlPoint.position);
            }

            GetControlPointsPositions(pointsPositions, pos, out p0, out p1, out p2, out p3);
        }

        public void GetControlPointsPositions(List<Vector3> controlPointsPart, int pos, out Vector3 p0, out Vector3 p1, out Vector3 p2, out Vector3 p3)
        {
            if (!IsLooping)
            {
                //pos = ClampListPos(pos - 1);

                p0 = pos > 0 ? controlPointsPart[ClampListPos(pos - 1)] : controlPointsPart[pos];
                p1 = controlPointsPart[pos];
                p2 = controlPointsPart[ClampListPos(pos + 1)];
                p3 = pos < controlPointsPart.Count - 2 ? controlPointsPart[ClampListPos(pos + 2)] : controlPointsPart[ClampListPos(pos + 1)];
            }
            else
            {
                p0 = controlPointsPart[ClampListPos(pos - 1)];
                p1 = controlPointsPart[pos];
                p2 = controlPointsPart[ClampListPos(pos + 1)];
                p3 = controlPointsPart[ClampListPos(pos + 2)];
            }
        }

        private void CalculatePointPosition(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3,
            float t, ref List<NmSplinePoint> pointsPart)
        {
            Vector3 newPos = RamMath.GetCatmullRomPosition(t, p0, p1, p2, p3);
            pointsPart.Add(new NmSplinePoint(newPos));
            //Debug.DrawLine(newPos, newPos + Vector3.up);
        }

        public void CalculatePointParameters(List<RamControlPoint> controlPointsPart, int pos, Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3,
            float t)
        {
            Vector3 newPos = RamMath.GetCatmullRomPosition(t, p0, p1, p2, p3);
            Vector3 lastPos = Points.Count == 0 ? p1 : Points[^1].Position;

            if (Points.Count > 0)
                Length += Vector3.Distance(newPos, lastPos);


            int clampListPos = ClampListPos(pos + 1);

            float widthPoint = Mathf.Lerp(controlPointsPart[pos].position.w, controlPointsPart[clampListPos].position.w, t);
            float snap;

            if (controlPointsPart.Count > pos + 1)
                snap = Mathf.Lerp(controlPointsPart[pos].snap, controlPointsPart[clampListPos].snap, t);
            else
                snap = 0;

            float lerp = pos + t;

            int density = (int)controlPointsPart[pos].additionalDensityV;
            //Debug.Log($"{density} {pos}");

            Vector3 tangent = RamMath.GetCatmullRomTangent(t, p0, p1, p2, p3).normalized;
            Vector3 normal = RamMath.CalculateNormal(tangent, Vector3.up);
            // Debug.Log(tangent + " CalculatePointParameters: " + normal);

            Quaternion orientation;
            if (normal == tangent && normal == Vector3.zero)
                orientation = Quaternion.identity;
            else
                orientation = Quaternion.LookRotation(tangent, normal);

            Quaternion rotation = Quaternion.Lerp(controlPointsPart[pos].rotation, controlPointsPart[clampListPos].rotation, t);

            orientation *= rotation;

            if (Points.Count > 0 && Vector3.Angle(Points[^1].Normal, normal) > 90) normal *= -1;

            Vector3 binormal = Vector3.Cross(Vector3.up, tangent).normalized;


            NmSplinePoint nmSplinePoint = new NmSplinePoint(newPos, orientation, rotation, normal, tangent, binormal, widthPoint, snap, lerp, Length, density);


            if (t is 0 or 1)
            {
                ControlPointsParameters.Add(nmSplinePoint);
            }

            Points.Add(nmSplinePoint);

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.CalculatePoint(pos, clampListPos, t);
            }
        }


        public int ClampListPos(int pos)
        {
            if (pos < 0) pos = MainControlPoints.Count - 1;

            if (pos > MainControlPoints.Count)
                pos = 1;
            else if (pos > MainControlPoints.Count - 1) pos = 0;

            return pos;
        }


        private void ClearDataLists()
        {
            ControlPointsParameters.Clear();

            Points.Clear();
            PointsUp.Clear();
            PointsDown.Clear();

            Length = 0;

            ControlPointsPositionUp.Clear();
            ControlPointsPositionDown.Clear();

            NmSplinePointSearcher.ClearPositions();

            foreach (NmSplineDataBase additionalData in AdditionalDataList)
            {
                additionalData.ClearSearchData();
            }
        }


        public void CenterSplinePivot()
        {
            Vector3 center = Vector3.zero;

            for (int i = 0; i < MainControlPoints.Count; i++) center += (Vector3)MainControlPoints[i].position;

            center /= MainControlPoints.Count;

            for (int i = 0; i < MainControlPoints.Count; i++)
            {
                Vector4 vec = MainControlPoints[i].position;
                vec.x -= center.x;
                vec.y -= center.y;
                vec.z -= center.z;
                MainControlPoints[i].position = vec;
            }

            transform.position += center;
        }

        public void GenerateArrayForDistanceSearch()
        {
            NmSplinePointSearcher.GenerateArrayForDistanceSearch(points);
        }

        public bool CanGenerateSpline(int pointNumber = 2)
        {
            return MainControlPoints != null && MainControlPoints.Count > pointNumber - 1;
        }

        public T GetData<T>() where T : NmSplineDataBase
        {
            T[] components = gameObject.GetComponents<T>();

            if (components is { Length: > 1 })
            {
                for (int i = 1; i < components.Length; i++)
                {
                    if (Application.isPlaying)
                    {
                        Destroy(components[i]);
                    }
                    else
                    {
                        DestroyImmediate(components[i]);
                    }
                }
            }
            else
            {
                foreach (NmSplineDataBase nmSplineDataBase in AdditionalDataList)
                {
                    var additionalData = (T)nmSplineDataBase;
                    if (additionalData && additionalData.GetType() == typeof(T))

                        return additionalData;
                }
            }

            T data;
            if (components == null || components.Length == 0)
                data = gameObject.AddComponent<T>();
            else
                data = components[0];

            GetAdditionalDataList();

            return data;
        }

        public static NmSplinePoint GetMainControlPointDataLerp(NmSpline nmSpline, float lerpValue)
        {
            int count = nmSpline.MainControlPoints.Count;
            int index = (int)lerpValue;
            float lerp = lerpValue % 1;

            NmSplinePoint firstPosition = nmSpline.ControlPointsParameters[index];
            NmSplinePoint secondPosition = nmSpline.ControlPointsParameters[(index + 1) % count];

            return NmSplinePoint.LerpTwoPoints(firstPosition, secondPosition, lerp);
        }
    }
}