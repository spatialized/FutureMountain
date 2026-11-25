// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class TerrainLayerData
    {
        [SerializeField] private string layerName = "Terrain Paint Layer";
        [SerializeField] private bool isActive = true;


        [SerializeField] private AnimationCurve power = new(new Keyframe(0, 0), new Keyframe(1, 1));
        [SerializeField] private float powerMultiplier = 1;

        [SerializeField] private bool useHeight = false;
        [SerializeField] private AnimationCurve height = new(new Keyframe(0, 1), new Keyframe(800, 1));
        [SerializeField] private float heightMultiplier = 1;
        [SerializeField] private float heightPower = 1;


        [SerializeField] private int splatMapID = 0;

        [SerializeField] private bool useAngle = false;
        [SerializeField] private AnimationCurve angle = new(new Keyframe(0, 1), new Keyframe(90, 1));
        [SerializeField] private List<TerrainNoiseParameters> noiseParametersList = new();
        [SerializeField] private TerrainConvexParameters convexParameters = new();


        public List<TerrainNoiseParameters> NoiseParametersList
        {
            get
            {
                if (noiseParametersList != null) return noiseParametersList;
                noiseParametersList = new List<TerrainNoiseParameters>();
                return noiseParametersList;
            }
            set => noiseParametersList = value;
        }

        public AnimationCurve Angle
        {
            get => angle;
            set => angle = value;
        }

        public int SplatMapID
        {
            get => splatMapID;
            set => splatMapID = value;
        }

        public AnimationCurve Power
        {
            get => power;
            set => power = value;
        }

        public bool IsActive
        {
            get => isActive;
            set => isActive = value;
        }

        public string LayerName
        {
            get => layerName;
            set => layerName = value;
        }

        public TerrainConvexParameters ConvexParameters
        {
            get => convexParameters;
            set => convexParameters = value;
        }

        public float PowerMultiplier
        {
            get => powerMultiplier;
            set => powerMultiplier = value;
        }

        public AnimationCurve Height
        {
            get => height;
            set => height = value;
        }

        public float HeightMultiplier
        {
            get => heightMultiplier;
            set => heightMultiplier = value;
        }

        public float HeightPower
        {
            get => heightPower;
            set => heightPower = value;
        }

        public bool UseHeight
        {
            get => useHeight;
            set => useHeight = value;
        }

        public bool UseAngle
        {
            get => useAngle;
            set => useAngle = value;
        }

        //contructor with default values
        public TerrainLayerData()
        {
            Reset();
        }

        public void Reset()
        {
            layerName = "Terrain Paint Layer";
            isActive = true;
            power = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 1));
            powerMultiplier = 1;
            height = new AnimationCurve(new Keyframe(0, 1), new Keyframe(800, 1));
            heightMultiplier = 1;
            heightPower = 1;
            splatMapID = 0;
            angle = new AnimationCurve(new Keyframe(0, 1), new Keyframe(90, 1));
            noiseParametersList = new List<TerrainNoiseParameters>();
            convexParameters = new TerrainConvexParameters();
        }

        //copy constructor
        public TerrainLayerData(TerrainLayerData terrainLayerData)
        {
            layerName = terrainLayerData.layerName;
            isActive = terrainLayerData.isActive;
            power = new AnimationCurve(terrainLayerData.power.keys);
            powerMultiplier = terrainLayerData.powerMultiplier;
            useHeight = terrainLayerData.useHeight;
            height = new AnimationCurve(terrainLayerData.height.keys);
            heightMultiplier = terrainLayerData.heightMultiplier;
            heightPower = terrainLayerData.heightPower;
            splatMapID = terrainLayerData.splatMapID;
            useAngle = terrainLayerData.useAngle;
            angle = new AnimationCurve(terrainLayerData.angle.keys);
            noiseParametersList = new List<TerrainNoiseParameters>(terrainLayerData.noiseParametersList);
            convexParameters = new TerrainConvexParameters(terrainLayerData.convexParameters);
        }

        public bool CheckProfileChange(TerrainLayerData otherParameters)
        {
            if (otherParameters == null)
                return false;

            if (otherParameters.layerName != layerName)
                return true;

            if (otherParameters.isActive != isActive)
                return true;

            if (otherParameters.powerMultiplier != powerMultiplier)
                return true;

            if (otherParameters.useHeight != useHeight)
                return true;

            if (otherParameters.heightMultiplier != heightMultiplier)
                return true;

            if (otherParameters.heightPower != heightPower)
                return true;

            if (otherParameters.splatMapID != splatMapID)
                return true;

            if (otherParameters.noiseParametersList.Count != noiseParametersList.Count)
                return true;

            for (int i = 0; i < noiseParametersList.Count; i++)
                if (noiseParametersList[i].CheckProfileChange(otherParameters.noiseParametersList[i]))
                    return true;


            if (otherParameters.convexParameters.CheckProfileChange(convexParameters))
                return true;

            if (otherParameters.power.keys.Length != power.keys.Length)
                return true;

            if (otherParameters.height.keys.Length != height.keys.Length)
                return true;

            if (otherParameters.useAngle != useAngle)
                return true;

            if (otherParameters.angle.keys.Length != angle.keys.Length)
                return true;

            for (int i = 0; i < power.keys.Length; i++)
                if (otherParameters.power.keys[i].time != power.keys[i].time ||
                    otherParameters.power.keys[i].value != power.keys[i].value)
                    return true;

            for (int i = 0; i < height.keys.Length; i++)
                if (otherParameters.height.keys[i].time != height.keys[i].time ||
                    otherParameters.height.keys[i].value != height.keys[i].value)
                    return true;

            for (int i = 0; i < angle.keys.Length; i++)
                if (otherParameters.angle.keys[i].time != angle.keys[i].time ||
                    otherParameters.angle.keys[i].value != angle.keys[i].value)
                    return true;

            return false;
        }
    }
}