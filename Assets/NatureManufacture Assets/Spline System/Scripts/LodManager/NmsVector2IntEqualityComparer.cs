using System.Collections.Generic;

namespace NatureManufacture.RAM
{
    public class NmsVector2IntEqualityComparer : IEqualityComparer<LodManager.SVector2Int>
    {
        public bool Equals(LodManager.SVector2Int v1, LodManager.SVector2Int v2)
        {
            return v1.X == v2.X && v1.Y == v2.Y;
        }

        public int GetHashCode(LodManager.SVector2Int obj)
        {
            int hash = 23;
            hash = hash * 31 + obj.X;
            hash = hash * 31 + obj.Y;
            return hash;
        }
    }
}