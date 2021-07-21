using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Horizon {
	[AddComponentMenu("Horizon[ON]/Horizon[ON] Master")]
	[SelectionBase]
	[ExecuteInEditMode]
	public class HorizonMaster : MonoBehaviour {

        // Material List
        [HideInInspector] public List<Material> hMats = new List<Material> ();

		// Misc
		[HideInInspector] public bool isPreset = false;
		[HideInInspector] public bool childUsesDisplacement = false;
		[HideInInspector] public bool childUsesTesselation = false;
		[HideInInspector] public bool childUsesCliffs = false;
		[HideInInspector] public bool childUsesTransition = false;
		[HideInInspector] public bool horizonChildAvailable = false;
		[HideInInspector] public bool drawGizmos = false;
		[HideInInspector] public Color gizmoColor = Color.blue;
		[HideInInspector] public bool updateHorizonMaster = true;
		[HideInInspector] public bool showWireF = true;
		[HideInInspector] public Material getFromMaterialMat;
		[HideInInspector] public bool setFeatures = true;
		[HideInInspector] public bool getFeatures = false;
		[HideInInspector] public bool getMatSettings = false;
		private int objectNumber = 0;
		private Transform[] children;

		// Remember EditorWindow Layout
		[HideInInspector] public bool showFeatures = false;
		[HideInInspector] public bool showScaling = false;
		[HideInInspector] public bool showMainSettings = false;
		[HideInInspector] public bool showDetailSettings = false;
		[HideInInspector] public bool showWaterSettings = false;
		[HideInInspector] public bool showFogSettings = false;
		[HideInInspector] public bool showSnowSettings = false;
		[HideInInspector] public bool showDispSettings = false;
		[HideInInspector] public bool showCliffSettings = false;
		[HideInInspector] public bool showTools = false;

		// Features
		[HideInInspector] public enum LayerCount {One = 1, Two = 2, Three = 3, Four = 4};
		[HideInInspector] public LayerCount hFeatLayerCount = LayerCount.One;
		[HideInInspector] public int layerCount = 1;
		[HideInInspector] public bool hFeatNormalmaps = false;
		[HideInInspector] public bool hFeatEmissivness = false;
		[HideInInspector] public bool hFeatDetailTex = false;
		[HideInInspector] public bool hFeatWater = false;
		[HideInInspector] public bool hFeatFog = false;
		[HideInInspector] public bool hFeatSnow = false;
		[HideInInspector] public bool hFeatDirSpec = false;
		[HideInInspector] public bool hFeatCubeRefl = false;
        // Settings Disc Scaling
        [HideInInspector] [Range(0,1)] public float hSetScaleInner = 0.9f;
		[HideInInspector] public float hSetScaleOuter = 0;
		[HideInInspector] [Range(0,1)] public float hSetScaleHeight = 0.2f;
		// Settings Main
		[HideInInspector] public Vector4 hSetMaskScaleOffset = new Vector4(12000,12000,6000,6000);
		[HideInInspector] public bool hSetLockMask = false;
		[HideInInspector] public Texture hTexMask;
		[HideInInspector] public Color hColTint = Color.white;
		[HideInInspector] public Color hColEmissColor = Color.white;
		[HideInInspector] public Color hColAmbOverride = new Color (0.8f,0.8f,1f,0);
        [HideInInspector] public float hSetIBLExposure = 0.6f;
        [HideInInspector] public float hSetIBLReflExposure = 1f;
		[HideInInspector] [Range(0,1)] public float hSetAmbvsIBL = 1;
		[HideInInspector] [Range(0,1)] public float hSetNMIntensLayers = 1;
		// Settings LayerProperties
		[HideInInspector] public HorizON_LayerProps[] hSetLayerProps = new HorizON_LayerProps[5];
		// Settings Detail
		[HideInInspector] public Vector4 hSetDetailScaleOffset = new Vector4(100,100,0,0);
		[HideInInspector] public Texture hTexDetailTexDiff;
		[HideInInspector] public Texture hTexDetailTexNM;
		[HideInInspector] [Range(0,1)] public float hSetDetailDiffIntens = 0.1f;
		[HideInInspector] [Range(0,1)] public float hSetDetailNMIntens = 1;
		// Settings Water
		[HideInInspector] public Texture hTexWaterNM;
		[HideInInspector] public Vector4 hSetWaterScaleOffset = new Vector4(100,100,0,0);
		[HideInInspector] public Color hColWaterColorOpac = new Color32(0,34,26,243);
		[HideInInspector] public Color hColWaterSpecGloss = new Color(0,0,0,1);
		[HideInInspector] [Range(0,1)] public float hSetWaterBlend = 0.98f;
		[HideInInspector] [Range(0,1)] public float hSetWaterWavesIntens = 0.15f;
		[HideInInspector] public float HSetWaterWavesSpeed = 1;
		// Settings Fog
		[HideInInspector] [Range(0,1)] public float hSetFogIntens = 1;
		[HideInInspector] public Color hColFogColorAmbBlend = new Color32(223,230,235,0);
		[HideInInspector] [Range(0,1)] public float hSetFogSpecCubeAdd = 0.3f;
		[HideInInspector] public float hSetFogStartDist = 1000;
		[HideInInspector] public float hSetFogTransDist = 15000;
		[HideInInspector] public float hSetFogStartHeight = 0;
		[HideInInspector] public float hSetFogTransHeight = 200;
		[HideInInspector] public float hSetFogDistHeightOffset = 15000;
		[HideInInspector] [Range(0,1)] public float hSetFogEmissPunchThru = 0.1f;
		// Settings Snow
		[HideInInspector] [Range(0,1)] public float hsetSnowAmount = 1;
		[HideInInspector] public Color hColSnowDiffColor = new Color32(174,189,205,0);
		[HideInInspector] public Color hColSnowSpecGloss = new Color(0.8f,0.8f,0.8f,0.2f);
		[HideInInspector] public float hSetSnowStartHeight = 70;
		[HideInInspector] public float hSetSnowHeightTrans = 700;
		[HideInInspector] [Range(0,1)] public float hSetSnowSlopeDamp = 0.75f;
		[HideInInspector] [Range(0,1)] public float hSetSnowReduceByColor = 0.75f;
		// Settings Displacement & Tesselation
		[HideInInspector] public float hSetDispHeight = 250;
		[HideInInspector] public bool hSetDispRedByVertCol = false;
		[HideInInspector] public bool hSetDispRedByUV = true;
		[HideInInspector] [Range(0.05f,1)] public float hSetDispRedFadeAmount = 1;
		[HideInInspector] public Texture hTexDispHeightmap;
		[HideInInspector] [Range(1,40)] public float hSetTessSubD = 1;
		// Settings Cliffs
		[HideInInspector] public Texture hTexCliffDiff;
		[HideInInspector] public Vector4 hSetCliffScaleOffset = new Vector4(50,50,0,0);
		[HideInInspector] public bool hSetCliffAIsEmissMask = false;
		[HideInInspector] public Texture hTexCliffNM;
        // =====================================================================================================================
        // =====================================================================================================================
        // =====================================================================================================================

#if UNITY_EDITOR

        void Update(){
			if (hSetLockMask){
				foreach (Material m in hMats) {
					if (m != null){
						if (m.HasProperty ("_Anchor")) { if (hSetLockMask) m.SetVector ("_Anchor", new Vector4(transform.localPosition.x, 0, transform.localPosition.z, 1)); else m.SetVector ("_Anchor", new Vector4(0,0,0,0)); }
					}
				}
			}
		}

		public void SavePreset(string path){
			if (path.Length == 0) return;
			path = path.Replace(Application.dataPath+"/","Assets/");
			GameObject tempParent = new GameObject();
			int childCount = this.transform.childCount;
			for (int i = 0;i < childCount;++i) this.transform.GetChild(0).parent = tempParent.transform;
			isPreset = true;
			GameObject save = Instantiate(this.gameObject) as GameObject;
			UnityEditor.AssetDatabase.DeleteAsset(path);
			UnityEngine.Object prefab = UnityEditor.PrefabUtility.CreateEmptyPrefab(path);
			UnityEditor.PrefabUtility.ReplacePrefab(save,prefab,UnityEditor.ReplacePrefabOptions.ReplaceNameBased);
			DestroyImmediate(save);
			for (int i = 0;i < childCount;++i) tempParent.transform.GetChild(0).parent = this.transform;
			DestroyImmediate (tempParent);
			isPreset = false;
		}// =====================================================================================================================

		public void LoadPreset(string path){
			if (path.Length == 0) return;
			path = path.Replace(Application.dataPath+"/","Assets/");
			int index = this.transform.GetSiblingIndex();
			GameObject newHorizon = (GameObject)Instantiate(UnityEditor.AssetDatabase.LoadAssetAtPath(path,typeof(GameObject)));
			newHorizon.name = this.gameObject.name;
			int childCount = this.transform.childCount;
			for (int i = 0;i < childCount;++i) this.transform.GetChild(0).parent = newHorizon.transform;
			DestroyImmediate(this.gameObject);
			newHorizon.transform.SetSiblingIndex(index);
			UnityEditor.Selection.activeGameObject = newHorizon;
			newHorizon.GetComponent<HorizonMaster>().isPreset = false;
		}// =====================================================================================================================

		public void ShowWireFrame (bool active){
			foreach (MeshRenderer mr in GetComponentsInChildren<MeshRenderer>()) {
                if (active) UnityEditor.EditorUtility.SetSelectedRenderState(mr, UnityEditor.EditorSelectedRenderState.Hidden);
                else
                {
                    UnityEditor.EditorUtility.SetSelectedRenderState(mr, UnityEditor.EditorSelectedRenderState.Wireframe);
                    //UnityEditor.EditorUtility.SetSelectedRenderState(mr, UnityEditor.EditorSelectedRenderState.Highlight);
                }
            }
		}

		public void InitLayerProps()
		{
			for (int i = 0;i < hSetLayerProps.Length;++i) {
				if (hSetLayerProps[i] == null) hSetLayerProps[i] = new HorizON_LayerProps();
			}
		}

		public void CheckMaterials(){
			horizonChildAvailable = false;
			childUsesDisplacement = false;
			childUsesTesselation = false;
			childUsesCliffs = false;
			childUsesTransition = false;
			hMats.Clear ();
			foreach (MeshRenderer mr in GetComponentsInChildren<MeshRenderer>()) {
				if (mr.sharedMaterial.HasProperty ("_BaseColormap")) {
					horizonChildAvailable = true;
				}
				if (mr.sharedMaterial.HasProperty ("_Parallax")) {
					childUsesDisplacement = true;
				}
				if (mr.sharedMaterial.HasProperty ("_EdgeLength")) {
					childUsesTesselation = true;
				}
				if (mr.sharedMaterial.HasProperty ("_CliffColormap")) {
					childUsesCliffs = true;
				}
				if (mr.sharedMaterial.HasProperty ("_ScaleInner")) {
					childUsesTransition = true;
				}
				if(mr.sharedMaterial){
					if (!hMats.Contains(mr.sharedMaterial)){
					hMats.Add(mr.sharedMaterial);
					}
				}
			}
		}// =====================================================================================================================

		void OnDrawGizmos () {
			if (drawGizmos){
				foreach (MeshRenderer mr in GetComponentsInChildren<MeshRenderer>()){
					if (mr.sharedMaterial.HasProperty("_Parallax")){
						Gizmos.color = gizmoColor;
						Gizmos.DrawWireCube (mr.bounds.center, mr.bounds.size);
					}
				}
			}
		}// =====================================================================================================================

		public void GetBounds(){
			children = transform.GetComponentsInChildren<Transform>();
			objectNumber = 0;
			foreach (Transform child in children) {
				++objectNumber;
				//Debug.Log (objectNumber);
				HorizonDisplacementHelper.AdjustBounds(child.gameObject);
			}
			//Debug.Log (children.Length);
		}// =====================================================================================================================

		public void Displace(){
			children = transform.GetComponentsInChildren<Transform>();
			objectNumber = 0;
			foreach (Transform child in children) {
				++objectNumber;
				HorizonDisplacementHelper.DisplaceMesh(child.gameObject);
			}
            HorizonDisplacementHelper.FixSeams(children);
        }// =====================================================================================================================

#endif

        void OnEnable()
        {
            UpdateMaterials();
        }

        public void UpdateMaterials () {
			switch (hFeatLayerCount){
			case LayerCount.One : layerCount = 1; break;
			case LayerCount.Two : layerCount = 2; break;
			case LayerCount.Three : layerCount = 3; break;
			case LayerCount.Four : layerCount = 4; break;
			}
			foreach (Material m in hMats) {
				if (m != null){
					// Features =====================================================================================================================
					if (setFeatures){
						if (m.HasProperty ("_LayerCount")){
							switch (hFeatLayerCount){
							case LayerCount.One : m.SetFloat ("_LayerCount",0); m.DisableKeyword("_LAYERCOUNT_FOUR"); m.DisableKeyword("_LAYERCOUNT_THREE"); m.DisableKeyword("_LAYERCOUNT_TWO"); m.EnableKeyword("_LAYERCOUNT_ONE"); layerCount = 1; break;
							case LayerCount.Two : m.SetFloat ("_LayerCount",1); m.DisableKeyword("_LAYERCOUNT_FOUR"); m.DisableKeyword("_LAYERCOUNT_THREE"); m.EnableKeyword("_LAYERCOUNT_TWO"); m.DisableKeyword("_LAYERCOUNT_ONE"); layerCount = 2; break;
							case LayerCount.Three : m.SetFloat ("_LayerCount",2); m.DisableKeyword("_LAYERCOUNT_FOUR"); m.EnableKeyword("_LAYERCOUNT_THREE"); m.DisableKeyword("_LAYERCOUNT_TWO"); m.DisableKeyword("_LAYERCOUNT_ONE"); layerCount = 3; break;
							case LayerCount.Four : m.SetFloat ("_LayerCount",3); m.EnableKeyword("_LAYERCOUNT_FOUR"); m.DisableKeyword("_LAYERCOUNT_THREE"); m.DisableKeyword("_LAYERCOUNT_TWO"); m.DisableKeyword("_LAYERCOUNT_ONE"); layerCount = 4; break;
							}
						}
						if (m.HasProperty ("_Normalmaps")){
							switch (hFeatNormalmaps){
							case false : m.SetFloat ("_Normalmaps",0); m.EnableKeyword("_NORMALMAPS_OFF"); m.DisableKeyword("_NORMALMAPS_ON"); break;
							case true : m.SetFloat ("_Normalmaps",1); m.DisableKeyword("_NORMALMAPS_OFF"); m.EnableKeyword("_NORMALMAPS_ON"); break;
							}
							switch (hFeatEmissivness){
							case false : m.SetFloat ("_Emissiveness",0); m.EnableKeyword("_EMISSIVENESS_OFF"); m.DisableKeyword("_EMISSIVENESS_ON"); break;
							case true : m.SetFloat ("_Emissiveness",1); m.DisableKeyword("_EMISSIVENESS_OFF"); m.EnableKeyword("_EMISSIVENESS_ON"); break;
							}
						}
						if (m.HasProperty ("_Detail")){
							switch (hFeatDetailTex){
							case false : m.SetFloat ("_Detail",0); m.EnableKeyword("_DETAIL_OFF"); m.DisableKeyword("_DETAIL_ON"); break;
							case true : m.SetFloat ("_Detail",1); m.DisableKeyword("_DETAIL_OFF"); m.EnableKeyword("_DETAIL_ON"); break;
							}
						}
						if (m.HasProperty ("_Water")){
							switch (hFeatWater){
							case false : m.SetFloat ("_Water",0); m.EnableKeyword("_WATER_OFF"); m.DisableKeyword("_WATER_ON"); break;
							case true : m.SetFloat ("_Water",1); m.DisableKeyword("_WATER_OFF"); m.EnableKeyword("_WATER_ON"); break;
							}
						}
						if (m.HasProperty ("_OverlayFog")){
							switch (hFeatFog){
							case false : m.SetFloat ("_OverlayFog",0); m.EnableKeyword("_OVERLAYFOG_OFF"); m.DisableKeyword("_OVERLAYFOG_ON"); break;
							case true : m.SetFloat ("_OverlayFog",1); m.DisableKeyword("_OVERLAYFOG_OFF"); m.EnableKeyword("_OVERLAYFOG_ON"); break;
							}
						}
						if (m.HasProperty ("_Snow")){
							switch (hFeatSnow){
							case false : m.SetFloat ("_Snow",0); m.EnableKeyword("_SNOW_OFF"); m.DisableKeyword("_SNOW_ON"); break;
							case true : m.SetFloat ("_Snow",1); m.DisableKeyword("_SNOW_OFF"); m.EnableKeyword("_SNOW_ON"); break;
							}
						}
						if (m.HasProperty ("_DirectSpec")){
							switch (hFeatDirSpec){
							case false : m.SetFloat ("_DirectSpec",0); m.EnableKeyword("_DIRECTSPEC_OFF"); m.DisableKeyword("_DIRECTSPEC_ON"); break;
							case true : m.SetFloat ("_DirectSpec",1); m.DisableKeyword("_DIRECTSPEC_OFF"); m.EnableKeyword("_DIRECTSPEC_ON"); break;
							}
						}
						if (m.HasProperty ("_IBLSpec")){
							switch (hFeatCubeRefl){
							case false : m.SetFloat ("_IBLSpec",0); m.EnableKeyword("_IBLSPEC_OFF"); m.DisableKeyword("_IBLSPEC_ON"); break;
							case true : m.SetFloat ("_IBLSpec",1); m.DisableKeyword("_IBLSPEC_OFF"); m.EnableKeyword("_IBLSPEC_ON"); break;
							}
						}
					}

					// Settings =====================================================================================================================
					// Disc Scaling =====================================================================================================================
					if (m.HasProperty ("_ScaleInner")) { m.SetFloat ("_ScaleInner", hSetScaleInner*1.25f); }
					if (m.HasProperty ("_ScaleOuter")) { m.SetFloat ("_ScaleOuter", hSetScaleOuter); }
					if (m.HasProperty ("_ScaleHeight")) { m.SetFloat ("_ScaleHeight", hSetScaleHeight); }
					// Main Settings =====================================================================================================================
					if (m.HasProperty ("_MapScaleOffset")) { m.SetVector ("_MapScaleOffset", hSetMaskScaleOffset); }
					if (m.HasProperty ("_MaskRBlend1GBlend2BBlend3AWater")) { m.SetTexture ("_MaskRBlend1GBlend2BBlend3AWater", hTexMask); }
					if (m.HasProperty ("_LocalSpace")) { if (hSetLockMask) m.SetFloat ("_LocalSpace", 1); else m.SetFloat ("_LocalSpace", 0); }
					if (m.HasProperty ("_Tint")) { m.SetColor ("_Tint", hColTint); }
					if (m.HasProperty ("_EmissionColor")) { m.SetColor ("_EmissionColor", hColEmissColor); }
					if (m.HasProperty ("_AmbientOverrideAAmount")) { m.SetColor ("_AmbientOverrideAAmount", hColAmbOverride); }
					if (m.HasProperty ("_AmbientIBL")) { m.SetFloat ("_AmbientIBL", hSetAmbvsIBL); }
					if (m.HasProperty ("_GlobalNormalmapIntensity")) { m.SetFloat ("_GlobalNormalmapIntensity", hSetNMIntensLayers); }

					// Layer Settings ==================================================================================================================================================
					// Layer 1 Settings
					if (m.HasProperty ("_BaseColormap")) { m.SetTexture ("_BaseColormap", hSetLayerProps[0].hTexLayerDiff); }
					if (m.HasProperty ("_BaseColormap")) { m.SetTextureScale ("_BaseColormap", new Vector2 (hSetLayerProps[0].hSetLayerScaleOffset.x, hSetLayerProps[0].hSetLayerScaleOffset.y)); }
					if (m.HasProperty ("_BaseColormap")) { m.SetTextureOffset ("_BaseColormap", new Vector2 (hSetLayerProps[0].hSetLayerScaleOffset.z, hSetLayerProps[0].hSetLayerScaleOffset.w)); }
					if (m.HasProperty ("_TintSaturation")) { m.SetColor ("_TintSaturation", hSetLayerProps[0].hColLayerTint); }
					if (m.HasProperty ("_BaseEmission")) { if (hSetLayerProps[0].hSetAIsEmissMask) m.SetFloat ("_BaseEmission", 1); else m.SetFloat ("_BaseEmission", 0);}
					if (m.HasProperty ("_BaseNormalmap")) { m.SetTexture ("_BaseNormalmap", hSetLayerProps[0].hTexLayerNM); }
					if (m.HasProperty ("_BaseDetailIntensity")) { m.SetFloat ("_BaseDetailIntensity", hSetLayerProps[0].hSetLayerDetIntens); }
					// Layer 2 Settings
					if (m.HasProperty ("_BlendColorMap1")) { m.SetTexture ("_BlendColorMap1", hSetLayerProps[1].hTexLayerDiff); }
					if (m.HasProperty ("_BlendColorMap1")) { m.SetTextureScale ("_BlendColorMap1", new Vector2 (hSetLayerProps[1].hSetLayerScaleOffset.x, hSetLayerProps[1].hSetLayerScaleOffset.y)); }
					if (m.HasProperty ("_BlendColorMap1")) { m.SetTextureOffset ("_BlendColorMap1", new Vector2 (hSetLayerProps[1].hSetLayerScaleOffset.z, hSetLayerProps[1].hSetLayerScaleOffset.w)); }
					if (m.HasProperty ("_TintSaturationBlend1")) { m.SetColor ("_TintSaturationBlend1", hSetLayerProps[1].hColLayerTint); }
					if (m.HasProperty ("_BlendEmission1")) { if (hSetLayerProps[1].hSetAIsEmissMask) m.SetFloat ("_BlendEmission1", 1); else m.SetFloat ("_BlendEmission1", 0);}
					if (m.HasProperty ("_BlendNormalmap1")) { m.SetTexture ("_BlendNormalmap1", hSetLayerProps[1].hTexLayerNM); }
					if (m.HasProperty ("_BlendDetailIntensity1")) { m.SetFloat ("_BlendDetailIntensity1", hSetLayerProps[1].hSetLayerDetIntens); }
					// Layer 3 Settings
					if (m.HasProperty ("_BlendColormap2")) { m.SetTexture ("_BlendColormap2", hSetLayerProps[2].hTexLayerDiff); }
					if (m.HasProperty ("_BlendColormap2")) { m.SetTextureScale ("_BlendColormap2", new Vector2 (hSetLayerProps[2].hSetLayerScaleOffset.x, hSetLayerProps[2].hSetLayerScaleOffset.y)); }
					if (m.HasProperty ("_BlendColormap2")) { m.SetTextureOffset ("_BlendColormap2", new Vector2 (hSetLayerProps[2].hSetLayerScaleOffset.z, hSetLayerProps[2].hSetLayerScaleOffset.w)); }
					if (m.HasProperty ("_TintSaturationBlend2")) { m.SetColor ("_TintSaturationBlend2", hSetLayerProps[2].hColLayerTint); }
					if (m.HasProperty ("_BlendEmission2")) { if (hSetLayerProps[2].hSetAIsEmissMask) m.SetFloat ("_BlendEmission2", 1); else m.SetFloat ("_BlendEmission2", 0);}
					if (m.HasProperty ("_BlendNormalmap2")) { m.SetTexture ("_BlendNormalmap2", hSetLayerProps[2].hTexLayerNM); }
					if (m.HasProperty ("_BlendDetailIntensity2")) { m.SetFloat ("_BlendDetailIntensity2", hSetLayerProps[2].hSetLayerDetIntens); }
					// Layer 4 Settings
					if (m.HasProperty ("_BlendColormap3")) { m.SetTexture ("_BlendColormap3", hSetLayerProps[3].hTexLayerDiff); }
					if (m.HasProperty ("_BlendColormap3")) { m.SetTextureScale ("_BlendColormap3", new Vector2 (hSetLayerProps[3].hSetLayerScaleOffset.x, hSetLayerProps[3].hSetLayerScaleOffset.y)); }
					if (m.HasProperty ("_BlendColormap3")) { m.SetTextureOffset ("_BlendColormap3", new Vector2 (hSetLayerProps[3].hSetLayerScaleOffset.z, hSetLayerProps[3].hSetLayerScaleOffset.w)); }
					if (m.HasProperty ("_TintSaturationBlend3")) { m.SetColor ("_TintSaturationBlend3", hSetLayerProps[3].hColLayerTint); }
					if (m.HasProperty ("_BlendEmission3")) { if (hSetLayerProps[3].hSetAIsEmissMask) m.SetFloat ("_BlendEmission3", 1); else m.SetFloat ("_BlendEmission3", 0);}
					if (m.HasProperty ("_BlendNormalmap3")) { m.SetTexture ("_BlendNormalmap3", hSetLayerProps[3].hTexLayerNM); }
					if (m.HasProperty ("_BlendDetailIntensity3")) { m.SetFloat ("_BlendDetailIntensity3", hSetLayerProps[3].hSetLayerDetIntens); }

					// Detail Settings =============================================================================================================================
					if (m.HasProperty ("_DetailColormap")) { m.SetTexture ("_DetailColormap", hTexDetailTexDiff); }
					if (m.HasProperty ("_DetailColormap")) { m.SetTextureScale ("_DetailColormap", new Vector2 (hSetDetailScaleOffset.x, hSetDetailScaleOffset.y)); }
					if (m.HasProperty ("_DetailColormap")) { m.SetTextureOffset ("_DetailColormap", new Vector2 (hSetDetailScaleOffset.z, hSetDetailScaleOffset.w)); }
					if (m.HasProperty ("_DetailColormapIntensity")) { m.SetFloat ("_DetailColormapIntensity", hSetDetailDiffIntens); }
					if (m.HasProperty ("_DetailNormalmap")) { m.SetTexture ("_DetailNormalmap", hTexDetailTexNM); }
					if (m.HasProperty ("_DetailNormalmapIntensity")) { m.SetFloat ("_DetailNormalmapIntensity", hSetDetailNMIntens); }

					// Water Settings =============================================================================================================================
					if (m.HasProperty ("_WaterColorAColorBlend")) { m.SetColor ("_WaterColorAColorBlend", hColWaterColorOpac); }
					if (m.HasProperty ("_WaterSpecGloss")) { m.SetColor ("_WaterSpecGloss", hColWaterSpecGloss); }
					if (m.HasProperty ("_WaterNormalmap")) { m.SetTexture ("_WaterNormalmap", hTexWaterNM); }
					if (m.HasProperty ("_WaterNormalmap")) { m.SetTextureScale ("_WaterNormalmap", new Vector2 (hSetWaterScaleOffset.x, hSetWaterScaleOffset.y)); }
					if (m.HasProperty ("_WaterNormalmap")) { m.SetTextureOffset ("_WaterNormalmap", new Vector2 (hSetWaterScaleOffset.z, hSetWaterScaleOffset.w)); }
					if (m.HasProperty ("_WaterBlend")) { m.SetFloat ("_WaterBlend", hSetWaterBlend); }
					if (m.HasProperty ("_WaterWaves")) { m.SetFloat ("_WaterWaves", hSetWaterWavesIntens); }
					if (m.HasProperty ("_WaterWaveSpeed")) { m.SetFloat ("_WaterWaveSpeed", HSetWaterWavesSpeed); }

					// Fog Settings =============================================================================================================================
					if (m.HasProperty ("_OverlayFogAmount")) { m.SetFloat ("_OverlayFogAmount", hSetFogIntens); }
					if (m.HasProperty ("_OverlayFogColorAfromAmbient")) { m.SetColor ("_OverlayFogColorAfromAmbient", hColFogColorAmbBlend); }
					if (m.HasProperty ("_OverlayFogAmountFromReflCubemap")) { m.SetFloat ("_OverlayFogAmountFromReflCubemap", hSetFogSpecCubeAdd); }
					if (m.HasProperty ("_OverlayFogStartDistance")) { m.SetFloat ("_OverlayFogStartDistance", hSetFogStartDist); }
					if (m.HasProperty ("_OverlayFogDistanceTransition")) { m.SetFloat ("_OverlayFogDistanceTransition", hSetFogTransDist); }
					if (m.HasProperty ("_OverlayFogStartHeight")) { m.SetFloat ("_OverlayFogStartHeight", hSetFogStartHeight); }
					if (m.HasProperty ("_OverlayFogHeightTransition")) { m.SetFloat ("_OverlayFogHeightTransition", hSetFogTransHeight); }
					if (m.HasProperty ("_OverlayFogDistance2Height")) { m.SetFloat ("_OverlayFogDistance2Height", hSetFogDistHeightOffset); }
					if (m.HasProperty ("_OverlayFogEmissivePunchThru")) { m.SetFloat ("_OverlayFogEmissivePunchThru", hSetFogEmissPunchThru); }

					// IBL Settings =============================================================================================================================
					if (m.HasProperty ("_DiffIBLMulti")) { m.SetFloat ("_DiffIBLMulti", hSetIBLExposure); }
                    if (m.HasProperty ("_SpecIBLMulti")) { m.SetFloat ("_SpecIBLMulti", hSetIBLReflExposure); }

					// Snow Settings =============================================================================================================================
					if (m.HasProperty ("_SnowAmount")) { m.SetFloat ("_SnowAmount", hsetSnowAmount); }
					if (m.HasProperty ("_SnowColor")) { m.SetColor ("_SnowColor", hColSnowDiffColor); }
					if (m.HasProperty ("_SnowSpecGloss")) { m.SetColor ("_SnowSpecGloss", hColSnowSpecGloss); }
					if (m.HasProperty ("_SnowHeight")) { m.SetFloat ("_SnowHeight", hSetSnowStartHeight); }
					if (m.HasProperty ("_SnowHeightTransition")) { m.SetFloat ("_SnowHeightTransition", hSetSnowHeightTrans); }
					if (m.HasProperty ("_SnowSlopeDamp")) { m.SetFloat ("_SnowSlopeDamp", hSetSnowSlopeDamp*4); }
					if (m.HasProperty ("_SnowOutputColorBrightness2Coverage")) { m.SetFloat ("_SnowOutputColorBrightness2Coverage", hSetSnowReduceByColor); }

					// Displacement Settings =============================================================================================================================
					if (m.HasProperty ("_Parallax")) { m.SetFloat ("_Parallax", hSetDispHeight); }
					if (m.HasProperty ("_ReduceByVertexAlpha")) {if (hSetDispRedByVertCol) m.SetFloat ("_ReduceByVertexAlpha", 1); else m.SetFloat ("_ReduceByVertexAlpha", 0); }
					if (m.HasProperty ("_ReduceByUVBorder")) { if (hSetDispRedByUV) m.SetFloat ("_ReduceByUVBorder", 1); else m.SetFloat ("_ReduceByUVBorder", 0); }
					if (m.HasProperty ("_ReduceByUVBorderLength")) { m.SetFloat ("_ReduceByUVBorderLength", (1-hSetDispRedFadeAmount)); }
					if (m.HasProperty ("_ParallaxMap")) { m.SetTexture ("_ParallaxMap", hTexDispHeightmap); }
					if (m.HasProperty ("_EdgeLength")) { m.SetFloat ("_EdgeLength", hSetTessSubD); }

					// Cliff Settings =============================================================================================================================
					if (m.HasProperty ("_CliffColormap")) { m.SetTexture ("_CliffColormap", hTexCliffDiff); }
					if (m.HasProperty ("_CliffColormap")) { m.SetTextureScale ("_CliffColormap", new Vector2(hSetCliffScaleOffset.x, hSetCliffScaleOffset.y)); }
					if (m.HasProperty ("_CliffColormap")) { m.SetTextureOffset ("_CliffColormap", new Vector2(hSetCliffScaleOffset.z, hSetCliffScaleOffset.w)); }
					if (m.HasProperty ("_CliffEmission")) { if (hSetCliffAIsEmissMask) m.SetFloat ("_CliffEmission", 1); else m.SetFloat ("_CliffEmission", 0); }
					if (m.HasProperty ("_CliffNormalmap")) { m.SetTexture ("_CliffNormalmap", hTexCliffNM); }
				}
			}
		}

#if UNITY_EDITOR

        public void UpdateHorizonMaster () {
			if (updateHorizonMaster){
				if (getFromMaterialMat != null){
					hMats.Clear();
					hMats.Add(getFromMaterialMat);
				}
				foreach (Material m in hMats){
					if (m != null){
						// Features =====================================================================================================================
						bool getFeaturesOld = getFeatures;
						if (getFromMaterialMat != null){ getFeatures = true; }
						if (getFeatures){
							if (m.HasProperty ("_LayerCount")){ 
								if (m.GetFloat ("_LayerCount") == 0) {hFeatLayerCount = LayerCount.One; layerCount = 1; }
								if (m.GetFloat ("_LayerCount") == 1) {hFeatLayerCount = LayerCount.Two; layerCount = 2; }
								if (m.GetFloat ("_LayerCount") == 2) {hFeatLayerCount = LayerCount.Three; layerCount = 3; }
								if (m.GetFloat ("_LayerCount") == 3) {hFeatLayerCount = LayerCount.Four; layerCount = 4; }
							}
							if (m.HasProperty ("_Normalmaps")){ if (m.GetFloat ("_Normalmaps") == 1) hFeatNormalmaps = true; else hFeatNormalmaps = false; }
							if (m.HasProperty ("_Emissiveness")){ if (m.GetFloat ("_Emissiveness") == 1) hFeatEmissivness = true; else hFeatEmissivness = false; }
							if (m.HasProperty ("_Detail")){ if (m.GetFloat ("_Detail") == 1) hFeatDetailTex = true; else hFeatDetailTex = false; }
							if (m.HasProperty ("_Water")){ if (m.GetFloat ("_Water") == 1) hFeatWater = true; else hFeatWater = false; }
							if (m.HasProperty ("_OverlayFog")){ if (m.GetFloat ("_OverlayFog") == 1) hFeatFog = true; else hFeatFog = false; }
							if (m.HasProperty ("_Snow")){ if (m.GetFloat ("_Snow") == 1) hFeatSnow = true; else hFeatSnow = false; }
							if (m.HasProperty ("_DirectSpec")){ if (m.GetFloat ("_DirectSpec") ==1 ) hFeatDirSpec = true; else hFeatDirSpec = false; }
							if (m.HasProperty ("_IBLSpec")){ if (m.GetFloat ("_IBLSpec") == 1) hFeatCubeRefl = true; else hFeatCubeRefl = false; }
						}
						getFeatures = getFeaturesOld;

						// Settings =====================================================================================================================
						bool getMatSettingsOld = getMatSettings;
						if (getFromMaterialMat != null){ getMatSettings = true; }
						if (getMatSettings){
							// Disc Scaling =====================================================================================================================
							if (m.HasProperty ("_ScaleInner")) { hSetScaleInner = m.GetFloat ("_ScaleInner")/1.25f; }
							if (m.HasProperty ("_ScaleOuter")) { hSetScaleOuter = m.GetFloat ("_ScaleOuter"); }
							if (m.HasProperty ("_ScaleHeight")) { hSetScaleHeight = m.GetFloat ("_ScaleHeight"); }
							// Main Settings =====================================================================================================================
							if (m.HasProperty ("_MapScaleOffset")) { hSetMaskScaleOffset = m.GetVector ("_MapScaleOffset"); }
							if (m.HasProperty ("_MaskRBlend1GBlend2BBlend3AWater")) { hTexMask = m.GetTexture ("_MaskRBlend1GBlend2BBlend3AWater"); }
							if (m.HasProperty ("_LocalSpace")) { if (m.GetFloat ("_LocalSpace") == 1) hSetLockMask = true; else hSetLockMask = false; }
							if (m.HasProperty ("_Tint")) { hColTint = m.GetColor ("_Tint"); }
							if (m.HasProperty ("_EmissionColor")) { hColEmissColor = m.GetColor ("_EmissionColor"); }
							if (m.HasProperty ("_AmbientOverrideAAmount")) { hColAmbOverride = m.GetColor ("_AmbientOverrideAAmount"); }
							if (m.HasProperty ("_AmbientIBL")) { hSetAmbvsIBL = m.GetFloat ("_AmbientIBL"); }
							if (m.HasProperty ("_GlobalNormalmapIntensity")) { hSetNMIntensLayers = m.GetFloat ("_GlobalNormalmapIntensity"); }
							
							// Layer Settings ==================================================================================================================================================
							// Layer 1 Settings
							if (m.HasProperty ("_BaseColormap")) { hSetLayerProps[0].hTexLayerDiff = m.GetTexture ("_BaseColormap"); }
							if (m.HasProperty ("_BaseColormap")) { hSetLayerProps[0].hSetLayerScaleOffset = new Vector4 (m.GetTextureScale ("_BaseColormap").x, m.GetTextureScale ("_BaseColormap").y, m.GetTextureOffset ("_BaseColormap").x, m.GetTextureOffset ("_BaseColormap").y); }
							if (m.HasProperty ("_TintSaturation")) { hSetLayerProps[0].hColLayerTint = m.GetColor ("_TintSaturation"); }
							if (m.HasProperty ("_BaseEmission")) { if (m.GetFloat ("_BaseEmission") == 1) hSetLayerProps[0].hSetAIsEmissMask = true; else hSetLayerProps[0].hSetAIsEmissMask = false; }
							if (m.HasProperty ("_BaseNormalmap")) { hSetLayerProps[0].hTexLayerNM = m.GetTexture ("_BaseNormalmap"); }
							if (m.HasProperty ("_BaseDetailIntensity")) { hSetLayerProps[0].hSetLayerDetIntens = m.GetFloat ("_BaseDetailIntensity"); }
							// Layer 2 Settings
							if (m.HasProperty ("_BlendColorMap1")) { hSetLayerProps[1].hTexLayerDiff = m.GetTexture ("_BlendColorMap1"); }
							if (m.HasProperty ("_BlendColorMap1")) { hSetLayerProps[1].hSetLayerScaleOffset = new Vector4 (m.GetTextureScale ("_BlendColorMap1").x, m.GetTextureScale ("_BlendColorMap1").y, m.GetTextureOffset ("_BlendColorMap1").x, m.GetTextureOffset ("_BlendColorMap1").y); }
							if (m.HasProperty ("_TintSaturationBlend1")) { hSetLayerProps[1].hColLayerTint = m.GetColor ("_TintSaturationBlend1"); }
							if (m.HasProperty ("_BlendEmission1")) { if (m.GetFloat ("_BlendEmission1") == 1) hSetLayerProps[1].hSetAIsEmissMask = true; else hSetLayerProps[1].hSetAIsEmissMask = false; }
							if (m.HasProperty ("_BlendNormalmap1")) { hSetLayerProps[1].hTexLayerNM = m.GetTexture ("_BlendNormalmap1"); }
							if (m.HasProperty ("_BlendDetailIntensity1")) { hSetLayerProps[1].hSetLayerDetIntens = m.GetFloat ("_BlendDetailIntensity1"); }
							// Layer 3 Settings
							if (m.HasProperty ("_BlendColormap2")) { hSetLayerProps[2].hTexLayerDiff = m.GetTexture ("_BlendColormap2"); }
							if (m.HasProperty ("_BlendColormap2")) { hSetLayerProps[2].hSetLayerScaleOffset = new Vector4 (m.GetTextureScale ("_BlendColormap2").x, m.GetTextureScale ("_BlendColormap2").y, m.GetTextureOffset ("_BlendColormap2").x, m.GetTextureOffset ("_BlendColormap2").y); }
							if (m.HasProperty ("_TintSaturationBlend2")) { hSetLayerProps[2].hColLayerTint = m.GetColor ("_TintSaturationBlend2"); }
							if (m.HasProperty ("_BlendEmission2")) { if (m.GetFloat ("_BlendEmission2") == 1) hSetLayerProps[2].hSetAIsEmissMask = true; else hSetLayerProps[2].hSetAIsEmissMask = false; }
							if (m.HasProperty ("_BlendNormalmap2")) { hSetLayerProps[2].hTexLayerNM = m.GetTexture ("_BlendNormalmap2"); }
							if (m.HasProperty ("_BlendDetailIntensity2")) { hSetLayerProps[2].hSetLayerDetIntens = m.GetFloat ("_BlendDetailIntensity2"); }
							// Layer 4 Settings
							if (m.HasProperty ("_BlendColormap3")) { hSetLayerProps[3].hTexLayerDiff = m.GetTexture ("_BlendColormap3"); }
							if (m.HasProperty ("_BlendColormap3")) { hSetLayerProps[3].hSetLayerScaleOffset = new Vector4 (m.GetTextureScale ("_BlendColormap3").x, m.GetTextureScale ("_BlendColormap3").y, m.GetTextureOffset ("_BlendColormap3").x, m.GetTextureOffset ("_BlendColormap3").y); }
							if (m.HasProperty ("_TintSaturationBlend3")) { hSetLayerProps[3].hColLayerTint = m.GetColor ("_TintSaturationBlend3"); }
							if (m.HasProperty ("_BlendEmission3")) { if (m.GetFloat ("_BlendEmission3") == 1) hSetLayerProps[3].hSetAIsEmissMask = true; else hSetLayerProps[3].hSetAIsEmissMask = false; }
							if (m.HasProperty ("_BlendNormalmap3")) { hSetLayerProps[3].hTexLayerNM = m.GetTexture ("_BlendNormalmap3"); }
							if (m.HasProperty ("_BlendDetailIntensity3")) { hSetLayerProps[3].hSetLayerDetIntens = m.GetFloat ("_BlendDetailIntensity3"); }

							// Detail Settings =============================================================================================================================
							if (m.HasProperty ("_DetailColormap")) { hTexDetailTexDiff = m.GetTexture ("_DetailColormap"); }
							if (m.HasProperty ("_DetailColormap")) { hSetDetailScaleOffset = new Vector4 (m.GetTextureScale ("_DetailColormap").x, m.GetTextureScale ("_DetailColormap").y, m.GetTextureOffset ("_DetailColormap").x, m.GetTextureOffset ("_DetailColormap").y); }
							if (m.HasProperty ("_DetailColormapIntensity")) { hSetDetailDiffIntens = m.GetFloat ("_DetailColormapIntensity"); }
							if (m.HasProperty ("_DetailNormalmap")) { hTexDetailTexNM = m.GetTexture ("_DetailNormalmap"); }
							if (m.HasProperty ("_DetailNormalmapIntensity")) { hSetDetailNMIntens = m.GetFloat ("_DetailNormalmapIntensity"); }
							
							// Water Settings =============================================================================================================================
							if (m.HasProperty ("_WaterColorAColorBlend")) { hColWaterColorOpac = m.GetColor ("_WaterColorAColorBlend"); }
							if (m.HasProperty ("_WaterSpecGloss")) { hColWaterSpecGloss = m.GetColor ("_WaterSpecGloss"); }
							if (m.HasProperty ("_WaterNormalmap")) { hTexWaterNM = m.GetTexture ("_WaterNormalmap"); }
							if (m.HasProperty ("_WaterNormalmap")) { hSetWaterScaleOffset = new Vector4 (m.GetTextureScale ("_WaterNormalmap").x ,m.GetTextureScale ("_WaterNormalmap").y, m.GetTextureOffset ("_WaterNormalmap").x ,m.GetTextureOffset ("_WaterNormalmap").y); }
							if (m.HasProperty ("_WaterBlend")) { hSetWaterBlend = m.GetFloat ("_WaterBlend"); }
							if (m.HasProperty ("_WaterWaves")) { hSetWaterWavesIntens = m.GetFloat ("_WaterWaves"); }
							if (m.HasProperty ("_WaterWaveSpeed")) { HSetWaterWavesSpeed = m.GetFloat ("_WaterWaveSpeed"); }
							
							// Fog Settings =============================================================================================================================
							if (m.HasProperty ("_OverlayFogAmount")) { hSetFogIntens = m.GetFloat ("_OverlayFogAmount"); }
							if (m.HasProperty ("_OverlayFogColorAfromAmbient")) { hColFogColorAmbBlend = m.GetColor ("_OverlayFogColorAfromAmbient"); }
							if (m.HasProperty ("_OverlayFogAmountFromReflCubemap")) { hSetFogSpecCubeAdd = m.GetFloat ("_OverlayFogAmountFromReflCubemap"); }
							if (m.HasProperty ("_OverlayFogStartDistance")) { hSetFogStartDist = m.GetFloat ("_OverlayFogStartDistance"); }
							if (m.HasProperty ("_OverlayFogDistanceTransition")) { hSetFogTransDist = m.GetFloat ("_OverlayFogDistanceTransition"); }
							if (m.HasProperty ("_OverlayFogStartHeight")) { hSetFogStartHeight = m.GetFloat ("_OverlayFogStartHeight"); }
							if (m.HasProperty ("_OverlayFogHeightTransition")) { hSetFogTransHeight = m.GetFloat ("_OverlayFogHeightTransition"); }
							if (m.HasProperty ("_OverlayFogDistance2Height")) { hSetFogDistHeightOffset = m.GetFloat ("_OverlayFogDistance2Height"); }
							if (m.HasProperty ("_OverlayFogEmissivePunchThru")) { hSetFogEmissPunchThru = m.GetFloat ("_OverlayFogEmissivePunchThru"); }
							
							// IBL Settings =============================================================================================================================
							if (m.HasProperty ("_DiffIBLMulti")) { hSetIBLExposure = m.GetFloat ("_DiffIBLMulti"); }
                            if (m.HasProperty ("_SpecIBLMulti")) { hSetIBLReflExposure = m.GetFloat ("_SpecIBLMulti"); }

							// Snow Settings =============================================================================================================================
							if (m.HasProperty ("_SnowAmount")) { hsetSnowAmount = m.GetFloat ("_SnowAmount"); }
							if (m.HasProperty ("_SnowColor")) { hColSnowDiffColor = m.GetColor ("_SnowColor"); }
							if (m.HasProperty ("_SnowSpecGloss")) { hColSnowSpecGloss = m.GetColor ("_SnowSpecGloss"); }
							if (m.HasProperty ("_SnowHeight")) { hSetSnowStartHeight = m.GetFloat ("_SnowHeight"); }
							if (m.HasProperty ("_SnowHeightTransition")) { hSetSnowHeightTrans = m.GetFloat ("_SnowHeightTransition"); }
							if (m.HasProperty ("_SnowSlopeDamp")) { hSetSnowSlopeDamp = m.GetFloat ("_SnowSlopeDamp")/4; }
							if (m.HasProperty ("_SnowOutputColorBrightness2Coverage")) { hSetSnowReduceByColor = m.GetFloat ("_SnowOutputColorBrightness2Coverage"); }
							
							// Displacement Settings =============================================================================================================================
							if (m.HasProperty ("_Parallax")) { hSetDispHeight = m.GetFloat ("_Parallax"); }
							if (m.HasProperty ("_ReduceByVertexAlpha")) {if (m.GetFloat ("_ReduceByVertexAlpha") == 1) hSetDispRedByVertCol = true; else hSetDispRedByVertCol = false; }
							if (m.HasProperty ("_ReduceByUVBorder")) { if (m.GetFloat ("_ReduceByUVBorder") == 1) hSetDispRedByUV = true; else hSetDispRedByUV = false; }
							if (m.HasProperty ("_ReduceByUVBorderLength")) { hSetDispRedFadeAmount = (1-(m.GetFloat ("_ReduceByUVBorderLength"))); }
							if (m.HasProperty ("_ParallaxMap")) { hTexDispHeightmap = m.GetTexture ("_ParallaxMap"); }
							if (m.HasProperty ("_EdgeLength")) { hSetTessSubD = m.GetFloat ("_EdgeLength"); }
							
							// Cliff Settings =============================================================================================================================
							if (m.HasProperty ("_CliffColormap")) { hTexCliffDiff = m.GetTexture ("_CliffColormap"); }
							if (m.HasProperty ("_CliffColormap")) { hSetCliffScaleOffset = new Vector4 (m.GetTextureScale ("_CliffColormap").x, m.GetTextureScale ("_CliffColormap").y, m.GetTextureOffset ("_CliffColormap").x, m.GetTextureOffset ("_CliffColormap").y); }
							if (m.HasProperty ("_CliffEmission")) { if (m.GetFloat ("_CliffEmission" ) == 1) hSetCliffAIsEmissMask = true; else hSetCliffAIsEmissMask = false; }
							if (m.HasProperty ("_CliffNormalmap")) { hTexCliffNM = m.GetTexture ("_CliffNormalmap"); }
						}
						getMatSettings = getMatSettingsOld;
					}
				}
			}
		}
#endif
    }


    [System.Serializable]
	public class HorizON_LayerProps
    {
        public bool showLayerSettings = false;
		public Vector4 hSetLayerScaleOffset = new Vector4(3,3,0,0);
		public Texture hTexLayerDiff;
		public Texture hTexLayerNM;
		public bool hSetAIsEmissMask = false;
		public Color hColLayerTint = new Color32(128,128,128,128);
		[Range(0,1)] public float hSetLayerDetIntens = 1;
    }
}