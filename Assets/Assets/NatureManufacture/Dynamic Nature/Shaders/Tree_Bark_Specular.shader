// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersTreeBarkSpecular' to new syntax.

Shader "NatureManufacture Shaders/Tree Bark Specular"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 1
		_SpecularRGBSmothnessA("Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailMask("DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_DetailNormal("Detail Normal", 2D) = "bump" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 1
		_DetailSpecularRGBSmothnessA("Detail Specular (RGB) Smothness (A)", 2D) = "white" {}
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_DetailAmbientOcclusionG("Detail Ambient Occlusion (G)", 2D) = "white" {}
		_WindPowerDirectionZX("Wind Power Direction ZX", Range( -1 , 1)) = 1
		_WindPower("Wind Power", Range( 0 , 3)) = 0.3
		[Toggle]_WindVertexColorMainR("Wind Vertex Color Main (R)", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WINDVERTEXCOLORMAINR_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			fixed2 uv_texcoord;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed _DetailNormalMapScale;
		uniform sampler2D _DetailNormal;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform fixed4 _Color;
		uniform sampler2D _SpecularRGBSmothnessA;
		uniform sampler2D _DetailSpecularRGBSmothnessA;
		uniform sampler2D _AmbientOcclusionG;
		uniform sampler2D _DetailAmbientOcclusionG;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZX;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersTreeBarkSpecular)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SpecularPower)
#define _SpecularPower_arr NatureManufactureShadersTreeBarkSpecular
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmothnessPower)
#define _SmothnessPower_arr NatureManufactureShadersTreeBarkSpecular
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersTreeBarkSpecular
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersTreeBarkSpecular)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult61 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZX));
			float mulTime87 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult85 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_92_0 = sin( ( mulTime87 + ( appendResult85 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult116 = clamp( ( temp_output_92_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult99 = lerp( temp_output_92_0 , ( 1.0 - temp_output_92_0 ) , clampResult116.x);
			float2 appendResult109 = (fixed2(( lerpResult99.x + 0.3 ) , lerpResult99.y));
			float2 appendResult90 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime91 = _Time.y * 0.0004;
			float2 temp_output_101_0 = sin( ( ( appendResult85 + ( appendResult90 * mulTime91 ) ) * float2( 0.6,0.8 ) ) );
			float cos103 = cos( _SinTime.w );
			float sin103 = sin( _SinTime.w );
			float2 rotator103 = mul( temp_output_101_0 - float2( 0.1,0.3 ) , float2x2( cos103 , -sin103 , sin103 , cos103 )) + float2( 0.1,0.3 );
			float cos102 = cos( temp_output_101_0.x );
			float sin102 = sin( temp_output_101_0.x );
			float2 rotator102 = mul( temp_output_101_0 - float2( 1,0.9 ) , float2x2( cos102 , -sin102 , sin102 , cos102 )) + float2( 1,0.9 );
			float2 clampResult105 = clamp( lerpResult99 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult106 = lerp( rotator103 , rotator102 , clampResult105.x);
			float2 clampResult108 = clamp( lerpResult106 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float3 appendResult70 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult61 * float2( 0.8,0.8 ) ) + ( appendResult109 + clampResult108 ) ) ).x , 0.0 , ( ( v.color.r * _WindPower ) * ( ( appendResult61 * float2( 0.8,0.8 ) ) + ( appendResult109 + clampResult108 ) ) ).y));
			fixed3 temp_cast_3 = (0.0).xxx;
			#ifdef _WINDVERTEXCOLORMAINR_ON
				float3 staticSwitch68 = appendResult70;
			#else
				float3 staticSwitch68 = temp_cast_3;
			#endif
			float4 transform71 = mul(unity_WorldToObject,fixed4( staticSwitch68 , 0.0 ));
			v.vertex.xyz += transform71.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			fixed4 tex2DNode25 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult19 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormal, uv_DetailAlbedoMap ) ,_DetailNormalMapScale ) , tex2DNode25.a);
			o.Normal = lerpResult19;
			float4 lerpResult16 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) , tex2DNode25.a);
			o.Albedo = ( lerpResult16 * _Color ).rgb;
			float4 lerpResult18 = lerp( tex2D( _SpecularRGBSmothnessA, uv_MainTex ) , tex2D( _DetailSpecularRGBSmothnessA, uv_DetailAlbedoMap ) , tex2DNode25.a);
			float3 appendResult29 = (fixed3(lerpResult18.r , lerpResult18.g , lerpResult18.b));
			fixed _SpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SpecularPower_arr, _SpecularPower);
			o.Specular = ( appendResult29 * _SpecularPower_Instance );
			fixed _SmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmothnessPower_arr, _SmothnessPower);
			o.Smoothness = ( lerpResult18.a * _SmothnessPower_Instance );
			float lerpResult30 = lerp( tex2D( _AmbientOcclusionG, uv_MainTex ).g , tex2D( _DetailAmbientOcclusionG, uv_DetailAlbedoMap ).g , tex2DNode25.a);
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult34 = clamp( lerpResult30 , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			o.Occlusion = clampResult34;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}