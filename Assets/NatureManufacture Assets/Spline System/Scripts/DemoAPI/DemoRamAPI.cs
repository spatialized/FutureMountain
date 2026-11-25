using UnityEngine;

namespace NatureManufacture.RAM
{
    //Demonstrates use of RamSpline API
    public class DemoRamAPI : MonoBehaviour
    {
        [SerializeField] private SplineProfile splineProfile;
        private RamSpline _ramSpline;
        [SerializeField] private TerrainPainterData terrainPainterData;
        private Camera _camera;


        // Setups spline and terrain painter data on start
        private void Start()
        {
            _camera = Camera.main;
            _ramSpline = RamSpline.CreateSpline(splineProfile.splineMaterial);
            _ramSpline.transform.SetParent(transform, true);
            _ramSpline.currentProfile = splineProfile;
            _ramSpline.BaseProfile.SetProfileData(_ramSpline.currentProfile);

            if (splineProfile.PainterData != null)
            {
                _ramSpline.BaseProfile.PainterData = splineProfile.PainterData;
                _ramSpline.RamTerrainManager.BasePainterData.SetProfileData(splineProfile.PainterData);
                _ramSpline.BaseProfile.PainterData.TerrainsUnder.Add(Terrain.activeTerrain);
            }


            if (terrainPainterData != null)
            {
                _ramSpline.BaseProfile.PainterData = terrainPainterData;
                _ramSpline.RamTerrainManager.BasePainterData.SetProfileData(terrainPainterData);
                _ramSpline.BaseProfile.PainterData.TerrainsUnder.Add(Terrain.activeTerrain);
            }
        }


        // Generates spline by adding points on mouse click and changes terrain
        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                // Debug.Log("MouseDown");

                if (_camera == null)
                {
                    Debug.Log("No main camera");
                    return;
                }

                if (AddPoint()) return;


                // Debug.Log("GenerateSpline");
                _ramSpline.GenerateSpline();

                ChangeTerrain();
            }
        }

        // Adds point to river spline on raycast hit
        private bool AddPoint()
        {
            Ray ray = _camera.ScreenPointToRay(Input.mousePosition);

            if (!Physics.Raycast(ray, out var hit)) return true;

            //Debug.Log("TerrainHit");
            _ramSpline.NmSpline.AddPoint(new Vector4(hit.point.x, hit.point.y, hit.point.z, _ramSpline.BaseProfile.width), false, _ramSpline.BaseProfile.width, _ramSpline.BaseProfile.meshCurve);

            return !_ramSpline.NmSpline.CanGenerateSpline();
        }

        // Carves and paints terrain according to terrainPainterData under river spline
        private void ChangeTerrain()
        {
            if (terrainPainterData == null || terrainPainterData.WorkTerrain == null) return;


            _ramSpline.RamTerrainManager.TerrainManager.CarveTerrain(_ramSpline.RamTerrainManager.BasePainterData);
            _ramSpline.RamTerrainManager.TerrainManager.PaintTerrain(_ramSpline.RamTerrainManager.BasePainterData);
            _ramSpline.GenerateSpline();
        }
    }
}