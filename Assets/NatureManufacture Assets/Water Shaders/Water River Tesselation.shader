Shader "NatureManufacture/Water/River Tesselation"
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
		_Big_Cascade_Slope_Speed_Influence("Big Cascade Slope Speed Influence", Vector) = (0.3,0.3,0,0)
		_MainWaterSpeed("Main Water Speed", Vector) = (0.3,0.3,0,0)
		_WaterFlowUVRefresSpeed("Water Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_SlowWaterMixSpeed("Wind Water Mix Speed", Vector) = (0,0,0,0)
		_SmallCascadeMainSpeed("Small Cascade Main Speed", Vector) = (1,1,0,0)
		_SmallCascadeFlowUVRefreshSpeed("Small Cascade Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_BigCascadeMainSpeed("Big Cascade Main Speed", Vector) = (1,1,0,0)
		_BigCascadeFlowUVRefreshSpeed("Big Cascade Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_EdgeFalloffMultiply("Alpha Edge Falloff Multiply", Float) = 5.19
		_EdgeFalloffPower("Alpha Edge Falloff Power", Float) = 0.74
		_WaterAlphaMultiply("Alpha Global Multiply", Float) = 0.66
		_WaterAlphaPower("Alpha Global Power", Float) = 1.39
		BackfaceAlpha("Backface Alpha", Range( 0 , 1)) = 1
		_Clean_Water_Background_Brightness("Clean Water Background Brightness", Float) = 0.9
		_CleanFalloffMultiply("Clean Falloff Multiply", Float) = 1.29
		_CleanFalloffPower("Clean Falloff Power", Float) = 0.38
		_ShalowColor("Shalow Color", Color) = (0.4031684,0.5485649,0.5660378,0)
		_ShalowFalloffMultiply("Shalow Falloff Multiply", Float) = 1.043
		_ShalowFalloffPower("Shalow Falloff Power", Float) = 3.9
		_DeepColor("Deep Color", Color) = (0.05660379,0.05660379,0.05660379,0)
		_BigCascadeTransparency("Big Cascade Transparency", Range( 0 , 1)) = 3.9
		_Distortion("Distortion", Range( 0 , 1)) = 0.03
		[NoScaleOffset]_SlowWaterNormal("Water Normal", 2D) = "bump" {}
		_SlowWaterTiling("Water Tiling", Vector) = (0,0,0,0)
		_SlowNormalScale("Water Normal Scale", Float) = 0
		WindMicroWaveTiling("Wind Micro Wave Tiling", Vector) = (0,0,0,0)
		_MicroWaveNormalScale("Wind Micro Wave Normal Scale", Range( 0 , 2)) = 0
		_MacroWaveTiling("Wind Macro Wave Tiling", Vector) = (0,0,0,0)
		_MacroWaveNormalScale("Wind Macro Wave Normal Scale", Range( 0 , 2)) = 0
		_FarNormalPower("Far Normal Power", Range( 0 , 1)) = 0.5
		_FarNormalBlendStartDistance("Far Normal Blend Start Distance", Float) = 0
		_FarNormalBlendThreshold("Far Normal Blend Threshold", Float) = 10
		_NMWaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_NMFoamSmoothness("Side Foam Smoothness", Range( 0 , 1)) = 0
		_SmallCascadeSmoothness("Small Cascade Smoothness", Range( 0 , 1)) = 0
		_BigCascadeSmoothness("Big Cascade Smoothness", Range( 0 , 1)) = 0
		_AOPower("Water Ambient Occlusion", Float) = 1
		_Water_Specular_Close("Water Specular Close", Range( 0 , 1)) = 0
		_Water_Specular_Far("Water Specular Far", Range( 0 , 1)) = 0
		_WaterSpecularThreshold("Water Specular Threshold", Range( 0 , 10)) = 0
		_Side_Foam_Specular("Side Foam Specular", Range( 0 , 1)) = 0
		_Small_Cascade_Foam_Specular("Small Cascade Foam Specular", Range( 0 , 1)) = 0
		_Big_Cascade_Foam_Specular("Big Cascade Foam Specular", Range( 0 , 1)) = 0
		[NoScaleOffset]_Noise("Cascade Noise", 2D) = "white" {}
		_SmallCascadeAngle("Small Cascade Angle", Range( 0.001 , 90)) = 4
		_SmallCascadeAngleFalloff("Small Cascade Angle Falloff", Range( 0 , 80)) = 0.7
		[NoScaleOffset]_SmallCascadeNormal("Small Cascade Normal", 2D) = "bump" {}
		_SmallCascadeNormalScale("Small Cascade Normal Scale", Float) = 0.5
		_SmallCascadeTiling("Small Cascade Normal Tiling", Vector) = (2,2,0,0)
		[NoScaleOffset]_SmallCascade("Small Cascade Foam", 2D) = "white" {}
		_Small_Cascade_Foam_Tiling("Small Cascade Foam Tiling", Vector) = (2,2,0,0)
		_SmallCascadeColor("Small Cascade Foam Color", Vector) = (0,0,0,0)
		_SmallCascadeFoamFalloff("Small Cascade Foam Falloff", Range( 0 , 10)) = 0.01
		_Small_Cascade_Foam_Height_Mask("Small Cascade Foam Height Mask", Range( 0.01 , 10)) = 0.01
		[NoScaleOffset]_Small_Cascade_Foam_Normal("Small Cascade Foam Normal", 2D) = "bump" {}
		_Small_Cascade_Foam_Normal_Scale("Small Cascade Foam Normal Scale", Float) = 0.5
		_NoiseTiling("Small Cascade Noise Tiling", Vector) = (2,2,0,0)
		_NoiseSpeed("Small Cascade Noise Speed", Vector) = (1,1,0,0)
		_Small_Cascade_Noise_Flow_UV_Refresh_Speed("Small Cascade Noise Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_SmallCascadeNoisePower("Small Cascade Noise Power", Float) = 0
		_SmallCascadeNoiseMultiply("Small Cascade Noise Multiply", Range( 0 , 40)) = 28.7
		_BigCascadeAngle("Big Cascade Angle", Range( 0.001 , 90)) = 9.8
		_BigCascadeAngleFalloff("Big Cascade Angle Falloff", Range( 0 , 80)) = 1.5
		_BigCascadeTiling("Big Cascade Tiling", Vector) = (2,2,0,0)
		[NoScaleOffset]_BigCascadeNormal("Big Cascade Normal", 2D) = "bump" {}
		_BigCascadeNormalScale("Big Cascade Normal Scale", Float) = 0.5
		[NoScaleOffset]_BigCascade("Big Cascade Foam", 2D) = "white" {}
		_Big_Foam_Cascade_Tiling("Big Foam Cascade Tiling", Vector) = (20,20,0,0)
		_BigCascadeColor("Big Cascade Foam Color", Vector) = (0,0,0,0)
		Big_Cascade_Foam_Falloff("Big Cascade Foam Falloff", Range( 0 , 10)) = 0.01
		_Big_Cascade_Foam_Height_Mask("Big Cascade Foam Height Mask", Range( 1.5 , 10)) = 1.5
		[NoScaleOffset]_Big_Cascade_Foam_Normal("Big Cascade Foam Normal", 2D) = "bump" {}
		_Big_Cascade_Foam_Normal_Scale("Big Cascade Foam Normal Scale", Float) = 0.5
		_Big_Cascade_Noise_Tiling("Big Cascade Noise Tiling", Vector) = (2,2,0,0)
		_Big_Cascade_Noise_Speed("Big Cascade Noise Speed", Vector) = (1,1,0,0)
		_Big_Cascade_Noise_Flow_UV_Refresh_Speed("Big Cascade Noise Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		_BigCascadeNoisePower("Big Cascade Noise Power", Float) = 0
		_BigCascadeNoiseMultiply("Big Cascade Noise Multiply", Range( 0 , 40)) = 28.7
		_FoamDepth("Side Foam Depth", Range( 0 , 10)) = 5.19
		_FoamFalloff("Side Foam Falloff", Float) = 0.74
		_FoamWaveHardness("Side Foam Wave Hardness", Range( 0 , 10)) = 0
		_FoamWavePower("Side Foam Wave Power", Range( 0 , 10)) = 0
		_FoamWaveMultiply("Side Foam Wave Multiply", Range( 0 , 10)) = 0
		_FoamColor("Side Foam Color", Vector) = (0,0,0,0)
		[NoScaleOffset]_Foam("Side Foam", 2D) = "white" {}
		_Side_Foam_Tiling("Side Foam Tiling", Vector) = (8,8,0,0)
		_FoamSpeed("Side Foam Speed", Vector) = (0.3,0.3,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		_Side_Foam_Flow_UV_Refresh_Speed("Side Foam Flow UV Refresh Speed", Range( 0 , 1)) = 0.15
		[NoScaleOffset]_Side_Foam_Normal("Side Foam Normal", 2D) = "bump" {}
		_Side_Foam_Normal_Scale("Side Foam Normal Scale", Float) = 0
		[NoScaleOffset]_SlowWaterTesselation("Water Tess", 2D) = "white" {}
		_SlowWaterTessScale("Water Tess Scale", Float) = 0
		MacroWaveTessScale("Wind Macro Wave Tess Scale", Float) = 0
		[NoScaleOffset]_SmallCascadeWaterTess("Small Cascade Water Tess", 2D) = "white" {}
		_SmallCascadeWaterTessScale("Small Cascade Water Tess Scale", Float) = 0
		[NoScaleOffset]BigCascadeWaterTess("Big Cascade Water Tess", 2D) = "white" {}
		_BigCascadeWaterTessScale("Big Cascade Water Tess Scale", Float) = 0
		_Translucency_Global_Power("Translucency Global Power", Range( 0 , 100)) = 10
		_Translucency_Direct_Sun_Power("Translucency Direct Sun Power", Range( 0 , 100)) = 10
		_WaveTranslucencyFallOffDistance("Wave Translucency FallOff Distance", Float) = 0
		_WaveTranslucencyPower("Wave Translucency Power", Range( 0 , 10)) = 0
		_WaveTranslucencyHardness("Wave Translucency Hardness", Float) = 0
		_WaveTranslucencyMultiply("Wave Translucency Multiply", Range( 0 , 10)) = 0
		_SlowWaterTranslucencyMultiply("Slow Water Translucency Multiply", Range( 0 , 10)) = 0
		_SmallCascadeTranslucencyMultiply("Small Cascade Translucency Multiply", Range( 0 , 10)) = 0
		_BigCascadeTranslucencyMultiply("Big Cascade Translucency Multiply", Range( 0 , 10)) = 0
		_Shore_Translucency_Multiply("Shore Translucency Multiply", Range( 0.01 , 100)) = 0.66
		_Shore_Translucency_Power("Shore Translucency Power", Range( 0.01 , 100)) = 1.39
		[Toggle(_USE_CAUSTIC)] _Use_Caustic("Use_Caustic", Float) = 0
		_Caustic_Triplanar_Hardness("Caustic Triplanar Hardness", Float) = 3
		[NoScaleOffset]_Caustic("Caustic", 2D) = "white" {}
		[HDR]_Caustic_Color("Caustic Color", Color) = (1,1,1,0)
		_Caustic_Tiling("Caustic Tiling", Float) = 0.05
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
		struct Input
		{
			float3 worldPos;
			half3 worldNormal;
			INTERNAL_DATA
			float2 uv4_texcoord4;
			float2 uv_texcoord;
			float4 screenPos;
			float4 vertexColor : COLOR;
			half ASEIsFrontFacing : VFACE;
		};

		uniform int _CullModeOff0Front1Back2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SlowWaterTesselation);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SlowWaterNormal);
		SamplerState sampler_Linear_Repeat_Aniso8;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SmallCascadeWaterTess);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Noise);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Side_Foam_Normal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Foam);
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _BigCascadeAngle;
		uniform half _BigCascadeAngleFalloff;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SmallCascadeNormal);
		uniform half _SmallCascadeAngle;
		uniform half _SmallCascadeAngleFalloff;
		UNITY_DECLARE_TEX2D_NOSAMPLER(BigCascadeWaterTess);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Small_Cascade_Foam_Normal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BigCascadeNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Big_Cascade_Foam_Normal);
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Caustic);
		SamplerState sampler_Caustic;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SmallCascade);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BigCascade);
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		UNITY_INSTANCING_BUFFER_START(Graph_NM_River_SS_Tesselation)
			UNITY_DEFINE_INSTANCED_PROP(half4, _DeepColor)
#define _DeepColor_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _Caustic_Color)
#define _Caustic_Color_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half4, _ShalowColor)
#define _ShalowColor_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _FoamColor)
#define _FoamColor_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _SmallCascadeColor)
#define _SmallCascadeColor_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half3, _BigCascadeColor)
#define _BigCascadeColor_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Slope_Speed_Influence)
#define _Slope_Speed_Influence_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _BigCascadeTiling)
#define _BigCascadeTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _BigCascadeMainSpeed)
#define _BigCascadeMainSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Small_Cascade_Foam_Tiling)
#define _Small_Cascade_Foam_Tiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, WindMicroWaveTiling)
#define WindMicroWaveTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Big_Cascade_Slope_Speed_Influence)
#define _Big_Cascade_Slope_Speed_Influence_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Big_Foam_Cascade_Tiling)
#define _Big_Foam_Cascade_Tiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Big_Cascade_Noise_Speed)
#define _Big_Cascade_Noise_Speed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Side_Foam_Tiling)
#define _Side_Foam_Tiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _FoamSpeed)
#define _FoamSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _Big_Cascade_Noise_Tiling)
#define _Big_Cascade_Noise_Tiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _NoiseTiling)
#define _NoiseTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _NoiseSpeed)
#define _NoiseSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MainWaterSpeed)
#define _MainWaterSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterTiling)
#define _SlowWaterTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SmallCascadeTiling)
#define _SmallCascadeTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SmallCascadeMainSpeed)
#define _SmallCascadeMainSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _SlowWaterMixSpeed)
#define _SlowWaterMixSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half2, _MacroWaveTiling)
#define _MacroWaveTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Global_Power)
#define _Translucency_Global_Power_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Power)
#define _Shore_Translucency_Power_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Shore_Translucency_Multiply)
#define _Shore_Translucency_Multiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyFallOffDistance)
#define _WaveTranslucencyFallOffDistance_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffMultiply)
#define _ShalowFalloffMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyMultiply)
#define _WaveTranslucencyMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _ShalowFalloffPower)
#define _ShalowFalloffPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyPower)
#define _WaveTranslucencyPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeTransparency)
#define _BigCascadeTransparency_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaveTranslucencyHardness)
#define _WaveTranslucencyHardness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeTranslucencyMultiply)
#define _BigCascadeTranslucencyMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowWaterTranslucencyMultiply)
#define _SlowWaterTranslucencyMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeTranslucencyMultiply)
#define _SmallCascadeTranslucencyMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffPower)
#define _CleanFalloffPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaMultiply)
#define _WaterAlphaMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeSmoothness)
#define _SmallCascadeSmoothness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _NMFoamSmoothness)
#define _NMFoamSmoothness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _NMWaterSmoothness)
#define _NMWaterSmoothness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Cascade_Foam_Specular)
#define _Big_Cascade_Foam_Specular_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Cascade_Foam_Specular)
#define _Small_Cascade_Foam_Specular_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Specular)
#define _Side_Foam_Specular_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterSpecularThreshold)
#define _WaterSpecularThreshold_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Close)
#define _Water_Specular_Close_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Water_Specular_Far)
#define _Water_Specular_Far_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, BackfaceAlpha)
#define BackfaceAlpha_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffPower)
#define _EdgeFalloffPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _EdgeFalloffMultiply)
#define _EdgeFalloffMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, Big_Cascade_Foam_Falloff)
#define Big_Cascade_Foam_Falloff_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeFoamFalloff)
#define _SmallCascadeFoamFalloff_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Blend)
#define _Caustic_Blend_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _CleanFalloffMultiply)
#define _CleanFalloffMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterAlphaPower)
#define _WaterAlphaPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Translucency_Direct_Sun_Power)
#define _Translucency_Direct_Sun_Power_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Speed)
#define _Caustic_Speed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalPower)
#define _FarNormalPower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Tiling)
#define _Caustic_Tiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MacroWaveNormalScale)
#define _MacroWaveNormalScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _MicroWaveNormalScale)
#define _MicroWaveNormalScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FoamWaveMultiply)
#define _FoamWaveMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FoamWavePower)
#define _FoamWavePower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FoamWaveHardness)
#define _FoamWaveHardness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FoamFalloff)
#define _FoamFalloff_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FoamDepth)
#define _FoamDepth_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeNormalScale)
#define _SmallCascadeNormalScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Normal_Scale)
#define _Side_Foam_Normal_Scale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Cascade_Noise_Flow_UV_Refresh_Speed)
#define _Small_Cascade_Noise_Flow_UV_Refresh_Speed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeFlowUVRefreshSpeed)
#define _SmallCascadeFlowUVRefreshSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowWaterTessScale)
#define _SlowWaterTessScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, MacroWaveTessScale)
#define MacroWaveTessScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SlowNormalScale)
#define _SlowNormalScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _GlobalTiling)
#define _GlobalTiling_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _WaterFlowUVRefresSpeed)
#define _WaterFlowUVRefresSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Side_Foam_Flow_UV_Refresh_Speed)
#define _Side_Foam_Flow_UV_Refresh_Speed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeNoisePower)
#define _SmallCascadeNoisePower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeNoiseMultiply)
#define _SmallCascadeNoiseMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _SmallCascadeWaterTessScale)
#define _SmallCascadeWaterTessScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Falloff)
#define _Caustic_Falloff_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Intensivity)
#define _Caustic_Intensivity_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Clean_Water_Background_Brightness)
#define _Clean_Water_Background_Brightness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Distortion)
#define _Distortion_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendThreshold)
#define _FarNormalBlendThreshold_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _FarNormalBlendStartDistance)
#define _FarNormalBlendStartDistance_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeSmoothness)
#define _BigCascadeSmoothness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Cascade_Foam_Height_Mask)
#define _Big_Cascade_Foam_Height_Mask_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Cascade_Foam_Normal_Scale)
#define _Big_Cascade_Foam_Normal_Scale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeNormalScale)
#define _BigCascadeNormalScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Cascade_Foam_Height_Mask)
#define _Small_Cascade_Foam_Height_Mask_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Small_Cascade_Foam_Normal_Scale)
#define _Small_Cascade_Foam_Normal_Scale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeNoiseMultiply)
#define _BigCascadeNoiseMultiply_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeNoisePower)
#define _BigCascadeNoisePower_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Big_Cascade_Noise_Flow_UV_Refresh_Speed)
#define _Big_Cascade_Noise_Flow_UV_Refresh_Speed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeFlowUVRefreshSpeed)
#define _BigCascadeFlowUVRefreshSpeed_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _BigCascadeWaterTessScale)
#define _BigCascadeWaterTessScale_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _Caustic_Triplanar_Hardness)
#define _Caustic_Triplanar_Hardness_arr Graph_NM_River_SS_Tesselation
			UNITY_DEFINE_INSTANCED_PROP(half, _AOPower)
#define _AOPower_arr Graph_NM_River_SS_Tesselation
		UNITY_INSTANCING_BUFFER_END(Graph_NM_River_SS_Tesselation)


		half2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		half3 InvertDepthDir72_g32( half3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		inline float4 TriplanarSampling25_g29( UNITY_DECLARE_TEX2D_NOSAMPLER(topTexMap), SamplerState samplertopTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling26_g29( UNITY_DECLARE_TEX2D_NOSAMPLER(topTexMap), SamplerState samplertopTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			half clampResult44_g5 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Slope_Speed_Influence_arr, _Slope_Speed_Influence);
			half2 SlopeSpeedInfluence204 = _Slope_Speed_Influence_Instance;
			half2 _MainWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainWaterSpeed_arr, _MainWaterSpeed);
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 temp_output_66_0_g5 = _SlowWaterTiling_Instance;
			half2 temp_output_53_0_g5 = ( ( ( ( ( 1.0 - clampResult44_g5 ) * SlopeSpeedInfluence204 ) + _MainWaterSpeed_Instance ) * temp_output_66_0_g5 ) * v.texcoord3.xy );
			half2 break56_g5 = temp_output_53_0_g5;
			half2 appendResult57_g5 = (half2(break56_g5.y , break56_g5.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g5 = temp_output_53_0_g5;
			#else
				half2 staticSwitch59_g5 = appendResult57_g5;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half temp_output_68_0_g5 = ( ( _Time.y + 0.0 ) * _WaterFlowUVRefresSpeed_Instance );
			half temp_output_71_0_g5 = frac( ( temp_output_68_0_g5 + 0.0 ) );
			half2 temp_output_60_0_g5 = ( staticSwitch59_g5 * temp_output_71_0_g5 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
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
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half2 appendResult136 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 temp_output_147_0 = ( temp_output_145_0 + ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * _MacroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( _MacroWaveTiling_Instance * appendResult136 ) ) ) );
			half4 tex2DNode184 = SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0, 0.0 );
			half MacroWaveTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(MacroWaveTessScale_arr, MacroWaveTessScale);
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93, 0.0 ).r , temp_output_69_96);
			half _SlowWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTessScale_arr, _SlowWaterTessScale);
			half2 _SmallCascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeMainSpeed_arr, _SmallCascadeMainSpeed);
			half2 temp_output_65_0_g35 = _SmallCascadeMainSpeed_Instance;
			half4 _Vector0 = half4(-1,1,0,1);
			half2 _SmallCascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeTiling_arr, _SmallCascadeTiling);
			half2 temp_output_66_0_g35 = _SmallCascadeTiling_Instance;
			half2 temp_output_53_0_g35 = ( ( ( temp_output_65_0_g35 + ( temp_output_65_0_g35 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g35 ) * v.texcoord3.xy );
			half2 break56_g35 = temp_output_53_0_g35;
			half2 appendResult57_g35 = (half2(break56_g35.y , break56_g35.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g35 = temp_output_53_0_g35;
			#else
				half2 staticSwitch59_g35 = appendResult57_g35;
			#endif
			half _SmallCascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeFlowUVRefreshSpeed_arr, _SmallCascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g35 = ( _Time.y * _SmallCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g35 = frac( ( temp_output_68_0_g35 + 0.0 ) );
			half2 temp_output_60_0_g35 = ( staticSwitch59_g35 * temp_output_71_0_g35 );
			half2 temp_output_83_0_g35 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g35 * v.texcoord.xy ) );
			half2 temp_output_202_91 = ( temp_output_60_0_g35 + temp_output_83_0_g35 );
			half2 temp_output_80_0_g35 = ( staticSwitch59_g35 * frac( ( temp_output_68_0_g35 + -0.5 ) ) );
			half2 temp_output_202_93 = ( temp_output_83_0_g35 + temp_output_80_0_g35 );
			half clampResult90_g35 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g35 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_202_96 = clampResult90_g35;
			half lerpResult214 = lerp( SAMPLE_TEXTURE2D_LOD( _SmallCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_202_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _SmallCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_202_93, 0.0 ).r , temp_output_202_96);
			half2 _NoiseSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseSpeed_arr, _NoiseSpeed);
			half2 temp_output_65_0_g12 = _NoiseSpeed_Instance;
			half2 _NoiseTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseTiling_arr, _NoiseTiling);
			half2 temp_output_66_0_g12 = _NoiseTiling_Instance;
			half2 temp_output_53_0_g12 = ( ( ( temp_output_65_0_g12 + ( temp_output_65_0_g12 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g12 ) * v.texcoord3.xy );
			half2 break56_g12 = temp_output_53_0_g12;
			half2 appendResult57_g12 = (half2(break56_g12.y , break56_g12.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g12 = temp_output_53_0_g12;
			#else
				half2 staticSwitch59_g12 = appendResult57_g12;
			#endif
			half _Small_Cascade_Noise_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Noise_Flow_UV_Refresh_Speed_arr, _Small_Cascade_Noise_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g12 = ( _Time.y * _Small_Cascade_Noise_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g12 = frac( ( temp_output_68_0_g12 + 0.0 ) );
			half2 temp_output_60_0_g12 = ( staticSwitch59_g12 * temp_output_71_0_g12 );
			half2 temp_output_83_0_g12 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g12 * v.texcoord.xy ) );
			half2 temp_output_111_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half2 _FoamSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamSpeed_arr, _FoamSpeed);
			half2 temp_output_65_0_g9 = _FoamSpeed_Instance;
			half2 _Side_Foam_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Tiling_arr, _Side_Foam_Tiling);
			half2 temp_output_66_0_g9 = _Side_Foam_Tiling_Instance;
			half2 temp_output_53_0_g9 = ( ( ( temp_output_65_0_g9 + ( temp_output_65_0_g9 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g9 ) * v.texcoord3.xy );
			half2 break56_g9 = temp_output_53_0_g9;
			half2 appendResult57_g9 = (half2(break56_g9.y , break56_g9.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g9 = temp_output_53_0_g9;
			#else
				half2 staticSwitch59_g9 = appendResult57_g9;
			#endif
			half _Side_Foam_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Flow_UV_Refresh_Speed_arr, _Side_Foam_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g9 = ( _Time.y * _Side_Foam_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g9 = frac( ( temp_output_68_0_g9 + 0.0 ) );
			half2 temp_output_60_0_g9 = ( staticSwitch59_g9 * temp_output_71_0_g9 );
			half2 temp_output_83_0_g9 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g9 * v.texcoord.xy ) );
			half2 temp_output_104_0 = ( temp_output_111_0 + ( temp_output_60_0_g9 + temp_output_83_0_g9 ) );
			half _Side_Foam_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Normal_Scale_arr, _Side_Foam_Normal_Scale);
			half2 temp_output_80_0_g9 = ( staticSwitch59_g9 * frac( ( temp_output_68_0_g9 + -0.5 ) ) );
			half2 temp_output_105_0 = ( temp_output_111_0 + ( temp_output_83_0_g9 + temp_output_80_0_g9 ) );
			half clampResult90_g9 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g9 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_94_96 = clampResult90_g9;
			half lerpResult100 = lerp( SAMPLE_TEXTURE2D_LOD( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_104_0, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_105_0, 0.0 ).r , temp_output_94_96);
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			half clampDepth53_g67 = SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPos.xy, 0, 0 ) );
			half temp_output_52_0_g67 = ( _ProjectionParams.x < 0.0 ? clampDepth53_g67 : ( 1.0 - clampDepth53_g67 ) );
			half temp_output_49_0_g67 = saturate( ( (_ProjectionParams.z + (temp_output_52_0_g67 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - eyeDepth ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth44_g67 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			half ifLocalVar46_g67 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar46_g67 = temp_output_49_0_g67;
			else
				ifLocalVar46_g67 = ( eyeDepth44_g67 - eyeDepth );
			half _FoamDepth_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamDepth_arr, _FoamDepth);
			half _FoamFalloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamFalloff_arr, _FoamFalloff);
			half clampResult307 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half temp_output_313_0 = ( _BigCascadeAngle / 45.0 );
			half clampResult319 = clamp( ( clampResult307 - ( 1.0 - temp_output_313_0 ) ) , 0.0 , 2.0 );
			half clampResult324 = clamp( ( clampResult319 * ( 1.0 / temp_output_313_0 ) ) , 0.0 , 1.0 );
			half clampResult328 = clamp( pow( abs( ( 1.0 - clampResult324 ) ) , _BigCascadeAngleFalloff ) , 0.0 , 1.0 );
			half BigCascadeAngle336 = clampResult328;
			half lerpResult577 = lerp( ( lerpResult100 * saturate( pow( abs( ( ifLocalVar46_g67 + _FoamDepth_Instance ) ) , _FoamFalloff_Instance ) ) ) , 0.0 , BigCascadeAngle336);
			half clampResult579 = clamp( lerpResult577 , 0.0 , 1.0 );
			half _FoamWaveHardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWaveHardness_arr, _FoamWaveHardness);
			half _FoamWavePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWavePower_arr, _FoamWavePower);
			half _FoamWaveMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWaveMultiply_arr, _FoamWaveMultiply);
			half clampResult581 = clamp( ( pow( abs( ( lerpResult81 * _FoamWaveHardness_Instance ) ) , _FoamWavePower_Instance ) * _FoamWaveMultiply_Instance ) , 0.0 , 1.0 );
			half temp_output_580_0 = ( clampResult579 * clampResult581 );
			half clampResult114 = clamp( temp_output_580_0 , 0.0 , 1.0 );
			half temp_output_113_0 = ( _Side_Foam_Normal_Scale_Instance * clampResult114 );
			half3 lerpResult110 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _Side_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_104_0, 0.0 ), temp_output_113_0 ) , UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _Side_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_105_0, 0.0 ), temp_output_113_0 ) , temp_output_94_96);
			half2 WindMicroWaveTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(WindMicroWaveTiling_arr, WindMicroWaveTiling);
			half2 appendResult124 = (half2(ase_worldPos.x , ase_worldPos.z));
			half3 tex2DNode149 = UnpackNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, ( ( ( _Time.y * ( ( _SlowWaterMixSpeed_Instance * float2( 1.2,1.2 ) ) * WindMicroWaveTiling_Instance ) ) + ( ( 1.0 / GlobalTiling70 ) * ( WindMicroWaveTiling_Instance * appendResult124 ) ) ) + temp_output_145_0 ), 0.0 ) );
			half2 appendResult152 = (half2(tex2DNode149.r , tex2DNode149.g));
			half2 appendResult168 = (half2(sign( ase_worldNormal.y ) , 1.0));
			half2 appendResult169 = (half2(ase_worldNormal.x , ase_worldNormal.z));
			half2 break174 = ( ( appendResult152 * appendResult168 ) + appendResult169 );
			half3 appendResult172 = (half3(break174.x , ( ase_worldNormal.y * tex2DNode149.b ) , break174.y));
			half3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			half tangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			half3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * tangentSign;
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half3 worldToTangentDir178 = mul( ase_worldToTangent, appendResult172);
			half3 break31_g7 = worldToTangentDir178;
			half2 appendResult35_g7 = (half2(break31_g7.x , break31_g7.y));
			half _MicroWaveNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_MicroWaveNormalScale_arr, _MicroWaveNormalScale);
			half temp_output_38_0_g7 = _MicroWaveNormalScale_Instance;
			half lerpResult36_g7 = lerp( 1.0 , break31_g7.z , saturate( temp_output_38_0_g7 ));
			half3 appendResult34_g7 = (half3(( appendResult35_g7 * temp_output_38_0_g7 ) , lerpResult36_g7));
			half3 tex2DNode150 = UnpackNormal( SAMPLE_TEXTURE2D_LOD( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_147_0, 0.0 ) );
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
			half3 temp_output_116_0 = BlendNormals( BlendNormals( lerpResult110 , lerpResult80 ) , BlendNormals( appendResult34_g7 , appendResult34_g8 ) );
			half _SmallCascadeNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNormalScale_arr, _SmallCascadeNormalScale);
			half3 lerpResult210 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SmallCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_202_91, 0.0 ), _SmallCascadeNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D_LOD( _SmallCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_202_93, 0.0 ), _SmallCascadeNormalScale_Instance ) , temp_output_202_96);
			half temp_output_310_0 = ( _SmallCascadeAngle / 45.0 );
			half clampResult318 = clamp( ( clampResult307 - ( 1.0 - temp_output_310_0 ) ) , 0.0 , 2.0 );
			half clampResult320 = clamp( ( clampResult318 * ( 1.0 / temp_output_310_0 ) ) , 0.0 , 1.0 );
			half clampResult329 = clamp( ( pow( abs( ( 1.0 - clampResult320 ) ) , _SmallCascadeAngleFalloff ) - clampResult328 ) , 0.0 , 1.0 );
			half SmallCascadeAngle335 = clampResult329;
			half3 lerpResult248 = lerp( temp_output_116_0 , lerpResult210 , SmallCascadeAngle335);
			half2 temp_output_247_0 = ( (lerpResult248).xy * float2( 0.03,0.03 ) );
			half2 temp_output_80_0_g12 = ( staticSwitch59_g12 * frac( ( temp_output_68_0_g12 + -0.5 ) ) );
			half clampResult90_g12 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g12 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult238 = lerp( SAMPLE_TEXTURE2D_LOD( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_60_0_g12 + temp_output_83_0_g12 ) + temp_output_247_0 ), 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_83_0_g12 + temp_output_80_0_g12 ) + temp_output_247_0 ), 0.0 ).r , clampResult90_g12);
			half _SmallCascadeNoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNoisePower_arr, _SmallCascadeNoisePower);
			half _SmallCascadeNoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNoiseMultiply_arr, _SmallCascadeNoiseMultiply);
			half temp_output_253_0 = ( pow( abs( lerpResult238 ) , _SmallCascadeNoisePower_Instance ) * _SmallCascadeNoiseMultiply_Instance );
			half clampResult535 = clamp( temp_output_253_0 , 0.4 , 1.0 );
			half _SmallCascadeWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeWaterTessScale_arr, _SmallCascadeWaterTessScale);
			half temp_output_538_0 = ( ( ( lerpResult214 + -0.25 ) * clampResult535 ) * _SmallCascadeWaterTessScale_Instance );
			half _BigCascadeWaterTessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeWaterTessScale_arr, _BigCascadeWaterTessScale);
			half2 _BigCascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeMainSpeed_arr, _BigCascadeMainSpeed);
			half2 temp_output_65_0_g13 = _BigCascadeMainSpeed_Instance;
			half2 _BigCascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeTiling_arr, _BigCascadeTiling);
			half2 temp_output_66_0_g13 = _BigCascadeTiling_Instance;
			half2 temp_output_53_0_g13 = ( ( ( temp_output_65_0_g13 + ( temp_output_65_0_g13 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g13 ) * v.texcoord3.xy );
			half2 break56_g13 = temp_output_53_0_g13;
			half2 appendResult57_g13 = (half2(break56_g13.y , break56_g13.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g13 = temp_output_53_0_g13;
			#else
				half2 staticSwitch59_g13 = appendResult57_g13;
			#endif
			half _BigCascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeFlowUVRefreshSpeed_arr, _BigCascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g13 = ( _Time.y * _BigCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g13 = frac( ( temp_output_68_0_g13 + 0.0 ) );
			half2 temp_output_60_0_g13 = ( staticSwitch59_g13 * temp_output_71_0_g13 );
			half2 temp_output_83_0_g13 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g13 * v.texcoord.xy ) );
			half2 temp_output_256_91 = ( temp_output_60_0_g13 + temp_output_83_0_g13 );
			half2 temp_output_80_0_g13 = ( staticSwitch59_g13 * frac( ( temp_output_68_0_g13 + -0.5 ) ) );
			half2 temp_output_256_93 = ( temp_output_83_0_g13 + temp_output_80_0_g13 );
			half clampResult90_g13 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g13 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_256_96 = clampResult90_g13;
			half lerpResult261 = lerp( SAMPLE_TEXTURE2D_LOD( BigCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_91, 0.0 ).r , SAMPLE_TEXTURE2D_LOD( BigCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_93, 0.0 ).r , temp_output_256_96);
			half2 _Big_Cascade_Noise_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Speed_arr, _Big_Cascade_Noise_Speed);
			half2 temp_output_65_0_g15 = _Big_Cascade_Noise_Speed_Instance;
			half2 _Big_Cascade_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Tiling_arr, _Big_Cascade_Noise_Tiling);
			half2 temp_output_66_0_g15 = _Big_Cascade_Noise_Tiling_Instance;
			half2 temp_output_53_0_g15 = ( ( ( temp_output_65_0_g15 + ( temp_output_65_0_g15 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g15 ) * v.texcoord3.xy );
			half2 break56_g15 = temp_output_53_0_g15;
			half2 appendResult57_g15 = (half2(break56_g15.y , break56_g15.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g15 = temp_output_53_0_g15;
			#else
				half2 staticSwitch59_g15 = appendResult57_g15;
			#endif
			half _Big_Cascade_Noise_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Flow_UV_Refresh_Speed_arr, _Big_Cascade_Noise_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g15 = ( _Time.y * _Big_Cascade_Noise_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g15 = frac( ( temp_output_68_0_g15 + 0.0 ) );
			half2 temp_output_60_0_g15 = ( staticSwitch59_g15 * temp_output_71_0_g15 );
			half2 temp_output_83_0_g15 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g15 * v.texcoord.xy ) );
			half2 temp_output_296_0 = ( float2( 0,0 ).x * float2( 0.03,0.03 ).x );
			half2 temp_output_80_0_g15 = ( staticSwitch59_g15 * frac( ( temp_output_68_0_g15 + -0.5 ) ) );
			half clampResult90_g15 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g15 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult284 = lerp( SAMPLE_TEXTURE2D_LOD( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_60_0_g15 + temp_output_83_0_g15 ) + temp_output_296_0 ), 0.0 ).r , SAMPLE_TEXTURE2D_LOD( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_83_0_g15 + temp_output_80_0_g15 ) + temp_output_296_0 ), 0.0 ).r , clampResult90_g15);
			half _BigCascadeNoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeNoisePower_arr, _BigCascadeNoisePower);
			half _BigCascadeNoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeNoiseMultiply_arr, _BigCascadeNoiseMultiply);
			half temp_output_299_0 = ( pow( abs( lerpResult284 ) , _BigCascadeNoisePower_Instance ) * _BigCascadeNoiseMultiply_Instance );
			half clampResult545 = clamp( temp_output_299_0 , 0.6 , 1.0 );
			half temp_output_547_0 = ( _BigCascadeWaterTessScale_Instance * ( ( lerpResult261 + -0.25 ) * clampResult545 ) );
			half4 break469 = v.color;
			half lerpResult553 = lerp( ( ( ( ( ( tex2DNode184.r + -0.2 ) * MacroWaveTessScale_Instance ) + ( ( lerpResult81 + -0.2 ) * _SlowWaterTessScale_Instance ) ) + ( temp_output_538_0 * SmallCascadeAngle335 ) ) + ( temp_output_547_0 * BigCascadeAngle336 ) ) , temp_output_538_0 , break469.g);
			half lerpResult552 = lerp( lerpResult553 , temp_output_547_0 , break469.b);
			half3 ase_vertexNormal = v.normal.xyz;
			half3 clampResult559 = clamp( ase_vertexNormal , float3( 0,0,0 ) , float3( 1,1,1 ) );
			v.vertex.xyz += ( lerpResult552 * clampResult559 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half clampResult44_g5 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half2 _Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Slope_Speed_Influence_arr, _Slope_Speed_Influence);
			half2 SlopeSpeedInfluence204 = _Slope_Speed_Influence_Instance;
			half2 _MainWaterSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainWaterSpeed_arr, _MainWaterSpeed);
			half2 _SlowWaterTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTiling_arr, _SlowWaterTiling);
			half2 temp_output_66_0_g5 = _SlowWaterTiling_Instance;
			half2 temp_output_53_0_g5 = ( ( ( ( ( 1.0 - clampResult44_g5 ) * SlopeSpeedInfluence204 ) + _MainWaterSpeed_Instance ) * temp_output_66_0_g5 ) * i.uv4_texcoord4 );
			half2 break56_g5 = temp_output_53_0_g5;
			half2 appendResult57_g5 = (half2(break56_g5.y , break56_g5.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g5 = temp_output_53_0_g5;
			#else
				half2 staticSwitch59_g5 = appendResult57_g5;
			#endif
			half _WaterFlowUVRefresSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterFlowUVRefresSpeed_arr, _WaterFlowUVRefresSpeed);
			half temp_output_68_0_g5 = ( ( _Time.y + 0.0 ) * _WaterFlowUVRefresSpeed_Instance );
			half temp_output_71_0_g5 = frac( ( temp_output_68_0_g5 + 0.0 ) );
			half2 temp_output_60_0_g5 = ( staticSwitch59_g5 * temp_output_71_0_g5 );
			half _GlobalTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlobalTiling_arr, _GlobalTiling);
			half GlobalTiling70 = _GlobalTiling_Instance;
			half2 temp_output_83_0_g5 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g5 * i.uv_texcoord ) );
			half2 temp_output_69_91 = ( temp_output_60_0_g5 + temp_output_83_0_g5 );
			half _SlowNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowNormalScale_arr, _SlowNormalScale);
			half2 temp_output_80_0_g5 = ( staticSwitch59_g5 * frac( ( temp_output_68_0_g5 + -0.5 ) ) );
			half2 temp_output_69_93 = ( temp_output_83_0_g5 + temp_output_80_0_g5 );
			half clampResult90_g5 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g5 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_69_96 = clampResult90_g5;
			half3 lerpResult80 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ), _SlowNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _SlowWaterNormal, sampler_Linear_Repeat_Aniso8, temp_output_69_93 ), _SlowNormalScale_Instance ) , temp_output_69_96);
			half2 temp_output_111_0 = ( (lerpResult80).xy * float2( 0.05,0.05 ) );
			half2 _FoamSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamSpeed_arr, _FoamSpeed);
			half2 temp_output_65_0_g9 = _FoamSpeed_Instance;
			half4 _Vector0 = half4(-1,1,0,1);
			half2 _Side_Foam_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Tiling_arr, _Side_Foam_Tiling);
			half2 temp_output_66_0_g9 = _Side_Foam_Tiling_Instance;
			half2 temp_output_53_0_g9 = ( ( ( temp_output_65_0_g9 + ( temp_output_65_0_g9 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g9 ) * i.uv4_texcoord4 );
			half2 break56_g9 = temp_output_53_0_g9;
			half2 appendResult57_g9 = (half2(break56_g9.y , break56_g9.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g9 = temp_output_53_0_g9;
			#else
				half2 staticSwitch59_g9 = appendResult57_g9;
			#endif
			half _Side_Foam_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Flow_UV_Refresh_Speed_arr, _Side_Foam_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g9 = ( _Time.y * _Side_Foam_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g9 = frac( ( temp_output_68_0_g9 + 0.0 ) );
			half2 temp_output_60_0_g9 = ( staticSwitch59_g9 * temp_output_71_0_g9 );
			half2 temp_output_83_0_g9 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g9 * i.uv_texcoord ) );
			half2 temp_output_104_0 = ( temp_output_111_0 + ( temp_output_60_0_g9 + temp_output_83_0_g9 ) );
			half _Side_Foam_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Normal_Scale_arr, _Side_Foam_Normal_Scale);
			half2 temp_output_80_0_g9 = ( staticSwitch59_g9 * frac( ( temp_output_68_0_g9 + -0.5 ) ) );
			half2 temp_output_105_0 = ( temp_output_111_0 + ( temp_output_83_0_g9 + temp_output_80_0_g9 ) );
			half clampResult90_g9 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g9 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_94_96 = clampResult90_g9;
			half lerpResult100 = lerp( SAMPLE_TEXTURE2D( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_104_0 ).r , SAMPLE_TEXTURE2D( _Foam, sampler_Linear_Repeat_Aniso8, temp_output_105_0 ).r , temp_output_94_96);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half clampDepth53_g67 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy );
			half temp_output_52_0_g67 = ( _ProjectionParams.x < 0.0 ? clampDepth53_g67 : ( 1.0 - clampDepth53_g67 ) );
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_viewPos = UnityObjectToViewPos( ase_vertex4Pos );
			float ase_screenDepth = -ase_viewPos.z;
			half temp_output_49_0_g67 = saturate( ( (_ProjectionParams.z + (temp_output_52_0_g67 - 0.0) * (_ProjectionParams.y - _ProjectionParams.z) / (1.0 - 0.0)) - ase_screenDepth ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth44_g67 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half ifLocalVar46_g67 = 0;
			UNITY_BRANCH 
			if( unity_OrthoParams.w >= 1.0 )
				ifLocalVar46_g67 = temp_output_49_0_g67;
			else
				ifLocalVar46_g67 = ( eyeDepth44_g67 - ase_screenDepth );
			half _FoamDepth_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamDepth_arr, _FoamDepth);
			half _FoamFalloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamFalloff_arr, _FoamFalloff);
			half clampResult307 = clamp( abs( ase_worldNormal.y ) , 0.0 , 1.0 );
			half temp_output_313_0 = ( _BigCascadeAngle / 45.0 );
			half clampResult319 = clamp( ( clampResult307 - ( 1.0 - temp_output_313_0 ) ) , 0.0 , 2.0 );
			half clampResult324 = clamp( ( clampResult319 * ( 1.0 / temp_output_313_0 ) ) , 0.0 , 1.0 );
			half clampResult328 = clamp( pow( abs( ( 1.0 - clampResult324 ) ) , _BigCascadeAngleFalloff ) , 0.0 , 1.0 );
			half BigCascadeAngle336 = clampResult328;
			half lerpResult577 = lerp( ( lerpResult100 * saturate( pow( abs( ( ifLocalVar46_g67 + _FoamDepth_Instance ) ) , _FoamFalloff_Instance ) ) ) , 0.0 , BigCascadeAngle336);
			half clampResult579 = clamp( lerpResult577 , 0.0 , 1.0 );
			half lerpResult81 = lerp( SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_91 ).r , SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_69_93 ).r , temp_output_69_96);
			half _FoamWaveHardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWaveHardness_arr, _FoamWaveHardness);
			half _FoamWavePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWavePower_arr, _FoamWavePower);
			half _FoamWaveMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamWaveMultiply_arr, _FoamWaveMultiply);
			half clampResult581 = clamp( ( pow( abs( ( lerpResult81 * _FoamWaveHardness_Instance ) ) , _FoamWavePower_Instance ) * _FoamWaveMultiply_Instance ) , 0.0 , 1.0 );
			half temp_output_580_0 = ( clampResult579 * clampResult581 );
			half clampResult114 = clamp( temp_output_580_0 , 0.0 , 1.0 );
			half temp_output_113_0 = ( _Side_Foam_Normal_Scale_Instance * clampResult114 );
			half3 lerpResult110 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Side_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_104_0 ), temp_output_113_0 ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Side_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_105_0 ), temp_output_113_0 ) , temp_output_94_96);
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
			half3 temp_output_116_0 = BlendNormals( BlendNormals( lerpResult110 , lerpResult80 ) , BlendNormals( appendResult34_g7 , appendResult34_g8 ) );
			half2 _SmallCascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeMainSpeed_arr, _SmallCascadeMainSpeed);
			half2 temp_output_65_0_g35 = _SmallCascadeMainSpeed_Instance;
			half2 _SmallCascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeTiling_arr, _SmallCascadeTiling);
			half2 temp_output_66_0_g35 = _SmallCascadeTiling_Instance;
			half2 temp_output_53_0_g35 = ( ( ( temp_output_65_0_g35 + ( temp_output_65_0_g35 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g35 ) * i.uv4_texcoord4 );
			half2 break56_g35 = temp_output_53_0_g35;
			half2 appendResult57_g35 = (half2(break56_g35.y , break56_g35.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g35 = temp_output_53_0_g35;
			#else
				half2 staticSwitch59_g35 = appendResult57_g35;
			#endif
			half _SmallCascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeFlowUVRefreshSpeed_arr, _SmallCascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g35 = ( _Time.y * _SmallCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g35 = frac( ( temp_output_68_0_g35 + 0.0 ) );
			half2 temp_output_60_0_g35 = ( staticSwitch59_g35 * temp_output_71_0_g35 );
			half2 temp_output_83_0_g35 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g35 * i.uv_texcoord ) );
			half2 temp_output_202_91 = ( temp_output_60_0_g35 + temp_output_83_0_g35 );
			half _SmallCascadeNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNormalScale_arr, _SmallCascadeNormalScale);
			half2 temp_output_80_0_g35 = ( staticSwitch59_g35 * frac( ( temp_output_68_0_g35 + -0.5 ) ) );
			half2 temp_output_202_93 = ( temp_output_83_0_g35 + temp_output_80_0_g35 );
			half clampResult90_g35 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g35 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_202_96 = clampResult90_g35;
			half3 lerpResult210 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _SmallCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_202_91 ), _SmallCascadeNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _SmallCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_202_93 ), _SmallCascadeNormalScale_Instance ) , temp_output_202_96);
			half2 temp_output_65_0_g36 = _SmallCascadeMainSpeed_Instance;
			half2 _Small_Cascade_Foam_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Foam_Tiling_arr, _Small_Cascade_Foam_Tiling);
			half2 temp_output_66_0_g36 = _Small_Cascade_Foam_Tiling_Instance;
			half2 temp_output_53_0_g36 = ( ( ( temp_output_65_0_g36 + ( temp_output_65_0_g36 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g36 ) * i.uv4_texcoord4 );
			half2 break56_g36 = temp_output_53_0_g36;
			half2 appendResult57_g36 = (half2(break56_g36.y , break56_g36.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g36 = temp_output_53_0_g36;
			#else
				half2 staticSwitch59_g36 = appendResult57_g36;
			#endif
			half temp_output_68_0_g36 = ( _Time.y * _SmallCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g36 = frac( ( temp_output_68_0_g36 + 0.0 ) );
			half2 temp_output_60_0_g36 = ( staticSwitch59_g36 * temp_output_71_0_g36 );
			half2 temp_output_83_0_g36 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g36 * i.uv_texcoord ) );
			half2 temp_output_218_91 = ( temp_output_60_0_g36 + temp_output_83_0_g36 );
			half _Small_Cascade_Foam_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Foam_Normal_Scale_arr, _Small_Cascade_Foam_Normal_Scale);
			half clampResult343 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			half temp_output_344_0 = ( 1.0 - clampResult343 );
			half2 _NoiseSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseSpeed_arr, _NoiseSpeed);
			half2 temp_output_65_0_g12 = _NoiseSpeed_Instance;
			half2 _NoiseTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_NoiseTiling_arr, _NoiseTiling);
			half2 temp_output_66_0_g12 = _NoiseTiling_Instance;
			half2 temp_output_53_0_g12 = ( ( ( temp_output_65_0_g12 + ( temp_output_65_0_g12 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g12 ) * i.uv4_texcoord4 );
			half2 break56_g12 = temp_output_53_0_g12;
			half2 appendResult57_g12 = (half2(break56_g12.y , break56_g12.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g12 = temp_output_53_0_g12;
			#else
				half2 staticSwitch59_g12 = appendResult57_g12;
			#endif
			half _Small_Cascade_Noise_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Noise_Flow_UV_Refresh_Speed_arr, _Small_Cascade_Noise_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g12 = ( _Time.y * _Small_Cascade_Noise_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g12 = frac( ( temp_output_68_0_g12 + 0.0 ) );
			half2 temp_output_60_0_g12 = ( staticSwitch59_g12 * temp_output_71_0_g12 );
			half2 temp_output_83_0_g12 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g12 * i.uv_texcoord ) );
			half temp_output_310_0 = ( _SmallCascadeAngle / 45.0 );
			half clampResult318 = clamp( ( clampResult307 - ( 1.0 - temp_output_310_0 ) ) , 0.0 , 2.0 );
			half clampResult320 = clamp( ( clampResult318 * ( 1.0 / temp_output_310_0 ) ) , 0.0 , 1.0 );
			half clampResult329 = clamp( ( pow( abs( ( 1.0 - clampResult320 ) ) , _SmallCascadeAngleFalloff ) - clampResult328 ) , 0.0 , 1.0 );
			half SmallCascadeAngle335 = clampResult329;
			half3 lerpResult248 = lerp( temp_output_116_0 , lerpResult210 , SmallCascadeAngle335);
			half2 temp_output_247_0 = ( (lerpResult248).xy * float2( 0.03,0.03 ) );
			half2 temp_output_80_0_g12 = ( staticSwitch59_g12 * frac( ( temp_output_68_0_g12 + -0.5 ) ) );
			half clampResult90_g12 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g12 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult238 = lerp( SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_60_0_g12 + temp_output_83_0_g12 ) + temp_output_247_0 ) ).r , SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_83_0_g12 + temp_output_80_0_g12 ) + temp_output_247_0 ) ).r , clampResult90_g12);
			half _SmallCascadeNoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNoisePower_arr, _SmallCascadeNoisePower);
			half _SmallCascadeNoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeNoiseMultiply_arr, _SmallCascadeNoiseMultiply);
			half temp_output_253_0 = ( pow( abs( lerpResult238 ) , _SmallCascadeNoisePower_Instance ) * _SmallCascadeNoiseMultiply_Instance );
			half clampResult347 = clamp( temp_output_253_0 , 0.0 , 1.0 );
			half lerpResult214 = lerp( SAMPLE_TEXTURE2D( _SmallCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_202_91 ).r , SAMPLE_TEXTURE2D( _SmallCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_202_93 ).r , temp_output_202_96);
			half _Small_Cascade_Foam_Height_Mask_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Foam_Height_Mask_arr, _Small_Cascade_Foam_Height_Mask);
			half temp_output_349_0 = pow( abs( lerpResult214 ) , _Small_Cascade_Foam_Height_Mask_Instance );
			half temp_output_345_0 = ( ( _Small_Cascade_Foam_Normal_Scale_Instance * temp_output_344_0 ) * ( clampResult347 * temp_output_349_0 ) );
			half2 temp_output_80_0_g36 = ( staticSwitch59_g36 * frac( ( temp_output_68_0_g36 + -0.5 ) ) );
			half2 temp_output_218_93 = ( temp_output_83_0_g36 + temp_output_80_0_g36 );
			half clampResult90_g36 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g36 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_218_96 = clampResult90_g36;
			half3 lerpResult224 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Small_Cascade_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_218_91 ), temp_output_345_0 ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Small_Cascade_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_218_93 ), temp_output_345_0 ) , temp_output_218_96);
			half3 temp_output_339_0 = BlendNormals( lerpResult210 , lerpResult224 );
			half3 lerpResult338 = lerp( temp_output_116_0 , temp_output_339_0 , SmallCascadeAngle335);
			half2 _BigCascadeMainSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeMainSpeed_arr, _BigCascadeMainSpeed);
			half2 temp_output_65_0_g13 = _BigCascadeMainSpeed_Instance;
			half2 _BigCascadeTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeTiling_arr, _BigCascadeTiling);
			half2 temp_output_66_0_g13 = _BigCascadeTiling_Instance;
			half2 temp_output_53_0_g13 = ( ( ( temp_output_65_0_g13 + ( temp_output_65_0_g13 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g13 ) * i.uv4_texcoord4 );
			half2 break56_g13 = temp_output_53_0_g13;
			half2 appendResult57_g13 = (half2(break56_g13.y , break56_g13.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g13 = temp_output_53_0_g13;
			#else
				half2 staticSwitch59_g13 = appendResult57_g13;
			#endif
			half _BigCascadeFlowUVRefreshSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeFlowUVRefreshSpeed_arr, _BigCascadeFlowUVRefreshSpeed);
			half temp_output_68_0_g13 = ( _Time.y * _BigCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g13 = frac( ( temp_output_68_0_g13 + 0.0 ) );
			half2 temp_output_60_0_g13 = ( staticSwitch59_g13 * temp_output_71_0_g13 );
			half2 temp_output_83_0_g13 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g13 * i.uv_texcoord ) );
			half2 temp_output_256_91 = ( temp_output_60_0_g13 + temp_output_83_0_g13 );
			half _BigCascadeNormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeNormalScale_arr, _BigCascadeNormalScale);
			half2 temp_output_80_0_g13 = ( staticSwitch59_g13 * frac( ( temp_output_68_0_g13 + -0.5 ) ) );
			half2 temp_output_256_93 = ( temp_output_83_0_g13 + temp_output_80_0_g13 );
			half clampResult90_g13 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g13 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_256_96 = clampResult90_g13;
			half3 lerpResult282 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _BigCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_256_91 ), _BigCascadeNormalScale_Instance ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _BigCascadeNormal, sampler_Linear_Repeat_Aniso8, temp_output_256_93 ), _BigCascadeNormalScale_Instance ) , temp_output_256_96);
			half2 temp_output_65_0_g34 = _BigCascadeMainSpeed_Instance;
			half2 _Big_Cascade_Slope_Speed_Influence_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Slope_Speed_Influence_arr, _Big_Cascade_Slope_Speed_Influence);
			half2 _Big_Foam_Cascade_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Foam_Cascade_Tiling_arr, _Big_Foam_Cascade_Tiling);
			half2 temp_output_66_0_g34 = _Big_Foam_Cascade_Tiling_Instance;
			half2 temp_output_53_0_g34 = ( ( ( temp_output_65_0_g34 + ( temp_output_65_0_g34 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( _Big_Cascade_Slope_Speed_Influence_Instance * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g34 ) * i.uv4_texcoord4 );
			half2 break56_g34 = temp_output_53_0_g34;
			half2 appendResult57_g34 = (half2(break56_g34.y , break56_g34.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g34 = temp_output_53_0_g34;
			#else
				half2 staticSwitch59_g34 = appendResult57_g34;
			#endif
			half temp_output_68_0_g34 = ( _Time.y * _BigCascadeFlowUVRefreshSpeed_Instance );
			half temp_output_71_0_g34 = frac( ( temp_output_68_0_g34 + 0.0 ) );
			half2 temp_output_60_0_g34 = ( staticSwitch59_g34 * temp_output_71_0_g34 );
			half2 temp_output_83_0_g34 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g34 * i.uv_texcoord ) );
			half2 temp_output_276_91 = ( temp_output_60_0_g34 + temp_output_83_0_g34 );
			half _Big_Cascade_Foam_Normal_Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Foam_Normal_Scale_arr, _Big_Cascade_Foam_Normal_Scale);
			half clampResult459 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			half temp_output_458_0 = ( 1.0 - clampResult459 );
			half2 _Big_Cascade_Noise_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Speed_arr, _Big_Cascade_Noise_Speed);
			half2 temp_output_65_0_g15 = _Big_Cascade_Noise_Speed_Instance;
			half2 _Big_Cascade_Noise_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Tiling_arr, _Big_Cascade_Noise_Tiling);
			half2 temp_output_66_0_g15 = _Big_Cascade_Noise_Tiling_Instance;
			half2 temp_output_53_0_g15 = ( ( ( temp_output_65_0_g15 + ( temp_output_65_0_g15 * ( abs( pow( abs( (_Vector0.z + (ase_worldNormal.y - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ) , 0.5 ) ) * ( SlopeSpeedInfluence204 * half2( -1,-1 ) ) ) ) ) * temp_output_66_0_g15 ) * i.uv4_texcoord4 );
			half2 break56_g15 = temp_output_53_0_g15;
			half2 appendResult57_g15 = (half2(break56_g15.y , break56_g15.x));
			#ifdef _UVVDIRECTION1UDIRECTION0_ON
				half2 staticSwitch59_g15 = temp_output_53_0_g15;
			#else
				half2 staticSwitch59_g15 = appendResult57_g15;
			#endif
			half _Big_Cascade_Noise_Flow_UV_Refresh_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Noise_Flow_UV_Refresh_Speed_arr, _Big_Cascade_Noise_Flow_UV_Refresh_Speed);
			half temp_output_68_0_g15 = ( _Time.y * _Big_Cascade_Noise_Flow_UV_Refresh_Speed_Instance );
			half temp_output_71_0_g15 = frac( ( temp_output_68_0_g15 + 0.0 ) );
			half2 temp_output_60_0_g15 = ( staticSwitch59_g15 * temp_output_71_0_g15 );
			half2 temp_output_83_0_g15 = ( ( 1.0 / GlobalTiling70 ) * ( temp_output_66_0_g15 * i.uv_texcoord ) );
			half2 temp_output_296_0 = ( float2( 0,0 ).x * float2( 0.03,0.03 ).x );
			half2 temp_output_80_0_g15 = ( staticSwitch59_g15 * frac( ( temp_output_68_0_g15 + -0.5 ) ) );
			half clampResult90_g15 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g15 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half lerpResult284 = lerp( SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_60_0_g15 + temp_output_83_0_g15 ) + temp_output_296_0 ) ).r , SAMPLE_TEXTURE2D( _Noise, sampler_Linear_Repeat_Aniso8, ( ( temp_output_83_0_g15 + temp_output_80_0_g15 ) + temp_output_296_0 ) ).r , clampResult90_g15);
			half _BigCascadeNoisePower_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeNoisePower_arr, _BigCascadeNoisePower);
			half _BigCascadeNoiseMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeNoiseMultiply_arr, _BigCascadeNoiseMultiply);
			half temp_output_299_0 = ( pow( abs( lerpResult284 ) , _BigCascadeNoisePower_Instance ) * _BigCascadeNoiseMultiply_Instance );
			half clampResult456 = clamp( temp_output_299_0 , 0.0 , 1.0 );
			half lerpResult261 = lerp( SAMPLE_TEXTURE2D( BigCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_91 ).r , SAMPLE_TEXTURE2D( BigCascadeWaterTess, sampler_Linear_Repeat_Aniso8, temp_output_256_93 ).r , temp_output_256_96);
			half _Big_Cascade_Foam_Height_Mask_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Foam_Height_Mask_arr, _Big_Cascade_Foam_Height_Mask);
			half temp_output_462_0 = pow( abs( lerpResult261 ) , _Big_Cascade_Foam_Height_Mask_Instance );
			half temp_output_455_0 = ( ( _Big_Cascade_Foam_Normal_Scale_Instance * temp_output_458_0 ) * ( clampResult456 * temp_output_462_0 ) );
			half2 temp_output_80_0_g34 = ( staticSwitch59_g34 * frac( ( temp_output_68_0_g34 + -0.5 ) ) );
			half2 temp_output_276_93 = ( temp_output_83_0_g34 + temp_output_80_0_g34 );
			half clampResult90_g34 = clamp( abs( sin( ( ( UNITY_PI * 1.5 ) + ( temp_output_71_0_g34 * UNITY_PI ) ) ) ) , 0.0 , 1.0 );
			half temp_output_276_96 = clampResult90_g34;
			half3 lerpResult263 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _Big_Cascade_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_276_91 ), temp_output_455_0 ) , UnpackScaleNormal( SAMPLE_TEXTURE2D( _Big_Cascade_Foam_Normal, sampler_Linear_Repeat_Aniso8, temp_output_276_93 ), temp_output_455_0 ) , temp_output_276_96);
			half3 temp_output_453_0 = BlendNormals( lerpResult282 , lerpResult263 );
			half3 lerpResult283 = lerp( lerpResult338 , temp_output_453_0 , BigCascadeAngle336);
			half4 break469 = i.vertexColor;
			half3 lerpResult465 = lerp( lerpResult283 , temp_output_339_0 , break469.g);
			half3 lerpResult466 = lerp( lerpResult465 , temp_output_453_0 , break469.b);
			half _FarNormalPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalPower_arr, _FarNormalPower);
			half3 appendResult483 = (half3(_FarNormalPower_Instance , _FarNormalPower_Instance , 1.0));
			half temp_output_470_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			half _FarNormalBlendStartDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendStartDistance_arr, _FarNormalBlendStartDistance);
			half _FarNormalBlendThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_FarNormalBlendThreshold_arr, _FarNormalBlendThreshold);
			half clampResult480 = clamp( pow( abs( ( temp_output_470_0 / _FarNormalBlendStartDistance_Instance ) ) , _FarNormalBlendThreshold_Instance ) , 0.0 , 1.0 );
			half3 lerpResult481 = lerp( lerpResult466 , ( lerpResult466 * appendResult483 ) , clampResult480);
			o.Normal = lerpResult481;
			half3 normalizeResult673 = normalize( lerpResult481 );
			half3 break42_g65 = normalizeResult673;
			half3 appendResult14_g65 = (half3(break42_g65.x , break42_g65.y , break42_g65.z));
			half _Distortion_Instance = UNITY_ACCESS_INSTANCED_PROP(_Distortion_arr, _Distortion);
			half temp_output_45_0_g65 = _Distortion_Instance;
			half3 temp_output_38_0_g65 = ( appendResult14_g65 * temp_output_45_0_g65 );
			half2 appendResult20_g65 = (half2(_ScreenParams.x , _ScreenParams.y));
			half2 temp_output_23_0_g65 = ( half2( 1,1 ) / appendResult20_g65 );
			half eyeDepth18_g65 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( ( floor( ( ( ase_screenPosNorm + half4( temp_output_38_0_g65 , 0.0 ) ) * half4( appendResult20_g65, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g65 ), 0.0 , 0.0 ) ).xy ));
			half temp_output_16_0_g65 = ( eyeDepth18_g65 - ase_screenDepth );
			half4 temp_output_35_0_g65 = ( ( floor( ( ase_screenPosNorm * half4( appendResult20_g65, 0.0 , 0.0 ) ) ) + float4( 0.5,0.5,0,0 ) ) * half4( abs( temp_output_23_0_g65 ), 0.0 , 0.0 ) );
			half4 temp_output_22_0_g65 = ( temp_output_35_0_g65 + half4( ( saturate( temp_output_16_0_g65 ) * ( temp_output_38_0_g65 / ase_screenPos.w ) ) , 0.0 ) );
			half4 ifLocalVar30_g65 = 0;
			if( temp_output_16_0_g65 >= 0.0 )
				ifLocalVar30_g65 = temp_output_22_0_g65;
			else
				ifLocalVar30_g65 = temp_output_35_0_g65;
			half4 temp_output_674_0 = ifLocalVar30_g65;
			half4 screenColor352 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_674_0.xy);
			half _Clean_Water_Background_Brightness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clean_Water_Background_Brightness_arr, _Clean_Water_Background_Brightness);
			half4 temp_output_415_0 = ( screenColor352 * _Clean_Water_Background_Brightness_Instance );
			half _Caustic_Intensivity_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Intensivity_arr, _Caustic_Intensivity);
			half4 _Caustic_Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Color_arr, _Caustic_Color);
			half _Caustic_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Falloff_arr, _Caustic_Falloff);
			half temp_output_44_0_g29 = _Caustic_Falloff_Instance;
			half3 appendResult34_g29 = (half3(temp_output_44_0_g29 , temp_output_44_0_g29 , temp_output_44_0_g29));
			half _Caustic_Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Tiling_arr, _Caustic_Tiling);
			half temp_output_42_0_g29 = _Caustic_Tiling_Instance;
			half2 temp_cast_14 = (temp_output_42_0_g29).xx;
			half _Caustic_Triplanar_Hardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Triplanar_Hardness_arr, _Caustic_Triplanar_Hardness);
			half temp_output_43_0_g29 = _Caustic_Triplanar_Hardness_Instance;
			half _Caustic_Speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Speed_arr, _Caustic_Speed);
			half temp_output_14_0_g29 = ( _Caustic_Speed_Instance * _Time.y );
			half3 appendResult16_g29 = (half3(temp_output_14_0_g29 , temp_output_14_0_g29 , temp_output_14_0_g29));
			half4 temp_output_38_0_g29 = temp_output_674_0;
			half4 temp_output_76_0_g32 = temp_output_38_0_g29;
			half2 UV22_g33 = temp_output_76_0_g32.xy;
			half2 localUnStereo22_g33 = UnStereo( UV22_g33 );
			half2 break64_g32 = localUnStereo22_g33;
			half clampDepth69_g32 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, temp_output_76_0_g32.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g32 = ( 1.0 - clampDepth69_g32 );
			#else
				float staticSwitch38_g32 = clampDepth69_g32;
			#endif
			half3 appendResult39_g32 = (half3(break64_g32.x , break64_g32.y , staticSwitch38_g32));
			half4 appendResult42_g32 = (half4((appendResult39_g32*2.0 + -1.0) , 1.0));
			half4 temp_output_43_0_g32 = mul( unity_CameraInvProjection, appendResult42_g32 );
			half3 temp_output_46_0_g32 = ( (temp_output_43_0_g32).xyz / (temp_output_43_0_g32).w );
			half3 In72_g32 = temp_output_46_0_g32;
			half3 localInvertDepthDir72_g32 = InvertDepthDir72_g32( In72_g32 );
			half4 appendResult49_g32 = (half4(localInvertDepthDir72_g32 , 1.0));
			half4 temp_output_48_0_g29 = mul( unity_CameraToWorld, appendResult49_g32 );
			float4 triplanar25_g29 = TriplanarSampling25_g29( _Caustic, sampler_Caustic, ( half4( ( appendResult16_g29 * float3( 0.76,0.73,0.79 ) ) , 0.0 ) + temp_output_48_0_g29 ).xyz, ase_worldNormal, temp_output_43_0_g29, temp_cast_14, 1.0, 0 );
			half3 appendResult35_g29 = (half3(triplanar25_g29.xyz));
			half2 temp_cast_19 = (temp_output_42_0_g29).xx;
			half temp_output_17_0_g29 = ( temp_output_14_0_g29 * -1.07 );
			half3 appendResult21_g29 = (half3(temp_output_17_0_g29 , temp_output_17_0_g29 , temp_output_17_0_g29));
			float4 triplanar26_g29 = TriplanarSampling26_g29( _Caustic, sampler_Caustic, ( half4( appendResult21_g29 , 0.0 ) + temp_output_48_0_g29 ).xyz, ase_worldNormal, temp_output_43_0_g29, temp_cast_19, 1.0, 0 );
			half3 appendResult36_g29 = (half3(triplanar26_g29.xyz));
			half3 clampResult37_g29 = clamp( ( appendResult34_g29 * min( appendResult35_g29 , appendResult36_g29 ) ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			half4 temp_cast_24 = (_Caustic_Intensivity_Instance).xxxx;
			half _Caustic_Blend_Instance = UNITY_ACCESS_INSTANCED_PROP(_Caustic_Blend_arr, _Caustic_Blend);
			half4 lerpResult425 = lerp( temp_output_415_0 , ( ( temp_output_415_0 / _Caustic_Intensivity_Instance ) + ( pow( abs( ( _Caustic_Color_Instance * half4( clampResult37_g29 , 0.0 ) ) ) , temp_cast_24 ) * _Caustic_Intensivity_Instance ) ) , _Caustic_Blend_Instance);
			#ifdef _USE_CAUSTIC
				half4 staticSwitch666 = lerpResult425;
			#else
				half4 staticSwitch666 = temp_output_415_0;
			#endif
			half4 _DeepColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_DeepColor_arr, _DeepColor);
			half4 _ShalowColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowColor_arr, _ShalowColor);
			half3 temp_output_41_0_g66 = temp_output_674_0.xyz;
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
			half temp_output_675_0 = ifLocalVar40_g66;
			half _ShalowFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffMultiply_arr, _ShalowFalloffMultiply);
			half _ShalowFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_ShalowFalloffPower_arr, _ShalowFalloffPower);
			half _BigCascadeTransparency_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeTransparency_arr, _BigCascadeTransparency);
			half lerpResult21 = lerp( pow( abs( ( temp_output_675_0 * _ShalowFalloffMultiply_Instance ) ) , ( _ShalowFalloffPower_Instance * -1.0 ) ) , 100.0 , ( _BigCascadeTransparency_Instance * BigCascadeAngle336 ));
			half clampResult16 = clamp( saturate( lerpResult21 ) , 0.0 , 1.0 );
			half4 lerpResult23 = lerp( _DeepColor_Instance , _ShalowColor_Instance , clampResult16);
			half4 tex2DNode184 = SAMPLE_TEXTURE2D( _SlowWaterTesselation, sampler_Linear_Repeat_Aniso8, temp_output_147_0 );
			half _SlowWaterTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_SlowWaterTranslucencyMultiply_arr, _SlowWaterTranslucencyMultiply);
			half clampResult486 = clamp( temp_output_253_0 , 0.0 , 1.0 );
			half _SmallCascadeTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeTranslucencyMultiply_arr, _SmallCascadeTranslucencyMultiply);
			half temp_output_487_0 = ( ( lerpResult214 * clampResult486 ) * _SmallCascadeTranslucencyMultiply_Instance );
			half lerpResult489 = lerp( ( ( tex2DNode184.r * _SlowWaterTranslucencyMultiply_Instance ) + ( lerpResult81 * _SlowWaterTranslucencyMultiply_Instance ) ) , temp_output_487_0 , SmallCascadeAngle335);
			half clampResult492 = clamp( temp_output_299_0 , 0.0 , 1.0 );
			half _BigCascadeTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeTranslucencyMultiply_arr, _BigCascadeTranslucencyMultiply);
			half temp_output_493_0 = ( ( lerpResult261 * clampResult492 ) * _BigCascadeTranslucencyMultiply_Instance );
			half lerpResult497 = lerp( lerpResult489 , temp_output_493_0 , BigCascadeAngle336);
			half lerpResult499 = lerp( lerpResult497 , temp_output_487_0 , break469.g);
			half lerpResult500 = lerp( lerpResult499 , ( temp_output_493_0 * BigCascadeAngle336 ) , break469.b);
			half _WaveTranslucencyHardness_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyHardness_arr, _WaveTranslucencyHardness);
			half _WaveTranslucencyPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyPower_arr, _WaveTranslucencyPower);
			half _WaveTranslucencyMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyMultiply_arr, _WaveTranslucencyMultiply);
			half _WaveTranslucencyFallOffDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveTranslucencyFallOffDistance_arr, _WaveTranslucencyFallOffDistance);
			half lerpResult508 = lerp( ( pow( abs( ( lerpResult500 * _WaveTranslucencyHardness_Instance ) ) , _WaveTranslucencyPower_Instance ) * _WaveTranslucencyMultiply_Instance ) , 0.0 , ( temp_output_470_0 / _WaveTranslucencyFallOffDistance_Instance ));
			half _Shore_Translucency_Multiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_Shore_Translucency_Multiply_arr, _Shore_Translucency_Multiply);
			half clampResult515 = clamp( ( _Shore_Translucency_Multiply_Instance * temp_output_675_0 ) , 0.0 , 1.0 );
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
			half clampResult43 = clamp( ( temp_output_675_0 * _WaterAlphaMultiply_Instance ) , 0.0 , 1.0 );
			half _WaterAlphaPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterAlphaPower_arr, _WaterAlphaPower);
			half clampResult42 = clamp( pow( abs( clampResult43 ) , _WaterAlphaPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult28 = lerp( ( lerpResult26 * staticSwitch666 ) , lerpResult26 , clampResult42);
			half _CleanFalloffMultiply_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffMultiply_arr, _CleanFalloffMultiply);
			half clampResult35 = clamp( ( temp_output_675_0 * _CleanFalloffMultiply_Instance ) , 0.0 , 1.0 );
			half _CleanFalloffPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_CleanFalloffPower_arr, _CleanFalloffPower);
			half clampResult34 = clamp( pow( abs( clampResult35 ) , _CleanFalloffPower_Instance ) , 0.0 , 1.0 );
			half4 lerpResult30 = lerp( staticSwitch666 , lerpResult28 , clampResult34);
			half3 _FoamColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamColor_arr, _FoamColor);
			half4 lerpResult589 = lerp( lerpResult30 , half4( _FoamColor_Instance , 0.0 ) , temp_output_580_0);
			half lerpResult227 = lerp( SAMPLE_TEXTURE2D( _SmallCascade, sampler_Linear_Repeat_Aniso8, temp_output_218_91 ).r , SAMPLE_TEXTURE2D( _SmallCascade, sampler_Linear_Repeat_Aniso8, temp_output_218_93 ).r , temp_output_218_96);
			half clampResult625 = clamp( temp_output_253_0 , 0.0 , 1.0 );
			half temp_output_623_0 = ( ( lerpResult227 * temp_output_344_0 ) * ( clampResult625 * temp_output_349_0 ) );
			half3 _SmallCascadeColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeColor_arr, _SmallCascadeColor);
			half3 temp_output_628_0 = ( temp_output_623_0 * _SmallCascadeColor_Instance );
			half _SmallCascadeFoamFalloff_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeFoamFalloff_arr, _SmallCascadeFoamFalloff);
			half clampResult634 = clamp( pow( abs( temp_output_623_0 ) , _SmallCascadeFoamFalloff_Instance ) , 0.0 , 1.0 );
			half lerpResult635 = lerp( 0.0 , clampResult634 , SmallCascadeAngle335);
			half4 lerpResult637 = lerp( lerpResult589 , half4( temp_output_628_0 , 0.0 ) , lerpResult635);
			half lerpResult275 = lerp( SAMPLE_TEXTURE2D( _BigCascade, sampler_Linear_Repeat_Aniso8, temp_output_276_91 ).r , SAMPLE_TEXTURE2D( _BigCascade, sampler_Linear_Repeat_Aniso8, temp_output_276_93 ).r , temp_output_276_96);
			half clampResult644 = clamp( temp_output_299_0 , 0.0 , 1.0 );
			half temp_output_643_0 = ( ( temp_output_458_0 * lerpResult275 ) * ( clampResult644 * temp_output_462_0 ) );
			half3 _BigCascadeColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeColor_arr, _BigCascadeColor);
			half3 temp_output_647_0 = ( temp_output_643_0 * _BigCascadeColor_Instance );
			half Big_Cascade_Foam_Falloff_Instance = UNITY_ACCESS_INSTANCED_PROP(Big_Cascade_Foam_Falloff_arr, Big_Cascade_Foam_Falloff);
			half clampResult650 = clamp( pow( abs( temp_output_643_0 ) , Big_Cascade_Foam_Falloff_Instance ) , 0.0 , 1.0 );
			half lerpResult653 = lerp( 0.0 , clampResult650 , BigCascadeAngle336);
			half4 lerpResult638 = lerp( lerpResult637 , half4( temp_output_647_0 , 0.0 ) , lerpResult653);
			half4 lerpResult639 = lerp( lerpResult30 , half4( temp_output_628_0 , 0.0 ) , clampResult634);
			half4 lerpResult641 = lerp( lerpResult638 , lerpResult639 , break469.g);
			half4 lerpResult656 = lerp( lerpResult30 , half4( temp_output_647_0 , 0.0 ) , clampResult650);
			half4 lerpResult640 = lerp( lerpResult641 , lerpResult656 , break469.b);
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
			half clampResult681 = clamp( switchResult661 , 0.0 , 1.0 );
			#ifdef DIRECTIONAL_COOKIE
				half staticSwitch677 = clampResult681;
			#else
				half staticSwitch677 = 1.0;
			#endif
			o.Albedo = ( lerpResult640 * staticSwitch677 ).rgb;
			half _Water_Specular_Far_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Far_arr, _Water_Specular_Far);
			half _Water_Specular_Close_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Specular_Close_arr, _Water_Specular_Close);
			half _WaterSpecularThreshold_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaterSpecularThreshold_arr, _WaterSpecularThreshold);
			half clampResult621 = clamp( pow( abs( clampResult16 ) , _WaterSpecularThreshold_Instance ) , 0.0 , 1.0 );
			half lerpResult616 = lerp( _Water_Specular_Far_Instance , _Water_Specular_Close_Instance , clampResult621);
			half _Side_Foam_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Side_Foam_Specular_arr, _Side_Foam_Specular);
			half lerpResult613 = lerp( lerpResult616 , _Side_Foam_Specular_Instance , temp_output_580_0);
			half _Small_Cascade_Foam_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Small_Cascade_Foam_Specular_arr, _Small_Cascade_Foam_Specular);
			half lerpResult611 = lerp( lerpResult613 , _Small_Cascade_Foam_Specular_Instance , lerpResult635);
			half _Big_Cascade_Foam_Specular_Instance = UNITY_ACCESS_INSTANCED_PROP(_Big_Cascade_Foam_Specular_arr, _Big_Cascade_Foam_Specular);
			half lerpResult610 = lerp( lerpResult611 , _Big_Cascade_Foam_Specular_Instance , lerpResult653);
			half lerpResult606 = lerp( lerpResult616 , _Small_Cascade_Foam_Specular_Instance , clampResult634);
			half lerpResult605 = lerp( lerpResult610 , lerpResult606 , break469.g);
			half lerpResult607 = lerp( lerpResult616 , _Big_Cascade_Foam_Specular_Instance , clampResult650);
			half lerpResult608 = lerp( lerpResult605 , lerpResult607 , break469.b);
			half3 temp_cast_34 = (( lerpResult608 * staticSwitch677 )).xxx;
			o.Specular = temp_cast_34;
			half _NMWaterSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_NMWaterSmoothness_arr, _NMWaterSmoothness);
			half _NMFoamSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_NMFoamSmoothness_arr, _NMFoamSmoothness);
			half lerpResult592 = lerp( _NMWaterSmoothness_Instance , _NMFoamSmoothness_Instance , temp_output_580_0);
			half _SmallCascadeSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmallCascadeSmoothness_arr, _SmallCascadeSmoothness);
			half lerpResult596 = lerp( lerpResult592 , _SmallCascadeSmoothness_Instance , lerpResult635);
			half _BigCascadeSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_BigCascadeSmoothness_arr, _BigCascadeSmoothness);
			half lerpResult598 = lerp( lerpResult596 , _BigCascadeSmoothness_Instance , lerpResult653);
			half lerpResult604 = lerp( _NMWaterSmoothness_Instance , _SmallCascadeSmoothness_Instance , clampResult634);
			half lerpResult601 = lerp( lerpResult598 , lerpResult604 , break469.g);
			half lerpResult602 = lerp( _NMWaterSmoothness_Instance , _BigCascadeSmoothness_Instance , clampResult650);
			half lerpResult600 = lerp( lerpResult601 , lerpResult602 , break469.b);
			o.Smoothness = lerpResult600;
			half _AOPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AOPower_arr, _AOPower);
			o.Occlusion = ( _AOPower_Instance * staticSwitch677 );
			o.Alpha = clampResult681;
		}

		ENDCG
	}
	Fallback "Diffuse"
}