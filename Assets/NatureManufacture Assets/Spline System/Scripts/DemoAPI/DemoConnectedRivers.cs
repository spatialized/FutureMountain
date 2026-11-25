using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    /// <summary>
    /// The DemoConnectedRivers class demonstrates how to create and connect multiple river splines
    /// using the NatureManufacture River Auto Material (RAM) system. It initializes a main river spline
    /// and then creates two child splines branching from it. Additionally, it connects these child splines
    /// to a third spline, forming a network of connected river segments.
    /// </summary>
    public class DemoConnectedRivers : MonoBehaviour
    {
        /// <summary>
        /// The spline profile to use for the rivers.
        /// </summary>
        [SerializeField] private SplineProfile splineProfile;

        /// <summary>
        /// Setups spline and terrain painter data on start.
        /// </summary>
        private void Start()
        {
            // Get the width from the spline profile
            float width = splineProfile.width;

            // Create the main spline with initial control points
            var ramSpline = RamSpline.CreateSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(0, 0, 0, width), new(0, 0, 20, width) });

            // Set the current profile and update the base profile data
            ramSpline.currentProfile = splineProfile;
            ramSpline.BaseProfile.SetProfileData(ramSpline.currentProfile);

            // Create two child splines branching from the main spline
            RamSpline ramFirst = ramSpline.CreateSecondSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(0, 0, 20, width * 0.5f), new(-10, 0, 40, width * 0.5f), new(-10, 0, 60, width * 0.5f), new(0, 0, 80, width * 0.5f) },
                "_first", width * 0.5f);

            RamSpline ramSecond = ramSpline.CreateSecondSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(0, 0, 20, width * 0.5f), new(10, 0, 40, width * 0.5f), new(10, 0, 60, width * 0.5f), new(0, 0, 80, width * 0.5f) },
                "_second", width * 0.5f);

            // Set the beginning spline and width range for the first child spline
            ConnectBeginningSpline(ramFirst, ramSpline, 0, 0.5f);

            // Set the beginning spline and width range for the second child spline
            ConnectBeginningSpline(ramSecond, ramSpline, 0.5f, 1);

            // Create third child splines connecting both first and second child splines
            RamSpline ramThird = ramFirst.CreateSecondSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(0, 0, 80, width), new(0, 0, 140, width) }, "_third", width);

            // Set the ending spline and width range for the first child spline
            ConnectEndingSpline(ramFirst, ramThird, 0f, 0.5f);

            // Set the ending spline and width range for the second child spline
            ConnectEndingSpline(ramSecond, ramThird, 0.5f, 1);

            // Generate the splines to apply the changes
            ramSpline.GenerateSpline();
            ramFirst.GenerateSpline();
            ramSecond.GenerateSpline();
            ramThird.GenerateSpline();
        }

        /// <summary>
        /// Connects the spline at the beginning to the connecting spline.
        /// </summary>
        /// <param name="baseSpline">The base spline to connect.</param>
        /// <param name="connectingSpline">The spline to connect to at the beginning.</param>
        /// <param name="minWidth">The minimum width % at the connection point.</param>
        /// <param name="maxWidth">The maximum width % at the connection point.</param>
        private static void ConnectBeginningSpline(RamSpline baseSpline, RamSpline connectingSpline, float minWidth, float maxWidth)
        {
            baseSpline.beginningSpline = connectingSpline;
            baseSpline.beginningMinWidth = minWidth;
            baseSpline.beginningMaxWidth = maxWidth;
            connectingSpline.endingChildSplines.Add(baseSpline);
        }

        /// <summary>
        /// Connects the spline at the ending to the connecting spline.
        /// </summary>
        /// <param name="baseSpline">The base spline to connect.</param>
        /// <param name="connectingSpline">The spline to connect to at the ending.</param>
        /// <param name="minWidth">The minimum width % at the connection point.</param>
        /// <param name="maxWidth">The maximum width % at the connection point.</param>
        private static void ConnectEndingSpline(RamSpline baseSpline, RamSpline connectingSpline, float minWidth, float maxWidth)
        {
            baseSpline.endingSpline = connectingSpline;
            baseSpline.endingMinWidth = minWidth;
            baseSpline.endingMaxWidth = maxWidth;
            connectingSpline.beginningChildSplines.Add(baseSpline);
        }
    }
}