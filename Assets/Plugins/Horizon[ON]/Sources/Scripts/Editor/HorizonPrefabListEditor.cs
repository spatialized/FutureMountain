using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace Horizon
{
    [CustomEditor(typeof(HorizonPrefabList))]
    public class HorizonPrefabListEditor : Editor
    {
        string installPath;
        string inspectorGUIPath;
        float inspectorWidth;
        int scrollBarWidth = 36;

        public HorizonPrefabList hpl;


        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/HorizonPrefabListEditor.cs", "");
            inspectorGUIPath = installPath + "/Sources/Scripts/Editor/InspectorGUI";
        }

        public override void OnInspectorGUI()
        {
            hpl = (HorizonPrefabList)target;
            inspectorWidth = EditorGUIUtility.currentViewWidth;

            Rect bgRect = EditorGUILayout.GetControlRect();
            bgRect = new Rect(bgRect.x + 1, bgRect.y - 18, inspectorWidth - 47, bgRect.height + 1);

            Texture2D bgTex;
            Texture2D logoTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_Logo.png", typeof(Texture2D)) as Texture2D;
            if (EditorGUIUtility.isProSkin) { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_DarkSkin.jpg", typeof(Texture2D)) as Texture2D; }
            else { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_LightSkin.jpg", typeof(Texture2D)) as Texture2D; }
            EditorGUI.DrawPreviewTexture(bgRect, bgTex);
            GUI.DrawTexture(new Rect((inspectorWidth / 2) - 110, bgRect.y + 7, 210, 36), logoTex);


            EditorGUILayout.Space();
            EditorGUILayout.Space();
            string message;
            if (hpl.objectMode) message = "This is a Deco Painter Object List, you can load it by using the \"Load List\" button in the Object Mode Tab in the Horizon[ON] DecoPainter window!";
            else message = "This is a Deco Painter Tree List, you can load it by using the \"Load List\" button in the Tree Mode Tab in the Horizon[ON] DecoPainter window!";
            Rect rect = EditorGUILayout.GetControlRect( GUILayout.Width(inspectorWidth - scrollBarWidth), GUILayout.Height(52) );
            EditorGUI.HelpBox(rect, message, MessageType.Info);

            EditorGUILayout.Space ();

            float lineWidth = 0;
            float lineHeight = 0;
            int inline = 0;
            float netScreenWidth = inspectorWidth - scrollBarWidth;
            float elementWidth = (netScreenWidth) / 4;
            if (elementWidth > 64) elementWidth = netScreenWidth / (netScreenWidth/64);
            Rect start = EditorGUILayout.GetControlRect();

            //int startedLines = 0;
            //int endedLines = 0;
            for (int i = 0; i < hpl.prefabList.Count; i++)
            {
                if (lineWidth == 0)
                {
                    EditorGUILayout.BeginHorizontal();
                    //startedLines++;
                    inline = 0;
                }

                Rect r = EditorGUILayout.GetControlRect(GUILayout.Width(elementWidth), GUILayout.Height(elementWidth));
                r = new Rect(start.x + (inline * elementWidth), start.y + lineHeight, elementWidth, elementWidth);
                Texture2D myTexture = AssetPreview.GetAssetPreview(hpl.prefabList[i]);
                if (myTexture == null)
                {
                    string path = AssetDatabase.GetAssetPath(hpl.prefabList[i]);
                    AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
                    myTexture = AssetPreview.GetAssetPreview(hpl.prefabList[i]);
                }
                //Debug.Log(AssetPreview.GetAssetPreview(hpl.prefabList[i]));
                if (myTexture != null) EditorGUI.DrawPreviewTexture(r, myTexture);
                lineWidth += elementWidth;
                inline++;

                if ( (lineWidth > netScreenWidth - elementWidth) || (i == hpl.prefabList.Count-1) )
                {
                    EditorGUILayout.EndHorizontal();
                    //endedLines++;
                    GUILayout.Space(1);
                    lineWidth = 0;
                    lineHeight += elementWidth;
                }
                //Debug.Log("Started: " + startedLines + "  | Ended: " + endedLines);
            }

        }
    }
}
