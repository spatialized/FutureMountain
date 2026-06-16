// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Trees_Bark_Blend"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normals("Normals", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 3)) = 1
		_Gloss_ao_mask("Gloss_ao_mask", 2D) = "white" {}
		_Moss("Moss", 2D) = "white" {}
		_MossNormal("Moss Normal", 2D) = "bump" {}
		_MossNormalBlend("Moss Normal Blend", Range( 0 , 1)) = 0.5
		_MossNormalScale("Moss Normal Scale", Range( 0 , 3)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _MossNormalScale;
		uniform sampler2D _MossNormal;
		uniform float4 _MossNormal_ST;
		uniform float _NormalScale;
		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform float _MossNormalBlend;
		uniform sampler2D _Moss;
		uniform float4 _Moss_ST;
		uniform sampler2D _Gloss_ao_mask;
		uniform float4 _Gloss_ao_mask_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MossNormal = i.uv_texcoord * _MossNormal_ST.xy + _MossNormal_ST.zw;
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			float3 tex2DNode5 = UnpackScaleNormal( tex2D( _Normals, uv_Normals ) ,_NormalScale );
			float3 lerpResult27 = lerp( tex2DNode5 , float3(0,0,1) , _MossNormalBlend);
			float2 uv_Moss = i.uv_texcoord * _Moss_ST.xy + _Moss_ST.zw;
			float4 tex2DNode7 = tex2D( _Moss, uv_Moss );
			float2 uv_Gloss_ao_mask = i.uv_texcoord * _Gloss_ao_mask_ST.xy + _Gloss_ao_mask_ST.zw;
			float4 tex2DNode2 = tex2D( _Gloss_ao_mask, uv_Gloss_ao_mask );
			float clampResult15 = clamp( i.vertexColor.g , 0.0 , 1.0 );
			float clampResult16 = clamp( (-3.0 + (( tex2DNode2.a + ( tex2DNode2.b + clampResult15 ) ) - 0.0) * (1.0 - -3.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float clampResult24 = clamp( ( tex2DNode7.a + clampResult16 ) , 0.0 , 1.0 );
			float3 lerpResult18 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _MossNormal, uv_MossNormal ) ,_MossNormalScale ) , lerpResult27 ) , tex2DNode5 , clampResult24);
			o.Normal = lerpResult18;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 lerpResult9 = lerp( tex2DNode7 , tex2D( _Albedo, uv_Albedo ) , clampResult24);
			o.Albedo = lerpResult9.rgb;
			o.Smoothness = tex2DNode2.r;
			o.Occlusion = tex2DNode2.g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
255;407;1265;549;1097.271;-256.8233;1;True;True
Node;AmplifyShaderEditor.VertexColorNode;8;-1411.382,-699.0273;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1073.812,-299.3467;Float;True;Property;_Gloss_ao_mask;Gloss_ao_mask;3;0;Create;210467557c220db478a4a46752c11b29;210467557c220db478a4a46752c11b29;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;15;-1221.147,-674.1348;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1046.382,-664.5435;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-882.5792,-675.5225;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-737.108,-679.7729;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;-3.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-951.4637,143.3082;Float;False;Property;_NormalScale;Normal Scale;2;0;Create;1;1.1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-590.918,-471.9568;Float;True;Property;_Moss;Moss;4;0;Create;a2c25eda4b27b5c4fa31b4817799c234;d80871d269bfb014b9da9924ce356a60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-930.7727,335.8113;Float;False;Property;_MossNormalScale;Moss Normal Scale;7;0;Create;1;1.16;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-850.2715,478.8233;Float;False;Property;_MossNormalBlend;Moss Normal Blend;6;0;Create;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-640,65.6535;Float;True;Property;_Normals;Normals;1;0;Create;c5e19ad67d8e72446bbd38b9ef8ff460;c5e19ad67d8e72446bbd38b9ef8ff460;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;17;-550.3669,526.065;Float;False;Constant;_Vector0;Vector 0;4;0;Create;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;16;-478.3961,-683.6524;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-658.9796,292.7723;Float;True;Property;_MossNormal;Moss Normal;5;0;Create;None;be0d737c154c6ab44813352f45c1145c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;-355.3519,498.3269;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-291.5379,-667.8785;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;24;-129.323,-644.2897;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;21;-185.3054,450.0138;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-640,-128;Float;True;Property;_Albedo;Albedo;0;0;Create;5cd2de77bf2f75547aaf5ea3e949984e;5cd2de77bf2f75547aaf5ea3e949984e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;9;-226.3302,-297.8479;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;14.82571,249.48;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;312.0375,-126.2675;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Trees_Bark_Blend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;8;2
WireConnection;11;0;2;3
WireConnection;11;1;15;0
WireConnection;12;0;2;4
WireConnection;12;1;11;0
WireConnection;13;0;12;0
WireConnection;5;5;26;0
WireConnection;16;0;13;0
WireConnection;20;5;25;0
WireConnection;27;0;5;0
WireConnection;27;1;17;0
WireConnection;27;2;28;0
WireConnection;22;0;7;4
WireConnection;22;1;16;0
WireConnection;24;0;22;0
WireConnection;21;0;20;0
WireConnection;21;1;27;0
WireConnection;9;0;7;0
WireConnection;9;1;1;0
WireConnection;9;2;24;0
WireConnection;18;0;21;0
WireConnection;18;1;5;0
WireConnection;18;2;24;0
WireConnection;0;0;9;0
WireConnection;0;1;18;0
WireConnection;0;4;2;1
WireConnection;0;5;2;2
ASEEND*/
//CHKSM=20261F0205C8AD219ED2784146AE870CCB0D013A