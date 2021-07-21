using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using UnityEngine.SceneManagement;

namespace Horizon
{
    public class FindHiddenObjects : EditorWindow
    {
        Vector2 scrollPos;
        string installPath;
        Texture icon;

        // Add menu named "My Window" to the Window menu
        [MenuItem("Window/Horizon[ON]/Find all hidden Objects")]
        static void Init()
        {
            FindHiddenObjects window = (FindHiddenObjects)EditorWindow.GetWindow(typeof(FindHiddenObjects));
            window.Show();
            window.minSize = new Vector2(300, 0);
        }
        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/FindHiddenObjects.cs", "");
            icon = AssetDatabase.LoadAssetAtPath(installPath + "/Sources/Scripts/Editor/InspectorGUI/Icon.png", typeof(Texture)) as Texture;
            titleContent = new GUIContent(icon);
        }

        public List<GameObject> list = new List<GameObject>();
        float a;
        float b;
        float offset;

        void OnGUI()
        {
            GUILayout.Space(5);
            GUI.color = Color.green;
            if (GUILayout.Button("Find all hidden GameObjects in active Scene"))
            {
                list.Clear();
                Scene scene = SceneManager.GetActiveScene();
                GameObject[] allGOs = scene.GetRootGameObjects();

                for (int i = 0; i < allGOs.Length; i++)
                {
                    if (allGOs[i].hideFlags == HideFlags.HideInHierarchy || allGOs[i].hideFlags == HideFlags.HideAndDontSave)
                        list.Add(allGOs[i]);
                    Transform[] children = allGOs[i].GetComponentsInChildren<Transform>(true);
                    for (int j = 0; j < children.Length; j++)
                    {
                        if (children[j] == allGOs[i].transform) continue;
                        if (children[j].hideFlags == HideFlags.HideInHierarchy || children[j].hideFlags == HideFlags.HideAndDontSave)
                            list.Add(children[j].gameObject);
                    }
                }
            }
            GUI.color = Color.white;

            scrollPos = EditorGUILayout.BeginScrollView(scrollPos);
            if (list.Count == 0)
            {
                EditorGUILayout.HelpBox("There are no hidden Objects in this Scene.", MessageType.Info);
            }
            for (int i = 0; i < list.Count; i++)
            {
                Rect r = EditorGUILayout.GetControlRect();
                r.width = Screen.width - 41 - offset;
                r.height = 18;
                if (GUI.Button(r, "", EditorStyles.label)) Selection.activeGameObject = list[i];
                EditorGUI.ObjectField(r, "", list[i], typeof(GameObject), true);
                Rect r2 = new Rect(Screen.width - 53 - offset, r.y, 49, 18);
                if (GUI.Button(r2, "Unhide")) list[i].hideFlags = HideFlags.None;
                GUILayout.Space(2);
                if (Event.current.type == EventType.Repaint) a = GUILayoutUtility.GetLastRect().y;
            }
            EditorGUILayout.EndScrollView();
            if (Event.current.type == EventType.Repaint) b = GUILayoutUtility.GetLastRect().height;
            if (a + 5 > b) offset = 12; else offset = -1;
        }
    }
}