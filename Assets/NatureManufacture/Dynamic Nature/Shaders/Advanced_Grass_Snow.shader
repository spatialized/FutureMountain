// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersAdvancedGrassSnow' to new syntax.

Shader "NatureManufacture Shaders/Advanced Grass Snow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.4
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 0
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		[Toggle]_SnowremovesAO("Snow removes AO", Int) = 1
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowColor("Snow Color", Color) = (1,1,1,0)
		_WindNoisetilling("Wind Noise tilling", Vector) = (0.007,0.007,0,0)
		_Color("Color", Vector) = (1,1,1,0)
		[Toggle]_Wind_VertexColorR("Wind_VertexColor(R)", Int) = 0
		_WindColorMultiply("Wind Color Multiply", Vector) = (1,1,1,0)
		_WindNoise("Wind Noise", 2D) = "black" {}
		_MaxWindbending("Max Wind bending", Range( 0 , 5)) = 1
		_NoiseWindSpeed("Noise Wind Speed", Range( 0 , 10)) = 0
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		_WindNoisePower("Wind Noise Power", Range( 0 , 5)) = 3
		_MaxSnowCover("Max Snow Cover", Range( 0 , 2)) = 0.35
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _SNOWREMOVESAO_ON
		#pragma multi_compile __ _WIND_VERTEXCOLORR_ON
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed3 _Color;
		uniform fixed3 _WindColorMultiply;
		uniform sampler2D _WindNoise;
		uniform fixed _NoiseWindSpeed;
		uniform fixed2 _WindNoisetilling;
		uniform fixed _WindNoisePower;
		uniform sampler2D _SnowAlbedoRGB;
		uniform fixed _MaxSnowCover;
		uniform fixed _Snow_Amount;
		uniform sampler2D _AmbientOcclusionG;
		uniform fixed _AmbientOcclusionPower;
		uniform fixed _MaxWindbending;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform float _Cutoff = 0.4;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersAdvancedGrassSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _SnowColor)
#define _SnowColor_arr NatureManufactureShadersAdvancedGrassSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersAdvancedGrassSnow)


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );;
			float2 appendResult219 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime363 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult362 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_366_0 = sin( ( mulTime363 + ( appendResult362 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult269 = clamp( temp_output_366_0 , float2( 0.0,0 ) , float2( 1.0,0 ) );
			float2 lerpResult270 = lerp( temp_output_366_0 , ( 1.0 - temp_output_366_0 ) , clampResult269.x);
			fixed2 temp_cast_1 = (_SinTime.x).xx;
			float clampResult351 = clamp( _SinTime.y , 0.0 , 0.7 );
			float2 lerpResult349 = lerp( lerpResult270 , temp_cast_1 , clampResult351);
			float2 appendResult277 = (fixed2(( lerpResult349 + float2( 0.3,0 ) ).x , lerpResult349.x));
			float2 temp_output_367_0 = ( ( appendResult219 * float2( 0.8,0.8 ) ) + appendResult277 );
			float2 appendResult297 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float cos299 = cos( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float sin299 = sin( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float2 rotator299 = mul( appendResult297 - float2( 0.04,-0.04 ) , float2x2( cos299 , -sin299 , sin299 , cos299 )) + float2( 0.04,-0.04 );
			float2 panner337 = ( ( rotator299 * _WindNoisetilling ) + ( _NoiseWindSpeed * _Time.y ) * float2( 0.01,0.01 ));
			fixed4 temp_cast_5 = (_WindNoisePower).xxxx;
			float4 temp_output_343_0 = ( 1.0 - CalculateContrast(tex2Dlod( _WindNoise, fixed4( panner337, 0, 1.0) ).r,temp_cast_5) );
			float2 appendResult312 = (fixed2(temp_output_343_0.r , temp_output_343_0.r));
			float2 clampResult323 = clamp( appendResult312 , float2( 0.4,0.4 ) , float2( 1,1 ) );
			float3 appendResult172 = (fixed3(( ( v.color.r * _MaxWindbending ) * temp_output_367_0 * clampResult323 ).x , 0.0 , ( ( v.color.r * _MaxWindbending ) * temp_output_367_0 * clampResult323 ).y));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 clampResult341 = clamp( ( clampResult323 * ( ase_vertex3Pos.y - float4( float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][0],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][1],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][2],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][3]).y ) ) , float2( 0.1,0.1 ) , float2( 1,1 ) );
			float3 appendResult283 = (fixed3(( ( clampResult341 * _MaxWindbending ) * temp_output_367_0 ).x , 0.0 , ( ( clampResult341 * _MaxWindbending ) * temp_output_367_0 ).y));
			#ifdef _WIND_VERTEXCOLORR_ON
				float3 staticSwitch274 = appendResult172;
			#else
				float3 staticSwitch274 = appendResult283;
			#endif
			float4 transform360 = mul(unity_WorldToObject,fixed4( ( ase_objectScale * staticSwitch274 ) , 0.0 ));
			v.vertex.xyz += transform360.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			fixed3 tex2DNode4 = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			o.Normal = tex2DNode4;
			fixed4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult297 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime363 = _Time.y * 0.7;
			float2 appendResult362 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_366_0 = sin( ( mulTime363 + ( appendResult362 * float2( 0.1,0.1 ) ) ) );
			float cos299 = cos( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float sin299 = sin( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float2 rotator299 = mul( appendResult297 - float2( 0.04,-0.04 ) , float2x2( cos299 , -sin299 , sin299 , cos299 )) + float2( 0.04,-0.04 );
			float2 panner337 = ( ( rotator299 * _WindNoisetilling ) + ( _NoiseWindSpeed * _Time.y ) * float2( 0.01,0.01 ));
			fixed4 temp_cast_3 = (_WindNoisePower).xxxx;
			float4 temp_output_343_0 = ( 1.0 - CalculateContrast(tex2D( _WindNoise, panner337 ).r,temp_cast_3) );
			float2 appendResult312 = (fixed2(temp_output_343_0.r , temp_output_343_0.r));
			float2 clampResult323 = clamp( appendResult312 , float2( 0.4,0.4 ) , float2( 1,1 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 clampResult341 = clamp( ( clampResult323 * ( ase_vertex3Pos.y - float4( float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][0],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][1],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][2],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][3]).y ) ) , float2( 0.1,0.1 ) , float2( 1,1 ) );
			float2 clampResult387 = clamp( clampResult341 , float2( 0,0 ) , float2( 1,1 ) );
			float4 lerpResult354 = lerp( ( fixed4( _Color , 0.0 ) * tex2DNode3 ) , ( fixed4( _WindColorMultiply , 0.0 ) * tex2DNode3 ) , clampResult387.x);
			fixed4 _SnowColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowColor_arr, _SnowColor);
			float3 newWorldNormal235 = WorldNormalVector( i , tex2DNode4 );
			float4 lerpResult51 = lerp( lerpResult354 , ( _SnowColor_Instance * tex2D( _SnowAlbedoRGB, uv_MainTex ) ) , saturate( abs( ( ( newWorldNormal235.x + ( newWorldNormal235.y * _MaxSnowCover ) + newWorldNormal235.z ) * _Snow_Amount ) ) ));
			o.Albedo = lerpResult51.rgb;
			fixed4 tex2DNode98 = tex2D( _AmbientOcclusionG, uv_MainTex );
			float lerpResult249 = lerp( tex2DNode98.g , 1.0 , ( _Snow_Amount * 0.5 ));
			#ifdef _SNOWREMOVESAO_ON
				float staticSwitch252 = lerpResult249;
			#else
				float staticSwitch252 = tex2DNode98.g;
			#endif
			float clampResult150 = clamp( staticSwitch252 , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			o.Occlusion = clampResult150;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows dithercrossfade vertex:vertexDataFunc 

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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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