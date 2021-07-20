// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Trees_two_sided"
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
		_Cutoff( "Mask Clip Value", Float ) = 0.36
		_Color("Color", Color) = (1,1,1,0)
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 3)) = 0
		_WindPower("Wind Power", Range( 0 , 1)) = 0
		_WindScale("Wind Scale", Range( 0 , 1)) = 0
		_WindNoiseTiling("Wind Noise Tiling", Range( 0 , 1)) = 0.5
		_WindSpeed("Wind Speed", Range( 0 , 1)) = 0.1
		_TransGlossAOWind("Trans-Gloss-AO-Wind", 2D) = "white" {}
		_WindNoise("Wind Noise", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			fixed ASEVFace : VFACE;
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

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform sampler2D _TransGlossAOWind;
		uniform float4 _TransGlossAOWind_ST;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform sampler2D _WindNoise;
		uniform float _WindSpeed;
		uniform float _WindNoiseTiling;
		uniform float _WindScale;
		uniform float _WindPower;
		uniform float _Cutoff = 0.36;


		inline float4 TriplanarSamplingSV( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2Dlod( topTexMap, float4( tilling * worldPos.zy * float2( nsign.x, 1.0 ), 0, 0 ) ) );
			yNorm = ( tex2Dlod( topTexMap, float4( tilling * worldPos.xz * float2( nsign.y, 1.0 ), 0, 0 ) ) );
			zNorm = ( tex2Dlod( topTexMap, float4( tilling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_WindSpeed).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 triplanar26 = TriplanarSamplingSV( _WindNoise, ase_worldPos, ase_worldNormal, 1.0, (0.1 + (_WindNoiseTiling - 0.0) * (3.0 - 0.1) / (1.0 - 0.0)), 0 );
			float2 temp_cast_1 = (triplanar26.x).xx;
			float2 panner27 = ( temp_cast_1 + 1.0 * _Time.y * temp_cast_0);
			float2 uv_TransGlossAOWind = v.texcoord * _TransGlossAOWind_ST.xy + _TransGlossAOWind_ST.zw;
			float4 tex2DNode15 = tex2Dlod( _TransGlossAOWind, float4( uv_TransGlossAOWind, 0, 0.0) );
			v.vertex.xyz += ( ( tex2Dlod( _WindNoise, float4( ( panner27 * _WindScale ), 0, 0.0) ) * _WindPower ) * tex2DNode15.a ).rgb;
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
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_TexCoord14 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_TexCoord14 ) ,_NormalScale );
			float4 tex2DNode4 = tex2D( _Albedo, uv_TexCoord14 );
			float4 switchResult43 = (((i.ASEVFace>0)?((float4( 0,0,0,0 ) + (( _Color * tex2DNode4 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,0 ) - float4( 0,0,0,0 )))):((float4( 0,0,0,0 ) + (( tex2DNode4 * _Color ) - float4( 0,0,0,0 )) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,0 ) - float4( 0,0,0,0 ))))));
			float4 clampResult42 = clamp( switchResult43 , float4( 0,0,0,1 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult42.rgb;
			float2 uv_TransGlossAOWind = i.uv_texcoord * _TransGlossAOWind_ST.xy + _TransGlossAOWind_ST.zw;
			float4 tex2DNode15 = tex2D( _TransGlossAOWind, uv_TransGlossAOWind );
			o.Smoothness = tex2DNode15.g;
			o.Occlusion = tex2DNode15.b;
			float3 temp_cast_1 = (tex2DNode15.r).xxx;
			o.Translucency = temp_cast_1;
			o.Alpha = 1;
			clip( tex2DNode4.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
184;332;1472;701;1649.448;473.7676;1.732057;True;True
Node;AmplifyShaderEditor.RangedFloatNode;22;-1969.913,938.5404;Float;False;Property;_WindNoiseTiling;Wind Noise Tiling;13;0;Create;0.5;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-1681.761,943.2899;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.1;False;4;FLOAT;3.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1972.622,493.8763;Float;True;Property;_WindNoise;Wind Noise;16;0;Create;None;c11328952cba63242a2b07d346665f72;False;black;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1271.091,-588.7082;Float;False;1252.009;1229.961;Inspired by 2Side Sample by The Four Headed Cat;10;4;10;6;15;41;43;42;44;49;50;Two Sided Shader using Switch by Face;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2321.084,363.2747;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1334.367,1072.51;Float;False;Property;_WindSpeed;Wind Speed;14;0;Create;0.1;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;26;-1558.804,719.0729;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;8;0;SAMPLER2D;;False;5;FLOAT;1.0;False;1;SAMPLER2D;;False;6;FLOAT;0.0;False;2;SAMPLER2D;;False;7;FLOAT;0.0;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1052.758,-404.7721;Float;True;Property;_Albedo;Albedo;8;0;Create;77d7f3810f1439b4994eecdde7f3a24b;34f4600e521a0a643a24dedfe80a0b62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1102.138,1178.201;Float;False;Property;_WindScale;Wind Scale;12;0;Create;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-1034.843,1054.877;Float;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0.3,0.3;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;51;-889.3685,-601.2017;Float;False;Property;_Color;Color;7;0;Create;1,1,1,0;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-604.6033,-557.5518;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-734.1796,1052.791;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-657.6494,-214.1478;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;44;-476.6498,-246.5406;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-551.7949,841.2441;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;49;-450.8107,-547.1372;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-370.625,1114.758;Float;False;Property;_WindPower;Wind Power;11;0;Create;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;43;-186.1108,-375.8096;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-94.46277,849.2084;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-832.4211,400.4342;Float;True;Property;_TransGlossAOWind;Trans-Gloss-AO-Wind;15;0;Create;b9f0aecb62cb0324ea64789aeec172f1;ccfb9eeedff991047a1edd3545541570;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-1165.383,360.6215;Float;False;Property;_NormalScale;Normal Scale;10;0;Create;0;1.2;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;-1658.108,409.7112;Float;False;Simplex2D;1;0;FLOAT2;16,16;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-126.1541,436.7905;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-825,213.2918;Float;True;Property;_NormalMap;NormalMap;9;0;Create;a3b924056d1f1974da43700c0f1058c8;d68342f5303b1ef48915920ddeb6033f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;42;-149.5475,-126.7948;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;116.3584,57.7998;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;MK4/Trees_two_sided;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Masked;0.36;True;True;0;False;TransparentCutout;AlphaTest;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;0;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0.0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;22;0
WireConnection;26;0;16;0
WireConnection;26;3;24;0
WireConnection;4;1;14;0
WireConnection;27;0;26;1
WireConnection;27;2;25;0
WireConnection;50;0;51;0
WireConnection;50;1;4;0
WireConnection;35;0;27;0
WireConnection;35;1;36;0
WireConnection;6;0;4;0
WireConnection;6;1;51;0
WireConnection;44;0;6;0
WireConnection;28;0;16;0
WireConnection;28;1;35;0
WireConnection;49;0;50;0
WireConnection;43;0;49;0
WireConnection;43;1;44;0
WireConnection;38;0;28;0
WireConnection;38;1;39;0
WireConnection;37;0;38;0
WireConnection;37;1;15;4
WireConnection;10;1;14;0
WireConnection;10;5;41;0
WireConnection;42;0;43;0
WireConnection;0;0;42;0
WireConnection;0;1;10;0
WireConnection;0;4;15;2
WireConnection;0;5;15;3
WireConnection;0;7;15;1
WireConnection;0;10;4;4
WireConnection;0;11;37;0
ASEEND*/
//CHKSM=B3255A8737FAFC9FA132CC2E484F2C070F8FFCF2