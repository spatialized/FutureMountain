using UnityEngine;
using UnityEditor;

namespace DynamicFogAndMist
{
	[CustomEditor (typeof(DynamicFogOfWarHole))]
	public class DynamicFogOfWarHoleEditor : Editor
	{
		
		public override void OnInspectorGUI ()
		{
			EditorGUILayout.Separator ();
			EditorGUILayout.HelpBox ("Use the transform to position/scale the hole. Customize global fog of war properties in Volumetric Fog script attached to the camera or the fog script specified below.", MessageType.Info);
			DrawDefaultInspector ();
		}


		[MenuItem("GameObject/Create Other/Dynamic Fog/Fog Of War Hole")]
		static void CreateFogOfWarHole(MenuCommand menuCommand) {
			GameObject hole = new GameObject("Dynamic Fog Of War Hole");
			hole.transform.localScale = new Vector3(35f, 1f, 35f);
			hole.AddComponent<DynamicFogOfWarHole>();
			Undo.RegisterCreatedObjectUndo(hole, "Create Fog Of War Hole");
			Selection.activeObject = hole;
		}

	}


}
