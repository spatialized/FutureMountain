using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public class LogoRamUi
    {
        private static Texture2D _logoRam;

        public static void UILogo()
        {
            EditorGUILayout.Space();
            if (_logoRam == null)
                _logoRam = AssetDatabase.LoadAssetAtPath<Texture2D>(NmIconAttribute.GetRelativeIconPath("logoRAM"));

            GUIContent btnTxt = new(_logoRam);
            var rt = GUILayoutUtility.GetRect(btnTxt, GUI.skin.label, GUILayout.ExpandWidth(false));
            rt.center = new Vector2(EditorGUIUtility.currentViewWidth / 2, rt.center.y);
            GUI.Button(rt, btnTxt, GUI.skin.label);
            EditorGUILayout.Space();
        }
    }
}