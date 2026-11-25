Shader "NatureManufacture/Water/Swamp Tesselation"
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
		_Slope_Speed_Influence("Slope Speed Influence", Vector) = (0,0,0,0)
		_Detail2MainSpeed("Detail 2 Main Speed", Vector) = (0.3,0.3,0,0)
		_Detail1MainSpeed("Detail 1 Main Speed", Vector) = (0.3,0.3,0,0)
		_MainWaterSpeed("Main Water Speed", Vector) = (0.3,0.3,0,0)
		_Detail2FlowUVRefreshSpeed("Detail 2 Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_Detail1FlowUVRefreshSpeed("Detail 1 Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_WaterFlowUVRefresSpeed("Water Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_SlowWaterMixSpeed("Wind Water Mix Speed", Vector) = (0,0,0,0)
		_CascadeMainSpeed("Cascade Main Speed", Vector) = (1,1,0,0)
		_CascadeFlowUVRefreshSpeed("Cascade Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_EdgeFalloffMultiply("Alpha Edge Falloff Multiply", Float) = 5.19
		_EdgeFalloffPower("Alpha Edge Falloff Power", Float) = 0.74
		_WaterAlphaMultiply("Alpha Global Multiply", Float) = 0.66
		_WaterAlphaPower("Alpha Global Power", Float) = 1.39
		BackfaceAlpha("Backface Alpha", Range( 0 , 1)) = 1
		_Details_Slope_Speed_Influence("Details Slope Speed Influence", Vector) = (0,0,0,0)
		_Clean_Water_Background_Brightness("Clean Water Background Brightness", Float) = 0.9
		_CleanFalloffMultiply("Clean Falloff Multiply", Float) = 1.29
		_CleanFalloffPower("Clean Falloff Power", Float) = 0.38
		_ShalowColor("Shalow Color", Color) = (0.4031684,0.5485649,0.5660378,0)
		_ShalowFalloffMultiply("Shalow Falloff Multiply", Float) = 1.043
		_ShalowFalloffPower("Shalow Falloff Power", Float) = 3.9
		_DeepColor("Deep Color", Color) = (0.05660379,0.05660379,0.05660379,0)
		_BigCascadeTransparency("Big Cascade Transparency", Range( 0 , 1)) = 3.9
		[NoScaleOffset]_SlowWaterNormal("Water Normal", 2D) = "bump" {}
		_SlowWaterTiling("Water Tiling", Vector) = (3,3,0,0)
		_SlowNormalScale("Water Normal Scale", Float) = 0
		_MicroWaveNormalScale("Wind Micro Wave Normal Scale", Range( 0 , 2)) = 0
		_MicroWaveTiling("Wind Micro Wave Tiling", Vector) = (0.5,0.5,0,0)
		_MacroWaveNormalScale("Wind Macro Wave Normal Scale", Range( 0 , 2)) = 0
		_MacroWaveTiling("Wind Macro Wave Tiling", Vector) = (0,0,0,0)
		_FarNormalPower("Far Normal Power", Range( 0 , 1)) = 0.5
		_FarNormalBlendStartDistance("Far Normal Blend Start Distance", Float) = 0
		_FarNormalBlendThreshold("Far Normal Blend Threshold", Float) = 10
		_CascadeAngle("Cascade Angle", Range( 0.001 , 90)) = 15
		_CascadeAngleFalloff("Cascade Angle Falloff", Range( 0 , 80)) = 0.7
		_CascadeTiling("Cascade Tiling", Vector) = (2,2,0,0)
		[NoScaleOffset]_BigCascadeNormal("Cascade Normal", 2D) = "bump" {}
		_CascadeNormalScale("Cascade Normal Scale", Float) = 0.7
		_Distortion("Distortion", Range( 0 , 1)) = 0.03
		_NMWaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_AOPower("Water Ambient Occlusion", Float) = 1
		_WaterSpecularThreshold("Water Specular Threshold", Range( 0 , 10)) = 0
		_Water_Specular_Close("Water Specular Close", Range( 0 , 1)) = 0
		_Water_Specular_Far("Water Specular Far", Range( 0 , 1)) = 0
		[NoScaleOffset]_Noise("Noise Detail 1(G) Detail 2(A)", 2D) = "white" {}
		_NoiseTiling1("Detail 1 Noise Tiling", Vector) = (3,3,0,0)
		_Detail1NoisePower("Detail 1 Noise Power", Range( 0 , 10)) = 5.48
		_Detail1NoiseMultiply("Detail 1 Noise Multiply", Range( 0 , 40)) = 5
		[NoScaleOffset]_DetailAlbedo("Detail 1 Albedo(RGB) Alpha(A)", 2D) = "white" {}
		_Detail1Tiling("Detail 1 Tiling", Vector) = (8,8,0,0)
		_DetailAlbedoColor("Detail 1 Albedo Color", Vector) = (1,1,1,0)
		_Detail_1_Specular("Detail 1 Specular", Range( 0 , 1)) = 0
		[NoScaleOffset]_DetailNormal("Detail 1 Normal", 2D) = "bump" {}
		_DetailNormalScale("Detail 1 Normal Scale", Float) = 0
		[NoScaleOffset]_Detail_1_AO_G_T_B_SM_A("Detail 1 AO(G) T(B) SM(A)", 2D) = "white" {}
		_Detail_1_AO_Remap_Min("Detail 1 AO Remap Min", Range( 0 , 1)) = 0
		_Detail_1_AO_Remap_Max("Detail 1 AO Remap Max", Range( 0 , 1)) = 1
		_Detail_1_Smoothness_Remap_Min("Detail 1 Smoothness Remap Min", Range( 0 , 1)) = 0
		_Detail_1_Smoothness_Remap_Max("Detail 1 Smoothness Remap Max", Range( 0 , 1)) = 1
		_NoiseTiling2("Detail 2 Noise Tiling", Vector) = (3,3,0,0)
		_Detail2NoisePower("Detail 2 Noise Power", Range( 0 , 10)) = 5.48
		_Detail2NoiseMultiply("Detail 2 Noise Multiply", Range( 0 , 40)) = 5
		_Detail2Tiling("Detail 2 Tiling", Vector) = (15,15,0,0)
		[NoScaleOffset]_Detail2Albedo("Detail 2 Albedo(RGB) Alpha(A)", 2D) = "white" {}
		_Detail2AlbedoColor("Detail 2 Albedo Color", Vector) = (1,1,1,0)
		_Detail_2_Specular("Detail 2 Specular", Range( 0 , 1)) = 0
		[NoScaleOffset]_Detail2Normal("Detail 2 Normal", 2D) = "bump" {}
		_Detail2NormalScale("Detail 2 Normal Scale", Float) = 0
		[NoScaleOffset]_Detail_2_AO_G_T_B_SM_A("Detail 2 AO(G) T(B) SM(A)", 2D) = "white" {}
		_Detail_2_AO_Remap_Min("Detail 2 AO Remap Min", Range( 0 , 1)) = 0
		_Detail_2_AO_Remap_Max("Detail 2 AO Remap Max", Range( 0 , 1)) = 1
		_Detail_2_Smoothness_Remap_Min("Detail 2 Smoothness Remap Min", Range( 0 , 1)) = 0
		_Detail_2_Smoothness_Remap_Max("Detail 2 Smoothness Remap Max", Range( 0 , 1)) = 1
		_Translucency_Global_Power("Translucency Global Power", Range( 0 , 100)) = 10
		_Translucency_Direct_Sun_Power("Translucency Direct Sun Power", Range( 0 , 100)) = 10
		_WaterTranslucencyMultiply("Water Translucency Multiply", Range( 0 , 10)) = 0
		_CascadeTranslucencyMultiply("Cascade Translucency Multiply", Range( 0 , 10)) = 1
		_WaveTranslucencyHardness("Wave Translucency Hardness", Float) = 0
		_WaveTranslucencyPower("Wave Translucency Power", Range( 0 , 10)) = 0
		_WaveTranslucencyMultiply("Wave Translucency Multiply", Range( 0 , 10)) = 0
		_WaveTranslucencyFallOffDistance("Wave Translucency FallOff Distance", Float) = 0
		_Shore_Translucency_Multiply("Shore Translucency Multiply", Range( 0.01 , 100)) = 0.66
		_Shore_Translucency_Power("Shore Translucency Power", Range( 0.01 , 100)) = 1.39
		[NoScaleOffset]_WaterTesselation("Water Tess", 2D) = "black" {}
		_SlowWaterTessScale("Water Tess Scale", Float) = 0
		MacroWaveTessScale("Wind Macro Wave Tess Scale", Float) = 0
		[NoScaleOffset]_CascadeWaterTess("Cascade Water Tess", 2D) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		_CascadeWaterTessScale("Cascade Water Tess Scale", Float) = 0.1
		[Toggle(_USE_CAUSTIC)] _Use_Caustic("Use_Caustic", Float) = 0
		[NoScaleOffset]_Caustic("Caustic", 2D) = "white" {}
		[HDR]_Caustic_Color("Caustic Color", Color) = (1,1,1,0)
		_Caustic_Tiling("Caustic Tiling", Float) = 0.05
		_Caustic_Triplanar_Hardness("Caustic Triplanar Hardness", Float) = 3
		_Caustic_Speed("Caustic Speed", Float) = 0.4
		_Caustic_Falloff("Caustic Falloff", Float) = 3.33
		_Caustic_Intensivity("Caustic Intensivity", Float) = 7.07
		_Caustic_Blend("Caustic Blend", Range( 0 , 1)) = 0.044
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull [_CullModeOff0Front1Back2]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
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

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
			float2 uv4_texcoord4;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPos;
			half ASEIsFrontFacing : VFACE;
		};

		uniform int _CullModeOff0Front1Back2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_WaterTesselation);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SlowWaterNormal);
		SamplerState sampler_Linear_Repeat_Aniso8;
		SamplerState sampler_SlowWaterNormal;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CascadeWaterTess);
		uniform half _CascadeAngle;
		uniform half _CascadeAngleFalloff;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedo);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Noise);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail2Normal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail2Albedo);
		SamplerState sampler_Detail2Albedo;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BigCascadeNormal);
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Caustic);
		SamplerState sampler_Caustic;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail_1_AO_G_T_B_SM_A);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Detail_2_AO_G_T_B_SM_A);
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		UNITY_INSTANCING_BUFFER_START(Graph_NM_Swamp_Tesselation)
			UNITY_DEFINE_INSTANCED_PROP(half4, _ShalowColor)
#define _ShalowColor_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _DeepColor)
#define _DeepColor_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _Caustic_Color)
#define _Caustic_Color_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _Detail2AlbedoColor)
#define _Detail2AlbedoColor_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _DetailAlbedoColor)
#define _DetailAlbedoColor_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _NoiseTiling2)
#define _NoiseTiling2_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Detail2Tiling)
#define _Detail2Tiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Detail2MainSpeed)
#define _Detail2MainSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _NoiseTiling1)
#define _NoiseTiling1_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Detail1Tiling)
#define _Detail1Tiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Detail1MainSpeed)
#define _Detail1MainSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Details_Slope_Speed_Influence)
#define _Details_Slope_Speed_Influence_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MicroWaveTiling)
#define _MicroWaveTiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Slope_Speed_Influence)
#define _Slope_Speed_Influence_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _CascadeTiling)
#define _CascadeTiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MainWaterSpeed)
#define _MainWaterSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterTiling)
#define _SlowWaterTiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MacroWaveTiling)
#define _MacroWaveTiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterMixSpeed)
#define _SlowWaterMixSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _CascadeMainSpeed)
#define _CascadeMainSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyMultiply)
#define _WaveTranslucencyMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Global_Power)
#define _Translucency_Global_Power_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Direct_Sun_Power)
#define _Translucency_Direct_Sun_Power_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Multiply)
#define _Shore_Translucency_Multiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaMultiply)
#define _WaterAlphaMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaPower)
#define _WaterAlphaPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyHardness)
#define _WaveTranslucencyHardness_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyFallOffDistance)
#define _WaveTranslucencyFallOffDistance_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffMultiply)
#define _CleanFalloffMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffPower)
#define _CleanFalloffPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyPower)
#define _WaveTranslucencyPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Power)
#define _Shore_Translucency_Power_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Far)
#define _Water_Specular_Far_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffPower)
#define _EdgeFalloffPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_2_Smoothness_Remap_Min)
#define _Detail_2_Smoothness_Remap_Min_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_2_AO_Remap_Min)
#define _Detail_2_AO_Remap_Min_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_1_Smoothness_Remap_Max)
#define _Detail_1_Smoothness_Remap_Max_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_1_AO_Remap_Max)
#define _Detail_1_AO_Remap_Max_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_1_Smoothness_Remap_Min)
#define _Detail_1_Smoothness_Remap_Min_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_1_AO_Remap_Min)
#define _Detail_1_AO_Remap_Min_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffMultiply)
#define _EdgeFalloffMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _AOPower)
#define _AOPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_2_Specular)
#define _Detail_2_Specular_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_1_Specular)
#define _Detail_1_Specular_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterSpecularThreshold)
#define _WaterSpecularThreshold_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Close)
#define _Water_Specular_Close_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CascadeTranslucencyMultiply)
#define _CascadeTranslucencyMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, BackfaceAlpha)
#define BackfaceAlpha_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _NMWaterSmoothness)
#define _NMWaterSmoothness_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterTranslucencyMultiply)
#define _WaterTranslucencyMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Tiling)
#define _Caustic_Tiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffPower)
#define _ShalowFalloffPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterFlowUVRefresSpeed)
#define _WaterFlowUVRefresSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _GlobalTiling)
#define _GlobalTiling_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowNormalScale)
#define _SlowNormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, MacroWaveTessScale)
#define MacroWaveTessScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowWaterTessScale)
#define _SlowWaterTessScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CascadeWaterTessScale)
#define _CascadeWaterTessScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CascadeFlowUVRefreshSpeed)
#define _CascadeFlowUVRefreshSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MicroWaveNormalScale)
#define _MicroWaveNormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MacroWaveNormalScale)
#define _MacroWaveNormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail1FlowUVRefreshSpeed)
#define _Detail1FlowUVRefreshSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _DetailNormalScale)
#define _DetailNormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail1NoisePower)
#define _Detail1NoisePower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail1NoiseMultiply)
#define _Detail1NoiseMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail2FlowUVRefreshSpeed)
#define _Detail2FlowUVRefreshSpeed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeTransparency)
#define _BigCascadeTransparency_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail2NormalScale)
#define _Detail2NormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail2NoiseMultiply)
#define _Detail2NoiseMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CascadeNormalScale)
#define _CascadeNormalScale_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalPower)
#define _FarNormalPower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendStartDistance)
#define _FarNormalBlendStartDistance_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendThreshold)
#define _FarNormalBlendThreshold_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Distortion)
#define _Distortion_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Clean_Water_Background_Brightness)
#define _Clean_Water_Background_Brightness_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Intensivity)
#define _Caustic_Intensivity_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Falloff)
#define _Caustic_Falloff_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_2_AO_Remap_Max)
#define _Detail_2_AO_Remap_Max_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Triplanar_Hardness)
#define _Caustic_Triplanar_Hardness_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Speed)
#define _Caustic_Speed_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Blend)
#define _Caustic_Blend_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffMultiply)
#define _ShalowFalloffMultiply_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail2NoisePower)
#define _Detail2NoisePower_arr Graph_NM_Swamp_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Detail_2_Smoothness_Remap_Max)
#define _Detail_2_Smoothness_Remap_Max_arr Graph_NM_Swamp_Tesselation
		UNITY_INSTANCING_BUFFER_END(Graph_NM_Swamp_Tesselation)


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
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			half clampResult44_g32 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Slope_Speed_Influence_arr, _Slope_Speed_Influence);
			half2 SlopeSpeedInfluence204 = _Slope_Speed_Influence_Instance;
			half2 _MainWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainWaterSpeed_arr, _MainWaterSpeed);
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 temp_output_66_0_g32 = _SlowWaterTiling_Instance;
			half2 temp_output_53_0_g32 = ( ( ( ( ( 1.0 - clampResult44_g32 ) * SlopeSpeedInfluence204 ) + _MainWaterSpeed_Instance ) * temp_output_66_0_g32 ) * v.texcoord3.xy );
			half2 break56_g32 = temp_output_53_0_g32;
			half2 appendResult57_g32 = (half2(break56_g32.y , break56_g32.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g32 = temp_output_53_0_g32;
			#else
				half2 staticSwitch59_g32 = appendResult57_g32;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half temp_output_68_0_g32 = ( ( _Time.y + 0.0 ) * _WaterFlowUVRefresSpeed_Instance );
			half temp_output_71_0_g32 = frac( ( temp_output_68_0_g32 + 0.0 ) );
			half2 temp_output_60_0_g32 = ( staticSwitch59_g32 * temp_output_71_0_g32 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
			half2 temp_output_83_0_g32 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g32 * v.texcoord.xy ) );
			half2 temp_output_69_91 = ( temp_output_60_0_g32 + temp_output_83_0_g32 );
			half _SlowNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowNormalScale_arr, _SlowNormalScale);
			half2 temp_output_80_0_g32 = ( staticSwitch59_g32 * frac( ( temp_output_68_0_g32 + -0.5 ) ) );
			half2 temp_output_69_93 = ( temp_output_83_0_g32 + temp_output_80_0_g32 );
			half clampResult90_g32 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g32 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_69_96 = clampResult90_g32;
			half3 lerpResult80 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_91, 0.0 ), _SlowNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_SlowWaterNormal, temp_output_69_93, 0.0 ), _SlowNormalScale_Instance ) , temp_output_69_96);
			half2 temp_output_145_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half2 _SlowWaterMixSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterMixSpeed_arr, _SlowWaterMixSpeed);
			half2 _MacroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveTiling_arr, _MacroWaveTiling);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half2 appendResult136 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_147_0 = ( temp_output_145_0 + ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MacroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MacroWaveTiling_Instance * appendResult136 ) ) ) );
			half4 tex2DNode184 = SAMPLE_TEXTURE2D_LOD( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0, 0.0 );
			half MacroWaveTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(MacroWaveTessScale_arr, MacroWaveTessScale);
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D_LOD( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93, 0.0 ).r , temp_output_69_96);
			half _SlowWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTessScale_arr, _SlowWaterTessScale);
			half _CascadeWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeWaterTessScale_arr, _CascadeWaterTessScale);
			half2 _CascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeMainSpeed_arr, _CascadeMainSpeed);
			half2 temp_output_65_0_g13 = _CascadeMainSpeed_Instance;
			half4 _Vector0 = half4(-1,1,0,1);
			half2 _CascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeTiling_arr, _CascadeTiling);
			half2 temp_output_66_0_g13 = _CascadeTiling_Instance;
			half2 temp_output_53_0_g13 = ( ( ( temp_output_65_0_g13 + ( temp_output_65_0_g13 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g13 ) * v.texcoord3.xy );
			half2 break56_g13 = temp_output_53_0_g13;
			half2 appendResult57_g13 = (half2(break56_g13.y , break56_g13.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g13 = temp_output_53_0_g13;
			#else
				half2 staticSwitch59_g13 = appendResult57_g13;
			#endif
			half _CascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeFlowUVRefreshSpeed_arr, _CascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g13 = ( _Time.y * _CascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g13 = frac( ( temp_output_68_0_g13 + 0.0 ) );
			half2 temp_output_60_0_g13 = ( staticSwitch59_g13 * temp_output_71_0_g13 );
			half2 temp_output_83_0_g13 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g13 * v.texcoord.xy ) );
			half2 temp_output_256_91 = ( temp_output_60_0_g13 + temp_output_83_0_g13 );
			half2 temp_output_80_0_g13 = ( staticSwitch59_g13 * frac( ( temp_output_68_0_g13 + -0.5 ) ) );
			half2 temp_output_256_93 = ( temp_output_83_0_g13 + temp_output_80_0_g13 );
			half clampResult90_g13 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g13 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_256_96 = clampResult90_g13;
			half lerpResult261 = lerp( SAMPLE_TEXTURE2D_LOD( _CascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _CascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_93, 0.0 ).r , temp_output_256_96);
			half temp_output_547_0 = ( _CascadeWaterTessScale_Instance * ( lerpResult261 + -0.25 ) );
			half clampResult307 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half temp_output_310_0 = ( _CascadeAngle / 45.0 );
			half clampResult318 = clamp( ( clampResult307 - ( 1.0 - temp_output_310_0 ) ) , 0.0 , 2.0 );
			half clampResult320 = clamp( ( clampResult318 * ( 1.0 / temp_output_310_0 ) ) , 0.0 , 1.0 );
			half clampResult329 = clamp( pow( abs( ( 1.0 - clampResult320 ) ) , _CascadeAngleFalloff ) , 0.0 , 1.0 );
			half CascadeAngle335 = clampResult329;
			half4 break469 = v.color;
			half lerpResult553 = lerp( ( ( ( tex2DNode184.r + -0.2 ) * MacroWaveTessScale_Instance ) + ( ( lerpResult81 + -0.2 ) * _SlowWaterTessScale_Instance ) ) , ( temp_output_547_0 * CascadeAngle335 ) , break469.g);
			half lerpResult552 = lerp( lerpResult553 , temp_output_547_0 , break469.b);
			half3 ase_vertexNormal = v.normal.xyz;
			half3 clampResult559 = clamp( ase_vertexNormal , float3( 0,0,0 ) , float3( 1,1,1 ) );
			v.vertex.xyz += ( lerpResult552 * clampResult559 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half clampResult44_g32 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Slope_Speed_Influence_arr, _Slope_Speed_Influence);
			half2 SlopeSpeedInfluence204 = _Slope_Speed_Influence_Instance;
			half2 _MainWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainWaterSpeed_arr, _MainWaterSpeed);
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 temp_output_66_0_g32 = _SlowWaterTiling_Instance;
			half2 temp_output_53_0_g32 = ( ( ( ( ( 1.0 - clampResult44_g32 ) * SlopeSpeedInfluence204 ) + _MainWaterSpeed_Instance ) * temp_output_66_0_g32 ) * i.uv4_texcoord4 );
			half2 break56_g32 = temp_output_53_0_g32;
			half2 appendResult57_g32 = (half2(break56_g32.y , break56_g32.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g32 = temp_output_53_0_g32;
			#else
				half2 staticSwitch59_g32 = appendResult57_g32;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half temp_output_68_0_g32 = ( ( _Time.y + 0.0 ) * _WaterFlowUVRefresSpeed_Instance );
			half temp_output_71_0_g32 = frac( ( temp_output_68_0_g32 + 0.0 ) );
			half2 temp_output_60_0_g32 = ( staticSwitch59_g32 * temp_output_71_0_g32 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
			half2 temp_output_83_0_g32 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g32 * i.uv_texcoord ) );
			half2 temp_output_69_91 = ( temp_output_60_0_g32 + temp_output_83_0_g32 );
			half _SlowNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowNormalScale_arr, _SlowNormalScale);
			half2 temp_output_80_0_g32 = ( staticSwitch59_g32 * frac( ( temp_output_68_0_g32 + -0.5 ) ) );
			half2 temp_output_69_93 = ( temp_output_83_0_g32 + temp_output_80_0_g32 );
			half clampResult90_g32 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g32 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_69_96 = clampResult90_g32;
			half3 lerpResult80 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ), _SlowNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_SlowWaterNormal, temp_output_69_93 ), _SlowNormalScale_Instance ) , temp_output_69_96);
			half2 _SlowWaterMixSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterMixSpeed_arr, _SlowWaterMixSpeed);
			half2 _MicroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_MicroWaveTiling_arr, _MicroWaveTiling);
			float3 ase_worldPos = i.worldPos;
			half2 appendResult124 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_145_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half3 tex2DNode149 = UnpackNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, ( ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MicroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MicroWaveTiling_Instance * appendResult124 ) ) ) + temp_output_145_0 ) ) );
			half2 appendResult152 = (half2(tex2DNode149.r , tex2DNode149.g));
			half2 appendResult168 = (half2(sign( ase_worldNormal.y ) , 1.0));
			half2 appendResult169 = (half2(ase_worldNormal.x , ase_worldNormal.z));
			half2 break174 = ( ( appendResult152 * appendResult168 ) + appendResult169 );
			half3 appendResult172 = (half3(break174.x , ( ase_worldNormal.y * tex2DNode149.b ) , break174.y));
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half3 worldToTangentDir178 = mul( ase_worldToTangent, appendResult172);
			half3 break31_g7 = worldToTangentDir178;
			half2 appendResult35_g7 = (half2(break31_g7.x , break31_g7.y));
			half _MicroWaveNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_MicroWaveNormalScale_arr, _MicroWaveNormalScale);
			half temp_output_38_0_g7 = _MicroWaveNormalScale_Instance;
			half lerpResult36_g7 = lerp( 1.0 , break31_g7.z , saturate( temp_output_38_0_g7 ));
			half3 appendResult34_g7 = (half3(( appendResult35_g7 * temp_output_38_0_g7 ) , lerpResult36_g7));
			half2 _MacroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveTiling_arr, _MacroWaveTiling);
			half2 appendResult136 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_147_0 = ( temp_output_145_0 + ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MacroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MacroWaveTiling_Instance * appendResult136 ) ) ) );
			half3 tex2DNode150 = UnpackNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_147_0 ) );
			half2 appendResult153 = (half2(tex2DNode150.r , tex2DNode150.g));
			half2 break175 = ( ( appendResult153 * appendResult168 ) + appendResult169 );
			half3 appendResult173 = (half3(break175.x , ( ase_worldNormal.y * tex2DNode150.b ) , break175.y));
			half3 worldToTangentDir179 = mul( ase_worldToTangent, appendResult173);
			half3 break31_g8 = worldToTangentDir179;
			half2 appendResult35_g8 = (half2(break31_g8.x , break31_g8.y));
			half _MacroWaveNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_MacroWaveNormalScale_arr, _MacroWaveNormalScale);
			half temp_output_38_0_g8 = _MacroWaveNormalScale_Instance;
			half lerpResult36_g8 = lerp( 1.0 , break31_g8.z , saturate( temp_output_38_0_g8 ));
			half3 appendResult34_g8 = (half3(( appendResult35_g8 * temp_output_38_0_g8 ) , lerpResult36_g8));
			half3 temp_output_116_0 = BlendNormals( lerpResult80 , BlendNormals( appendResult34_g7 , appendResult34_g8 ) );
			half clampResult44_g33 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Details_Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Details_Slope_Speed_Influence_arr, _Details_Slope_Speed_Influence);
			half2 DetailsSlopeSpeedInfluence703 = _Details_Slope_Speed_Influence_Instance;
			half2 _Detail1MainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail1MainSpeed_arr, _Detail1MainSpeed);
			half2 _Detail1Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail1Tiling_arr, _Detail1Tiling);
			half2 temp_output_66_0_g33 = _Detail1Tiling_Instance;
			half2 temp_output_53_0_g33 = ( ( ( ( ( 1.0 - clampResult44_g33 ) * DetailsSlopeSpeedInfluence703 ) + _Detail1MainSpeed_Instance ) * temp_output_66_0_g33 ) * i.uv4_texcoord4 );
			half2 break56_g33 = temp_output_53_0_g33;
			half2 appendResult57_g33 = (half2(break56_g33.y , break56_g33.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g33 = temp_output_53_0_g33;
			#else
				half2 staticSwitch59_g33 = appendResult57_g33;
			#endif
			half _Detail1FlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail1FlowUVRefreshSpeed_arr, _Detail1FlowUVRefreshSpeed);
			half Detail1FlowUVRefreshSpeed706 = _Detail1FlowUVRefreshSpeed_Instance;
			half temp_output_68_0_g33 = ( ( _Time.y + 0.0 ) * Detail1FlowUVRefreshSpeed706 );
			half temp_output_71_0_g33 = frac( ( temp_output_68_0_g33 + 0.0 ) );
			half2 temp_output_60_0_g33 = ( staticSwitch59_g33 * temp_output_71_0_g33 );
			half2 temp_output_83_0_g33 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g33 * i.uv_texcoord ) );
			half2 temp_output_672_91 = ( temp_output_60_0_g33 + temp_output_83_0_g33 );
			half _DetailNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailNormalScale_arr, _DetailNormalScale);
			half2 temp_output_80_0_g33 = ( staticSwitch59_g33 * frac( ( temp_output_68_0_g33 + -0.5 ) ) );
			half2 temp_output_672_93 = ( temp_output_83_0_g33 + temp_output_80_0_g33 );
			half clampResult90_g33 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g33 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_672_96 = clampResult90_g33;
			half3 lerpResult679 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _DetailNormal, sampler_Linear_Repeat_Aniso8, temp_output_672_91 ), _DetailNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _DetailNormal, sampler_Linear_Repeat_Aniso8, temp_output_672_93 ), _DetailNormalScale_Instance ) , temp_output_672_96);
			half4 lerpResult681 = lerp( SAMPLE_TEXTURE2D( _DetailAlbedo, sampler_Linear_Repeat_Aniso8, temp_output_672_91 ) , SAMPLE_TEXTURE2D( _DetailAlbedo, sampler_Linear_Repeat_Aniso8, temp_output_672_93 ) , temp_output_672_96);
			half clampResult44_g34 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _NoiseTiling1_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseTiling1_arr, _NoiseTiling1);
			half2 temp_output_66_0_g34 = _NoiseTiling1_Instance;
			half2 temp_output_53_0_g34 = ( ( ( ( ( 1.0 - clampResult44_g34 ) * DetailsSlopeSpeedInfluence703 ) + _Detail1MainSpeed_Instance ) * temp_output_66_0_g34 ) * i.uv4_texcoord4 );
			half2 break56_g34 = temp_output_53_0_g34;
			half2 appendResult57_g34 = (half2(break56_g34.y , break56_g34.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g34 = temp_output_53_0_g34;
			#else
				half2 staticSwitch59_g34 = appendResult57_g34;
			#endif
			half temp_output_68_0_g34 = ( ( _Time.y + 0.0 ) * Detail1FlowUVRefreshSpeed706 );
			half temp_output_71_0_g34 = frac( ( temp_output_68_0_g34 + 0.0 ) );
			half2 temp_output_60_0_g34 = ( staticSwitch59_g34 * temp_output_71_0_g34 );
			half2 temp_output_83_0_g34 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g34 * i.uv_texcoord ) );
			half2 temp_output_80_0_g34 = ( staticSwitch59_g34 * frac( ( temp_output_68_0_g34 + -0.5 ) ) );
			half clampResult90_g34 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g34 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult696 = lerp( SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g34 + temp_output_83_0_g34 ) ).g , SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g34 + temp_output_80_0_g34 ) ).g , clampResult90_g34);
			half _Detail1NoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail1NoisePower_arr, _Detail1NoisePower);
			half _Detail1NoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail1NoiseMultiply_arr, _Detail1NoiseMultiply);
			half clampResult785 = clamp( ( pow( abs( lerpResult696 ) , _Detail1NoisePower_Instance ) * _Detail1NoiseMultiply_Instance ) , 0.0 , 1.0 );
			half lerpResult787 = lerp( 0.0 , lerpResult681.a , ( lerpResult681.a * clampResult785 ));
			half3 lerpResult767 = lerp( temp_output_116_0 , lerpResult679 , lerpResult787);
			half clampResult44_g35 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Detail2MainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2MainSpeed_arr, _Detail2MainSpeed);
			half2 _Detail2Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2Tiling_arr, _Detail2Tiling);
			half2 temp_output_66_0_g35 = _Detail2Tiling_Instance;
			half2 temp_output_53_0_g35 = ( ( ( ( ( 1.0 - clampResult44_g35 ) * DetailsSlopeSpeedInfluence703 ) + _Detail2MainSpeed_Instance ) * temp_output_66_0_g35 ) * i.uv4_texcoord4 );
			half2 break56_g35 = temp_output_53_0_g35;
			half2 appendResult57_g35 = (half2(break56_g35.y , break56_g35.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g35 = temp_output_53_0_g35;
			#else
				half2 staticSwitch59_g35 = appendResult57_g35;
			#endif
			half _Detail2FlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2FlowUVRefreshSpeed_arr, _Detail2FlowUVRefreshSpeed);
			half Detail2FlowUVRefreshSpeed766 = _Detail2FlowUVRefreshSpeed_Instance;
			half temp_output_68_0_g35 = ( ( _Time.y + 0.0 ) * Detail2FlowUVRefreshSpeed766 );
			half temp_output_71_0_g35 = frac( ( temp_output_68_0_g35 + 0.0 ) );
			half2 temp_output_60_0_g35 = ( staticSwitch59_g35 * temp_output_71_0_g35 );
			half2 temp_output_83_0_g35 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g35 * i.uv_texcoord ) );
			half2 temp_output_722_91 = ( temp_output_60_0_g35 + temp_output_83_0_g35 );
			half _Detail2NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2NormalScale_arr, _Detail2NormalScale);
			half2 temp_output_80_0_g35 = ( staticSwitch59_g35 * frac( ( temp_output_68_0_g35 + -0.5 ) ) );
			half2 temp_output_722_93 = ( temp_output_83_0_g35 + temp_output_80_0_g35 );
			half clampResult90_g35 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g35 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_722_96 = clampResult90_g35;
			half3 lerpResult710 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Detail2Normal, sampler_Linear_Repeat_Aniso8, temp_output_722_91 ), _Detail2NormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Detail2Normal, sampler_Linear_Repeat_Aniso8, temp_output_722_93 ), _Detail2NormalScale_Instance ) , temp_output_722_96);
			half4 lerpResult714 = lerp( SAMPLE_TEXTURE2D( _Detail2Albedo, sampler_Linear_Repeat_Aniso8, temp_output_722_91 ) , SAMPLE_TEXTURE2D( _Detail2Albedo, sampler_Detail2Albedo, temp_output_722_93 ) , temp_output_722_96);
			half clampResult44_g36 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _NoiseTiling2_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseTiling2_arr, _NoiseTiling2);
			half2 temp_output_66_0_g36 = _NoiseTiling2_Instance;
			half2 temp_output_53_0_g36 = ( ( ( ( ( 1.0 - clampResult44_g36 ) * DetailsSlopeSpeedInfluence703 ) + _Detail2MainSpeed_Instance ) * temp_output_66_0_g36 ) * i.uv4_texcoord4 );
			half2 break56_g36 = temp_output_53_0_g36;
			half2 appendResult57_g36 = (half2(break56_g36.y , break56_g36.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g36 = temp_output_53_0_g36;
			#else
				half2 staticSwitch59_g36 = appendResult57_g36;
			#endif
			half temp_output_68_0_g36 = ( ( _Time.y + 0.0 ) * Detail2FlowUVRefreshSpeed766 );
			half temp_output_71_0_g36 = frac( ( temp_output_68_0_g36 + 0.0 ) );
			half2 temp_output_60_0_g36 = ( staticSwitch59_g36 * temp_output_71_0_g36 );
			half2 temp_output_83_0_g36 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g36 * i.uv_texcoord ) );
			half2 temp_output_80_0_g36 = ( staticSwitch59_g36 * frac( ( temp_output_68_0_g36 + -0.5 ) ) );
			half clampResult90_g36 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g36 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult721 = lerp( SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_60_0_g36 + temp_output_83_0_g36 ) ).a , SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( temp_output_83_0_g36 + temp_output_80_0_g36 ) ).a , clampResult90_g36);
			half _Detail2NoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2NoisePower_arr, _Detail2NoisePower);
			half _Detail2NoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2NoiseMultiply_arr, _Detail2NoiseMultiply);
			half clampResult819 = clamp( ( pow( abs( lerpResult721 ) , _Detail2NoisePower_Instance ) * _Detail2NoiseMultiply_Instance ) , 0.0 , 1.0 );
			half lerpResult817 = lerp( 0.0 , lerpResult714.a , ( lerpResult714.a * clampResult819 ));
			half3 lerpResult768 = lerp( lerpResult767 , lerpResult710 , lerpResult817);
			half2 _CascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeMainSpeed_arr, _CascadeMainSpeed);
			half2 temp_output_65_0_g13 = _CascadeMainSpeed_Instance;
			half4 _Vector0 = half4(-1,1,0,1);
			half2 _CascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeTiling_arr, _CascadeTiling);
			half2 temp_output_66_0_g13 = _CascadeTiling_Instance;
			half2 temp_output_53_0_g13 = ( ( ( temp_output_65_0_g13 + ( temp_output_65_0_g13 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g13 ) * i.uv4_texcoord4 );
			half2 break56_g13 = temp_output_53_0_g13;
			half2 appendResult57_g13 = (half2(break56_g13.y , break56_g13.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g13 = temp_output_53_0_g13;
			#else
				half2 staticSwitch59_g13 = appendResult57_g13;
			#endif
			half _CascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeFlowUVRefreshSpeed_arr, _CascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g13 = ( _Time.y * _CascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g13 = frac( ( temp_output_68_0_g13 + 0.0 ) );
			half2 temp_output_60_0_g13 = ( staticSwitch59_g13 * temp_output_71_0_g13 );
			half2 temp_output_83_0_g13 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g13 * i.uv_texcoord ) );
			half2 temp_output_256_91 = ( temp_output_60_0_g13 + temp_output_83_0_g13 );
			half _CascadeNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeNormalScale_arr, _CascadeNormalScale);
			half2 temp_output_80_0_g13 = ( staticSwitch59_g13 * frac( ( temp_output_68_0_g13 + -0.5 ) ) );
			half2 temp_output_256_93 = ( temp_output_83_0_g13 + temp_output_80_0_g13 );
			half clampResult90_g13 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g13 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_256_96 = clampResult90_g13;
			half3 lerpResult282 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _BigCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_256_91 ), _CascadeNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _BigCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_256_93 ), _CascadeNormalScale_Instance ) , temp_output_256_96);
			half clampResult307 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half temp_output_310_0 = ( _CascadeAngle / 45.0 );
			half clampResult318 = clamp( ( clampResult307 - ( 1.0 - temp_output_310_0 ) ) , 0.0 , 2.0 );
			half clampResult320 = clamp( ( clampResult318 * ( 1.0 / temp_output_310_0 ) ) , 0.0 , 1.0 );
			half clampResult329 = clamp( pow( abs( ( 1.0 - clampResult320 ) ) , _CascadeAngleFalloff ) , 0.0 , 1.0 );
			half CascadeAngle335 = clampResult329;
			half3 lerpResult283 = lerp( lerpResult768 , lerpResult282 , CascadeAngle335);
			half3 lerpResult465 = lerp( lerpResult283 , lerpResult679 , lerpResult681.a);
			half4 break469 = i.vertexColor;
			half3 lerpResult466 = lerp( lerpResult283 , lerpResult465 , break469.r);
			half3 lerpResult770 = lerp( lerpResult283 , lerpResult768 , lerpResult714.a);
			half3 lerpResult769 = lerp( lerpResult466 , lerpResult770 , break469.g);
			half3 lerpResult772 = lerp( temp_output_116_0 , lerpResult282 , CascadeAngle335);
			half3 lerpResult771 = lerp( lerpResult769 , lerpResult772 , break469.b);
			half _FarNormalPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalPower_arr, _FarNormalPower);
			half3 appendResult483 = (half3(_FarNormalPower_Instance , _FarNormalPower_Instance , 1.0));
			half temp_output_470_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			half _FarNormalBlendStartDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendStartDistance_arr, _FarNormalBlendStartDistance);
			half _FarNormalBlendThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendThreshold_arr, _FarNormalBlendThreshold);
			half clampResult480 = clamp( pow( abs( ( temp_output_470_0 / _FarNormalBlendStartDistance_Instance ) ) , _FarNormalBlendThreshold_Instance ) , 0.0 , 1.0 );
			half3 lerpResult481 = lerp( lerpResult771 , ( lerpResult771 * appendResult483 ) , clampResult480);
			o.Normal = lerpResult481;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half3 lerpResult891 = lerp( lerpResult283 , float3( 0,0,1 ) , break469.r);
			half3 lerpResult892 = lerp( lerpResult891 , float3( 0,0,1 ) , break469.g);
			half3 lerpResult893 = lerp( lerpResult892 , temp_output_116_0 , break469.b);
			half3 normalizeResult913 = normalize( lerpResult893 );
			half3 break42_g65 = normalizeResult913;
			half3 appendResult14_g65 = (half3(break42_g65.x , break42_g65.y , break42_g65.z));
			half _Distortion_Instance = UNITY_ACCESS_INSTANCED_PROP(_Distortion_arr, _Distortion);
			half temp_output_45_0_g65 = _Distortion_Instance;
			half3 temp_output_38_0_g65 = ( appendResult14_g65 * temp_output_45_0_g65 );
			half2 appendResult20_g65 = (half2(_ScreenParams.x , _ScreenParams.y));
			half2 temp_output_23_0_g65 = ( half2( 1,1 ) / appendResult20_g65 );
			half eyeDepth18_g65 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( ( floor( ( ( ase_screenPosNorm + half4( temp_output_38_0_g65 , 0.0 ) ) * half4( appendResult20_g65, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g65 ), 0.0 , 0.0 ) ).xy ));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_viewPos = UnityObjectToViewPos( ase_vertex4Pos );
			float ase_screenDepth = -ase_viewPos.z;
			half temp_output_16_0_g65 = ( eyeDepth18_g65 - ase_screenDepth );
			half4 temp_output_35_0_g65 = ( ( floor( ( ase_screenPosNorm * half4( appendResult20_g65, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g65 ), 0.0 , 0.0 ) );
			half4 temp_output_22_0_g65 = ( temp_output_35_0_g65 + half4( ( saturate( temp_output_16_0_g65 ) * ( temp_output_38_0_g65 / ase_screenPos.w ) ) , 0.0 ) );
			half4 ifLocalVar30_g65 = 0;
			if( temp_output_16_0_g65 >= 0.0 )
				ifLocalVar30_g65 = temp_output_22_0_g65;
			else
				ifLocalVar30_g65 = temp_output_35_0_g65;
			half4 temp_output_911_0 = ifLocalVar30_g65;
			half4 screenColor352 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_911_0.xy);
			half _Clean_Water_Background_Brightness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clean_Water_Background_Brightness_arr, _Clean_Water_Background_Brightness);
			half4 temp_output_415_0 = ( screenColor352 * _Clean_Water_Background_Brightness_Instance );
			half _Caustic_Intensivity_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Intensivity_arr, _Caustic_Intensivity);
			half4 _Caustic_Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Color_arr, _Caustic_Color);
			half _Caustic_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Falloff_arr, _Caustic_Falloff);
			half temp_output_44_0_g37 = _Caustic_Falloff_Instance;
			half3 appendResult34_g37 = (half3(temp_output_44_0_g37 , temp_output_44_0_g37 , temp_output_44_0_g37));
			half _Caustic_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Tiling_arr, _Caustic_Tiling);
			half temp_output_42_0_g37 = _Caustic_Tiling_Instance;
			half2 temp_cast_10 = (temp_output_42_0_g37).xx;
			half _Caustic_Triplanar_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Triplanar_Hardness_arr, _Caustic_Triplanar_Hardness);
			half temp_output_43_0_g37 = _Caustic_Triplanar_Hardness_Instance;
			half _Caustic_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Speed_arr, _Caustic_Speed);
			half temp_output_14_0_g37 = ( _Caustic_Speed_Instance * _Time.y );
			half3 appendResult16_g37 = (half3(temp_output_14_0_g37 , temp_output_14_0_g37 , temp_output_14_0_g37));
			half4 temp_output_38_0_g37 = temp_output_911_0;
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
			float4 triplanar25_g37 = TriplanarSampling25_g37( _Caustic, sampler_Caustic, ( half4( ( appendResult16_g37 * float3( 0.76,0.73,0.79 ) ) , 0.0 ) + temp_output_48_0_g37 ).xyz, ase_worldNormal, temp_output_43_0_g37, temp_cast_10, 1.0, 0 );
			half3 appendResult35_g37 = (half3(triplanar25_g37.xyz));
			half2 temp_cast_15 = (temp_output_42_0_g37).xx;
			half temp_output_17_0_g37 = ( temp_output_14_0_g37 * -1.07 );
			half3 appendResult21_g37 = (half3(temp_output_17_0_g37 , temp_output_17_0_g37 , temp_output_17_0_g37));
			float4 triplanar26_g37 = TriplanarSampling26_g37( _Caustic, sampler_Caustic, ( half4( appendResult21_g37 , 0.0 ) + temp_output_48_0_g37 ).xyz, ase_worldNormal, temp_output_43_0_g37, temp_cast_15, 1.0, 0 );
			half3 appendResult36_g37 = (half3(triplanar26_g37.xyz));
			half3 clampResult37_g37 = clamp( ( appendResult34_g37 * min( appendResult35_g37 , appendResult36_g37 ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			half4 temp_cast_20 = (_Caustic_Intensivity_Instance).xxxx;
			half _Caustic_Blend_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Blend_arr, _Caustic_Blend);
			half4 lerpResult425 = lerp( temp_output_415_0 , ( ( temp_output_415_0 / _Caustic_Intensivity_Instance ) + ( pow( abs( ( _Caustic_Color_Instance * half4( clampResult37_g37 , 0.0 ) ) ) , temp_cast_20 ) * _Caustic_Intensivity_Instance ) ) , _Caustic_Blend_Instance);
			#ifdef _USE_CAUSTIC
				half4 staticSwitch666 = lerpResult425;
			#else
				half4 staticSwitch666 = temp_output_415_0;
			#endif
			half4 _DeepColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_DeepColor_arr, _DeepColor);
			half4 _ShalowColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowColor_arr, _ShalowColor);
			half3 temp_output_41_0_g66 = temp_output_911_0.xyz;
			half clampDepth36_g66 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, half4( temp_output_41_0_g66 , 0.0 ).xy );
			half temp_output_16_0_g66 = ( _ProjectionParams.x < 0.0 ? clampDepth36_g66 : ( 1.0 - clampDepth36_g66 ) );
			half temp_output_31_0_g66 = saturate( ( (_ProjectionParams.z + (temp_output_16_0_g66 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - ase_screenDepth ) );
			half eyeDepth39_g66 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, half4( temp_output_41_0_g66 , 0.0 ).xy ));
			half ifLocalVar40_g66 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar40_g66 = temp_output_31_0_g66;
			else
				ifLocalVar40_g66 = ( eyeDepth39_g66 - ase_screenDepth );
			half temp_output_912_0 = ifLocalVar40_g66;
			half _ShalowFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffMultiply_arr, _ShalowFalloffMultiply);
			half _ShalowFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffPower_arr, _ShalowFalloffPower);
			half _BigCascadeTransparency_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeTransparency_arr, _BigCascadeTransparency);
			half lerpResult21 = lerp( pow( abs( ( temp_output_912_0 * _ShalowFalloffMultiply_Instance ) ) , ( _ShalowFalloffPower_Instance * -1.0 ) ) , 100.0 , ( _BigCascadeTransparency_Instance * (0) ));
			half clampResult16 = clamp( saturate( lerpResult21 ) , 0.0 , 1.0 );
			half4 lerpResult23 = lerp( _DeepColor_Instance , _ShalowColor_Instance , clampResult16);
			half4 tex2DNode184 = SAMPLE_TEXTURE2D( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0 );
			half _WaterTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterTranslucencyMultiply_arr, _WaterTranslucencyMultiply);
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ).r , SAMPLE_TEXTURE2D( _WaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93 ).r , temp_output_69_96);
			half lerpResult261 = lerp( SAMPLE_TEXTURE2D( _CascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_91 ).r , SAMPLE_TEXTURE2D( _CascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_93 ).r , temp_output_256_96);
			half _CascadeTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_CascadeTranslucencyMultiply_arr, _CascadeTranslucencyMultiply);
			half lerpResult497 = lerp( ( ( tex2DNode184.r * _WaterTranslucencyMultiply_Instance ) + ( lerpResult81 * _WaterTranslucencyMultiply_Instance ) ) , ( ( lerpResult261 * CascadeAngle335 ) * _CascadeTranslucencyMultiply_Instance ) , CascadeAngle335);
			half _WaveTranslucencyHardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyHardness_arr, _WaveTranslucencyHardness);
			half _WaveTranslucencyPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyPower_arr, _WaveTranslucencyPower);
			half _WaveTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyMultiply_arr, _WaveTranslucencyMultiply);
			half _WaveTranslucencyFallOffDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyFallOffDistance_arr, _WaveTranslucencyFallOffDistance);
			half lerpResult508 = lerp( ( pow( abs( ( lerpResult497 * _WaveTranslucencyHardness_Instance ) ) , _WaveTranslucencyPower_Instance ) * _WaveTranslucencyMultiply_Instance ) , 0.0 , ( temp_output_470_0 / _WaveTranslucencyFallOffDistance_Instance ));
			half _Shore_Translucency_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shore_Translucency_Multiply_arr, _Shore_Translucency_Multiply);
			half clampResult515 = clamp( ( _Shore_Translucency_Multiply_Instance * temp_output_912_0 ) , 0.0 , 1.0 );
			half _Shore_Translucency_Power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shore_Translucency_Power_arr, _Shore_Translucency_Power);
			half clampResult514 = clamp( pow( abs( clampResult515 ) , _Shore_Translucency_Power_Instance ) , 0.0 , 1.0 );
			half clampResult520 = clamp( ( lerpResult508 + ( 1.0 - clampResult514 ) ) , 0.0 , 1.0 );
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
			half clampResult43 = clamp( ( temp_output_912_0 * _WaterAlphaMultiply_Instance ) , 0.0 , 1.0 );
			half _WaterAlphaPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterAlphaPower_arr, _WaterAlphaPower);
			half clampResult42 = clamp( pow( abs( clampResult43 ) , _WaterAlphaPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult28 = lerp( ( lerpResult26 * staticSwitch666 ) , lerpResult26 , clampResult42);
			half _CleanFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffMultiply_arr, _CleanFalloffMultiply);
			half clampResult35 = clamp( ( temp_output_912_0 * _CleanFalloffMultiply_Instance ) , 0.0 , 1.0 );
			half _CleanFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffPower_arr, _CleanFalloffPower);
			half clampResult34 = clamp( pow( abs( clampResult35 ) , _CleanFalloffPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult30 = lerp( staticSwitch666 , lerpResult28 , clampResult34);
			half3 _DetailAlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailAlbedoColor_arr, _DetailAlbedoColor);
			half4 temp_output_775_0 = ( lerpResult681 * half4( _DetailAlbedoColor_Instance , 0.0 ) );
			half4 lerpResult791 = lerp( lerpResult30 , temp_output_775_0 , lerpResult787);
			half3 _Detail2AlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail2AlbedoColor_arr, _Detail2AlbedoColor);
			half4 temp_output_809_0 = ( lerpResult714 * half4( _Detail2AlbedoColor_Instance , 0.0 ) );
			half4 lerpResult807 = lerp( lerpResult791 , temp_output_809_0 , lerpResult817);
			half4 lerpResult889 = lerp( lerpResult807 , lerpResult30 , CascadeAngle335);
			half4 lerpResult899 = lerp( lerpResult30 , temp_output_775_0 , lerpResult681.a);
			half4 lerpResult896 = lerp( lerpResult889 , lerpResult899 , break469.r);
			half4 lerpResult897 = lerp( lerpResult30 , temp_output_809_0 , lerpResult714.a);
			half4 lerpResult898 = lerp( lerpResult896 , lerpResult897 , break469.g);
			half4 lerpResult900 = lerp( lerpResult898 , lerpResult30 , break469.b);
			half clampDepth53_g66 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy );
			half temp_output_52_0_g66 = ( _ProjectionParams.x < 0.0 ? clampDepth53_g66 : ( 1.0 - clampDepth53_g66 ) );
			half temp_output_49_0_g66 = saturate( ( (_ProjectionParams.z + (temp_output_52_0_g66 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - ase_screenDepth ) );
			half eyeDepth44_g66 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half ifLocalVar46_g66 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar46_g66 = temp_output_49_0_g66;
			else
				ifLocalVar46_g66 = ( eyeDepth44_g66 - ase_screenDepth );
			half _EdgeFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_EdgeFalloffMultiply_arr, _EdgeFalloffMultiply);
			half clampResult4 = clamp( ( ifLocalVar46_g66 * _EdgeFalloffMultiply_Instance ) , 0.0 , 1.0 );
			half _EdgeFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_EdgeFalloffPower_arr, _EdgeFalloffPower);
			half clampResult8 = clamp( pow( abs( clampResult4 ) , _EdgeFalloffPower_Instance ) , 0.0 , 1.0 );
			half temp_output_660_0 = ( clampResult8 * break469.a );
			half BackfaceAlpha_Instance = UNITY_ACCESS_INSTANCED_PROP(BackfaceAlpha_arr, BackfaceAlpha);
			half switchResult661 = (((i.ASEIsFrontFacing>0)?(temp_output_660_0):(( temp_output_660_0 * BackfaceAlpha_Instance ))));
			half clampResult917 = clamp( switchResult661 , 0.0 , 1.0 );
			#ifdef DIRECTIONAL_COOKIE
				half staticSwitch915 = clampResult917;
			#else
				half staticSwitch915 = 1.0;
			#endif
			o.Albedo = ( lerpResult900 * staticSwitch915 ).rgb;
			half _Water_Specular_Far_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Far_arr, _Water_Specular_Far);
			half _Water_Specular_Close_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Close_arr, _Water_Specular_Close);
			half _WaterSpecularThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterSpecularThreshold_arr, _WaterSpecularThreshold);
			half clampResult621 = clamp( pow( abs( clampResult16 ) , _WaterSpecularThreshold_Instance ) , 0.0 , 1.0 );
			half lerpResult616 = lerp( _Water_Specular_Far_Instance , _Water_Specular_Close_Instance , clampResult621);
			half4 temp_cast_29 = (lerpResult616).xxxx;
			half _Detail_1_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_1_Specular_arr, _Detail_1_Specular);
			half4 temp_output_788_0 = ( temp_output_775_0 * _Detail_1_Specular_Instance );
			half4 lerpResult792 = lerp( temp_cast_29 , temp_output_788_0 , lerpResult787);
			half _Detail_2_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_2_Specular_arr, _Detail_2_Specular);
			half4 temp_output_822_0 = ( temp_output_809_0 * _Detail_2_Specular_Instance );
			half4 lerpResult805 = lerp( lerpResult792 , temp_output_822_0 , lerpResult817);
			half4 temp_cast_32 = (lerpResult616).xxxx;
			half4 lerpResult890 = lerp( lerpResult805 , temp_cast_32 , CascadeAngle335);
			half4 lerpResult907 = lerp( lerpResult890 , temp_output_788_0 , break469.r);
			half4 lerpResult906 = lerp( lerpResult907 , temp_output_822_0 , break469.g);
			half4 temp_cast_35 = (lerpResult616).xxxx;
			half4 lerpResult905 = lerp( lerpResult906 , temp_cast_35 , break469.b);
			o.Specular = ( lerpResult905 * staticSwitch915 ).rgb;
			half _NMWaterSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_NMWaterSmoothness_arr, _NMWaterSmoothness);
			half _AOPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AOPower_arr, _AOPower);
			half2 appendResult793 = (half2(_NMWaterSmoothness_Instance , _AOPower_Instance));
			half4 tex2DNode691 = SAMPLE_TEXTURE2D( _Detail_1_AO_G_T_B_SM_A, sampler_Linear_Repeat_Aniso8, temp_output_672_91 );
			half2 appendResult795 = (half2(tex2DNode691.g , tex2DNode691.a));
			half4 tex2DNode690 = SAMPLE_TEXTURE2D( _Detail_1_AO_G_T_B_SM_A, sampler_Linear_Repeat_Aniso8, temp_output_672_93 );
			half2 appendResult796 = (half2(tex2DNode690.g , tex2DNode690.a));
			half2 lerpResult689 = lerp( appendResult795 , appendResult796 , temp_output_672_96);
			half _Detail_1_AO_Remap_Min_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_1_AO_Remap_Min_arr, _Detail_1_AO_Remap_Min);
			half _Detail_1_Smoothness_Remap_Min_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_1_Smoothness_Remap_Min_arr, _Detail_1_Smoothness_Remap_Min);
			half2 appendResult797 = (half2(_Detail_1_AO_Remap_Min_Instance , _Detail_1_Smoothness_Remap_Min_Instance));
			half _Detail_1_AO_Remap_Max_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_1_AO_Remap_Max_arr, _Detail_1_AO_Remap_Max);
			half _Detail_1_Smoothness_Remap_Max_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_1_Smoothness_Remap_Max_arr, _Detail_1_Smoothness_Remap_Max);
			half2 appendResult803 = (half2(_Detail_1_AO_Remap_Max_Instance , _Detail_1_Smoothness_Remap_Max_Instance));
			half2 temp_output_794_0 = (appendResult797 + (lerpResult689 - float2( 0,0 )) * (appendResult803 - appendResult797) / (float2( 1,1 ) - float2( 0,0 )));
			half2 lerpResult790 = lerp( appendResult793 , temp_output_794_0 , lerpResult787);
			half4 tex2DNode728 = SAMPLE_TEXTURE2D( _Detail_2_AO_G_T_B_SM_A, sampler_Linear_Repeat_Aniso8, temp_output_722_91 );
			half2 appendResult821 = (half2(tex2DNode728.g , tex2DNode728.a));
			half4 tex2DNode719 = SAMPLE_TEXTURE2D( _Detail_2_AO_G_T_B_SM_A, sampler_Linear_Repeat_Aniso8, temp_output_722_93 );
			half2 appendResult820 = (half2(tex2DNode719.g , tex2DNode719.a));
			half2 lerpResult720 = lerp( appendResult821 , appendResult820 , temp_output_722_96);
			half _Detail_2_AO_Remap_Min_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_2_AO_Remap_Min_arr, _Detail_2_AO_Remap_Min);
			half _Detail_2_Smoothness_Remap_Min_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_2_Smoothness_Remap_Min_arr, _Detail_2_Smoothness_Remap_Min);
			half2 appendResult825 = (half2(_Detail_2_AO_Remap_Min_Instance , _Detail_2_Smoothness_Remap_Min_Instance));
			half _Detail_2_AO_Remap_Max_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_2_AO_Remap_Max_arr, _Detail_2_AO_Remap_Max);
			half _Detail_2_Smoothness_Remap_Max_Instance = UNITY_ACCESS_INSTANCED_PROP(_Detail_2_Smoothness_Remap_Max_arr, _Detail_2_Smoothness_Remap_Max);
			half2 appendResult826 = (half2(_Detail_2_AO_Remap_Max_Instance , _Detail_2_Smoothness_Remap_Max_Instance));
			half2 temp_output_831_0 = (appendResult825 + (lerpResult720 - float2( 0,0 )) * (appendResult826 - appendResult825) / (float2( 1,1 ) - float2( 0,0 )));
			half2 lerpResult806 = lerp( lerpResult790 , temp_output_831_0 , lerpResult817);
			half2 lerpResult888 = lerp( lerpResult806 , appendResult793 , CascadeAngle335);
			half2 lerpResult904 = lerp( lerpResult888 , temp_output_794_0 , break469.r);
			half2 lerpResult903 = lerp( lerpResult904 , temp_output_831_0 , break469.g);
			half2 lerpResult902 = lerp( lerpResult903 , appendResult793 , break469.b);
			half2 break908 = lerpResult902;
			o.Smoothness = break908;
			o.Occlusion = ( break908.y * staticSwitch915 );
			o.Alpha = clampResult917;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv4_texcoord4;
				o.customPack1.xy = v.texcoord3;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv4_texcoord4 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}