// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Plants Waving"
{
	Properties
	{
		_NoiseRGB("Noise RGB", 2D) = "black" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 3)) = 0
		_Speed1("Speed1", Range( 0.3 , 1)) = 0.3
		_DistortionBlend("Distortion Blend", Range( 0 , 1)) = 0
		_DistortionPower("Distortion Power", Range( 0 , 1)) = 0
		_WindGloss("Wind Gloss", 2D) = "black" {}
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
		#pragma target 3.5
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform sampler2D _Albedo;
		uniform sampler2D _WindGloss;
		uniform float4 _WindGloss_ST;
		uniform sampler2D _NoiseRGB;
		uniform float _Speed1;
		uniform float _DistortionBlend;
		uniform float _DistortionPower;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_WindGloss = v.texcoord * _WindGloss_ST.xy + _WindGloss_ST.zw;
			float4 tex2DNode137 = tex2Dlod( _WindGloss, float4( uv_WindGloss, 0, 0.0) );
			float temp_output_134_0 = (0.0 + (_Speed1 - 0.0) * (1.2 - 0.0) / (1.0 - 0.0));
			float2 temp_cast_0 = (temp_output_134_0).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult101 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 _Vector1 = float2(0.05,0.05);
			float2 panner99 = ( ( appendResult101 * _Vector1 ) + 0.2 * _Time.y * temp_cast_0);
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 temp_output_57_0 = abs( mul( unity_WorldToObject, float4( ase_worldNormal , 0.0 ) ).xyz );
			float dotResult59 = dot( temp_output_57_0 , float3(1,1,1) );
			float3 BlendComponents87 = ( temp_output_57_0 / dotResult59 );
			float2 temp_cast_3 = (temp_output_134_0).xx;
			float2 appendResult116 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner117 = ( ( appendResult116 * _Vector1 ) + 0.2 * _Time.y * temp_cast_3);
			float2 temp_cast_4 = (temp_output_134_0).xx;
			float2 appendResult122 = (float2(ase_worldPos.x , ase_worldPos.y));
			float2 panner124 = ( ( appendResult122 * _Vector1 ) + 0.2 * _Time.y * temp_cast_4);
			float2 appendResult71 = (float2(ase_worldPos.y , ase_worldPos.z));
			float2 panner114 = ( appendResult71 + 0.2 * _Time.y * float2( 1,1 ));
			float2 appendResult73 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner90 = ( appendResult73 + 0.2 * _Time.y * float2( 1,1 ));
			float2 appendResult72 = (float2(ase_worldPos.x , ase_worldPos.y));
			float2 panner112 = ( appendResult72 + 0.2 * _Time.y * float2( 1,1 ));
			float4 lerpResult108 = lerp( ( ( ( tex2Dlod( _NoiseRGB, float4( panner99, 0, 1.0) ) * BlendComponents87.x ) + ( tex2Dlod( _NoiseRGB, float4( panner117, 0, 1.0) ) * BlendComponents87.y ) ) + ( tex2Dlod( _NoiseRGB, float4( panner124, 0, 1.0) ) * BlendComponents87.z ) ) , ( ( ( tex2Dlod( _NoiseRGB, float4( panner114, 0, 1.0) ) * BlendComponents87.x ) + ( tex2Dlod( _NoiseRGB, float4( panner90, 0, 1.0) ) * BlendComponents87.y ) ) + ( tex2Dlod( _NoiseRGB, float4( panner112, 0, 1.0) ) * BlendComponents87.z ) ) , _DistortionBlend);
			float4 clampResult107 = clamp( ( tex2DNode137 * ( lerpResult108 * _DistortionPower ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			v.vertex.xyz += clampResult107.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord14 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_TexCoord14 ) ,_NormalScale );
			float4 tex2DNode4 = tex2D( _Albedo, uv_TexCoord14 );
			o.Albedo = tex2DNode4.rgb;
			float2 uv_WindGloss = i.uv_texcoord * _WindGloss_ST.xy + _WindGloss_ST.zw;
			float4 tex2DNode137 = tex2D( _WindGloss, uv_WindGloss );
			o.Smoothness = tex2DNode137.a;
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
158;179;1265;657;2023.953;919.3655;1.866416;True;True
Node;AmplifyShaderEditor.WorldNormalVector;54;-3515.571,-1335.771;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectMatrix;55;-3515.571,-1431.771;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3243.571,-1367.771;Float;False;2;2;0;FLOAT4x4;0,0,0;False;1;FLOAT3;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;58;-3116.689,-1187.321;Float;False;Constant;_Vector0;Vector 0;-1;0;Create;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;57;-3083.571,-1367.771;Float;False;1;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;59;-2909.671,-1301.373;Float;False;2;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;60;-2747.571,-1367.771;Float;False;2;0;FLOAT3;0.0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-2586.571,-1367.771;Float;True;BlendComponents;1;False;1;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;115;-2066.636,-2221.093;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;61;-2283.571,-1527.771;Float;False;FLOAT3;1;0;FLOAT3;0.0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;62;-2283.571,-1239.771;Float;False;FLOAT3;1;0;FLOAT3;0.0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;100;-2079.342,-2425.028;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;91;-2035.683,-1529.226;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;101;-1891.41,-2393.836;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;123;-2049.754,-2035.16;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;133;-2028.227,-2543.431;Float;False;Property;_Speed1;Speed1;7;0;Create;0.3;0.5;0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;63;-2011.572,-1095.771;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;92;-2035.077,-1802.859;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;64;-2011.572,-1575.771;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-1868.305,-2212.781;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;93;-2019.482,-1261.859;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;127;-2429.527,-2279.936;Float;False;Constant;_Vector1;Vector 1;13;0;Create;0.05,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;65;-1830.913,-1069.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1736.059,-2399.53;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-1859.317,-1753.926;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;134;-1663.982,-2608.224;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-1837.351,-1520.914;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;69;-2283.571,-1383.771;Float;False;FLOAT3;1;0;FLOAT3;0.0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;67;-1830.913,-1613.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1728.978,-2197.907;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;122;-1835.025,-2001.385;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-1804.752,-1228.085;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;99;-1586.421,-2416.455;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;114;-1536.837,-1805.187;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;90;-1542.762,-1520.653;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;74;-1094.913,-1613.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;117;-1573.716,-2212.52;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1700.047,-2018.169;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;75;-1094.913,-1069.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;112;-1531.505,-1277.216;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;76;-1094.913,-1341.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;77;-1062.913,-1373.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;78;-1062.913,-1645.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1349.911,-1269.218;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;None;None;True;0;False;white;Auto;False;Instance;89;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;89;-1354.862,-1837.848;Float;True;Property;_NoiseRGB;Noise RGB;0;0;Create;c11328952cba63242a2b07d346665f72;e47125b76d001f84c804533cb4a6ea68;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;124;-1559.171,-2050.517;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;96;-1372.423,-2446.208;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;None;None;True;0;False;white;Auto;False;Instance;89;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;118;-1383.65,-2237.722;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;None;None;True;0;False;white;Auto;False;Instance;89;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;79;-1062.913,-1101.717;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-1352.696,-1545.855;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;None;None;True;0;False;white;Auto;False;Instance;89;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-1013.055,-2489.693;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-982.9135,-1309.717;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-982.9135,-1821.717;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;125;-1380.184,-2042.519;Float;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;None;None;True;0;False;white;Auto;False;Instance;89;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-980.0818,-1549.717;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1012.314,-2270.821;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1006.651,-2061.284;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;84;-726.9135,-1357.717;Float;False;1;0;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-723.4917,-2401.077;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-609.6577,-1791.939;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-302.6269,-1697.546;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-712.1655,-2191.538;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-1074.55,-1060.155;Float;False;Property;_DistortionBlend;Distortion Blend;8;0;Create;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;108;-764.894,-1144.113;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1062.291,-983.2133;Float;False;Property;_DistortionPower;Distortion Power;9;0;Create;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1550.199,-425.4563;Float;False;1252.009;1229.961;Inspired by 2Side Sample by The Four Headed Cat;11;4;10;6;41;43;42;44;49;50;53;51;Two Sided Shader using Switch by Face;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-675.8215,-1034.053;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;137;-961.8834,-734.5512;Float;True;Property;_WindGloss;Wind Gloss;10;0;Create;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-507.406,-1002.032;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2321.084,363.2747;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-1444.491,523.8734;Float;False;Property;_NormalScale;Normal Scale;6;0;Create;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-936.7575,-50.89597;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-1104.108,376.5436;Float;True;Property;_NormalMap;NormalMap;5;0;Create;a3b924056d1f1974da43700c0f1058c8;5f60c6955eb80144e81325712e44597a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1667.818,-1248.349;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwitchByFaceNode;43;-465.2187,-212.5578;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;-1658.108,409.7112;Float;False;Simplex2D;1;0;FLOAT2;16,16;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1692.099,-1790.574;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.4,0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;107;-304.2659,-939.5822;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;-1175.278,-18.32446;Float;False;Property;_ColorBack;Color Back;3;0;Create;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;44;-755.7579,-83.28878;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-1698.024,-1506.04;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.4,0.4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-854.088,-388.7455;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;51;-1085.533,-393.1468;Float;False;Property;_ColorFront;Color Front;2;0;Create;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;49;-678.0779,-389.4396;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;42;-360.1949,4.859922;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-1449.982,-309.6366;Float;True;Property;_Albedo;Albedo;4;0;Create;None;53a901cbec289e043a6df51f027ac80b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;64.91184,-937.3777;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;MK4/Plants Waving;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0.0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;0;55;0
WireConnection;56;1;54;0
WireConnection;57;0;56;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;60;0;57;0
WireConnection;60;1;59;0
WireConnection;87;0;60;0
WireConnection;61;0;87;0
WireConnection;62;0;87;0
WireConnection;101;0;100;1
WireConnection;101;1;100;3
WireConnection;63;0;62;2
WireConnection;64;0;61;0
WireConnection;116;0;115;1
WireConnection;116;1;115;3
WireConnection;65;0;63;0
WireConnection;102;0;101;0
WireConnection;102;1;127;0
WireConnection;71;0;92;2
WireConnection;71;1;92;3
WireConnection;134;0;133;0
WireConnection;73;0;91;1
WireConnection;73;1;91;3
WireConnection;69;0;87;0
WireConnection;67;0;64;0
WireConnection;119;0;116;0
WireConnection;119;1;127;0
WireConnection;122;0;123;1
WireConnection;122;1;123;2
WireConnection;72;0;93;1
WireConnection;72;1;93;2
WireConnection;99;0;102;0
WireConnection;99;2;134;0
WireConnection;114;0;71;0
WireConnection;90;0;73;0
WireConnection;74;0;67;0
WireConnection;117;0;119;0
WireConnection;117;2;134;0
WireConnection;126;0;122;0
WireConnection;126;1;127;0
WireConnection;75;0;65;0
WireConnection;112;0;72;0
WireConnection;76;0;69;1
WireConnection;77;0;76;0
WireConnection;78;0;74;0
WireConnection;80;1;112;0
WireConnection;89;1;114;0
WireConnection;124;0;126;0
WireConnection;124;2;134;0
WireConnection;96;1;99;0
WireConnection;118;1;117;0
WireConnection;79;0;75;0
WireConnection;88;1;90;0
WireConnection;128;0;96;0
WireConnection;128;1;61;0
WireConnection;82;0;80;0
WireConnection;82;1;79;0
WireConnection;81;0;89;0
WireConnection;81;1;78;0
WireConnection;125;1;124;0
WireConnection;83;0;88;0
WireConnection;83;1;77;0
WireConnection;129;0;118;0
WireConnection;129;1;69;1
WireConnection;130;0;125;0
WireConnection;130;1;62;2
WireConnection;84;0;82;0
WireConnection;131;0;128;0
WireConnection;131;1;129;0
WireConnection;85;0;81;0
WireConnection;85;1;83;0
WireConnection;86;0;85;0
WireConnection;86;1;84;0
WireConnection;132;0;131;0
WireConnection;132;1;130;0
WireConnection;108;0;132;0
WireConnection;108;1;86;0
WireConnection;108;2;135;0
WireConnection;95;0;108;0
WireConnection;95;1;136;0
WireConnection;105;0;137;0
WireConnection;105;1;95;0
WireConnection;6;0;4;0
WireConnection;6;1;53;0
WireConnection;10;1;14;0
WireConnection;10;5;41;0
WireConnection;111;0;72;0
WireConnection;43;0;49;0
WireConnection;43;1;44;0
WireConnection;113;0;71;0
WireConnection;107;0;105;0
WireConnection;44;0;6;0
WireConnection;94;0;73;0
WireConnection;50;0;51;0
WireConnection;50;1;4;0
WireConnection;49;0;50;0
WireConnection;42;0;43;0
WireConnection;4;1;14;0
WireConnection;0;0;4;0
WireConnection;0;1;10;0
WireConnection;0;4;137;4
WireConnection;0;10;4;4
WireConnection;0;11;107;0
ASEEND*/
//CHKSM=98B319D6E6F325F66CDA9840A3D60DE1545B9FFA