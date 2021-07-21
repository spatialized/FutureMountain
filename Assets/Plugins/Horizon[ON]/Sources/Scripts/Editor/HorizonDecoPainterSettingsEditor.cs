using UnityEngine;
using UnityEditor;

namespace Horizon
{
    [CustomEditor(typeof(HorizonDecoPainterSettings))]
    public class HorizonDecoPainterSettingsEditor : Editor
    {
        string installPath;
        string inspectorGUIPath;
        float inspectorWidth;
        int scrollBarWidth = 36;

        public HorizonDecoPainterSettings hdps;

        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/HorizonDecoPainterSettingsEditor.cs", "");
            inspectorGUIPath = installPath + "/Sources/Scripts/Editor/InspectorGUI";
        }

        public override void OnInspectorGUI()
        {
            hdps = (HorizonDecoPainterSettings)target;
            inspectorWidth = EditorGUIUtility.currentViewWidth;

            Rect bgRect = EditorGUILayout.GetControlRect();
            bgRect = new Rect(bgRect.x + 1, bgRect.y - 18, inspectorWidth - 40, bgRect.height + 1);

            Texture2D bgTex;
            Texture2D logoTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_Logo.png", typeof(Texture2D)) as Texture2D;
            if (EditorGUIUtility.isProSkin) { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_DarkSkin.jpg", typeof(Texture2D)) as Texture2D; }
            else { bgTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_LightSkin.jpg", typeof(Texture2D)) as Texture2D; }
            EditorGUI.DrawPreviewTexture(bgRect, bgTex);
            GUI.DrawTexture(new Rect((inspectorWidth / 2) - 110, bgRect.y + 7, 210, 36), logoTex);


            EditorGUILayout.Space();
            EditorGUILayout.Space();
            string message = "This Object holds the current settings of the Horizon[ON] Deco Painter, it wont be included in builds but anyway, you can savely delete it. The Horizon[ON] Deco Painter will create a new one if there is none. Deleting it will only cause it to forget its current settings.";
            Rect rect = EditorGUILayout.GetControlRect(GUILayout.Width(inspectorWidth - scrollBarWidth), GUILayout.Height(85));
            EditorGUI.HelpBox(rect, message, MessageType.Info);

            EditorGUILayout.Space();
            hdps.sizeVariationMinMaxLimit = EditorGUILayout.Vector2Field("Tree Size Limits:", hdps.sizeVariationMinMaxLimit);
        }
    }
}