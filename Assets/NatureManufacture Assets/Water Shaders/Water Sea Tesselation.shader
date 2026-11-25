Shader "NatureManufacture/Water/Sea Tesselation"
{
	Properties
	{
		_CullModeOff0Front1Back2("CullMode Off 0 Front 1 Back 2", Int) = 0
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.75
		_GlobalTiling("Global Tiling", Range( 0.001 , 100)) = 0
		[Toggle(_UVVDIRECTION1UDIRECTION0_ON)] _UVVDirection1UDirection0("UV Direction - V(T) U(F)", Float) = 0
		_SlowWaterSpeed("Main Water Speed", Vector) = (0.3,0.3,0,0)
		_SlowWaterMixSpeed("Wind Water Mix Speed", Vector) = (0,0,0,0)
		_WaterFlowUVRefresSpeed("Water Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_Polar_Wave_Depth_Start_X_Flatten_Point_Y("Polar Wave Depth Start (X) Flatten Point (Y)", Vector) = (7,0.4,0,0)
		_GerstnerDirection_1("Polar Wave Height (X) Flatten (Y) Wave Scale (W)", Vector) = (0.7,0.1,0,7)
		_Polar_Wave_Silent_Area_Angle("Polar Wave Silent Area Angle", Range( 0 , 360)) = 77
		_Polar_Wave_Silent_Area_Angle_Hardness("Polar Wave Silent Area Angle Hardness", Float) = 1
		_Polar_Wave_Swash_Size("Polar Wave Swash Size", Float) = 0.8
		_Polar_and_Small_Waves_Friction_Depth_Mask("Polar and Small Waves Friction Depth Mask", Range( 0 , 8)) = 3.7
		_Polar_and_Small_Waves_Friction_Depth_Mask_Power("Polar and Small Waves Friction Depth Mask Power", Range( 0 , 8)) = 2.06
		_Polar_and_Small_Waves_Friction_Speed_Reduction("Polar and Small Waves Friction Speed Reduction", Float) = 0.99
		_Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y("Small Wave Shore Depth Start (X) Flatten Point (Y)", Vector) = (6,1.4,0,0)
		_Small_Wave_Shore_Height_Multiply("Small Wave Shore Height Multiply", Float) = 3
		_Gerstner_1("Small Wave Height (X) Flatten (Y) Direction (Z) Wave Scale (W)", Vector) = (0.3,0,30,13)
		_Gerstner_2("Small Wave 2 Height (X) Flatten (Y) Direction (Z) Wave Scale (W)", Vector) = (0.4,0.1,-30,16)
		_Small_Waves_Chaos("Small Waves Chaos", Range( 0 , 1)) = 1
		_Small_Wave_Silent_Area_Angle("Small Wave Silent Area Angle", Range( 0 , 360)) = 200
		_Small_Wave_Silent_Area_Angle_Hardness("Small Wave Silent Area Angle Hardness", Float) = 2
		_Small_Wave_Swash_Size("Small Wave Swash Size", Float) = 0.8
		_Sea_Wave_Depth_Flatten_Start_X_End_Y("Sea Wave Depth Flatten Start (X) End (Y)", Vector) = (7,5,0,0)
		_GerstnerDirection_4("Sea Wave Height (X) Flatten (Y) Direction (Z) Wave Scale (W)", Vector) = (0.33,0,60,37)
		_GerstnerDirection_5("Sea Wave 2 Height (X) Flatten (Y) Direction (Z) Wave Scale (W)", Vector) = (0.31,0,-60,43)
		_Sea_Waves_Chaos("Sea Waves Chaos", Range( 0 , 1)) = 0.4
		_Sea_Wave_Swash_Size("Sea Wave Swash Size", Float) = 0.8
		[NoScaleOffset]_Waves_Noise("Waves Noise", 2D) = "white" {}
		_Small_Wave_Noise_Tiling("Small Wave Noise Tiling", Vector) = (0.33,0.8,0,0)
		_Small_Wave_Noise_Multiply("Small Wave Noise Multiply", Range( 0 , 5)) = 1.68
		_Small_Wave_Noise_Power("Small Wave Noise Power", Range( 0 , 1)) = 1
		_Sea_Wave_Noise_Tiling("Sea Wave Noise Tiling", Vector) = (0.19,0.53,0,0)
		_Sea_Wave_Noise_Multiply("Sea Wave Noise Multiply", Range( 0 , 5)) = 1.68
		_Sea_Wave_Noise_Power("Sea Wave Noise Power", Range( 0 , 1)) = 1
		_EdgeFalloffMultiply("Alpha Edge Falloff Multiply", Float) = 5.19
		_EdgeFalloffPower("Alpha Edge Falloff Power", Float) = 0.74
		_WaterAlphaMultiply("Alpha Global Multiply", Float) = 0.66
		_WaterAlphaPower("Alpha Global Power", Float) = 1.39
		_BackfaceAlpha("Alpha Backface", Range( 0 , 1)) = 0
		_Clean_Water_Background_Brightness("Clean Water Background Brightness", Float) = 0.9
		_CleanFalloffMultiply("Clean Falloff Multiply", Float) = 1.29
		_CleanFalloffPower("Clean Falloff Power", Float) = 0.38
		_ShalowColor("Shalow Color", Color) = (0.4031684,0.5485649,0.5660378,0)
		_ShalowFalloffPower("Shalow Falloff Power", Float) = 3.9
		_ShalowFalloffMultiply("Shalow Falloff Multiply", Float) = 1.043
		_DeepColor("Deep Color", Color) = (0.05660379,0.05660379,0.05660379,0)
		[NoScaleOffset]_SlowWaterNormal("Water Normal", 2D) = "bump" {}
		WindMicroWaveTiling("Wind Micro Wave Tiling", Vector) = (0.1,0.1,0,0)
		_MicroWaveNormalScale("Wind Micro Wave Normal Scale", Range( 0 , 2)) = 0
		_MacroWaveTiling("Wind Macro Wave Tiling", Vector) = (0.02,0.02,0,0)
		_MacroWaveNormalScale("Wind Macro Wave Normal Scale", Range( 0 , 2)) = 0
		_SlowWaterTiling("Water Tiling", Vector) = (0,0,0,0)
		_SlowNormalScale("Water Normal Scale", Float) = 0
		_Water_Normal_Flatten_Multiply("Water Normal Flatten Multiply", Range( 0 , 1)) = 0.2
		_FarNormalPower("Far Normal Power", Range( 0 , 1)) = 0.5
		_FarNormalBlendStartDistance("Far Normal Blend Start Distance", Float) = 0
		_FarNormalBlendThreshold("Far Normal Blend Threshold", Float) = 10
		_NMWaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_NMFoamSmoothness("Foam Smoothness", Range( 0 , 1)) = 0
		_Distortion("Distortion", Range( 0 , 1)) = 0.03
		_AOPower("Water Ambient Occlusion", Float) = 1
		_WaterSpecularThreshold("Water Specular Threshold", Range( 0 , 10)) = 0
		_Water_Specular_Close("Water Specular Close", Range( 0 , 1)) = 0
		_Water_Specular_Far("Water Specular Far", Range( 0 , 1)) = 0
		_Foam_Specular("Foam Specular", Range( 0 , 1)) = 0
		_SeaFoamColor("Sea Foam Color", Vector) = (2,2,2,0)
		[NoScaleOffset]_Sea_Foam_Texture("Sea Foam Texture", 2D) = "white" {}
		_Sea_Foam_Texture_Falloff("Sea Foam Texture Falloff", Range( 0 , 20)) = 4.11
		_Sea_Foam_Tiling("Sea Foam Tiling", Vector) = (0.3,0.3,0,0)
		_Sea_Foam_Slope_Influence("Sea Foam Slope Influence", Vector) = (0.3,0.3,0,0)
		[NoScaleOffset]_Sea_Foam_Texture_Normal("Sea Foam Texture Normal", 2D) = "bump" {}
		_Sea_Foam_Texture_Normal_Scale("Sea Foam Texture Normal Scale", Float) = 6
		_Sea_Waves_Foam_Multiply("Sea Waves Foam Multiply", Float) = 0.13
		_Sea_Waves_Foam_Mask_Offset("Sea Waves Foam Mask Offset", Float) = 0.48
		_Sea_Waves_Foam_Power("Sea Waves Foam Power", Float) = 4.49
		Sea_Waves_Foam_Mask_Hardness("Sea Foam Tesselation Mask Hardness", Range( 0 , 10)) = 0.95
		Sea_Waves_Foam_Mask_Power("Sea Foam Tesselation Mask Power", Range( 0 , 10)) = 5.2
		Sea_Waves_Foam_Mask_Multiply("Sea Foam Tesselation Mask Multiply", Range( 0 , 20)) = 20
		_Side_Foam_Depth_Multiply("Side Foam Depth Multiply", Range( 0 , 1)) = 0.121
		_Side_Foam_Depth_Falloff("Side Foam Depth Falloff", Range( 0.01 , 10)) = 0.68
		[NoScaleOffset]_Foam("Side Foam Mask", 2D) = "white" {}
		_Side_Foam_Mask_Power("Side Foam Mask Power", Float) = 4
		_Side_Foam_Speed("Side Foam Speed", Vector) = (0.3,0.3,0,0)
		_Side_Foam_Flow_UV_Refresh_Speed("Side Foam Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_Side_Foam_Slope_Speed_Influence("Side Foam Slope Speed Influence", Vector) = (0.3,0.3,0,0)
		_Side_Foam_Tiling("Side Foam Tiling", Vector) = (0,0,0,0)
		[NoScaleOffset]_Side_Foam_Mask_Normal("Side Foam Mask Normal", 2D) = "bump" {}
		_Side_Foam_Mask_Normal_Scale("Side Foam Mask Normal Scale", Float) = 6
		_Side_Foam_Color("Side Foam Color", Vector) = (1.5,1.5,1.5,0)
		_Side_Foam_Wave_Backs_Multiply("Side Foam Wave Backs Multiply", Float) = 2
		_Side_Foam_Wave_Backs_Offset("Side Foam Wave Backs Offset", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		_Side_Foam_Waves_Multiply("Side Foam Waves  Multiply", Float) = 1
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		_Side_Foam_Waves_Power("Side Foam Waves  Power", Range( 0.01 , 10)) = 3.46
		_Side_Foam_Waves_Offset("Side Foam Waves Offset", Float) = -0.13
		_Side_Foam_Crest_Color("Side Foam Crest Color", Vector) = (3,3,3,0)
		_Side_Foam_Crest_Mask_Offset("Side Foam Crest Mask Offset", Float) = -1.1
		_Side_Foam_Crest_Mask_Multiply("Side Foam Crest Mask Multiply", Float) = 1.22
		_Side_Foam_Perlin_Tiling("Side Foam Perlin Tiling", Float) = 1.09
		_Side_Foam_Perlin_Multiply("Side Foam Perlin Multiply", Float) = 3.13
		_Side_Foam_Perlin_Power("Side Foam Perlin Power", Float) = -3.23
		[NoScaleOffset]_SlowWaterTesselation("Water Tess", 2D) = "white" {}
		_SlowWaterTessScale("Water Tess Scale", Float) = 0
		MacroWaveTessScale("Wind Macro Wave Tess Scale", Float) = 0
		_Translucency_Global_Power("Translucency Global Power", Range( 0 , 100)) = 10
		_Translucency_Direct_Sun_Power("Translucency Direct Sun Power", Range( 0 , 100)) = 10
		_SlowWaterTranslucencyMultiply("Water Translucency Multiply", Range( 0 , 10)) = 1
		_WaveTranslucencyFallOffDistance("Micro Wave Translucency FallOff Distance", Float) = 0
		_WaveTranslucencyPower("Micro Wave Translucency Power", Range( 0 , 10)) = 2.69
		_WaveTranslucencyHardness("Micro Wave Translucency Hardness", Range( 0 , 10)) = 1.89
		_WaveTranslucencyMultiply("Micro Wave Translucency Multiply", Range( 0 , 10)) = 0.03
		_Big_Waves_Translucency_Offset("Big Waves Translucency Offset", Float) = 0.05
		_Big_Waves_Translucency_Power("Big Waves Translucency Power", Range( 0.01 , 10)) = 2
		_Big_Waves_Translucency_Multiply("Big Waves Translucency Multiply", Float) = 20
		_Big_Front_Waves_Translucency_Multiply("Big Front Waves Translucency Multiply", Float) = 20
		_Big_Front_Waves_Translucency_Power("Big Front Waves Translucency Power", Range( 0.01 , 10)) = 2
		_Shore_Translucency_Power("Shore Translucency Power", Range( 0.01 , 100)) = 1.6
		_Shore_Translucency_Multiply("Shore Translucency Multiply", Range( 0.01 , 100)) = 0.3
		[Toggle(_USE_CAUSTIC)] _Use_Caustic("Use_Caustic", Float) = 0
		[NoScaleOffset]_Caustic("Caustic", 2D) = "white" {}
		[HDR]_Caustic_Color("Caustic Color", Color) = (1,1,1,0)
		_Caustic_Tiling("Caustic Tiling", Float) = 0.05
		_Caustic_Triplanar_Hardness("Caustic Triplanar Hardness", Float) = 3
		_Caustic_Speed("Caustic Speed", Float) = 0.4
		_Caustic_Falloff("Caustic Falloff", Float) = 3.33
		_Caustic_Intensivity("Caustic Intensivity", Float) = 7.07
		_Caustic_Blend("Caustic Blend", Range( 0 , 1)) = 0.044
		_Time_Offset("Time Offset", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull [_CullModeOff0Front1Back2]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
		#pragma shader_feature_local _UVVDIRECTION1UDIRECTION0_ON
		#pragma multi_compile_local __ _USE_CAUSTIC
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
		#endif//ASE Sampling Macros

		#pragma surface surf StandardSpecular keepalpha vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
			float4 uv4_texcoord4;
			float4 uv_texcoord;
			float4 screenPos;
			float4 vertexColor : COLOR;
			half ASEIsFrontFacing : VFACE;
		};

		uniform int _CullModeOff0Front1Back2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Waves_Noise);
		SamplerState sampler_Linear_Repeat_Aniso8;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SlowWaterTesselation);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SlowWaterNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Side_Foam_Mask_Normal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Sea_Foam_Texture_Normal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Sea_Foam_Texture);
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Caustic);
		SamplerState sampler_Caustic;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Foam);
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		UNITY_INSTANCING_BUFFER_START(Graph_NM_Sea_SS_Tesselation)
			UNITY_DEFINE_INSTANCED_PROP(half4, _GerstnerDirection_5)
#define _GerstnerDirection_5_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _ShalowColor)
#define _ShalowColor_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _Gerstner_2)
#define _Gerstner_2_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _DeepColor)
#define _DeepColor_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _Caustic_Color)
#define _Caustic_Color_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _Gerstner_1)
#define _Gerstner_1_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _GerstnerDirection_4)
#define _GerstnerDirection_4_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _GerstnerDirection_1)
#define _GerstnerDirection_1_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _SeaFoamColor)
#define _SeaFoamColor_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _Side_Foam_Color)
#define _Side_Foam_Color_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _Side_Foam_Crest_Color)
#define _Side_Foam_Crest_Color_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MacroWaveTiling)
#define _MacroWaveTiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Sea_Foam_Tiling)
#define _Sea_Foam_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterTiling)
#define _SlowWaterTiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Sea_Wave_Depth_Flatten_Start_X_End_Y)
#define _Sea_Wave_Depth_Flatten_Start_X_End_Y_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Sea_Wave_Noise_Tiling)
#define _Sea_Wave_Noise_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterMixSpeed)
#define _SlowWaterMixSpeed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterSpeed)
#define _SlowWaterSpeed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Sea_Foam_Slope_Influence)
#define _Sea_Foam_Slope_Influence_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Side_Foam_Slope_Speed_Influence)
#define _Side_Foam_Slope_Speed_Influence_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y)
#define _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Polar_Wave_Depth_Start_X_Flatten_Point_Y)
#define _Polar_Wave_Depth_Start_X_Flatten_Point_Y_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, WindMicroWaveTiling)
#define WindMicroWaveTiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Side_Foam_Speed)
#define _Side_Foam_Speed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Small_Wave_Noise_Tiling)
#define _Small_Wave_Noise_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Side_Foam_Tiling)
#define _Side_Foam_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyMultiply)
#define _WaveTranslucencyMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyPower)
#define _WaveTranslucencyPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Tiling)
#define _Caustic_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffPower)
#define _ShalowFalloffPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowWaterTranslucencyMultiply)
#define _SlowWaterTranslucencyMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffMultiply)
#define _ShalowFalloffMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Distortion)
#define _Distortion_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Clean_Water_Background_Brightness)
#define _Clean_Water_Background_Brightness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyFallOffDistance)
#define _WaveTranslucencyFallOffDistance_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Intensivity)
#define _Caustic_Intensivity_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Blend)
#define _Caustic_Blend_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Falloff)
#define _Caustic_Falloff_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Speed)
#define _Caustic_Speed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Triplanar_Hardness)
#define _Caustic_Triplanar_Hardness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyHardness)
#define _WaveTranslucencyHardness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Front_Waves_Translucency_Multiply)
#define _Big_Front_Waves_Translucency_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Power)
#define _Shore_Translucency_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Waves_Translucency_Multiply)
#define _Big_Waves_Translucency_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _NMWaterSmoothness)
#define _NMWaterSmoothness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Foam_Specular)
#define _Foam_Specular_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterSpecularThreshold)
#define _WaterSpecularThreshold_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Close)
#define _Water_Specular_Close_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Far)
#define _Water_Specular_Far_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BackfaceAlpha)
#define _BackfaceAlpha_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffPower)
#define _EdgeFalloffPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffMultiply)
#define _EdgeFalloffMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Mask_Power)
#define _Side_Foam_Mask_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Crest_Mask_Offset)
#define _Side_Foam_Crest_Mask_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Crest_Mask_Multiply)
#define _Side_Foam_Crest_Mask_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffPower)
#define _CleanFalloffPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffMultiply)
#define _CleanFalloffMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaPower)
#define _WaterAlphaPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaMultiply)
#define _WaterAlphaMultiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Direct_Sun_Power)
#define _Translucency_Direct_Sun_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Global_Power)
#define _Translucency_Global_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Normal_Flatten_Multiply)
#define _Water_Normal_Flatten_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Multiply)
#define _Shore_Translucency_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Waves_Translucency_Power)
#define _Big_Waves_Translucency_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Waves_Translucency_Offset)
#define _Big_Waves_Translucency_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Front_Waves_Translucency_Power)
#define _Big_Front_Waves_Translucency_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Foam_Texture_Falloff)
#define _Sea_Foam_Texture_Falloff_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Perlin_Multiply)
#define _Side_Foam_Perlin_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Waves_Foam_Mask_Offset)
#define _Sea_Waves_Foam_Mask_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterFlowUVRefresSpeed)
#define _WaterFlowUVRefresSpeed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Swash_Size)
#define _Small_Wave_Swash_Size_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_and_Small_Waves_Friction_Speed_Reduction)
#define _Polar_and_Small_Waves_Friction_Speed_Reduction_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_and_Small_Waves_Friction_Depth_Mask)
#define _Polar_and_Small_Waves_Friction_Depth_Mask_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_and_Small_Waves_Friction_Depth_Mask_Power)
#define _Polar_and_Small_Waves_Friction_Depth_Mask_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_Wave_Swash_Size)
#define _Polar_Wave_Swash_Size_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Wave_Swash_Size)
#define _Sea_Wave_Swash_Size_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Silent_Area_Angle_Hardness)
#define _Small_Wave_Silent_Area_Angle_Hardness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Silent_Area_Angle)
#define _Small_Wave_Silent_Area_Angle_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowNormalScale)
#define _SlowNormalScale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Waves_Chaos)
#define _Small_Waves_Chaos_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Noise_Multiply)
#define _Small_Wave_Noise_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Noise_Power)
#define _Small_Wave_Noise_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_Wave_Silent_Area_Angle_Hardness)
#define _Polar_Wave_Silent_Area_Angle_Hardness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Polar_Wave_Silent_Area_Angle)
#define _Polar_Wave_Silent_Area_Angle_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Wave_Noise_Multiply)
#define _Sea_Wave_Noise_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Wave_Noise_Power)
#define _Sea_Wave_Noise_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _GlobalTiling)
#define _GlobalTiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Time_Offset)
#define _Time_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Waves_Chaos)
#define _Sea_Waves_Chaos_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Wave_Shore_Height_Multiply)
#define _Small_Wave_Shore_Height_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, MacroWaveTessScale)
#define MacroWaveTessScale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowWaterTessScale)
#define _SlowWaterTessScale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MicroWaveNormalScale)
#define _MicroWaveNormalScale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Waves_Foam_Multiply)
#define _Sea_Waves_Foam_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, Sea_Waves_Foam_Mask_Multiply)
#define Sea_Waves_Foam_Mask_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, Sea_Waves_Foam_Mask_Power)
#define Sea_Waves_Foam_Mask_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, Sea_Waves_Foam_Mask_Hardness)
#define Sea_Waves_Foam_Mask_Hardness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Foam_Texture_Normal_Scale)
#define _Sea_Foam_Texture_Normal_Scale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Perlin_Power)
#define _Side_Foam_Perlin_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _NMFoamSmoothness)
#define _NMFoamSmoothness_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Perlin_Tiling)
#define _Side_Foam_Perlin_Tiling_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Depth_Falloff)
#define _Side_Foam_Depth_Falloff_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Depth_Multiply)
#define _Side_Foam_Depth_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Waves_Power)
#define _Side_Foam_Waves_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Waves_Offset)
#define _Side_Foam_Waves_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Waves_Multiply)
#define _Side_Foam_Waves_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Wave_Backs_Multiply)
#define _Side_Foam_Wave_Backs_Multiply_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Wave_Backs_Offset)
#define _Side_Foam_Wave_Backs_Offset_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Mask_Normal_Scale)
#define _Side_Foam_Mask_Normal_Scale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Flow_UV_Refresh_Speed)
#define _Side_Foam_Flow_UV_Refresh_Speed_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendThreshold)
#define _FarNormalBlendThreshold_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendStartDistance)
#define _FarNormalBlendStartDistance_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalPower)
#define _FarNormalPower_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MacroWaveNormalScale)
#define _MacroWaveNormalScale_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Sea_Waves_Foam_Power)
#define _Sea_Waves_Foam_Power_arr Graph_NM_Sea_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _AOPower)
#define _AOPower_arr Graph_NM_Sea_SS_Tesselation
		UNITY_INSTANCING_BUFFER_END(Graph_NM_Sea_SS_Tesselation)


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		half2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		half3 InvertDepthDir72_g40( half3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		inline float4 TriplanarSampling25_g37( UNITY_DECLARE_TEX2D_NOSAMPLER(topTexMap), SamplerState samplertopTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling26_g37( UNITY_DECLARE_TEX2D_NOSAMPLER(topTexMap), SamplerState samplertopTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = SAMPLE_TEXTURE2D( topTexMap, samplertopTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			half2 appendResult861 = (half2(v.texcoord3.x , v.texcoord3.y));
			half4 _GerstnerDirection_5_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_5_arr, _GerstnerDirection_5);
			half _Sea_Waves_Chaos_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Waves_Chaos_arr, _Sea_Waves_Chaos);
			float cos864 = cos( ( ( ( _GerstnerDirection_5_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			float sin864 = sin( ( ( ( _GerstnerDirection_5_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			half2 rotator864 = mul( appendResult861 - float2( 0,0 ) , float2x2( cos864 , -sin864 , sin864 , cos864 )) + float2( 0,0 );
			half2 temp_output_73_0_g51 = rotator864;
			half2 ifLocalVar77_g51 = 0;
			if( length( temp_output_73_0_g51 ) == 0.0 )
				ifLocalVar77_g51 = half2( 0.001,0 );
			else
				ifLocalVar77_g51 = temp_output_73_0_g51;
			half2 normalizeResult79_g51 = normalize( ifLocalVar77_g51 );
			half2 break80_g51 = normalizeResult79_g51;
			half2 _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Depth_Flatten_Start_X_End_Y_arr, _Sea_Wave_Depth_Flatten_Start_X_End_Y);
			half temp_output_816_0 = (0.0 + (v.texcoord3.w - _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.y) * (1.0 - 0.0) / (_Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.x - _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.y));
			half clampResult823 = clamp( temp_output_816_0 , 0.0 , 1.0 );
			half clampResult833 = clamp( (_GerstnerDirection_5_Instance.y + (clampResult823 - 0.0) * (max( ( clampResult823 * _GerstnerDirection_5_Instance.x ) , _GerstnerDirection_5_Instance.y ) - _GerstnerDirection_5_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			half clampResult44_g47 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Sea_Wave_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Tiling_arr, _Sea_Wave_Noise_Tiling);
			half2 temp_output_801_0 = ( _Sea_Wave_Noise_Tiling_Instance / float2( 1,1 ) );
			half2 clampResult800 = clamp( temp_output_801_0 , float2( 0.001,0.001 ) , float2( 500,500 ) );
			half2 temp_output_66_0_g47 = temp_output_801_0;
			half2 temp_output_53_0_g47 = ( ( ( ( ( 1.0 - clampResult44_g47 ) * half2( 1,1 ) ) + ( ( float2( 1,1 ) / clampResult800 ) * float2( 1.8,1.8 ) ) ) * temp_output_66_0_g47 ) * v.texcoord3.xy );
			half2 break56_g47 = temp_output_53_0_g47;
			half2 appendResult57_g47 = (half2(break56_g47.y , break56_g47.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g47 = temp_output_53_0_g47;
			#else
				half2 staticSwitch59_g47 = appendResult57_g47;
			#endif
			half _Time_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Time_Offset_arr, _Time_Offset);
			half TimeOffset843 = _Time_Offset_Instance;
			half temp_output_68_0_g47 = ( ( _Time.y + TimeOffset843 ) * 0.07 );
			half temp_output_71_0_g47 = frac( ( temp_output_68_0_g47 + 0.0 ) );
			half2 temp_output_60_0_g47 = ( staticSwitch59_g47 * temp_output_71_0_g47 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
			half2 temp_output_83_0_g47 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g47 * v.texcoord.xy ) );
			half2 temp_output_80_0_g47 = ( staticSwitch59_g47 * frac( ( temp_output_68_0_g47 + -0.5 ) ) );
			half clampResult90_g47 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g47 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult791 = lerp( SAMPLE_TEXTURE2D_LOD( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g47 + temp_output_83_0_g47 ), 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g47 + temp_output_80_0_g47 ), 0.0 ).r , clampResult90_g47);
			half _Sea_Wave_Noise_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Power_arr, _Sea_Wave_Noise_Power);
			half _Sea_Wave_Noise_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Multiply_arr, _Sea_Wave_Noise_Multiply);
			half clampResult807 = clamp( ( pow( abs( lerpResult791 ) , _Sea_Wave_Noise_Power_Instance ) * _Sea_Wave_Noise_Multiply_Instance ) , 0.0 , 1.0 );
			half clampResult827 = clamp( ( 1.0 - (0.05 + (clampResult807 - 0.0) * (0.97 - 0.05) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			half temp_output_832_0 = ( clampResult833 * clampResult827 );
			half2 _Polar_Wave_Depth_Start_X_Flatten_Point_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Depth_Start_X_Flatten_Point_Y_arr, _Polar_Wave_Depth_Start_X_Flatten_Point_Y);
			half2 PolarWaveDepthStartXFlattenPointY732 = _Polar_Wave_Depth_Start_X_Flatten_Point_Y_Instance;
			half2 break1308 = PolarWaveDepthStartXFlattenPointY732;
			half clampResult884 = clamp( ( v.texcoord3.w - break1308.y ) , 0.0 , 1.0 );
			half4 _GerstnerDirection_1_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_1_arr, _GerstnerDirection_1);
			half clampResult886 = clamp( (1.0 + (v.texcoord3.w - break1308.y) * (0.0 - 1.0) / (break1308.x - break1308.y)) , 0.0 , 1.0 );
			half clampResult890 = clamp( (_GerstnerDirection_1_Instance.y + (clampResult884 - 0.0) * (( _GerstnerDirection_1_Instance.x * clampResult886 ) - _GerstnerDirection_1_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half2 appendResult1009 = (half2(v.texcoord3.x , v.texcoord3.y));
			half2 normalizeResult1014 = normalize( ( appendResult1009 * float2( 1,-1 ) ) );
			half2 appendResult1011 = (half2(v.texcoord.z , v.texcoord.w));
			half2 normalizeResult1015 = normalize( appendResult1011 );
			half dotResult1016 = dot( normalizeResult1014 , normalizeResult1015 );
			half _Polar_Wave_Silent_Area_Angle_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Silent_Area_Angle_arr, _Polar_Wave_Silent_Area_Angle);
			half clampResult1022 = clamp( ( (0.0 + (dotResult1016 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + ( ( _Polar_Wave_Silent_Area_Angle_Instance + -180.0 ) / 180.0 ) ) , 0.0 , 1.0 );
			half clampResult1024 = clamp( ( 1.0 - clampResult1022 ) , 0.0 , 1.0 );
			half _Polar_Wave_Silent_Area_Angle_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Silent_Area_Angle_Hardness_arr, _Polar_Wave_Silent_Area_Angle_Hardness);
			half clampResult1028 = clamp( pow( abs( clampResult1024 ) , _Polar_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half clampResult44_g46 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Small_Wave_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Tiling_arr, _Small_Wave_Noise_Tiling);
			half2 temp_output_779_0 = ( _Small_Wave_Noise_Tiling_Instance / float2( 1,1 ) );
			half2 clampResult780 = clamp( temp_output_779_0 , float2( 0.001,0.001 ) , float2( 500,500 ) );
			half2 temp_output_66_0_g46 = temp_output_779_0;
			half2 temp_output_53_0_g46 = ( ( ( ( ( 1.0 - clampResult44_g46 ) * half2( 1,1 ) ) + ( ( float2( 1,1 ) / clampResult780 ) * float2( 2,2 ) ) ) * temp_output_66_0_g46 ) * v.texcoord3.xy );
			half2 break56_g46 = temp_output_53_0_g46;
			half2 appendResult57_g46 = (half2(break56_g46.y , break56_g46.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g46 = temp_output_53_0_g46;
			#else
				half2 staticSwitch59_g46 = appendResult57_g46;
			#endif
			half temp_output_68_0_g46 = ( ( _Time.y + TimeOffset843 ) * 0.05 );
			half temp_output_71_0_g46 = frac( ( temp_output_68_0_g46 + 0.0 ) );
			half2 temp_output_60_0_g46 = ( staticSwitch59_g46 * temp_output_71_0_g46 );
			half2 temp_output_83_0_g46 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g46 * v.texcoord.xy ) );
			half2 temp_output_80_0_g46 = ( staticSwitch59_g46 * frac( ( temp_output_68_0_g46 + -0.5 ) ) );
			half clampResult90_g46 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g46 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult772 = lerp( SAMPLE_TEXTURE2D_LOD( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g46 + temp_output_83_0_g46 ), 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g46 + temp_output_80_0_g46 ), 0.0 ).r , clampResult90_g46);
			half _Small_Wave_Noise_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Power_arr, _Small_Wave_Noise_Power);
			half _Small_Wave_Noise_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Multiply_arr, _Small_Wave_Noise_Multiply);
			half clampResult787 = clamp( ( pow( abs( lerpResult772 ) , _Small_Wave_Noise_Power_Instance ) * _Small_Wave_Noise_Multiply_Instance ) , 0.0 , 1.0 );
			half temp_output_788_0 = (0.0 + (clampResult787 - 0.0) * (0.97 - 0.0) / (1.0 - 0.0));
			half clampResult897 = clamp( ( 1.0 - temp_output_788_0 ) , 0.0 , 1.0 );
			half temp_output_895_0 = ( ( clampResult890 * ( clampResult1028 * 1.0 ) ) * clampResult897 );
			half4 _GerstnerDirection_4_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_4_arr, _GerstnerDirection_4);
			half clampResult824 = clamp( (_GerstnerDirection_4_Instance.y + (clampResult823 - 0.0) * (max( ( clampResult823 * _GerstnerDirection_4_Instance.x ) , _GerstnerDirection_4_Instance.y ) - _GerstnerDirection_4_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_825_0 = ( clampResult824 * clampResult827 );
			half2 _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_arr, _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y);
			half2 SmallWaveShoreDepthStartXFlattenPointY733 = _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_Instance;
			half2 break953 = SmallWaveShoreDepthStartXFlattenPointY733;
			half clampResult968 = clamp( ( v.texcoord3.w - break953.y ) , 0.0 , 1.0 );
			half4 _Gerstner_1_Instance = UNITY_ACCESS_INSTANCED_PROP(_Gerstner_1_arr, _Gerstner_1);
			half _Small_Wave_Shore_Height_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Shore_Height_Multiply_arr, _Small_Wave_Shore_Height_Multiply);
			half clampResult950 = clamp( (1.0 + (v.texcoord3.w - break953.y) * (0.0 - 1.0) / (break953.x - break953.y)) , 0.0 , 1.0 );
			half clampResult983 = clamp( (_Gerstner_1_Instance.y + (clampResult968 - 0.0) * (( _Gerstner_1_Instance.x + ( ( _Small_Wave_Shore_Height_Multiply_Instance * _Gerstner_1_Instance.x ) * clampResult950 ) ) - _Gerstner_1_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half clampResult985 = clamp( ( 1.0 - temp_output_788_0 ) , 0.0 , 1.0 );
			half clampResult1007 = clamp( temp_output_816_0 , 0.0 , 1.0 );
			half temp_output_1008_0 = ( 1.0 - clampResult1007 );
			half _Small_Waves_Chaos_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Waves_Chaos_arr, _Small_Waves_Chaos);
			half temp_output_933_0 = ( _Gerstner_1_Instance.z * _Small_Waves_Chaos_Instance );
			float cos1034 = cos( ( temp_output_933_0 * 0.01745 ) );
			float sin1034 = sin( ( temp_output_933_0 * 0.01745 ) );
			half2 rotator1034 = mul( normalizeResult1014 - float2( 0,0 ) , float2x2( cos1034 , -sin1034 , sin1034 , cos1034 )) + float2( 0,0 );
			half2 normalizeResult1038 = normalize( rotator1034 );
			half dotResult1040 = dot( normalizeResult1038 , normalizeResult1015 );
			half _Small_Wave_Silent_Area_Angle_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Silent_Area_Angle_arr, _Small_Wave_Silent_Area_Angle);
			half temp_output_1045_0 = ( ( _Small_Wave_Silent_Area_Angle_Instance + -180.0 ) / 180.0 );
			half clampResult1051 = clamp( ( temp_output_1008_0 * ( (0.0 + (dotResult1040 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + temp_output_1045_0 ) ) , 0.0 , 1.0 );
			half clampResult1055 = clamp( ( 1.0 - clampResult1051 ) , 0.0 , 1.0 );
			half _Small_Wave_Silent_Area_Angle_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Silent_Area_Angle_Hardness_arr, _Small_Wave_Silent_Area_Angle_Hardness);
			half clampResult1062 = clamp( pow( abs( clampResult1055 ) , _Small_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half temp_output_993_0 = ( ( clampResult983 * clampResult985 ) * clampResult1062 );
			half4 _Gerstner_2_Instance = UNITY_ACCESS_INSTANCED_PROP(_Gerstner_2_arr, _Gerstner_2);
			half clampResult984 = clamp( (_Gerstner_2_Instance.y + (clampResult968 - 0.0) * (( ( ( _Small_Wave_Shore_Height_Multiply_Instance * _Gerstner_2_Instance.x ) * clampResult950 ) + _Gerstner_2_Instance.x ) - _Gerstner_2_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_929_0 = ( _Gerstner_2_Instance.z * _Small_Waves_Chaos_Instance );
			float cos1036 = cos( ( temp_output_929_0 * 0.01745 ) );
			float sin1036 = sin( ( temp_output_929_0 * 0.01745 ) );
			half2 rotator1036 = mul( normalizeResult1014 - float2( 0,0 ) , float2x2( cos1036 , -sin1036 , sin1036 , cos1036 )) + float2( 0,0 );
			half2 normalizeResult1039 = normalize( rotator1036 );
			half dotResult1041 = dot( normalizeResult1039 , normalizeResult1015 );
			half clampResult1052 = clamp( ( temp_output_1008_0 * ( (0.0 + (dotResult1041 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + temp_output_1045_0 ) ) , 0.0 , 1.0 );
			half clampResult1056 = clamp( ( 1.0 - clampResult1052 ) , 0.0 , 1.0 );
			half clampResult1063 = clamp( pow( abs( clampResult1056 ) , _Small_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half temp_output_994_0 = ( ( clampResult984 * clampResult985 ) * clampResult1063 );
			half clampResult894 = clamp( ( temp_output_895_0 + ( ( temp_output_825_0 + temp_output_832_0 ) + ( temp_output_993_0 + temp_output_994_0 ) ) ) , 0.01 , 999.0 );
			half clampResult858 = clamp( temp_output_832_0 , 0.0 , ( temp_output_832_0 / clampResult894 ) );
			half clampResult859 = clamp( clampResult858 , 0.01 , 1.0 );
			half temp_output_83_0_g51 = clampResult859;
			half temp_output_61_0_g51 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_5_Instance.w );
			half temp_output_82_0_g51 = ( temp_output_83_0_g51 / temp_output_61_0_g51 );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half3 break70_g51 = ase_worldPos;
			half3 appendResult71_g51 = (half3(break70_g51.x , break70_g51.z , 0.0));
			half dotResult72_g51 = dot( half3( normalizeResult79_g51 ,  0.0 ) , appendResult71_g51 );
			half temp_output_841_0 = ( _Time.y + TimeOffset843 );
			half temp_output_81_0_g51 = ( temp_output_61_0_g51 * ( dotResult72_g51 - ( sqrt( ( 9.8 / temp_output_61_0_g51 ) ) * temp_output_841_0 ) ) );
			half temp_output_85_0_g51 = cos( temp_output_81_0_g51 );
			half temp_output_86_0_g51 = sin( temp_output_81_0_g51 );
			half clampResult856 = clamp( temp_output_832_0 , 0.0 , 1.0 );
			half _Sea_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Swash_Size_arr, _Sea_Wave_Swash_Size);
			half temp_output_849_0 = ( v.texcoord3.z * _Sea_Wave_Swash_Size_Instance );
			half temp_output_89_0_g51 = ( clampResult856 * temp_output_849_0 );
			half temp_output_90_0_g51 = ( ( temp_output_82_0_g51 * temp_output_85_0_g51 ) + ( temp_output_86_0_g51 * temp_output_89_0_g51 ) );
			half3 appendResult94_g51 = (half3(( break80_g51.x * temp_output_90_0_g51 ) , ( temp_output_82_0_g51 * temp_output_86_0_g51 ) , ( break80_g51.y * temp_output_90_0_g51 )));
			float cos862 = cos( ( ( ( _GerstnerDirection_4_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			float sin862 = sin( ( ( ( _GerstnerDirection_4_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			half2 rotator862 = mul( appendResult861 - float2( 0,0 ) , float2x2( cos862 , -sin862 , sin862 , cos862 )) + float2( 0,0 );
			half2 temp_output_73_0_g54 = rotator862;
			half2 ifLocalVar77_g54 = 0;
			if( length( temp_output_73_0_g54 ) == 0.0 )
				ifLocalVar77_g54 = half2( 0.001,0 );
			else
				ifLocalVar77_g54 = temp_output_73_0_g54;
			half2 normalizeResult79_g54 = normalize( ifLocalVar77_g54 );
			half2 break80_g54 = normalizeResult79_g54;
			half clampResult845 = clamp( temp_output_825_0 , 0.0 , ( temp_output_825_0 / clampResult894 ) );
			half clampResult847 = clamp( clampResult845 , 0.01 , 1.0 );
			half temp_output_83_0_g54 = clampResult847;
			half temp_output_61_0_g54 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_4_Instance.w );
			half temp_output_82_0_g54 = ( temp_output_83_0_g54 / temp_output_61_0_g54 );
			half3 break70_g54 = ase_worldPos;
			half3 appendResult71_g54 = (half3(break70_g54.x , break70_g54.z , 0.0));
			half dotResult72_g54 = dot( half3( normalizeResult79_g54 ,  0.0 ) , appendResult71_g54 );
			half temp_output_81_0_g54 = ( temp_output_61_0_g54 * ( dotResult72_g54 - ( sqrt( ( 9.8 / temp_output_61_0_g54 ) ) * temp_output_841_0 ) ) );
			half temp_output_85_0_g54 = cos( temp_output_81_0_g54 );
			half temp_output_86_0_g54 = sin( temp_output_81_0_g54 );
			half clampResult852 = clamp( temp_output_825_0 , 0.0 , 1.0 );
			half temp_output_89_0_g54 = ( clampResult852 * temp_output_849_0 );
			half temp_output_90_0_g54 = ( ( temp_output_82_0_g54 * temp_output_85_0_g54 ) + ( temp_output_86_0_g54 * temp_output_89_0_g54 ) );
			half3 appendResult94_g54 = (half3(( break80_g54.x * temp_output_90_0_g54 ) , ( temp_output_82_0_g54 * temp_output_86_0_g54 ) , ( break80_g54.y * temp_output_90_0_g54 )));
			half2 appendResult908 = (half2(v.texcoord.z , v.texcoord.w));
			half2 temp_output_73_0_g55 = appendResult908;
			half2 ifLocalVar77_g55 = 0;
			if( length( temp_output_73_0_g55 ) == 0.0 )
				ifLocalVar77_g55 = half2( 0.001,0 );
			else
				ifLocalVar77_g55 = temp_output_73_0_g55;
			half2 normalizeResult79_g55 = normalize( ifLocalVar77_g55 );
			half2 break80_g55 = normalizeResult79_g55;
			half clampResult899 = clamp( temp_output_895_0 , 0.0 , ( temp_output_895_0 / clampResult894 ) );
			half clampResult901 = clamp( clampResult899 , 0.01 , 1.0 );
			half temp_output_83_0_g55 = clampResult901;
			half temp_output_61_0_g55 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_1_Instance.w );
			half temp_output_82_0_g55 = ( temp_output_83_0_g55 / temp_output_61_0_g55 );
			half _Polar_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Swash_Size_arr, _Polar_Wave_Swash_Size);
			half temp_output_909_0 = ( clampResult897 * ( ( _Polar_Wave_Swash_Size_Instance * v.texcoord3.z ) * clampResult1028 ) );
			half clampResult910 = clamp( temp_output_909_0 , 0.0 , ( temp_output_909_0 / clampResult894 ) );
			half clampResult913 = clamp( (1.0 + (v.texcoord3.w - break1308.y) * (0.0 - 1.0) / (break1308.x - break1308.y)) , 0.001 , 1.0 );
			half temp_output_912_0 = ( clampResult910 * clampResult913 );
			half _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Depth_Mask_Power_arr, _Polar_and_Small_Waves_Friction_Depth_Mask_Power);
			half temp_output_67_0_g176 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g176 = clamp( v.texcoord3.w , 0.0 , temp_output_67_0_g176 );
			half _Polar_and_Small_Waves_Friction_Depth_Mask_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Depth_Mask_arr, _Polar_and_Small_Waves_Friction_Depth_Mask);
			half _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Speed_Reduction_arr, _Polar_and_Small_Waves_Friction_Speed_Reduction);
			half temp_output_81_0_g55 = ( temp_output_61_0_g55 * ( ( -1.0 * length( ifLocalVar77_g55 ) ) - ( sqrt( ( 9.8 / temp_output_61_0_g55 ) ) * ( ( ( _Time.y + TimeOffset843 ) - ( 0.3 * temp_output_912_0 ) ) - ( pow( abs( (1.0 + (clampResult135_g176 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g176 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_85_0_g55 = cos( temp_output_81_0_g55 );
			half temp_output_86_0_g55 = sin( temp_output_81_0_g55 );
			half temp_output_89_0_g55 = temp_output_912_0;
			half temp_output_90_0_g55 = ( ( temp_output_82_0_g55 * temp_output_85_0_g55 ) + ( temp_output_86_0_g55 * temp_output_89_0_g55 ) );
			half3 appendResult94_g55 = (half3(( ( break80_g55.x * -1.0 ) * temp_output_90_0_g55 ) , ( temp_output_82_0_g55 * temp_output_86_0_g55 ) , ( ( break80_g55.y * -1.0 ) * temp_output_90_0_g55 )));
			half2 appendResult967 = (half2(v.texcoord3.x , v.texcoord3.y));
			float cos932 = cos( ( ( temp_output_933_0 + 180.0 ) * 0.01745 ) );
			float sin932 = sin( ( ( temp_output_933_0 + 180.0 ) * 0.01745 ) );
			half2 rotator932 = mul( appendResult967 - float2( 0,0 ) , float2x2( cos932 , -sin932 , sin932 , cos932 )) + float2( 0,0 );
			half2 temp_output_73_0_g179 = rotator932;
			half2 ifLocalVar77_g179 = 0;
			if( length( temp_output_73_0_g179 ) == 0.0 )
				ifLocalVar77_g179 = half2( 0.001,0 );
			else
				ifLocalVar77_g179 = temp_output_73_0_g179;
			half2 normalizeResult79_g179 = normalize( ifLocalVar77_g179 );
			half2 break80_g179 = normalizeResult79_g179;
			half clampResult998 = clamp( temp_output_993_0 , 0.0 , ( temp_output_993_0 / clampResult894 ) );
			half clampResult1000 = clamp( clampResult998 , 0.01 , 1.0 );
			half temp_output_83_0_g179 = clampResult1000;
			half temp_output_61_0_g179 = ( ( UNITY_PI * 2.0 ) / _Gerstner_1_Instance.w );
			half temp_output_82_0_g179 = ( temp_output_83_0_g179 / temp_output_61_0_g179 );
			half3 break70_g179 = ase_worldPos;
			half3 appendResult71_g179 = (half3(break70_g179.x , break70_g179.z , 0.0));
			half dotResult72_g179 = dot( half3( normalizeResult79_g179 ,  0.0 ) , appendResult71_g179 );
			half temp_output_964_0 = ( _Time.y + TimeOffset843 );
			half _Small_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Swash_Size_arr, _Small_Wave_Swash_Size);
			half temp_output_991_0 = ( clampResult985 * ( clampResult1062 * ( _Small_Wave_Swash_Size_Instance * v.texcoord3.z ) ) );
			half clampResult996 = clamp( temp_output_991_0 , 0.0 , ( temp_output_991_0 / clampResult894 ) );
			half temp_output_67_0_g180 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g180 = clamp( v.texcoord3.w , 0.0 , temp_output_67_0_g180 );
			half temp_output_81_0_g179 = ( temp_output_61_0_g179 * ( dotResult72_g179 - ( sqrt( ( 9.8 / temp_output_61_0_g179 ) ) * ( ( temp_output_964_0 - ( 0.3 * clampResult996 ) ) - ( pow( abs( (1.0 + (clampResult135_g180 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g180 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_85_0_g179 = cos( temp_output_81_0_g179 );
			half temp_output_86_0_g179 = sin( temp_output_81_0_g179 );
			half temp_output_89_0_g179 = clampResult996;
			half temp_output_90_0_g179 = ( ( temp_output_82_0_g179 * temp_output_85_0_g179 ) + ( temp_output_86_0_g179 * temp_output_89_0_g179 ) );
			half3 appendResult94_g179 = (half3(( break80_g179.x * temp_output_90_0_g179 ) , ( temp_output_82_0_g179 * temp_output_86_0_g179 ) , ( break80_g179.y * temp_output_90_0_g179 )));
			float cos931 = cos( ( ( temp_output_929_0 + 180.0 ) * 0.01745 ) );
			float sin931 = sin( ( ( temp_output_929_0 + 180.0 ) * 0.01745 ) );
			half2 rotator931 = mul( appendResult967 - float2( 0,0 ) , float2x2( cos931 , -sin931 , sin931 , cos931 )) + float2( 0,0 );
			half2 temp_output_73_0_g177 = rotator931;
			half2 ifLocalVar77_g177 = 0;
			if( length( temp_output_73_0_g177 ) == 0.0 )
				ifLocalVar77_g177 = half2( 0.001,0 );
			else
				ifLocalVar77_g177 = temp_output_73_0_g177;
			half2 normalizeResult79_g177 = normalize( ifLocalVar77_g177 );
			half2 break80_g177 = normalizeResult79_g177;
			half clampResult1004 = clamp( temp_output_994_0 , 0.0 , ( temp_output_994_0 / clampResult894 ) );
			half clampResult1005 = clamp( clampResult1004 , 0.01 , 1.0 );
			half temp_output_83_0_g177 = clampResult1005;
			half temp_output_61_0_g177 = ( ( UNITY_PI * 2.0 ) / _Gerstner_2_Instance.w );
			half temp_output_82_0_g177 = ( temp_output_83_0_g177 / temp_output_61_0_g177 );
			half3 break70_g177 = ase_worldPos;
			half3 appendResult71_g177 = (half3(break70_g177.x , break70_g177.z , 0.0));
			half dotResult72_g177 = dot( half3( normalizeResult79_g177 ,  0.0 ) , appendResult71_g177 );
			half temp_output_992_0 = ( clampResult985 * ( ( _Small_Wave_Swash_Size_Instance * v.texcoord3.z ) * clampResult1063 ) );
			half clampResult1001 = clamp( temp_output_992_0 , 0.0 , ( temp_output_992_0 / clampResult894 ) );
			half temp_output_67_0_g178 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g178 = clamp( v.texcoord3.w , 0.0 , temp_output_67_0_g178 );
			half temp_output_81_0_g177 = ( temp_output_61_0_g177 * ( dotResult72_g177 - ( sqrt( ( 9.8 / temp_output_61_0_g177 ) ) * ( ( temp_output_964_0 - ( 0.3 * clampResult1001 ) ) - ( pow( abs( (1.0 + (clampResult135_g178 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g178 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_85_0_g177 = cos( temp_output_81_0_g177 );
			half temp_output_86_0_g177 = sin( temp_output_81_0_g177 );
			half temp_output_89_0_g177 = clampResult1001;
			half temp_output_90_0_g177 = ( ( temp_output_82_0_g177 * temp_output_85_0_g177 ) + ( temp_output_86_0_g177 * temp_output_89_0_g177 ) );
			half3 appendResult94_g177 = (half3(( break80_g177.x * temp_output_90_0_g177 ) , ( temp_output_82_0_g177 * temp_output_86_0_g177 ) , ( break80_g177.y * temp_output_90_0_g177 )));
			half3 temp_output_1078_0 = ( ( ( appendResult94_g51 + ( appendResult94_g54 + appendResult94_g55 ) ) + appendResult94_g179 ) + appendResult94_g177 );
			half clampResult44_g5 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Sea_Foam_Slope_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Foam_Slope_Influence_arr, _Sea_Foam_Slope_Influence);
			half2 SeaFoamSlopeInfluence701 = _Sea_Foam_Slope_Influence_Instance;
			half2 _SlowWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterSpeed_arr, _SlowWaterSpeed);
			half2 MainWaterSpeed692 = _SlowWaterSpeed_Instance;
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 WaterTiling693 = _SlowWaterTiling_Instance;
			half2 temp_output_66_0_g5 = WaterTiling693;
			half2 temp_output_53_0_g5 = ( ( ( ( ( 1.0 - clampResult44_g5 ) * SeaFoamSlopeInfluence701 ) + MainWaterSpeed692 ) * temp_output_66_0_g5 ) * v.texcoord3.xy );
			half2 break56_g5 = temp_output_53_0_g5;
			half2 appendResult57_g5 = (half2(break56_g5.y , break56_g5.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g5 = temp_output_53_0_g5;
			#else
				half2 staticSwitch59_g5 = appendResult57_g5;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half WaterFlowUVRefreshSpeed695 = _WaterFlowUVRefresSpeed_Instance;
			half temp_output_68_0_g5 = ( ( _Time.y + 0.0 ) * WaterFlowUVRefreshSpeed695 );
			half temp_output_71_0_g5 = frac( ( temp_output_68_0_g5 + 0.0 ) );
			half2 temp_output_60_0_g5 = ( staticSwitch59_g5 * temp_output_71_0_g5 );
			half2 temp_output_83_0_g5 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g5 * v.texcoord.xy ) );
			half2 temp_output_69_91 = ( temp_output_60_0_g5 + temp_output_83_0_g5 );
			half _SlowNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowNormalScale_arr, _SlowNormalScale);
			half2 temp_output_80_0_g5 = ( staticSwitch59_g5 * frac( ( temp_output_68_0_g5 + -0.5 ) ) );
			half2 temp_output_69_93 = ( temp_output_83_0_g5 + temp_output_80_0_g5 );
			half clampResult90_g5 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g5 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_69_96 = clampResult90_g5;
			half3 lerpResult80 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_91, 0.0 ), _SlowNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_93, 0.0 ), _SlowNormalScale_Instance ) , temp_output_69_96);
			half2 temp_output_145_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half2 _SlowWaterMixSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterMixSpeed_arr, _SlowWaterMixSpeed);
			half2 _MacroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveTiling_arr, _MacroWaveTiling);
			half2 appendResult136 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_147_0 = ( temp_output_145_0 + ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MacroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MacroWaveTiling_Instance * appendResult136 ) ) ) );
			half4 tex2DNode184 = SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0, 0.0 );
			half MacroWaveTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(MacroWaveTessScale_arr, MacroWaveTessScale);
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93, 0.0 ).r , temp_output_69_96);
			half _SlowWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTessScale_arr, _SlowWaterTessScale);
			half temp_output_1124_0 = min( PolarWaveDepthStartXFlattenPointY732.y , SmallWaveShoreDepthStartXFlattenPointY733.y );
			half clampResult1126 = clamp( ( temp_output_1124_0 / 3.0 ) , 0.0 , 9999.0 );
			half clampResult1132 = clamp( ( temp_output_1124_0 * 2.0 ) , 0.0 , 9999.0 );
			half clampResult1129 = clamp( (1.0 + (v.texcoord3.w - clampResult1126) * (0.0 - 1.0) / (clampResult1132 - clampResult1126)) , 0.0 , 1.0 );
			half lerpResult1133 = lerp( ( ( ( tex2DNode184.r + -0.25 ) * MacroWaveTessScale_Instance ) + ( lerpResult81 * _SlowWaterTessScale_Instance ) ) , 0.0 , clampResult1129);
			v.vertex.xyz += ( ( temp_output_1078_0 + ( lerpResult1133 * ase_worldNormal ) ) + float3( 0,0,0 ) );
			v.vertex.w = 1;
			half3 ase_vertexNormal = v.normal.xyz;
			half4 ase_vertexTangent = v.tangent;
			half3 ase_vertexBitangent = cross( ase_vertexNormal, ase_vertexTangent) * v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			half temp_output_95_0_g51 = ( temp_output_86_0_g51 * temp_output_83_0_g51 );
			half temp_output_1333_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			half clampResult126_g51 = clamp( temp_output_1333_0 , 0.0 , 100.0 );
			half clampResult130_g51 = clamp( ( ( ( clampResult126_g51 * 0.01 ) * temp_output_89_0_g51 ) + -1.0 ) , -0.6 , 0.0 );
			half clampResult132_g51 = clamp( temp_output_85_0_g51 , clampResult130_g51 , 1.0 );
			half temp_output_104_0_g51 = ( ( clampResult132_g51 * temp_output_61_0_g51 ) * temp_output_89_0_g51 );
			half temp_output_114_0_g51 = ( ( ( break80_g51.y * -1.0 ) * temp_output_95_0_g51 ) + ( break80_g51.y * temp_output_104_0_g51 ) );
			half temp_output_96_0_g51 = ( clampResult132_g51 * temp_output_83_0_g51 );
			half3 appendResult120_g51 = (half3(( break80_g51.x * temp_output_114_0_g51 ) , ( break80_g51.y * temp_output_96_0_g51 ) , ( break80_g51.y * temp_output_114_0_g51 )));
			half temp_output_95_0_g54 = ( temp_output_86_0_g54 * temp_output_83_0_g54 );
			half clampResult126_g54 = clamp( temp_output_1333_0 , 0.0 , 100.0 );
			half clampResult130_g54 = clamp( ( ( ( clampResult126_g54 * 0.01 ) * temp_output_89_0_g54 ) + -1.0 ) , -0.6 , 0.0 );
			half clampResult132_g54 = clamp( temp_output_85_0_g54 , clampResult130_g54 , 1.0 );
			half temp_output_104_0_g54 = ( ( clampResult132_g54 * temp_output_61_0_g54 ) * temp_output_89_0_g54 );
			half temp_output_114_0_g54 = ( ( ( break80_g54.y * -1.0 ) * temp_output_95_0_g54 ) + ( break80_g54.y * temp_output_104_0_g54 ) );
			half temp_output_96_0_g54 = ( clampResult132_g54 * temp_output_83_0_g54 );
			half3 appendResult120_g54 = (half3(( break80_g54.x * temp_output_114_0_g54 ) , ( break80_g54.y * temp_output_96_0_g54 ) , ( break80_g54.y * temp_output_114_0_g54 )));
			half clampResult144_g55 = clamp( temp_output_1333_0 , 0.0 , 100.0 );
			half clampResult146_g55 = clamp( ( ( ( clampResult144_g55 * 0.01 ) * temp_output_89_0_g55 ) + -1.0 ) , -0.6 , 0.0 );
			half clampResult147_g55 = clamp( temp_output_85_0_g55 , clampResult146_g55 , 1.0 );
			half temp_output_127_0_g55 = ( -1.0 / 1.0 );
			half temp_output_136_0_g55 = ( ( ( ( temp_output_83_0_g55 * -1.0 ) * temp_output_86_0_g55 ) + ( ( temp_output_61_0_g55 * clampResult147_g55 ) * temp_output_89_0_g55 ) ) * temp_output_127_0_g55 );
			half temp_output_138_0_g55 = ( break80_g55.y * temp_output_136_0_g55 );
			half temp_output_131_0_g55 = ( ( clampResult147_g55 * temp_output_83_0_g55 ) * temp_output_127_0_g55 );
			half3 appendResult120_g55 = (half3(( break80_g55.x * temp_output_138_0_g55 ) , ( break80_g55.y * temp_output_131_0_g55 ) , ( break80_g55.y * temp_output_138_0_g55 )));
			half temp_output_95_0_g179 = ( temp_output_86_0_g179 * temp_output_83_0_g179 );
			half clampResult126_g179 = clamp( temp_output_1333_0 , 0.0 , 100.0 );
			half clampResult130_g179 = clamp( ( ( ( clampResult126_g179 * 0.01 ) * temp_output_89_0_g179 ) + -1.0 ) , -0.6 , 0.0 );
			half clampResult132_g179 = clamp( temp_output_85_0_g179 , clampResult130_g179 , 1.0 );
			half temp_output_104_0_g179 = ( ( clampResult132_g179 * temp_output_61_0_g179 ) * temp_output_89_0_g179 );
			half temp_output_114_0_g179 = ( ( ( break80_g179.y * -1.0 ) * temp_output_95_0_g179 ) + ( break80_g179.y * temp_output_104_0_g179 ) );
			half temp_output_96_0_g179 = ( clampResult132_g179 * temp_output_83_0_g179 );
			half3 appendResult120_g179 = (half3(( break80_g179.x * temp_output_114_0_g179 ) , ( break80_g179.y * temp_output_96_0_g179 ) , ( break80_g179.y * temp_output_114_0_g179 )));
			half temp_output_95_0_g177 = ( temp_output_86_0_g177 * temp_output_83_0_g177 );
			half clampResult126_g177 = clamp( temp_output_1333_0 , 0.0 , 100.0 );
			half clampResult130_g177 = clamp( ( ( ( clampResult126_g177 * 0.01 ) * temp_output_89_0_g177 ) + -1.0 ) , -0.6 , 0.0 );
			half clampResult132_g177 = clamp( temp_output_85_0_g177 , clampResult130_g177 , 1.0 );
			half temp_output_104_0_g177 = ( ( clampResult132_g177 * temp_output_61_0_g177 ) * temp_output_89_0_g177 );
			half temp_output_114_0_g177 = ( ( ( break80_g177.y * -1.0 ) * temp_output_95_0_g177 ) + ( break80_g177.y * temp_output_104_0_g177 ) );
			half temp_output_96_0_g177 = ( clampResult132_g177 * temp_output_83_0_g177 );
			half3 appendResult120_g177 = (half3(( break80_g177.x * temp_output_114_0_g177 ) , ( break80_g177.y * temp_output_96_0_g177 ) , ( break80_g177.y * temp_output_114_0_g177 )));
			half temp_output_101_0_g51 = ( ( ( break80_g51.x * -1.0 ) * temp_output_95_0_g51 ) + ( break80_g51.x * temp_output_104_0_g51 ) );
			half3 appendResult110_g51 = (half3(( break80_g51.x * temp_output_101_0_g51 ) , ( break80_g51.x * temp_output_96_0_g51 ) , ( break80_g51.y * temp_output_101_0_g51 )));
			half temp_output_101_0_g54 = ( ( ( break80_g54.x * -1.0 ) * temp_output_95_0_g54 ) + ( break80_g54.x * temp_output_104_0_g54 ) );
			half3 appendResult110_g54 = (half3(( break80_g54.x * temp_output_101_0_g54 ) , ( break80_g54.x * temp_output_96_0_g54 ) , ( break80_g54.y * temp_output_101_0_g54 )));
			half temp_output_137_0_g55 = ( break80_g55.x * temp_output_136_0_g55 );
			half3 appendResult110_g55 = (half3(( break80_g55.x * temp_output_137_0_g55 ) , ( break80_g55.x * temp_output_131_0_g55 ) , ( break80_g55.y * temp_output_137_0_g55 )));
			half temp_output_101_0_g179 = ( ( ( break80_g179.x * -1.0 ) * temp_output_95_0_g179 ) + ( break80_g179.x * temp_output_104_0_g179 ) );
			half3 appendResult110_g179 = (half3(( break80_g179.x * temp_output_101_0_g179 ) , ( break80_g179.x * temp_output_96_0_g179 ) , ( break80_g179.y * temp_output_101_0_g179 )));
			half temp_output_101_0_g177 = ( ( ( break80_g177.x * -1.0 ) * temp_output_95_0_g177 ) + ( break80_g177.x * temp_output_104_0_g177 ) );
			half3 appendResult110_g177 = (half3(( break80_g177.x * temp_output_101_0_g177 ) , ( break80_g177.x * temp_output_96_0_g177 ) , ( break80_g177.y * temp_output_101_0_g177 )));
			half3 normalizeResult1099 = normalize( cross( ( half3(0,0,1) + ( ase_vertexBitangent + ( ( ( ( appendResult120_g51 + float3( 0,0,0 ) ) + ( ( appendResult120_g54 + float3( 0,0,0 ) ) + ( ( appendResult120_g55 * float3( -1,1,-1 ) ) + float3( 0,0,0 ) ) ) ) + ( appendResult120_g179 + float3( 0,0,0 ) ) ) + ( appendResult120_g177 + float3( 0,0,0 ) ) ) ) ) , ( half3(1,0,0) + ( ase_vertexTangent.xyz + ( ( ( ( appendResult110_g51 + float3( 0,0,0 ) ) + ( ( appendResult110_g54 + float3( 0,0,0 ) ) + ( ( appendResult110_g55 * float3( -1,1,-1 ) ) + float3( 0,0,0 ) ) ) ) + ( appendResult110_g179 + float3( 0,0,0 ) ) ) + ( appendResult110_g177 + float3( 0,0,0 ) ) ) ) ) ) );
			v.normal = ( normalizeResult1099 + float3( 0,0,0 ) );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half clampResult44_g5 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Sea_Foam_Slope_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Foam_Slope_Influence_arr, _Sea_Foam_Slope_Influence);
			half2 SeaFoamSlopeInfluence701 = _Sea_Foam_Slope_Influence_Instance;
			half2 _SlowWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterSpeed_arr, _SlowWaterSpeed);
			half2 MainWaterSpeed692 = _SlowWaterSpeed_Instance;
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 WaterTiling693 = _SlowWaterTiling_Instance;
			half2 temp_output_66_0_g5 = WaterTiling693;
			half2 temp_output_53_0_g5 = ( ( ( ( ( 1.0 - clampResult44_g5 ) * SeaFoamSlopeInfluence701 ) + MainWaterSpeed692 ) * temp_output_66_0_g5 ) * i.uv4_texcoord4.xy );
			half2 break56_g5 = temp_output_53_0_g5;
			half2 appendResult57_g5 = (half2(break56_g5.y , break56_g5.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g5 = temp_output_53_0_g5;
			#else
				half2 staticSwitch59_g5 = appendResult57_g5;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half WaterFlowUVRefreshSpeed695 = _WaterFlowUVRefresSpeed_Instance;
			half temp_output_68_0_g5 = ( ( _Time.y + 0.0 ) * WaterFlowUVRefreshSpeed695 );
			half temp_output_71_0_g5 = frac( ( temp_output_68_0_g5 + 0.0 ) );
			half2 temp_output_60_0_g5 = ( staticSwitch59_g5 * temp_output_71_0_g5 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
			half2 temp_output_83_0_g5 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g5 * i.uv_texcoord.xy ) );
			half2 temp_output_69_91 = ( temp_output_60_0_g5 + temp_output_83_0_g5 );
			half _SlowNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowNormalScale_arr, _SlowNormalScale);
			half2 temp_output_80_0_g5 = ( staticSwitch59_g5 * frac( ( temp_output_68_0_g5 + -0.5 ) ) );
			half2 temp_output_69_93 = ( temp_output_83_0_g5 + temp_output_80_0_g5 );
			half clampResult90_g5 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g5 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_69_96 = clampResult90_g5;
			half3 lerpResult80 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ), _SlowNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_93 ), _SlowNormalScale_Instance ) , temp_output_69_96);
			half2 _SlowWaterMixSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterMixSpeed_arr, _SlowWaterMixSpeed);
			half2 WindMicroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(WindMicroWaveTiling_arr, WindMicroWaveTiling);
			float3 ase_worldPos = i.worldPos;
			half2 appendResult124 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_145_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half3 tex2DNode149 = UnpackNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, ( ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * WindMicroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( WindMicroWaveTiling_Instance * appendResult124 ) ) ) + temp_output_145_0 ) ) );
			half2 appendResult152 = (half2(tex2DNode149.r , tex2DNode149.g));
			half2 appendResult168 = (half2(sign( ase_worldNormal.y ) , 1.0));
			half2 appendResult169 = (half2(ase_worldNormal.x , ase_worldNormal.z));
			half2 break174 = ( ( appendResult152 * appendResult168 ) + appendResult169 );
			half3 appendResult172 = (half3(break174.x , ( ase_worldNormal.y * tex2DNode149.b ) , break174.y));
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half3 worldToTangentDir178 = mul( ase_worldToTangent, appendResult172);
			half3 break31_g43 = worldToTangentDir178;
			half2 appendResult35_g43 = (half2(break31_g43.x , break31_g43.y));
			half _MicroWaveNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_MicroWaveNormalScale_arr, _MicroWaveNormalScale);
			half temp_output_38_0_g43 = _MicroWaveNormalScale_Instance;
			half lerpResult36_g43 = lerp( 1.0 , break31_g43.z , saturate( temp_output_38_0_g43 ));
			half3 appendResult34_g43 = (half3(( appendResult35_g43 * temp_output_38_0_g43 ) , lerpResult36_g43));
			half2 _MacroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveTiling_arr, _MacroWaveTiling);
			half2 appendResult136 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_147_0 = ( temp_output_145_0 + ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MacroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MacroWaveTiling_Instance * appendResult136 ) ) ) );
			half3 tex2DNode150 = UnpackNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_147_0 ) );
			half2 appendResult153 = (half2(tex2DNode150.r , tex2DNode150.g));
			half2 break175 = ( ( appendResult153 * appendResult168 ) + appendResult169 );
			half3 appendResult173 = (half3(break175.x , ( ase_worldNormal.y * tex2DNode150.b ) , break175.y));
			half3 worldToTangentDir179 = mul( ase_worldToTangent, appendResult173);
			half3 break31_g44 = worldToTangentDir179;
			half2 appendResult35_g44 = (half2(break31_g44.x , break31_g44.y));
			half _MacroWaveNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveNormalScale_arr, _MacroWaveNormalScale);
			half temp_output_38_0_g44 = _MacroWaveNormalScale_Instance;
			half lerpResult36_g44 = lerp( 1.0 , break31_g44.z , saturate( temp_output_38_0_g44 ));
			half3 appendResult34_g44 = (half3(( appendResult35_g44 * temp_output_38_0_g44 ) , lerpResult36_g44));
			half3 temp_output_116_0 = BlendNormals( lerpResult80 , BlendNormals( appendResult34_g43 , appendResult34_g44 ) );
			half _FarNormalPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalPower_arr, _FarNormalPower);
			half3 appendResult483 = (half3(_FarNormalPower_Instance , _FarNormalPower_Instance , 1.0));
			half temp_output_470_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			half _FarNormalBlendStartDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendStartDistance_arr, _FarNormalBlendStartDistance);
			half _FarNormalBlendThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendThreshold_arr, _FarNormalBlendThreshold);
			half clampResult480 = clamp( pow( abs( ( temp_output_470_0 / _FarNormalBlendStartDistance_Instance ) ) , _FarNormalBlendThreshold_Instance ) , 0.0 , 1.0 );
			half3 lerpResult481 = lerp( temp_output_116_0 , ( temp_output_116_0 * appendResult483 ) , clampResult480);
			half2 _Side_Foam_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Speed_arr, _Side_Foam_Speed);
			half2 temp_output_65_0_g45 = _Side_Foam_Speed_Instance;
			half4 _Vector0 = half4(-1,1,0,1);
			half2 _Side_Foam_Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Slope_Speed_Influence_arr, _Side_Foam_Slope_Speed_Influence);
			half2 _Side_Foam_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Tiling_arr, _Side_Foam_Tiling);
			half2 temp_output_66_0_g45 = _Side_Foam_Tiling_Instance;
			half2 temp_output_53_0_g45 = ( ( ( temp_output_65_0_g45 + ( temp_output_65_0_g45 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( _Side_Foam_Slope_Speed_Influence_Instance * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g45 ) * i.uv4_texcoord4.xy );
			half2 break56_g45 = temp_output_53_0_g45;
			half2 appendResult57_g45 = (half2(break56_g45.y , break56_g45.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g45 = temp_output_53_0_g45;
			#else
				half2 staticSwitch59_g45 = appendResult57_g45;
			#endif
			half _Side_Foam_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Flow_UV_Refresh_Speed_arr, _Side_Foam_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g45 = ( _Time.y * _Side_Foam_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g45 = frac( ( temp_output_68_0_g45 + 0.0 ) );
			half2 temp_output_60_0_g45 = ( staticSwitch59_g45 * temp_output_71_0_g45 );
			half2 temp_output_83_0_g45 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g45 * i.uv_texcoord.xy ) );
			half2 temp_output_94_91 = ( temp_output_60_0_g45 + temp_output_83_0_g45 );
			half _Side_Foam_Mask_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Mask_Normal_Scale_arr, _Side_Foam_Mask_Normal_Scale);
			half2 temp_output_80_0_g45 = ( staticSwitch59_g45 * frac( ( temp_output_68_0_g45 + -0.5 ) ) );
			half2 temp_output_94_93 = ( temp_output_83_0_g45 + temp_output_80_0_g45 );
			half clampResult90_g45 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g45 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_94_96 = clampResult90_g45;
			half3 lerpResult110 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Side_Foam_Mask_Normal, sampler_Linear_Repeat_Aniso8, temp_output_94_91 ), _Side_Foam_Mask_Normal_Scale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Side_Foam_Mask_Normal, sampler_Linear_Repeat_Aniso8, temp_output_94_93 ), _Side_Foam_Mask_Normal_Scale_Instance ) , temp_output_94_96);
			half4 _GerstnerDirection_4_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_4_arr, _GerstnerDirection_4);
			half temp_output_61_0_g54 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_4_Instance.w );
			half2 appendResult861 = (half2(i.uv4_texcoord4.x , i.uv4_texcoord4.y));
			half _Sea_Waves_Chaos_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Waves_Chaos_arr, _Sea_Waves_Chaos);
			float cos862 = cos( ( ( ( _GerstnerDirection_4_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			float sin862 = sin( ( ( ( _GerstnerDirection_4_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			half2 rotator862 = mul( appendResult861 - float2( 0,0 ) , float2x2( cos862 , -sin862 , sin862 , cos862 )) + float2( 0,0 );
			half2 temp_output_73_0_g54 = rotator862;
			half2 ifLocalVar77_g54 = 0;
			if( length( temp_output_73_0_g54 ) == 0.0 )
				ifLocalVar77_g54 = half2( 0.001,0 );
			else
				ifLocalVar77_g54 = temp_output_73_0_g54;
			half2 normalizeResult79_g54 = normalize( ifLocalVar77_g54 );
			half3 break70_g54 = ase_worldPos;
			half3 appendResult71_g54 = (half3(break70_g54.x , break70_g54.z , 0.0));
			half dotResult72_g54 = dot( half3( normalizeResult79_g54 ,  0.0 ) , appendResult71_g54 );
			half _Time_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Time_Offset_arr, _Time_Offset);
			half TimeOffset843 = _Time_Offset_Instance;
			half temp_output_841_0 = ( _Time.y + TimeOffset843 );
			half temp_output_81_0_g54 = ( temp_output_61_0_g54 * ( dotResult72_g54 - ( sqrt( ( 9.8 / temp_output_61_0_g54 ) ) * temp_output_841_0 ) ) );
			half temp_output_839_56 = ( ( ( ( ( UNITY_PI * 0.5 ) - ( temp_output_81_0_g54 + -3.8 ) ) % ( UNITY_PI * 2.0 ) ) / UNITY_PI ) + -1.0 );
			half clampResult1184 = clamp( temp_output_839_56 , 0.0 , 1.0 );
			half clampResult1185 = clamp( temp_output_839_56 , -1.0 , 1.0 );
			half4 _GerstnerDirection_5_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_5_arr, _GerstnerDirection_5);
			half temp_output_61_0_g51 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_5_Instance.w );
			float cos864 = cos( ( ( ( _GerstnerDirection_5_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			float sin864 = sin( ( ( ( _GerstnerDirection_5_Instance.z * _Sea_Waves_Chaos_Instance ) + 180.0 ) * 0.01745 ) );
			half2 rotator864 = mul( appendResult861 - float2( 0,0 ) , float2x2( cos864 , -sin864 , sin864 , cos864 )) + float2( 0,0 );
			half2 temp_output_73_0_g51 = rotator864;
			half2 ifLocalVar77_g51 = 0;
			if( length( temp_output_73_0_g51 ) == 0.0 )
				ifLocalVar77_g51 = half2( 0.001,0 );
			else
				ifLocalVar77_g51 = temp_output_73_0_g51;
			half2 normalizeResult79_g51 = normalize( ifLocalVar77_g51 );
			half3 break70_g51 = ase_worldPos;
			half3 appendResult71_g51 = (half3(break70_g51.x , break70_g51.z , 0.0));
			half dotResult72_g51 = dot( half3( normalizeResult79_g51 ,  0.0 ) , appendResult71_g51 );
			half temp_output_81_0_g51 = ( temp_output_61_0_g51 * ( dotResult72_g51 - ( sqrt( ( 9.8 / temp_output_61_0_g51 ) ) * temp_output_841_0 ) ) );
			half temp_output_853_56 = ( ( ( ( ( UNITY_PI * 0.5 ) - ( temp_output_81_0_g51 + -3.8 ) ) % ( UNITY_PI * 2.0 ) ) / UNITY_PI ) + -1.0 );
			half clampResult1189 = clamp( temp_output_853_56 , 0.0 , 1.0 );
			half clampResult1190 = clamp( temp_output_853_56 , -1.0 , 1.0 );
			half2 appendResult908 = (half2(i.uv_texcoord.z , i.uv_texcoord.w));
			half2 temp_output_73_0_g55 = appendResult908;
			half2 ifLocalVar77_g55 = 0;
			if( length( temp_output_73_0_g55 ) == 0.0 )
				ifLocalVar77_g55 = half2( 0.001,0 );
			else
				ifLocalVar77_g55 = temp_output_73_0_g55;
			half2 normalizeResult79_g55 = normalize( ifLocalVar77_g55 );
			half2 break80_g55 = normalizeResult79_g55;
			half2 _Polar_Wave_Depth_Start_X_Flatten_Point_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Depth_Start_X_Flatten_Point_Y_arr, _Polar_Wave_Depth_Start_X_Flatten_Point_Y);
			half2 PolarWaveDepthStartXFlattenPointY732 = _Polar_Wave_Depth_Start_X_Flatten_Point_Y_Instance;
			half2 break1308 = PolarWaveDepthStartXFlattenPointY732;
			half clampResult884 = clamp( ( i.uv4_texcoord4.w - break1308.y ) , 0.0 , 1.0 );
			half4 _GerstnerDirection_1_Instance = UNITY_ACCESS_INSTANCED_PROP(_GerstnerDirection_1_arr, _GerstnerDirection_1);
			half clampResult886 = clamp( (1.0 + (i.uv4_texcoord4.w - break1308.y) * (0.0 - 1.0) / (break1308.x - break1308.y)) , 0.0 , 1.0 );
			half clampResult890 = clamp( (_GerstnerDirection_1_Instance.y + (clampResult884 - 0.0) * (( _GerstnerDirection_1_Instance.x * clampResult886 ) - _GerstnerDirection_1_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half2 appendResult1009 = (half2(i.uv4_texcoord4.x , i.uv4_texcoord4.y));
			half2 normalizeResult1014 = normalize( ( appendResult1009 * float2( 1,-1 ) ) );
			half2 appendResult1011 = (half2(i.uv_texcoord.z , i.uv_texcoord.w));
			half2 normalizeResult1015 = normalize( appendResult1011 );
			half dotResult1016 = dot( normalizeResult1014 , normalizeResult1015 );
			half _Polar_Wave_Silent_Area_Angle_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Silent_Area_Angle_arr, _Polar_Wave_Silent_Area_Angle);
			half clampResult1022 = clamp( ( (0.0 + (dotResult1016 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + ( ( _Polar_Wave_Silent_Area_Angle_Instance + -180.0 ) / 180.0 ) ) , 0.0 , 1.0 );
			half clampResult1024 = clamp( ( 1.0 - clampResult1022 ) , 0.0 , 1.0 );
			half _Polar_Wave_Silent_Area_Angle_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Silent_Area_Angle_Hardness_arr, _Polar_Wave_Silent_Area_Angle_Hardness);
			half clampResult1028 = clamp( pow( abs( clampResult1024 ) , _Polar_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half clampResult44_g46 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Small_Wave_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Tiling_arr, _Small_Wave_Noise_Tiling);
			half2 temp_output_779_0 = ( _Small_Wave_Noise_Tiling_Instance / float2( 1,1 ) );
			half2 clampResult780 = clamp( temp_output_779_0 , float2( 0.001,0.001 ) , float2( 500,500 ) );
			half2 temp_output_66_0_g46 = temp_output_779_0;
			half2 temp_output_53_0_g46 = ( ( ( ( ( 1.0 - clampResult44_g46 ) * half2( 1,1 ) ) + ( ( float2( 1,1 ) / clampResult780 ) * float2( 2,2 ) ) ) * temp_output_66_0_g46 ) * i.uv4_texcoord4.xy );
			half2 break56_g46 = temp_output_53_0_g46;
			half2 appendResult57_g46 = (half2(break56_g46.y , break56_g46.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g46 = temp_output_53_0_g46;
			#else
				half2 staticSwitch59_g46 = appendResult57_g46;
			#endif
			half temp_output_68_0_g46 = ( ( _Time.y + TimeOffset843 ) * 0.05 );
			half temp_output_71_0_g46 = frac( ( temp_output_68_0_g46 + 0.0 ) );
			half2 temp_output_60_0_g46 = ( staticSwitch59_g46 * temp_output_71_0_g46 );
			half2 temp_output_83_0_g46 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g46 * i.uv_texcoord.xy ) );
			half2 temp_output_80_0_g46 = ( staticSwitch59_g46 * frac( ( temp_output_68_0_g46 + -0.5 ) ) );
			half clampResult90_g46 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g46 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult772 = lerp( SAMPLE_TEXTURE2D( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g46 + temp_output_83_0_g46 ) ).r , SAMPLE_TEXTURE2D( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g46 + temp_output_80_0_g46 ) ).r , clampResult90_g46);
			half _Small_Wave_Noise_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Power_arr, _Small_Wave_Noise_Power);
			half _Small_Wave_Noise_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Noise_Multiply_arr, _Small_Wave_Noise_Multiply);
			half clampResult787 = clamp( ( pow( abs( lerpResult772 ) , _Small_Wave_Noise_Power_Instance ) * _Small_Wave_Noise_Multiply_Instance ) , 0.0 , 1.0 );
			half temp_output_788_0 = (0.0 + (clampResult787 - 0.0) * (0.97 - 0.0) / (1.0 - 0.0));
			half clampResult897 = clamp( ( 1.0 - temp_output_788_0 ) , 0.0 , 1.0 );
			half temp_output_895_0 = ( ( clampResult890 * ( clampResult1028 * 1.0 ) ) * clampResult897 );
			half2 _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Depth_Flatten_Start_X_End_Y_arr, _Sea_Wave_Depth_Flatten_Start_X_End_Y);
			half temp_output_816_0 = (0.0 + (i.uv4_texcoord4.w - _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.y) * (1.0 - 0.0) / (_Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.x - _Sea_Wave_Depth_Flatten_Start_X_End_Y_Instance.y));
			half clampResult823 = clamp( temp_output_816_0 , 0.0 , 1.0 );
			half clampResult824 = clamp( (_GerstnerDirection_4_Instance.y + (clampResult823 - 0.0) * (max( ( clampResult823 * _GerstnerDirection_4_Instance.x ) , _GerstnerDirection_4_Instance.y ) - _GerstnerDirection_4_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half clampResult44_g47 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Sea_Wave_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Tiling_arr, _Sea_Wave_Noise_Tiling);
			half2 temp_output_801_0 = ( _Sea_Wave_Noise_Tiling_Instance / float2( 1,1 ) );
			half2 clampResult800 = clamp( temp_output_801_0 , float2( 0.001,0.001 ) , float2( 500,500 ) );
			half2 temp_output_66_0_g47 = temp_output_801_0;
			half2 temp_output_53_0_g47 = ( ( ( ( ( 1.0 - clampResult44_g47 ) * half2( 1,1 ) ) + ( ( float2( 1,1 ) / clampResult800 ) * float2( 1.8,1.8 ) ) ) * temp_output_66_0_g47 ) * i.uv4_texcoord4.xy );
			half2 break56_g47 = temp_output_53_0_g47;
			half2 appendResult57_g47 = (half2(break56_g47.y , break56_g47.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g47 = temp_output_53_0_g47;
			#else
				half2 staticSwitch59_g47 = appendResult57_g47;
			#endif
			half temp_output_68_0_g47 = ( ( _Time.y + TimeOffset843 ) * 0.07 );
			half temp_output_71_0_g47 = frac( ( temp_output_68_0_g47 + 0.0 ) );
			half2 temp_output_60_0_g47 = ( staticSwitch59_g47 * temp_output_71_0_g47 );
			half2 temp_output_83_0_g47 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g47 * i.uv_texcoord.xy ) );
			half2 temp_output_80_0_g47 = ( staticSwitch59_g47 * frac( ( temp_output_68_0_g47 + -0.5 ) ) );
			half clampResult90_g47 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g47 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult791 = lerp( SAMPLE_TEXTURE2D( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g47 + temp_output_83_0_g47 ) ).r , SAMPLE_TEXTURE2D( _Waves_Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g47 + temp_output_80_0_g47 ) ).r , clampResult90_g47);
			half _Sea_Wave_Noise_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Power_arr, _Sea_Wave_Noise_Power);
			half _Sea_Wave_Noise_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Noise_Multiply_arr, _Sea_Wave_Noise_Multiply);
			half clampResult807 = clamp( ( pow( abs( lerpResult791 ) , _Sea_Wave_Noise_Power_Instance ) * _Sea_Wave_Noise_Multiply_Instance ) , 0.0 , 1.0 );
			half clampResult827 = clamp( ( 1.0 - (0.05 + (clampResult807 - 0.0) * (0.97 - 0.05) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			half temp_output_825_0 = ( clampResult824 * clampResult827 );
			half clampResult833 = clamp( (_GerstnerDirection_5_Instance.y + (clampResult823 - 0.0) * (max( ( clampResult823 * _GerstnerDirection_5_Instance.x ) , _GerstnerDirection_5_Instance.y ) - _GerstnerDirection_5_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_832_0 = ( clampResult833 * clampResult827 );
			half2 _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_arr, _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y);
			half2 SmallWaveShoreDepthStartXFlattenPointY733 = _Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y_Instance;
			half2 break953 = SmallWaveShoreDepthStartXFlattenPointY733;
			half clampResult968 = clamp( ( i.uv4_texcoord4.w - break953.y ) , 0.0 , 1.0 );
			half4 _Gerstner_1_Instance = UNITY_ACCESS_INSTANCED_PROP(_Gerstner_1_arr, _Gerstner_1);
			half _Small_Wave_Shore_Height_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Shore_Height_Multiply_arr, _Small_Wave_Shore_Height_Multiply);
			half clampResult950 = clamp( (1.0 + (i.uv4_texcoord4.w - break953.y) * (0.0 - 1.0) / (break953.x - break953.y)) , 0.0 , 1.0 );
			half clampResult983 = clamp( (_Gerstner_1_Instance.y + (clampResult968 - 0.0) * (( _Gerstner_1_Instance.x + ( ( _Small_Wave_Shore_Height_Multiply_Instance * _Gerstner_1_Instance.x ) * clampResult950 ) ) - _Gerstner_1_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half clampResult985 = clamp( ( 1.0 - temp_output_788_0 ) , 0.0 , 1.0 );
			half clampResult1007 = clamp( temp_output_816_0 , 0.0 , 1.0 );
			half temp_output_1008_0 = ( 1.0 - clampResult1007 );
			half _Small_Waves_Chaos_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Waves_Chaos_arr, _Small_Waves_Chaos);
			half temp_output_933_0 = ( _Gerstner_1_Instance.z * _Small_Waves_Chaos_Instance );
			float cos1034 = cos( ( temp_output_933_0 * 0.01745 ) );
			float sin1034 = sin( ( temp_output_933_0 * 0.01745 ) );
			half2 rotator1034 = mul( normalizeResult1014 - float2( 0,0 ) , float2x2( cos1034 , -sin1034 , sin1034 , cos1034 )) + float2( 0,0 );
			half2 normalizeResult1038 = normalize( rotator1034 );
			half dotResult1040 = dot( normalizeResult1038 , normalizeResult1015 );
			half _Small_Wave_Silent_Area_Angle_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Silent_Area_Angle_arr, _Small_Wave_Silent_Area_Angle);
			half temp_output_1045_0 = ( ( _Small_Wave_Silent_Area_Angle_Instance + -180.0 ) / 180.0 );
			half clampResult1051 = clamp( ( temp_output_1008_0 * ( (0.0 + (dotResult1040 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + temp_output_1045_0 ) ) , 0.0 , 1.0 );
			half clampResult1055 = clamp( ( 1.0 - clampResult1051 ) , 0.0 , 1.0 );
			half _Small_Wave_Silent_Area_Angle_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Silent_Area_Angle_Hardness_arr, _Small_Wave_Silent_Area_Angle_Hardness);
			half clampResult1062 = clamp( pow( abs( clampResult1055 ) , _Small_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half temp_output_993_0 = ( ( clampResult983 * clampResult985 ) * clampResult1062 );
			half4 _Gerstner_2_Instance = UNITY_ACCESS_INSTANCED_PROP(_Gerstner_2_arr, _Gerstner_2);
			half clampResult984 = clamp( (_Gerstner_2_Instance.y + (clampResult968 - 0.0) * (( ( ( _Small_Wave_Shore_Height_Multiply_Instance * _Gerstner_2_Instance.x ) * clampResult950 ) + _Gerstner_2_Instance.x ) - _Gerstner_2_Instance.y) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_929_0 = ( _Gerstner_2_Instance.z * _Small_Waves_Chaos_Instance );
			float cos1036 = cos( ( temp_output_929_0 * 0.01745 ) );
			float sin1036 = sin( ( temp_output_929_0 * 0.01745 ) );
			half2 rotator1036 = mul( normalizeResult1014 - float2( 0,0 ) , float2x2( cos1036 , -sin1036 , sin1036 , cos1036 )) + float2( 0,0 );
			half2 normalizeResult1039 = normalize( rotator1036 );
			half dotResult1041 = dot( normalizeResult1039 , normalizeResult1015 );
			half clampResult1052 = clamp( ( temp_output_1008_0 * ( (0.0 + (dotResult1041 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + temp_output_1045_0 ) ) , 0.0 , 1.0 );
			half clampResult1056 = clamp( ( 1.0 - clampResult1052 ) , 0.0 , 1.0 );
			half clampResult1063 = clamp( pow( abs( clampResult1056 ) , _Small_Wave_Silent_Area_Angle_Hardness_Instance ) , 0.0 , 1.0 );
			half temp_output_994_0 = ( ( clampResult984 * clampResult985 ) * clampResult1063 );
			half clampResult894 = clamp( ( temp_output_895_0 + ( ( temp_output_825_0 + temp_output_832_0 ) + ( temp_output_993_0 + temp_output_994_0 ) ) ) , 0.01 , 999.0 );
			half clampResult899 = clamp( temp_output_895_0 , 0.0 , ( temp_output_895_0 / clampResult894 ) );
			half clampResult901 = clamp( clampResult899 , 0.01 , 1.0 );
			half temp_output_83_0_g55 = clampResult901;
			half temp_output_61_0_g55 = ( ( UNITY_PI * 2.0 ) / _GerstnerDirection_1_Instance.w );
			half temp_output_82_0_g55 = ( temp_output_83_0_g55 / temp_output_61_0_g55 );
			half _Polar_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_Wave_Swash_Size_arr, _Polar_Wave_Swash_Size);
			half temp_output_909_0 = ( clampResult897 * ( ( _Polar_Wave_Swash_Size_Instance * i.uv4_texcoord4.z ) * clampResult1028 ) );
			half clampResult910 = clamp( temp_output_909_0 , 0.0 , ( temp_output_909_0 / clampResult894 ) );
			half clampResult913 = clamp( (1.0 + (i.uv4_texcoord4.w - break1308.y) * (0.0 - 1.0) / (break1308.x - break1308.y)) , 0.001 , 1.0 );
			half temp_output_912_0 = ( clampResult910 * clampResult913 );
			half _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Depth_Mask_Power_arr, _Polar_and_Small_Waves_Friction_Depth_Mask_Power);
			half temp_output_67_0_g176 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g176 = clamp( i.uv4_texcoord4.w , 0.0 , temp_output_67_0_g176 );
			half _Polar_and_Small_Waves_Friction_Depth_Mask_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Depth_Mask_arr, _Polar_and_Small_Waves_Friction_Depth_Mask);
			half _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance = UNITY_ACCESS_INSTANCED_PROP(_Polar_and_Small_Waves_Friction_Speed_Reduction_arr, _Polar_and_Small_Waves_Friction_Speed_Reduction);
			half temp_output_81_0_g55 = ( temp_output_61_0_g55 * ( ( -1.0 * length( ifLocalVar77_g55 ) ) - ( sqrt( ( 9.8 / temp_output_61_0_g55 ) ) * ( ( ( _Time.y + TimeOffset843 ) - ( 0.3 * temp_output_912_0 ) ) - ( pow( abs( (1.0 + (clampResult135_g176 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g176 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_85_0_g55 = cos( temp_output_81_0_g55 );
			half temp_output_86_0_g55 = sin( temp_output_81_0_g55 );
			half temp_output_89_0_g55 = temp_output_912_0;
			half temp_output_90_0_g55 = ( ( temp_output_82_0_g55 * temp_output_85_0_g55 ) + ( temp_output_86_0_g55 * temp_output_89_0_g55 ) );
			half3 appendResult94_g55 = (half3(( ( break80_g55.x * -1.0 ) * temp_output_90_0_g55 ) , ( temp_output_82_0_g55 * temp_output_86_0_g55 ) , ( ( break80_g55.y * -1.0 ) * temp_output_90_0_g55 )));
			half clampResult124_g55 = clamp( appendResult94_g55.y , 0.0 , 10.0 );
			half temp_output_1120_56 = ( clampResult124_g55 * ( ( ( ( ( UNITY_PI * 0.5 ) - ( temp_output_81_0_g55 + -3.8 ) ) % ( UNITY_PI * 2.0 ) ) / UNITY_PI ) + -1.0 ) );
			half clampResult1194 = clamp( temp_output_1120_56 , 0.0 , 1.0 );
			half clampResult1195 = clamp( temp_output_1120_56 , -1.0 , 1.0 );
			half temp_output_61_0_g179 = ( ( UNITY_PI * 2.0 ) / _Gerstner_1_Instance.w );
			half2 appendResult967 = (half2(i.uv4_texcoord4.x , i.uv4_texcoord4.y));
			float cos932 = cos( ( ( temp_output_933_0 + 180.0 ) * 0.01745 ) );
			float sin932 = sin( ( ( temp_output_933_0 + 180.0 ) * 0.01745 ) );
			half2 rotator932 = mul( appendResult967 - float2( 0,0 ) , float2x2( cos932 , -sin932 , sin932 , cos932 )) + float2( 0,0 );
			half2 temp_output_73_0_g179 = rotator932;
			half2 ifLocalVar77_g179 = 0;
			if( length( temp_output_73_0_g179 ) == 0.0 )
				ifLocalVar77_g179 = half2( 0.001,0 );
			else
				ifLocalVar77_g179 = temp_output_73_0_g179;
			half2 normalizeResult79_g179 = normalize( ifLocalVar77_g179 );
			half3 break70_g179 = ase_worldPos;
			half3 appendResult71_g179 = (half3(break70_g179.x , break70_g179.z , 0.0));
			half dotResult72_g179 = dot( half3( normalizeResult79_g179 ,  0.0 ) , appendResult71_g179 );
			half temp_output_964_0 = ( _Time.y + TimeOffset843 );
			half _Small_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Wave_Swash_Size_arr, _Small_Wave_Swash_Size);
			half temp_output_991_0 = ( clampResult985 * ( clampResult1062 * ( _Small_Wave_Swash_Size_Instance * i.uv4_texcoord4.z ) ) );
			half clampResult996 = clamp( temp_output_991_0 , 0.0 , ( temp_output_991_0 / clampResult894 ) );
			half temp_output_67_0_g180 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g180 = clamp( i.uv4_texcoord4.w , 0.0 , temp_output_67_0_g180 );
			half temp_output_81_0_g179 = ( temp_output_61_0_g179 * ( dotResult72_g179 - ( sqrt( ( 9.8 / temp_output_61_0_g179 ) ) * ( ( temp_output_964_0 - ( 0.3 * clampResult996 ) ) - ( pow( abs( (1.0 + (clampResult135_g180 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g180 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_919_56 = ( ( ( ( ( UNITY_PI * 0.5 ) - ( temp_output_81_0_g179 + -3.8 ) ) % ( UNITY_PI * 2.0 ) ) / UNITY_PI ) + -1.0 );
			half clampResult1199 = clamp( temp_output_919_56 , 0.0 , 1.0 );
			half clampResult1200 = clamp( temp_output_919_56 , -1.0 , 1.0 );
			half temp_output_61_0_g177 = ( ( UNITY_PI * 2.0 ) / _Gerstner_2_Instance.w );
			float cos931 = cos( ( ( temp_output_929_0 + 180.0 ) * 0.01745 ) );
			float sin931 = sin( ( ( temp_output_929_0 + 180.0 ) * 0.01745 ) );
			half2 rotator931 = mul( appendResult967 - float2( 0,0 ) , float2x2( cos931 , -sin931 , sin931 , cos931 )) + float2( 0,0 );
			half2 temp_output_73_0_g177 = rotator931;
			half2 ifLocalVar77_g177 = 0;
			if( length( temp_output_73_0_g177 ) == 0.0 )
				ifLocalVar77_g177 = half2( 0.001,0 );
			else
				ifLocalVar77_g177 = temp_output_73_0_g177;
			half2 normalizeResult79_g177 = normalize( ifLocalVar77_g177 );
			half3 break70_g177 = ase_worldPos;
			half3 appendResult71_g177 = (half3(break70_g177.x , break70_g177.z , 0.0));
			half dotResult72_g177 = dot( half3( normalizeResult79_g177 ,  0.0 ) , appendResult71_g177 );
			half temp_output_992_0 = ( clampResult985 * ( ( _Small_Wave_Swash_Size_Instance * i.uv4_texcoord4.z ) * clampResult1063 ) );
			half clampResult1001 = clamp( temp_output_992_0 , 0.0 , ( temp_output_992_0 / clampResult894 ) );
			half temp_output_67_0_g178 = _Polar_and_Small_Waves_Friction_Depth_Mask_Power_Instance;
			half clampResult135_g178 = clamp( i.uv4_texcoord4.w , 0.0 , temp_output_67_0_g178 );
			half temp_output_81_0_g177 = ( temp_output_61_0_g177 * ( dotResult72_g177 - ( sqrt( ( 9.8 / temp_output_61_0_g177 ) ) * ( ( temp_output_964_0 - ( 0.3 * clampResult1001 ) ) - ( pow( abs( (1.0 + (clampResult135_g178 - 0.0) * (0.0 - 1.0) / (temp_output_67_0_g178 - 0.0)) ) , _Polar_and_Small_Waves_Friction_Depth_Mask_Instance ) * _Polar_and_Small_Waves_Friction_Speed_Reduction_Instance ) ) ) ) );
			half temp_output_928_56 = ( ( ( ( ( UNITY_PI * 0.5 ) - ( temp_output_81_0_g177 + -3.8 ) ) % ( UNITY_PI * 2.0 ) ) / UNITY_PI ) + -1.0 );
			half clampResult1204 = clamp( temp_output_928_56 , 0.0 , 1.0 );
			half clampResult1205 = clamp( temp_output_928_56 , -1.0 , 1.0 );
			half clampResult1210 = clamp( ( ( clampResult1184 * ( 1.0 - abs( clampResult1185 ) ) ) + ( clampResult1189 * ( 1.0 - abs( clampResult1190 ) ) ) + ( clampResult1194 * ( 1.0 - abs( clampResult1195 ) ) ) + ( clampResult1199 * ( 1.0 - abs( clampResult1200 ) ) ) + ( clampResult1204 * ( 1.0 - abs( clampResult1205 ) ) ) ) , 0.25 , 1.0 );
			half2 break80_g51 = normalizeResult79_g51;
			half clampResult858 = clamp( temp_output_832_0 , 0.0 , ( temp_output_832_0 / clampResult894 ) );
			half clampResult859 = clamp( clampResult858 , 0.01 , 1.0 );
			half temp_output_83_0_g51 = clampResult859;
			half temp_output_82_0_g51 = ( temp_output_83_0_g51 / temp_output_61_0_g51 );
			half temp_output_85_0_g51 = cos( temp_output_81_0_g51 );
			half temp_output_86_0_g51 = sin( temp_output_81_0_g51 );
			half clampResult856 = clamp( temp_output_832_0 , 0.0 , 1.0 );
			half _Sea_Wave_Swash_Size_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Wave_Swash_Size_arr, _Sea_Wave_Swash_Size);
			half temp_output_849_0 = ( i.uv4_texcoord4.z * _Sea_Wave_Swash_Size_Instance );
			half temp_output_89_0_g51 = ( clampResult856 * temp_output_849_0 );
			half temp_output_90_0_g51 = ( ( temp_output_82_0_g51 * temp_output_85_0_g51 ) + ( temp_output_86_0_g51 * temp_output_89_0_g51 ) );
			half3 appendResult94_g51 = (half3(( break80_g51.x * temp_output_90_0_g51 ) , ( temp_output_82_0_g51 * temp_output_86_0_g51 ) , ( break80_g51.y * temp_output_90_0_g51 )));
			half2 break80_g54 = normalizeResult79_g54;
			half clampResult845 = clamp( temp_output_825_0 , 0.0 , ( temp_output_825_0 / clampResult894 ) );
			half clampResult847 = clamp( clampResult845 , 0.01 , 1.0 );
			half temp_output_83_0_g54 = clampResult847;
			half temp_output_82_0_g54 = ( temp_output_83_0_g54 / temp_output_61_0_g54 );
			half temp_output_85_0_g54 = cos( temp_output_81_0_g54 );
			half temp_output_86_0_g54 = sin( temp_output_81_0_g54 );
			half clampResult852 = clamp( temp_output_825_0 , 0.0 , 1.0 );
			half temp_output_89_0_g54 = ( clampResult852 * temp_output_849_0 );
			half temp_output_90_0_g54 = ( ( temp_output_82_0_g54 * temp_output_85_0_g54 ) + ( temp_output_86_0_g54 * temp_output_89_0_g54 ) );
			half3 appendResult94_g54 = (half3(( break80_g54.x * temp_output_90_0_g54 ) , ( temp_output_82_0_g54 * temp_output_86_0_g54 ) , ( break80_g54.y * temp_output_90_0_g54 )));
			half2 break80_g179 = normalizeResult79_g179;
			half clampResult998 = clamp( temp_output_993_0 , 0.0 , ( temp_output_993_0 / clampResult894 ) );
			half clampResult1000 = clamp( clampResult998 , 0.01 , 1.0 );
			half temp_output_83_0_g179 = clampResult1000;
			half temp_output_82_0_g179 = ( temp_output_83_0_g179 / temp_output_61_0_g179 );
			half temp_output_85_0_g179 = cos( temp_output_81_0_g179 );
			half temp_output_86_0_g179 = sin( temp_output_81_0_g179 );
			half temp_output_89_0_g179 = clampResult996;
			half temp_output_90_0_g179 = ( ( temp_output_82_0_g179 * temp_output_85_0_g179 ) + ( temp_output_86_0_g179 * temp_output_89_0_g179 ) );
			half3 appendResult94_g179 = (half3(( break80_g179.x * temp_output_90_0_g179 ) , ( temp_output_82_0_g179 * temp_output_86_0_g179 ) , ( break80_g179.y * temp_output_90_0_g179 )));
			half2 break80_g177 = normalizeResult79_g177;
			half clampResult1004 = clamp( temp_output_994_0 , 0.0 , ( temp_output_994_0 / clampResult894 ) );
			half clampResult1005 = clamp( clampResult1004 , 0.01 , 1.0 );
			half temp_output_83_0_g177 = clampResult1005;
			half temp_output_82_0_g177 = ( temp_output_83_0_g177 / temp_output_61_0_g177 );
			half temp_output_85_0_g177 = cos( temp_output_81_0_g177 );
			half temp_output_86_0_g177 = sin( temp_output_81_0_g177 );
			half temp_output_89_0_g177 = clampResult1001;
			half temp_output_90_0_g177 = ( ( temp_output_82_0_g177 * temp_output_85_0_g177 ) + ( temp_output_86_0_g177 * temp_output_89_0_g177 ) );
			half3 appendResult94_g177 = (half3(( break80_g177.x * temp_output_90_0_g177 ) , ( temp_output_82_0_g177 * temp_output_86_0_g177 ) , ( break80_g177.y * temp_output_90_0_g177 )));
			half3 temp_output_1078_0 = ( ( ( appendResult94_g51 + ( appendResult94_g54 + appendResult94_g55 ) ) + appendResult94_g179 ) + appendResult94_g177 );
			half3 Waves710 = temp_output_1078_0;
			half clampResult1171 = clamp( Waves710.y , 0.0 , 10.0 );
			half _Side_Foam_Wave_Backs_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Wave_Backs_Offset_arr, _Side_Foam_Wave_Backs_Offset);
			half _Side_Foam_Wave_Backs_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Wave_Backs_Multiply_arr, _Side_Foam_Wave_Backs_Multiply);
			half clampResult1215 = clamp( ( ( ( (0.0 + (clampResult1210 - 0.25) * (1.0 - 0.0) / (1.0 - 0.25)) * clampResult1171 ) + _Side_Foam_Wave_Backs_Offset_Instance ) * _Side_Foam_Wave_Backs_Multiply_Instance ) , 0.0 , 1.0 );
			half clampResult1138 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half _Side_Foam_Waves_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Waves_Multiply_arr, _Side_Foam_Waves_Multiply);
			half _Side_Foam_Waves_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Waves_Offset_arr, _Side_Foam_Waves_Offset);
			half clampResult1178 = clamp( ( ( ( pow( clampResult1138 , 10.0 ) * clampResult1171 ) * _Side_Foam_Waves_Multiply_Instance ) + _Side_Foam_Waves_Offset_Instance ) , 0.0 , 1.0 );
			half _Side_Foam_Waves_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Waves_Power_arr, _Side_Foam_Waves_Power);
			half _Side_Foam_Depth_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Depth_Multiply_arr, _Side_Foam_Depth_Multiply);
			half clampResult572 = clamp( ( abs( i.uv4_texcoord4.w ) * _Side_Foam_Depth_Multiply_Instance ) , 0.0 , 1.0 );
			half _Side_Foam_Depth_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Depth_Falloff_arr, _Side_Foam_Depth_Falloff);
			half clampResult1217 = clamp( pow( abs( ( 1.0 - clampResult572 ) ) , _Side_Foam_Depth_Falloff_Instance ) , 0.0 , 1.0 );
			half2 appendResult1224 = (half2(ase_worldPos.x , ase_worldPos.z));
			half _Side_Foam_Perlin_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Perlin_Tiling_arr, _Side_Foam_Perlin_Tiling);
			half simplePerlin2D1222 = snoise( appendResult1224*_Side_Foam_Perlin_Tiling_Instance );
			simplePerlin2D1222 = simplePerlin2D1222*0.5 + 0.5;
			half _Side_Foam_Perlin_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Perlin_Multiply_arr, _Side_Foam_Perlin_Multiply);
			half _Side_Foam_Perlin_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Perlin_Power_arr, _Side_Foam_Perlin_Power);
			half clampResult1232 = clamp( pow( abs( ( simplePerlin2D1222 * _Side_Foam_Perlin_Multiply_Instance ) ) , _Side_Foam_Perlin_Power_Instance ) , 0.0 , 1.0 );
			half clampResult1234 = clamp( ( 1.0 - clampResult1232 ) , 0.0 , 1.0 );
			half temp_output_1220_0 = ( ( ( clampResult1215 + pow( clampResult1178 , _Side_Foam_Waves_Power_Instance ) ) * clampResult1217 ) * clampResult1234 );
			half clampResult1221 = clamp( temp_output_1220_0 , 0.0 , 1.0 );
			half3 lerpResult723 = lerp( lerpResult481 , BlendNormals( lerpResult481 , lerpResult110 ) , clampResult1221);
			half2 _Sea_Foam_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Foam_Tiling_arr, _Sea_Foam_Tiling);
			half2 temp_output_65_0_g35 = ( MainWaterSpeed692 / _Sea_Foam_Tiling_Instance );
			half2 temp_output_66_0_g35 = WaterTiling693;
			half2 temp_output_53_0_g35 = ( ( ( temp_output_65_0_g35 + ( temp_output_65_0_g35 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SeaFoamSlopeInfluence701 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g35 ) * i.uv4_texcoord4.xy );
			half2 break56_g35 = temp_output_53_0_g35;
			half2 appendResult57_g35 = (half2(break56_g35.y , break56_g35.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g35 = temp_output_53_0_g35;
			#else
				half2 staticSwitch59_g35 = appendResult57_g35;
			#endif
			half temp_output_68_0_g35 = ( _Time.y * WaterFlowUVRefreshSpeed695 );
			half temp_output_71_0_g35 = frac( ( temp_output_68_0_g35 + 0.0 ) );
			half2 temp_output_60_0_g35 = ( staticSwitch59_g35 * temp_output_71_0_g35 );
			half2 temp_output_83_0_g35 = ( ( 1.0 / _Sea_Foam_Tiling_Instance.x ) * ( temp_output_66_0_g35 * i.uv_texcoord.xy ) );
			half2 temp_output_679_91 = ( temp_output_60_0_g35 + temp_output_83_0_g35 );
			half _Sea_Foam_Texture_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Foam_Texture_Normal_Scale_arr, _Sea_Foam_Texture_Normal_Scale);
			half2 temp_output_80_0_g35 = ( staticSwitch59_g35 * frac( ( temp_output_68_0_g35 + -0.5 ) ) );
			half2 temp_output_679_93 = ( temp_output_83_0_g35 + temp_output_80_0_g35 );
			half clampResult90_g35 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g35 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_679_96 = clampResult90_g35;
			half3 lerpResult673 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Sea_Foam_Texture_Normal, sampler_Linear_Repeat_Aniso8, temp_output_679_91 ), _Sea_Foam_Texture_Normal_Scale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Side_Foam_Mask_Normal, sampler_Linear_Repeat_Aniso8, temp_output_679_93 ), _Sea_Foam_Texture_Normal_Scale_Instance ) , temp_output_679_96);
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ).r , SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93 ).r , temp_output_69_96);
			half Sea_Waves_Foam_Mask_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(Sea_Waves_Foam_Mask_Hardness_arr, Sea_Waves_Foam_Mask_Hardness);
			half Sea_Waves_Foam_Mask_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(Sea_Waves_Foam_Mask_Power_arr, Sea_Waves_Foam_Mask_Power);
			half Sea_Waves_Foam_Mask_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(Sea_Waves_Foam_Mask_Multiply_arr, Sea_Waves_Foam_Mask_Multiply);
			half clampResult1253 = clamp( ( pow( abs( ( lerpResult81 * Sea_Waves_Foam_Mask_Hardness_Instance ) ) , Sea_Waves_Foam_Mask_Power_Instance ) * Sea_Waves_Foam_Mask_Multiply_Instance ) , 0.0 , 1.0 );
			half _Sea_Waves_Foam_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Waves_Foam_Multiply_arr, _Sea_Waves_Foam_Multiply);
			half _Sea_Waves_Foam_Mask_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Waves_Foam_Mask_Offset_arr, _Sea_Waves_Foam_Mask_Offset);
			half clampResult1251 = clamp( ( ( Waves710.y * _Sea_Waves_Foam_Multiply_Instance ) + _Sea_Waves_Foam_Mask_Offset_Instance ) , 0.0 , 1.0 );
			half _Sea_Waves_Foam_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Waves_Foam_Power_arr, _Sea_Waves_Foam_Power);
			half clampResult1257 = clamp( pow( abs( clampResult1251 ) , _Sea_Waves_Foam_Power_Instance ) , 0.0 , 1.0 );
			half lerpResult678 = lerp( SAMPLE_TEXTURE2D( _Sea_Foam_Texture, sampler_Linear_Repeat_Aniso8, temp_output_679_91 ).r , SAMPLE_TEXTURE2D( _Sea_Foam_Texture, sampler_Linear_Repeat_Aniso8, temp_output_679_93 ).r , temp_output_679_96);
			half _Sea_Foam_Texture_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_Sea_Foam_Texture_Falloff_arr, _Sea_Foam_Texture_Falloff);
			half clampResult1263 = clamp( pow( abs( lerpResult678 ) , _Sea_Foam_Texture_Falloff_Instance ) , 0.0 , 1.0 );
			half clampResult1264 = clamp( ( ( clampResult1253 * clampResult1257 ) * clampResult1263 ) , 0.0 , 1.0 );
			half clampResult1268 = clamp( distance( i.uv4_texcoord4.w , 0.0 ) , 0.0 , 1.0 );
			half clampResult1292 = clamp( ( clampResult1264 * clampResult1268 ) , 0.0 , 1.0 );
			half3 lerpResult725 = lerp( lerpResult723 , BlendNormals( lerpResult723 , lerpResult673 ) , clampResult1292);
			half _Water_Normal_Flatten_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Normal_Flatten_Multiply_arr, _Water_Normal_Flatten_Multiply);
			half3 appendResult727 = (half3(_Water_Normal_Flatten_Multiply_Instance , _Water_Normal_Flatten_Multiply_Instance , 1.0));
			half temp_output_738_0 = min( PolarWaveDepthStartXFlattenPointY732.y , SmallWaveShoreDepthStartXFlattenPointY733.y );
			half clampResult741 = clamp( ( temp_output_738_0 / 2.0 ) , 0.0 , 9999.0 );
			half clampResult742 = clamp( ( temp_output_738_0 * 2.0 ) , 0.0 , 9999.0 );
			half clampResult750 = clamp( (1.0 + (i.uv4_texcoord4.w - clampResult741) * (0.0 - 1.0) / (clampResult742 - clampResult741)) , 0.0 , 1.0 );
			half3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			half clampResult756 = clamp( abs( ase_vertexNormal.y ) , 0.0 , 1.0 );
			half clampResult761 = clamp( ( clampResult750 + ( pow( abs( ( 1.0 - clampResult756 ) ) , 2.0 ) * 600.0 ) ) , 0.0 , 1.0 );
			half3 lerpResult729 = lerp( lerpResult725 , ( lerpResult725 * appendResult727 ) , clampResult761);
			o.Normal = lerpResult729;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half3 normalizeResult1314 = normalize( lerpResult481 );
			half3 break42_g61 = normalizeResult1314;
			half3 appendResult14_g61 = (half3(break42_g61.x , break42_g61.y , break42_g61.z));
			half _Distortion_Instance = UNITY_ACCESS_INSTANCED_PROP(_Distortion_arr, _Distortion);
			half temp_output_45_0_g61 = _Distortion_Instance;
			half3 temp_output_38_0_g61 = ( appendResult14_g61 * temp_output_45_0_g61 );
			half2 appendResult20_g61 = (half2(_ScreenParams.x , _ScreenParams.y));
			half2 temp_output_23_0_g61 = ( half2( 1,1 ) / appendResult20_g61 );
			half eyeDepth18_g61 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( ( floor( ( ( ase_screenPosNorm + half4( temp_output_38_0_g61 , 0.0 ) ) * half4( appendResult20_g61, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g61 ), 0.0 , 0.0 ) ).xy ));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_viewPos = UnityObjectToViewPos( ase_vertex4Pos );
			float ase_screenDepth = -ase_viewPos.z;
			half temp_output_16_0_g61 = ( eyeDepth18_g61 - ase_screenDepth );
			half4 temp_output_35_0_g61 = ( ( floor( ( ase_screenPosNorm * half4( appendResult20_g61, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g61 ), 0.0 , 0.0 ) );
			half4 temp_output_22_0_g61 = ( temp_output_35_0_g61 + half4( ( saturate( temp_output_16_0_g61 ) * ( temp_output_38_0_g61 / ase_screenPos.w ) ) , 0.0 ) );
			half4 ifLocalVar30_g61 = 0;
			if( temp_output_16_0_g61 >= 0.0 )
				ifLocalVar30_g61 = temp_output_22_0_g61;
			else
				ifLocalVar30_g61 = temp_output_35_0_g61;
			half4 temp_output_1313_0 = ifLocalVar30_g61;
			half4 screenColor352 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_1313_0.xy);
			half _Clean_Water_Background_Brightness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clean_Water_Background_Brightness_arr, _Clean_Water_Background_Brightness);
			half4 temp_output_415_0 = ( screenColor352 * _Clean_Water_Background_Brightness_Instance );
			half _Caustic_Intensivity_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Intensivity_arr, _Caustic_Intensivity);
			half4 _Caustic_Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Color_arr, _Caustic_Color);
			half _Caustic_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Falloff_arr, _Caustic_Falloff);
			half temp_output_44_0_g37 = _Caustic_Falloff_Instance;
			half3 appendResult34_g37 = (half3(temp_output_44_0_g37 , temp_output_44_0_g37 , temp_output_44_0_g37));
			half _Caustic_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Tiling_arr, _Caustic_Tiling);
			half temp_output_42_0_g37 = _Caustic_Tiling_Instance;
			half2 temp_cast_15 = (temp_output_42_0_g37).xx;
			half _Caustic_Triplanar_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Triplanar_Hardness_arr, _Caustic_Triplanar_Hardness);
			half temp_output_43_0_g37 = _Caustic_Triplanar_Hardness_Instance;
			half _Caustic_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Speed_arr, _Caustic_Speed);
			half temp_output_14_0_g37 = ( _Caustic_Speed_Instance * _Time.y );
			half3 appendResult16_g37 = (half3(temp_output_14_0_g37 , temp_output_14_0_g37 , temp_output_14_0_g37));
			half4 temp_output_38_0_g37 = temp_output_1313_0;
			half4 temp_output_76_0_g40 = temp_output_38_0_g37;
			half2 UV22_g41 = temp_output_76_0_g40.xy;
			half2 localUnStereo22_g41 = UnStereo( UV22_g41 );
			half2 break64_g40 = localUnStereo22_g41;
			half clampDepth69_g40 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, temp_output_76_0_g40.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g40 = ( 1.0 - clampDepth69_g40 );
			#else
				float staticSwitch38_g40 = clampDepth69_g40;
			#endif
			half3 appendResult39_g40 = (half3(break64_g40.x , break64_g40.y , staticSwitch38_g40));
			half4 appendResult42_g40 = (half4((appendResult39_g40*2.0 + -1.0) , 1.0));
			half4 temp_output_43_0_g40 = mul( unity_CameraInvProjection, appendResult42_g40 );
			half3 temp_output_46_0_g40 = ( (temp_output_43_0_g40).xyz / (temp_output_43_0_g40).w );
			half3 In72_g40 = temp_output_46_0_g40;
			half3 localInvertDepthDir72_g40 = InvertDepthDir72_g40( In72_g40 );
			half4 appendResult49_g40 = (half4(localInvertDepthDir72_g40 , 1.0));
			half4 temp_output_48_0_g37 = mul( unity_CameraToWorld, appendResult49_g40 );
			float4 triplanar25_g37 = TriplanarSampling25_g37( _Caustic, sampler_Caustic, ( half4( ( appendResult16_g37 * float3( 0.76,0.73,0.79 ) ) , 0.0 ) + temp_output_48_0_g37 ).xyz, ase_worldNormal, temp_output_43_0_g37, temp_cast_15, 1.0, 0 );
			half3 appendResult35_g37 = (half3(triplanar25_g37.xyz));
			half2 temp_cast_20 = (temp_output_42_0_g37).xx;
			half temp_output_17_0_g37 = ( temp_output_14_0_g37 * -1.07 );
			half3 appendResult21_g37 = (half3(temp_output_17_0_g37 , temp_output_17_0_g37 , temp_output_17_0_g37));
			float4 triplanar26_g37 = TriplanarSampling26_g37( _Caustic, sampler_Caustic, ( half4( appendResult21_g37 , 0.0 ) + temp_output_48_0_g37 ).xyz, ase_worldNormal, temp_output_43_0_g37, temp_cast_20, 1.0, 0 );
			half3 appendResult36_g37 = (half3(triplanar26_g37.xyz));
			half3 clampResult37_g37 = clamp( ( appendResult34_g37 * min( appendResult35_g37 , appendResult36_g37 ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			half4 temp_cast_25 = (_Caustic_Intensivity_Instance).xxxx;
			half _Caustic_Blend_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Blend_arr, _Caustic_Blend);
			half4 lerpResult425 = lerp( temp_output_415_0 , ( ( temp_output_415_0 / _Caustic_Intensivity_Instance ) + ( pow( abs( ( _Caustic_Color_Instance * half4( clampResult37_g37 , 0.0 ) ) ) , temp_cast_25 ) * _Caustic_Intensivity_Instance ) ) , _Caustic_Blend_Instance);
			#ifdef _USE_CAUSTIC
				half4 staticSwitch666 = lerpResult425;
			#else
				half4 staticSwitch666 = temp_output_415_0;
			#endif
			half4 _DeepColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_DeepColor_arr, _DeepColor);
			half4 _ShalowColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowColor_arr, _ShalowColor);
			half3 temp_output_41_0_g62 = temp_output_1313_0.xyz;
			half clampDepth36_g62 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, half4( temp_output_41_0_g62 , 0.0 ).xy );
			half temp_output_16_0_g62 = ( _ProjectionParams.x < 0.0 ? clampDepth36_g62 : ( 1.0 - clampDepth36_g62 ) );
			half temp_output_31_0_g62 = saturate( ( (_ProjectionParams.z + (temp_output_16_0_g62 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - ase_screenDepth ) );
			half eyeDepth39_g62 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, half4( temp_output_41_0_g62 , 0.0 ).xy ));
			half ifLocalVar40_g62 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar40_g62 = temp_output_31_0_g62;
			else
				ifLocalVar40_g62 = ( eyeDepth39_g62 - ase_screenDepth );
			half temp_output_1312_0 = ifLocalVar40_g62;
			half _ShalowFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffMultiply_arr, _ShalowFalloffMultiply);
			half _ShalowFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffPower_arr, _ShalowFalloffPower);
			half clampResult16 = clamp( saturate( pow( abs( ( temp_output_1312_0 * _ShalowFalloffMultiply_Instance ) ) , ( _ShalowFalloffPower_Instance * -1.0 ) ) ) , 0.0 , 1.0 );
			half4 lerpResult23 = lerp( _DeepColor_Instance , _ShalowColor_Instance , clampResult16);
			half4 tex2DNode184 = SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0 );
			half _SlowWaterTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTranslucencyMultiply_arr, _SlowWaterTranslucencyMultiply);
			half _WaveTranslucencyHardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyHardness_arr, _WaveTranslucencyHardness);
			half _WaveTranslucencyPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyPower_arr, _WaveTranslucencyPower);
			half _WaveTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyMultiply_arr, _WaveTranslucencyMultiply);
			half _WaveTranslucencyFallOffDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyFallOffDistance_arr, _WaveTranslucencyFallOffDistance);
			half lerpResult508 = lerp( ( pow( abs( ( ( ( tex2DNode184.r * _SlowWaterTranslucencyMultiply_Instance ) + ( lerpResult81 * _SlowWaterTranslucencyMultiply_Instance ) ) * _WaveTranslucencyHardness_Instance ) ) , _WaveTranslucencyPower_Instance ) * _WaveTranslucencyMultiply_Instance ) , 0.0 , ( temp_output_470_0 / _WaveTranslucencyFallOffDistance_Instance ));
			half _Big_Front_Waves_Translucency_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Front_Waves_Translucency_Multiply_arr, _Big_Front_Waves_Translucency_Multiply);
			half clampResult1289 = clamp( abs( ( ( 1.0 - ase_vertexNormal.y ) * _Big_Front_Waves_Translucency_Multiply_Instance ) ) , 0.0 , 1.0 );
			half _Big_Front_Waves_Translucency_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Front_Waves_Translucency_Power_arr, _Big_Front_Waves_Translucency_Power);
			half _Big_Waves_Translucency_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Waves_Translucency_Multiply_arr, _Big_Waves_Translucency_Multiply);
			half _Big_Waves_Translucency_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Waves_Translucency_Offset_arr, _Big_Waves_Translucency_Offset);
			half clampResult1279 = clamp( ( ( Waves710.y * _Big_Waves_Translucency_Multiply_Instance ) + ( clampResult1268 * _Big_Waves_Translucency_Offset_Instance ) ) , 0.0 , 1.0 );
			half _Big_Waves_Translucency_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Waves_Translucency_Power_arr, _Big_Waves_Translucency_Power);
			half clampResult1271 = clamp( ( lerpResult508 + ( pow( clampResult1289 , _Big_Front_Waves_Translucency_Power_Instance ) + pow( clampResult1279 , _Big_Waves_Translucency_Power_Instance ) ) ) , 0.0 , 1.0 );
			half _Shore_Translucency_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shore_Translucency_Multiply_arr, _Shore_Translucency_Multiply);
			half clampResult515 = clamp( ( _Shore_Translucency_Multiply_Instance * temp_output_1312_0 ) , 0.0 , 1.0 );
			half _Shore_Translucency_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shore_Translucency_Power_arr, _Shore_Translucency_Power);
			half clampResult514 = clamp( pow( abs( clampResult515 ) , _Shore_Translucency_Power_Instance ) , 0.0 , 1.0 );
			half clampResult520 = clamp( ( clampResult1271 + ( 1.0 - clampResult514 ) ) , 0.0 , 1.0 );
			half _Translucency_Global_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Translucency_Global_Power_arr, _Translucency_Global_Power);
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half dotResult525 = dot( ase_worldViewDir , ase_worldlightDir );
			half clampResult527 = clamp( ( dotResult525 * -1.0 ) , 0.0 , 1.0 );
			half _Translucency_Direct_Sun_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Translucency_Direct_Sun_Power_arr, _Translucency_Direct_Sun_Power);
			half clampResult534 = clamp( ( ( clampResult520 * _Translucency_Global_Power_Instance ) + ( ( clampResult527 * _Translucency_Direct_Sun_Power_Instance ) * clampResult520 ) ) , 0.0 , 1.0 );
			half4 lerpResult26 = lerp( lerpResult23 , _ShalowColor_Instance , clampResult534);
			half _WaterAlphaMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterAlphaMultiply_arr, _WaterAlphaMultiply);
			half clampResult43 = clamp( ( temp_output_1312_0 * _WaterAlphaMultiply_Instance ) , 0.0 , 1.0 );
			half _WaterAlphaPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterAlphaPower_arr, _WaterAlphaPower);
			half clampResult42 = clamp( pow( abs( clampResult43 ) , _WaterAlphaPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult28 = lerp( ( lerpResult26 * staticSwitch666 ) , lerpResult26 , clampResult42);
			half _CleanFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffMultiply_arr, _CleanFalloffMultiply);
			half clampResult35 = clamp( ( temp_output_1312_0 * _CleanFalloffMultiply_Instance ) , 0.0 , 1.0 );
			half _CleanFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffPower_arr, _CleanFalloffPower);
			half clampResult34 = clamp( pow( abs( clampResult35 ) , _CleanFalloffPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult30 = lerp( staticSwitch666 , lerpResult28 , clampResult34);
			half3 _SeaFoamColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SeaFoamColor_arr, _SeaFoamColor);
			half4 lerpResult589 = lerp( lerpResult30 , half4( _SeaFoamColor_Instance , 0.0 ) , clampResult1292);
			half3 _Side_Foam_Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Color_arr, _Side_Foam_Color);
			half3 _Side_Foam_Crest_Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Crest_Color_arr, _Side_Foam_Crest_Color);
			half _Side_Foam_Crest_Mask_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Crest_Mask_Multiply_arr, _Side_Foam_Crest_Mask_Multiply);
			half _Side_Foam_Crest_Mask_Offset_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Crest_Mask_Offset_arr, _Side_Foam_Crest_Mask_Offset);
			half temp_output_712_0 = ( _Side_Foam_Crest_Mask_Multiply_Instance * ( _Side_Foam_Crest_Mask_Offset_Instance + ( Waves710.y * pow( ase_worldNormal.y , 2.0 ) ) ) );
			half clampResult1302 = clamp( temp_output_712_0 , 0.0 , 1.0 );
			half3 lerpResult1299 = lerp( _Side_Foam_Color_Instance , _Side_Foam_Crest_Color_Instance , clampResult1302);
			half lerpResult100 = lerp( SAMPLE_TEXTURE2D( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_94_91 ).r , SAMPLE_TEXTURE2D( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_94_93 ).r , temp_output_94_96);
			half _Side_Foam_Mask_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Mask_Power_arr, _Side_Foam_Mask_Power);
			half clampResult711 = clamp( temp_output_712_0 , 0.0 , 1.0 );
			half clampResult708 = clamp( ( _Side_Foam_Mask_Power_Instance * clampResult711 ) , 0.0 , ( _Side_Foam_Mask_Power_Instance * 0.9 ) );
			half clampResult1135 = clamp( pow( abs( lerpResult100 ) , ( _Side_Foam_Mask_Power_Instance - clampResult708 ) ) , 0.0 , 1.0 );
			half temp_output_1235_0 = ( temp_output_1220_0 * clampResult1135 );
			half clampResult1294 = clamp( temp_output_1235_0 , 0.0 , 1.0 );
			half4 lerpResult1298 = lerp( lerpResult589 , half4( lerpResult1299 , 0.0 ) , clampResult1294);
			half clampDepth53_g62 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy );
			half temp_output_52_0_g62 = ( _ProjectionParams.x < 0.0 ? clampDepth53_g62 : ( 1.0 - clampDepth53_g62 ) );
			half temp_output_49_0_g62 = saturate( ( (_ProjectionParams.z + (temp_output_52_0_g62 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - ase_screenDepth ) );
			half eyeDepth44_g62 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half ifLocalVar46_g62 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar46_g62 = temp_output_49_0_g62;
			else
				ifLocalVar46_g62 = ( eyeDepth44_g62 - ase_screenDepth );
			half _EdgeFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_EdgeFalloffMultiply_arr, _EdgeFalloffMultiply);
			half clampResult4 = clamp( ( ifLocalVar46_g62 * _EdgeFalloffMultiply_Instance ) , 0.0 , 1.0 );
			half _EdgeFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_EdgeFalloffPower_arr, _EdgeFalloffPower);
			half clampResult8 = clamp( pow( abs( clampResult4 ) , _EdgeFalloffPower_Instance ) , 0.0 , 1.0 );
			half temp_output_660_0 = ( clampResult8 * i.vertexColor.a );
			half _BackfaceAlpha_Instance = UNITY_ACCESS_INSTANCED_PROP(_BackfaceAlpha_arr, _BackfaceAlpha);
			half switchResult661 = (((i.ASEIsFrontFacing>0)?(temp_output_660_0):(( temp_output_660_0 * _BackfaceAlpha_Instance ))));
			half clampResult1296 = clamp( temp_output_1235_0 , 0.0 , 1.0 );
			half lerpResult1297 = lerp( switchResult661 , 1.0 , clampResult1296);
			half clampResult1318 = clamp( lerpResult1297 , 0.0 , 1.0 );
			#ifdef DIRECTIONAL_COOKIE
				half staticSwitch1316 = clampResult1318;
			#else
				half staticSwitch1316 = 1.0;
			#endif
			o.Albedo = ( lerpResult1298 * staticSwitch1316 ).rgb;
			half _Water_Specular_Far_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Far_arr, _Water_Specular_Far);
			half _Water_Specular_Close_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Close_arr, _Water_Specular_Close);
			half _WaterSpecularThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterSpecularThreshold_arr, _WaterSpecularThreshold);
			half clampResult621 = clamp( pow( abs( clampResult16 ) , _WaterSpecularThreshold_Instance ) , 0.0 , 1.0 );
			half lerpResult616 = lerp( _Water_Specular_Far_Instance , _Water_Specular_Close_Instance , clampResult621);
			half _Foam_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Foam_Specular_arr, _Foam_Specular);
			half temp_output_1304_0 = max( clampResult1292 , clampResult1294 );
			half lerpResult613 = lerp( lerpResult616 , _Foam_Specular_Instance , temp_output_1304_0);
			half3 temp_cast_32 = (( lerpResult613 * staticSwitch1316 )).xxx;
			o.Specular = temp_cast_32;
			half _NMWaterSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_NMWaterSmoothness_arr, _NMWaterSmoothness);
			half _NMFoamSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_NMFoamSmoothness_arr, _NMFoamSmoothness);
			half lerpResult592 = lerp( _NMWaterSmoothness_Instance , _NMFoamSmoothness_Instance , temp_output_1304_0);
			o.Smoothness = lerpResult592;
			half _AOPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AOPower_arr, _AOPower);
			o.Occlusion = ( _AOPower_Instance * staticSwitch1316 );
			o.Alpha = lerpResult1297;
		}

		ENDCG
	}
	Fallback "Diffuse"
}