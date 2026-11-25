// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public struct NmSplinePoint
    {
        [SerializeField] private Vector3 position;
        [SerializeField] private float width;
        [SerializeField] private float snap;
        [SerializeField] private float lerpValue;
        [SerializeField] private Quaternion orientation;
        [SerializeField] private Quaternion rotation;
        [SerializeField] private Vector3 normal;
        [SerializeField] private Vector3 tangent;
        [SerializeField] private Vector3 binormal;
        [SerializeField] private float distance;
        [SerializeField] private int density;
        [SerializeField] private int id;

        public NmSplinePoint(int id = 0)
        {
            width = 1;
            snap = 0;
            lerpValue = 0;
            distance = 0;
            density = 1;
            position = default;
            orientation = default;
            rotation = default;
            normal = default;
            tangent = default;
            binormal = default;
            this.id = id;
        }

        public NmSplinePoint(Vector3 position)
        {
            this.position = position;
            width = 0;
            snap = 0;
            lerpValue = 0;
            orientation = default;
            rotation = default;
            normal = default;
            tangent = default;
            binormal = default;
            distance = 0;
            density = 0;
            id = 0;
        }

        public NmSplinePoint(Vector3 position, Quaternion orientation, Quaternion rotation, Vector3 normal, Vector3 tangent, Vector3 binormal, float width, float snap, float lerpValue, float distance, int density)
        {
            this.position = position;
            this.orientation = orientation;
            this.rotation = rotation;
            this.normal = normal;
            this.tangent = tangent;
            this.binormal = binormal;
            this.width = width;
            this.snap = snap;
            this.lerpValue = lerpValue;
            this.distance = distance;
            this.density = density;
            id = 0;
        }

        public static NmSplinePoint LerpTwoPoints(NmSplinePoint point1, NmSplinePoint point2, float lerp)
        {
            Vector3 positionLerp = Vector3.Lerp(point1.position, point2.position, lerp);
            Quaternion orientationLerp = Quaternion.Lerp(point1.orientation, point2.orientation, lerp);
            Quaternion rotationLerp = Quaternion.Lerp(point1.rotation, point2.rotation, lerp);
            Vector3 normalLerp = Vector3.Lerp(point1.normal, point2.normal, lerp);
            Vector3 tangentLerp = Vector3.Lerp(point1.tangent, point2.tangent, lerp);
            Vector3 binormalLerp = Vector3.Lerp(point1.binormal, point2.binormal, lerp);
            float widthLerp = Mathf.Lerp(point1.width, point2.width, lerp);
            float snapLerp = Mathf.Lerp(point1.snap, point2.snap, lerp);
            float lerpValueLerp = Mathf.Lerp(point1.lerpValue, point2.lerpValue, lerp);
            float distanceLerp = Mathf.Lerp(point1.distance, point2.distance, lerp);
            int densityLerp = (int)Mathf.Lerp(point1.density, point2.density, lerp);

            return new NmSplinePoint(positionLerp, orientationLerp, rotationLerp, normalLerp, tangentLerp, binormalLerp, widthLerp, snapLerp, lerpValueLerp, distanceLerp, densityLerp);
        }


        public Vector3 Position
        {
            get => position;
            set => position = value;
        }

        public float Width
        {
            get => width;
            set => width = value;
        }

        public float Snap
        {
            get => snap;
            set => snap = value;
        }

        public float LerpValue
        {
            get => lerpValue;
            set => lerpValue = value;
        }

        public Quaternion Orientation
        {
            get => orientation;
            set => orientation = value;
        }

        public Vector3 Tangent
        {
            get => tangent;
            set => tangent = value;
        }

        public Vector3 Binormal
        {
            get => binormal;
            set => binormal = value;
        }

        public Vector3 Normal
        {
            get => normal;
            set => normal = value;
        }

        public float Distance
        {
            get => distance;
            set => distance = value;
        }

        public int Density
        {
            get => density;
            set => density = value;
        }

        public Quaternion Rotation
        {
            get => rotation;
            set => rotation = value;
        }

        public int ID
        {
            get => id;
            set => id = value;
        }
    }
}