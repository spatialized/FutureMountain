// /**
//  * Created by Hollegar
//  */

using System;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class RamControlPoint
    {
        public Vector4 position;
        public Quaternion rotation;
        public Quaternion orientation;
        public float snap;
        public AnimationCurve meshCurve;
        public float additionalDensityU = 1;
        public float additionalDensityV = 1;

        public RamControlPoint(Vector4 position, Quaternion rotation, Quaternion orientation, float snap, AnimationCurve meshCurve = null)
        {
            this.position = position;
            this.rotation = rotation;
            this.orientation = orientation;
            this.snap = snap;
            this.meshCurve = meshCurve;
        }

        public RamControlPoint(Vector4 position = default, Quaternion rotation = default, float snap = default, AnimationCurve meshCurve = null)
        {
            this.position = position;
            this.rotation = rotation;
            this.snap = snap;
            this.meshCurve = meshCurve;
            this.orientation = Quaternion.identity;
        }


        public RamControlPoint(RamControlPoint ramControlPoint)
        {
            this.position = ramControlPoint.position;
            this.rotation = ramControlPoint.rotation;
            this.snap = ramControlPoint.snap;
            this.meshCurve = ramControlPoint.meshCurve;
            this.orientation = ramControlPoint.orientation;
        }
    }
}