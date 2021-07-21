using UnityEngine;
using UnityEditor;

namespace Horizon
{
    [CustomEditor(typeof(HorizonCompensateZFighting))]
    public class HorizonCompensateZFightingEditor : Editor
    {
        string installPath;
        float inspectorWidth;
        string inspectorGUIPath;
        //int scrollBarWidth = 36;

        public HorizonCompensateZFighting hczf;


        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/HorizonCompensateZFightingEditor.cs", "");
            inspectorGUIPath = installPath + "/Sources/Scripts/Editor/InspectorGUI";
        }

        public override void OnInspectorGUI()
        {
            hczf = (HorizonCompensateZFighting)target;
            inspectorWidth = EditorGUIUtility.currentViewWidth;

            Rect bgRect = EditorGUILayout.GetControlRect();
            bgRect = new Rect(bgRect.x + 36, bgRect.y - 18, inspectorWidth - 85, bgRect.height + 1);

            Texture2D bgTex;
            Texture2D logoTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_Logo.png", typeof(Texture2D)) as Texture2D;
            if (EditorGUIUtility.isProSkin) { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_DarkSkin.jpg", typeof(Texture2D)) as Texture2D; }
            else { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_LightSkin.jpg", typeof(Texture2D)) as Texture2D; }
            EditorGUI.DrawPreviewTexture(bgRect, bgTex);
            GUI.DrawTexture(new Rect((inspectorWidth / 2) - 80, bgRect.y+7, 160, 27), logoTex);

            //EditorGUILayout.Space();
            EditorGUILayout.LabelField("Compensate Z-Fighting", EditorStyles.boldLabel);
            
            string message = "This script helps to reduce the risk of Z_Fighting between the \"Transition Terrain\" object and your terrain.\n\nPlease make sure that your camera is tagged as \"MainCamera\" and that the \"Transition Terrain\" object is not set to static.";
            //Rect rect = EditorGUILayout.GetControlRect(GUILayout.Width(inspectorWidth - scrollBarWidth), GUILayout.Height(100));
            EditorGUILayout.HelpBox(message, MessageType.Info);

            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(inspectorWidth - 20));
            EditorGUILayout.LabelField("Low Camera Position", EditorStyles.boldLabel);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Camera Height:");
            hczf.minCamHeight = EditorGUILayout.FloatField(hczf.minCamHeight);
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Transition Y Offset:");
            hczf.minOffsetY = EditorGUILayout.FloatField(hczf.minOffsetY);
            EditorGUILayout.EndHorizontal();
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(inspectorWidth-20));
            EditorGUILayout.LabelField("High Camera Position", EditorStyles.boldLabel);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Camera Height:");
            hczf.maxCamHeight = EditorGUILayout.FloatField(hczf.maxCamHeight);
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Transition Y Offset:");
            hczf.maxOffsetY = EditorGUILayout.FloatField(hczf.maxOffsetY);
            EditorGUILayout.EndHorizontal();
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(inspectorWidth - 20));
        }
    }
}