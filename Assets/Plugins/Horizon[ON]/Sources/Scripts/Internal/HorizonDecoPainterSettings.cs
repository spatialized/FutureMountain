using UnityEngine;
using System.Collections.Generic;

namespace Horizon
{
    public class HorizonDecoPainterSettings : MonoBehaviour
    {
#if UNITY_EDITOR
        [HideInInspector] public bool objectMode;
        [HideInInspector] public GameObject parent;
        [HideInInspector] public int currentObjectCount;
        [HideInInspector] public int currentVertCount;
        [HideInInspector] public int currentTriangleCount;

        [HideInInspector] public List<GameObject> treePrefabs = new List<GameObject>();
        [HideInInspector] public List<GameObject> objectPrefabs = new List<GameObject>();

        [HideInInspector] public Vector2 sizeVariationMinMax = new Vector2(0.9f, 1.1f);
        public Vector2 sizeVariationMinMaxLimit = new Vector2(0.2f, 2);
        [HideInInspector] public float minPointDist = 5;
        [HideInInspector] public int brushSize = 2;
        [HideInInspector] public int oldBrushSize = 2;
        [HideInInspector] public float maxSteepness = 50;
        [HideInInspector] public float probability = 1;

        [HideInInspector] public bool pickRandom = false;
        [HideInInspector] public float scaleSensitivity = 1;
        [HideInInspector] public int selectedPrefab = 0;
#endif
    }
}