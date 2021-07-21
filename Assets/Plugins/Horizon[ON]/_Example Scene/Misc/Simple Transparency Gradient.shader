// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:0,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32719,y:32712,varname:node_2865,prsc:2|emission-6665-RGB,alpha-8858-OUT;n:type:ShaderForge.SFN_Color,id:6665,x:32546,y:32811,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5019608,c2:0.5019608,c3:0.5019608,c4:1;n:type:ShaderForge.SFN_TexCoord,id:7388,x:32233,y:32830,varname:node_7388,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:8858,x:32546,y:32972,varname:node_8858,prsc:2|A-8303-OUT,B-8303-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:999,x:32233,y:32972,varname:node_999,prsc:2|IN-7388-V,IMIN-9641-OUT,IMAX-2732-OUT,OMIN-8930-OUT,OMAX-7255-OUT;n:type:ShaderForge.SFN_Clamp01,id:8303,x:32388,y:32972,varname:node_8303,prsc:2|IN-999-OUT;n:type:ShaderForge.SFN_Vector1,id:8930,x:32020,y:33001,varname:node_8930,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:7255,x:32020,y:33052,varname:node_7255,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:9641,x:31863,y:32852,ptovrint:False,ptlb:Min,ptin:_Min,varname:node_9641,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:2732,x:31863,y:32937,ptovrint:False,ptlb:Max,ptin:_Max,varname:node_2732,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.7,max:1;proporder:6665-9641-2732;pass:END;sub:END;*/

Shader "Horizon[ON]/Simple Transparency Gradient" {
    Properties {
        _Color ("Color", Color) = (0.5019608,0.5019608,0.5019608,1)
        _Min ("Min", Range(0, 1)) = 0
        _Max ("Max", Range(0, 1)) = 0.7
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _Color;
            uniform float _Min;
            uniform float _Max;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float3 emissive = _Color.rgb;
                float3 finalColor = emissive;
                float node_8930 = 0.0;
                float node_8303 = saturate((node_8930 + ( (i.uv0.g - _Min) * (1.0 - node_8930) ) / (_Max - _Min)));
                fixed4 finalRGBA = fixed4(finalColor,(node_8303*node_8303));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    //CustomEditor "ShaderForgeMaterialInspector"
}
