// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class TerrainNoiseParameters
    {
        [SerializeField] private bool useNoise = true;
        [SerializeField] private bool randomizeSeed = true;
        [SerializeField] private float noiseSeed;

        [SerializeField] private float noiseMultiplierPower = 1f;

        [SerializeField] private float noiseMultiplier = 1f;
        [SerializeField] private float noiseSizeX = 10f;
        [SerializeField] private float noiseSizeZ = 10f;
        [SerializeField] private OperationTypeEnum operationType = OperationTypeEnum.Add;

        public enum OperationTypeEnum
        {
            Add,
            Subtract,
            Multiply,
            Divide
        }

        public bool UseNoise
        {
            get => useNoise;
            set => useNoise = value;
        }

        public float NoiseMultiplier
        {
            get => noiseMultiplier;
            set => noiseMultiplier = value;
        }


        public float NoiseSizeX
        {
            get => noiseSizeX;
            set => noiseSizeX = value;
        }

        public float NoiseSizeZ
        {
            get => noiseSizeZ;
            set => noiseSizeZ = value;
        }

        public float NoiseMultiplierPower
        {
            get => noiseMultiplierPower;
            set => noiseMultiplierPower = value;
        }

        public OperationTypeEnum OperationType
        {
            get => operationType;
            set => operationType = value;
        }

        public bool RandomizeSeed
        {
            get => randomizeSeed;
            set => randomizeSeed = value;
        }

        public float NoiseSeed
        {
            get => noiseSeed;
            set => noiseSeed = value;
        }

        public TerrainNoiseParameters()
        {
            Reset();
        }

        public void Reset()
        {
            useNoise = false;
            randomizeSeed = true;
            noiseSeed = 0;
            noiseMultiplierPower = 1f;
            noiseMultiplier = 1f;
            noiseSizeX = 10f;
            noiseSizeZ = 10f;
            operationType = OperationTypeEnum.Add;
        }

        //Copy constructor
        public TerrainNoiseParameters(TerrainNoiseParameters terrainNoiseParameters)
        {
            useNoise = terrainNoiseParameters.useNoise;
            randomizeSeed = terrainNoiseParameters.randomizeSeed;
            noiseSeed = terrainNoiseParameters.noiseSeed;
            noiseMultiplierPower = terrainNoiseParameters.noiseMultiplierPower;
            noiseMultiplier = terrainNoiseParameters.noiseMultiplier;
            noiseSizeX = terrainNoiseParameters.noiseSizeX;
            noiseSizeZ = terrainNoiseParameters.noiseSizeZ;
            operationType = terrainNoiseParameters.operationType;
        }


        public bool CheckProfileChange(TerrainNoiseParameters otherParameters)
        {
            if (otherParameters == null)
                return false;

            //check all fields with other parameters fields
            if (useNoise != otherParameters.useNoise)
                return true;
            if (randomizeSeed != otherParameters.randomizeSeed)
                return true;
            if (noiseSeed != otherParameters.noiseSeed)
                return true;


            if (noiseMultiplierPower != otherParameters.noiseMultiplierPower)
                return true;

            if (noiseMultiplier != otherParameters.noiseMultiplier)
                return true;

            if (noiseSizeX != otherParameters.noiseSizeX)
                return true;

            if (noiseSizeZ != otherParameters.noiseSizeZ)
                return true;

            if (operationType != otherParameters.operationType)
                return true;

            return false;
        }
    }
}