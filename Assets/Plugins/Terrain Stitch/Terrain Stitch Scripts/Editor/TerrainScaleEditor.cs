using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace TerrainStitch
{
	/// <summary>
	/// Terrain scale editor.
	/// </summary>
	public class TerrainScaleEditor : EditorWindow
	{
		/// <summary>
		/// The new height.
		/// </summary>
		float newHeight = 600f;
		/// <summary>
		/// The new height offset.
		/// </summary>
		float offset = 0f;


		/// <summary>
		/// Init this instance.
		/// </summary>
		[MenuItem ("Tools/Terrain Scaler")]
		static void Init ()
		{
			EditorWindow.GetWindow (typeof(TerrainScaleEditor), false, "Terrain Scaler");
		}

		/// <summary>
		/// Raises the GU event.
		/// </summary>
		void OnGUI ()
		{
				

			GUILayout.Label ("Base Settings", EditorStyles.boldLabel);

			newHeight = EditorGUILayout.FloatField ("New height", newHeight);
			offset = EditorGUILayout.FloatField ("Offset", offset);

			EditorGUILayout.Space ();

			if (GUILayout.Button ("Rescale selected terrains")) {
				RescaleTerrain (true);
			}

			if (GUILayout.Button ("Rescale all terrains")) {
				RescaleTerrain (false);
			}

		}

		/// <summary>
		/// Rescales the terrain.
		/// </summary>
		void RescaleTerrain (bool selected)
		{
			List<Terrain> terrains = new List<Terrain> ();
			if (selected) {
				foreach (var item in Selection.gameObjects) {
					Terrain terrain = item.GetComponent<Terrain> ();
					if (terrain != null)
						terrains.Add (terrain);
				}
			} else
				terrains.AddRange (Terrain.activeTerrains);

			foreach (var t in terrains) {
				Undo.RegisterUndo (t.terrainData, "Rescale terrains");
			}

			foreach (var terrain in terrains) {
				TerrainData terrainData = terrain.terrainData;

				float[,] heights = terrainData.GetHeights (0, 0, terrainData.heightmapResolution, terrainData.heightmapResolution);
				Vector3 terrainSize = terrainData.size;
				float scale = (float)terrainSize.y / (float)newHeight;
				float offestScaled = offset / (float)newHeight;
				terrainSize.y = newHeight;
				terrainData.size = terrainSize;
				terrain.Flush ();
				for (int i = 0; i < heights.GetLength (0); i++) {
					for (int j = 0; j < heights.GetLength (1); j++) {
						heights [i, j] = heights [i, j] * scale + offestScaled;
					}
				}
				terrainData.SetHeights (0, 0, heights);
				terrain.terrainData = terrainData;
				terrain.Flush ();
			}


		
		}
	}
}