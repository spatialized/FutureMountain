using UnityEditor;
using UnityEngine;
using System.Collections;

namespace Horizon {
	public class BlockInfoDrawer : MaterialPropertyDrawer {
		Color backgroundColor;
		bool foldoutFlag;
		private string visibilityProp1;
		private float[] visibilityPropVals1=new float[1]{1};

		public BlockInfoDrawer():base() {
			backgroundColor = Color.white;
			foldoutFlag = false;
		}
		public BlockInfoDrawer(float R, float G, float B, float A):base() {
			backgroundColor = new Color(R, G, B, A);
			foldoutFlag = false;
		}
		public BlockInfoDrawer(float R, float G, float B, float A, float foldout):base() {
			backgroundColor = new Color(R, G, B, A);
			foldoutFlag = foldout==1;
		}
		public BlockInfoDrawer(float R, float G, float B, float A, float foldout, string prop1):base() {
			backgroundColor = new Color(R, G, B, A);
			foldoutFlag = foldout==1;
			ProcessVisibilityProp1(prop1);
		}

		override public void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor) {
			if (!checkVisible (editor)) return;

			Color col = GUI.contentColor;
			Color bcol = GUI.backgroundColor;
			GUI.contentColor = new Color(1f, 1f, 0.8f, 1f);
			GUI.backgroundColor = backgroundColor;
			//position.y -= 15;
			Rect pos=new Rect(position);
			pos.y += 3;
			pos.height -= 3;
			//if (visibilityProp1==null || visibilityProp1=="indent") {
	//			pos.height -= 10;
	//			pos.y += 10;
			//}

			if (visibilityProp1!=null) {
				pos.x+=12;
				pos.width-=12;
			}
	//		pos.height = 17;
			EditorGUI.HelpBox(pos, (foldoutFlag ? "     ":"")+label, MessageType.None);

			if (foldoutFlag) {
				Rect fpos = new Rect(pos);
				fpos.x += 15;
				fpos.y += 1;
				bool state = EditorGUI.Foldout(fpos, prop.floatValue==1, "", true);
				prop.floatValue = state ? 1 : 0;
			}

			GUI.contentColor = col;
			GUI.backgroundColor = bcol;
		}
		
		override public float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor) {
			if (!checkVisible(editor)) return -2;

	//		if (foldoutFlag) {
	//			if (prop.floatValue==1) {
	//				return 17;
	//			} else {
	//				return 17;
	//			}
	//		} else {
				return 20;
	//		}
		}

		private void ProcessVisibilityProp1(string prop1) {
			string[] tmp = prop1.Split('.');
			visibilityProp1 = tmp[0];
			if (tmp.Length==1) {
				visibilityPropVals1 = new float[1]{1};
			} else {
				visibilityPropVals1 = new float[tmp.Length-1];
			}
			for(int i=0; i<tmp.Length-1; i++) {
				visibilityPropVals1[i]=float.Parse(tmp[i+1]);
			}
		}

		bool checkVisible(MaterialEditor editor) {
			if (visibilityProp1==null || visibilityProp1=="indent") return true;
			bool visible = false;
			
			// 1st level
			if (visibilityProp1 != "") {
				Material mat=editor.target as Material;
				if (mat.HasProperty(visibilityProp1)) {
					float val = mat.GetFloat(visibilityProp1);
					//Debug.Log (visibilityProp1+" "+visibilityProp2+"  "+val+"   "+visibilityPropVals1[0]); 
					for(int i=0; i<visibilityPropVals1.Length; i++) {
						visible = visible || (val==visibilityPropVals1[i]);
					}
				}
			}

			return visible;
		}
	}
}