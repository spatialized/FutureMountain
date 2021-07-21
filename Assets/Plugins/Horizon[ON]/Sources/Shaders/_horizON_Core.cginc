/////////////////////////////////////////////////////////

#ifdef SHADOWS_SHADOWMASK
	#undef SHADOWS_SHADOWMASK
#endif

// undefine for SM2.0 texCUBEbias compatibility
#define SPEC_MIP_GLOSS

// undefine when you don't like the water layer to be not displaced
#define DONT_DISPLACE_WATER

#define DETAIL_BLEND_OVERLAY
//#define TINT_BLEND_OVERLAY
//#define PBL_VISIBILITY_TERM
#define PBL_FRESNEL_TERM

//#define _TRANSPARENCYFALLOFFQUAD

// no water on the cliffs
#if defined(_WATER_ON) && defined(_CLIFFS)
#undef _WATER_ON
#endif

// high quality ambient color taken from diffuse IBL skybox in Unity5
#define IBL_DIFFUSE_FOG_COLOR
// higher quality refl. probe add to fog
#define REFLECTION_PROBE_FOG_COLOR_ADD

// per vertex fog distance
// if you'd like to use per vertex fog distance(cheaper but may give bad results with big polys) uncomment the following line 
// #define PER_VERTEX_FOG_DISTANCE

#include "Lighting.cginc"
#include "AutoLight.cginc"

/////////////////////////////////////////////////////////
            
			UNITY_DECLARE_TEX2D(_BaseColormap); uniform float4 _BaseColormap_ST;
            uniform float4 _MapScaleOffset;
			UNITY_DECLARE_TEX2D(_BaseNormalmap); uniform float4 _BaseNormalmap_ST;
            uniform float _GlobalNormalmapIntensity;
            
            //fog
            uniform half4 _OverlayFogColorAfromAmbient;
            uniform float _OverlayFogStartDistance;
            uniform float _OverlayFogDistanceTransition;
            uniform float _OverlayFogStartHeight;
            uniform float _OverlayFogHeightTransition;
            uniform float _OverlayFogDistance2Height;
            uniform float _OverlayFogEmissivePunchThru;
            uniform float _OverlayFogAmount;
            uniform float _OverlayFogAmountFromReflCubemap;
            
            // ibl & ambient
		    //uniform fixed _IBL_HDR; // always hdr in RGBM function below
		    uniform float _DiffIBLMulti;
		    // <U5
		    #ifndef UNITY_PI
		    uniform samplerCUBE unity_SpecCube0;
		    #endif

            uniform float _AmbientIBL;
			uniform float _SpecIBLMulti;
            uniform float4 _AmbientOverrideAAmount;
            
			UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalmap); uniform float4 _DetailNormalmap_ST;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailColormap); uniform float4 _DetailColormap_ST;
            uniform float4 _WaterColorAColorBlend;
            uniform float _WaterWaves;
			uniform sampler2D _WaterNormalmap; uniform float4 _WaterNormalmap_ST;
            uniform float _DetailColormapIntensity;
            uniform sampler2D _MaskRBlend1GBlend2BBlend3AWater; uniform float4 _MaskRBlend1GBlend2BBlend3AWater_ST;
            uniform float _DetailNormalmapIntensity;
            uniform float _WaterBlend;
            
            //uniform fixed _LocalSpace;
            uniform float3 _Anchor;
            uniform half4 _Tint;
            uniform half4 _TintSaturation, _TintSaturationBlend1, _TintSaturationBlend2, _TintSaturationBlend3;
            uniform half4 _WaterSpecGloss;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendColorMap1); uniform float4 _BlendColorMap1_ST;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendColormap2); uniform float4 _BlendColormap2_ST;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendNormalmap1); uniform float4 _BlendNormalmap1_ST;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendNormalmap2); uniform float4 _BlendNormalmap2_ST;
            uniform half4 _EmissionColor;
            uniform float _WaterWaveSpeed;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendColormap3); uniform float4 _BlendColormap3_ST;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendNormalmap3); uniform float4 _BlendNormalmap3_ST;
            
            uniform bool _BaseEmission, _BlendEmission1, _BlendEmission2, _BlendEmission3;
            uniform half _BaseDetailIntensity, _BlendDetailIntensity1, _BlendDetailIntensity2, _BlendDetailIntensity3;
            
			UNITY_DECLARE_TEX2D_NOSAMPLER(_CliffColormap); uniform float4 _CliffColormap_ST;
			uniform bool _CliffEmission;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_CliffNormalmap);  uniform float4 _CliffNormalmap_ST;
        
            uniform float _ScaleInner;
            uniform float _ScaleOuter;
            uniform float _ScaleHeight;
            
            uniform float _SnowAmount;
	        uniform half4 _SnowColor;
    	    uniform half4 _SnowSpecGloss;
        	uniform float _SnowHeight;
        	uniform float _SnowHeightTransition;
        	uniform float _SnowSlopeDamp;
        	uniform float _SnowOutputColorBrightness2Coverage;


//            #if defined(_SHADOW_CASTER)
//            	#define VertexInput app_data_full
//            #else
            struct VertexInput {
                float4 vertex : POSITION;
                #if defined(_MESHNORMALS) || defined(_SHADOW_CASTER)
                	float3 normal : NORMAL;
                #endif
                #if defined(_HORIZONDISK) || defined(USE_UVS_FOR_DISPLACEMENT_BLEND)
                	float2 texcoord0 : TEXCOORD0;
                #endif
               	fixed4 color : COLOR;
            };
//			#endif
			
            struct VertexOutput {
            	#if defined(_SHADOW_CASTER)
              		V2F_SHADOW_CASTER;
  				#else			
	                float4 pos : SV_POSITION;
	                float4 worldPos : TEXCOORD0; // wPos + dist
	                
	                #if defined(_MESHNORMALS)
		                float3 worldNormal : TEXCOORD1; // normal
	                #endif
	                #ifdef _CLIFFS
		 				float3 uv : TEXCOORD2; // z component is y world pos scaled like x axis
	                #else
		 				float2 uv : TEXCOORD2; // mask
	                #endif
	                float2 uv1 : TEXCOORD3; // base (layer1)
	                #if defined(_DETAIL_ON)
		                float2 uvDet : TEXCOORD4; // detail
	                	
		            	#if defined(_LAYERCOUNT_TWO) || defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
			                float2 uv2 : TEXCOORD5; // layer2
		            	#endif
		            	#if defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
			                float2 uv3 : TEXCOORD6; // layer3
		            	#endif
		            	// transformed in frag program
						// #if defined(_LAYERCOUNT_FOUR)
						// float2 uv4 : TEXCOORD7; // layer4
						// #endif
		            	#if defined(UNITY_PI) && !defined(NO_U5_FOG)
			            	UNITY_FOG_COORDS(7)
			            #endif
		            #else
		            	#if defined(_LAYERCOUNT_TWO) || defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
			                float2 uv2 : TEXCOORD4;
		            	#endif
		            	#if defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
			                float2 uv3 : TEXCOORD5;
		            	#endif
		            	#if defined(_LAYERCOUNT_FOUR)
			                float2 uv4 : TEXCOORD6;
		            	#endif     
		            	#if defined(UNITY_PI) && !defined(NO_U5_FOG)
		            		UNITY_FOG_COORDS(7)
	           			#endif
		            #endif
	            	#if defined(UNITY_PI) && !defined(NO_U5_FOG)
						SHADOW_COORDS(8)
	       			#endif
		            
		            #ifdef _HORIZONDISK        
		            	fixed alpha : COLOR;
	                #endif
	        	#endif
            };

//
// displacement
//
uniform float _Parallax;
uniform sampler2D _ParallaxMap;
uniform fixed _ReduceByVertexAlpha;
uniform fixed _ReduceByUVBorder;
uniform float _ReduceByUVBorderLength;
half Displace(float2 uv) {
	half4 dispVals;
	dispVals.r=tex2Dlod(_ParallaxMap, float4(TRANSFORM_TEX(uv.xy, _BlendColorMap1),0,0)).r;
	dispVals.g=tex2Dlod(_ParallaxMap, float4(TRANSFORM_TEX(uv.xy, _BlendColormap2),0,0)).g;
	dispVals.b=tex2Dlod(_ParallaxMap, float4(TRANSFORM_TEX(uv.xy, _BlendColormap3),0,0)).b;
	dispVals.a=tex2Dlod(_ParallaxMap, float4(TRANSFORM_TEX(uv.xy, _BaseColormap),0,0)).a;
	fixed4 blendVal = tex2Dlod(_MaskRBlend1GBlend2BBlend3AWater, float4(uv,0,0));
	
	half dispValue=dispVals.a;
	#if defined(_LAYERCOUNT_TWO) || defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
		dispValue=lerp(dispValue, dispVals.r, blendVal.r);
	#endif
	#if defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
		dispValue=lerp(dispValue, dispVals.g, blendVal.g);
	#endif
	#if defined(_LAYERCOUNT_FOUR)
		dispValue=lerp(dispValue, dispVals.b, blendVal.b);
	#endif
	#if defined(_WATER_ON) && defined(DONT_DISPLACE_WATER)
		dispValue*= saturate(1-blendVal.a*100);
	#endif
		return dispValue;// *1.25 - 0.25;
}

void disp (inout VertexInput v)
{
	float2 worldPosXZ = mul(unity_ObjectToWorld, v.vertex).xz;
	float2 objCenter=float2(unity_ObjectToWorld[0][3], unity_ObjectToWorld[2][3]);
	float2 uv=(/* -_LocalSpace*objCenter*0 */ -_Anchor.xz + worldPosXZ + _MapScaleOffset.zw)/_MapScaleOffset.xy;
	
	// extrusion height measured in world scale
	float yScale = unity_WorldToObject[1][1]*1.0;
	
	float d = Displace(uv) * _Parallax*yScale*lerp(1, v.color.a, _ReduceByVertexAlpha);
	#ifdef USE_UVS_FOR_DISPLACEMENT_BLEND
		float2 UVreduction=abs((v.texcoord0-0.5)*2);
		float UVreductionFct=1-saturate((max(UVreduction.x, UVreduction.y)-_ReduceByUVBorderLength)/(1-_ReduceByUVBorderLength));
		d*=lerp(1, UVreductionFct, _ReduceByUVBorder);
	#endif
	#if defined(_MESHNORMALS)
		v.vertex.xyz += v.normal * d;
	#else
		v.vertex.y += d;
	#endif
}

//
// tessellation
//
#if defined(UNITY_CAN_COMPILE_TESSELLATION)
float _EdgeLength;

float4 tessEdge (VertexInput v0, VertexInput v1, VertexInput v2)
{
	return _EdgeLength;
	//return UnityEdgeLengthBasedTessCull (v0.vertex, v1.vertex, v2.vertex, _EdgeLength, _Parallax * 1.5f);
}
    
// tessellation vertex shader
struct InternalTessInterp_appdata {
	float4 vertex : INTERNALTESSPOS;
	#ifdef _MESHNORMALS
		float3 normal : NORMAL;
	#endif
	#if defined(_HORIZONDISK) || defined(USE_UVS_FOR_DISPLACEMENT_BLEND)
		float2 texcoord0 : TEXCOORD0;
	#endif
	fixed4 color : COLOR;
};
InternalTessInterp_appdata tessvert_surf (VertexInput v) {
	InternalTessInterp_appdata o;
	o.vertex = v.vertex;
	#ifdef _MESHNORMALS
		o.normal = v.normal;
	#endif
	#if defined(_HORIZONDISK) || defined(USE_UVS_FOR_DISPLACEMENT_BLEND)
		o.texcoord0 = v.texcoord0;
	#endif
	o.color = v.color;
	return o;
}

//struct UnityTessellationFactors {
//    float edge[3] : SV_TessFactor;
//    float inside : SV_InsideTessFactor;
//};

// tessellation hull constant shader
UnityTessellationFactors hsconst_surf (InputPatch<InternalTessInterp_appdata,3> v) {
	UnityTessellationFactors o;
	float4 tf;
	VertexInput vi[3];

	vi[0].vertex = v[0].vertex;
	vi[1].vertex = v[1].vertex;
	vi[2].vertex = v[2].vertex;
  
	#ifdef _MESHNORMALS
		vi[0].normal = v[0].normal;
		vi[1].normal = v[1].normal;
		vi[2].normal = v[2].normal;
	#endif  
	#if defined(_HORIZONDISK) || defined(USE_UVS_FOR_DISPLACEMENT_BLEND)
		vi[0].texcoord0 = v[0].texcoord0;
		vi[1].texcoord0 = v[1].texcoord0;
		vi[2].texcoord0 = v[2].texcoord0;
	#endif	
	vi[0].color = v[0].color;
	vi[1].color = v[1].color;
	vi[2].color = v[2].color;
	tf = tessEdge(vi[0], vi[1], vi[2]);
	o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
	return o;
}

// tessellation hull shader
[UNITY_domain("tri")]
[UNITY_partitioning("fractional_odd")]
[UNITY_outputtopology("triangle_cw")]
[UNITY_patchconstantfunc("hsconst_surf")]
[UNITY_outputcontrolpoints(3)]
InternalTessInterp_appdata hs_surf (InputPatch<InternalTessInterp_appdata,3> v, uint id : SV_OutputControlPointID) {
	return v[id];
}
#endif // tessellation

                       
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                
				#ifdef _HORIZONDISK        
					float blendSize= ( ( ((_ScaleInner-1)*(1-v.texcoord0.r)) * v.texcoord0.g ) +1 );
	                v.vertex.xz*= blendSize;
	                _ScaleOuter =(_ScaleOuter > 0) ? _ScaleOuter :0;
	                float sOuter= (_ScaleOuter)*(v.texcoord0.r)+1;
	                v.vertex.xz*= sOuter;
	                #if !defined(_SHADOW_CASTER)
	                	o.alpha = blendSize<0.001 ? 1 : 1-v.texcoord0.g;
	                #endif
	                v.vertex.y*=_ScaleHeight*sOuter;
                #endif
                
                #ifdef _DISPLACEMENT
                	disp (v);
                #endif
    			
				#if defined(_SHADOW_CASTER)            
					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				#else
	                o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
	                o.worldPos.w = distance(_WorldSpaceCameraPos, o.worldPos.xyz);
	                o.pos = UnityObjectToClipPos(v.vertex);
	                
	                #ifdef _MESHNORMALS
						o.worldNormal=normalize(mul(unity_ObjectToWorld, float4(SCALED_NORMAL,0)).xyz);
	                #endif
	                
					#ifdef _CLIFFS
	        	    	float3 objCenter=float3(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3]);
	            		float3 uv=(/* -_LocalSpace*objCenter.xzy*0 */ - _Anchor.xzy + o.worldPos.xzy + _MapScaleOffset.zwz)/_MapScaleOffset.xyx;
	            	#else
		            	float2 objCenter=float2(unity_ObjectToWorld[0][3], unity_ObjectToWorld[2][3]);
	    	        	float2 uv=(/* -_LocalSpace*objCenter*0 */ - _Anchor.xz + o.worldPos.xz + _MapScaleOffset.zw)/_MapScaleOffset.xy;
	            	#endif
	            	
	            	o.uv=uv;
	            	o.uv1=TRANSFORM_TEX(uv.xy, _BaseColormap);
	                #if defined(_DETAIL_ON)
		                o.uvDet=TRANSFORM_TEX(uv.xy, _DetailColormap);
		            #endif
	            	
	            	#if defined(_LAYERCOUNT_TWO) || defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
		                o.uv2=TRANSFORM_TEX(uv.xy, _BlendColorMap1);
	            	#endif
	            	#if defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
		                o.uv3=TRANSFORM_TEX(uv.xy, _BlendColormap2);
	            	#endif
	                #if !defined(_DETAIL_ON) && defined(_LAYERCOUNT_FOUR)
		                o.uv4=TRANSFORM_TEX(uv.xy, _BlendColormap3);
	            	#endif                
	            	
	               	#if defined(UNITY_PI) && !defined(NO_U5_FOG)
						UNITY_TRANSFER_FOG(o,o.pos);
	           		#endif
	           		
	               	#if defined(UNITY_PI) && !defined(NO_U5_FOG)
		           		TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
	    			#endif
	    			       		
                #endif
                
                return o;
            }
            
#if defined(UNITY_CAN_COMPILE_TESSELLATION)
// tessellation domain shader
[UNITY_domain("tri")]
VertexOutput ds_surf (UnityTessellationFactors tessFactors, const OutputPatch<InternalTessInterp_appdata,3> vi, float3 bary : SV_DomainLocation) {
	VertexInput v;
	UNITY_INITIALIZE_OUTPUT(VertexInput, v);
	v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
	#ifdef _MESHNORMALS
		v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
	#endif
	#if defined(_HORIZONDISK) || defined(USE_UVS_FOR_DISPLACEMENT_BLEND)
		v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
	#endif
	v.color = vi[0].color*bary.x + vi[1].color*bary.y + vi[2].color*bary.z;
	disp (v);
	VertexOutput o = vert (v);
	return o;
}
#endif // tessellation     

		inline float3 BlendNormalsCustom(float3 global_norm, float3 detail) {
				float3 _t = global_norm;
				_t.z += 1;
				float3 _u = float3(-detail.xy, detail.z);
				return (_t*dot(_t, _u) - _u*_t.z);
			}      
			
			inline half3 OverlayBlending(half3 t1, half3 t2) {
				return (t1.rgb<half3(0.5,0.5,0.5)) ? (2.0*t1*t2) : (half3(1.0, 1.0, 1.0)-2.0*(1.0-t1)*(1.0-t2));
			}
			
			inline half3 DecodeRGBM(float4 rgbm) {
				fixed _IBL_HDR=1;
				#if (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3)) && defined(SHADER_API_MOBILE)
					return (_IBL_HDR ? 2.0 : 1.0) * rgbm.rgb;
				#else
					return (_IBL_HDR ? (8.0 * rgbm.a) : 1.0) * rgbm.rgb;
				#endif
			}			
			
            float4 frag(VertexOutput i) : SV_Target {
            	#if defined(_SHADOW_CASTER)
					SHADOW_CASTER_FRAGMENT(i)            
            	#else
               	fixed4 blendVal = tex2D(_MaskRBlend1GBlend2BBlend3AWater, i.uv.xy);
            	
            	fixed4 colorTex = UNITY_SAMPLE_TEX2D(_BaseColormap, i.uv1); // A - gloss / emissive mask
           	    // desat + tint
            	colorTex.rgb=lerp( ( dot(colorTex.rgb, half3(0.3,0.5,0.3)) ).xxx, colorTex.rgb, _TintSaturation.a*2);
        		#ifdef DETAIL_BLEND_OVERLAY
        			colorTex.rgb = OverlayBlending(_TintSaturation.rgb, colorTex.rgb);
        		#else
        			colorTex.rgb *= _TintSaturation.rgb*2;
        		#endif
            	fixed4 normalTex = UNITY_SAMPLE_TEX2D(_BaseNormalmap, i.uv1);
            	
            	float detailIntensity=_BaseDetailIntensity;
            	float emissiveness=_BaseEmission*colorTex.a;
           		fixed4 emissiveLayerMask=fixed4(_BaseEmission, _BlendEmission1, _BlendEmission2, _BlendEmission3);
            	#if defined(_LAYERCOUNT_TWO) || defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
            	    fixed4 col= UNITY_SAMPLE_TEX2D_SAMPLER(_BlendColorMap1, _BaseColormap, i.uv2);
            	    // desat + tint
	            	col.rgb=lerp(( dot(col.rgb, half3(0.3,0.5,0.3)) ).xxx, col.rgb, _TintSaturationBlend1.a*2);
	        		#ifdef DETAIL_BLEND_OVERLAY
	        			col.rgb = OverlayBlending(_TintSaturationBlend1.rgb, col.rgb);
	        		#else
	        			col.rgb *= _TintSaturationBlend1.rgb*2;
	        		#endif
            	    
            		colorTex=lerp(colorTex, col, blendVal.r);
            		normalTex=lerp(normalTex, UNITY_SAMPLE_TEX2D_SAMPLER(_BlendNormalmap1, _BaseNormalmap, i.uv2), blendVal.r);
            		detailIntensity=lerp(detailIntensity, _BlendDetailIntensity1, blendVal.r);
	            	emissiveness = lerp(emissiveness, _BlendEmission1 ? col.a : 0, blendVal.r);
            	#endif
            	#if defined(_LAYERCOUNT_THREE) || defined(_LAYERCOUNT_FOUR)
            	    col= UNITY_SAMPLE_TEX2D_SAMPLER(_BlendColormap2, _BaseColormap, i.uv3);
            	    // desat + tint
	            	col.rgb=lerp(( dot(col.rgb, half3(0.3,0.5,0.3)) ).xxx, col.rgb, _TintSaturationBlend2.a*2);
	        		#ifdef DETAIL_BLEND_OVERLAY
	        			col.rgb = OverlayBlending(_TintSaturationBlend2.rgb, col.rgb);
	        		#else
	        			col.rgb *= _TintSaturationBlend2.rgb*2;
	        		#endif
	        		            	    
            		colorTex=lerp(colorTex, col, blendVal.g);
            		normalTex=lerp(normalTex, UNITY_SAMPLE_TEX2D_SAMPLER(_BlendNormalmap2, _BaseNormalmap, i.uv3), blendVal.g);
            		detailIntensity=lerp(detailIntensity, _BlendDetailIntensity2, blendVal.g);
	            	emissiveness = lerp(emissiveness, _BlendEmission2 ? col.a : 0, blendVal.g);
            	#endif
            	#if defined(_LAYERCOUNT_FOUR)
					#if defined(_DETAIL_ON)
						float2 uv4=TRANSFORM_TEX(i.uv.xy, _BlendColormap3);
					#else
						float2 uv4=i.uv4;
					#endif
            	    col= UNITY_SAMPLE_TEX2D_SAMPLER(_BlendColormap3, _BaseColormap, uv4);
            	    // desat + tint
	            	col.rgb=lerp(( dot(col.rgb, half3(0.3,0.5,0.3)) ).xxx, col.rgb, _TintSaturationBlend3.a*2);
	        		#ifdef DETAIL_BLEND_OVERLAY
	        			col.rgb = OverlayBlending(_TintSaturationBlend3.rgb, col.rgb);
	        		#else
	        			col.rgb *= _TintSaturationBlend3.rgb*2;
	        		#endif
	        		            	    
            		colorTex=lerp(colorTex, col, blendVal.b);
            		normalTex=lerp(normalTex, UNITY_SAMPLE_TEX2D_SAMPLER(_BlendNormalmap3, _BaseNormalmap, uv4), blendVal.b);
            		detailIntensity=lerp(detailIntensity, _BlendDetailIntensity3, blendVal.b);
	            	emissiveness = lerp(emissiveness, _BlendEmission3 ? col.a : 0, blendVal.b);
            	#endif
            	
            	fixed3 pureColor=colorTex.rgb;
	           	float3 baseNormalDirection=UnpackScaleNormal(normalTex, _GlobalNormalmapIntensity);
            	
            	#ifdef _DETAIL_ON
            		half3 detailColorTex = lerp(half3(0.5,0.5,0.5), UNITY_SAMPLE_TEX2D_SAMPLER(_DetailColormap, _BaseColormap, i.uvDet).rgb, _DetailColormapIntensity*detailIntensity);
            		#ifdef DETAIL_BLEND_OVERLAY
            			colorTex.rgb = OverlayBlending(detailColorTex, colorTex.rgb);
            		#else
            			colorTex.rgb *= detailColorTex*2;
            		#endif
            		
					fixed4 detailNormTex = UNITY_SAMPLE_TEX2D_SAMPLER(_DetailNormalmap, _BaseNormalmap, i.uvDet);
            		float3 normalDirection=UnpackScaleNormal(detailNormTex, _DetailNormalmapIntensity*detailIntensity);
            		normalDirection=BlendNormalsCustom(baseNormalDirection, normalDirection);
            	#else
            		float3 normalDirection=baseNormalDirection;
            	#endif
            	
            	#ifdef _MESHNORMALS
	            	normalDirection=BlendNormalsCustom(i.worldNormal.xzy, normalDirection);
            	#endif
            	
            	// 2planar cliffs (xy, zy)
            	#ifdef _CLIFFS
            		float cliffBlend=exp(-5*saturate(abs(i.worldNormal.y)-0.5)/0.5);
            		float cliffBlendXZ=exp(-5*saturate(abs(i.worldNormal.x)-0.5)/0.5);
            		
            		half4 cliffColorXY= UNITY_SAMPLE_TEX2D_SAMPLER(_CliffColormap, _BaseColormap, i.uv.xz*_CliffColormap_ST.xx);
            		half4 cliffColorZY= UNITY_SAMPLE_TEX2D_SAMPLER(_CliffColormap, _BaseColormap, i.uv.yz*_CliffColormap_ST.yx);
            		half4 cliffColor=lerp(cliffColorZY, cliffColorXY, cliffBlendXZ);
	            	emissiveness = lerp(emissiveness, _CliffEmission ? cliffColor.a : 0, cliffBlend);
            		colorTex.rgb=lerp(colorTex.rgb, cliffColor.rgb, cliffBlend);
            		
            		float3 CliffNormalXY=UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_CliffNormalmap, _BaseNormalmap, i.uv.xz*_CliffColormap_ST.xx) );
            		CliffNormalXY.xyz=CliffNormalXY.xzy;
            		CliffNormalXY.y*=sign(i.worldNormal.z);
            		
            		float3 CliffNormalZY=UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_CliffNormalmap, _BaseNormalmap, i.uv.yz*_CliffColormap_ST.yx) );

            		CliffNormalZY.xyz=CliffNormalZY.zxy;
            		CliffNormalZY.x*=sign(i.worldNormal.x);
					            		
            		normalDirection=lerp(normalDirection, lerp(CliffNormalZY, CliffNormalXY, cliffBlendXZ), cliffBlend);
            	#endif
            	
				#ifdef TINT_BLEND_OVERLAY
					colorTex.rgb=OverlayBlending(_Tint.rgb,colorTex.rgb);
				#else
					colorTex.rgb*=_Tint.rgb*2;
				#endif
            	

            	#ifdef _WATER_ON
            		float waterAmount=blendVal.w*_WaterBlend;
            		colorTex.rgb = lerp(colorTex.rgb, _WaterColorAColorBlend.rgb, waterAmount*_WaterColorAColorBlend.a);
            		
            		float2 water_uv=TRANSFORM_TEX(i.uv.xy, _WaterNormalmap);
            		float wSpeed=_Time.x*_WaterWaveSpeed;
            		fixed4 waterTex=tex2D(_WaterNormalmap, water_uv + wSpeed);
            		waterTex=0.5*(waterTex+tex2D(_WaterNormalmap, water_uv*0.8 + wSpeed*float2(-1.2,-0.9)));
					waterTex = 0.5*(waterTex + tex2D(_WaterNormalmap, water_uv*1.2 + wSpeed*float2(0.9, -1.2)));
	            	float3 waterNormal=UnpackScaleNormal(waterTex, _WaterWaves);
	            	normalDirection=lerp(normalDirection, waterNormal, waterAmount);
	            	
        			float3 specColor=lerp(0, max(0, _WaterSpecGloss.rgb), waterAmount);
        			float gloss=lerp(0, _WaterSpecGloss.a, waterAmount);
				#else	   
					float3 specColor = 0;
        			float gloss=0; 
            	#endif
            	
            	//normalDirection.xy*=_NormalMultiplier;
            	#ifdef _NORMALMAPS_ON
	            	normalDirection=normalize(normalDirection.xzy);
            	#else
            		#ifdef _MESHNORMALS
	            		normalDirection=i.worldNormal;
	            	#else
	            		normalDirection=float3(0,1,0);
	            	#endif
            	#endif  
            	float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            	#ifdef _SNOW_ON
					float snow_val=_SnowAmount*2;
					float snow_height_fct=saturate((_SnowHeight - i.worldPos.y)/_SnowHeightTransition)*4;
					snow_val += snow_height_fct<0 ? 0 : -snow_height_fct;
					 
					half3 desat_color=1-dot(colorTex.rgb, float3(0.4,0.4,0.4));
					desat_color*=desat_color;
					snow_val -= desat_color*_SnowOutputColorBrightness2Coverage;
					float3 norm_for_snow=float3(0,1,0);
					snow_val -= _SnowSlopeDamp*(1-normalDirection.y);

					snow_val=saturate(snow_val);
					snow_val*=snow_val;
					snow_val*=snow_val;

					#ifdef _WATER_ON
            			/*gloss = lerp(gloss, _SnowSpecGloss.a, snow_val);
	           			specColor = lerp(specColor, _SnowSpecGloss.rgb, snow_val);*/
						gloss = lerp(gloss, 0, snow_val);
						specColor = lerp(specColor, 0, snow_val);
					#endif
            		colorTex.rgb=lerp(colorTex.rgb, _SnowColor.rgb, snow_val);
            	#endif          	
            	                        	                        	                        	                        	                        	            
           		float NdotV=saturate(dot(normalDirection, viewDirection));
				float3 fresnelTermAmb = specColor + ( max(gloss.xxx, specColor) - specColor ) * exp2(-8.656170*NdotV); // exp2 is quick approx of (1-x)^5
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = _WorldSpaceLightPos0.xyz; // forward pass - directional light
                float3 halfDirection = normalize(viewDirection+lightDirection);
                
                #if defined(UNITY_PI)
                	UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                #else
                   	half atten = 1;
				#endif
				
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;

           		float NdotL = saturate( dot( normalDirection, lightDirection ) );
                float3 diffuse = NdotL * InvPi * _LightColor0.xyz * atten;
                
                float specPow = exp2( gloss*10.0 + 1.0 );
   	            float specularMonochrome = saturate(dot(specColor,float3(0.3,0.59,0.11)));
				#ifdef PBL_VISIBILITY_TERM
					float alpha = 1.0 / ( sqrt( (Pi/4.0) * specPow + Pi/2.0 ) );
					float visTerm = ( NdotL * ( 1.0 - alpha ) + alpha ) * ( NdotV * ( 1.0 - alpha ) + alpha );
					visTerm = 1.0 / visTerm;
				#else
					float visTerm=1.0;
				#endif
                float normTerm = (specPow + 8.0 ) / (8.0 * Pi);

				#ifdef _IBLSPEC_ON
					float _IBLSpecRoughMIP = 6;
					float _IBLSpecGlossMIP = 0;

					// U5 reflection probe
					#ifdef UNITY_PI
						half4 rgbm = SampleCubeReflection( unity_SpecCube0, viewReflectDirection, lerp(_IBLSpecRoughMIP, _IBLSpecGlossMIP, gloss) );
	              		float3 specularAmb = fresnelTermAmb * _SpecIBLMulti * DecodeHDR_NoLinearSupportInSM2 (rgbm, unity_SpecCube0_HDR);
              		#else
						// U4 reflection probe
						#ifdef SPEC_MIP_GLOSS
							float3 specularAmb = fresnelTermAmb * _SpecIBLMulti * DecodeRGBM( texCUBElod(unity_SpecCube0, float4(viewReflectDirection, lerp(_IBLSpecRoughMIP, _IBLSpecGlossMIP, gloss))) );
						#else
							float3 specularAmb = fresnelTermAmb * _SpecIBLMulti * DecodeRGBM( texCUBEbias(unity_SpecCube0, float4(viewReflectDirection, lerp(_IBLSpecRoughMIP, _IBLSpecGlossMIP, gloss))) );
						#endif
              		#endif 	                  
				#endif

				float HdotL= saturate(dot(halfDirection,lightDirection));
				float3 fresnelTerm = specColor;
				#ifdef PBL_FRESNEL_TERM
					fresnelTerm += ( float3(1.0, 1.0, 1.0) - specColor ) * exp2(-8.656170*HdotL); // exp2 is quick approx of (1-x)^5
				#endif

				float HdotN = saturate(dot(halfDirection,normalDirection));
				float3 specular=0;
				#ifdef _IBLSPEC_ON
               		specular += specularAmb;
                #endif
				#ifdef _DIRECTSPEC_ON
					// TODO: Resolve in future update
					#ifdef _WATER_ON
						specular += lerp(0, _LightColor0.xyz * atten * NdotL * pow(HdotN, specPow)*fresnelTerm*visTerm*normTerm, waterAmount);
					#endif
					#ifdef _WATER_OFF
						specular = 0;
					#endif
					//specular += lerp()0;// _LightColor0.xyz * atten * NdotL * pow(HdotN, specPow)*fresnelTerm*visTerm*normTerm; 
				#endif
                
                float3 finalColor;
                float3 diffuseLight = diffuse;
                
				float AO=1;
				// Diffuse Ambient Light
                half3 diffuseAmb = _DiffIBLMulti * ShadeSH9(float4(normalDirection,1));
    	        diffuseLight += lerp(lerp(UNITY_LIGHTMODEL_AMBIENT.rgb,_AmbientOverrideAAmount.rgb,_AmbientOverrideAAmount.a), diffuseAmb, _AmbientIBL*AO);

                #if defined(_IBLSPEC_ON) || defined(_DIRECTSPEC_ON)
                	diffuseLight *= 1-specularMonochrome;
                #endif
                // diffuse
                finalColor = colorTex.rgb*diffuseLight*2;
                // spec
                finalColor += specular*AO;
                // fog
                #ifdef _OVERLAYFOG_ON
	                #if defined(SHADER_API_MOBILE)
	                	float dist=i.worldPos.w;
	                #else
	                	float dist=distance(i.worldPos.xyz,_WorldSpaceCameraPos);
	                #endif
	                float fogVal=1-saturate((dist-_OverlayFogStartDistance)/(_OverlayFogDistanceTransition+_OverlayFogStartDistance));
	                fogVal=1-fogVal*fogVal; // ^2 better than linear
	                
	                float fogHeightVal=saturate((i.worldPos.y-_OverlayFogStartHeight-_OverlayFogDistance2Height*fogVal*fogVal) / (_OverlayFogHeightTransition+_OverlayFogStartHeight));
	                fogHeightVal=(1-fogHeightVal);
	                fogHeightVal*=fogHeightVal;

                	half3 ambientFogCol;
                	float3 fogViewDirection=-viewDirection;
                	fogViewDirection.y=abs(fogViewDirection.y);
                	#if defined(UNITY_PI) && defined(IBL_DIFFUSE_FOG_COLOR)
                		ambientFogCol = ShadeSH9(float4(fogViewDirection,1)).rgb*2;
                	#else
                		ambientFogCol = UNITY_LIGHTMODEL_AMBIENT.rgb*2;
                	#endif
	                half3 fogColor=lerp(_OverlayFogColorAfromAmbient.rgb, ambientFogCol, _OverlayFogColorAfromAmbient.a);
	                
	                #define REFLECTION_PROBE_FOG_MIPLEVEL (fogVal*2+3)
					#if defined(_IBLSPEC_ON) && defined(REFLECTION_PROBE_FOG_COLOR_ADD)
		                #ifdef UNITY_PI
							half4 rgbmf = SampleCubeReflection( unity_SpecCube0, fogViewDirection, REFLECTION_PROBE_FOG_MIPLEVEL );
			              	half3 fogScatterValue = DecodeHDR_NoLinearSupportInSM2 (rgbmf, unity_SpecCube0_HDR);
		              	#else
			                // U4 reflection probe
			                #ifdef SPEC_MIP_GLOSS
				                half3 fogScatterValue = DecodeRGBM( texCUBElod(unity_SpecCube0, float4(fogViewDirection, REFLECTION_PROBE_FOG_MIPLEVEL)) );
			                #else
				                half3 fogScatterValue = DecodeRGBM( texCUBEbias(unity_SpecCube0, float4(fogViewDirection, REFLECTION_PROBE_FOG_MIPLEVEL)) );
			                #endif
		              	#endif
		              	fogColor+=fogScatterValue*_OverlayFogAmountFromReflCubemap;
					#endif
	                	                
	                fogVal *= fogHeightVal*_OverlayFogAmount;
					//return float4 (fogVal.xxx*fogColor, 1);
	                finalColor = lerp(finalColor, fogColor, fogVal);
                #endif

                // emissive
                #ifdef _EMISSIVENESS_ON
	                float3 emissive = (emissiveness*(_EmissionColor.a*32))*pureColor*_EmissionColor.rgb;
		            #ifdef _WATER_ON
		            	emissive*=lerp(1, (1-_WaterColorAColorBlend.a), waterAmount); // opaque water stops emissiveness from underlying base
		            #endif
		            #ifdef _OVERLAYFOG_ON
	                	finalColor += lerp(1, _OverlayFogEmissivePunchThru, fogVal)*emissive; // emissiveness can be seen (punched) thru fog
	                #else
	                	finalColor += emissive;
	                #endif
                #endif

				finalColor = pow(finalColor, 1);

/// Final Color:
               	//#if defined(UNITY_PI) && !defined(NO_U5_FOG)
				//	UNITY_APPLY_FOG(i.worldPos.w, finalColor.rgb);
           		//#endif
           		#ifdef PER_VERTEX_FOG_DISTANCE
           			UNITY_APPLY_FOG(i.worldPos.w, finalColor.rgb);
           		#else
           			UNITY_APPLY_FOG(i.fogCoord, finalColor.rgb);
           		#endif
           			
				#ifdef _HORIZONDISK
					#ifdef _TRANSPARENCYFALLOFFQUAD             		
						return half4(finalColor,saturate(i.alpha*i.alpha-(1-i.alpha)*dot(finalColor.rgb,0.2)));
					#else
						return half4(finalColor,saturate(i.alpha-(1-i.alpha)*dot(finalColor.rgb,0.2)));
					#endif
				#else
					return half4(finalColor,1);
				#endif
				#endif // !_SHADOW_CASTER
            }