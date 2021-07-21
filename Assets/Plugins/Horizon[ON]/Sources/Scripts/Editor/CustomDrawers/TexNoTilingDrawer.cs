using UnityEditor;
using UnityEngine;
using System.Collections;

namespace Horizon {
	public class TexNoTilingDrawer : MaterialPropertyDrawer {
		private string visibilityProp="";

		public TexNoTilingDrawer(string propName):base() {
			visibilityProp = propName;
		}
		public TexNoTilingDrawer():base() {
			
		}

		override public void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor) {
			if (checkVisible(editor)) {
				editor.TextureProperty(position, prop, label, false);
			}
		}

		override public float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor) {
			return ( checkVisible(editor) ? MaterialEditor.GetDefaultPropertyHeight(prop) : -2 );
		}

		bool checkVisible(MaterialEditor editor) {
			bool visible = true;
			if (visibilityProp != "") {
				Material mat=editor.target as Material;
				if (mat.HasProperty(visibilityProp)) {
					return (mat.GetFloat(visibilityProp)==1);
				}
			}
			return visible;
		}

	}
}