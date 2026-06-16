Shader "NatureManufacture Shaders/Terrain Snow Cover World Mapped"
{
	Properties
	{
		_SnowAmount("SnowAmount", Range( 0 , 2)) = 0.13
		_SnowAngleHardness("Snow Angle Hardness", Range( 0.01 , 10)) = 1
		_SnowMaxAngle("Snow Max Angle", Range( 0.001 , 90)) = 20
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.22
		_SpecularPower("Specular Power", Range( 0.01 , 2)) = 1
		_Albedo_1RGBSmothnessA("Albedo_1 (RGB) Smothness (A)", 2D) = "white" {}
		_Albedo1SnowReduction("Albedo 1 Snow Reduction", Range( -1 , 1)) = 0
		_Texture1Tilling("Texture 1 Tilling", Range( 0 , 100)) = 0.5
		_Normal_1RGB("Normal_1 (RGB)", 2D) = "bump" {}
		_Normal1Power("Normal 1 Power", Range( 0 , 5)) = 1
		_Albedo_2RGBSmothnessA("Albedo_2 (RGB) Smothness (A)", 2D) = "white" {}
		_Texture2Tilling("Texture 2 Tilling", Range( 0 , 100)) = 0.5
		_Albedo2SnowReduction("Albedo 2 Snow Reduction", Range( -1 , 1)) = 0
		_Normal_2RGB("Normal_2 (RGB)", 2D) = "bump" {}
		_Normal2Power("Normal 2 Power", Range( 0 , 5)) = 1
		_Albedo_3RGBSmothnessA("Albedo_3 (RGB) Smothness (A)", 2D) = "white" {}
		_Albedo3SnowReduction("Albedo 3 Snow Reduction", Range( -1 , 1)) = 0
		_Texture3Tilling("Texture 3 Tilling", Range( 0 , 100)) = 0.5
		_Normal_3RGB("Normal_3 (RGB) ", 2D) = "bump" {}
		_Normal3Power("Normal 3 Power", Range( 0 , 5)) = 1
		_Albedo_4RGBSmothnessA("Albedo_4 (RGB) Smothness (A)", 2D) = "white" {}
		_Texture4Tilling("Texture 4 Tilling", Range( 0 , 100)) = 0.5
		_Albedo4SnowReduction("Albedo 4 Snow Reduction", Range( -1 , 1)) = 0
		_Normal_4RGB("Normal_4 (RGB)", 2D) = "bump" {}
		_Normal4Power("Normal 4 Power", Range( 0 , 5)) = 1
		_Splat_Map_1("Splat_Map_1", 2D) = "white" {}
		_SnowAlbedoRGBSpecularA("Snow Albedo (RGB) Specular (A)", 2D) = "white" {}
		_SnowTextureTilling("Snow Texture Tilling", Range( 0 , 100)) = 0.5
		_SnowSpecularPower("Snow Specular Power", Range( 0.01 , 2)) = 1
		_SnowSmoothness("Snow Smoothness", Range( 0 , 1)) = 0.22
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_SnowNormalPower("Snow Normal Power", Range( 0 , 5)) = 1
		_SnowNoiseCover("Snow Noise Cover", 2D) = "white" {}
		_SnowNoiseTilling("Snow Noise Tilling", Range( 0 , 100)) = 1
		_SnowCoverMix_1("Snow Cover Mix_1", Vector) = (0.23,0.23,0,0)
		_SnowCoverMix_2("Snow Cover Mix_2", Vector) = (0.53,0.53,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float3 worldPos;
			float2 texcoord_0;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform fixed _Normal1Power;
		uniform sampler2D _Normal_1RGB;
		uniform fixed _Texture1Tilling;
		uniform sampler2D _Splat_Map_1;
		uniform fixed _Normal2Power;
		uniform sampler2D _Normal_2RGB;
		uniform fixed _Texture2Tilling;
		uniform fixed _Normal3Power;
		uniform sampler2D _Normal_3RGB;
		uniform fixed _Texture3Tilling;
		uniform fixed _Normal4Power;
		uniform sampler2D _Normal_4RGB;
		uniform fixed _Texture4Tilling;
		uniform fixed _SnowNormalPower;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _SnowTextureTilling;
		uniform fixed _SnowAmount;
		uniform fixed _Albedo3SnowReduction;
		uniform fixed _Albedo4SnowReduction;
		uniform fixed _Albedo2SnowReduction;
		uniform fixed _Albedo1SnowReduction;
		uniform sampler2D _Albedo_1RGBSmothnessA;
		uniform sampler2D _Albedo_2RGBSmothnessA;
		uniform sampler2D _Albedo_3RGBSmothnessA;
		uniform sampler2D _Albedo_4RGBSmothnessA;
		uniform sampler2D _SnowAlbedoRGBSpecularA;
		uniform sampler2D _SnowNoiseCover;
		uniform fixed _SnowNoiseTilling;
		uniform fixed2 _SnowCoverMix_2;
		uniform fixed2 _SnowCoverMix_1;
		uniform fixed _SnowMaxAngle;
		uniform fixed _SnowAngleHardness;
		uniform fixed _SpecularPower;
		uniform fixed _SnowSpecularPower;
		uniform fixed _Smoothness;
		uniform fixed _SnowSmoothness;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			fixed3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += 0.0;
			 v.tangent.xyz=cross( ase_worldNormal , fixed3(0,0,1) );
			 v.tangent.w = -1;//;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult195 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_193_0 = ( appendResult195 * _Texture1Tilling );
			fixed4 tex2DNode4 = tex2D( _Splat_Map_1, i.texcoord_0 );
			fixed Splat_1_R6 = tex2DNode4.r;
			fixed Splat_1_G7 = tex2DNode4.g;
			float clampResult23 = clamp( ( Splat_1_R6 + Splat_1_G7 ) , 0.0 , 1.0 );
			float3 lerpResult31 = lerp( float3( 0,0,0 ) , UnpackScaleNormal( tex2D( _Normal_1RGB, temp_output_193_0 ) ,_Normal1Power ) , clampResult23);
			float2 temp_output_197_0 = ( appendResult195 * _Texture2Tilling );
			float3 lerpResult32 = lerp( lerpResult31 , UnpackScaleNormal( tex2D( _Normal_2RGB, temp_output_197_0 ) ,_Normal2Power ) , Splat_1_G7);
			float2 temp_output_198_0 = ( appendResult195 * _Texture3Tilling );
			fixed Splat_1_B8 = tex2DNode4.b;
			float3 lerpResult33 = lerp( lerpResult32 , UnpackScaleNormal( tex2D( _Normal_3RGB, temp_output_198_0 ) ,_Normal3Power ) , Splat_1_B8);
			float2 temp_output_199_0 = ( appendResult195 * _Texture4Tilling );
			fixed Splat_1_A9 = tex2DNode4.a;
			float3 lerpResult34 = lerp( lerpResult33 , UnpackScaleNormal( tex2D( _Normal_4RGB, temp_output_199_0 ) ,_Normal4Power ) , Splat_1_A9);
			float2 temp_output_200_0 = ( appendResult195 * _SnowTextureTilling );
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float clampResult181 = clamp( ( ( _Albedo3SnowReduction * Splat_1_B8 ) + ( _Albedo4SnowReduction * Splat_1_A9 ) + ( _Albedo2SnowReduction * Splat_1_G7 ) + ( _Albedo1SnowReduction * clampResult23 ) ) , 0.0 , 1.0 );
			float lerpResult160 = lerp( saturate( ( ase_worldNormal.y * _SnowAmount ) ) , 0.0 , clampResult181);
			float3 lerpResult83 = lerp( lerpResult34 , UnpackScaleNormal( tex2D( _SnowNormalRGB, temp_output_200_0 ) ,_SnowNormalPower ) , lerpResult160);
			float3 lerpResult183 = lerp( lerpResult83 , lerpResult34 , clampResult181);
			float3 normalizeResult182 = normalize( lerpResult183 );
			o.Normal = normalizeResult182;
			float4 lerpResult24 = lerp( float4( 0,0,0,0 ) , tex2D( _Albedo_1RGBSmothnessA, temp_output_193_0 ) , clampResult23);
			float4 lerpResult25 = lerp( lerpResult24 , tex2D( _Albedo_2RGBSmothnessA, temp_output_197_0 ) , Splat_1_G7);
			float4 lerpResult26 = lerp( lerpResult25 , tex2D( _Albedo_3RGBSmothnessA, temp_output_198_0 ) , Splat_1_B8);
			float4 lerpResult27 = lerp( lerpResult26 , tex2D( _Albedo_4RGBSmothnessA, temp_output_199_0 ) , Splat_1_A9);
			fixed4 tex2DNode78 = tex2D( _SnowAlbedoRGBSpecularA, temp_output_200_0 );
			float3 newWorldNormal81 = WorldNormalVector( i , lerpResult83 );
			fixed3 temp_cast_0 = (newWorldNormal81.y).xxx;
			float temp_output_137_0 = ( _SnowAmount * 3.0 );
			float2 temp_output_142_0 = ( i.texcoord_0 * _SnowNoiseTilling );
			float3 appendResult128 = (fixed3(( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).r , ( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).g , ( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).b));
			float4 clampResult135 = clamp( ( CalculateContrast(temp_output_137_0,fixed4( appendResult128 , 0.0 )) * temp_output_137_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float clampResult118 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_107_0 = ( 1.0 - ( _SnowMaxAngle / 90.0 ) );
			float clampResult109 = clamp( ( clampResult118 - temp_output_107_0 ) , 0.0 , 2.0 );
			float temp_output_112_0 = pow( ( 1.0 - ( clampResult109 * ( 1.0 / ( 1.0 - temp_output_107_0 ) ) ) ) , _SnowAngleHardness );
			float4 lerpResult139 = lerp( ( 1.0 - clampResult135 ) , float4( 1,0,0,0 ) , temp_output_112_0);
			float3 lerpResult123 = lerp( temp_cast_0 , lerpResult34 , lerpResult139.r);
			float3 lerpResult165 = lerp( saturate( ( lerpResult123 * _SnowAmount ) ) , float3( 0,0,0 ) , clampResult181);
			float4 lerpResult91 = lerp( lerpResult27 , tex2DNode78 , lerpResult165.x);
			float3 appendResult54 = (fixed3(lerpResult91.r , lerpResult91.g , lerpResult91.b));
			o.Albedo = appendResult54;
			float4 lerpResult209 = lerp( float4( 0,0,0,0 ) , lerpResult91 , ( lerpResult27.a * _SpecularPower ));
			float4 lerpResult210 = lerp( float4( 0,0,0,0 ) , tex2DNode78 , ( tex2DNode78.a * _SnowSpecularPower ));
			float4 lerpResult186 = lerp( lerpResult209 , lerpResult210 , lerpResult165.x);
			o.Specular = lerpResult186.rgb;
			float lerpResult190 = lerp( _Smoothness , _SnowSmoothness , lerpResult165.x);
			o.Smoothness = lerpResult190;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
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