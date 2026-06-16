Shader "NatureManufacture Shaders/Terrain Snow Cover World Mapped uvFree"
{
	Properties
	{
		_Splat_Map_1("Splat_Map_1", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 1)) = 0.01
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.2
		_Texture1_AlbedoRGB_Smoothness_A("Texture 1_Albedo (RGB)_Smoothness_(A)", 2D) = "white" {}
		_Texture1Tiling("Texture 1 Tiling", Range( 0 , 100)) = 15
		_Texture1_NormalRGB("Texture 1_Normal (RGB)", 2D) = "bump" {}
		_Texture1TriplanarFalloff("Texture 1 Triplanar Falloff", Range( 0 , 100)) = 100
		_Texture2_AlbedoRGB_Smoothness_A("Texture 2_Albedo (RGB)_Smoothness_(A)", 2D) = "white" {}
		_Texture2Tiling("Texture 2 Tiling", Range( 0 , 100)) = 15
		_Texture2TriplanarFalloff("Texture 2 Triplanar Falloff", Range( 0 , 100)) = 100
		_Texture2_NormalRGB("Texture 2_Normal (RGB)", 2D) = "bump" {}
		_Texture3_AlbedoRGB_Smoothness_A("Texture 3_Albedo (RGB)_Smoothness_(A)", 2D) = "white" {}
		_Texture3Tiling("Texture 3 Tiling", Range( 0 , 100)) = 15
		_Texture3TriplanarFalloff("Texture 3 Triplanar Falloff", Range( 0 , 100)) = 100
		_Texture3_NormalRGB("Texture 3_Normal (RGB)", 2D) = "bump" {}
		_Texture4_AlbedoRGB_Smoothness_A("Texture 4_Albedo (RGB)_Smoothness_(A)", 2D) = "white" {}
		_Texture4Tiling("Texture 4 Tiling", Range( 0 , 100)) = 0.5
		_Texture4TriplanarFalloff("Texture 4 Triplanar Falloff", Range( 0 , 100)) = 100
		_Texture4_NormalRGB("Texture 4_Normal (RGB)", 2D) = "bump" {}
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_SnowSmoothness("Snow Smoothness", Range( 0 , 1)) = 0.2
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 1)) = 0.01
		_SnowMaxAngle("Snow Max Angle", Range( 0.001 , 90)) = 20
		_SnowAngleHardness("Snow Angle Hardness", Range( 0.01 , 10)) = 1
		_SnowAlbedoRGBSpecularA("Snow Albedo (RGB) Specular (A)", 2D) = "white" {}
		_SnowTiling("Snow Tiling", Range( 0 , 100)) = 0.5
		_SnowTriplanarFalloff("Snow Triplanar Falloff", Range( 0 , 100)) = 100
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_Albedo1SnowReduction("Albedo 1 Snow Reduction", Range( -1 , 1)) = 0
		_Albedo2SnowReduction("Albedo 2 Snow Reduction", Range( -1 , 1)) = 0
		_Albedo3SnowReduction("Albedo 3 Snow Reduction", Range( -1 , 1)) = 0
		_Albedo4SnowReduction("Albedo 4 Snow Reduction", Range( -1 , 1)) = 0
		_SnowNoiseCover("Snow Noise Cover", 2D) = "white" {}
		_SnowNoiseTiling("Snow Noise Tiling", Range( 0 , 100)) = 1
		_SnowCoverMix_1("Snow Cover Mix_1", Vector) = (0.23,0.23,0,0)
		_SnowCoverMix_2("Snow Cover Mix_2", Vector) = (0.53,0.53,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture1_NormalRGB;
		uniform float _Texture1Tiling;
		uniform float _Texture1TriplanarFalloff;
		uniform sampler2D _Splat_Map_1;
		uniform float4 _Texture1_NormalRGB_ST;
		uniform sampler2D _Texture2_NormalRGB;
		uniform float _Texture2Tiling;
		uniform float _Texture2TriplanarFalloff;
		uniform sampler2D _Texture3_NormalRGB;
		uniform float _Texture3Tiling;
		uniform float _Texture3TriplanarFalloff;
		uniform sampler2D _Texture4_NormalRGB;
		uniform float _Texture4Tiling;
		uniform float _Texture4TriplanarFalloff;
		uniform sampler2D _SnowNormalRGB;
		uniform float _SnowTiling;
		uniform float _SnowTriplanarFalloff;
		uniform float _Snow_Amount;
		uniform float _Albedo3SnowReduction;
		uniform float _Albedo4SnowReduction;
		uniform float _Albedo2SnowReduction;
		uniform float _Albedo1SnowReduction;
		uniform sampler2D _Texture1_AlbedoRGB_Smoothness_A;
		uniform sampler2D _Texture2_AlbedoRGB_Smoothness_A;
		uniform sampler2D _Texture3_AlbedoRGB_Smoothness_A;
		uniform sampler2D _Texture4_AlbedoRGB_Smoothness_A;
		uniform sampler2D _SnowAlbedoRGBSpecularA;
		uniform sampler2D _SnowNoiseCover;
		uniform float _SnowNoiseTiling;
		uniform float2 _SnowCoverMix_2;
		uniform float2 _SnowCoverMix_1;
		uniform float _SnowMaxAngle;
		uniform float _SnowAngleHardness;
		uniform float _SpecularPower;
		uniform float _SnowSpecularPower;
		uniform float _Smoothness;
		uniform float _SnowSmoothness;


		inline float3 TriplanarNormal( sampler2D topBumpMap, sampler2D midBumpMap, sampler2D botBumpMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign(worldNormal);
			half3 xNorm; half3 yNorm; half3 zNorm;
			if( vertex == 1 ){
				xNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			xNorm = half3( xNorm.xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x );
			yNorm = half3( yNorm.xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y );
			zNorm = half3( zNorm.xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z );
			xNorm = xNorm.zyx;
			yNorm = yNorm.xzy;
			zNorm = zNorm.xyz;
			return normalize( xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z );
		}


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			if( vertex == 1 ){
				xNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = ( tex2D( topTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += 0.0;
			 v.tangent.xyz=cross( ase_worldNormal , float3(0,0,1) );
			 v.tangent.w = -1;//;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float temp_output_704_0 = ( 1.0 / _Texture1Tiling );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 worldTriplanarNormal685 = TriplanarNormal( _Texture1_NormalRGB, _Texture1_NormalRGB, _Texture1_NormalRGB, ase_worldPos, ase_worldNormal, _Texture1TriplanarFalloff, temp_output_704_0, 0 );
			float3 tanTriplanarNormal685 = mul( ase_worldToTangent, worldTriplanarNormal685 );
			float2 uv_Texture1_NormalRGB = i.uv_texcoord * _Texture1_NormalRGB_ST.xy + _Texture1_NormalRGB_ST.zw;
			float4 tex2DNode4 = tex2D( _Splat_Map_1, uv_Texture1_NormalRGB );
			float Splat_1_R6 = tex2DNode4.r;
			float Splat_1_G7 = tex2DNode4.g;
			float clampResult23 = clamp( ( Splat_1_R6 + Splat_1_G7 ) , 0.0 , 1.0 );
			float3 lerpResult31 = lerp( float3( 0,0,0 ) , tanTriplanarNormal685 , clampResult23);
			float temp_output_705_0 = ( 1.0 / _Texture2Tiling );
			float3 worldTriplanarNormal684 = TriplanarNormal( _Texture2_NormalRGB, _Texture2_NormalRGB, _Texture2_NormalRGB, ase_worldPos, ase_worldNormal, _Texture2TriplanarFalloff, temp_output_705_0, 0 );
			float3 tanTriplanarNormal684 = mul( ase_worldToTangent, worldTriplanarNormal684 );
			float3 lerpResult32 = lerp( lerpResult31 , tanTriplanarNormal684 , Splat_1_G7);
			float temp_output_706_0 = ( 1.0 / _Texture3Tiling );
			float3 worldTriplanarNormal683 = TriplanarNormal( _Texture3_NormalRGB, _Texture3_NormalRGB, _Texture3_NormalRGB, ase_worldPos, ase_worldNormal, _Texture3TriplanarFalloff, temp_output_706_0, 0 );
			float3 tanTriplanarNormal683 = mul( ase_worldToTangent, worldTriplanarNormal683 );
			float Splat_1_B8 = tex2DNode4.b;
			float3 lerpResult33 = lerp( lerpResult32 , tanTriplanarNormal683 , Splat_1_B8);
			float temp_output_707_0 = ( 1.0 / _Texture4Tiling );
			float3 worldTriplanarNormal682 = TriplanarNormal( _Texture4_NormalRGB, _Texture4_NormalRGB, _Texture4_NormalRGB, ase_worldPos, ase_worldNormal, _Texture4TriplanarFalloff, temp_output_707_0, 0 );
			float3 tanTriplanarNormal682 = mul( ase_worldToTangent, worldTriplanarNormal682 );
			float Splat_1_A9 = tex2DNode4.a;
			float3 lerpResult34 = lerp( lerpResult33 , tanTriplanarNormal682 , Splat_1_A9);
			float temp_output_708_0 = ( 1.0 / _SnowTiling );
			float3 worldTriplanarNormal687 = TriplanarNormal( _SnowNormalRGB, _SnowNormalRGB, _SnowNormalRGB, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_708_0, 0 );
			float3 tanTriplanarNormal687 = mul( ase_worldToTangent, worldTriplanarNormal687 );
			float clampResult181 = clamp( ( ( ( _Albedo3SnowReduction * Splat_1_B8 ) + ( _Albedo4SnowReduction * Splat_1_A9 ) ) + ( ( _Albedo2SnowReduction * Splat_1_G7 ) + ( _Albedo1SnowReduction * clampResult23 ) ) ) , 0.0 , 1.0 );
			float lerpResult160 = lerp( saturate( ( ase_worldNormal.y * _Snow_Amount ) ) , 0.0 , clampResult181);
			float3 lerpResult83 = lerp( lerpResult34 , tanTriplanarNormal687 , lerpResult160);
			float3 lerpResult183 = lerp( lerpResult83 , lerpResult34 , clampResult181);
			float3 normalizeResult182 = normalize( lerpResult183 );
			o.Normal = normalizeResult182;
			float4 triplanar671 = TriplanarSampling( _Texture1_AlbedoRGB_Smoothness_A, _Texture1_AlbedoRGB_Smoothness_A, _Texture1_AlbedoRGB_Smoothness_A, ase_worldPos, ase_worldNormal, _Texture1TriplanarFalloff, temp_output_704_0, 0 );
			float4 lerpResult24 = lerp( float4( 0,0,0,0 ) , triplanar671 , clampResult23);
			float4 triplanar673 = TriplanarSampling( _Texture2_AlbedoRGB_Smoothness_A, _Texture2_AlbedoRGB_Smoothness_A, _Texture2_AlbedoRGB_Smoothness_A, ase_worldPos, ase_worldNormal, _Texture2TriplanarFalloff, temp_output_705_0, 0 );
			float4 lerpResult25 = lerp( lerpResult24 , triplanar673 , Splat_1_G7);
			float4 triplanar676 = TriplanarSampling( _Texture3_AlbedoRGB_Smoothness_A, _Texture3_AlbedoRGB_Smoothness_A, _Texture3_AlbedoRGB_Smoothness_A, ase_worldPos, ase_worldNormal, _Texture3TriplanarFalloff, temp_output_706_0, 0 );
			float4 lerpResult26 = lerp( lerpResult25 , triplanar676 , Splat_1_B8);
			float4 triplanar679 = TriplanarSampling( _Texture4_AlbedoRGB_Smoothness_A, _Texture4_AlbedoRGB_Smoothness_A, _Texture4_AlbedoRGB_Smoothness_A, ase_worldPos, ase_worldNormal, _Texture4TriplanarFalloff, temp_output_707_0, 0 );
			float4 lerpResult27 = lerp( lerpResult26 , triplanar679 , Splat_1_A9);
			float4 triplanar686 = TriplanarSampling( _SnowAlbedoRGBSpecularA, _SnowAlbedoRGBSpecularA, _SnowAlbedoRGBSpecularA, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_708_0, 0 );
			float3 newWorldNormal81 = WorldNormalVector( i , lerpResult83 );
			float3 temp_cast_0 = (newWorldNormal81.y).xxx;
			float temp_output_137_0 = ( _Snow_Amount * 3.0 );
			float2 temp_output_142_0 = ( uv_Texture1_NormalRGB * _SnowNoiseTiling );
			float3 appendResult128 = (float3(( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).r , ( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).g , ( ( tex2D( _SnowNoiseCover, temp_output_142_0 ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_2 ) ) ) + tex2D( _SnowNoiseCover, ( temp_output_142_0 * _SnowCoverMix_1 ) ) ).b));
			float4 clampResult135 = clamp( ( CalculateContrast(temp_output_137_0,float4( appendResult128 , 0.0 )) * temp_output_137_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float clampResult118 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_107_0 = ( 1.0 - ( _SnowMaxAngle / 90.0 ) );
			float clampResult109 = clamp( ( clampResult118 - temp_output_107_0 ) , 0.0 , 2.0 );
			float temp_output_112_0 = pow( ( 1.0 - ( clampResult109 * ( 1.0 / ( 1.0 - temp_output_107_0 ) ) ) ) , _SnowAngleHardness );
			float4 lerpResult139 = lerp( ( 1.0 - clampResult135 ) , float4( 1,0,0,0 ) , temp_output_112_0);
			float3 lerpResult123 = lerp( temp_cast_0 , lerpResult34 , lerpResult139.r);
			float3 lerpResult165 = lerp( saturate( ( lerpResult123 * _Snow_Amount ) ) , float3( 0,0,0 ) , clampResult181);
			float4 lerpResult91 = lerp( lerpResult27 , triplanar686 , lerpResult165.x);
			float3 appendResult54 = (float3(lerpResult91.x , lerpResult91.y , lerpResult91.z));
			o.Albedo = appendResult54;
			float lerpResult186 = lerp( ( lerpResult27.w * _SpecularPower ) , ( triplanar686.w * _SnowSpecularPower ) , lerpResult165.x);
			float3 temp_cast_5 = (lerpResult186).xxx;
			o.Specular = temp_cast_5;
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
				float4 texcoords01 : TEXCOORD4;
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
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
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
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
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