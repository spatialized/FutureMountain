using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class RamBuoyancyCalculations
    {
        private GameObject _lastGameObject;
        private RamSpline _lastRamSpline;
        private LakePolygon _lastLakePolygon;
        private Waterfall _lastWaterfall;
        private List<Vector2> _uvs3 = new(100);
        private List<int> _triangles = new(100);
        private List<Vector3> _vertices = new(100);

        public bool IsOverWater => _lastRamSpline != null || _lastLakePolygon != null || _lastWaterfall != null;

        public (Vector3 floatSpeed, float physicalDensity) GetFloatSpeedAndDensity(int triangleIndex, bool isSea, bool debug = false)
        {
            Vector3 baseProfileFloatSpeed = Vector3.zero;
            float physicalDensity = 1;
            Vector3 verticeDirection;

            int verticeId1 = _triangles[triangleIndex * 3];
            Vector2 uv3 = -_uvs3[verticeId1];
            float baseYAngle = 0;

            float floatSpeedWaterfallMultiplier = 1;

            if (_lastWaterfall)
            {
                verticeDirection = _lastWaterfall.VerticeDirection[verticeId1];
                baseYAngle = verticeDirection.y;

                verticeDirection = verticeDirection * -uv3.y - new Vector3(verticeDirection.z, verticeDirection.y, -verticeDirection.x) * uv3.x;

                baseProfileFloatSpeed = new Vector3(verticeDirection.x, verticeDirection.y, verticeDirection.z) * _lastWaterfall.BaseProfile.FloatSpeed;
                // if (debug)
                //      Debug.Log($" _lastWaterfall BaseProfileFloatSpeed: {baseProfileFloatSpeed}", _lastGameObject);

                floatSpeedWaterfallMultiplier = _lastWaterfall.BaseProfile.FloatSpeedWaterfallMultiplier;

                physicalDensity = _lastWaterfall.BaseProfile.PhysicalDensity;
                if (debug)
                    Debug.DrawRay(_lastGameObject.transform.TransformPoint(_vertices[verticeId1]) + Vector3.up * 0.1f, baseProfileFloatSpeed * 10f, Color.red);
            }
            else if (_lastLakePolygon && isSea)
            {
                verticeDirection = new Vector3(uv3.x, 0, uv3.y);
                baseYAngle = 0;
                baseProfileFloatSpeed = verticeDirection * _lastLakePolygon.BaseProfile.floatSpeed;
                physicalDensity = _lastLakePolygon.BaseProfile.physicalDensity;
                
                if (debug)
                    Debug.Log($"verticeDirection {verticeDirection} baseProfileFloatSpeed {baseProfileFloatSpeed} physicalDensity {physicalDensity}");
                
                if (debug)
                    Debug.DrawRay(_lastGameObject.transform.TransformPoint(_vertices[verticeId1]) + Vector3.up * 0.1f, baseProfileFloatSpeed * 10f, Color.cyan);
            }
            else if (_lastRamSpline)
            {
                verticeDirection = _lastRamSpline.verticeDirection[verticeId1];
                baseYAngle = verticeDirection.y;


                verticeDirection = verticeDirection * uv3.y - new Vector3(verticeDirection.z, verticeDirection.y, -verticeDirection.x) * uv3.x;

                baseProfileFloatSpeed = new Vector3(-verticeDirection.x, -verticeDirection.y, -verticeDirection.z) * _lastRamSpline.BaseProfile.floatSpeed;

                floatSpeedWaterfallMultiplier = _lastRamSpline.BaseProfile.floatSpeedWaterfallMultiplier;

                physicalDensity = _lastRamSpline.BaseProfile.physicalDensity;
                if (debug)
                    Debug.DrawRay(_lastGameObject.transform.TransformPoint(_vertices[verticeId1]) + Vector3.up * 0.1f, baseProfileFloatSpeed * 10f, Color.green);
            }
            else if (_lastLakePolygon)
            {
                verticeDirection = new Vector3(uv3.x, 0, uv3.y);
                baseYAngle = 0;
                baseProfileFloatSpeed = verticeDirection * _lastLakePolygon.BaseProfile.floatSpeed;
                physicalDensity = _lastLakePolygon.BaseProfile.physicalDensity;
                if (debug)
                    Debug.DrawRay(_lastGameObject.transform.TransformPoint(_vertices[verticeId1]) + Vector3.up * 0.1f, baseProfileFloatSpeed * 10f, Color.blue);
            }

            //[NMTODO] check water speed on angles

            float angleSpeed = Mathf.Lerp(1, floatSpeedWaterfallMultiplier, Mathf.Clamp01(-baseYAngle));

            baseProfileFloatSpeed *= angleSpeed;


            return (baseProfileFloatSpeed, physicalDensity);
        }

        public void GetMeshData(GameObject waterGameObject, bool isSea)
        {
            if (_lastGameObject == waterGameObject) return;

            waterGameObject.TryGetComponent(out _lastRamSpline);
            waterGameObject.TryGetComponent(out _lastLakePolygon);
            waterGameObject.TryGetComponent(out _lastWaterfall);

            Mesh mesh = null;
            if (_lastWaterfall != null)
            {
                mesh = _lastWaterfall.MainMeshFilter.sharedMesh;
            }

            else if (_lastLakePolygon != null && isSea)
            {
                mesh = _lastLakePolygon.meshFilter.sharedMesh;
            }
            else if (_lastRamSpline != null)
            {
                mesh = _lastRamSpline.meshFilter.sharedMesh;
            }
            else if (_lastLakePolygon != null)
            {
                mesh = _lastLakePolygon.meshFilter.sharedMesh;
            }


            if (mesh == null) return;


            mesh.GetTriangles(_triangles, 0);
            mesh.GetUVs(3, _uvs3);
            mesh.GetVertices(_vertices);

            _lastGameObject = waterGameObject;
        }
    }
}