using UnityEngine;
using System.Collections;

namespace Horizon {
	[AddComponentMenu("Horizon[ON]/Horizon[ON] Copy material props")]
	public class HorizonCopyMaterialProps : MonoBehaviour {
		public GameObject source;

		public void Sync(bool enabled_only_flag) {
			if (source==null) return;
			Renderer sourceRenderer = source.GetComponent<Renderer>();
			if (sourceRenderer==null) return;
			Material sourceMaterial = sourceRenderer.sharedMaterial;
			if (sourceMaterial==null) return;

			Renderer targetRenderer = GetComponent<Renderer>();
			if (targetRenderer==null) return;
			Material targetMaterial = targetRenderer.sharedMaterial;
			if (targetMaterial==null) return;

			//
			// copy props
			//

			// normals enabled?
			bool NormalsFlag = CheckEnabled("_Normalmaps", sourceMaterial) && CheckEnabled("_Normalmaps", targetMaterial);
			if (NormalsFlag || !enabled_only_flag) {
				CopyFloat("_Normalmaps", sourceMaterial, targetMaterial);
			}
			CopyTexture("_MaskRBlend1GBlend2BBlend3AWater", sourceMaterial, targetMaterial);

			CopyVector("_MapScaleOffset", sourceMaterial, targetMaterial);
			CopyVector("_Anchor", sourceMaterial, targetMaterial);
			CopyColor("_Tint", sourceMaterial, targetMaterial);

			// direct specular enabled ?
			bool DirectSpecFlag = CheckEnabled("_DirectSpec", sourceMaterial) && CheckEnabled("_DirectSpec", targetMaterial);
			if (DirectSpecFlag || !enabled_only_flag) {
				CopyFloat("_DirectSpec", sourceMaterial, targetMaterial);
				
			}

			// reflection probe enabled ?
			bool IBLSpecFlag = CheckEnabled("_IBLSpec", sourceMaterial) && CheckEnabled("_IBLSpec", targetMaterial);

			// emissiveness enabled ?
			bool EmissivenessFlag = CheckEnabled("_Emissiveness", sourceMaterial) && CheckEnabled("_Emissiveness", targetMaterial);
			if (EmissivenessFlag || !enabled_only_flag) {
				CopyFloat("_Emissiveness", sourceMaterial, targetMaterial);
				CopyColor("_EmissionColor", sourceMaterial, targetMaterial);
			}

			// detail enabled?
			bool DetailFlag = CheckEnabled("_Detail", sourceMaterial) && CheckEnabled("_Detail", targetMaterial);

			CopyColor("_AmbientOverrideAAmount", sourceMaterial, targetMaterial);

			// diffuse ambient lighting enabled ?
			bool IBLDiff = CheckEnabled("_IBLDiff", sourceMaterial) && CheckEnabled("_IBLDiff", targetMaterial);
			if (IBLDiff || !enabled_only_flag) {
				CopyFloat("_AmbientIBL", sourceMaterial, targetMaterial);
			}

			if (NormalsFlag || !enabled_only_flag) {
				CopyFloat("_GlobalNormalmapIntensity", sourceMaterial, targetMaterial);
			}

			// snow enabled ?
			bool Snow = CheckEnabled("_Snow", sourceMaterial) && CheckEnabled("_Snow", targetMaterial);
				
			float targetLayerCount = CheckType ("_LayerCount", targetMaterial);
			if (targetLayerCount==0) {
				// N to 1 layer - possible routing

				// 1st layer to 1st
				if (CompareTextures("_BaseColormap", sourceMaterial, "_BaseColormap", targetMaterial)) {
					CopyTexture("_BaseColormap", "_BaseColormap", sourceMaterial, targetMaterial);
					CopyTextureTilingOffset("_BaseColormap", "_BaseColormap", sourceMaterial, targetMaterial);
					CopyColor ("_TintSaturation", "_TintSaturation", sourceMaterial, targetMaterial); 
					if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
						CopyFloat("_BaseGloss", "_BaseGloss", sourceMaterial, targetMaterial);
						CopyColor("_SpecGloss", "_SpecGloss", sourceMaterial, targetMaterial);
					}
					if (EmissivenessFlag || !enabled_only_flag) {
						CopyFloat("_BaseEmission", "_BaseEmission", sourceMaterial, targetMaterial);
					}
					if (DetailFlag || !enabled_only_flag) {
						CopyFloat("_BaseDetailIntensity", "_BaseDetailIntensity", sourceMaterial, targetMaterial);
					}
					if (NormalsFlag || !enabled_only_flag) {
						CopyTexture("_BaseNormalmap", "_BaseNormalmap", sourceMaterial, targetMaterial);
					}
				}
				
				// 2nd layer to 1st
				if (CompareTextures("_BlendColorMap1", sourceMaterial, "_BaseColormap", targetMaterial)) {
					CopyTexture("_BlendColorMap1", "_BaseColormap", sourceMaterial, targetMaterial);
					CopyColor ("_TintSaturationBlend1", "_TintSaturation", sourceMaterial, targetMaterial); 
					CopyTextureTilingOffset("_BlendColorMap1", "_BaseColormap", sourceMaterial, targetMaterial);
					if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
						CopyFloat("_BlendGloss1", "_BaseGloss", sourceMaterial, targetMaterial);
						CopyColor("_SpecGlossBlend1", "_SpecGloss", sourceMaterial, targetMaterial);
					}
					if (EmissivenessFlag || !enabled_only_flag) {
						CopyFloat("_BlendEmission1", "_BaseEmission", sourceMaterial, targetMaterial);
					}
					if (DetailFlag || !enabled_only_flag) {
						CopyFloat("_BlendDetailIntensity1", "_BaseDetailIntensity", sourceMaterial, targetMaterial);
					}
					if (NormalsFlag || !enabled_only_flag) {
						CopyTexture("_BlendNormalmap1", "_BaseNormalmap", sourceMaterial, targetMaterial);
					}
				}
				
				// 3rd layer to 1st
				if (CompareTextures("_BlendColormap2", sourceMaterial, "_BaseColormap", targetMaterial)) {
					CopyTexture("_BlendColormap2", "_BaseColormap", sourceMaterial, targetMaterial);
					CopyColor ("_TintSaturationBlend2", "_TintSaturation", sourceMaterial, targetMaterial); 
					CopyTextureTilingOffset("_BlendColormap2", "_BaseColormap", sourceMaterial, targetMaterial);
					if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
						CopyFloat("_BlendGloss2", "_BaseGloss", sourceMaterial, targetMaterial);
						CopyColor("_SpecGlossBlend2", "_SpecGloss", sourceMaterial, targetMaterial);
					}
					if (EmissivenessFlag || !enabled_only_flag) {
						CopyFloat("_BlendEmission2", "_BaseEmission", sourceMaterial, targetMaterial);
					}
					if (DetailFlag || !enabled_only_flag) {
						CopyFloat("_BlendDetailIntensity2", "_BaseDetailIntensity", sourceMaterial, targetMaterial);
					}
					if (NormalsFlag || !enabled_only_flag) {
						CopyTexture("_BlendNormalmap2", "_BaseNormalmap", sourceMaterial, targetMaterial);
					}
				}
				
				// 4th layer to 1st
				if (CompareTextures("_BlendColormap3", sourceMaterial, "_BaseColormap", targetMaterial)) {
					CopyTexture("_BlendColormap3", "_BaseColormap", sourceMaterial, targetMaterial);
					CopyColor ("_TintSaturationBlend3", "_TintSaturation", sourceMaterial, targetMaterial); 
					CopyTextureTilingOffset("_BlendColormap3", "_BaseColormap", sourceMaterial, targetMaterial);
					if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
						CopyFloat("_BlendGloss3", "_BaseGloss", sourceMaterial, targetMaterial);
						CopyColor("_SpecGlossBlend3", "_SpecGloss", sourceMaterial, targetMaterial);
					}
					if (EmissivenessFlag || !enabled_only_flag) {
						CopyFloat("_BlendEmission3", "_BaseEmission", sourceMaterial, targetMaterial);
					}
					if (DetailFlag || !enabled_only_flag) {
						CopyFloat("_BlendDetailIntensity3", "_BaseDetailIntensity", sourceMaterial, targetMaterial);
					}
					if (NormalsFlag || !enabled_only_flag) {
						CopyTexture("_BlendNormalmap3", "_BaseNormalmap", sourceMaterial, targetMaterial);
					}
				}
				//
				// routed layers (copy from Nth to 1st)
			} else {
				//
				// no routing - direct layers 1-4 copy
				//
				// 1st layer
				CopyTexture("_BaseColormap", sourceMaterial, targetMaterial);
				CopyTextureTilingOffset("_BaseColormap", sourceMaterial, targetMaterial);
				CopyColor("_TintSaturation", sourceMaterial, targetMaterial); 
				if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
					CopyFloat("_BaseGloss", sourceMaterial, targetMaterial);
					CopyColor("_SpecGloss", sourceMaterial, targetMaterial);
				}
				if (EmissivenessFlag || !enabled_only_flag) {
					CopyFloat("_BaseEmission", sourceMaterial, targetMaterial);
				}
				if (DetailFlag || !enabled_only_flag) {
					CopyFloat("_BaseDetailIntensity", sourceMaterial, targetMaterial);
				}
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_BaseNormalmap", sourceMaterial, targetMaterial);
				}

				// 2nd layer
				CopyTexture("_BlendColorMap1", sourceMaterial, targetMaterial);
				CopyTextureTilingOffset("_BlendColorMap1", sourceMaterial, targetMaterial);
				CopyColor("_TintSaturationBlend1", sourceMaterial, targetMaterial); 
				if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
					CopyFloat("_BlendGloss1", sourceMaterial, targetMaterial);
					CopyColor("_SpecGlossBlend1", sourceMaterial, targetMaterial);
				}
				if (EmissivenessFlag || !enabled_only_flag) {
					CopyFloat("_BlendEmission1", sourceMaterial, targetMaterial);
				}
				if (DetailFlag || !enabled_only_flag) {
					CopyFloat("_BlendDetailIntensity1", sourceMaterial, targetMaterial);
				}
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_BlendNormalmap1", sourceMaterial, targetMaterial);
				}

				// 3rd layer
				CopyTexture("_BlendColormap2", sourceMaterial, targetMaterial);
				CopyTextureTilingOffset("_BlendColormap2", sourceMaterial, targetMaterial);
				CopyColor("_TintSaturationBlend2", sourceMaterial, targetMaterial); 
				if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
					CopyFloat("_BlendGloss2", sourceMaterial, targetMaterial);
					CopyColor("_SpecGlossBlend2", sourceMaterial, targetMaterial);
				}
				if (EmissivenessFlag || !enabled_only_flag) {
					CopyFloat("_BlendEmission2", sourceMaterial, targetMaterial);
				}
				if (DetailFlag || !enabled_only_flag) {
					CopyFloat("_BlendDetailIntensity2", sourceMaterial, targetMaterial);
				}
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_BlendNormalmap2", sourceMaterial, targetMaterial);
				}

				// 4th layer
				CopyTexture("_BlendColormap3", sourceMaterial, targetMaterial);
				CopyTextureTilingOffset("_BlendColormap3", sourceMaterial, targetMaterial);
				CopyColor("_TintSaturationBlend3", sourceMaterial, targetMaterial); 
				if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
					CopyFloat("_BlendGloss3", sourceMaterial, targetMaterial);
					CopyColor("_SpecGlossBlend3", sourceMaterial, targetMaterial);
				}
				if (EmissivenessFlag || !enabled_only_flag) {
					CopyFloat("_BlendEmission3", sourceMaterial, targetMaterial);
				}
				if (DetailFlag || !enabled_only_flag) {
					CopyFloat("_BlendDetailIntensity3", sourceMaterial, targetMaterial);
				}
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_BlendNormalmap3", sourceMaterial, targetMaterial);
				}
				//
				// direct layer 1-4 copy
			}

			// detail
			if (DetailFlag || !enabled_only_flag) {
				CopyFloat("_Detail", sourceMaterial, targetMaterial);
				CopyTexture("_DetailColormap", sourceMaterial, targetMaterial);
				CopyFloat("_DetailColormapIntensity", sourceMaterial, targetMaterial);
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_DetailNormalmap", sourceMaterial, targetMaterial);
					CopyFloat("_DetailNormalmapIntensity", sourceMaterial, targetMaterial);
				}
			}
				
			// cliff
			CopyTexture("_CliffColormap", sourceMaterial, targetMaterial);
			if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
				CopyFloat("_CliffGloss", sourceMaterial, targetMaterial);
				CopyColor("_SpecGlossCliff", sourceMaterial, targetMaterial);
			}
			if (EmissivenessFlag || !enabled_only_flag) {
				CopyFloat("_CliffEmission", sourceMaterial, targetMaterial);
			}
			if (NormalsFlag || !enabled_only_flag) {
				CopyTexture("_CliffNormalmap", sourceMaterial, targetMaterial);
			}

			// cliff detail
			bool CliffDetail = CheckEnabled("_CliffDetail", sourceMaterial) && CheckEnabled("_CliffDetail", targetMaterial);
			if (CliffDetail || !enabled_only_flag) {
				CopyFloat("_CliffDetail", sourceMaterial, targetMaterial);
				CopyTexture("_CliffDetailmap", sourceMaterial, targetMaterial);
				CopyFloat("_CliffDetailColorIntensity", sourceMaterial, targetMaterial);
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_CliffDetailNormalmap", sourceMaterial, targetMaterial);
					CopyFloat("_CliffDetailNormalIntensity", sourceMaterial, targetMaterial);
				}
			}

			// water
			bool Water = CheckEnabled("_Water", sourceMaterial) && CheckEnabled("_Water", targetMaterial);
			if (Water || !enabled_only_flag) {
				CopyFloat("_Water", sourceMaterial, targetMaterial);
				CopyColor("_WaterColorAColorBlend", sourceMaterial, targetMaterial);
				if (DirectSpecFlag || IBLSpecFlag || !enabled_only_flag) {
					CopyColor("_WaterSpecGloss", sourceMaterial, targetMaterial);
				}
				CopyFloat("_WaterBlend", sourceMaterial, targetMaterial);
				if (NormalsFlag || !enabled_only_flag) {
					CopyTexture("_WaterNormalmap", sourceMaterial, targetMaterial);
					CopyFloat("_WaterWaves", sourceMaterial, targetMaterial);
					CopyFloat("_WaterWaveSpeed", sourceMaterial, targetMaterial);
				}
			}

			// diffuse ambient lighting props
			if (IBLDiff || !enabled_only_flag) {
				CopyFloat("_IBLDiff", sourceMaterial, targetMaterial);
				CopyFloat("_DiffIBLMulti", sourceMaterial, targetMaterial);
			}
			// diffuse ambient lighting type
			IBLDiff = IBLDiff && (CheckType("_IBLDiff", sourceMaterial)==CheckType("_IBLDiff", targetMaterial));
			if (IBLDiff || !enabled_only_flag) {
				// copy IBL cubemap
				if (CheckType("_IBLDiff", sourceMaterial)==1) {
					CopyTexture("_DiffuseIBLCubemap", sourceMaterial, targetMaterial);
				}
			}

			// reflection probe
			if (IBLSpecFlag || !enabled_only_flag) {
				CopyFloat("_IBLSpec", sourceMaterial, targetMaterial);
				CopyTexture("unity_SpecCube", sourceMaterial, targetMaterial);
				CopyFloat("_IBLSpecRoughMIP", sourceMaterial, targetMaterial);
				CopyFloat("_IBLMIPDim_Rough", sourceMaterial, targetMaterial);
				CopyFloat("_IBLSpecGlossMIP", sourceMaterial, targetMaterial);
				CopyFloat("_IBLMIPDim_Gloss", sourceMaterial, targetMaterial);
			}

			// tessellation & displacement
			CopyFloat("_EdgeLength", sourceMaterial, targetMaterial);
			CopyFloat("_Parallax", sourceMaterial, targetMaterial);
			CopyFloat("_ReduceByVertexAlpha", sourceMaterial, targetMaterial);
			CopyFloat("_ReduceByUVBorder", sourceMaterial, targetMaterial);
			CopyFloat("_ReduceByUVBorderLength", sourceMaterial, targetMaterial);
			CopyTexture("_ParallaxMap", sourceMaterial, targetMaterial);

			// snow
			if (Snow || !enabled_only_flag) {
				CopyFloat("_SnowAmount", sourceMaterial, targetMaterial);
				CopyColor("_SnowColor", sourceMaterial, targetMaterial);
				CopyColor("_SnowSpecGloss", sourceMaterial, targetMaterial);
				CopyFloat("_SnowHeight", sourceMaterial, targetMaterial);
				CopyFloat("_SnowHeightTransition", sourceMaterial, targetMaterial);
				CopyFloat("_SnowSlopeDamp", sourceMaterial, targetMaterial);
				CopyFloat("_SnowOutputColorBrightness2Coverage", sourceMaterial, targetMaterial);
			}

			// fog
			bool OverlayFog = CheckEnabled("_IBLDiff", sourceMaterial) && CheckEnabled("_IBLDiff", targetMaterial);
			if (OverlayFog || !enabled_only_flag) {
				CopyFloat("_OverlayFog", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogAmount", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogAmountFromReflCubemap", sourceMaterial, targetMaterial);

				CopyColor("_OverlayFogColorAfromAmbient", sourceMaterial, targetMaterial);

				CopyFloat("_OverlayFogStartDistance", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogDistanceTransition", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogStartHeight", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogHeightTransition", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogDistance2Height", sourceMaterial, targetMaterial);
				CopyFloat("_OverlayFogEmissivePunchThru", sourceMaterial, targetMaterial);
			}

			// keywords
			if (!enabled_only_flag) {
				targetMaterial.shaderKeywords=sourceMaterial.shaderKeywords;
			}
		}

		void CopyFloat(string propName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(propName)) {
				targetMaterial.SetFloat(propName, sourceMaterial.GetFloat(propName));
			}
		}
		void CopyFloat(string propName, string targetPropName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(targetPropName)) {
				targetMaterial.SetFloat(targetPropName, sourceMaterial.GetFloat(propName));
			}
		}
		void CopyColor(string propName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(propName)) {
				targetMaterial.SetColor(propName, sourceMaterial.GetColor(propName));
			}
		}
		void CopyColor(string propName, string targetPropName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(targetPropName)) {
				targetMaterial.SetColor(targetPropName, sourceMaterial.GetColor(propName));
			}
		}
		void CopyVector(string propName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(propName)) {
				targetMaterial.SetVector(propName, sourceMaterial.GetVector(propName));
			}
		}
		void CopyVector(string propName, string targetPropName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(targetPropName)) {
				targetMaterial.SetVector(targetPropName, sourceMaterial.GetVector(propName));
			}
		}
		void CopyTexture(string propName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(propName)) {
				Texture tex=sourceMaterial.GetTexture(propName);
				if (tex) targetMaterial.SetTexture(propName, tex);
			}
		}
		void CopyTexture(string propName, string targetPropName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(targetPropName)) {
				Texture tex=sourceMaterial.GetTexture(propName);
				if (tex) targetMaterial.SetTexture(targetPropName, tex);
			}
		}
		void CopyTextureTilingOffset(string propName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(propName)) {
				targetMaterial.SetTextureScale(propName, sourceMaterial.GetTextureScale(propName));
				targetMaterial.SetTextureOffset(propName, sourceMaterial.GetTextureOffset(propName));
			}
		}
		void CopyTextureTilingOffset(string propName, string targetPropName, Material sourceMaterial, Material targetMaterial) {
			if (sourceMaterial.HasProperty(propName) && targetMaterial.HasProperty(targetPropName)) {
				targetMaterial.SetTextureScale(targetPropName, sourceMaterial.GetTextureScale(propName));
				targetMaterial.SetTextureOffset(targetPropName, sourceMaterial.GetTextureOffset(propName));
			}
		}

		bool CheckEnabled(string propName, Material mat) {
			if (mat.HasProperty(propName)) {
				if (mat.GetFloat(propName)!=0) {
					return true;
				}
			}
			return false;
		}

		float CheckType(string propName, Material mat) {
			if (mat.HasProperty(propName)) {
				return mat.GetFloat(propName);
			}
			return 0;
		}
		
		bool CompareTextures(string sourcePropName, Material sourceMaterial, string targetPropName, Material targetMaterial) {
			if (sourceMaterial.HasProperty(sourcePropName) && targetMaterial.HasProperty (targetPropName)) {
				Texture sourceTexture=sourceMaterial.GetTexture(sourcePropName);
				Texture targetTexture=targetMaterial.GetTexture(targetPropName);
				if ( (sourceTexture!=null) && (sourceTexture==targetTexture) ) {
					return true;
				}
			}
			return false;
		}

	}
}