using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    /// <summary>
    /// The DemoRiversAlpha class demonstrates how to create and connect multiple river splines
    /// using the NatureManufacture River Auto Material (RAM) system. It initializes a main river spline
    /// and then creates two additional splines, connecting them to form a network of river segments.
    /// </summary>
    public class DemoRiversAlpha : MonoBehaviour
    {
        /// <summary>
        /// The spline profile to use for the rivers.
        /// </summary>
        [SerializeField] private SplineProfile splineProfile;

        /// <summary>
        /// Initializes the splines and sets up connections on start.
        /// </summary>
        private void Start()
        {
            // Get the width from the spline profile
            float width = splineProfile.width;

            // Create the main spline with initial control points
            var ramSpline = RamSpline.CreateSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(10, 0, 0, width), new(10, 0, 20, width) });

            // Set the current profile and update the base profile data
            ramSpline.currentProfile = splineProfile;
            ramSpline.BaseProfile.SetProfileData(ramSpline.currentProfile);

            // Set alpha connection at the ending of the spline without a connected spline
            RamSplineConnection.SetAlphaConnectionEndingNoSpline(ramSpline, 10, 1,
                new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 1)),
                new AnimationCurve(new Keyframe(0, 0), new Keyframe(0.5f, 1), new Keyframe(1, 0)));

            // Generate the spline to apply the changes
            ramSpline.GenerateSpline();

            // Create the second spline with initial control points
            var ramSplineTwo = RamSpline.CreateSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(0, 0, 0, width), new(0, 0, 10, width), new(0, 0, 20, width) });

            // Set the current profile and update the base profile data
            ramSplineTwo.currentProfile = splineProfile;
            ramSplineTwo.BaseProfile.SetProfileData(ramSpline.currentProfile);

            // Create the third spline with initial control points
            var ramSplineThree = RamSpline.CreateSpline(splineProfile.splineMaterial,
                new List<Vector4>() { new(-10, 0, 20, width), new(0, 0, 20, width), new(10, 0, 20, width) });

            // Set the current profile and update the base profile data
            ramSplineThree.currentProfile = splineProfile;
            ramSplineThree.BaseProfile.SetProfileData(ramSpline.currentProfile);

            // Generate the third spline to apply the changes
            ramSplineThree.GenerateSpline();

            // Set alpha connection at the ending of the second spline to connect with the third spline
            RamSplineConnection.SetAlphaConnectionEnding(ramSplineTwo, ramSplineThree.NmSpline);

            // Generate the second spline to apply the changes
            ramSplineTwo.GenerateSpline();
        }
    }
}