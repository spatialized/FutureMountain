using UnityEngine;

namespace NatureManufacture.RAM
{
    public class FenceAxis
    {
        private static readonly Vector3[] VectorAxes = {
            Vector3.right,
            Vector3.up,
            Vector3.forward,
            Vector3.left,
            Vector3.down,
            Vector3.back
        };

        public enum AlignAxis
        {
            /// <summary> Object space X axis. </summary>
            [InspectorName("Object X+")] XAxis,

            /// <summary> Object space Y axis. </summary>
            [InspectorName("Object Y+")] YAxis,

            /// <summary> Object space Z axis. </summary>
            [InspectorName("Object Z+")] ZAxis,

            /// <summary> Object space negative X axis. </summary>
            [InspectorName("Object X-")] NegativeXAxis,

            /// <summary> Object space negative Y axis. </summary>
            [InspectorName("Object Y-")] NegativeYAxis,

            /// <summary> Object space negative Z axis. </summary>
            [InspectorName("Object Z-")] NegativeZAxis
        }

        public static Vector3 GetAxis(AlignAxis axis)
        {
            return VectorAxes[(int)axis];
        }
    }
}