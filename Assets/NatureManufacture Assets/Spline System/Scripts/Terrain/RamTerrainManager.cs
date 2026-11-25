// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class RamTerrainManager
    {
        [SerializeField] private NmSpline nmNmSpline;

        private ITerrainPainterGetData _terrainPainterGetData;
        [SerializeField] private TerrainPainterData baseTerrainPainterData;
        [SerializeField] private TerrainPainterData terrainPainterGetDataOld;


        private TerrainManager _terrainManager;


        public NmSpline NmSpline
        {
            get => nmNmSpline;
            set => nmNmSpline = value;
        }


        public TerrainPainterData TerrainPainterGetData
        {
            get
            {
                _terrainPainterGetData ??= NmSpline.GetComponent<ITerrainPainterGetData>();

                return _terrainPainterGetData.PainterData;
            }
            set => _terrainPainterGetData.PainterData = value;
        }

        public TerrainPainterData BasePainterData
        {
            get
            {
                if (baseTerrainPainterData) return baseTerrainPainterData;


                baseTerrainPainterData = ScriptableObject.CreateInstance<TerrainPainterData>();
                if (TerrainPainterGetData)
                {
                    baseTerrainPainterData.SetProfileData(TerrainPainterGetData);
                }


                return baseTerrainPainterData;
            }
        }

        public TerrainPainterData TerrainPainterGetDataOld
        {
            get => terrainPainterGetDataOld;
            set => terrainPainterGetDataOld = value;
        }

        public TerrainManager TerrainManager
        {
            get { return _terrainManager ??= new TerrainManager(NmSpline.Transform.GetComponent<MeshFilter>()); }
        }

        public RamTerrainManager(NmSpline nmSpline, ITerrainPainterGetData terrainPainterGetData, RamTerrainManager ramTerrainManager) : this(nmSpline, terrainPainterGetData)
        {
            CopyProfile(ramTerrainManager.BasePainterData);
        }


        public RamTerrainManager(NmSpline nmNmSpline, ITerrainPainterGetData terrainPainterGetData)
        {
            //Debug.Log($"created RamTerrainManager with NmSpline: {nmNmSpline.gameObject.name} and ITerrainPainterGetData: {terrainPainterGetData}");

            _terrainPainterGetData = terrainPainterGetData;
            baseTerrainPainterData = ScriptableObject.CreateInstance<TerrainPainterData>();

            NmSpline = nmNmSpline;

            _terrainManager = new TerrainManager(NmSpline.Transform.GetComponent<MeshFilter>());
        }


        public void CopyProfile(TerrainPainterData terrainPainterData)
        {
            //Debug.Log($"Copied profile data from TerrainPainterData: {terrainPainterData}");
            baseTerrainPainterData.SetProfileData(terrainPainterData);
        }
    }
}