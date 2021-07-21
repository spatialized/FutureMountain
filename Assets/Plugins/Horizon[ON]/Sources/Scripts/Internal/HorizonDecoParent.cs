using UnityEngine;
using System.Collections.Generic;

namespace Horizon
{
    public class HorizonDecoParent : MonoBehaviour
    {
    #if UNITY_EDITOR
        public bool objectMode;
        public List<GameObject> gameObjects = new List<GameObject>();
        public List<Vector3> positions = new List<Vector3>();
        public List<Quaternion> rotations = new List<Quaternion>();
        public List<Vector3> scalings = new List<Vector3>();
    #endif
    }
}
