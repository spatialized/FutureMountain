// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersTreeBarkSpecularSnow' to new syntax.

Shader "NatureManufacture Shaders/Tree Bark Specular Snow"
{
	Properties
	{
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 1
		_SpecularRGBSmothnessA("Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		_AmbientOcclusionA("Ambient Occlusion (A)", 2D) = "gray" {}
		[HideInInspector]_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailMask("DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_DetailNormalMap("DetailNormalMap", 2D) = "bump" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 1
		_DetailAmbientOcclusionG("Detail Ambient Occlusion (G)", 2D) = "gray" {}
		_DetailAmbientOcclusionPower("Detail Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailSpecularRGBSmothnessA("Detail Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SnowCover("Snow Cover", 2D) = "white" {}
		_SnowCoverNormal("Snow Cover Normal", 2D) = "bump" {}
		_SnowCoverSpecularRGBSmothnessA("Snow Cover Specular (RGB) Smothness (A)", 2D) = "gray" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 0
		_SnowSmothnessPower("Snow Smothness Power", Range( 0 , 2)) = 0
		_SnowCoverAmbientOcclusionG("Snow Cover Ambient Occlusion (G)", 2D) = "gray" {}
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		[Toggle] _WindVertexColorMainR("Wind Vertex Color Main (R)", Float) = 0.0
		_WindPower("Wind Power", Range( 0 , 3)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WINDVERTEXCOLORMAINR_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			fixed2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
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
		uniform sampler2D _SnowCoverNormal;
		uniform sampler2D _SnowCover;
		uniform float4 _SnowCover_ST;
		uniform fixed _Snow_Amount;
		uniform fixed4 _Color;
		uniform sampler2D _SpecularRGBSmothnessA;
		uniform sampler2D _DetailSpecularRGBSmothnessA;
		uniform sampler2D _SnowCoverSpecularRGBSmothnessA;
		uniform sampler2D _AmbientOcclusionA;
		uniform sampler2D _DetailAmbientOcclusionG;
		uniform sampler2D _SnowCoverAmbientOcclusionG;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersTreeBarkSpecularSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SpecularPower)
#define _SpecularPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSpecularPower)
#define _SnowSpecularPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmothnessPower)
#define _SmothnessPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSmothnessPower)
#define _SnowSmothnessPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _DetailAmbientOcclusionPower)
#define _DetailAmbientOcclusionPower_arr NatureManufactureShadersTreeBarkSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowAmbientOcclusionPower)
#define _SnowAmbientOcclusionPower_arr NatureManufactureShadersTreeBarkSpecularSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersTreeBarkSpecularSnow)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult94 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime121 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult119 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_126_0 = sin( ( mulTime121 + ( appendResult119 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult150 = clamp( ( temp_output_126_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult133 = lerp( temp_output_126_0 , ( 1.0 - temp_output_126_0 ) , clampResult150.x);
			float2 appendResult143 = (fixed2(( lerpResult133.x + 0.3 ) , lerpResult133.y));
			float2 appendResult124 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime125 = _Time.y * 0.0004;
			float2 temp_output_135_0 = sin( ( ( ( appendResult124 * mulTime125 ) + appendResult119 ) * float2( 0.6,0.8 ) ) );
			float cos137 = cos( _SinTime.w );
			float sin137 = sin( _SinTime.w );
			float2 rotator137 = mul( temp_output_135_0 - float2( 0.1,0.3 ) , float2x2( cos137 , -sin137 , sin137 , cos137 )) + float2( 0.1,0.3 );
			float cos136 = cos( temp_output_135_0.x );
			float sin136 = sin( temp_output_135_0.x );
			float2 rotator136 = mul( temp_output_135_0 - float2( 1,0.9 ) , float2x2( cos136 , -sin136 , sin136 , cos136 )) + float2( 1,0.9 );
			float2 clampResult139 = clamp( lerpResult133 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult140 = lerp( rotator137 , rotator136 , clampResult139.x);
			float2 clampResult142 = clamp( lerpResult140 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float3 appendResult103 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult94 * float2( 0.8,0.8 ) ) + ( appendResult143 + clampResult142 ) ) ).x , 0.0 , ( ( v.color.r * _WindPower ) * ( ( appendResult94 * float2( 0.8,0.8 ) ) + ( appendResult143 + clampResult142 ) ) ).y));
			fixed3 temp_cast_3 = (0.0).xxx;
			#ifdef _WINDVERTEXCOLORMAINR_ON
				float3 staticSwitch101 = appendResult103;
			#else
				float3 staticSwitch101 = temp_cast_3;
			#endif
			float4 transform104 = mul(unity_WorldToObject,fixed4( staticSwitch101 , 0.0 ));
			v.vertex.xyz += transform104.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			fixed4 tex2DNode25 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult19 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormalMap, uv_DetailAlbedoMap ) ,_DetailNormalMapScale ) , tex2DNode25.a);
			float2 uv_SnowCover = i.uv_texcoord * _SnowCover_ST.xy + _SnowCover_ST.zw;
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float3 lerpResult29 = lerp( lerpResult19 , UnpackNormal( tex2D( _SnowCoverNormal, uv_SnowCover ) ) , saturate( ( ase_worldNormal.y * _Snow_Amount ) ));
			o.Normal = lerpResult29;
			float4 lerpResult16 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) , tex2DNode25.a);
			float3 newWorldNormal40 = WorldNormalVector( i , lerpResult29 );
			float temp_output_33_0 = saturate( ( newWorldNormal40.y * _Snow_Amount ) );
			float4 lerpResult28 = lerp( ( lerpResult16 * _Color ) , tex2D( _SnowCover, uv_SnowCover ) , temp_output_33_0);
			o.Albedo = lerpResult28.rgb;
			float4 lerpResult18 = lerp( tex2D( _SpecularRGBSmothnessA, uv_MainTex ) , tex2D( _DetailSpecularRGBSmothnessA, uv_DetailAlbedoMap ) , tex2DNode25.a);
			float3 appendResult48 = (fixed3(lerpResult18.r , lerpResult18.g , lerpResult18.b));
			fixed _SpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SpecularPower_arr, _SpecularPower);
			fixed4 tex2DNode45 = tex2D( _SnowCoverSpecularRGBSmothnessA, uv_SnowCover );
			float3 appendResult49 = (fixed3(tex2DNode45.r , tex2DNode45.g , tex2DNode45.b));
			fixed _SnowSpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSpecularPower_arr, _SnowSpecularPower);
			float3 lerpResult38 = lerp( ( appendResult48 * _SpecularPower_Instance ) , ( appendResult49 * _SnowSpecularPower_Instance ) , temp_output_33_0);
			o.Specular = lerpResult38;
			fixed _SmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmothnessPower_arr, _SmothnessPower);
			fixed _SnowSmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSmothnessPower_arr, _SnowSmothnessPower);
			float lerpResult37 = lerp( ( lerpResult18.a * _SmothnessPower_Instance ) , ( tex2DNode45.a * _SnowSmothnessPower_Instance ) , temp_output_33_0);
			o.Smoothness = lerpResult37;
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult64 = clamp( tex2D( _AmbientOcclusionA, uv_MainTex ).g , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			fixed _DetailAmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailAmbientOcclusionPower_arr, _DetailAmbientOcclusionPower);
			float clampResult66 = clamp( tex2D( _DetailAmbientOcclusionG, uv_DetailAlbedoMap ).g , ( 1.0 - _DetailAmbientOcclusionPower_Instance ) , 1.0 );
			float lerpResult53 = lerp( clampResult64 , clampResult66 , tex2DNode25.a);
			fixed _SnowAmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAmbientOcclusionPower_arr, _SnowAmbientOcclusionPower);
			float clampResult62 = clamp( tex2D( _SnowCoverAmbientOcclusionG, uv_SnowCover ).g , ( 1.0 - _SnowAmbientOcclusionPower_Instance ) , 1.0 );
			float lerpResult39 = lerp( lerpResult53 , clampResult62 , temp_output_33_0);
			o.Occlusion = lerpResult39;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows dithercrossfade vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}