using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace Horizon
{
    public class HorizonTreePlacer : EditorWindow {

        GameObject saveSettingsGo;
        HorizonDecoPainterSettings hdps;
        public List<GameObject> prefabs = new List<GameObject>();

        string installPath;
        Texture icon;
        Vector2 scrollPos = new Vector2(0, 0);
        bool foldedOut = true;
        float inspectorWidth;

        Ray ray;
        RaycastHit hit;
        List<Vector3> rayPos = new List<Vector3>();

        Mesh brush;
        Event e;

        List<Transform> transformsSortedByZ = new List<Transform>();
        CombineInstance[] combineInstance;

        bool isPainting = false;
        bool paint = false;
        bool delete = false;




        [MenuItem("Window/Horizon[ON]/Horizon[ON] Deco Painter")]
        static void Init() {
            HorizonTreePlacer window = (HorizonTreePlacer)EditorWindow.GetWindow(typeof(HorizonTreePlacer));
            window.Show();
        } //==================================================================================================


        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/HorizonTreePlacer.cs", "");
            icon = AssetDatabase.LoadAssetAtPath(installPath + "/Sources/Scripts/Editor/InspectorGUI/Icon.png", typeof(Texture)) as Texture;
            titleContent = new GUIContent(icon);
            if (saveSettingsGo == null)
            {
                saveSettingsGo = GameObject.Find("HorizonDecoPainterSettings");
                if (saveSettingsGo == null)
                {
                    saveSettingsGo = new GameObject("HorizonDecoPainterSettings");
                    hdps = saveSettingsGo.AddComponent<HorizonDecoPainterSettings>();
                    saveSettingsGo.hideFlags = HideFlags.HideInHierarchy;
                    saveSettingsGo.transform.hideFlags = HideFlags.HideInInspector;
                    saveSettingsGo.tag = "EditorOnly";
                }
                else { hdps = saveSettingsGo.GetComponent<HorizonDecoPainterSettings>(); }
                ChangeBrushSize(); // Initialize Brush
            }
        } //==================================================================================================
        void OnDestroy()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        } //==================================================================================================
        void OnFocus()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
        } //==================================================================================================


        void OnGUI()
        {
            inspectorWidth = EditorGUIUtility.currentViewWidth;
            if (prefabs.Count != 0)
            {
                if (prefabs[prefabs.Count - 1] != null)
                {
                    if (prefabs.Count > 1)
                    {
                        bool alreadyAdded = false;
                        for (int i = 0; i < prefabs.Count - 1; i++) { if (prefabs[i] == prefabs[prefabs.Count - 1]) { alreadyAdded = true; break; } }
                        if (alreadyAdded)
                        {
                            ShowNotification(new GUIContent("Already added!"));
                            prefabs.RemoveAt(prefabs.Count - 1);
                        }
                    }
                    prefabs.Add(null);
                    //Repaint();
                    //return;
                }
            }
            else { prefabs.Add(null); } //Repaint(); return; }

            minSize = new Vector2(300, 242);

            if (hdps.parent == null) {isPainting = false; }
            if (focusedWindow != null) { if (focusedWindow.titleContent.text != "Scene") if (focusedWindow != this) isPainting = false; }
            if (EditorApplication.isPlayingOrWillChangePlaymode) { isPainting = false; }

            DrawUI();
        } //==================================================================================================


        void DrawUI()
        {
            //--->
            EditorGUILayout.BeginHorizontal();
            GUI.backgroundColor = new Color(0.5f, 0.9f, 0, 1);
            if (!hdps.objectMode) GUI.color = new Color(1, 1, 1, 1); else GUI.color = new Color(1, 1, 1, 0.5f);
            if (GUILayout.Button("Tree Mode")) hdps.objectMode = false;

            GUI.backgroundColor = new Color(0, 0.5f, 1, 1);
            if (hdps.objectMode) GUI.color = new Color(1, 1, 1, 1); else GUI.color = new Color(1, 1, 1, 0.5f);
            if (GUILayout.Button("Object Mode")) hdps.objectMode = true;
            EditorGUILayout.EndHorizontal();
            //<---

            GUI.color = new Color(1, 1, 1, 1);
            GUI.backgroundColor = new Color(1, 1, 1, 1);

            if (Selection.activeGameObject != null)
            {
                GameObject activeGO = Selection.activeGameObject;
                if (activeGO.GetComponent<HorizonDecoParent>() != null)
                {
                    if (GUILayout.Button("Convert selection back to editable Group"))
                    {
                        ConvertToEditable(activeGO);
                    }
                }
            }
            if (!hdps.objectMode) { DrawTreeModeUI(); }
            else { DrawObjectModeUI(); }
            DrawPrefabsList();
        } //==================================================================================================


        void DrawObjectModeUI()
        {
            if (hdps.parent == null)
            {
                if (prefabs.Count == 1) EditorGUILayout.HelpBox("Add Prefabs in the Prefabslot below or use the \"Load Prefab List\" Button", MessageType.Info);
                else if (GUILayout.Button("Create new object group & start painting", GUILayout.Height(25))) { NewParent("ObjectGroup (editing!)"); isPainting = true; }
            }
            else
            {
                if (!isPainting) { if (GUILayout.Button("Continue painting", GUILayout.Height(25))) isPainting = true; }
                else
                { 
                    if (hdps.parent.transform.childCount == 0)
                    {
                        if (GUILayout.Button("Cancel ObjectGroup", GUILayout.Height(25))) DestroyImmediate(hdps.parent);
                    }
                    else
                    {
                        if (GUILayout.Button("Close current obect group and combine", GUILayout.Height(25))) CloseGroup();
                    }
                    GUI.backgroundColor = new Color(0.75f, 0.75f, 0.75f, 1);
                    GUILayout.Space(2);

                //--->
                    EditorGUILayout.BeginHorizontal();
                    Rect r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Objects: " + hdps.currentObjectCount.ToString(), MessageType.None);
                    r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Verts: " + hdps.currentVertCount.ToString(), MessageType.None);
                    r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Tris: " + hdps.currentTriangleCount.ToString(), MessageType.None);
                    EditorGUILayout.EndHorizontal();
                //<---

                    GUILayout.Space(2);
                    GUI.backgroundColor = new Color(1, 1, 1, 1);
                    hdps.pickRandom = EditorGUILayout.Toggle("Pick Random", hdps.pickRandom);
                    hdps.scaleSensitivity = EditorGUILayout.Slider("Scale Sensitivity", hdps.scaleSensitivity, 0.1f, 1);
                }
            }
        }


        void DrawTreeModeUI()
        {
            if (hdps.parent == null)
            {
                if (prefabs.Count == 1) EditorGUILayout.HelpBox("Add Prefabs in the Prefabslot above or use the \"Load Prefab List\" Button", MessageType.Info); /// Error Here!!!
                else if (GUILayout.Button("Create new tree group & start painting", GUILayout.Height(25))) { NewParent("TreeGroup (editing!)"); isPainting = true; }
            }
            else
            {
                if (!isPainting) { if (GUILayout.Button("Continue painting", GUILayout.Height(25))) isPainting = true; }
                else
                { 
                    if (hdps.parent.transform.childCount == 0)
                    {
                        if (GUILayout.Button("Cancel TreeGroup", GUILayout.Height(25))) { DestroyImmediate(hdps.parent); }
                    }
                    else
                    {
                        if (GUILayout.Button("Close current tree group and combine", GUILayout.Height(25))) { CloseGroup(); }
                    }
                    GUI.backgroundColor = new Color(0.75f, 0.75f, 0.75f, 1);
                    GUILayout.Space(2);

                //--->
                    EditorGUILayout.BeginHorizontal();
                    Rect r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Trees: " + hdps.currentObjectCount.ToString(), MessageType.None);
                    r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Verts: " + hdps.currentVertCount.ToString(), MessageType.None);
                    r = new Rect(EditorGUILayout.GetControlRect(GUILayout.MaxWidth((inspectorWidth / 3) - 6), GUILayout.Height(17)));
                    EditorGUI.HelpBox(r, "Tris: " + hdps.currentTriangleCount.ToString(), MessageType.None);
                    EditorGUILayout.EndHorizontal();
                //<---

                    GUILayout.Space(2);
                    GUI.backgroundColor = new Color(1, 1, 1, 1);

                    hdps.brushSize = EditorGUILayout.IntSlider("BrushSize", hdps.brushSize, 1, 8);
                    if (hdps.brushSize != hdps.oldBrushSize) { ChangeBrushSize(); hdps.oldBrushSize = hdps.brushSize; }
                    hdps.probability = EditorGUILayout.Slider("Probability", hdps.probability, 0.1f, 1);
                    hdps.minPointDist = EditorGUILayout.Slider("Minimum Tree Distance", hdps.minPointDist, 4, 30);
                    hdps.maxSteepness = EditorGUILayout.Slider("Maximum Steepness", hdps.maxSteepness, 1, 90);

                //--->
                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField("Size Variation:", GUILayout.Width(92));
                    hdps.sizeVariationMinMax.x = EditorGUILayout.FloatField(hdps.sizeVariationMinMax.x, GUILayout.Width(50));
                    EditorGUILayout.MinMaxSlider(ref hdps.sizeVariationMinMax.x, ref hdps.sizeVariationMinMax.y, hdps.sizeVariationMinMaxLimit.x, hdps.sizeVariationMinMaxLimit.y);
                    hdps.sizeVariationMinMax.y = EditorGUILayout.FloatField(hdps.sizeVariationMinMax.y, GUILayout.Width(50));
                    EditorGUILayout.EndHorizontal();
                //<---
                }
            }
        } //==================================================================================================


        void DrawPrefabsList()
        {
            if (!hdps.objectMode) prefabs = hdps.treePrefabs;
            else prefabs = hdps.objectPrefabs;
            if (prefabs.Count == 0) { prefabs.Add(null); }//Repaint(); return; }
            string prefabsTitle = "Prefabs(Show)";
            if (foldedOut) prefabsTitle = "Prefabs(Hide)";

        //--->
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(prefabsTitle, GUILayout.Width(48));
            foldedOut = EditorGUILayout.Foldout(foldedOut, "");

            GUI.backgroundColor = new Color(0.75f,0.75f,0.75f,1);
            if (!isPainting)
            {
                if (prefabs.Count == 1) GUI.color = new Color(1, 1, 1, 0.5f);
                if (GUILayout.Button("Clear")) { if (prefabs.Count != 1) { if (hdps.objectMode) hdps.objectPrefabs.Clear(); else hdps.treePrefabs.Clear(); } }
                GUI.color = new Color(1, 1, 1, 1);
                if (prefabs.Count == 1) GUI.color = new Color(1, 1, 1, 0.5f);
                if (GUILayout.Button("Save List")) { if (prefabs.Count == 1) return; else SavePreset(EditorUtility.SaveFilePanel("Save PrefabList", installPath + "/Presets", "MyPrefabList", "prefab")); }
                GUI.color = new Color(1, 1, 1, 1);
                if (GUILayout.Button("Load List")) { LoadPreset(EditorUtility.OpenFilePanel("Load PrefabList", installPath + "/Presets", "prefab")); }
            }
            else
            {
                GUI.color = new Color(1, 1, 1, 0.5f);
                GUILayout.Button("Clear");
                GUILayout.Button("Save List");
                GUILayout.Button("Load List");
                GUI.color = new Color(1, 1, 1, 1);
            }
            GUI.backgroundColor = new Color(1, 1, 1, 1);
            EditorGUILayout.EndHorizontal();
            //<---

            if (hdps.objectMode && prefabs.Count == 2) hdps.selectedPrefab = 0;

            if (foldedOut)
            {
                GUILayout.Space(2);

            //---> Scroll View ----------------------------------------------------------------
                scrollPos = EditorGUILayout.BeginScrollView(scrollPos);


                for (int i = 0; i < prefabs.Count; i++)
                {
                    if (i == prefabs.Count - 1) GUILayout.Space(3);

                //--->
                    EditorGUILayout.BeginHorizontal();
                    int space = 99;
                    if (i != prefabs.Count - 1)
                    {
                        if (hdps.objectMode)
                        {
                            string s = "";
                            if (i == hdps.selectedPrefab) { s = "►"; GUI.backgroundColor = new Color(0.6f, 1f, 0.1f, 1); } else GUI.backgroundColor = new Color(0.05f, 0.3f, 0, 0.65f);
                            if (GUILayout.Button(s, GUILayout.Width(19), GUILayout.Height(14))) hdps.selectedPrefab = i;
                            GUI.backgroundColor = new Color(1, 1, 1, 1);
                            space = 122;
                        }
                    }
                    else { GUILayout.Label("Add Prefab:", GUILayout.Width(70)); space = 103; }

                    prefabs[i] = EditorGUILayout.ObjectField(prefabs[i], typeof(GameObject), false, GUILayout.Width(inspectorWidth - space)) as GameObject;
                    if (i != prefabs.Count - 1)
                    {
                        if (GUILayout.Button("▲", GUILayout.Width(21), GUILayout.Height(14)))
                        {
                            GameObject go = prefabs[i];
                            prefabs.RemoveAt(i);
                            prefabs.Insert(i - 1, go);
                        }
                        if (GUILayout.Button("▼", GUILayout.Width(21), GUILayout.Height(14)))
                        {
                            GameObject go = prefabs[i];
                            prefabs.RemoveAt(i);
                            prefabs.Insert(i + 1, go);
                        }

                        if (GUILayout.Button("-", GUILayout.Width(19), GUILayout.Height(14))) { prefabs.RemoveAt(i); }
                    }
                    EditorGUILayout.EndHorizontal();
                //<---
                }
                GUILayout.Space(3);


                EditorGUILayout.EndScrollView();
            //<--- Scroll View ---------------------------------------------------------------

            }
            if (!hdps.objectMode) hdps.treePrefabs = prefabs;
            else hdps.objectPrefabs = prefabs;
        } //==================================================================================================


        void SortByDistance()
        {
            transformsSortedByZ.Sort
                (
                    delegate(Transform t1, Transform t2)
                    {
                        return Vector3.Distance(new Vector3(t2.position.x, 0, t2.position.z), Vector3.zero).CompareTo( Vector3.Distance( new Vector3(t1.position.x, 0, t1.position.z), Vector3.zero));
                    }
                );
        }

        void CloseGroup()
        {
            if (hdps.parent != null)
            {
                int childCount = hdps.parent.transform.childCount;

                transformsSortedByZ.Clear();
                for (int i = 0; i < childCount; i++)
                {
                    Transform currentTransform = hdps.parent.transform.GetChild(i);
                    if (currentTransform.GetComponent<MeshFilter>() == null)
                    {
                        string notification = "There are Children in the current Group that have no Meshfilter component. \nRemove any invalid objects and try again!";
                        if (GetWindow<SceneView>() != null) GetWindow<SceneView>().ShowNotification(new GUIContent(notification));
                        return;
                    }
                    transformsSortedByZ.Add(currentTransform);
                }
                SortByDistance();

                isPainting = false;

                combineInstance = new CombineInstance[childCount];
                for (int i = 0; i < combineInstance.Length; i++)
                {
                    //Transform currentTransform = hdps.parent.transform.GetChild(i);
                    Transform currentTransform = transformsSortedByZ[i];
                    combineInstance[i].mesh = currentTransform.GetComponent<MeshFilter>().sharedMesh;
                    combineInstance[i].transform = Matrix4x4.TRS(currentTransform.position, currentTransform.rotation, currentTransform.localScale);
                }
                string groupName = "TreeGroup";
                if (hdps.objectMode) groupName = "ObjectGroup";
                GameObject newGroup = new GameObject(groupName);
                StoreValuesInParent(newGroup);
                MeshFilter mf = newGroup.AddComponent<MeshFilter>();
                mf.sharedMesh = new Mesh();
                mf.sharedMesh.name = groupName;
                mf.sharedMesh.CombineMeshes(combineInstance, true, true);
                MeshRenderer mr = newGroup.AddComponent<MeshRenderer>();
                mr.sharedMaterial = hdps.parent.transform.GetChild(0).GetComponent<MeshRenderer>().sharedMaterial;
                if (hdps.objectMode) mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On; else mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;
                mr.receiveShadows = true;
                mr.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
                mr.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
                mr.motionVectorGenerationMode = MotionVectorGenerationMode.Camera;
                GameObjectUtility.SetStaticEditorFlags(newGroup, StaticEditorFlags.BatchingStatic);
                GameObjectUtility.SetStaticEditorFlags(newGroup, StaticEditorFlags.ReflectionProbeStatic);
                GameObjectUtility.SetStaticEditorFlags(newGroup, StaticEditorFlags.OccludeeStatic);
                //Undo.RegisterCreatedObjectUndo(newGroup, "Horizon[ON]");
                //Undo.DestroyObjectImmediate(hdps.parent);
                DestroyImmediate(hdps.parent);
                string message = "Current " + groupName + " combined! \n Triangles: " + (mf.sharedMesh.triangles.Length / 3).ToString() + " Vertices: " + mf.sharedMesh.vertexCount.ToString();

                if (GetWindow<SceneView>() != null) GetWindow<SceneView>().ShowNotification(new GUIContent(message));
            }
        } //==================================================================================================

        void StoreValuesInParent(GameObject group)
        {
            HorizonDecoParent groupParent = group.AddComponent<HorizonDecoParent>();
            groupParent.objectMode = hdps.objectMode;
            for (int i = 0; i < hdps.parent.transform.childCount; i++)
            {
                Transform t = hdps.parent.transform.GetChild(i);
                groupParent.gameObjects.Add(PrefabUtility.GetCorrespondingObjectFromSource(t.gameObject) as GameObject);
                groupParent.positions.Add(t.position);
                groupParent.rotations.Add(t.rotation);
                groupParent.scalings.Add(t.localScale);
            }
        }

        void ConvertToEditable(GameObject group)
        {
            HorizonDecoParent groupParent = group.GetComponent<HorizonDecoParent>();
            string name;
            if (groupParent.objectMode) name = "ObjectGroup (editing!)";
            else name = "TreeGroup (editing!)";
            NewParent(name);
            for (int i = 0; i < groupParent.gameObjects.Count; i++)
            {
                GameObject go = PrefabUtility.InstantiatePrefab(groupParent.gameObjects[i]) as GameObject;
                go.transform.position = groupParent.positions[i];
                go.transform.rotation = groupParent.rotations[i];
                go.transform.localScale = groupParent.scalings[i];
                if (!groupParent.objectMode) go.AddComponent<SphereCollider>().radius = 4f;
                go.transform.parent = hdps.parent.transform;

                MeshFilter mf = go.GetComponent<MeshFilter>();
                hdps.currentObjectCount += 1;
                hdps.currentVertCount += mf.sharedMesh.vertexCount;
                hdps.currentTriangleCount += mf.sharedMesh.triangles.Length / 3;
            }
            hdps.objectMode = groupParent.objectMode;
            //Undo.DestroyObjectImmediate(group);
            DestroyImmediate(group);
        }



        void NewParent(string name)
        {
            hdps.parent = new GameObject(name);
            hdps.currentObjectCount = 0;
            hdps.currentVertCount = 0;
            hdps.currentTriangleCount = 0;
            //Undo.RegisterCreatedObjectUndo(hdps.parent, "Horizon[ON]");
        } //==================================================================================================


        void ChangeBrushSize()
        {
            if (hdps.brushSize > 1)
            {
                brush = AssetDatabase.LoadAssetAtPath<GameObject>(installPath + "/Sources/Scripts/Internal/Brushes/BrushSize_" + hdps.brushSize.ToString() + ".prefab").GetComponent<MeshFilter>().sharedMesh;
                rayPos.Clear();
                rayPos.AddRange(brush.vertices);
            }
        } //==================================================================================================



        Camera cam;
        void OnSceneGUI(SceneView sceneView)
        {
            if (isPainting)
            {
                e = Event.current;
                if (e.type == EventType.Layout && isPainting && !(hdps.objectMode && e.shift))
                {
                    Selection.activeGameObject = null;
                    HandleUtility.AddDefaultControl(GUIUtility.GetControlID(GetHashCode(), FocusType.Passive));
                }
                cam = Camera.current;
                ray = cam.ScreenPointToRay(new Vector3(e.mousePosition.x, cam.pixelHeight - e.mousePosition.y, 0));

                if (e.alt) return;

                if (!e.shift)
                {
                    if (e.type == EventType.MouseDown && (e.button == 0)) { paint = true; if (hdps.objectMode) PaintObjectStartDrag(); }
                    if (e.type == EventType.MouseUp && (e.button == 0)) { paint = false; if (hdps.objectMode) PaintObjectEndDrag(); }
                }
                if (paint)
                {
                    if (hdps.objectMode) PaintObjectCurrentDrag();
                    else PaintTree();
                }

                else if (e.shift)
                {
                    if (hdps.objectMode)
                    {
                        if (Selection.activeTransform != null)
                        {
                            if (!Selection.activeTransform.IsChildOf(hdps.parent.transform)) Selection.activeGameObject = null;
                            else
                            {
                                hdps.currentObjectCount -= 1;
                                MeshFilter mf = Selection.activeTransform.GetComponent<MeshFilter>();
                                hdps.currentVertCount -= mf.GetComponent<MeshFilter>().sharedMesh.vertexCount;
                                hdps.currentTriangleCount -= mf.sharedMesh.triangles.Length / 3;

                                DestroyImmediate(Selection.activeTransform.gameObject);
                            }
                        }
                    }
                    else
                    {
                        if (e.type == EventType.MouseDown && (e.button == 0)) { delete = true; }
                        if (e.type == EventType.MouseUp && (e.button == 0)) { delete = false; }
                    }
                }
                if (delete) Delete();

                if (e.mousePosition.x < cam.pixelRect.x || e.mousePosition.x > cam.pixelRect.xMax || e.mousePosition.y < cam.pixelRect.y || e.mousePosition.y > cam.pixelRect.yMax)
                {
                    paint = false;
                    delete = false;
                }
            }
            Repaint();
        } //=====================================================================================================================================


        Vector3 startDragPoint = Vector3.zero;
        Vector3 currentDragPoint = Vector3.zero;
        GameObject currentObject;
        float objectScaleDistance = 0;

        void PaintObjectStartDrag()
        {
            //Undo.RegisterFullObjectHierarchyUndo(hdps.parent.transform, "full object hierarchy change");
            if (Physics.Raycast(ray, out hit))
            {
                Vector3 pos = hit.point;
                Ray newRay = new Ray();
                RaycastHit newHit;
                newRay.origin = pos + new Vector3(0, 50, 0);
                newRay.direction = Vector3.down;
                if (Physics.Raycast(newRay, out newHit, 100))
                {
                    startDragPoint = newHit.point;
                    currentObject = PrefabUtility.InstantiatePrefab(prefabs[hdps.selectedPrefab]) as GameObject;
                    currentObject.transform.parent = hdps.parent.transform;
                    currentObject.transform.position = startDragPoint;
                    currentObject.transform.localScale = Vector3.zero;
                    hdps.currentObjectCount += 1;
                    MeshFilter mf = currentObject.GetComponent<MeshFilter>();
                    hdps.currentVertCount += mf.sharedMesh.vertexCount;
                    hdps.currentTriangleCount += mf.sharedMesh.triangles.Length / 3;
                }
            }
        } //=====================================================================================================================================
        void PaintObjectCurrentDrag()
        {
            if (Physics.Raycast(ray, out hit))
            {
                Vector3 pos = hit.point;
                Ray newRay = new Ray();
                RaycastHit newHit;
                newRay.origin = pos + new Vector3(0, 50, 0);
                newRay.direction = Vector3.down;
                if (Physics.Raycast(newRay, out newHit, 100)) { currentDragPoint = newHit.point; }
                objectScaleDistance = (new Vector3(currentDragPoint.x, 0, currentDragPoint.z) - new Vector3(startDragPoint.x, 0, startDragPoint.z)).magnitude * 2;
                Vector3 direction = new Vector3(currentDragPoint.x, 0, currentDragPoint.z) - new Vector3(startDragPoint.x, 0, startDragPoint.z);
                if (direction == Vector3.zero) direction = Vector3.one;
                currentObject.transform.rotation = Quaternion.LookRotation(direction);
                currentObject.transform.localScale = new Vector3(objectScaleDistance, objectScaleDistance, objectScaleDistance) * hdps.scaleSensitivity;
            }
        } //=====================================================================================================================================
        void PaintObjectEndDrag()
        {
            if (currentObject != null)
            {
                if (currentObject.transform.localScale.x < 1)
                {
                    hdps.currentObjectCount -= 1;
                    MeshFilter mf = currentObject.GetComponent<MeshFilter>();
                    hdps.currentVertCount -= mf.sharedMesh.vertexCount;
                    hdps.currentTriangleCount -= mf.sharedMesh.triangles.Length / 3;
                    DestroyImmediate(currentObject);
                }
                if (hdps.pickRandom) hdps.selectedPrefab = Random.Range(0, prefabs.Count - 2);
            }
        }


        void PaintTree()
        {
            //Undo.RegisterFullObjectHierarchyUndo(hdps.parent.transform, "full object hierarchy change");
            if (Physics.Raycast(ray, out hit))
            {
                if (hdps.brushSize > 1)
                {
                    for (int i = 0; i < rayPos.Count; i++)
                    {
                        float random = Random.Range(0f, 0.99f);
                        if (random > hdps.probability*0.2f) continue;
                        Vector3 pos = hit.point + rayPos[i];
                        Ray newRay = new Ray();
                        RaycastHit newHit;
                        newRay.origin = pos + new Vector3(0, 50, 0);
                        newRay.direction = Vector3.down;
                        if (Physics.Raycast(newRay, out newHit, 100))
                        {
                            pos = newHit.point;
                        }
                        else continue;
                        if (Vector3.Angle(Vector3.up, newHit.normal) > hdps.maxSteepness) return;
                        bool skip = false;
                        foreach (Collider c in Physics.OverlapSphere(pos, hdps.minPointDist))
                        {
                            if (c.transform.IsChildOf(hdps.parent.transform)) { skip = true; break; }
                        }
                        if (!skip) { InstantiateTree(pos); }
                    }
                }
                else
                {
                    float random = Random.Range(0f, 0.99f);
                    if (random > hdps.probability * 0.6f) return;
                    Vector3 pos = hit.point;
                    Ray newRay = new Ray();
                    RaycastHit newHit;
                    newRay.origin = pos + new Vector3(0, 50, 0);
                    newRay.direction = Vector3.down;
                    if (Physics.Raycast(newRay, out newHit, 100))
                    {
                        pos = newHit.point;
                    }
                    if (Vector3.Angle(Vector3.up, newHit.normal) > hdps.maxSteepness) return;
                    bool skip = false;
                    foreach (Collider c in Physics.OverlapSphere(pos, hdps.minPointDist))
                    {
                        if (c.transform.IsChildOf(hdps.parent.transform)) { skip = true; break; }
                    }
                    if (!skip) { InstantiateTree(pos); }
                }
            }
        } //==================================================================================================

        void Delete()
        {
            //Undo.RegisterFullObjectHierarchyUndo(hdps.parent.transform, "full object hierarchy change");
            Camera cam = Camera.current;
            ray = cam.ScreenPointToRay(new Vector3(e.mousePosition.x, cam.pixelHeight - e.mousePosition.y, 0));

            if (e.mousePosition.x < cam.pixelRect.x || e.mousePosition.x > cam.pixelRect.xMax || e.mousePosition.y < cam.pixelRect.y || e.mousePosition.y > cam.pixelRect.yMax)
            {
                paint = false;
                delete = false;
                return;
            }

            if (Physics.Raycast(ray, out hit))
            {
                Vector3 pos = hit.point;
                Ray newRay = new Ray();
                RaycastHit newHit;
                newRay.origin = pos + new Vector3(0, 50, 0);
                newRay.direction = Vector3.down;
                if (Physics.Raycast(newRay, out newHit, 100))
                {
                    pos = newHit.point;
                }
                foreach (Collider c in Physics.OverlapSphere(pos, hdps.brushSize*10))
                {
                    if (c.transform.IsChildOf(hdps.parent.transform))
                    {
                        hdps.currentObjectCount -= 1;
                        MeshFilter mf = c.GetComponent<MeshFilter>();
                        hdps.currentVertCount -= mf.sharedMesh.vertexCount;
                        hdps.currentTriangleCount -= mf.sharedMesh.triangles.Length / 3;
                        DestroyImmediate(c.gameObject);
                    }
                }
            }
        } //==================================================================================================


        void InstantiateTree(Vector3 position)
        {
            if (hdps.parent != null)
            {
                Vector3 direction = new Vector3(0, position.y, 0) - position;
                GameObject go = PrefabUtility.InstantiatePrefab(prefabs[GetRandomIndex()]) as GameObject;
                go.transform.position = position;
                go.transform.rotation = Quaternion.LookRotation(direction);
                float scaleRange = Random.Range(hdps.sizeVariationMinMax.x, hdps.sizeVariationMinMax.y);
                go.transform.localScale = go.transform.localScale * scaleRange;
                go.AddComponent<SphereCollider>().radius = 4f;
                go.transform.parent = hdps.parent.transform;

                MeshFilter mf = go.GetComponent<MeshFilter>();
                if (hdps.currentVertCount + mf.sharedMesh.vertexCount > 65536) { DestroyImmediate(go); goto Message; }
                hdps.currentObjectCount += 1;
                hdps.currentVertCount += mf.sharedMesh.vertexCount;
                hdps.currentTriangleCount += mf.sharedMesh.triangles.Length / 3;
                return;

                Message:
                string message = "Limit of 65536 Vertices reached, please close the current group and start a new one!";
                if (GetWindow<SceneView>() != null) GetWindow<SceneView>().ShowNotification(new GUIContent(message));
            }
        } //==================================================================================================


        int GetRandomIndex()
        {
            bool isNull = true;
            int i = -1;
            while (isNull)
            {
                i = Random.Range(0, prefabs.Count - 2);
                if (prefabs[i] != null) { isNull = false; }
            }
            return i;
        } //==================================================================================================


        public void SavePreset(string path)
        {
            if (path.Length == 0) return;
            path = path.Replace(Application.dataPath + "/", "Assets/");
            GameObject prefabList = new GameObject();
            List<GameObject> list = prefabList.AddComponent<HorizonPrefabList>().prefabList;
            if (hdps.objectMode) prefabList.GetComponent<HorizonPrefabList>().objectMode = true;
            list.Clear();
            list.AddRange(prefabs);
            list.RemoveAt(list.Count - 1);
            AssetDatabase.DeleteAsset(path);
            PrefabUtility.CreatePrefab(path, prefabList);
            DestroyImmediate(prefabList);
        } // =====================================================================================================================
        public void LoadPreset(string path)
        {
            if (path.Length == 0) return;
            path = path.Replace(Application.dataPath + "/", "Assets/");
            if (AssetDatabase.LoadAssetAtPath<GameObject>(path).GetComponent<HorizonPrefabList>() != null)
            {

                if (hdps.objectMode)
                {
                    if (AssetDatabase.LoadAssetAtPath<GameObject>(path).GetComponent<HorizonPrefabList>().objectMode)
                    {
                        prefabs.RemoveAt(prefabs.Count - 1);
                        prefabs.AddRange(AssetDatabase.LoadAssetAtPath<GameObject>(path).GetComponent<HorizonPrefabList>().prefabList);
                    }
                    else
                    {
                        string message = "You specified a Tree List.\nSwitch to \"Tree Mode\" and try again.";
                        if (SceneView.GetWindow<SceneView>() != null) SceneView.GetWindow<SceneView>().ShowNotification(new GUIContent(message));
                    }
                }
                else
                {
                    if (!AssetDatabase.LoadAssetAtPath<GameObject>(path).GetComponent<HorizonPrefabList>().objectMode)
                    {
                        prefabs.RemoveAt(prefabs.Count - 1);
                        prefabs.AddRange(AssetDatabase.LoadAssetAtPath<GameObject>(path).GetComponent<HorizonPrefabList>().prefabList);
                    }
                    else
                    {
                        string message = "You specified a Object List.\nSwitch to \"Object Mode\" and try again.";
                        if (SceneView.GetWindow<SceneView>() != null) SceneView.GetWindow<SceneView>().ShowNotification(new GUIContent(message));
                    }
                }
            }
            else
            {
                string message = "The File you tried to load is not a Horizon[ON] Deco Painter Prefab List";
                if (SceneView.GetWindow<SceneView>() != null) SceneView.GetWindow<SceneView>().ShowNotification(new GUIContent(message));
            }
            //Repaint();
        } // =====================================================================================================================
    }
}