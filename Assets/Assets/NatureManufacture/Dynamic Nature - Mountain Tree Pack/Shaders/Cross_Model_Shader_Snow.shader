Shader "NatureManufacture Shaders/Cross Model Shader Snow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_MainTex("MainTex", 2D) = "white" {}
		_Smooothness("Smooothness", Float) = 0.3
		_AO("AO", Float) = 1
		_Color("Color", Color) = (1,1,1,0)
		_ColorAdjustment("Color Adjustment", Vector) = (1,1,1,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		_SnowMaskR("Snow Mask (R)", 2D) = "black" {}
		[Toggle] _InvertSnowMask("Invert Snow Mask", Float) = 0.0
		_SnowMaskTreshold("Snow Mask Treshold", Range( 0.1 , 3)) = 1
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_SnowBrightnessReduction("Snow Brightness Reduction", Range( -0.5 , 0.5)) = 0.2
		[Toggle] _WindVertexColorMainR("Wind Vertex Color Main (R)", Float) = 0.0
		_WindPower("Wind Power", Range( 0 , 3)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _INVERTSNOWMASK_ON
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
		uniform fixed4 _Color;
		uniform sampler2D _SnowAlbedoRGB;
		uniform float4 _SnowAlbedoRGB_ST;
		uniform fixed _SnowBrightnessReduction;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _Snow_Amount;
		uniform sampler2D _SnowMaskR;
		uniform fixed _SnowMaskTreshold;
		uniform fixed3 _ColorAdjustment;
		uniform fixed _Smooothness;
		uniform fixed _AO;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			fixed3 temp_cast_0 = (0.0).xxx;
			float2 appendResult105 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime81 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult79 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_87_0 = sin( ( mulTime81 + ( appendResult79 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult92 = clamp( ( temp_output_87_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult93 = lerp( temp_output_87_0 , ( 1.0 - temp_output_87_0 ) , clampResult92.x);
			float2 appendResult104 = (fixed2(( lerpResult93.x + 0.3 ) , lerpResult93.y));
			float2 appendResult83 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime84 = _Time.y * 0.0004;
			float2 temp_output_94_0 = sin( ( ( appendResult79 + ( appendResult83 * mulTime84 ) ) * float2( 0.6,0.8 ) ) );
			float cos96 = cos( _SinTime.w );
			float sin96 = sin( _SinTime.w );
			float2 rotator96 = mul( temp_output_94_0 - float2( 0.1,0.3 ) , float2x2( cos96 , -sin96 , sin96 , cos96 )) + float2( 0.1,0.3 );
			float cos99 = cos( temp_output_94_0.x );
			float sin99 = sin( temp_output_94_0.x );
			float2 rotator99 = mul( temp_output_94_0 - float2( 1,0.9 ) , float2x2( cos99 , -sin99 , sin99 , cos99 )) + float2( 1,0.9 );
			float2 clampResult98 = clamp( lerpResult93 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult100 = lerp( rotator96 , rotator99 , clampResult98.x);
			float2 clampResult106 = clamp( lerpResult100 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float3 appendResult116 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult105 * float2( 0.8,0.8 ) ) + ( appendResult104 + clampResult106 ) ) ).x , 0.0 , ( ( v.color.r * _WindPower ) * ( ( appendResult105 * float2( 0.8,0.8 ) ) + ( appendResult104 + clampResult106 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINR_ON
				float3 staticSwitch117 = appendResult116;
			#else
				float3 staticSwitch117 = temp_cast_0;
			#endif
			float4 transform118 = mul(unity_WorldToObject,fixed4( staticSwitch117 , 0.0 ));
			v.vertex.xyz += transform118.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			fixed3 tex2DNode3 = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			o.Normal = tex2DNode3;
			fixed4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float2 uv_SnowAlbedoRGB = i.uv_texcoord * _SnowAlbedoRGB_ST.xy + _SnowAlbedoRGB_ST.zw;
			float3 appendResult76 = (fixed3(_SnowBrightnessReduction , _SnowBrightnessReduction , _SnowBrightnessReduction));
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float3 lerpResult46 = lerp( tex2DNode3 , UnpackNormal( tex2D( _SnowNormalRGB, uv_SnowAlbedoRGB ) ) , saturate( ( ase_worldNormal.z * _Snow_Amount ) ));
			float temp_output_50_0 = saturate( ( WorldNormalVector( i , lerpResult46 ).y * _Snow_Amount ) );
			fixed4 tex2DNode68 = tex2D( _SnowMaskR, uv_MainTex );
			#ifdef _INVERTSNOWMASK_ON
				float staticSwitch125 = ( 1.0 - tex2DNode68.r );
			#else
				float staticSwitch125 = tex2DNode68.r;
			#endif
			float clampResult127 = clamp( ( staticSwitch125 * _SnowMaskTreshold ) , 0.0 , 1.0 );
			float lerpResult67 = lerp( temp_output_50_0 , 0.0 , clampResult127);
			float clampResult149 = clamp( _Snow_Amount , 0.1 , 2.0 );
			float lerpResult150 = lerp( 0.0 , lerpResult67 , pow( tex2DNode68.r , ( _SnowMaskTreshold / clampResult149 ) ));
			float4 lerpResult56 = lerp( ( tex2DNode2 * _Color ) , ( tex2D( _SnowAlbedoRGB, uv_SnowAlbedoRGB ) - fixed4( appendResult76 , 0.0 ) ) , lerpResult150);
			o.Albedo = ( lerpResult56 * fixed4( _ColorAdjustment , 0.0 ) ).rgb;
			fixed3 temp_cast_3 = (0.0).xxx;
			o.Specular = temp_cast_3;
			o.Smoothness = _Smooothness;
			o.Occlusion = _AO;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
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