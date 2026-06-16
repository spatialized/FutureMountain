// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersTreeBarkMetalic' to new syntax.

Shader "NatureManufacture Shaders/Tree Bark Metalic"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 1
		_MetalicRAOGSmothnessA("Metalic (R) AO (G) Smothness (A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 0
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		_DetailMask("DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_DetailNormalMap("DetailNormalMap", 2D) = "bump" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 1
		_DetailMetalicRAOGSmothnessA("Detail Metalic (R) AO (G) Smothness (A) ", 2D) = "white" {}
		[Toggle]_WindVertexColorMainR("Wind Vertex Color Main (R)", Int) = 0
		_WindPower("Wind Power", Range( 0 , 1)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			fixed2 uv_texcoord;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed _DetailNormalMapScale;
		uniform sampler2D _DetailNormalMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform fixed4 _Color;
		uniform sampler2D _MetalicRAOGSmothnessA;
		uniform sampler2D _DetailMetalicRAOGSmothnessA;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersTreeBarkMetalic)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _MetalicPower)
#define _MetalicPower_arr NatureManufactureShadersTreeBarkMetalic
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmothnessPower)
#define _SmothnessPower_arr NatureManufactureShadersTreeBarkMetalic
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersTreeBarkMetalic
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersTreeBarkMetalic)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult136 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime169 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult168 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_174_0 = sin( ( mulTime169 + ( appendResult168 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult267 = clamp( ( temp_output_174_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult196 = lerp( temp_output_174_0 , ( 1.0 - temp_output_174_0 ) , clampResult267.x);
			float2 appendResult193 = (fixed2(( lerpResult196.x + 0.3 ) , lerpResult196.y));
			float2 appendResult173 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime175 = _Time.y * 0.0004;
			float2 temp_output_183_0 = sin( ( ( appendResult168 + ( appendResult173 * mulTime175 ) ) * float2( 0.6,0.8 ) ) );
			float cos184 = cos( _SinTime.w );
			float sin184 = sin( _SinTime.w );
			float2 rotator184 = mul( temp_output_183_0 - float2( 0.1,0.3 ) , float2x2( cos184 , -sin184 , sin184 , cos184 )) + float2( 0.1,0.3 );
			float cos185 = cos( temp_output_183_0.x );
			float sin185 = sin( temp_output_183_0.x );
			float2 rotator185 = mul( temp_output_183_0 - float2( 1,0.9 ) , float2x2( cos185 , -sin185 , sin185 , cos185 )) + float2( 1,0.9 );
			float2 clampResult186 = clamp( lerpResult196 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult187 = lerp( rotator184 , rotator185 , clampResult186.x);
			float2 clampResult188 = clamp( lerpResult187 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float3 appendResult145 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult136 * float2( 0.8,0.8 ) ) + ( appendResult193 + clampResult188 ) ) ).x , 0.0 , ( ( v.color.r * _WindPower ) * ( ( appendResult136 * float2( 0.8,0.8 ) ) + ( appendResult193 + clampResult188 ) ) ).y));
			fixed3 temp_cast_3 = (0.0).xxx;
			#ifdef _WINDVERTEXCOLORMAINR_ON
				float3 staticSwitch150 = appendResult145;
			#else
				float3 staticSwitch150 = temp_cast_3;
			#endif
			float4 transform151 = mul(unity_WorldToObject,fixed4( staticSwitch150 , 0.0 ));
			v.vertex.xyz += transform151.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			fixed4 tex2DNode25 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult19 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormalMap, uv_DetailAlbedoMap ) ,_DetailNormalMapScale ) , tex2DNode25.a);
			o.Normal = lerpResult19;
			float4 lerpResult16 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) , tex2DNode25.a);
			o.Albedo = ( lerpResult16 * _Color ).rgb;
			float4 lerpResult18 = lerp( tex2D( _MetalicRAOGSmothnessA, uv_MainTex ) , tex2D( _DetailMetalicRAOGSmothnessA, uv_DetailAlbedoMap ) , tex2DNode25.a);
			fixed _MetalicPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetalicPower_arr, _MetalicPower);
			o.Metallic = ( lerpResult18.r * _MetalicPower_Instance );
			fixed _SmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmothnessPower_arr, _SmothnessPower);
			o.Smoothness = ( lerpResult18.a * _SmothnessPower_Instance );
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult31 = clamp( lerpResult18.g , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			o.Occlusion = clampResult31;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}