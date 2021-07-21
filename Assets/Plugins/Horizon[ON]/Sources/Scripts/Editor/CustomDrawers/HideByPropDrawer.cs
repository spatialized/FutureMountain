using UnityEditor;
using UnityEngine;
using System.Collections;

namespace Horizon {
	public class HideByPropDrawer : MaterialPropertyDrawer {
		private string visibilityProp1;
		private float[] visibilityPropVals1=new float[1]{1};
		private string visibilityProp2;
		private float[] visibilityPropVals2=new float[1]{1};
		private bool texTileOffset = true;
		private bool inactiveFlag1 = false;
		private bool inactiveFlag2 = false;
		private bool BoolOrFlag = false;

		public HideByPropDrawer(string prop1):base() {
			if (inactiveFlag1 = (prop1.IndexOf("INACTIVE")==0)) prop1=prop1.Substring(8);
			ProcessVisibilityProp1(prop1);
			texTileOffset = true;
		}
		public HideByPropDrawer(string prop1, float texTileOffset):base() {
			if (inactiveFlag1 = (prop1.IndexOf("INACTIVE")==0)) prop1=prop1.Substring(8);
			ProcessVisibilityProp1(prop1);
			this.texTileOffset = (texTileOffset == 1);
		}
		public HideByPropDrawer(string prop1, string prop2):base() {
			if (inactiveFlag1 = (prop1.IndexOf("INACTIVE")==0)) prop1=prop1.Substring(8);
			if (prop2.IndexOf("INACTIVE")==0) {
				inactiveFlag2=true;
				prop2=prop2.Substring(8);
			}
			if (prop2.IndexOf("LOGICOR")==0) {
				BoolOrFlag=true;
				prop2=prop2.Substring(7);
			}
			//Debug.Log (prop1 + "  " + prop2 + "  " + inactiveFlag1 + "  " + inactiveFlag2);
			ProcessVisibilityProp1(prop1);
			ProcessVisibilityProp2(prop2);
		}
		public HideByPropDrawer(string prop1, string prop2, float texTileOffset):base() {
			if (inactiveFlag1 = (prop1.IndexOf("INACTIVE")==0)) prop1=prop1.Substring(8);
			if (prop2.IndexOf("INACTIVE")==0) {
				inactiveFlag2=true;
				prop2=prop2.Substring(8);
			}
			if (prop2.IndexOf("LOGICOR")==0) {
				BoolOrFlag=true;
				prop2=prop2.Substring(7);
			}
			ProcessVisibilityProp1(prop1);
			ProcessVisibilityProp2(prop2);
			//Debug.Log (visibilityProp1 + "  " + visibilityProp2 + "  " + visibilityPropVals1 + "  " + visibilityPropVals2);
			this.texTileOffset = (texTileOffset == 1);
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
		private void ProcessVisibilityProp2(string prop2) {
			string[] tmp = prop2.Split('.');
			visibilityProp2 = tmp[0];
			if (tmp.Length==1) {
				visibilityPropVals2 = new float[1]{1};
			} else {
				visibilityPropVals2 = new float[tmp.Length-1];
			}
			for(int i=0; i<tmp.Length-1; i++) {
				visibilityPropVals2[i]=float.Parse(tmp[i+1]);
			}
		}

		override public void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor) {
			bool inactiveFlag = false;
			if (!checkNormalmapsUsage(editor.target as Material, label)) return;
			if (!checkDetailUsage(editor.target as Material, label)) return;
			if (!checkSpecUsage(editor.target as Material, label)) return;
			#if UNITY_5
				if (prop.name=="unity_SpecCube" || prop.name=="unity_SpecCube1") return;
			#endif

			if (checkVisible (editor, label, ref inactiveFlag)) {
				EditorGUI.BeginDisabledGroup(inactiveFlag);
				switch (prop.type) {
					case MaterialProperty.PropType.Range: // float ranges
					{
						editor.RangeProperty(position, prop, label);
						break;
					}
					case MaterialProperty.PropType.Float: // floats
					{
						editor.FloatProperty(position, prop, label);
						break;
					}
					case MaterialProperty.PropType.Color: // colors
					{
						editor.ColorProperty(position, prop, label);
						break;
					}
					case MaterialProperty.PropType.Texture: // textures
					{
						editor.TextureProperty(position, prop, label, texTileOffset);
						break;
					}
					case MaterialProperty.PropType.Vector: // vectors
					{
						position.x+=12;
						position.width-=12;
						editor.VectorProperty(position, prop, label);
						break;
					}
					default:
					{
						GUILayout.Label("Unknown prop type... ("+label+")");
						break;
					}
				}
				EditorGUI.EndDisabledGroup();
			}
		}

		bool checkNormalmapsUsage(Material mat, string label) {
			if (label.ToLower().IndexOf("normalmap")<0 && label.IndexOf("Water wave")<0) return true;
			if (!mat.HasProperty("_Normalmaps")) return true;
			if (mat.GetFloat("_Normalmaps")==0) return false;
			return true;
		}

		bool checkDetailUsage(Material mat, string label) {
			if (label.ToLower().IndexOf ("cliff")>= 0) {
				// cliff detail
				if (label.ToLower().IndexOf("detail colormap")>0) {
					if (!mat.HasProperty("_CliffDetail")) return true;
					if (mat.GetFloat("_CliffDetail")==0) return false;
				}
				if (label.ToLower().IndexOf("detail normalmap")>0) {
					if (!mat.HasProperty("_CliffDetail") || !mat.HasProperty("_IBLDiff")) return true;
					if (mat.GetFloat("_CliffDetail")==2 && mat.GetFloat("_IBLDiff")==1) return false;
				}
				return true;
			} else {
				if (label.ToLower().IndexOf("detail")<0) return true;
				if (!mat.HasProperty("_Detail")) return true;
				if (mat.GetFloat("_Detail")==0) return false;
				return true;
			}
		}

		bool checkSpecUsage(Material mat, string label) {
			if ((label.IndexOf("layer Spec+Gloss")<0) && (label.IndexOf("gloss mask")<0) && (label.IndexOf("Spec (RGB)")<0)) return true;
			if (!mat.HasProperty("_DirectSpec")) return true;
			if (!mat.HasProperty("_IBLSpec")) return true;
			if (mat.GetFloat("_DirectSpec")==0 && mat.GetFloat("_IBLSpec")==0) return false;
			return true;
		}

		bool HorizONWatercheckUsage(Material mat, string label) {
			if (label.IndexOf("Mask Scale (XY)")>=0 || label.IndexOf("Mask (R)Blend 1")>=0) {
				if (!mat.HasProperty("_Water")) return false;
				if (mat.GetFloat("_Water")==1) return true;
			}
			return false;
		}

		override public float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor) {
			bool inactiveFlag=false;
			if (!checkNormalmapsUsage(editor.target as Material, label)) return -2;
			if (!checkDetailUsage(editor.target as Material, label)) return -2;
			if (!checkSpecUsage(editor.target as Material, label)) return -2;
			#if UNITY_5
			if (prop.name=="unity_SpecCube" || prop.name=="unity_SpecCube1") return 0;
			#endif
			if (checkVisible(editor, label, ref inactiveFlag)) {
				return MaterialEditor.GetDefaultPropertyHeight(prop);
			}
			return -2;
		}

		bool checkVisible(MaterialEditor editor, string label, ref bool inactiveFlagOut) {
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
				if (!visible && inactiveFlag1) inactiveFlagOut=true;
				visible = visible || inactiveFlag1; 
			}
			if (BoolOrFlag || (HorizONWatercheckUsage(editor.target as Material, label) && visible)) {
				if (visible) return true;
			} else {
				if (!visible) return false;
			}

			// 2nd nested level
			if (visibilityProp2 != "") {
				Material mat=editor.target as Material;
				if (mat.HasProperty(visibilityProp2)) {
					visible=false;
					float val = mat.GetFloat(visibilityProp2);
					for(int i=0; i<visibilityPropVals2.Length; i++) {
						visible = visible || (val==visibilityPropVals2[i]);
					}
					if (!visible && inactiveFlag2) inactiveFlagOut=true;
					visible = visible || inactiveFlag2;
				}
			}

			return visible;
		}

	}
}