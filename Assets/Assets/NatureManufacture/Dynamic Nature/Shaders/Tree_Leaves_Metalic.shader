Shader "NatureManufacture Shaders/Tree Leaves Metalic"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_TranslucencyColor("Translucency Color", Color) = (0.7585312,0.8676471,0.6124567,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.2
		_Color("Color", Color) = (0,0,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		_MetalicRAOGSmothnessA("Metalic (R) AO (G) Smothness (A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 0
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		[Toggle]_WindVertexColorMainRNoiseB("Wind Vertex Color Main (R) Noise (B)", Int) = 1
		_WindColorMultiply("Wind Color Multiply", Vector) = (1,1,1,0)
		_WindPower("Wind Power", Range( 0 , 1)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		_WindNoiseSpeed("Wind Noise Speed", Float) = 2
		_WindNoisePower("Wind Noise Power", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WINDVERTEXCOLORMAINRNOISEB_ON
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			fixed2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
		};

		struct SurfaceOutputStandardCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Translucency;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed4 _Color;
		uniform fixed3 _WindColorMultiply;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform fixed _WindNoisePower;
		uniform fixed _WindNoiseSpeed;
		uniform sampler2D _MetalicRAOGSmothnessA;
		uniform fixed _MetalicPower;
		uniform fixed _SmothnessPower;
		uniform fixed _AmbientOcclusionPower;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform fixed4 _TranslucencyColor;
		uniform float _Cutoff = 0.2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult138 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime183 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult181 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_188_0 = sin( ( mulTime183 + ( appendResult181 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult212 = clamp( ( temp_output_188_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult195 = lerp( temp_output_188_0 , ( 1.0 - temp_output_188_0 ) , clampResult212.x);
			float2 appendResult205 = (fixed2(( lerpResult195.x + 0.3 ) , lerpResult195.y));
			float2 appendResult186 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime187 = _Time.y * 0.0004;
			float2 temp_output_197_0 = sin( ( ( appendResult181 + ( appendResult186 * mulTime187 ) ) * float2( 0.6,0.8 ) ) );
			float cos199 = cos( _SinTime.w );
			float sin199 = sin( _SinTime.w );
			float2 rotator199 = mul( temp_output_197_0 - float2( 0.1,0.3 ) , float2x2( cos199 , -sin199 , sin199 , cos199 )) + float2( 0.1,0.3 );
			float cos198 = cos( temp_output_197_0.x );
			float sin198 = sin( temp_output_197_0.x );
			float2 rotator198 = mul( temp_output_197_0 - float2( 1,0.9 ) , float2x2( cos198 , -sin198 , sin198 , cos198 )) + float2( 1,0.9 );
			float2 clampResult201 = clamp( lerpResult195 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult202 = lerp( rotator199 , rotator198 , clampResult201.x);
			float2 clampResult204 = clamp( lerpResult202 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime214 = _Time.y * _WindNoiseSpeed;
			float lerpResult217 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime214 ));
			fixed2 temp_cast_4 = (ase_worldPos.y).xx;
			float2 panner144 = ( temp_cast_4 + clampResult204.x * float2( 10000,4000 ));
			float2 lerpResult145 = lerp( float2( 0,0 ) , panner144 , v.color.b);
			float2 temp_output_152_0 = ( lerpResult217 * ( lerpResult145 * float2( 0.0001,0.0001 ) ) );
			float mulTime207 = _Time.y * 0.9;
			float cos149 = cos( lerpResult195.x );
			float sin149 = sin( lerpResult195.x );
			float2 rotator149 = mul( sin( ( mulTime207 + ( appendResult181 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos149 , -sin149 , sin149 , cos149 )) + float2( 0.5,0.5 );
			float2 clampResult153 = clamp( rotator149 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult158 = lerp( temp_output_152_0 , ( temp_output_152_0 * float2( 0.45,0.45 ) ) , clampResult153.x);
			float3 appendResult160 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult138 * float2( 0.8,0.8 ) ) + ( appendResult205 + clampResult204 ) ) ).x , lerpResult158.x , ( ( v.color.r * _WindPower ) * ( ( appendResult138 * float2( 0.8,0.8 ) ) + ( appendResult205 + clampResult204 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch161 = appendResult160;
			#else
				float3 staticSwitch161 = fixed3(0,0,0);
			#endif
			float4 transform162 = mul(unity_WorldToObject,fixed4( staticSwitch161 , 0.0 ));
			v.vertex.xyz += transform162.xyz;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			fixed4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_35_0 = ( tex2DNode3 * _Color );
			float2 appendResult138 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime183 = _Time.y * 0.7;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult181 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_188_0 = sin( ( mulTime183 + ( appendResult181 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult212 = clamp( ( temp_output_188_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult195 = lerp( temp_output_188_0 , ( 1.0 - temp_output_188_0 ) , clampResult212.x);
			float2 appendResult205 = (fixed2(( lerpResult195.x + 0.3 ) , lerpResult195.y));
			float2 appendResult186 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime187 = _Time.y * 0.0004;
			float2 temp_output_197_0 = sin( ( ( appendResult181 + ( appendResult186 * mulTime187 ) ) * float2( 0.6,0.8 ) ) );
			float cos199 = cos( _SinTime.w );
			float sin199 = sin( _SinTime.w );
			float2 rotator199 = mul( temp_output_197_0 - float2( 0.1,0.3 ) , float2x2( cos199 , -sin199 , sin199 , cos199 )) + float2( 0.1,0.3 );
			float cos198 = cos( temp_output_197_0.x );
			float sin198 = sin( temp_output_197_0.x );
			float2 rotator198 = mul( temp_output_197_0 - float2( 1,0.9 ) , float2x2( cos198 , -sin198 , sin198 , cos198 )) + float2( 1,0.9 );
			float2 clampResult201 = clamp( lerpResult195 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult202 = lerp( rotator199 , rotator198 , clampResult201.x);
			float2 clampResult204 = clamp( lerpResult202 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime214 = _Time.y * _WindNoiseSpeed;
			float lerpResult217 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime214 ));
			fixed2 temp_cast_5 = (ase_worldPos.y).xx;
			float2 panner144 = ( temp_cast_5 + clampResult204.x * float2( 10000,4000 ));
			float2 lerpResult145 = lerp( float2( 0,0 ) , panner144 , i.vertexColor.b);
			float2 temp_output_152_0 = ( lerpResult217 * ( lerpResult145 * float2( 0.0001,0.0001 ) ) );
			float mulTime207 = _Time.y * 0.9;
			float cos149 = cos( lerpResult195.x );
			float sin149 = sin( lerpResult195.x );
			float2 rotator149 = mul( sin( ( mulTime207 + ( appendResult181 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos149 , -sin149 , sin149 , cos149 )) + float2( 0.5,0.5 );
			float2 clampResult153 = clamp( rotator149 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult158 = lerp( temp_output_152_0 , ( temp_output_152_0 * float2( 0.45,0.45 ) ) , clampResult153.x);
			float3 appendResult160 = (fixed3(( ( i.vertexColor.r * _WindPower ) * ( ( appendResult138 * float2( 0.8,0.8 ) ) + ( appendResult205 + clampResult204 ) ) ).x , lerpResult158.x , ( ( i.vertexColor.r * _WindPower ) * ( ( appendResult138 * float2( 0.8,0.8 ) ) + ( appendResult205 + clampResult204 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch161 = appendResult160;
			#else
				float3 staticSwitch161 = fixed3(0,0,0);
			#endif
			float4 transform162 = mul(unity_WorldToObject,fixed4( staticSwitch161 , 0.0 ));
			float clampResult179 = clamp( transform162.x , 0.0 , 1.0 );
			float4 lerpResult104 = lerp( temp_output_35_0 , ( temp_output_35_0 * fixed4( _WindColorMultiply , 0.0 ) ) , clampResult179);
			o.Albedo = lerpResult104.rgb;
			fixed4 tex2DNode28 = tex2D( _MetalicRAOGSmothnessA, uv_MainTex );
			o.Metallic = ( tex2DNode28.r * _MetalicPower );
			o.Smoothness = ( tex2DNode28.a * _SmothnessPower );
			float clampResult39 = clamp( tex2DNode28.g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			o.Occlusion = clampResult39;
			o.Translucency = ( _TranslucencyColor * temp_output_35_0 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}