using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using UnityEditor.SceneManagement;

[CustomEditor (typeof(SnowManager))]
public class SnowManagerEditor : Editor
{
	bool playing = false;

	void OnEnable ()
	{

		SnowManager t = (SnowManager)target;

		Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (t.snowValue * t.snowGrassValue, 0, t.snowGrassValueMax));
		Shader.SetGlobalFloat ("_Season", Mathf.Clamp (t.seasonValue, 0, 4));

		Shader.SetGlobalTexture ("_SnowTex", t.snowGrassTex);

		foreach (var item in t.materials) {
			if (item != null) {
				item.SetFloat ("_Snow_Amount", t.snowValue);
				item.SetFloat ("_Season", t.seasonValue);
			}
		}

		if (t.snowValue > t.particleTurnOn) {
			foreach (var item in t.particles) {
				if (item != null && !item.gameObject.activeSelf)
					item.gameObject.SetActive (true);
			}
		} else {
			foreach (var item in t.particles) {
				if (item != null && item.gameObject.activeSelf)
					item.gameObject.SetActive (false);
			}
		}


	}

	public override void OnInspectorGUI ()
	{
		SnowManager t = (SnowManager)target;

		if (playing == true && playing != EditorApplication.isPlaying) {

			Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (t.snowValue * t.snowGrassValue, 0, t.snowGrassValueMax));
			Shader.SetGlobalFloat ("_Season", Mathf.Clamp (t.seasonValue, 0, 4));
			Shader.SetGlobalTexture ("_SnowTex", t.snowGrassTex);

			foreach (var item in t.materials) {
				if (item != null) {
					item.SetFloat ("_Snow_Amount", t.snowValue);
					item.SetFloat ("_Season", t.seasonValue);
				}
			}

			if (t.snowValue > t.particleTurnOn) {
				foreach (var item in t.particles) {
					if (item != null && !item.gameObject.activeSelf)
						item.gameObject.SetActive (true);
				}
			} else {
				foreach (var item in t.particles) {
					if (item != null && item.gameObject.activeSelf)
						item.gameObject.SetActive (false);
				}
			}
		}
		playing = EditorApplication.isPlaying;
	
		EditorGUILayout.Space ();
		EditorGUILayout.LabelField ("Materials:", EditorStyles.boldLabel);


		EditorGUI.indentLevel += 1;

		if (t.particles == null)
			t.particles = new List<ParticleSystem> ();
		if (t.materials == null)
			t.materials = new List<Material> ();

		t.materialsCollapsed = EditorGUILayout.Foldout (t.materialsCollapsed, "Materials " + t.materialsSize + ": ");
		if (t.materialsCollapsed) {
			EditorGUI.indentLevel++;
			t.materialsSize = EditorGUILayout.IntField ("size", t.materialsSize);
			if (t.materialsSize != t.materials.Count) {
				Undo.RecordObject (t, "Material size change");
				while (t.materialsSize > t.materials.Count) {
					
					t.materials.Add (null);
				}
				while (t.materialsSize < t.materials.Count) {
					t.materials.RemoveAt (t.materials.Count - 1);
				}
			}
			for (int i = 0; i < t.materials.Count; i++) {
				t.materials [i] = (Material)EditorGUILayout.ObjectField ("Material:", t.materials [i], typeof(Material), false);
			}
			EditorGUI.indentLevel--;
		}

		t.particlesCollapsed = EditorGUILayout.Foldout (t.particlesCollapsed, "Particle Systems " + t.particlesSize + ": ");
		if (t.particlesCollapsed) {
			EditorGUI.indentLevel++;
			t.particlesSize = EditorGUILayout.IntField ("size", t.particlesSize);
			if (t.particlesSize != t.particles.Count) {
				Undo.RecordObject (t, "Particles size change");
				while (t.particlesSize > t.particles.Count) {
					t.particles.Add (null);
				}
				while (t.particlesSize < t.particles.Count) {
					t.particles.RemoveAt (t.particles.Count - 1);
				}
			}
			for (int i = 0; i < t.particles.Count; i++) {
				t.particles [i] = (ParticleSystem)EditorGUILayout.ObjectField ("Particle System:", t.particles [i], typeof(ParticleSystem), true);
			}
			EditorGUI.indentLevel--;
		}



		t.snowValue = EditorGUILayout.Slider ("Snow Amount", t.snowValue, 0, 2);
		if (t.snowValue != t.snowValueOld) {

			Undo.RecordObject (t, "Snow amount change");
			t.snowValueOld = t.snowValue;

			Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (t.snowValue * t.snowGrassValue, 0, t.snowGrassValueMax));

			foreach (var item in t.materials) {
				if (item != null)
					item.SetFloat ("_Snow_Amount", t.snowValue);
			}

			if (t.snowValue > t.particleTurnOn) {
				foreach (var item in t.particles) {
					if (item != null && !item.gameObject.activeSelf)
						item.gameObject.SetActive (true);
				}
			} else {
				foreach (var item in t.particles) {
					if (item != null && item.gameObject.activeSelf)
						item.gameObject.SetActive (false);
				}
			}

			SceneView.RepaintAll ();

		}

		t.seasonValue = EditorGUILayout.Slider ("Season", t.seasonValue, 0, 4);
		if (t.seasonValue != t.seasonValueOld) {
			


			Shader.SetGlobalFloat ("_Season", Mathf.Clamp (t.seasonValue, 0, 4));
			foreach (var item in t.materials) {
				if (item != null)
					item.SetFloat ("_Season", t.seasonValue);
			}
			t.seasonValueOld = t.seasonValue;
		}

		EditorGUI.indentLevel -= 1;

		EditorGUILayout.Space ();

		EditorGUILayout.LabelField ("Grass:", EditorStyles.boldLabel);


		EditorGUI.indentLevel += 1;

		t.snowGrassValue = EditorGUILayout.Slider ("Snow Amount Grass", t.snowGrassValue, 0, 2);
		t.snowGrassValueMax = EditorGUILayout.Slider ("Snow Amount Grass Max", t.snowGrassValueMax, 0, 1);

		if (t.snowGrassValue != t.snowGrassValueOld || t.snowGrassValueMax != t.snowGrassValueOldMax) {

			Undo.RecordObject (t, "Snow amount grass change");
			t.snowGrassValueOld = t.snowGrassValue;
			t.snowGrassValueOldMax = t.snowGrassValueMax;
			Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (t.snowValue * t.snowGrassValue, 0, t.snowGrassValueMax));
			SceneView.RepaintAll ();
		}

		t.snowGrassTex = (Texture2D)EditorGUILayout.ObjectField ("Snow grass texture", t.snowGrassTex, typeof(Texture2D), false); 
		if (t.snowGrassTex != t.snowGrassTexOld) {

			Undo.RecordObject (t, "Snow  grass texture change");
			t.snowGrassTexOld = t.snowGrassTex;
			Shader.SetGlobalTexture ("_SnowTex", t.snowGrassTex);
			SceneView.RepaintAll ();
		}




	}

}
