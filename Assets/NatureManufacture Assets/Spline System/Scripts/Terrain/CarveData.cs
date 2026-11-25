using UnityEngine;

namespace NatureManufacture.RAM
{
    public class CarveData
    {
        public Vector4[,] Distances;
        public float DistSmooth = 0;
        public float MaxX = float.MinValue;
        public float MaxZ = float.MinValue;
        public float MinX = float.MaxValue;
        public float MinZ = float.MaxValue;
    }
}