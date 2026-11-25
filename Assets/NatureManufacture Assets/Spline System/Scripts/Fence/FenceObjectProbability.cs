// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using UnityEngine;

namespace NatureManufacture.RAM
{
    [System.Serializable]
    public class FenceObjectProbability
    {
        public GameObject gameObject;
        public float probability = 1;

        public FenceAxis.AlignAxis forward = FenceAxis.AlignAxis.XAxis;
        public FenceAxis.AlignAxis up = FenceAxis.AlignAxis.YAxis;

        public Vector3 positionOffset;
        public Vector3 rotationOffset;
        public Vector3 scaleOffset = Vector3.one;

        public enum EnumBoundsType
        {
            MeshRenderer,
            MeshFilter,
            Custom
        }

        [field: SerializeField] public EnumBoundsType BoundsType { get; set; } = EnumBoundsType.MeshFilter;
        [field: SerializeField] public Vector3 CustomBoundsSize { get; set; } = Vector3.one;
        
        public Vector3 PositionOffset => positionOffset.y * GetRemappedUp() + positionOffset.z * GetRemappedForward() + positionOffset.x * GetRemappedRight();

        public enum MirrorType
        {
            None,
            Mirror,
            EndOffset
        }

        public MirrorType mirror;


        //contructor no paramaters with default values
        public FenceObjectProbability()
        {
            Reset();
        }

        //copy constructor
        public FenceObjectProbability(FenceObjectProbability other)
        {
            gameObject = other.gameObject;
            probability = other.probability;
            forward = other.forward;
            up = other.up;
            positionOffset = other.positionOffset;
            rotationOffset = other.rotationOffset;
            scaleOffset = other.scaleOffset;
            mirror = other.mirror;
            BoundsType = other.BoundsType;
            CustomBoundsSize = other.CustomBoundsSize;
        }

        public void Reset()
        {
            gameObject = null;
            probability = 1;
            forward = FenceAxis.AlignAxis.XAxis;
            up = FenceAxis.AlignAxis.YAxis;
            positionOffset = Vector3.zero;
            rotationOffset = Vector3.zero;
            scaleOffset = Vector3.one;
            mirror = MirrorType.None;
            BoundsType = EnumBoundsType.MeshFilter;
            CustomBoundsSize = Vector3.one;
        }

        public Quaternion GetRotation()
        {
            Vector3 remappedForward = GetRemappedForward();
            Vector3 remappedUp = GetRemappedUp();
            Quaternion rotation = Quaternion.Inverse(Quaternion.LookRotation(remappedForward, remappedUp));

            return rotation;
        }

        public Vector3 GetRemappedUp()
        {
            Vector3 remappedUp = FenceAxis.GetAxis(up);
            return remappedUp;
        }

        public Vector3 GetRemappedForward()
        {
            Vector3 remappedForward = FenceAxis.GetAxis(forward);
            return remappedForward;
        }

        public Vector3 GetRemappedRight()
        {
            Vector3 remappedRight = Vector3.Cross(GetRemappedForward(), GetRemappedUp());
            return remappedRight;
        }
    }
}