Shader "Horizon[ON]/Horizon[ON] Flat" {
    Properties {
[BlockInfo(1.0,1.0,1.0,1.0)] dummy_begin ("Features", Float) = 1
	    [KeywordEnum(One, Two, Three, Four)] _LayerCount ("   Layer count", Float) = 3
	    [PropBlockKeyword(_DIRECTSPEC)] _DirectSpec ("    Enable Specularity", Float) = 1
	    [PropBlockKeyword(_IBLSPEC)] _IBLSpec ("    Enable Reflections", Float) = 0
	    [PropBlockKeyword(_NORMALMAPS)] _Normalmaps ("    Enable Normalmapping", Float) = 0
	    [PropBlockKeyword(_EMISSIVENESS)] _Emissiveness ("    Enable Emissiveness", Float) = 0
	    [PropBlockKeyword(_DETAIL)] _Detail ("    Enable Detail Textures", Float) = 0
	    [PropBlockKeyword(_WATER)] _Water ("    Enable Water", Float) = 0
	    [PropBlockKeyword(_OVERLAYFOG)] _OverlayFog ("    Enable Fog", Float) = 0
	    [PropBlockKeyword(_SNOW)] _Snow ("    Enable Snow", Float) = 0
	    
//[BlockInfo(1.0,1.0,1.0,1.0, 1, indent)] dummy_disk ("Horizon[ON] Scaling", Float) = 1
//        [HideByProp(dummy_disk)] _ScaleInner ("   Scale inner", Range(1.25,0) ) = 1
//        [HideByProp(dummy_disk)] _ScaleOuter ("   Scale outer", Float ) = 1
//        [HideByProp(dummy_disk)] _ScaleHeight ("   Scale height", Range(0,2) ) = 1	   
    	    
[BlockInfo(1.0,0.5,0.5,0.8, 1, indent)] dummy_main ("Main settings", Float) = 1    
        [HideByProp(dummy_main)] _MapScaleOffset ("Mask Scale (XY), Offset (ZW) [m]", Vector ) = (1000,1000,0,0)
        [HideByProp(dummy_main)] _Anchor ("World Shift (XYZ) [m]", Vector ) = (0,0,0,0)
        //[PropBlock(dummy_main)] _LocalSpace ("   Use local Space", Float ) = 0
        [HideByProp(dummy_main, _LayerCount.1.2.3, 0)] _MaskRBlend1GBlend2BBlend3AWater ("   Mask (R)Blend 1 (G)Blend 2 (B)Blend 3 (A)Water", 2D) = "white" {}
        [HideByProp(dummy_main)] _Tint ("         Color Tint", Color) = (0.5,0.5,0.5,1)
        [HideByProp(_Emissiveness, dummy_main)] _EmissionColor ("         Emission color (RGB)", Color ) = (0,0,0,0)
        [HideByProp(dummy_main)] _AmbientOverrideAAmount ("         Ambient Override/Amount", Color) = (0.5086505,0.5635247,0.6176471,0)
        [HideByProp(dummy_main)] _DiffIBLMulti("         Ambient Light Multi", Float) = 1
        [HideByProp(_IBLSpec, dummy_main)] _SpecIBLMulti("         Ambient Reflection Multi", Float) = 1
        [HideByProp(dummy_main)] _AmbientIBL ("         Ambient > diff IBL", Range(0, 1)) = 1
        [HideByProp(_Normalmaps, dummy_main)] _GlobalNormalmapIntensity ("         Normalmap intensity from Layers (set below)", Range(0, 1)) = 1

[BlockInfo(0.5,1.0,0.5,1.0, 1, indent)] dummy_layer1 ("Layer 1 properties", Float) = 0
        [HideByProp(dummy_layer1)] _BaseColormap ("   Colormap (RGB) + A", 2D) = "white" {}
        [HideByProp(dummy_layer1)] _TintSaturation ("   Tint / Saturation", Color) = (0.5, 0.5, 0.5, 0.5)
        [PropBlock(dummy_layer1)] _BaseEmission ("       A = Emission", Float) = 0
        [HideByProp(dummy_layer1,_Normalmaps, 0)] _BaseNormalmap ("   Normalmap", 2D) = "bump" {}
        [HideByProp(dummy_layer1)] _BaseDetailIntensity ("   detail intensity", Range(0,1)) = 1
        
[BlockInfo(0.5,1.0,0.5,1.0, 1, _LayerCount.1.2.3)] dummy_layer2 ("Layer 2 properties", Float) = 0
        [HideByProp(dummy_layer2, _LayerCount.1.2.3)] _BlendColorMap1 ("   Colormap (RGB) + A", 2D) = "white" {}
        [HideByProp(dummy_layer2, _LayerCount.1.2.3)] _TintSaturationBlend1 ("   Tint / Saturation", Color) = (0.5, 0.5, 0.5, 0.5)
        [PropBlock(dummy_layer2, _LayerCount.1.2.3)] _BlendEmission1 ("       A = Emission", Float) = 0
        [HideByProp(dummy_layer2, _LayerCount.1.2.3, 0)] _BlendNormalmap1 ("   Normalmap", 2D) = "bump" {}
		[HideByProp(dummy_layer2, _LayerCount.1.2.3)] _BlendDetailIntensity1 ("   detail intensity", Range(0,1)) = 1

[BlockInfo(0.5,1.0,0.5,1.0, 1, _LayerCount.2.3)] dummy_layer3 ("Layer 3 properties", Float) = 0
        [HideByProp(dummy_layer3, _LayerCount.2.3)] _BlendColormap2 ("   Colormap (RGB) + A", 2D) = "white" {}
        [HideByProp(dummy_layer3, _LayerCount.2.3)] _TintSaturationBlend2 ("   Tint / Saturation", Color) = (0.5, 0.5, 0.5, 0.5)
        [PropBlock(dummy_layer3, _LayerCount.2.3)] _BlendEmission2 ("       A = Emission", Float) = 0
        [HideByProp(dummy_layer3, _LayerCount.2.3, 0)] _BlendNormalmap2 ("   Normalmap", 2D) = "bump" {}
        [HideByProp(dummy_layer3, _LayerCount.2.3)] _BlendDetailIntensity2 ("   detail intensity", Range(0,1)) = 1

[BlockInfo(0.5,1.0,0.5,1.0, 1, _LayerCount.3)] dummy_layer4 ("Layer 4 properties", Float) = 0
        [HideByProp(dummy_layer4, _LayerCount.3)] _BlendColormap3 ("   Colormap (RGB) + A", 2D) = "white" {}
        [HideByProp(dummy_layer4, _LayerCount.3)] _TintSaturationBlend3 ("   Tint / Saturation", Color) = (0.5, 0.5, 0.5, 0.5)
        [PropBlock(dummy_layer4, _LayerCount.3)] _BlendEmission3 ("       A = Emission", Float) = 0
        [HideByProp(dummy_layer4, _LayerCount.3, 0)] _BlendNormalmap3 ("   Normalmap", 2D) = "bump" {}
        [HideByProp(dummy_layer4, _LayerCount.3)] _BlendDetailIntensity3 ("   detail intensity", Range(0,1)) = 1

[BlockInfo(0.5,1.0,0.5,1.0, 1, _Detail)] dummy_detail ("Detail settings", Float) = 1
        [HideByProp(dummy_detail, _Detail)] _DetailColormap ("   Detail colormap", 2D) = "gray" {}
        [HideByProp(dummy_detail, _Detail)] _DetailColormapIntensity ("   Detail colormap intensity", Range(0, 1)) = 1
        [HideByProp(dummy_detail, _Detail)] _DetailNormalmap ("   Detail normalmap", 2D) = "bump" {}
        [HideByProp(dummy_detail, _Detail)] _DetailNormalmapIntensity ("   Detail normalmap intensity", Range(0, 1)) = 1
        
[BlockInfo(0.2,0.7,1.0,1.0, 1, _Water)] dummy_water ("Water features", Float) = 1
        [HideByProp(dummy_water, _Water)] _WaterColorAColorBlend ("   Color / Opacity", Color) = (0.201449,0.3554559,0.5073529,1)
        [HideByProp(dummy_water, _Water)] _WaterSpecGloss ("   Spec / Gloss", Color) = (0.2, 0.2, 0.2, 0.9)
        [HideByProp(dummy_water, _Water)] _WaterNormalmap ("   Normalmap", 2D) = "white" {}
	    [HideByProp(dummy_water, _Water)] _WaterBlend ("   Water Blend", Range(0, 1)) = 0
        [HideByProp(dummy_water, _Water)] _WaterWaves ("   Waviness", Range(0, 1)) = 1
        [HideByProp(dummy_water, _Water)] _WaterWaveSpeed ("   Wave Speed", Float ) = 1
        
[BlockInfo(0.2,0.95,1.0,0.99, 1, _OverlayFog)] dummy_fog ("Layered fog", Float) = 1
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogAmount ("   Amount", Range(0, 1)) = 0
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogColorAfromAmbient ("   Color / Ambient Blend", Color) = (0.7189662,0.7639169,0.8014706,0)
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogAmountFromReflCubemap ("   Refl.cubemap add(if active)", Range(0,1.2)) = 0.5
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogStartDistance ("   Start Distance", Float ) = 2000
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogDistanceTransition ("   distance transition length", Float ) = 3000
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogStartHeight ("   start height", Float ) = 0
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogHeightTransition ("   height transition length", Float ) = 100
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogDistance2Height ("   height offset dy distance", Float ) = 100
        [HideByProp(dummy_fog, _OverlayFog)] _OverlayFogEmissivePunchThru ("   emissiveness punch thru", Range(0,1) ) = 0
        
[BlockInfo(1.0,1.0,1.0,0.8, 1, _Snow)] dummy_snow ("Snow", Float) = 1
        [HideByProp(dummy_snow, _Snow)] _SnowAmount ("   Amount", Range(0, 1)) = 1
        [HideByProp(dummy_snow, _Snow)] _SnowColor ("   Color (RGB)", Color) = (0.8, 0.8, 0.8, 0)
        [HideByProp(dummy_snow, _Snow)] _SnowSpecGloss ("   Spec (RGB) Gloss (A)", Color) = (0.2, 0.2, 0.2, 0.3)
        [HideByProp(dummy_snow, _Snow)] _SnowHeight ("   Start height (world Y)", Float ) = 300
        [HideByProp(dummy_snow, _Snow)] _SnowHeightTransition ("   Height transition", Float ) = 50
        [HideByProp(dummy_snow, _Snow)] _SnowSlopeDamp ("   Slope Damp factor", Range(0,4) ) = 1
        [HideByProp(dummy_snow, _Snow)] _SnowOutputColorBrightness2Coverage ("   Reduce by underlying color", Range(0,1) ) = 0.2
	}
    
    SubShader {
        Tags {
            "IgnoreProjector"="False"
            "Queue"="Geometry"
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            //Fog { Mode Off }
            ZWrite On
            CGPROGRAM
            //#define NO_U5_FOG
            #pragma multi_compile_fog
            
            #pragma fragment frag

			// no tessellation
   	        #pragma vertex vert
   	        // optional displacement feature
            //#define _DISPLACEMENT
   	        
            // tessellation
			//#pragma vertex tessvert_surf
			//#pragma hull hs_surf
			//#pragma domain ds_surf
			//#include "Tessellation.cginc"
			                        
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            
            #pragma multi_compile_fwdbase
//            #define DIRECTIONAL
//            #define LIGHTMAP_OFF
//            #define DIRLIGHTMAP_OFF
//            #define SHADOWS_OFF
            
            #pragma exclude_renderers flash d3d11_9x
           	#pragma target 3.0
            
			#ifdef SHADER_API_OPENGL
  	          #pragma glsl
            #endif

            //#define _MESHNORMALS
            //#define _CLIFFS
            //#define _HORIZONDISK
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            // Enable/Disable Features here! =============================================================
            #pragma shader_feature _LAYERCOUNT_ONE _LAYERCOUNT_TWO _LAYERCOUNT_THREE _LAYERCOUNT_FOUR
            #pragma shader_feature _DIRECTSPEC_OFF _DIRECTSPEC_ON
            #pragma shader_feature _IBLSPEC_OFF _IBLSPEC_ON
            #pragma shader_feature _NORMALMAPS_OFF _NORMALMAPS_ON
            #pragma shader_feature _EMISSIVENESS_OFF _EMISSIVENESS_ON
            #pragma shader_feature _DETAIL_OFF _DETAIL_ON
            #pragma shader_feature _WATER_OFF _WATER_ON 
            #pragma shader_feature _OVERLAYFOG_OFF _OVERLAYFOG_ON
            #pragma shader_feature _SNOW_OFF _SNOW_ON
            // ===========================================================================================
            // Backup of the original multicompile options! ==============================================
//            #pragma shader_feature _LAYERCOUNT_ONE _LAYERCOUNT_TWO _LAYERCOUNT_THREE _LAYERCOUNT_FOUR
//            #pragma shader_feature _DIRECTSPEC_OFF _DIRECTSPEC_ON
//            #pragma shader_feature _IBLSPEC_OFF _IBLSPEC_ON
//            #pragma shader_feature _NORMALMAPS_OFF _NORMALMAPS_ON
//            #pragma shader_feature _EMISSIVENESS_OFF _EMISSIVENESS_ON
//            #pragma shader_feature _DETAIL_OFF _DETAIL_ON
//            #pragma shader_feature _WATER_OFF _WATER_ON 
//            #pragma shader_feature _OVERLAYFOG_OFF _OVERLAYFOG_ON
//            #pragma shader_feature _SNOW_OFF _SNOW_ON                                                                                                                                                                                                                                                     
			// ===========================================================================================

			#include "_horizON_Core.cginc"
            ENDCG
        }
        
		// Pass to render object as a shadow caster
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct v2f { 
				V2F_SHADOW_CASTER;
			};

			v2f vert( appdata_base v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG

		}         
    }
    
    FallBack Off
}