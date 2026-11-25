using System.Linq;
using UnityEditorInternal;

namespace NatureManufacture.RAM.Editor
{
    using System.Collections;
    using System.Collections.Generic;
    using NatureManufacture.RAM;
    using UnityEditor;
    using UnityEngine;

    public class TerrainSplinesManager : EditorWindow
    {
        private readonly TerrainManager _terrainManager = new();
        private TerrainSplinesManagerDataHolder _dataHolder;

        private SerializedObject _serializedDataHolder;
        private ReorderableList _rlTerrainPainterObjects;
        private ReorderableList _rlPrepassTerrainPainterObjects;
        private SerializedProperty _terrainPainterData;

        private Vector2 _scrollPosition;

        [MenuItem("Tools/Nature Manufacture/Terrain Splines Manager")]
        public static void ShowWindow()
        {
            GetWindow<TerrainSplinesManager>("Terrain Splines Manager");
        }

        private void OnEnable()
        {
            GetDataObject();
        }

        private void GetDataObject()
        {
            GameObject dataHolderObject = GameObject.Find("TerrainSplineDataHolder");

            if (dataHolderObject == null)
            {
                dataHolderObject = new GameObject("TerrainSplineDataHolder");
            }

            // This makes the GameObject hidden in the hierarchy
            dataHolderObject.hideFlags = HideFlags.HideInHierarchy | HideFlags.DontSaveInBuild;
            //dataHolderObject.hideFlags = HideFlags.None;

            _dataHolder = dataHolderObject.GetComponent<TerrainSplinesManagerDataHolder>();

            if (_dataHolder == null)
            {
                _dataHolder = dataHolderObject.AddComponent<TerrainSplinesManagerDataHolder>();
            }

            _serializedDataHolder = new SerializedObject(_dataHolder);
            _terrainPainterData = _serializedDataHolder.FindProperty("terrainPainterData");

            _rlTerrainPainterObjects = new ReorderableList(_serializedDataHolder, _serializedDataHolder.FindProperty("terrainPainterObjects"), true, true, true, true)
            {
                drawHeaderCallback = (Rect rect) => { EditorGUI.LabelField(rect, "Terrain Splines"); },

                drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
                {
                    SerializedProperty element = _rlTerrainPainterObjects.serializedProperty.GetArrayElementAtIndex(index);
                    rect.y += 2;
                    EditorGUI.PropertyField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), element, GUIContent.none);
                }
            };

            _rlPrepassTerrainPainterObjects = new ReorderableList(_serializedDataHolder, _serializedDataHolder.FindProperty("terrainPainterObjectsPrepass"), true, true, true, true)
            {
                drawHeaderCallback = (Rect rect) => { EditorGUI.LabelField(rect, $"Prepass Terrain Splines"); },

                drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
                {
                    SerializedProperty element = _rlPrepassTerrainPainterObjects.serializedProperty.GetArrayElementAtIndex(index);
                    rect.y += 2;
                    EditorGUI.PropertyField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), element, GUIContent.none);
                },
            };
        }

        private void OnGUI()
        {
            if (_serializedDataHolder.targetObject == null)
            {
                GetDataObject();
                return;
            }


            _serializedDataHolder.Update();
            _scrollPosition = EditorGUILayout.BeginScrollView(_scrollPosition);

            EditorGUILayout.Space();


            _rlPrepassTerrainPainterObjects.DoLayoutList();
            _rlTerrainPainterObjects.DoLayoutList();


            //get only terrain splines
            if (GUILayout.Button("Get Only Terrain Splines"))
            {
                TerrainSpline[] terrainSplines = FindObjectsByType<TerrainSpline>(FindObjectsSortMode.None);
                _dataHolder.TerrainPainterObjects.Clear();
                _dataHolder.AddRangeWithoutDuplicates(terrainSplines);
                _dataHolder.SortAndCheckList();
                _serializedDataHolder.Update();
            }

            //get only lake polygons
            if (GUILayout.Button("Get Only Lake Polygons"))
            {
                LakePolygon[] lakePolygons = FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);
                _dataHolder.TerrainPainterObjects.Clear();
                _dataHolder.AddRangeWithoutDuplicates(lakePolygons);
                _dataHolder.SortAndCheckList();
                _serializedDataHolder.Update();
            }

            //get only ram splines
            if (GUILayout.Button("Get Only Ram Splines"))
            {
                RamSpline[] ramSplines = FindObjectsByType<RamSpline>(FindObjectsSortMode.None);
                _dataHolder.TerrainPainterObjects.Clear();
                _dataHolder.AddRangeWithoutDuplicates(ramSplines);
                _dataHolder.SortAndCheckList();
                _serializedDataHolder.Update();
            }


            if (GUILayout.Button("Get All Spline Painters"))
            {
                TerrainSpline[] terrainSplines = FindObjectsByType<TerrainSpline>(FindObjectsSortMode.None);
                LakePolygon[] lakePolygons = FindObjectsByType<LakePolygon>(FindObjectsSortMode.None);
                RamSpline[] ramSplines = FindObjectsByType<RamSpline>(FindObjectsSortMode.None);


                _dataHolder.TerrainPainterObjects.Clear();
                _dataHolder.AddRangeWithoutDuplicates(terrainSplines);
                _dataHolder.AddRangeWithoutDuplicates(lakePolygons);
                _dataHolder.AddRangeWithoutDuplicates(ramSplines);
                _dataHolder.SortAndCheckList();
                _serializedDataHolder.Update();
            }

            if (GUILayout.Button("Clear All Spline Painters"))
            {
                _dataHolder.TerrainPainterObjects.Clear();
                _serializedDataHolder.Update();
            }


            EditorGUILayout.Space();


            if (GUILayout.Button("Paint All Terrain Splines"))
            {
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to paint all terrains?", "Yes", "No"))
                {
                    PaintPrepassTerrainSplines();
                    PaintAllTerrainSplines();
                }
            }

            if (GUILayout.Button("Carve All Terrains"))
            {
                // Display a confirmation dialog
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to carve all terrains?", "Yes", "No"))
                {
                    CarvePrepassTerrains();
                    CarveAllTerrains();
                }
            }

            if (GUILayout.Button("Carve All Terrains Grouped by Terrain Painter Data"))
            {
                // Display a confirmation dialog
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to carve all terrains?", "Yes", "No"))
                {
                    CarvePrepassTerrains();
                    CarveAllTerrainsGrouped();
                }
            }

            if (GUILayout.Button("Carve All Terrains Grouped by Rivers"))
            {
                // Display a confirmation dialog
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to carve all terrains?", "Yes", "No"))
                {
                    CarvePrepassTerrains();
                    CarveAllTerrainsGroupedRivers();
                }
            }

            EditorGUILayout.Space();

            EditorGUILayout.PropertyField(_terrainPainterData, true);

            if (GUILayout.Button("Paint All Terrain Splines With Painter Data"))
            {
                // Display a confirmation dialog
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to paint all terrains?", "Yes", "No"))
                {
                    if (PrepareForTerrainData(_dataHolder.TerrainPainterGetDataObjects))
                        _terrainManager.PaintTerrain(_dataHolder.PainterData);
                }
            }

            if (GUILayout.Button("Carve All Terrains With Painter Data"))
            {
                // Display a confirmation dialog
                if (EditorUtility.DisplayDialog("Confirmation", "Are you sure you want to carve all terrains?", "Yes", "No"))
                {
                    if (PrepareForTerrainData(_dataHolder.TerrainPainterGetDataObjects))
                        _terrainManager.CarveTerrain(_dataHolder.PainterData);
                }
            }

            EditorGUILayout.EndScrollView();
            _serializedDataHolder.ApplyModifiedProperties();
        }

       

        private void CarveAllTerrainsGrouped()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjects;

            // Group ITerrainPainterGetData by painter data
            Dictionary<TerrainPainterData, List<ITerrainPainterGetData>> groupedTerrainPainterDatas = new();
            foreach (ITerrainPainterGetData terrainPainterData in terrainPainterDatas)
            {
                if (PrepareTerrainSpline(terrainPainterData)) continue;

                TerrainPainterData painterData = GetTerrainPainterData(terrainPainterData);

                if (!groupedTerrainPainterDatas.ContainsKey(painterData))
                {
                    groupedTerrainPainterDatas.Add(painterData, new List<ITerrainPainterGetData>());
                }

                groupedTerrainPainterDatas[painterData].Add(terrainPainterData);
            }

            List<List<ITerrainPainterGetData>> terrainPainterDatasList = groupedTerrainPainterDatas.Values.ToList();

            CarveGroups(terrainPainterDatasList, TerrainManager.PaintHeightPasses.CarveTerrainMax);
            CarveGroups(terrainPainterDatasList, TerrainManager.PaintHeightPasses.CarveTerrainMin);

            EditorUtility.ClearProgressBar();
        }

        private static TerrainPainterData GetTerrainPainterData(ITerrainPainterGetData terrainPainterData)
        {
            TerrainPainterData painterData = terrainPainterData.RamTerrainManager.TerrainPainterGetData;
            if (painterData == null)
                painterData = terrainPainterData.RamTerrainManager.BasePainterData;
            return painterData;
        }

        private void CarveAllTerrainsGroupedRivers()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjects;

            // Group ITerrainPainterGetData by painter data

            List<List<ITerrainPainterGetData>> terrainPainterDatasList = new();

            foreach (ITerrainPainterGetData terrainPainterData in terrainPainterDatas)
            {
                if (PrepareTerrainSpline(terrainPainterData)) continue;

                RamSpline ramSpline = terrainPainterData.GetTransform.gameObject.GetComponent<RamSpline>();

                if (ramSpline == null)
                {
                    terrainPainterDatasList.Add(new List<ITerrainPainterGetData> { terrainPainterData });
                }
                else
                {
                    //check if terrainPainterData is in some list
                    bool isAdded = false;
                    foreach (List<ITerrainPainterGetData> terrainPainterDataCheck in terrainPainterDatasList)
                    {
                        if (!terrainPainterDataCheck.Contains(terrainPainterData)) continue;

                        isAdded = true;
                        break;
                    }

                    if (isAdded) continue;

                    List<ITerrainPainterGetData> ramTerrainPainterGetDatas = new();

                    AddConnectedRamSplines(ramSpline, ramTerrainPainterGetDatas);

                    terrainPainterDatasList.Add(ramTerrainPainterGetDatas);
                }
            }



            CarveGroups(terrainPainterDatasList, TerrainManager.PaintHeightPasses.CarveTerrainMax);
            CarveGroups(terrainPainterDatasList, TerrainManager.PaintHeightPasses.CarveTerrainMin);

            EditorUtility.ClearProgressBar();
        }

        private void AddConnectedRamSplines(RamSpline ramSpline, List<ITerrainPainterGetData> ramTerrainPainterGetDatas)
        {
            if (ramTerrainPainterGetDatas.Contains(ramSpline))
                return;

            if (!PrepareTerrainSpline(ramSpline))
                ramTerrainPainterGetDatas.Add(ramSpline);

            foreach (RamSpline connectedRamSpline in ramSpline.beginningChildSplines)
            {
                AddConnectedRamSplines(connectedRamSpline, ramTerrainPainterGetDatas);
            }

            foreach (RamSpline connectedRamSpline in ramSpline.endingChildSplines)
            {
                AddConnectedRamSplines(connectedRamSpline, ramTerrainPainterGetDatas);
            }
        }


        private void CarveGroups(List<List<ITerrainPainterGetData>> groupedTerrainPainterDatas, TerrainManager.PaintHeightPasses pass = TerrainManager.PaintHeightPasses.CarveTerrain)
        {
            int countGroups = 0;
            foreach (var terrainPainterDatas in groupedTerrainPainterDatas)
            {
                if (terrainPainterDatas.Count == 0) continue;

                TerrainPainterData painterData = GetTerrainPainterData(terrainPainterDatas[0]);

                float progress = (float)countGroups / groupedTerrainPainterDatas.Count;
                if (EditorUtility.DisplayCancelableProgressBar($"Carving progress {painterData.name} ", $"Carving {countGroups + 1}/{groupedTerrainPainterDatas.Count}", progress))
                {
                    // If the user clicked the Cancel button, break out of the loop
                    break;
                }

                if (PrepareForTerrainData(terrainPainterDatas))
                {
                    painterData.TerrainsUnder.Clear();
                    painterData.TerrainsUnder.AddRange(_dataHolder.PainterData.TerrainsUnder);

                    _terrainManager.CarveTerrain(painterData, pass);
                }

                countGroups++;
            }
        }

        private void CarvePrepassTerrains()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjectsPrepass;
            CarveTerrains(terrainPainterDatas, TerrainManager.PaintHeightPasses.CarveTerrainMax);
            CarveTerrains(terrainPainterDatas, TerrainManager.PaintHeightPasses.CarveTerrainMin);
            EditorUtility.ClearProgressBar();
        }

        private void CarveAllTerrains()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjects;
            CarveTerrains(terrainPainterDatas, TerrainManager.PaintHeightPasses.CarveTerrainMax);
            CarveTerrains(terrainPainterDatas, TerrainManager.PaintHeightPasses.CarveTerrainMin);
            EditorUtility.ClearProgressBar();
        }

        private void CarveTerrains(List<ITerrainPainterGetData> terrainPainterDatas, TerrainManager.PaintHeightPasses pass = TerrainManager.PaintHeightPasses.CarveTerrain)
        {
            for (int i = 0; i < terrainPainterDatas.Count; i++)
            {
                ITerrainPainterGetData terrainSpline = terrainPainterDatas[i];

                if (PrepareTerrainSpline(terrainSpline)) continue;

                _terrainManager.CarveTerrain(terrainSpline.RamTerrainManager.BasePainterData, pass);

                // Calculate progress as a float between 0 and 1 and display it
                float progress = (float)i / terrainPainterDatas.Count;
                if (EditorUtility.DisplayCancelableProgressBar($"Carving progress {terrainSpline.RamTerrainManager.NmSpline.name}", $"Carving {i + 1}/{terrainPainterDatas.Count}", progress))
                {
                    // If the user clicked the Cancel button, break out of the loop
                    break;
                }
            }
        }
        
        private void PaintPrepassTerrainSplines()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjectsPrepass;

            for (int i = 0; i < terrainPainterDatas.Count; i++)
            {
                ITerrainPainterGetData terrainSpline = terrainPainterDatas[i];

                if (PrepareTerrainSpline(terrainSpline)) continue;

                _terrainManager.PaintTerrain(terrainSpline.RamTerrainManager.BasePainterData);

                // Calculate progress as a float between 0 and 1 and display it
                float progress = (float)i / terrainPainterDatas.Count;
                if (EditorUtility.DisplayCancelableProgressBar("Painting prepass", $"Painting {i + 1}/{terrainPainterDatas.Count}", progress))
                {
                    // If the user clicked the Cancel button, break out of the loop
                    break;
                }
            }

            EditorUtility.ClearProgressBar();
        }

        private void PaintAllTerrainSplines()
        {
            List<ITerrainPainterGetData> terrainPainterDatas = _dataHolder.TerrainPainterGetDataObjects;

            for (int i = 0; i < terrainPainterDatas.Count; i++)
            {
                ITerrainPainterGetData terrainSpline = terrainPainterDatas[i];

                if (PrepareTerrainSpline(terrainSpline)) continue;

                _terrainManager.PaintTerrain(terrainSpline.RamTerrainManager.BasePainterData);

                // Calculate progress as a float between 0 and 1 and display it
                float progress = (float)i / terrainPainterDatas.Count;
                if (EditorUtility.DisplayCancelableProgressBar("Painting progress", $"Painting {i + 1}/{terrainPainterDatas.Count}", progress))
                {
                    // If the user clicked the Cancel button, break out of the loop
                    break;
                }
            }

            EditorUtility.ClearProgressBar();
        }

        private bool PrepareForTerrainData(List<ITerrainPainterGetData> terrainPainterDatas)
        {
            _terrainManager.MeshFilters.Clear();
            HashSet<Terrain> terrainsUnder = new();
            for (int i = 0; i < terrainPainterDatas.Count; i++)
            {
                ITerrainPainterGetData terrainSpline = terrainPainterDatas[i];
                if (terrainSpline == null) continue;

                terrainSpline.GenerateForTerrain();

                if (terrainSpline.MainMeshFilter == null) continue;
                _terrainManager.MeshFilters.Add(terrainSpline.MainMeshFilter);

                if (terrainSpline.RamTerrainManager.BasePainterData != null)
                    terrainsUnder.UnionWith(terrainSpline.RamTerrainManager.BasePainterData.TerrainsUnder);
            }

            if (_terrainManager.MeshFilters.Count <= 0 || terrainsUnder.Count <= 0) return false;


            if (_dataHolder.PainterData == null)
                _dataHolder.PainterData = ScriptableObject.CreateInstance<TerrainPainterData>();

            _dataHolder.PainterData.TerrainsUnder.Clear();
            _dataHolder.PainterData.TerrainsUnder.AddRange(terrainsUnder);
            return true;
        }


        private bool PrepareTerrainSpline(ITerrainPainterGetData terrainSpline)
        {
            if (terrainSpline == null) return true;

            terrainSpline.GenerateForTerrain();

            if (CheckTerrainSpline(terrainSpline)) return true;

            _terrainManager.MeshFilters.Clear();
            _terrainManager.MeshFilters.Add(terrainSpline.MainMeshFilter);
            return false;
        }

        private static bool CheckTerrainSpline(ITerrainPainterGetData terrainSpline)
        {
            if (terrainSpline.MainMeshFilter == null)
                return true;
            if (terrainSpline.RamTerrainManager.BasePainterData == null)
                return true;

            return terrainSpline.RamTerrainManager.BasePainterData.TerrainsUnder.Count == 0;
        }
    }
}