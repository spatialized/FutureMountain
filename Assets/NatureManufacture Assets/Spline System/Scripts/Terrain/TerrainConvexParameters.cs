// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class TerrainConvexParameters
    {
        [SerializeField] private ConvexType convex;
        [SerializeField] private int steps = 1;
        [SerializeField] private float stepSize = 1;
        [SerializeField] private float strength = 1;


        public enum ConvexType
        {
            None = 0,
            Convex = 1,
            Concave = 2
        }


        public ConvexType Convex
        {
            get => convex;
            set => convex = value;
        }

        public int Steps
        {
            get => steps;
            set => steps = value;
        }

        public float StepSize
        {
            get => stepSize;
            set => stepSize = value;
        }

        public float Strength
        {
            get => strength;
            set => strength = value;
        }

        public TerrainConvexParameters()
        {
            Reset();
        }

        public void  Reset()
        {
            convex = ConvexType.None;
            steps = 1;
            stepSize = 1;
            strength = 1;
            
        }

        //copy constructor
        public TerrainConvexParameters(TerrainConvexParameters other)
        {
            convex = other.convex;
            steps = other.steps;
            stepSize = other.stepSize;
            strength = other.strength;
        }

        public bool CheckProfileChange(TerrainConvexParameters otherParameters)
        {
            if (otherParameters == null)
                return false;

            if (convex != otherParameters.convex)
                return true;

            if (steps != otherParameters.steps)
                return true;

            if (stepSize != otherParameters.stepSize)
                return true;

            if (strength != otherParameters.strength)
                return true;


            return false;
        }
    }
}