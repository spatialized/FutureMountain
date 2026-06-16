Shader "NatureManufacture Shaders/Tree Leaves Specular"
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
		_Cutoff( "Mask Clip Value", Float ) = 0.4
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 0
		_AmbientOcclusionGSmoothnessA("Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		[Toggle]_WindVertexColorMainRNoiseB("Wind Vertex Color Main (R) Noise (B)", Int) = 1
		_WindColorMultiply("Wind Color Multiply", Vector) = (1,1,1,0)
		_WindPower("Wind Power", Range( 0 , 3)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		_WindNoiseSpeed("Wind Noise Speed", Float) = 2
		_WindNoisePower("Wind Noise Power", Range( 0 , 1)) = 1
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
		#pragma surface surf StandardSpecularCustom keepalpha addshadow fullforwardshadows exclude_path:deferred dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			fixed2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
		};

		struct SurfaceOutputStandardSpecularCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			fixed3 Specular;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Translucency;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform fixed4 _Color;
		uniform fixed3 _WindColorMultiply;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform fixed _WindNoisePower;
		uniform fixed _WindNoiseSpeed;
		uniform fixed _SpecularPower;
		uniform sampler2D _AmbientOcclusionGSmoothnessA;
		uniform fixed _SmoothnessPower;
		uniform fixed _AmbientOcclusionPower;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform fixed4 _TranslucencyColor;
		uniform float _Cutoff = 0.4;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult88 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime245 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult244 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_248_0 = sin( ( mulTime245 + ( appendResult244 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult97 = clamp( ( temp_output_248_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult98 = lerp( temp_output_248_0 , ( 1.0 - temp_output_248_0 ) , clampResult97.x);
			float2 appendResult257 = (fixed2(( lerpResult98.x + 0.3 ) , lerpResult98.y));
			float2 appendResult217 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime223 = _Time.y * 0.0004;
			float2 temp_output_218_0 = ( appendResult217 * mulTime223 );
			float2 temp_output_220_0 = sin( ( ( appendResult244 + temp_output_218_0 ) * float2( 0.6,0.8 ) ) );
			float cos221 = cos( _SinTime.w );
			float sin221 = sin( _SinTime.w );
			float2 rotator221 = mul( temp_output_220_0 - float2( 0.1,0.3 ) , float2x2( cos221 , -sin221 , sin221 , cos221 )) + float2( 0.1,0.3 );
			float cos231 = cos( temp_output_220_0.x );
			float sin231 = sin( temp_output_220_0.x );
			float2 rotator231 = mul( temp_output_220_0 - float2( 1,0.9 ) , float2x2( cos231 , -sin231 , sin231 , cos231 )) + float2( 1,0.9 );
			float2 clampResult328 = clamp( lerpResult98 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult225 = lerp( rotator221 , rotator231 , clampResult328.x);
			float2 clampResult222 = clamp( lerpResult225 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime338 = _Time.y * _WindNoiseSpeed;
			float lerpResult332 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime338 ));
			fixed2 temp_cast_4 = (ase_worldPos.y).xx;
			float2 panner174 = ( temp_cast_4 + clampResult222.x * float2( 10000,4000 ));
			float2 lerpResult163 = lerp( float2( 0,0 ) , panner174 , v.color.b);
			float2 temp_output_177_0 = ( lerpResult332 * ( lerpResult163 * float2( 0.0001,0.0001 ) ) );
			float mulTime249 = _Time.y * 0.9;
			float cos201 = cos( lerpResult98.x );
			float sin201 = sin( lerpResult98.x );
			float2 rotator201 = mul( sin( ( mulTime249 + ( appendResult244 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos201 , -sin201 , sin201 , cos201 )) + float2( 0.5,0.5 );
			float2 lerpResult211 = lerp( temp_output_177_0 , ( temp_output_177_0 * float2( 0.45,0.45 ) ) , ( rotator201 * float2( 0.3,0.3 ) ).x);
			float3 appendResult100 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult88 * float2( 0.8,0.8 ) ) + ( appendResult257 + clampResult222 ) ) ).x , lerpResult211.x , ( ( v.color.r * _WindPower ) * ( ( appendResult88 * float2( 0.8,0.8 ) ) + ( appendResult257 + clampResult222 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch213 = appendResult100;
			#else
				float3 staticSwitch213 = fixed3(0,0,0);
			#endif
			float4 transform242 = mul(unity_WorldToObject,fixed4( staticSwitch213 , 0.0 ));
			v.vertex.xyz += transform242.xyz;
		}

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
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

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + c;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			float2 uv_TexCoord40 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord40 ) ,_BumpScale );
			fixed4 tex2DNode3 = tex2D( _MainTex, uv_TexCoord40 );
			float4 temp_output_35_0 = ( tex2DNode3 * _Color );
			float2 appendResult88 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime245 = _Time.y * 0.7;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult244 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_248_0 = sin( ( mulTime245 + ( appendResult244 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult97 = clamp( ( temp_output_248_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult98 = lerp( temp_output_248_0 , ( 1.0 - temp_output_248_0 ) , clampResult97.x);
			float2 appendResult257 = (fixed2(( lerpResult98.x + 0.3 ) , lerpResult98.y));
			float2 appendResult217 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime223 = _Time.y * 0.0004;
			float2 temp_output_218_0 = ( appendResult217 * mulTime223 );
			float2 temp_output_220_0 = sin( ( ( appendResult244 + temp_output_218_0 ) * float2( 0.6,0.8 ) ) );
			float cos221 = cos( _SinTime.w );
			float sin221 = sin( _SinTime.w );
			float2 rotator221 = mul( temp_output_220_0 - float2( 0.1,0.3 ) , float2x2( cos221 , -sin221 , sin221 , cos221 )) + float2( 0.1,0.3 );
			float cos231 = cos( temp_output_220_0.x );
			float sin231 = sin( temp_output_220_0.x );
			float2 rotator231 = mul( temp_output_220_0 - float2( 1,0.9 ) , float2x2( cos231 , -sin231 , sin231 , cos231 )) + float2( 1,0.9 );
			float2 clampResult328 = clamp( lerpResult98 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult225 = lerp( rotator221 , rotator231 , clampResult328.x);
			float2 clampResult222 = clamp( lerpResult225 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime338 = _Time.y * _WindNoiseSpeed;
			float lerpResult332 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime338 ));
			fixed2 temp_cast_5 = (ase_worldPos.y).xx;
			float2 panner174 = ( temp_cast_5 + clampResult222.x * float2( 10000,4000 ));
			float2 lerpResult163 = lerp( float2( 0,0 ) , panner174 , i.vertexColor.b);
			float2 temp_output_177_0 = ( lerpResult332 * ( lerpResult163 * float2( 0.0001,0.0001 ) ) );
			float mulTime249 = _Time.y * 0.9;
			float cos201 = cos( lerpResult98.x );
			float sin201 = sin( lerpResult98.x );
			float2 rotator201 = mul( sin( ( mulTime249 + ( appendResult244 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos201 , -sin201 , sin201 , cos201 )) + float2( 0.5,0.5 );
			float2 lerpResult211 = lerp( temp_output_177_0 , ( temp_output_177_0 * float2( 0.45,0.45 ) ) , ( rotator201 * float2( 0.3,0.3 ) ).x);
			float3 appendResult100 = (fixed3(( ( i.vertexColor.r * _WindPower ) * ( ( appendResult88 * float2( 0.8,0.8 ) ) + ( appendResult257 + clampResult222 ) ) ).x , lerpResult211.x , ( ( i.vertexColor.r * _WindPower ) * ( ( appendResult88 * float2( 0.8,0.8 ) ) + ( appendResult257 + clampResult222 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch213 = appendResult100;
			#else
				float3 staticSwitch213 = fixed3(0,0,0);
			#endif
			float4 transform242 = mul(unity_WorldToObject,fixed4( staticSwitch213 , 0.0 ));
			float clampResult256 = clamp( max( transform242.x , transform242.z ) , 0.0 , 1.0 );
			float4 lerpResult238 = lerp( temp_output_35_0 , ( temp_output_35_0 * fixed4( _WindColorMultiply , 0.0 ) ) , clampResult256);
			o.Albedo = lerpResult238.rgb;
			o.Specular = ( tex2DNode3 * _SpecularPower ).rgb;
			fixed4 tex2DNode28 = tex2D( _AmbientOcclusionGSmoothnessA, uv_TexCoord40 );
			o.Smoothness = ( tex2DNode28.a * _SmoothnessPower );
			float clampResult41 = clamp( tex2D( _AmbientOcclusionGSmoothnessA, uv_TexCoord40 ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			o.Occlusion = clampResult41;
			o.Translucency = ( _TranslucencyColor * temp_output_35_0 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}