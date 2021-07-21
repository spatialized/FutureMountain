#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.Collections;

namespace Horizon {
	public class AddHorizonMenuItems : MonoBehaviour {

		static string scriptLocation;
		static string installPath;
        static string prefabsPath;

        static void GetInstallPath()
        {
            string[] temp = AssetDatabase.FindAssets("AddHorizonMenuItems t:Script");
            scriptLocation = AssetDatabase.GUIDToAssetPath(temp[0]);
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/AddHorizonMenuItems.cs", "");
            prefabsPath = installPath + "/Prefabs";
        }

        [MenuItem("Window/Horizon[ON]/Hide|Unhide Deco Painter Settings")]
        static void HideUnhideDecoPainterSettings()
        {
            GameObject saveSettingsGo = GameObject.Find("HorizonDecoPainterSettings");
            Debug.Log(saveSettingsGo);
            if (saveSettingsGo == null) return;
            else if (saveSettingsGo.hideFlags == HideFlags.HideInHierarchy)
            {
                saveSettingsGo.hideFlags = HideFlags.None;
                saveSettingsGo.transform.hideFlags = HideFlags.HideInInspector;
                Selection.activeGameObject = saveSettingsGo;
            }
            else if (saveSettingsGo.hideFlags == HideFlags.None)
            {
                saveSettingsGo.hideFlags = HideFlags.HideInHierarchy;
                if (Selection.activeGameObject == saveSettingsGo) Selection.activeGameObject = null;
            }
            EditorApplication.RepaintHierarchyWindow();
            EditorApplication.DirtyHierarchyWindowSorting();
        }

        //[MenuItem("Window/ListAllObjects")]
        //static void ListAllObjects()
        //{
        //    Object[] allObjects = FindObjectsOfType<Object>();
        //    foreach (object o in allObjects) Debug.Log(o);
        //}

        [MenuItem("GameObject/Horizon[ON]/Horizon[ON] Master", false, 1)]
		static void CreateHorizonONMaster(MenuCommand HorizonONMaster) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Horizon[ON].prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]";
			GameObjectUtility.SetParentAndAlign(go, HorizonONMaster.context as GameObject);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON]");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Transitions/Transition Terrain", false, 10)]
		static void CreateTransitionTerrain(MenuCommand TransitionTerrain) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Transitions/Horizon[ON]_Transition_Terrain.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Transition_Terrain";
			GameObjectUtility.SetParentAndAlign(go, TransitionTerrain.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Transition Terrain");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Transitions/Transition Sky", false, 10)]
		static void CreateTransitionSky(MenuCommand TransitionSky) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Transitions/Horizon[ON]_Transition_Sky.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Transition_Sky";
			GameObjectUtility.SetParentAndAlign(go, TransitionSky.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Transition Sky");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Patch 1", false, 10)]
		static void Create_Disp_Patch1(MenuCommand Disp_Patch1) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Patch1.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Patch1";
			GameObjectUtility.SetParentAndAlign(go, Disp_Patch1.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Patch 1");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Patch 2", false, 10)]
		static void Create_Disp_Patch2(MenuCommand Disp_Patch2) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Patch2.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Patch2";
			GameObjectUtility.SetParentAndAlign(go, Disp_Patch2.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Patch 2");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Patch 3", false, 10)]
		static void Create_Disp_Patch3(MenuCommand Disp_Patch3) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Patch3.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Patch3";
			GameObjectUtility.SetParentAndAlign(go, Disp_Patch3.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Patch 3");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Patch 4", false, 10)]
		static void Create_Disp_Patch4(MenuCommand Disp_Patch4) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Patch4.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Patch4";
			GameObjectUtility.SetParentAndAlign(go, Disp_Patch4.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Patch 4");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Plane", false, 10)]
		static void Create_Disp_Plane(MenuCommand Disp_Plane) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Plane.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Plane";
			GameObjectUtility.SetParentAndAlign(go, Disp_Plane.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Plane");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Ring Low", false, 10)]
		static void Create_Disp_Ring_Low(MenuCommand Disp_RingLow) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Ring_Low.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Ring_Low";
			GameObjectUtility.SetParentAndAlign(go, Disp_RingLow.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Ring Low");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Ring High", false, 10)]
		static void Create_Disp_Ring_High(MenuCommand Disp_RingHigh) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Ring_High.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Ring_High";
			GameObjectUtility.SetParentAndAlign(go, Disp_RingHigh.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Ring High");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes Displaced/Ring Ultra", false, 10)]
		static void Create_Disp_Ring_Ultra(MenuCommand Disp_RingUltra) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes Displaced/Horizon[ON]_Disp_Ring_Ultra.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Ring_Ultra";
			GameObjectUtility.SetParentAndAlign(go, Disp_RingUltra.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Displaced Ring Ultra");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes NonDisplaced/Hill Example", false, 10)]
		static void Create_HillExample(MenuCommand HillExample) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes NonDisplaced/Horizon[ON]_Hill_Example.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Hill_Example";
			GameObjectUtility.SetParentAndAlign(go, HillExample.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Hill Example");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/BlendMeshes NonDisplaced/Cliff Example", false, 10)]
		static void Create_CliffExample(MenuCommand CliffExample) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/BlendMeshes NonDisplaced/Horizon[ON]_Cliff_Example.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Cliff_Example";
			GameObjectUtility.SetParentAndAlign(go, CliffExample.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] BlendMesh Cliff Example");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Multi Level Arrangement/Displacement Level Start", false, 10)]
		static void Create_Disp_Level_Start(MenuCommand Disp_Level_Start) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Multi Level Arrangement/Horizon[ON]_Disp_Level_Start.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Level_Start";
			GameObjectUtility.SetParentAndAlign(go, Disp_Level_Start.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Multi Level Displaced Start");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Multi Level Arrangement/Displacement Level Regular", false, 10)]
		static void Create_Disp_Level_Regular(MenuCommand Disp_Level_Regular) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Multi Level Arrangement/Horizon[ON]_Disp_Level_Regular.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Level_Regular";
			GameObjectUtility.SetParentAndAlign(go, Disp_Level_Regular.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Multi Level Displaced Regular");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Multi Level Arrangement/Displacement Level End", false, 10)]
		static void Create_Disp_Level_End(MenuCommand Disp_Level_End) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Multi Level Arrangement/Horizon[ON]_Disp_Level_End.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Disp_Level_End";
			GameObjectUtility.SetParentAndAlign(go, Disp_Level_End.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Multi Level Displaced End");
        }
		[MenuItem("GameObject/Horizon[ON]/Horizon[ON] Elements/Multi Level Arrangement/Flat Level Regular", false, 10)]
		static void Create_Flat_Level_Regular(MenuCommand Flat_Level_Regular) {
            GetInstallPath();
            GameObject go = Instantiate(AssetDatabase.LoadAssetAtPath (prefabsPath + "/Multi Level Arrangement/Horizon[ON]_Flat_Level_Regular.prefab", typeof (GameObject))as GameObject)as GameObject;
			go.name = "Horizon[ON]_Flat_Level_Regular";
			GameObjectUtility.SetParentAndAlign(go, Flat_Level_Regular.context as GameObject);
			go.transform.localScale = new Vector3 (1000, 1000, 1000);
			Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
			Selection.activeObject = go;
            Refresh(go);
            Undo.RegisterCreatedObjectUndo(go, "Create Horizon[ON] Multi Level Flat");
        }

        static void Refresh(GameObject go)
        {
            go.SendMessageUpwards("InitLayerProps", SendMessageOptions.DontRequireReceiver);
            go.SendMessageUpwards("CheckMaterials", SendMessageOptions.DontRequireReceiver);
            go.SendMessageUpwards("UpdateHorizonMaster", SendMessageOptions.DontRequireReceiver);
            go.SendMessageUpwards("UpdateMaterials", SendMessageOptions.DontRequireReceiver);
        }
	}
}
#endif