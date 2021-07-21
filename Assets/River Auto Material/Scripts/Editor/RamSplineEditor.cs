using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor (typeof(RamSpline)), CanEditMultipleObjects]
public class RamSplineEditor : Editor
{
	Vector2 scrollPos;


	RamSpline spline;
	bool showPositions = false;

	Texture2D logo;
	int selectedPosition = -1;
	Vector3 pivotChange = Vector3.zero;

	//	/// <summary>
	//	/// The button editing style.
	//	/// </summary>
	//	GUIStyle buttonEditingStyle;

	[MenuItem ("GameObject/3D Object/Create River Spline")]
	static public void CreateSpline ()
	{
		GameObject gameobject = new GameObject ("RamSpline");
		gameobject.AddComponent<RamSpline> ();
		MeshRenderer meshRenderer = gameobject.AddComponent<MeshRenderer> ();
		meshRenderer.receiveShadows = false;
		meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
	
		if (meshRenderer.sharedMaterial == null)
			meshRenderer.sharedMaterial = AssetDatabase.GetBuiltinExtraResource<Material> ("Default-Diffuse.mat");
	

		Selection.activeGameObject = gameobject;
	}


	public override void OnInspectorGUI ()
	{

		EditorGUILayout.Space ();
		logo = (Texture2D)Resources.Load ("logoRAM");


	


		Color baseCol = GUI.color;

		spline = (RamSpline)target;


		scrollPos = EditorGUILayout.BeginScrollView (scrollPos);
		{


			GUIContent btnTxt = new GUIContent (logo);

			var rt = GUILayoutUtility.GetRect (btnTxt, GUI.skin.label, GUILayout.ExpandWidth (false));
			rt.center = new Vector2 (EditorGUIUtility.currentViewWidth / 2, rt.center.y);

			GUI.Button (rt, btnTxt, GUI.skin.label);



			EditorGUILayout.HelpBox ("Add Point  - CTRL + Left Mouse Button Click", MessageType.Info);
			EditorGUI.indentLevel++;

			EditorGUILayout.BeginHorizontal ();
			showPositions = EditorGUILayout.Foldout (showPositions, "Points");

			if (GUILayout.Button ("Add point at end")) {	

				Undo.RecordObject (spline, "Add point");

				int i = spline.controlPoints.Count - 1;
				Vector4 position = Vector3.zero;
				position.w = spline.width;

				if (i < spline.controlPoints.Count - 1 && spline.controlPoints.Count > i + 1) {
				
					position = spline.controlPoints [i];
					Vector4 positionSecond = spline.controlPoints [i + 1];
					if (Vector3.Distance ((Vector3)positionSecond, (Vector3)position) > 0)
						position = (position + positionSecond) * 0.5f;
					else
						position.x += 1;

				} else if (spline.controlPoints.Count > 1 && i == spline.controlPoints.Count - 1) {
				
					position = spline.controlPoints [i];
					Vector4 positionSecond = spline.controlPoints [i - 1];
					if (Vector3.Distance ((Vector3)positionSecond, (Vector3)position) > 0)
						position = position + (position - positionSecond);
					else
						position.x += 1;

				} else if (spline.controlPoints.Count > 0) {
					position = spline.controlPoints [i];
					position.x += 1;
				}
			
				spline.controlPoints.Add (position);

				spline.GenerateSpline ();
			}
			EditorGUILayout.EndHorizontal ();

			EditorGUI.BeginChangeCheck ();
			if (showPositions) {

				EditorGUI.indentLevel++;
				for (int i = 0; i < spline.controlPoints.Count; i++) {
				
					EditorGUILayout.BeginHorizontal ();
				
					spline.controlPoints [i] = EditorGUILayout.Vector4Field ("", spline.controlPoints [i]);

					if (spline.controlPoints [i].w <= 0) {
						Vector4 vec4 = spline.controlPoints [i];
						vec4.w = 1;
						spline.controlPoints [i] = vec4;
					}
				
					if (GUILayout.Button (new GUIContent ("A", "Add point after this point"))) {	

						Undo.RecordObject (spline, "Add point");


						Vector4 position = spline.controlPoints [i];

						if (i < spline.controlPoints.Count - 1 && spline.controlPoints.Count > i + 1) {
						
							Vector4 positionSecond = spline.controlPoints [i + 1];
							if (Vector3.Distance ((Vector3)positionSecond, (Vector3)position) > 0)
								position = (position + positionSecond) * 0.5f;
							else
								position.x += 1;

						} else if (spline.controlPoints.Count > 1 && i == spline.controlPoints.Count - 1) {
						
							Vector4 positionSecond = spline.controlPoints [i - 1];
							if (Vector3.Distance ((Vector3)positionSecond, (Vector3)position) > 0)
								position = position + (position - positionSecond);
							else
								position.x += 1;
						

						} else {
							position.x += 1;
						}

						spline.controlPoints.Insert (i + 1, position);

						spline.GenerateSpline ();
					}

					if (GUILayout.Button (new GUIContent ("R", "Remove this Point"))) {	
						Undo.RecordObject (spline, "Remove point");
						spline.controlPoints.RemoveAt (i);
						spline.GenerateSpline ();
					}

					if (GUILayout.Toggle (selectedPosition == i, new GUIContent ("S", "Select point"), "Button")) {
						selectedPosition = i;
					} else if (selectedPosition == i) {
						selectedPosition = -1;
					}

					EditorGUILayout.EndHorizontal ();

				}

				EditorGUI.indentLevel--;
				EditorGUILayout.Space ();
			}

			EditorGUI.indentLevel--;

			string meshResolution = "Triangles density";
			if (spline.meshfilter != null && spline.meshfilter.sharedMesh != null) {
				float tris = spline.meshfilter.sharedMesh.triangles.Length;
				meshResolution += " (" + tris + " tris)";

			} else if (spline.meshfilter != null && spline.meshfilter.sharedMesh == null) {
				spline.GenerateSpline ();
			}
			EditorGUILayout.LabelField (meshResolution);

			EditorGUI.indentLevel++;
			spline.traingleDensity = 1 / (float)EditorGUILayout.IntSlider ("U", (int)(1 / (float)spline.traingleDensity), 1, 100);

			spline.vertsInShape = EditorGUILayout.IntSlider ("V", spline.vertsInShape - 1, 1, 20) + 1;
			EditorGUI.indentLevel--;


			spline.uvScale = EditorGUILayout.FloatField ("UV scale (texture tiling)", spline.uvScale);

			if (EditorGUI.EndChangeCheck ()) {

				spline.GenerateSpline ();
			}


			EditorGUILayout.BeginHorizontal ();
			{

				spline.width = EditorGUILayout.FloatField ("River width", spline.width);
				if (GUILayout.Button ("Change width for whole river")) {	
					if (spline.width > 0) {
						Undo.RecordObject (spline, "Add point");
						for (int i = 0; i < spline.controlPoints.Count; i++) {
							Vector4 point = spline.controlPoints [i];
							point.w = spline.width;
							spline.controlPoints [i] = point;
						}

						spline.GenerateSpline ();
					}
				}
			}
			EditorGUILayout.EndHorizontal ();


			EditorGUILayout.Space ();



			if (GUILayout.Button ("Set basic river material")) {	
				
				try {
				
					string materialName = "RAM_River_Material_Gamma";
					if (PlayerSettings.colorSpace == ColorSpace.Linear)
						materialName = "RAM_River_Material_Linear";

					Material riverMat = (Material)Resources.Load (materialName);

					if (riverMat != null) {
						
						spline.GetComponent<MeshRenderer> ().sharedMaterial = riverMat;
					}
			

				} catch {


				}

			}

			if (GUILayout.Button ("Set basic river material with tesselation")) {	



				try {

					string materialName = "RAM_River_Material_Gamma_Tess";
					if (PlayerSettings.colorSpace == ColorSpace.Linear)
						materialName = "RAM_River_Material_Linear_Tess";

					Material riverMat = (Material)Resources.Load (materialName);

					if (riverMat != null) {
						spline.GetComponent<MeshRenderer> ().sharedMaterial = riverMat;
					}


				} catch {


				}

			}
			if (GUILayout.Button ("Set basic river material - vertex color")) {	

				try {

					string materialName = "RAM_River_Material_Gamma_Vertex_Color";
					if (PlayerSettings.colorSpace == ColorSpace.Linear)
						materialName = "RAM_River_Material_Linear_Vertex_Color";

					Material riverMat = (Material)Resources.Load (materialName);

					if (riverMat != null) {

						spline.GetComponent<MeshRenderer> ().sharedMaterial = riverMat;
					}


				} catch {


				}

			}

			if (GUILayout.Button ("Set basic river material with tesselation - vertex color")) {	



				try {

					string materialName = "RAM_River_Material_Gamma_Tess_Vertex_Color";
					if (PlayerSettings.colorSpace == ColorSpace.Linear)
						materialName = "RAM_River_Material_Linear_Tess_Vertex_Color";

					Material riverMat = (Material)Resources.Load (materialName);

					if (riverMat != null) {
						spline.GetComponent<MeshRenderer> ().sharedMaterial = riverMat;
					}


				} catch {


				}

			}


		
			EditorGUILayout.Space ();
			EditorGUILayout.Space ();

			EditorGUI.indentLevel++;
			spline.showAdditionalOptions = EditorGUILayout.Foldout (spline.showAdditionalOptions, "Additional options");

			if (spline.showAdditionalOptions) {

			


				GUIStyle buttonEditingStyle = new GUIStyle (GUI.skin.GetStyle ("Button"));
				buttonEditingStyle.fontStyle = FontStyle.Bold;
				buttonEditingStyle.fontSize = 15;

				Color guiBaseColor = GUI.color;

				GUI.color = Color.green;
				if (!spline.drawOnMesh && GUILayout.Button ("Start drawing vertex color", buttonEditingStyle)) {
					spline.drawOnMesh = true;
				}
				GUI.color = Color.red;
				if (spline.drawOnMesh && GUILayout.Button ("Stop drawing vertex color", buttonEditingStyle)) {
					spline.drawOnMesh = false;
				}
				GUI.color = guiBaseColor;

				if (spline.drawOnMesh) {
					EditorGUILayout.HelpBox ("R - Slow Water G - Small Cascade B - Big Cascade A - Opacity", MessageType.Info);
					spline.drawColor = EditorGUILayout.ColorField ("Draw color", spline.drawColor);
					spline.opacity = EditorGUILayout.FloatField ("Opacity", spline.opacity);
					spline.drawSize = EditorGUILayout.FloatField ("Size", spline.drawSize);

					if (spline.drawSize < 0) {
						spline.drawSize = 0;
					}
				}

				if (!spline.showVertexColors) {

					if (GUILayout.Button ("Show vertex colors")) {	
						spline.oldMaterial = spline.GetComponent<MeshRenderer> ().sharedMaterial;
						spline.GetComponent<MeshRenderer> ().sharedMaterial = new Material (Shader.Find ("Debug/Vertex color"));
						spline.showVertexColors = true;
					}
				} else {
					if (GUILayout.Button ("Hide vertex colors")) {	
						spline.GetComponent<MeshRenderer> ().sharedMaterial = spline.oldMaterial;
						spline.showVertexColors = false;
					}

				}


				EditorGUILayout.Space ();
				EditorGUILayout.Space ();

				if (GUILayout.Button ("Set object pivot to center")) {	
					Vector3 center = spline.meshfilter.sharedMesh.bounds.center;

					ChangePivot (center);

				}
				EditorGUILayout.BeginHorizontal ();
				{

					if (GUILayout.Button ("Set object pivot position")) {	
						ChangePivot (pivotChange - spline.transform.position);
					}
					pivotChange = EditorGUILayout.Vector3Field ("", pivotChange);

				

				}
				EditorGUILayout.EndHorizontal ();

				EditorGUILayout.Space ();

				if (GUILayout.Button (new GUIContent ("Regenerate spline", "Racalculates whole mesh"))) {	
					spline.GenerateSpline ();
				}

				EditorGUILayout.Space ();
				if (GUILayout.Button ("Export as mesh")) {	

					string path = EditorUtility.SaveFilePanelInProject ("Save river mesh", "", "asset", "Save river mesh");


					if (path.Length != 0 && spline.meshfilter.sharedMesh != null) {

						AssetDatabase.CreateAsset (spline.meshfilter.sharedMesh, path);		

						AssetDatabase.Refresh ();
						spline.GenerateSpline ();
					}

				}


			}


		}
		EditorGUILayout.EndScrollView ();

	}

	void ChangePivot (Vector3 center)
	{
		Vector3 position = spline.transform.position;
		spline.transform.position += center;
		for (int i = 0; i < spline.controlPoints.Count; i++) {
			Vector4 vec = spline.controlPoints [i];
			vec.x -= center.x;
			vec.y -= center.y;
			vec.z -= center.z;
			spline.controlPoints [i] = vec;
		}
		spline.GenerateSpline ();
	}






	protected virtual void OnSceneGUI ()
	{

		

		int controlId = GUIUtility.GetControlID (FocusType.Passive);

		if (spline != null) {

			if (spline.drawOnMesh) {
				DrawOnVertexColors ();
				return;
			}

			if (Event.current.commandName == "UndoRedoPerformed") {
				spline.GenerateSpline ();
				return;
			}

			if (selectedPosition >= 0 && selectedPosition < spline.controlPoints.Count) {
				Handles.color = Color.red;
				Handles.SphereHandleCap (0, (Vector3)spline.controlPoints [selectedPosition] + spline.transform.position, Quaternion.identity, 1, EventType.Repaint);

			}


			List<Vector3> points = new List<Vector3> ();
			points.AddRange (spline.points);


			for (int j = 0; j < spline.controlPoints.Count; j++) {

			

				EditorGUI.BeginChangeCheck ();

				Handles.color = new Color32 (147, 225, 58, 255);


				Vector3 handlePos = (Vector3)spline.controlPoints [j] + spline.transform.position;
				if (Tools.current == Tool.Move) {
					float width = spline.controlPoints [j].w;
					float size = 0.6f;
					size = HandleUtility.GetHandleSize (handlePos) * size;

					Handles.color = Handles.xAxisColor;
					Vector4 pos = Handles.Slider ((Vector3)spline.controlPoints [j] + spline.transform.position, Vector3.right, size, Handles.ArrowHandleCap, 0.01f) - spline.transform.position;

					pos = Handles.Slider ((Vector3)pos + spline.transform.position, Vector3.up, size, Handles.ArrowHandleCap, 0.01f) - spline.transform.position;

					pos = Handles.Slider ((Vector3)pos + spline.transform.position, Vector3.forward, size, Handles.ArrowHandleCap, 0.01f) - spline.transform.position;

					Vector3 halfPos = (Vector3.right + Vector3.forward) * size * 0.3f;
					pos = Handles.Slider2D ((Vector3)pos + spline.transform.position + halfPos, Vector3.up, Vector3.right, Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) - spline.transform.position - halfPos;
					halfPos = (Vector3.right + Vector3.up) * size * 0.3f;
					pos = Handles.Slider2D ((Vector3)pos + spline.transform.position + halfPos, Vector3.forward, Vector3.right, Vector3.up, size * 0.3f, Handles.RectangleHandleCap, 0.01f) - spline.transform.position - halfPos;
					halfPos = (Vector3.up + Vector3.forward) * size * 0.3f;
					pos = Handles.Slider2D ((Vector3)pos + spline.transform.position + halfPos, Vector3.right, Vector3.up, Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) - spline.transform.position - halfPos;
				
					pos.w = width;
					spline.controlPoints [j] = pos;


				} else if (Tools.current == Tool.Scale) {
					//Vector3 handlePos = (Vector3)spline.controlPoints [j] + spline.transform.position;
					Handles.color = Color.red;       
					float width = Handles.ScaleSlider (spline.controlPoints [j].w, (Vector3)spline.controlPoints [j] + spline.transform.position, new Vector3 (0, 1, 0), 
						              Quaternion.Euler (-90, 0, 0), HandleUtility.GetHandleSize (handlePos), 0.01f);
					
					Vector4 pos = spline.controlPoints [j];
					pos.w = width;
					spline.controlPoints [j] = pos;

				}
				
				if (EditorGUI.EndChangeCheck ()) {

					Undo.RecordObject (spline, "Change Position");
					spline.GenerateSpline ();
				}

			}

			if (Event.current.type == EventType.MouseDown && Event.current.button == 0 && Event.current.control) {
				

				Vector3 screenPosition = Event.current.mousePosition;
				screenPosition.y = Camera.current.pixelHeight - screenPosition.y;
				Ray ray = Camera.current.ScreenPointToRay (screenPosition);
				RaycastHit hit;

				if (Physics.Raycast (ray, out hit)) {
					Undo.RecordObject (spline, "Add point");

					Vector4 position = hit.point - spline.transform.position;
					if (spline.controlPoints.Count > 0)
						position.w = spline.controlPoints [spline.controlPoints.Count - 1].w;
					else
						position.w = spline.width;


					spline.controlPoints.Add (position);

					spline.GenerateSpline ();

					GUIUtility.hotControl = controlId;
					Event.current.Use ();
					HandleUtility.Repaint ();
				}
			}
			if (Event.current.type == EventType.MouseUp && Event.current.button == 0 && Event.current.control) {
				GUIUtility.hotControl = 0;

			}


		}


	}

	void DrawOnVertexColors ()
	{

		HandleUtility.AddDefaultControl (GUIUtility.GetControlID (FocusType.Passive));

	
	
		Camera sceneCamera = SceneView.lastActiveSceneView.camera;
		Vector2 mousePos = Event.current.mousePosition;
		mousePos.y = Screen.height - mousePos.y - 40;
		Ray ray = sceneCamera.ScreenPointToRay (mousePos);
		MeshCollider meshCollider = spline.gameObject.AddComponent<MeshCollider> ();
		RaycastHit[] hits = Physics.RaycastAll (ray, Mathf.Infinity);

		GameObject go = null;
		Vector3 hitPosition = Vector3.zero;
		Vector3 hitNormal = Vector3.zero;
		if (hits.Length > 0) {

			foreach (var hit in hits) {
				if (hit.collider is MeshCollider) {
					go = hit.collider.gameObject;
					if (go == spline.gameObject) {
						
						hitPosition = hit.point;
						hitNormal = hit.normal;
						break;
					} else
						go = null;
				}
			}
		
		}

		DestroyImmediate (meshCollider);


		if (go != null) {
			
			Handles.color = new Color (spline.drawColor.r, spline.drawColor.g, spline.drawColor.b, 1);
			Handles.DrawLine (hitPosition, hitPosition + hitNormal * 2);
			Handles.CircleHandleCap (
				0,
				hitPosition,
				Quaternion.LookRotation (hitNormal),
				spline.drawSize,
				EventType.Repaint
			);
			Handles.color = Color.black;
			Handles.CircleHandleCap (
				0,
				hitPosition,
				Quaternion.LookRotation (hitNormal),
				spline.drawSize - 0.1f,
				EventType.Repaint
			);

			if (!(Event.current.type == EventType.MouseDown || Event.current.type == EventType.MouseDrag) || Event.current.button != 0)
				return;
			if (Event.current.type == EventType.MouseDown && Event.current.button == 0) {
			}

			MeshFilter meshFilter = spline.GetComponent<MeshFilter> ();
			if (meshFilter.sharedMesh != null) {
				Mesh mesh = meshFilter.sharedMesh;
				if (spline.colors.Length == 0)
					spline.colors = new Color[mesh.vertices.Length];
				
				for (int i = 0; i < mesh.vertices.Length; i++) {
					float dist = Vector3.Distance (hitPosition, spline.transform.TransformPoint (mesh.vertices [i]));
					if (dist < spline.drawSize) {
						Color[] colors = spline.colors;
						if (Event.current.shift)
							colors [i] = Color.Lerp (colors [i], Color.white, spline.opacity);
						else
							colors [i] = Color.Lerp (colors [i], spline.drawColor, spline.opacity);
						mesh.colors = colors;
						meshFilter.sharedMesh = mesh;
					}
				}

			
			}
		}
	}

}
