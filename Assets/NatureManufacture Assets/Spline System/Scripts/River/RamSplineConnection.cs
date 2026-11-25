using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class RamSplineConnection
    {
        public enum ConnectionTypeEnum
        {
            Split,
            Alpha
        }

        /// <summary>
        /// The spline to connect to.
        /// </summary>
        [SerializeField] private NmSpline spline;

        /// <summary>
        /// The point on the spline to connect to.
        /// </summary>
        [SerializeField] private float pointToConnect;

        /// <summary>
        /// The offset to apply when blending the connection.
        /// </summary>
        [SerializeField] private float blendOffset;

        /// <summary>
        /// The distance over which to blend the connection.
        /// </summary>
        [SerializeField] private float blendDistance;

        /// <summary>
        /// The strength of the blend.
        /// </summary>
        [SerializeField] private float blendStrength = 0.05f;

        /// <summary>
        /// The vertical offset of the connection.
        /// </summary>
        [SerializeField] private float yOffset = 0.01f;

        /// <summary>
        /// The curve to use for blending.
        /// </summary>
        [SerializeField] private AnimationCurve blendCurve = new AnimationCurve(new Keyframe[] { new Keyframe(0, 0, 0, 0), new Keyframe(0.5f, 0, 0, 1.497524f), new Keyframe(1, 1) });

        /// <summary>
        /// The curve to use for blending the side.
        /// </summary>
        [SerializeField] private AnimationCurve sideBlendCurve = new AnimationCurve(new Keyframe[] { new Keyframe(0, 0), new Keyframe(0.25f, 1), new Keyframe(0.75f, 1), new Keyframe(1, 0) });

        /// <summary>
        /// The type of connection.
        /// </summary>
        [SerializeField] private ConnectionTypeEnum connectionType;


        // Properties for accessing private fields
        public NmSpline Spline
        {
            get => spline;
            set => spline = value;
        }

        public float PointToConnect
        {
            get => pointToConnect;
            set => pointToConnect = value;
        }

        public float BlendDistance
        {
            get => blendDistance;
            set => blendDistance = value;
        }

        public float BlendStrength
        {
            get => blendStrength;
            set => blendStrength = value;
        }

        public float YOffset
        {
            get => yOffset;
            set => yOffset = value;
        }

        public AnimationCurve BlendCurve
        {
            get => blendCurve;
            set => blendCurve = value;
        }

        public AnimationCurve SideBlendCurve
        {
            get => sideBlendCurve;
            set => sideBlendCurve = value;
        }

        public float BlendOffset
        {
            get => blendOffset;
            set => blendOffset = value;
        }

        public ConnectionTypeEnum ConnectionType
        {
            get => connectionType;
            set => connectionType = value;
        }

        /// <summary>
        /// Sets up base values for the spline connection.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance used in the connection.</param>
        /// <param name="ramSplineConnection">The RamSplineConnection instance to set up.</param>
        /// <param name="connectionPointId">The index of the connection point used for calculating values.</param>
        public static void SetupBaseValues(RamSpline ramSpline, RamSplineConnection ramSplineConnection, int connectionPointId)
        {
            FindClosestPointToSpline(ramSpline, ramSplineConnection, connectionPointId);
            FindBaseValues(ramSplineConnection);
        }

        /// <summary>
        /// Finds and sets base values for the spline connection.
        /// </summary>
        /// <param name="ramSplineConnection">The RamSplineConnection instance to update with base values.</param>
        private static void FindBaseValues(RamSplineConnection ramSplineConnection)
        {
            if (ramSplineConnection.Spline.TryGetComponent<LakePolygon>(out LakePolygon lakePolygon))
            {
                ramSplineConnection.BlendOffset = 5;
                ramSplineConnection.BlendDistance = 8;
                ramSplineConnection.BlendStrength = 0.5f;
                ramSplineConnection.YOffset = 0.03f;
            }
            else if (ramSplineConnection.Spline.TryGetComponent<RamSpline>(out RamSpline ramSpline))
            {
                NmSplinePoint point = NmSpline.GetMainControlPointDataLerp(ramSplineConnection.Spline, ramSplineConnection.PointToConnect);
                float width = point.Width;
                ramSplineConnection.BlendOffset = 0.125f * width;
                ramSplineConnection.BlendDistance = 0.75f * width;
                ramSplineConnection.BlendStrength = 0.5f;
                ramSplineConnection.YOffset = 0.03f;
            }
        }

        /// <summary>
        /// Finds the closest point on the spline to connect to.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance.</param>
        /// <param name="ramSplineConnection">The RamSplineConnection instance being updated.</param>
        /// <param name="connectionPointId">The index of the connection point used to determine the closest point.</param>
        public static void FindClosestPointToSpline(RamSpline ramSpline, RamSplineConnection ramSplineConnection, int connectionPointId)
        {
            float minDistance = float.MaxValue;
            int closestPoint = -1;
            Vector3 splinePosition = ramSplineConnection.Spline.transform.position;
            Vector3 position = (Vector3)(ramSpline.NmSpline.MainControlPoints[connectionPointId].position) + ramSpline.transform.position;
            List<RamControlPoint> points = ramSplineConnection.Spline.MainControlPoints;
            for (int i = 0; i < points.Count; i++)
            {
                float distance = Vector3.Distance(position, (Vector3)points[i].position + splinePosition);
                if (!(distance < minDistance)) continue;
                minDistance = distance;
                closestPoint = i;
            }

            ramSplineConnection.PointToConnect = closestPoint;
        }

        /// <summary>
        /// Sets the blend position for the spline connection.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance.</param>
        /// <param name="ramSplineConnection">The RamSplineConnection instance being updated.</param>
        /// <param name="connectionPointId">The index of the control point to update.</param>
        public static void SetBlendPosition(RamSpline ramSpline, RamSplineConnection ramSplineConnection, int connectionPointId)
        {
            NmSplinePoint point = NmSpline.GetMainControlPointDataLerp(ramSplineConnection.Spline, ramSplineConnection.PointToConnect);
            Vector3 lakePoint = point.Position + point.Binormal * ramSplineConnection.BlendOffset + ramSplineConnection.Spline.transform.position;
            lakePoint -= ramSpline.transform.position;
            Vector4 position = ramSpline.NmSpline.MainControlPoints[connectionPointId].position;
            position.x = lakePoint.x;
            position.y = lakePoint.y + ramSplineConnection.YOffset;
            position.z = lakePoint.z;
            ramSpline.NmSpline.MainControlPoints[connectionPointId].position = position;
        }

        /// <summary>
        /// Generates beginning points from the parent spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance from which beginning points are generated.</param>
        public static void GenerateBeginningPointsFromParent(RamSpline ramSpline)
        {
            ramSpline.BaseProfile.vertsInShape = (int)Mathf.Round((ramSpline.beginningSpline.BaseProfile.vertsInShape - 1)
                * (ramSpline.beginningMaxWidth - ramSpline.beginningMinWidth) + 1);
            ramSpline.BaseProfile.uvFixedWidth = ramSpline.beginningSpline.BaseProfile.uvFixedWidth * (ramSpline.beginningMaxWidth - ramSpline.beginningMinWidth);
            if (ramSpline.BaseProfile.vertsInShape < 1)
                ramSpline.BaseProfile.vertsInShape = 1;
            if (!ramSpline.beginningSpline.NmSpline.CanGenerateSpline())
                return;
            if (ramSpline.beginningSpline.NmSpline.PointsDown.Count == 0)
            {
                ramSpline.beginningSpline.GenerateSpline();
            }

            ramSpline.beginningConnectionID = ramSpline.beginningSpline.NmSpline.Points.Count - 1;
            Vector4 pos = ramSpline.beginningSpline.NmSpline.MainControlPoints[^1].position;
            float widthNew = pos.w;
            widthNew *= ramSpline.beginningMaxWidth - ramSpline.beginningMinWidth;
            pos = Vector3.Lerp(ramSpline.beginningSpline.NmSpline.PointsDown[ramSpline.beginningConnectionID].Position,
                    ramSpline.beginningSpline.NmSpline.PointsUp[ramSpline.beginningConnectionID].Position,
                    ramSpline.beginningMinWidth + (ramSpline.beginningMaxWidth - ramSpline.beginningMinWidth) * 0.5f)
                + ramSpline.beginningSpline.transform.position - ramSpline.transform.position;
            pos.w = widthNew;
            ramSpline.NmSpline.MainControlPoints[0].position = pos;
            if (!ramSpline.uvScaleOverride)
                ramSpline.BaseProfile.uvScale = ramSpline.beginningSpline.BaseProfile.uvScale;
        }

        /// <summary>
        /// Generates ending points from the parent spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance from which ending points are generated.</param>
        public static void GenerateEndingPointsFromParent(RamSpline ramSpline)
        {
            if (ramSpline.beginningSpline == null)
            {
                ramSpline.BaseProfile.vertsInShape = (int)Mathf.Round((ramSpline.endingSpline.BaseProfile.vertsInShape - 1)
                    * (ramSpline.endingMaxWidth - ramSpline.endingMinWidth) + 1);
                ramSpline.BaseProfile.uvFixedWidth = ramSpline.endingSpline.BaseProfile.uvFixedWidth * (ramSpline.endingMaxWidth - ramSpline.endingMinWidth);
                if (ramSpline.BaseProfile.vertsInShape < 1)
                    ramSpline.BaseProfile.vertsInShape = 1;
            }

            if (ramSpline.endingSpline.NmSpline.PointsDown.Count == 0)
            {
                ramSpline.endingSpline.GenerateSpline();
            }

            ramSpline.endingConnectionID = 0;
            Vector4 pos = ramSpline.endingSpline.NmSpline.MainControlPoints[0].position;
            float widthNew = pos.w;
            widthNew *= ramSpline.endingMaxWidth - ramSpline.endingMinWidth;
            pos = Vector3.Lerp(ramSpline.endingSpline.NmSpline.PointsDown[ramSpline.endingConnectionID].Position,
                    ramSpline.endingSpline.NmSpline.PointsUp[ramSpline.endingConnectionID].Position,
                    ramSpline.endingMinWidth + (ramSpline.endingMaxWidth - ramSpline.endingMinWidth) * 0.5f)
                + ramSpline.endingSpline.transform.position - ramSpline.transform.position;
            pos.w = widthNew;
            ramSpline.NmSpline.MainControlPoints[^1].position = pos;
            if (!ramSpline.uvScaleOverride && ramSpline.beginningSpline == null)
                ramSpline.BaseProfile.uvScale = ramSpline.endingSpline.BaseProfile.uvScale;
        }

        /// <summary>
        /// Sets alpha connection without a beginning spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance whose beginning connection is being set.</param>
        /// <param name="blendDistance">The blend distance used for the connection.</param>
        /// <param name="blendStrength">The blend strength used for the connection.</param>
        /// <param name="blendCurve">Optional AnimationCurve defining the blend curve.</param>
        /// <param name="sideBlendCurve">Optional AnimationCurve defining the side blend curve.</param>
        public static void SetAlphaConnectionBeginningNoSpline(RamSpline ramSpline, float blendDistance, float blendStrength, AnimationCurve blendCurve = null, AnimationCurve sideBlendCurve = null)
        {
            SetAlphaConnectionNoSpline(ramSpline.BeginningSplineConnection, blendDistance, blendStrength, blendCurve, sideBlendCurve);
        }

        /// <summary>
        /// Sets alpha connection without an ending spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance whose ending connection is being set.</param>
        /// <param name="blendDistance">The blend distance used for the connection.</param>
        /// <param name="blendStrength">The blend strength used for the connection.</param>
        /// <param name="blendCurve">Optional AnimationCurve defining the blend curve.</param>
        /// <param name="sideBlendCurve">Optional AnimationCurve defining the side blend curve.</param>
        public static void SetAlphaConnectionEndingNoSpline(RamSpline ramSpline, float blendDistance, float blendStrength, AnimationCurve blendCurve = null, AnimationCurve sideBlendCurve = null)
        {
            SetAlphaConnectionNoSpline(ramSpline.EndingSplineConnection, blendDistance, blendStrength, blendCurve, sideBlendCurve);
        }

        /// <summary>
        /// Internal method to set alpha connection without a spline.
        /// </summary>
        /// <param name="ramSplineConnection">The RamSplineConnection instance to update.</param>
        /// <param name="blendDistance">The blend distance used for the connection.</param>
        /// <param name="blendStrength">The blend strength used for the connection.</param>
        /// <param name="blendCurve">Optional AnimationCurve defining the blend curve.</param>
        /// <param name="sideBlendCurve">Optional AnimationCurve defining the side blend curve.</param>
        private static void SetAlphaConnectionNoSpline(RamSplineConnection ramSplineConnection, float blendDistance, float blendStrength, AnimationCurve blendCurve = null, AnimationCurve sideBlendCurve = null)
        {
            ramSplineConnection.ConnectionType = ConnectionTypeEnum.Alpha;
            ramSplineConnection.BlendDistance = blendDistance;
            ramSplineConnection.BlendStrength = blendStrength;
            if (blendCurve != null)
                ramSplineConnection.BlendCurve.keys = blendCurve.keys;
            if (sideBlendCurve != null)
                ramSplineConnection.SideBlendCurve.keys = sideBlendCurve.keys;
        }

        /// <summary>
        /// Sets alpha connection at the beginning of the spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance.</param>
        /// <param name="splineToConnect">The NmSpline instance to connect to.</param>
        public static void SetAlphaConnectionBeginning(RamSpline ramSpline, NmSpline splineToConnect)
        {
            SetAlphaConnection(ramSpline, ramSpline.BeginningSplineConnection, splineToConnect, 0);
        }

        /// <summary>
        /// Sets alpha connection at the ending of the spline.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance.</param>
        /// <param name="splineToConnect">The NmSpline instance to connect to.</param>
        public static void SetAlphaConnectionEnding(RamSpline ramSpline, NmSpline splineToConnect)
        {
            SetAlphaConnection(ramSpline, ramSpline.EndingSplineConnection, splineToConnect, ramSpline.NmSpline.MainControlPoints.Count - 1);
        }

        /// <summary>
        /// Sets alpha connection for the specified spline connection.
        /// </summary>
        /// <param name="ramSpline">The main RamSpline instance.</param>
        /// <param name="ramSplineConnection">The RamSplineConnection instance to update.</param>
        /// <param name="splineToConnect">The NmSpline instance to connect to.</param>
        /// <param name="connectionPointId">The index of the connection point used for calculating values.</param>
        private static void SetAlphaConnection(RamSpline ramSpline, RamSplineConnection ramSplineConnection, NmSpline splineToConnect, int connectionPointId)
        {
            ramSplineConnection.Spline = splineToConnect;
            ramSplineConnection.ConnectionType = ConnectionTypeEnum.Alpha;
            SetupBaseValues(ramSpline, ramSplineConnection, connectionPointId);
            SetBlendPosition(ramSpline, ramSplineConnection, connectionPointId);
        }
    }
}