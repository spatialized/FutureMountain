Shader "NatureManufacture/URP/Water/Underwater"
{
    Properties
    {
        [Toggle(_USE_CAUSTIC)]_USE_CAUSTIC("Use Caustic", Float) = 1
        [NoScaleOffset]_Caustic("Caustic", 2D) = "white" {}
        _Caustic_Speed("Caustic Speed", Float) = 0.2
        _Caustic_Tiling("Caustic Tiling", Float) = 0.2
        _Caustic_Triplanar_Hardness("Caustic Triplanar Hardness", Float) = 3
        _Caustic_Falloff("Caustic Falloff", Float) = 3.33
        [HDR]_Caustic_Color("Caustic Color", Color) = (1, 1, 1, 1)
        _Caustic_Intensivity("Caustic Intensivity", Float) = 7.07
        _Caustic_Blend("Caustic Blend", Range(0, 1)) = 0.044
        _Caustic_Shadow_Reduction("Caustic Shadow Reduction", Range(0, 1)) = 0
        _Caustic_Distance_Multiply("Caustic Distance Multiply", Range(0, 200)) = 20
        _Caustic_Distance_Exp("Caustic Distance Exp", Range(0.01, 4)) = 1.3
        [Toggle(_USE_SIMPLE_FOG)]_USE_SIMPLE_FOG("Use Simple Fog", Float) = 0
        [HDR]_Shallow_Color("Shallow Color", Color) = (0, 0.7461715, 1, 0)
        [HDR]_Deep_Color("Deep Color", Color) = (0, 0.07718696, 0.1698113, 0)
        _Fog_Multiply("Fog Multiply", Range(0, 200)) = 46
        _Fog_Exp("Fog Exp", Range(0.01, 4)) = 1
        _Deep_Fog_Multiply("Deep Fog Multiply", Range(0, 400)) = 20
        _Deep_Fog_Exp("Deep Fog Exp", Range(0.01, 4)) = 2.7
        [Toggle(_USE_DISTORTION)]_USE_DISTORTION("Use Distortion", Float) = 1
        [Normal][NoScaleOffset]_Distortion_Texture("Distortion Texture", 2D) = "bump" {}
        [NoScaleOffset]_Distortion_Mask("Distortion Mask", 2D) = "white" {}
        _Underwater_Distortion_Power("Underwater Distortion Power", Float) = 0.03
        _Underwater_Distortion_Speed("Underwater Distortion Speed", Vector, 2) = (0.07, 0.07, 0, 0)
        _Underwater_Blur("Underwater Blur", Range(0, 3)) = 0.2
        _UnderWater_Distortion_Tiling("UnderWater Distortion Tiling", Float) = 0.3
        [Toggle(_USE_DROPLETS)]_USE_DROPLETS("Use Droplets", Float) = 0
        [Normal][NoScaleOffset]_Droplets("Droplets", 2D) = "bump" {}
        _UVDistortIntensity("Droplet Distortion", Range(0, 0.1)) = 0.0084
        _DistortionTilingX("Dropplet Distortion Tiling X", Range(0, 6)) = 1
        _DistortionTilingX_1("Dropplet Distortion Tiling Y", Range(0, 1)) = 1
        _Dropplet_Speed("Dropplet Speed", Float) = 0.2
        _Waterline_Power("Waterline Power", Range(1, 100)) = 40
        _Waterline_Multiply("Waterline Multiply", Float) = 7
        [Toggle(_USE_WATERLINE_BLUR)]_USE_WATERLINE_BLUR("Use  Waterline Blur", Float) = 1
        _Waterline_Blur_Power("Waterline Blur Power", Range(0.01, 4)) = 1
        _Waterline_Blur_Strenght("Waterline Blur Strenght", Range(0, 5)) = 2
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            // RenderType: <None>
            // Queue: <None>
            // DisableBatching: <None>
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalFullscreenSubTarget"
        }
        Pass
        {
            Name "DrawProcedural"
        
        // Render State
        Cull Off
        Blend Off
        ZTest Off
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma vertex vert
        #pragma fragment frag
        // #pragma enable_d3d11_debug_symbols
        
        /* WARNING: $splice Could not find named fragment 'DotsInstancingOptions' */
        /* WARNING: $splice Could not find named fragment 'HybridV1InjectedBuiltinProperties' */
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma dynamic_branch _ _USE_CAUSTIC
        #pragma dynamic_branch_local _ _USE_SIMPLE_FOG
        #pragma dynamic_branch _ _USE_DISTORTION
        #pragma dynamic_branch _ _USE_DROPLETS
        #pragma dynamic_branch _ _USE_WATERLINE_BLUR
        
        
        
        #define FULLSCREEN_SHADERGRAPH
        
        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_VERTEXID
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        
        // Force depth texture because we need it for almost every nodes
        // TODO: dependency system that triggers this define from position or view direction usage
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_NORMAL_TEXTURE
        
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DRAWPROCEDURAL
        #define REQUIRE_DEPTH_TEXTURE
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenShaderPass.cs.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
             uint vertexID : VERTEXID_SEMANTIC;
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float3 AbsoluteWorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Caustic_Shadow_Reduction;
        float _Caustic_Intensivity;
        float _Caustic_Falloff;
        float _Caustic_Triplanar_Hardness;
        float4 _Caustic_TexelSize;
        float _Fog_Exp;
        float _Fog_Multiply;
        float _Deep_Fog_Exp;
        float _Deep_Fog_Multiply;
        float4 _Deep_Color;
        float4 _Shallow_Color;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Blend;
        float4 _Caustic_Color;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float4 _Distortion_Mask_TexelSize;
        float _Underwater_Distortion_Power;
        float2 _Underwater_Distortion_Speed;
        float _Underwater_Blur;
        float _UnderWater_Distortion_Tiling;
        float4 _Droplets_TexelSize;
        float _UVDistortIntensity;
        float _DistortionTilingX;
        float _DistortionTilingX_1;
        float _Dropplet_Speed;
        float _Waterline_Power;
        float _Waterline_Multiply;
        float _Waterline_Blur_Power;
        float _Waterline_Blur_Strenght;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Clamp);
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_NMTransparentDepthTexture);
        SAMPLER(sampler_NMTransparentDepthTexture);
        float4 _NMTransparentDepthTexture_TexelSize;
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_NMWaterLevelTex);
        SAMPLER(sampler_NMWaterLevelTex);
        float4 _NMWaterLevelTex_TexelSize;
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        TEXTURE2D(_Distortion_Mask);
        SAMPLER(sampler_Distortion_Mask);
        TEXTURE2D(_Droplets);
        SAMPLER(sampler_Droplets);
        float _FlipY;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        TEXTURE2D_X(_BlitTexture);
        float4 Unity_Universal_SampleBuffer_BlitSource_float(float2 uv)
        {
            uint2 pixelCoords = uint2(uv * _ScreenSize.xy);
            return LOAD_TEXTURE2D_X_LOD(_BlitTexture, pixelCoords, 0);
        }
        
        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }
        
        void Unity_DDY_0e907faf81734c558aba6597c2a95dec_float3(float3 In, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'DDY' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = ddy(In);
        }
        
        void Unity_DDX_a3b8c8bd55e349e980d104178e569227_float3(float3 In, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'DDX' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            Out = ddx(In);
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        struct Bindings_FaceNormal_e1024532a1a801f41a6f45f93c8da7a8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_FaceNormal_e1024532a1a801f41a6f45f93c8da7a8_float(int _Space, Bindings_FaceNormal_e1024532a1a801f41a6f45f93c8da7a8_float IN, out float3 Out_1)
        {
        float3 _DDY_0e907faf81734c558aba6597c2a95dec_Out_1_Vector3;
        Unity_DDY_0e907faf81734c558aba6597c2a95dec_float3(IN.AbsoluteWorldSpacePosition, _DDY_0e907faf81734c558aba6597c2a95dec_Out_1_Vector3);
        float3 _DDX_a3b8c8bd55e349e980d104178e569227_Out_1_Vector3;
        Unity_DDX_a3b8c8bd55e349e980d104178e569227_float3(IN.AbsoluteWorldSpacePosition, _DDX_a3b8c8bd55e349e980d104178e569227_Out_1_Vector3);
        float3 _CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3;
        Unity_CrossProduct_float(_DDY_0e907faf81734c558aba6597c2a95dec_Out_1_Vector3, _DDX_a3b8c8bd55e349e980d104178e569227_Out_1_Vector3, _CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3);
        float3 _Transform_5f0973a3c25d42ca88ddf98cca780606_Out_1_Vector3;
        _Transform_5f0973a3c25d42ca88ddf98cca780606_Out_1_Vector3 = TransformWorldToObjectNormal(_CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3.xyz, false);
        float3 _Transform_87f746fe95c141f49c4a384d6514b2f2_Out_1_Vector3;
        _Transform_87f746fe95c141f49c4a384d6514b2f2_Out_1_Vector3 = TransformWorldToViewNormal(_CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3.xyz, false);
        float3 _Transform_8d417530668644b58d83669f29f62b52_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_8d417530668644b58d83669f29f62b52_Out_1_Vector3 = TransformWorldToTangent(_CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3.xyz, tangentTransform, false);
        }
        float3 _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3;
        if (_Space == 0)
        {
        _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3 = _Transform_5f0973a3c25d42ca88ddf98cca780606_Out_1_Vector3;
        }
        else if (_Space == 1)
        {
        _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3 = _Transform_87f746fe95c141f49c4a384d6514b2f2_Out_1_Vector3;
        }
        else if (_Space == 2)
        {
        _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3 = _CrossProduct_e7988e207bce4b3e9d90ff02f1716bb6_Out_2_Vector3;
        }
        else if (_Space == 3)
        {
        _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3 = _Transform_8d417530668644b58d83669f29f62b52_Out_1_Vector3;
        }
        else
        {
        _Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3 = _Transform_5f0973a3c25d42ca88ddf98cca780606_Out_1_Vector3;
        }
        float3 _Normalize_f0ef3f4e40184ff4b5e1766a11c6d7ea_Out_1_Vector3;
        Unity_Normalize_float3(_Space_baa2c6909f8445c1929d4b5b069539b9_Out_0_Vector3, _Normalize_f0ef3f4e40184ff4b5e1766a11c6d7ea_Out_1_Vector3);
        Out_1 = _Normalize_f0ef3f4e40184ff4b5e1766a11c6d7ea_Out_1_Vector3;
        }
        
        // unity-custom-func-begin
        void GetLightData_float(float3 positionWS, out float3 lightDir, out float3 color, out float distanceAttenuation, out float shadowAttenuation){
         color = float3(0, 0, 0);
        distanceAttenuation = 0;
        shadowAttenuation =  0;
        #ifdef SHADERGRAPH_PREVIEW
        
            lightDir = float3(0.707, 0.707, 0);
        
            color = 128000;
            distanceAttenuation = 0;
            shadowAttenuation =  0;
        
        #else
        
          
        
        
        
                Light mainLight = GetMainLight(TransformWorldToShadowCoord(positionWS));
        
                lightDir = -mainLight.direction;
        
                color = mainLight.color;
               distanceAttenuation = mainLight.distanceAttenuation;
               shadowAttenuation =  mainLight.shadowAttenuation;
                
        
          
        
        #endif
        }
        // unity-custom-func-end
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        struct Bindings_LightDataURP_a02ff11a29d676645b44ec159fdb9001_float
        {
        float3 AbsoluteWorldSpacePosition;
        };
        
        void SG_LightDataURP_a02ff11a29d676645b44ec159fdb9001_float(Bindings_LightDataURP_a02ff11a29d676645b44ec159fdb9001_float IN, out float3 Direction_1, out float3 Color_2, out float distanceAttenuation_3, out float shadowAttenuation_4)
        {
        float3 _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_lightDir_0_Vector3;
        float3 _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_color_1_Vector3;
        float _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_distanceAttenuation_2_Float;
        float _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_shadowAttenuation_3_Float;
        GetLightData_float(IN.AbsoluteWorldSpacePosition, _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_lightDir_0_Vector3, _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_color_1_Vector3, _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_distanceAttenuation_2_Float, _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_shadowAttenuation_3_Float);
        float3 _Clamp_d0e121f15e9b4bc78655a4ed324774b9_Out_3_Vector3;
        Unity_Clamp_float3(_GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_lightDir_0_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_d0e121f15e9b4bc78655a4ed324774b9_Out_3_Vector3);
        float3 _Clamp_cae8c421a0c141f79e638702618f11ad_Out_3_Vector3;
        Unity_Clamp_float3(_GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_color_1_Vector3, float3(0.01, 0.01, 0.01), float3(1000000, 100000, 100000), _Clamp_cae8c421a0c141f79e638702618f11ad_Out_3_Vector3);
        Direction_1 = _Clamp_d0e121f15e9b4bc78655a4ed324774b9_Out_3_Vector3;
        Color_2 = _Clamp_cae8c421a0c141f79e638702618f11ad_Out_3_Vector3;
        distanceAttenuation_3 = _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_distanceAttenuation_2_Float;
        shadowAttenuation_4 = _GetLightDataCustomFunction_7080735260b3168baa0a08cab565a2c1_shadowAttenuation_3_Float;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        // unity-custom-func-begin
        void ComputeWorld_float(float2 positionNDC, float deviceDepth, float4x4 invViewProjMatrix, out float3 Out){
        Out = ComputeWorldSpacePosition(positionNDC,deviceDepth,invViewProjMatrix);
        }
        // unity-custom-func-end
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        struct Bindings_Caustic_40069613a7406f14da7bfcc13509b29b_float
        {
        float3 AbsoluteWorldSpacePosition;
        float2 NDCPosition;
        float3 TimeParameters;
        };
        
        void SG_Caustic_40069613a7406f14da7bfcc13509b29b_float(UnityTexture2D _Texture2D, float _Tiling, float _Triplanar_Hardness, float _Scene_Depth_Raw, float3 _Sample_Buffer_Normal_World, float _Caustic_Speed, float _Caustic_Strenght, float _Caustic_Shadow_Reduction, float3 _Distortion, Bindings_Caustic_40069613a7406f14da7bfcc13509b29b_float IN, out float4 OutVector4_1, out float Out_NoShadows_2, out float out_postprocess_3)
        {
        Bindings_LightDataURP_a02ff11a29d676645b44ec159fdb9001_float _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9;
        _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
        float3 _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_Direction_1_Vector3;
        float3 _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_Color_2_Vector3;
        float _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_distanceAttenuation_3_Float;
        float _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_shadowAttenuation_4_Float;
        SG_LightDataURP_a02ff11a29d676645b44ec159fdb9001_float(_LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9, _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_Direction_1_Vector3, _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_Color_2_Vector3, _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_distanceAttenuation_3_Float, _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_shadowAttenuation_4_Float);
        float _Multiply_17592d1e94bf41ab816963eea14d3775_Out_2_Float;
        Unity_Multiply_float_float(_LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_distanceAttenuation_3_Float, _LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_shadowAttenuation_4_Float, _Multiply_17592d1e94bf41ab816963eea14d3775_Out_2_Float);
        float _Clamp_66ab6eaf44ed4c6eaf0361dd07f715d5_Out_3_Float;
        Unity_Clamp_float(_Multiply_17592d1e94bf41ab816963eea14d3775_Out_2_Float, float(0), float(1), _Clamp_66ab6eaf44ed4c6eaf0361dd07f715d5_Out_3_Float);
        float _Property_5f03cc955df6420eb340eb9ce9f8394a_Out_0_Float = _Caustic_Shadow_Reduction;
        float _OneMinus_8d22a6578c344313b971bc76f7272a9a_Out_1_Float;
        Unity_OneMinus_float(_Property_5f03cc955df6420eb340eb9ce9f8394a_Out_0_Float, _OneMinus_8d22a6578c344313b971bc76f7272a9a_Out_1_Float);
        float _Add_426b49d2d7904356b201df7abc4ceb71_Out_2_Float;
        Unity_Add_float(_Clamp_66ab6eaf44ed4c6eaf0361dd07f715d5_Out_3_Float, _OneMinus_8d22a6578c344313b971bc76f7272a9a_Out_1_Float, _Add_426b49d2d7904356b201df7abc4ceb71_Out_2_Float);
        float _Clamp_14ba9beb69284481b23ee4bb91acb030_Out_3_Float;
        Unity_Clamp_float(_Add_426b49d2d7904356b201df7abc4ceb71_Out_2_Float, float(0), float(1), _Clamp_14ba9beb69284481b23ee4bb91acb030_Out_3_Float);
        float _Property_bab15b28b9cc427f8f656c3c71436618_Out_0_Float = _Caustic_Strenght;
        UnityTexture2D _Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D = _Texture2D;
        float _Property_cf56deeeaf784b7781218a4384f4d7be_Out_0_Float = _Caustic_Speed;
        float _Multiply_bf912aadbe41470b8e6b9b62348f86ce_Out_2_Float;
        Unity_Multiply_float_float(_Property_cf56deeeaf784b7781218a4384f4d7be_Out_0_Float, IN.TimeParameters.x, _Multiply_bf912aadbe41470b8e6b9b62348f86ce_Out_2_Float);
        float _Split_07a2ad293dc647b4ba15853b54241c9c_R_1_Float = _Multiply_bf912aadbe41470b8e6b9b62348f86ce_Out_2_Float;
        float _Split_07a2ad293dc647b4ba15853b54241c9c_G_2_Float = 0;
        float _Split_07a2ad293dc647b4ba15853b54241c9c_B_3_Float = 0;
        float _Split_07a2ad293dc647b4ba15853b54241c9c_A_4_Float = 0;
        float4 _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RGBA_4_Vector4;
        float3 _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RGB_5_Vector3;
        float2 _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RG_6_Vector2;
        Unity_Combine_float(_Split_07a2ad293dc647b4ba15853b54241c9c_R_1_Float, _Split_07a2ad293dc647b4ba15853b54241c9c_G_2_Float, _Split_07a2ad293dc647b4ba15853b54241c9c_B_3_Float, float(0), _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RGBA_4_Vector4, _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RGB_5_Vector3, _Combine_e391bc1cc0ea457d8c4d5c951a0af675_RG_6_Vector2);
        float3 _Multiply_855d7c27d2cf4c109f0650699c689802_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Combine_e391bc1cc0ea457d8c4d5c951a0af675_RGB_5_Vector3, float3(0.76, 0.73, 0.79), _Multiply_855d7c27d2cf4c109f0650699c689802_Out_2_Vector3);
        float4 _ScreenPosition_a5ecb2c15e734b6fbcc18eff816cc081_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
        float _Property_a0686044537d4459a80825ec1ab3be88_Out_0_Float = _Scene_Depth_Raw;
        float3 _ComputeWorldCustomFunction_cc95fddca3a345d38574a46766ea9439_Out_3_Vector3;
        ComputeWorld_float((_ScreenPosition_a5ecb2c15e734b6fbcc18eff816cc081_Out_0_Vector4.xy), _Property_a0686044537d4459a80825ec1ab3be88_Out_0_Float, UNITY_MATRIX_I_VP, _ComputeWorldCustomFunction_cc95fddca3a345d38574a46766ea9439_Out_3_Vector3);
        float3 _Transform_addd9310bfdd47cca2f82af36b847eab_Out_1_Vector3;
        _Transform_addd9310bfdd47cca2f82af36b847eab_Out_1_Vector3 = GetAbsolutePositionWS(_ComputeWorldCustomFunction_cc95fddca3a345d38574a46766ea9439_Out_3_Vector3.xyz);
        float3 _Multiply_0e59bc1d3a6241adb98cc540fe008c66_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Transform_addd9310bfdd47cca2f82af36b847eab_Out_1_Vector3, float3(1, 1, 1), _Multiply_0e59bc1d3a6241adb98cc540fe008c66_Out_2_Vector3);
        float3 _Add_39b844098db24ba3b094e1d65df2a09a_Out_2_Vector3;
        Unity_Add_float3(_Multiply_855d7c27d2cf4c109f0650699c689802_Out_2_Vector3, _Multiply_0e59bc1d3a6241adb98cc540fe008c66_Out_2_Vector3, _Add_39b844098db24ba3b094e1d65df2a09a_Out_2_Vector3);
        float3 _Property_826c56762afe441dad11d277aa5ae0b8_Out_0_Vector3 = _Sample_Buffer_Normal_World;
        float _Property_a16502a55f984486bfef4fc91d12fc4d_Out_0_Float = _Tiling;
        float _Property_76ba8da203f448c4a76edc2379156d72_Out_0_Float = _Triplanar_Hardness;
        float3 Triplanar_394d55cba80c45899ac45ca942c7384e_UV = _Add_39b844098db24ba3b094e1d65df2a09a_Out_2_Vector3 * _Property_a16502a55f984486bfef4fc91d12fc4d_Out_0_Float;
        float3 Triplanar_394d55cba80c45899ac45ca942c7384e_Blend = SafePositivePow_float(_Property_826c56762afe441dad11d277aa5ae0b8_Out_0_Vector3, min(_Property_76ba8da203f448c4a76edc2379156d72_Out_0_Float, floor(log2(Min_float())/log2(1/sqrt(3)))) );
        Triplanar_394d55cba80c45899ac45ca942c7384e_Blend /= dot(Triplanar_394d55cba80c45899ac45ca942c7384e_Blend, 1.0);
        float4 Triplanar_394d55cba80c45899ac45ca942c7384e_X = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_394d55cba80c45899ac45ca942c7384e_UV.zy);
        float4 Triplanar_394d55cba80c45899ac45ca942c7384e_Y = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_394d55cba80c45899ac45ca942c7384e_UV.xz);
        float4 Triplanar_394d55cba80c45899ac45ca942c7384e_Z = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_394d55cba80c45899ac45ca942c7384e_UV.xy);
        float4 _Triplanar_394d55cba80c45899ac45ca942c7384e_Out_0_Vector4 = Triplanar_394d55cba80c45899ac45ca942c7384e_X * Triplanar_394d55cba80c45899ac45ca942c7384e_Blend.x + Triplanar_394d55cba80c45899ac45ca942c7384e_Y * Triplanar_394d55cba80c45899ac45ca942c7384e_Blend.y + Triplanar_394d55cba80c45899ac45ca942c7384e_Z * Triplanar_394d55cba80c45899ac45ca942c7384e_Blend.z;
        float _Multiply_0a9ed8b591084486b0428d7641f227a7_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_bf912aadbe41470b8e6b9b62348f86ce_Out_2_Float, -1.07, _Multiply_0a9ed8b591084486b0428d7641f227a7_Out_2_Float);
        float3 _Add_35a040df64a7439595e72f31caf94623_Out_2_Vector3;
        Unity_Add_float3((_Multiply_0a9ed8b591084486b0428d7641f227a7_Out_2_Float.xxx), _Multiply_0e59bc1d3a6241adb98cc540fe008c66_Out_2_Vector3, _Add_35a040df64a7439595e72f31caf94623_Out_2_Vector3);
        float3 Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_UV = _Add_35a040df64a7439595e72f31caf94623_Out_2_Vector3 * _Property_a16502a55f984486bfef4fc91d12fc4d_Out_0_Float;
        float3 Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend = SafePositivePow_float(_Property_826c56762afe441dad11d277aa5ae0b8_Out_0_Vector3, min(_Property_76ba8da203f448c4a76edc2379156d72_Out_0_Float, floor(log2(Min_float())/log2(1/sqrt(3)))) );
        Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend /= dot(Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend, 1.0);
        float4 Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_X = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_UV.zy);
        float4 Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Y = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_UV.xz);
        float4 Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Z = SAMPLE_TEXTURE2D(_Property_782a679f39304966afca4b6892a4e44b_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_UV.xy);
        float4 _Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Out_0_Vector4 = Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_X * Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend.x + Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Y * Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend.y + Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Z * Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Blend.z;
        float4 _Minimum_86fca17887a24cecb2009e9a9644e2ca_Out_2_Vector4;
        Unity_Minimum_float4(_Triplanar_394d55cba80c45899ac45ca942c7384e_Out_0_Vector4, _Triplanar_1ea45d4bc5574f7aaa597f85f04b9aec_Out_0_Vector4, _Minimum_86fca17887a24cecb2009e9a9644e2ca_Out_2_Vector4);
        float4 _Multiply_15e2f2f34cef455cbb04c810bfb91d2a_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Property_bab15b28b9cc427f8f656c3c71436618_Out_0_Float.xxxx), _Minimum_86fca17887a24cecb2009e9a9644e2ca_Out_2_Vector4, _Multiply_15e2f2f34cef455cbb04c810bfb91d2a_Out_2_Vector4);
        float4 _Multiply_fa6a0f0a169a4f2b843f8216a6c1f178_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Clamp_14ba9beb69284481b23ee4bb91acb030_Out_3_Float.xxxx), _Multiply_15e2f2f34cef455cbb04c810bfb91d2a_Out_2_Vector4, _Multiply_fa6a0f0a169a4f2b843f8216a6c1f178_Out_2_Vector4);
        float4 _Clamp_dac8b7a418fd4637b2bb0cb7e1ea943b_Out_3_Vector4;
        Unity_Clamp_float4(_Multiply_fa6a0f0a169a4f2b843f8216a6c1f178_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_dac8b7a418fd4637b2bb0cb7e1ea943b_Out_3_Vector4);
        float4 _Clamp_1657e1e28ffe4eeb8b1d053241be4849_Out_3_Vector4;
        Unity_Clamp_float4(_Multiply_15e2f2f34cef455cbb04c810bfb91d2a_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1657e1e28ffe4eeb8b1d053241be4849_Out_3_Vector4);
        float _Add_05a27bbfa89c420b9472f3f185f305c9_Out_2_Float;
        Unity_Add_float(_LightDataURP_e6a081fefff24df7b4f1e46666e7ffb9_shadowAttenuation_4_Float, _OneMinus_8d22a6578c344313b971bc76f7272a9a_Out_1_Float, _Add_05a27bbfa89c420b9472f3f185f305c9_Out_2_Float);
        float _Clamp_e643413143f7427c9ad929acb17d035f_Out_3_Float;
        Unity_Clamp_float(_Add_05a27bbfa89c420b9472f3f185f305c9_Out_2_Float, float(0), float(1), _Clamp_e643413143f7427c9ad929acb17d035f_Out_3_Float);
        float4 _Multiply_2c4a9ec52d494e4888652923c830fb18_Out_2_Vector4;
        Unity_Multiply_float4_float4((_Clamp_e643413143f7427c9ad929acb17d035f_Out_3_Float.xxxx), _Multiply_15e2f2f34cef455cbb04c810bfb91d2a_Out_2_Vector4, _Multiply_2c4a9ec52d494e4888652923c830fb18_Out_2_Vector4);
        float4 _Clamp_65c490a7d5f744adaacdee4c1135480d_Out_3_Vector4;
        Unity_Clamp_float4(_Multiply_2c4a9ec52d494e4888652923c830fb18_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_65c490a7d5f744adaacdee4c1135480d_Out_3_Vector4);
        OutVector4_1 = _Clamp_dac8b7a418fd4637b2bb0cb7e1ea943b_Out_3_Vector4;
        Out_NoShadows_2 = (_Clamp_1657e1e28ffe4eeb8b1d053241be4849_Out_3_Vector4).x;
        out_postprocess_3 = (_Clamp_65c490a7d5f744adaacdee4c1135480d_Out_3_Vector4).x;
        }
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        // GraphVertex: <None>
        
        // Custom interpolators, pre surface
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_24eb191641414551a916d7cdb0a5f6c5_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Deep_Color) : _Deep_Color;
            float4 _Property_ec5a798e56b14cdcab6ae0762b62a83d_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Shallow_Color) : _Shallow_Color;
            float _SceneDepth_98899af40e9845f3ac7b6611fcaec2fc_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_98899af40e9845f3ac7b6611fcaec2fc_Out_1_Float);
            float _Property_8c3b15d6d0cf4fc898a4d67a8fa64f54_Out_0_Float = _Deep_Fog_Multiply;
            float _Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_98899af40e9845f3ac7b6611fcaec2fc_Out_1_Float, _Property_8c3b15d6d0cf4fc898a4d67a8fa64f54_Out_0_Float, _Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float);
            float _Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float;
            Unity_Clamp_float(_Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float, float(0), float(10000), _Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float);
            float _Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float;
            Unity_Absolute_float(_Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float, _Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float);
            float _Property_398cf7319dff4e06ad43d5b60db5c9f1_Out_0_Float = _Deep_Fog_Exp;
            float _Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float;
            Unity_Power_float(_Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float, _Property_398cf7319dff4e06ad43d5b60db5c9f1_Out_0_Float, _Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float);
            float _Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float;
            Unity_Clamp_float(_Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float, float(0), float(1), _Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float);
            float4 _Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4;
            Unity_Lerp_float4(_Property_24eb191641414551a916d7cdb0a5f6c5_Out_0_Vector4, _Property_ec5a798e56b14cdcab6ae0762b62a83d_Out_0_Vector4, (_Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float.xxxx), _Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4);
            float4 _ScreenPosition_640e04266eb04b7abf5e045f8b7634e1_Out_0_Vector4 = IN.ScreenPosition;
            float4 _URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4 = Unity_Universal_SampleBuffer_BlitSource_float(_ScreenPosition_640e04266eb04b7abf5e045f8b7634e1_Out_0_Vector4.xy);
            float _Property_22dedc5c595d44aa9544140764ce6222_Out_0_Float = _Caustic_Intensivity;
            float4 _Divide_128265d61402433c89250b2fa87a5111_Out_2_Vector4;
            Unity_Divide_float4(_URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4, (_Property_22dedc5c595d44aa9544140764ce6222_Out_0_Float.xxxx), _Divide_128265d61402433c89250b2fa87a5111_Out_2_Vector4);
            UnityTexture2D _Property_806acc47d64846eca633dfd69a16e1d5_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float _Property_bd97707148704a679e8142acdbbc45bb_Out_0_Float = _Caustic_Tiling;
            float _Property_4b330f4994834cd1b67b101b242f5e29_Out_0_Float = _Caustic_Triplanar_Hardness;
            float _SceneDepth_678e75a746694b8badd83e4a9281a0aa_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_678e75a746694b8badd83e4a9281a0aa_Out_1_Float);
            Bindings_FaceNormal_e1024532a1a801f41a6f45f93c8da7a8_float _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef;
            _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef.WorldSpaceNormal = IN.WorldSpaceNormal;
            _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef.WorldSpaceTangent = IN.WorldSpaceTangent;
            _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float3 _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef_Out_1_Vector3;
            SG_FaceNormal_e1024532a1a801f41a6f45f93c8da7a8_float(2, _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef, _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef_Out_1_Vector3);
            float _Property_7f769c39aa7d4594bccaf1834cf37329_Out_0_Float = _Caustic_Speed;
            float _Property_89799058990448d18baac5c98e59f135_Out_0_Float = _Caustic_Falloff;
            float _Property_6c780ce360f541cfa44077856068cc34_Out_0_Float = _Caustic_Shadow_Reduction;
            Bindings_Caustic_40069613a7406f14da7bfcc13509b29b_float _Caustic_9d8da243d894427984dc8e48cb45f436;
            _Caustic_9d8da243d894427984dc8e48cb45f436.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _Caustic_9d8da243d894427984dc8e48cb45f436.NDCPosition = IN.NDCPosition;
            _Caustic_9d8da243d894427984dc8e48cb45f436.TimeParameters = IN.TimeParameters;
            float4 _Caustic_9d8da243d894427984dc8e48cb45f436_OutVector4_1_Vector4;
            float _Caustic_9d8da243d894427984dc8e48cb45f436_OutNoShadows_2_Float;
            float _Caustic_9d8da243d894427984dc8e48cb45f436_outpostprocess_3_Float;
            SG_Caustic_40069613a7406f14da7bfcc13509b29b_float(_Property_806acc47d64846eca633dfd69a16e1d5_Out_0_Texture2D, _Property_bd97707148704a679e8142acdbbc45bb_Out_0_Float, _Property_4b330f4994834cd1b67b101b242f5e29_Out_0_Float, _SceneDepth_678e75a746694b8badd83e4a9281a0aa_Out_1_Float, _FaceNormal_a8138f990ecf4a41a84f4540bc7b18ef_Out_1_Vector3, _Property_7f769c39aa7d4594bccaf1834cf37329_Out_0_Float, _Property_89799058990448d18baac5c98e59f135_Out_0_Float, _Property_6c780ce360f541cfa44077856068cc34_Out_0_Float, float3 (0, 0, 0), _Caustic_9d8da243d894427984dc8e48cb45f436, _Caustic_9d8da243d894427984dc8e48cb45f436_OutVector4_1_Vector4, _Caustic_9d8da243d894427984dc8e48cb45f436_OutNoShadows_2_Float, _Caustic_9d8da243d894427984dc8e48cb45f436_outpostprocess_3_Float);
            float4 _Property_a00b95e1d9874b87b6e97d92ff0df55c_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_cef039b37c484979b38bdfa556d59584_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Caustic_9d8da243d894427984dc8e48cb45f436_outpostprocess_3_Float.xxxx), _Property_a00b95e1d9874b87b6e97d92ff0df55c_Out_0_Vector4, _Multiply_cef039b37c484979b38bdfa556d59584_Out_2_Vector4);
            float4 _Absolute_e8ec9ae2c4d14e7795a25a184af9c343_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_cef039b37c484979b38bdfa556d59584_Out_2_Vector4, _Absolute_e8ec9ae2c4d14e7795a25a184af9c343_Out_1_Vector4);
            float4 _Power_411981e69bcf41198d865965aedc27d4_Out_2_Vector4;
            Unity_Power_float4(_Absolute_e8ec9ae2c4d14e7795a25a184af9c343_Out_1_Vector4, (_Property_22dedc5c595d44aa9544140764ce6222_Out_0_Float.xxxx), _Power_411981e69bcf41198d865965aedc27d4_Out_2_Vector4);
            float4 _Multiply_d2e93307f0094c4f9be1a83cb82bccde_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_411981e69bcf41198d865965aedc27d4_Out_2_Vector4, (_Property_22dedc5c595d44aa9544140764ce6222_Out_0_Float.xxxx), _Multiply_d2e93307f0094c4f9be1a83cb82bccde_Out_2_Vector4);
            float4 _Add_f37fd1e8aae9479db08fca4d767af2e2_Out_2_Vector4;
            Unity_Add_float4(_Divide_128265d61402433c89250b2fa87a5111_Out_2_Vector4, _Multiply_d2e93307f0094c4f9be1a83cb82bccde_Out_2_Vector4, _Add_f37fd1e8aae9479db08fca4d767af2e2_Out_2_Vector4);
            float _Property_292521dc819b4d09ae5e0fbce346d868_Out_0_Float = _Caustic_Blend;
            float _Property_75370f1b5c044fedb26e89714aecfb5e_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_95efe80909ca46c39f18e3e41d214e0f_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_98899af40e9845f3ac7b6611fcaec2fc_Out_1_Float, _Property_75370f1b5c044fedb26e89714aecfb5e_Out_0_Float, _Multiply_95efe80909ca46c39f18e3e41d214e0f_Out_2_Float);
            float _Clamp_4fd01a717d29442f8f44188f7f2c859f_Out_3_Float;
            Unity_Clamp_float(_Multiply_95efe80909ca46c39f18e3e41d214e0f_Out_2_Float, float(0), float(1), _Clamp_4fd01a717d29442f8f44188f7f2c859f_Out_3_Float);
            float _Absolute_3217a195857447329f296c84216f3c1a_Out_1_Float;
            Unity_Absolute_float(_Clamp_4fd01a717d29442f8f44188f7f2c859f_Out_3_Float, _Absolute_3217a195857447329f296c84216f3c1a_Out_1_Float);
            float _Property_ab2d0f614d864dc9b969fe3cdae96d3d_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_f7e3cd79ea6541dcade87b5f2018a407_Out_2_Float;
            Unity_Power_float(_Absolute_3217a195857447329f296c84216f3c1a_Out_1_Float, _Property_ab2d0f614d864dc9b969fe3cdae96d3d_Out_0_Float, _Power_f7e3cd79ea6541dcade87b5f2018a407_Out_2_Float);
            float _Clamp_31e8b5ff95a549dba7595403e59cc59a_Out_3_Float;
            Unity_Clamp_float(_Power_f7e3cd79ea6541dcade87b5f2018a407_Out_2_Float, float(0), float(1), _Clamp_31e8b5ff95a549dba7595403e59cc59a_Out_3_Float);
            UnityTexture2D _Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NMWaterLevelTex);
            float4 _ScreenPosition_8f6df1fbc7e14fa482111f61dcdff791_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float4 _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Clamp).samplerstate, _Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D.GetTransformedUV((_ScreenPosition_8f6df1fbc7e14fa482111f61dcdff791_Out_0_Vector4.xy)) );
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_R_4_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.r;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_G_5_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.g;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_B_6_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.b;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_A_7_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.a;
            float _OneMinus_c5ab85de92f04441b0425c165c6e967f_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_R_4_Float, _OneMinus_c5ab85de92f04441b0425c165c6e967f_Out_1_Float);
            float _Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float;
            Unity_Clamp_float(_OneMinus_c5ab85de92f04441b0425c165c6e967f_Out_1_Float, float(0), float(1), _Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float);
            float _Subtract_4eeb9d87824c4e15a42ad14abb67cf78_Out_2_Float;
            Unity_Subtract_float(_Clamp_31e8b5ff95a549dba7595403e59cc59a_Out_3_Float, _Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float, _Subtract_4eeb9d87824c4e15a42ad14abb67cf78_Out_2_Float);
            float _Clamp_b3f8f7b860174c5690197d3448635ac1_Out_3_Float;
            Unity_Clamp_float(_Subtract_4eeb9d87824c4e15a42ad14abb67cf78_Out_2_Float, float(0), float(1), _Clamp_b3f8f7b860174c5690197d3448635ac1_Out_3_Float);
            float _Multiply_4c92658bf1954dea95f6a2bc9dc1adf9_Out_2_Float;
            Unity_Multiply_float_float(_Property_292521dc819b4d09ae5e0fbce346d868_Out_0_Float, _Clamp_b3f8f7b860174c5690197d3448635ac1_Out_3_Float, _Multiply_4c92658bf1954dea95f6a2bc9dc1adf9_Out_2_Float);
            float4 _Lerp_7ce19479852a48cfa742e25d262b1c17_Out_3_Vector4;
            Unity_Lerp_float4(_URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4, _Add_f37fd1e8aae9479db08fca4d767af2e2_Out_2_Vector4, (_Multiply_4c92658bf1954dea95f6a2bc9dc1adf9_Out_2_Float.xxxx), _Lerp_7ce19479852a48cfa742e25d262b1c17_Out_3_Vector4);
            float4 _UseCaustic_add231dcbccd4b7ca6613419a1f01af5_Out_0_Vector4 = _USE_CAUSTIC ? _Lerp_7ce19479852a48cfa742e25d262b1c17_Out_3_Vector4 : _URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4;
            float _Property_dda2daa6a0f840f1bed05fa4bbf59f83_Out_0_Float = _Fog_Multiply;
            float _Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_98899af40e9845f3ac7b6611fcaec2fc_Out_1_Float, _Property_dda2daa6a0f840f1bed05fa4bbf59f83_Out_0_Float, _Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float);
            float _Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float;
            Unity_Clamp_float(_Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float, float(0), float(10000), _Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float);
            float _Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float;
            Unity_Absolute_float(_Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float, _Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float);
            float _Property_033d2fd4a54643c7b995d404035544fd_Out_0_Float = _Fog_Exp;
            float _Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float;
            Unity_Power_float(_Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float, _Property_033d2fd4a54643c7b995d404035544fd_Out_0_Float, _Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float);
            float _Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float;
            Unity_Clamp_float(_Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float, float(0), float(1), _Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float);
            float4 _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4, _UseCaustic_add231dcbccd4b7ca6613419a1f01af5_Out_0_Vector4, (_Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float.xxxx), _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector4);
            float4 _UseSimpleFog_e7400f5f0dd540fdbde681ff2f7b2c2d_Out_0_Vector4 = _USE_SIMPLE_FOG ? _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector4 : _UseCaustic_add231dcbccd4b7ca6613419a1f01af5_Out_0_Vector4;
            float4 _Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector4;
            Unity_Lerp_float4(_UseSimpleFog_e7400f5f0dd540fdbde681ff2f7b2c2d_Out_0_Vector4, _UseCaustic_add231dcbccd4b7ca6613419a1f01af5_Out_0_Vector4, (_Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float.xxxx), _Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector4);
            surface.BaseColor = (_Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector4.xyz);
            surface.Alpha = float(1);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            float3 normalWS = SHADERGRAPH_SAMPLE_SCENE_NORMAL(input.texCoord0.xy);
            float4 tangentWS = float4(0, 1, 0, 0); // We can't access the tangent in screen space
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
            float3 bitang = crossSign * cross(normalWS.xyz, tangentWS.xyz);
        
            output.WorldSpaceNormal = normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = tangentWS.xyz;
            output.WorldSpaceBiTangent = bitang;
        
            float3 viewDirWS = normalize(input.texCoord1.xyz);
            float linearDepth = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(input.texCoord0.xy), _ZBufferParams);
            float3 cameraForward = -UNITY_MATRIX_V[2].xyz;
            float camearDistance = linearDepth / dot(viewDirWS, cameraForward);
            float3 positionWS = viewDirWS * camearDistance + GetCameraPositionWS();
        
        
            output.WorldSpacePosition = positionWS;
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(positionWS);
            output.ScreenPosition = float4(input.texCoord0.xy, 0, 1);
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            output.NDCPosition = input.texCoord0.xy;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenCommon.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenDrawProcedural.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "DrawProcedural"
        
        // Render State
        Cull Off
        Blend Off
        ZTest Off
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma vertex vert
        #pragma fragment frag
        // #pragma enable_d3d11_debug_symbols
        
        /* WARNING: $splice Could not find named fragment 'DotsInstancingOptions' */
        /* WARNING: $splice Could not find named fragment 'HybridV1InjectedBuiltinProperties' */
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma dynamic_branch _ _USE_DROPLETS
        #pragma dynamic_branch _ _USE_WATERLINE_BLUR
        #pragma dynamic_branch _ _USE_DISTORTION
        #pragma dynamic_branch_local _ _USE_SIMPLE_FOG
        
        
        
        #define FULLSCREEN_SHADERGRAPH
        
        // Defines
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_VERTEXID
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        
        // Force depth texture because we need it for almost every nodes
        // TODO: dependency system that triggers this define from position or view direction usage
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_NORMAL_TEXTURE
        
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DRAWPROCEDURAL
        #define REQUIRE_DEPTH_TEXTURE
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenShaderPass.cs.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
             uint vertexID : VERTEXID_SEMANTIC;
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Tex_6_Texture2D_TexelSize;
        float _Fog_Exp;
        float _Fog_Multiply;
        float _Deep_Fog_Exp;
        float _Deep_Fog_Multiply;
        float _DistortionTilingX_1;
        float4 _Distortion_Mask_TexelSize;
        float _Underwater_Blur;
        float _Waterline_Blur_Power;
        float _Waterline_Power;
        float4 _Deep_Color;
        float4 _Shallow_Color;
        float _Underwater_Distortion_Power;
        float2 _Underwater_Distortion_Speed;
        float _UnderWater_Distortion_Tiling;
        float _Dropplet_Speed;
        float _DistortionTilingX;
        float _UVDistortIntensity;
        float4 _Distortion_Texture_TexelSize;
        float4 _Droplets_TexelSize;
        float _Waterline_Blur_Strenght;
        float _Waterline_Multiply;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Clamp);
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Tex_6_Texture2D);
        SAMPLER(sampler_SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Tex_6_Texture2D);
        TEXTURE2D(_NMTransparentDepthTexture);
        SAMPLER(sampler_NMTransparentDepthTexture);
        float4 _NMTransparentDepthTexture_TexelSize;
        TEXTURE2D(_Distortion_Mask);
        SAMPLER(sampler_Distortion_Mask);
        TEXTURE2D(_NMWaterLevelTex);
        SAMPLER(sampler_NMWaterLevelTex);
        float4 _NMWaterLevelTex_TexelSize;
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        TEXTURE2D(_Droplets);
        SAMPLER(sampler_Droplets);
        float _FlipY;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        TEXTURE2D_X(_BlitTexture);
        float4 Unity_Universal_SampleBuffer_BlitSource_float(float2 uv)
        {
            uint2 pixelCoords = uint2(uv * _ScreenSize.xy);
            return LOAD_TEXTURE2D_X_LOD(_BlitTexture, pixelCoords, 0);
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        // unity-custom-func-begin
        void SpiralBlurCustomFunction_float(float2 ScreenPosition, float2 ScenePixels, float2 SceneSize, float Blurriness, float Cycles, float SamplesPerCycle, float BlurMultiplier, UnityTexture2D Tex, float3 Hack, out float3 Out){
        float2 NextUV = ScreenPosition;
        
        float2 WidthHeightRatio = float2(SceneSize.y/SceneSize.x,1);
        
        float StepSize = Blurriness / (int) Cycles;
        
        float CurDistance=0;
        
        float2 CurOffset;
        
        
        
        float Substep;
        
        float Noise = SAMPLE_TEXTURE2D(Tex.tex,Tex.samplerstate,ScenePixels).w *2-1;
        
        
        
        
        
        if (Cycles<1)
        
        {
        
            uint2 pixelCoords = uint2(NextUV * _ScreenSize.xy);
        
            Out = LOAD_TEXTURE2D_X_LOD(_BlitTexture, pixelCoords, 0).xyz;
        
        }
        
        else
        
        {
        
            for (int i = 0; i < (int) Cycles; i++)
        
            {
        
                for (int j = 0; j < (int) SamplesPerCycle; j++)
        
                {
        
                    sincos(6.283185*((Noise+Substep) / SamplesPerCycle), CurOffset.y, CurOffset.x);
        
                    CurOffset *=BlurMultiplier;
        
                                      NextUV = ScreenPosition + (CurOffset * (CurDistance+(Noise*StepSize))* WidthHeightRatio);
        
        
        
                    uint2 pixelCoords = uint2(NextUV * _ScreenSize.xy);
        
                    Out += LOAD_TEXTURE2D_X_LOD(_BlitTexture, pixelCoords, 0).xyz;
        
                    Substep++;
        
                }
        
                CurDistance+=StepSize;
        
                Substep+=0.618;
        
        
        
            }
        
            Out = Out / ((int)Cycles*(int)SamplesPerCycle);
        
        }
        }
        // unity-custom-func-end
        
        struct Bindings_NMSceneColorBlur2_07548ac45fdad9f47a7a89b5095396a0_float
        {
        };
        
        void SG_NMSceneColorBlur2_07548ac45fdad9f47a7a89b5095396a0_float(float _Blurriness, float _Cycles, float _Samples_Per_Cycle, float _Blur_Multiplier, float3 _Scene_Color, float2 _Screen_Position, Bindings_NMSceneColorBlur2_07548ac45fdad9f47a7a89b5095396a0_float IN, out float3 BlurredScene_1)
        {
        float2 _Property_68b8cba2baf74ff8bff1f1fc313fb562_Out_0_Vector2 = _Screen_Position;
        float2 _Vector2_998892cf26734b919ba9542ffe6cf90e_Out_0_Vector2 = float2(_ScreenParams.x, _ScreenParams.y);
        float2 _Divide_737b1e9970fd41ae924bb8ef70f357c8_Out_2_Vector2;
        Unity_Divide_float2(_Vector2_998892cf26734b919ba9542ffe6cf90e_Out_0_Vector2, float2(64, 64), _Divide_737b1e9970fd41ae924bb8ef70f357c8_Out_2_Vector2);
        float2 _Multiply_bc0ffa015c204b7d814d67af14f89115_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Divide_737b1e9970fd41ae924bb8ef70f357c8_Out_2_Vector2, _Property_68b8cba2baf74ff8bff1f1fc313fb562_Out_0_Vector2, _Multiply_bc0ffa015c204b7d814d67af14f89115_Out_2_Vector2);
        float2 _Fraction_a1da500ba30b4003b09a72a4f2f3b783_Out_1_Vector2;
        Unity_Fraction_float2(_Multiply_bc0ffa015c204b7d814d67af14f89115_Out_2_Vector2, _Fraction_a1da500ba30b4003b09a72a4f2f3b783_Out_1_Vector2);
        float _Property_457966b5cf744fa7a7b8e2ade3c7fcbd_Out_0_Float = _Blurriness;
        float _Multiply_059c5d87a1b7461eadd6874afe75b071_Out_2_Float;
        Unity_Multiply_float_float(_Property_457966b5cf744fa7a7b8e2ade3c7fcbd_Out_0_Float, 0.5, _Multiply_059c5d87a1b7461eadd6874afe75b071_Out_2_Float);
        float _Property_8ddf146e6b174c2f99521adbcdf674c1_Out_0_Float = _Cycles;
        float _Property_3b407ca4de794e83aa320e35d66e6187_Out_0_Float = _Samples_Per_Cycle;
        float _Property_c7aecbe5f64d4fdc8adfb33996ed4a67_Out_0_Float = _Blur_Multiplier;
        float3 _Property_6fece3ac118b40919f69072010648e08_Out_0_Vector3 = _Scene_Color;
        float3 _SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Out_0_Vector3;
        SpiralBlurCustomFunction_float(_Property_68b8cba2baf74ff8bff1f1fc313fb562_Out_0_Vector2, _Fraction_a1da500ba30b4003b09a72a4f2f3b783_Out_1_Vector2, _Vector2_998892cf26734b919ba9542ffe6cf90e_Out_0_Vector2, _Multiply_059c5d87a1b7461eadd6874afe75b071_Out_2_Float, _Property_8ddf146e6b174c2f99521adbcdf674c1_Out_0_Float, _Property_3b407ca4de794e83aa320e35d66e6187_Out_0_Float, _Property_c7aecbe5f64d4fdc8adfb33996ed4a67_Out_0_Float, UnityBuildTexture2DStructNoScale(_SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Tex_6_Texture2D), _Property_6fece3ac118b40919f69072010648e08_Out_0_Vector3, _SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Out_0_Vector3);
        BlurredScene_1 = _SpiralBlurCustomFunctionCustomFunction_1a8f5730f4b2425aa252e141aacca6ba_Out_0_Vector3;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        // GraphVertex: <None>
        
        // Custom interpolators, pre surface
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_24eb191641414551a916d7cdb0a5f6c5_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Deep_Color) : _Deep_Color;
            float4 _Property_ec5a798e56b14cdcab6ae0762b62a83d_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Shallow_Color) : _Shallow_Color;
            float4 _ScreenPosition_dce3ef228ed64713a109cd33874394a9_Out_0_Vector4 = IN.ScreenPosition;
            UnityTexture2D _Property_6c46330cca9d4b2aaabe4337a544d961_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _ScreenPosition_8f6df1fbc7e14fa482111f61dcdff791_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float2 _Property_dfa10b64362b4a129563c7c40726a969_Out_0_Vector2 = _Underwater_Distortion_Speed;
            float2 _Multiply_4f987aed772345afba4c4207f2f72c83_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_dfa10b64362b4a129563c7c40726a969_Out_0_Vector2, _Multiply_4f987aed772345afba4c4207f2f72c83_Out_2_Vector2);
            float2 _Add_68899e1615a84786bc3e54825a38ab84_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_8f6df1fbc7e14fa482111f61dcdff791_Out_0_Vector4.xy), _Multiply_4f987aed772345afba4c4207f2f72c83_Out_2_Vector2, _Add_68899e1615a84786bc3e54825a38ab84_Out_2_Vector2);
            float _Property_562c3f2e4f71483ba13a320d3db5c462_Out_0_Float = _UnderWater_Distortion_Tiling;
            float2 _Multiply_7abc727e1a054b249d7cf6f3a83bb344_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_68899e1615a84786bc3e54825a38ab84_Out_2_Vector2, (_Property_562c3f2e4f71483ba13a320d3db5c462_Out_0_Float.xx), _Multiply_7abc727e1a054b249d7cf6f3a83bb344_Out_2_Vector2);
            float4 _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6c46330cca9d4b2aaabe4337a544d961_Out_0_Texture2D.tex, _Property_6c46330cca9d4b2aaabe4337a544d961_Out_0_Texture2D.samplerstate, _Property_6c46330cca9d4b2aaabe4337a544d961_Out_0_Texture2D.GetTransformedUV(_Multiply_7abc727e1a054b249d7cf6f3a83bb344_Out_2_Vector2) );
            _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4);
            float _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_R_4_Float = _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4.r;
            float _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_G_5_Float = _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4.g;
            float _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_B_6_Float = _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4.b;
            float _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_A_7_Float = _SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4.a;
            float4 _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4;
            Unity_Normalize_float4(_SampleTexture2D_3d7a57055f314302a76689a95a0f5c67_RGBA_0_Vector4, _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4);
            float _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_R_1_Float = _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4[0];
            float _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_G_2_Float = _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4[1];
            float _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_B_3_Float = _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4[2];
            float _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_A_4_Float = _Normalize_702764c50e1a40a3af84be8be287c201_Out_1_Vector4[3];
            float2 _Append_39de90e6cbca4c8296e78291fd2e48a5_Out_2_Vector2 = float2( _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_R_1_Float.x, _Split_0f81c61ac18f4c8c85d1aa8ecaaafa80_G_2_Float.x );
            UnityTexture2D _Property_553740d2b8154fc3b9b1cd1b57ea80e4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Mask);
            float4 _ScreenPosition_d6a61298d501472da2d2b68d017037f7_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float4 _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_553740d2b8154fc3b9b1cd1b57ea80e4_Out_0_Texture2D.tex, _Property_553740d2b8154fc3b9b1cd1b57ea80e4_Out_0_Texture2D.samplerstate, _Property_553740d2b8154fc3b9b1cd1b57ea80e4_Out_0_Texture2D.GetTransformedUV((_ScreenPosition_d6a61298d501472da2d2b68d017037f7_Out_0_Vector4.xy)) );
            _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4);
            float _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_R_4_Float = _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4.r;
            float _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_G_5_Float = _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4.g;
            float _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_B_6_Float = _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4.b;
            float _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_A_7_Float = _SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_RGBA_0_Vector4.a;
            float _Saturate_a539465e4bf948c480d9b8bc1eb2cd6c_Out_1_Float;
            Unity_Saturate_float(_SampleTexture2D_5ed1650542324e009fbc92ee9dc83c55_R_4_Float, _Saturate_a539465e4bf948c480d9b8bc1eb2cd6c_Out_1_Float);
            float _Property_f064f7c555f64d00bdec4af411fcac66_Out_0_Float = _Underwater_Distortion_Power;
            float _Multiply_4043762a52c24d108e11ab418c79fe1e_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a539465e4bf948c480d9b8bc1eb2cd6c_Out_1_Float, _Property_f064f7c555f64d00bdec4af411fcac66_Out_0_Float, _Multiply_4043762a52c24d108e11ab418c79fe1e_Out_2_Float);
            float2 _Multiply_37c50ed529db4dc99b01d97a82c29298_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Append_39de90e6cbca4c8296e78291fd2e48a5_Out_2_Vector2, (_Multiply_4043762a52c24d108e11ab418c79fe1e_Out_2_Float.xx), _Multiply_37c50ed529db4dc99b01d97a82c29298_Out_2_Vector2);
            UnityTexture2D _Property_36daa065dd024fcf98836ef69ee10968_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NMWaterLevelTex);
            float4 _ScreenPosition_1b01afe3567a488e867605f654345567_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float4 _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_36daa065dd024fcf98836ef69ee10968_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Clamp).samplerstate, _Property_36daa065dd024fcf98836ef69ee10968_Out_0_Texture2D.GetTransformedUV((_ScreenPosition_1b01afe3567a488e867605f654345567_Out_0_Vector4.xy)) );
            float _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_R_4_Float = _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_RGBA_0_Vector4.r;
            float _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_G_5_Float = _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_RGBA_0_Vector4.g;
            float _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_B_6_Float = _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_RGBA_0_Vector4.b;
            float _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_A_7_Float = _SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_RGBA_0_Vector4.a;
            float2 _Multiply_f7db19aa3e0140f284771c3fe37464e2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_37c50ed529db4dc99b01d97a82c29298_Out_2_Vector2, (_SampleTexture2D_4efba1c5ab7f4fbab3f66a2614723f25_R_4_Float.xx), _Multiply_f7db19aa3e0140f284771c3fe37464e2_Out_2_Vector2);
            float2 _Add_9d555f54b2e24e51bf0753d550823323_Out_2_Vector2;
            Unity_Add_float2((_ScreenPosition_dce3ef228ed64713a109cd33874394a9_Out_0_Vector4.xy), _Multiply_f7db19aa3e0140f284771c3fe37464e2_Out_2_Vector2, _Add_9d555f54b2e24e51bf0753d550823323_Out_2_Vector2);
            float2 _UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2 = _USE_DISTORTION ? _Add_9d555f54b2e24e51bf0753d550823323_Out_2_Vector2 : (_ScreenPosition_dce3ef228ed64713a109cd33874394a9_Out_0_Vector4.xy);
            float _SceneDepth_2b98999b92ff49d481a6db7d2912bf1f_Out_1_Float;
            Unity_SceneDepth_Raw_float((float4(_UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2, 0.0, 1.0)), _SceneDepth_2b98999b92ff49d481a6db7d2912bf1f_Out_1_Float);
            float _Property_14e86a29a38d423598aa0b0877a896fd_Out_0_Float = _Deep_Fog_Multiply;
            float _Multiply_6c29280be5714bf79eadc05cf10b8d87_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_2b98999b92ff49d481a6db7d2912bf1f_Out_1_Float, _Property_14e86a29a38d423598aa0b0877a896fd_Out_0_Float, _Multiply_6c29280be5714bf79eadc05cf10b8d87_Out_2_Float);
            UnityTexture2D _Property_732deafca7a849afb5d1fbed9e1acf6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NMTransparentDepthTexture);
              float4 _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_732deafca7a849afb5d1fbed9e1acf6a_Out_0_Texture2D.tex, _Property_732deafca7a849afb5d1fbed9e1acf6a_Out_0_Texture2D.samplerstate, _Property_732deafca7a849afb5d1fbed9e1acf6a_Out_0_Texture2D.GetTransformedUV(_UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2), float(0));
            float _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_R_5_Float = _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_G_6_Float = _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_B_7_Float = _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_A_8_Float = _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_RGBA_0_Vector4.a;
            float _Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_R_5_Float, _Property_14e86a29a38d423598aa0b0877a896fd_Out_0_Float, _Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float);
            float _Maximum_f144530538894d6a89feec7fe333af00_Out_2_Float;
            Unity_Maximum_float(_Multiply_6c29280be5714bf79eadc05cf10b8d87_Out_2_Float, _Multiply_42856f21957f42728c8c8cb4393f8f83_Out_2_Float, _Maximum_f144530538894d6a89feec7fe333af00_Out_2_Float);
            float _Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float;
            Unity_Clamp_float(_Maximum_f144530538894d6a89feec7fe333af00_Out_2_Float, float(0), float(10000), _Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float);
            float _Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float;
            Unity_Absolute_float(_Clamp_ba35c2a92af4438692d72d0a9f3ec15d_Out_3_Float, _Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float);
            float _Property_84f2458915d541d2b5cce8c75fadcb18_Out_0_Float = _Deep_Fog_Exp;
            float _Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float;
            Unity_Power_float(_Absolute_94df3ab566794d8d9698ef6490fdc1d2_Out_1_Float, _Property_84f2458915d541d2b5cce8c75fadcb18_Out_0_Float, _Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float);
            float _Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float;
            Unity_Clamp_float(_Power_9805a9cffbc44f55ba6e0052aafd06f7_Out_2_Float, float(0), float(1), _Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float);
            float4 _Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4;
            Unity_Lerp_float4(_Property_24eb191641414551a916d7cdb0a5f6c5_Out_0_Vector4, _Property_ec5a798e56b14cdcab6ae0762b62a83d_Out_0_Vector4, (_Clamp_6f18d97a928845bca8675ffefbd4689b_Out_3_Float.xxxx), _Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4);
            UnityTexture2D _Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NMWaterLevelTex);
            float _Split_6823169751b34c108ad1dc98495b525f_R_1_Float = _UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2[0];
            float _Split_6823169751b34c108ad1dc98495b525f_G_2_Float = _UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2[1];
            float _Split_6823169751b34c108ad1dc98495b525f_B_3_Float = 0;
            float _Split_6823169751b34c108ad1dc98495b525f_A_4_Float = 0;
            float4 _Combine_a1dc49dc735447e2ae1c3a193757f56e_RGBA_4_Vector4;
            float3 _Combine_a1dc49dc735447e2ae1c3a193757f56e_RGB_5_Vector3;
            float2 _Combine_a1dc49dc735447e2ae1c3a193757f56e_RG_6_Vector2;
            Unity_Combine_float(_Split_6823169751b34c108ad1dc98495b525f_R_1_Float, _Split_6823169751b34c108ad1dc98495b525f_G_2_Float, float(0), float(0), _Combine_a1dc49dc735447e2ae1c3a193757f56e_RGBA_4_Vector4, _Combine_a1dc49dc735447e2ae1c3a193757f56e_RGB_5_Vector3, _Combine_a1dc49dc735447e2ae1c3a193757f56e_RG_6_Vector2);
            float4 _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Clamp).samplerstate, _Property_e6d5a02050d14ce8949b4f909a71b1a4_Out_0_Texture2D.GetTransformedUV(_Combine_a1dc49dc735447e2ae1c3a193757f56e_RG_6_Vector2) );
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_R_4_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.r;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_G_5_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.g;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_B_6_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.b;
            float _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_A_7_Float = _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_RGBA_0_Vector4.a;
            float _Clamp_a182438872d1442bbe003ea10a85e78f_Out_3_Float;
            Unity_Clamp_float(_SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_G_5_Float, float(0), float(1), _Clamp_a182438872d1442bbe003ea10a85e78f_Out_3_Float);
            float _Property_188bdd048dfb4bc3ac4f0272d630e829_Out_0_Float = _Waterline_Blur_Power;
            float _Power_f70e899dc0b045c79ab3b1051564c336_Out_2_Float;
            Unity_Power_float(_Clamp_a182438872d1442bbe003ea10a85e78f_Out_3_Float, _Property_188bdd048dfb4bc3ac4f0272d630e829_Out_0_Float, _Power_f70e899dc0b045c79ab3b1051564c336_Out_2_Float);
            float _Clamp_9090f77d92744adc9a3afa1e501e00fc_Out_3_Float;
            Unity_Clamp_float(_Power_f70e899dc0b045c79ab3b1051564c336_Out_2_Float, float(0), float(1), _Clamp_9090f77d92744adc9a3afa1e501e00fc_Out_3_Float);
            float _Property_d23251e8547a4dbeb3cff6a4656a1ee7_Out_0_Float = _Waterline_Blur_Strenght;
            float _Multiply_524a28e9bb1c4ed4a968ced5a841b5e5_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_9090f77d92744adc9a3afa1e501e00fc_Out_3_Float, _Property_d23251e8547a4dbeb3cff6a4656a1ee7_Out_0_Float, _Multiply_524a28e9bb1c4ed4a968ced5a841b5e5_Out_2_Float);
            float _UseWaterlineBlur_3553ef8481464febbbf1b5900c41b78b_Out_0_Float = _USE_WATERLINE_BLUR ? _Multiply_524a28e9bb1c4ed4a968ced5a841b5e5_Out_2_Float : float(0);
            float _Float_e0ded1b3406c43fdaba9e365ad80d992_Out_0_Float = _UseWaterlineBlur_3553ef8481464febbbf1b5900c41b78b_Out_0_Float;
            float _Property_e02c6021f54642ddb48cf18b25b92f41_Out_0_Float = _Underwater_Blur;
            float _Multiply_81f0814ee8e24b75bb12e8a896bebc4d_Out_2_Float;
            Unity_Multiply_float_float(_Property_e02c6021f54642ddb48cf18b25b92f41_Out_0_Float, _SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_R_4_Float, _Multiply_81f0814ee8e24b75bb12e8a896bebc4d_Out_2_Float);
            float _Add_5be810e36b8348a1abd96e19ddb06346_Out_2_Float;
            Unity_Add_float(_Float_e0ded1b3406c43fdaba9e365ad80d992_Out_0_Float, _Multiply_81f0814ee8e24b75bb12e8a896bebc4d_Out_2_Float, _Add_5be810e36b8348a1abd96e19ddb06346_Out_2_Float);
            float _Saturate_e76cfa101441488b8fdf3dc5a08dc2b9_Out_1_Float;
            Unity_Saturate_float(_SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_B_6_Float, _Saturate_e76cfa101441488b8fdf3dc5a08dc2b9_Out_1_Float);
            float _Clamp_e2c64541a8c944a2b380b07824897f0c_Out_3_Float;
            Unity_Clamp_float(_Saturate_e76cfa101441488b8fdf3dc5a08dc2b9_Out_1_Float, float(0), float(1), _Clamp_e2c64541a8c944a2b380b07824897f0c_Out_3_Float);
            float _Subtract_8e2b6ed7ea84400a923c146503c076d8_Out_2_Float;
            Unity_Subtract_float(_Clamp_e2c64541a8c944a2b380b07824897f0c_Out_3_Float, _Clamp_a182438872d1442bbe003ea10a85e78f_Out_3_Float, _Subtract_8e2b6ed7ea84400a923c146503c076d8_Out_2_Float);
            float _Clamp_4a76c46de65e406f9f76d3a05366de26_Out_3_Float;
            Unity_Clamp_float(_Subtract_8e2b6ed7ea84400a923c146503c076d8_Out_2_Float, float(0), float(1), _Clamp_4a76c46de65e406f9f76d3a05366de26_Out_3_Float);
            UnityTexture2D _Property_26037c87127a42b588bb8e035038c379_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Droplets);
            float4 _ScreenPosition_79976e50709c4ddf8d9a5b943d801811_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Property_5b6edc83d759425aafc4ca39704fccfd_Out_0_Float = _DistortionTilingX;
            float _Property_e11e63cc0f7641c3a29ae31a1314f39c_Out_0_Float = _DistortionTilingX_1;
            float _Clamp_58f84e1e392c466db64c99966b6e46d5_Out_3_Float;
            Unity_Clamp_float(_Saturate_e76cfa101441488b8fdf3dc5a08dc2b9_Out_1_Float, float(0.01), float(1), _Clamp_58f84e1e392c466db64c99966b6e46d5_Out_3_Float);
            float _Multiply_80c72de33d914d75870af91489bd5272_Out_2_Float;
            Unity_Multiply_float_float(_Property_e11e63cc0f7641c3a29ae31a1314f39c_Out_0_Float, _Clamp_58f84e1e392c466db64c99966b6e46d5_Out_3_Float, _Multiply_80c72de33d914d75870af91489bd5272_Out_2_Float);
            float4 _Combine_8d124627f192428b858d7a46e3023488_RGBA_4_Vector4;
            float3 _Combine_8d124627f192428b858d7a46e3023488_RGB_5_Vector3;
            float2 _Combine_8d124627f192428b858d7a46e3023488_RG_6_Vector2;
            Unity_Combine_float(_Property_5b6edc83d759425aafc4ca39704fccfd_Out_0_Float, _Multiply_80c72de33d914d75870af91489bd5272_Out_2_Float, float(0), float(0), _Combine_8d124627f192428b858d7a46e3023488_RGBA_4_Vector4, _Combine_8d124627f192428b858d7a46e3023488_RGB_5_Vector3, _Combine_8d124627f192428b858d7a46e3023488_RG_6_Vector2);
            float _Property_555a5a92077f4f27a25768c3f4d3bef8_Out_0_Float = _Dropplet_Speed;
            float _Multiply_d8bffd67a0ce473fa0bb6ebb088d71c9_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_555a5a92077f4f27a25768c3f4d3bef8_Out_0_Float, _Multiply_d8bffd67a0ce473fa0bb6ebb088d71c9_Out_2_Float);
            float _Clamp_cc21ca60adee4a5faab83107229e035b_Out_3_Float;
            Unity_Clamp_float(_Saturate_e76cfa101441488b8fdf3dc5a08dc2b9_Out_1_Float, float(0), float(1), _Clamp_cc21ca60adee4a5faab83107229e035b_Out_3_Float);
            float _OneMinus_3cba50f4893f4383a79611667b374c7d_Out_1_Float;
            Unity_OneMinus_float(_Clamp_cc21ca60adee4a5faab83107229e035b_Out_3_Float, _OneMinus_3cba50f4893f4383a79611667b374c7d_Out_1_Float);
            float _Add_4de4af1a41294169bddcc85c8abf7488_Out_2_Float;
            Unity_Add_float(_Multiply_d8bffd67a0ce473fa0bb6ebb088d71c9_Out_2_Float, _OneMinus_3cba50f4893f4383a79611667b374c7d_Out_1_Float, _Add_4de4af1a41294169bddcc85c8abf7488_Out_2_Float);
            float4 _Combine_8861acaca83d4b3fbbaba34d16d80d88_RGBA_4_Vector4;
            float3 _Combine_8861acaca83d4b3fbbaba34d16d80d88_RGB_5_Vector3;
            float2 _Combine_8861acaca83d4b3fbbaba34d16d80d88_RG_6_Vector2;
            Unity_Combine_float(float(0), _Add_4de4af1a41294169bddcc85c8abf7488_Out_2_Float, float(0), float(0), _Combine_8861acaca83d4b3fbbaba34d16d80d88_RGBA_4_Vector4, _Combine_8861acaca83d4b3fbbaba34d16d80d88_RGB_5_Vector3, _Combine_8861acaca83d4b3fbbaba34d16d80d88_RG_6_Vector2);
            float2 _TilingAndOffset_86a0333585c94ef79f394ad00d4ced79_Out_3_Vector2;
            Unity_TilingAndOffset_float((_ScreenPosition_79976e50709c4ddf8d9a5b943d801811_Out_0_Vector4.xy), _Combine_8d124627f192428b858d7a46e3023488_RG_6_Vector2, _Combine_8861acaca83d4b3fbbaba34d16d80d88_RG_6_Vector2, _TilingAndOffset_86a0333585c94ef79f394ad00d4ced79_Out_3_Vector2);
            float4 _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_26037c87127a42b588bb8e035038c379_Out_0_Texture2D.tex, _Property_26037c87127a42b588bb8e035038c379_Out_0_Texture2D.samplerstate, _Property_26037c87127a42b588bb8e035038c379_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_86a0333585c94ef79f394ad00d4ced79_Out_3_Vector2) );
            _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4);
            float _SampleTexture2D_85a3339957e8499184d103c60a299c8e_R_4_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4.r;
            float _SampleTexture2D_85a3339957e8499184d103c60a299c8e_G_5_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4.g;
            float _SampleTexture2D_85a3339957e8499184d103c60a299c8e_B_6_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4.b;
            float _SampleTexture2D_85a3339957e8499184d103c60a299c8e_A_7_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4.a;
            float _Split_c24cbd19338e4c238a3d8adf7156a282_R_1_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4[0];
            float _Split_c24cbd19338e4c238a3d8adf7156a282_G_2_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4[1];
            float _Split_c24cbd19338e4c238a3d8adf7156a282_B_3_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4[2];
            float _Split_c24cbd19338e4c238a3d8adf7156a282_A_4_Float = _SampleTexture2D_85a3339957e8499184d103c60a299c8e_RGBA_0_Vector4[3];
            float4 _Combine_29753a14fed145578492604872a3eec6_RGBA_4_Vector4;
            float3 _Combine_29753a14fed145578492604872a3eec6_RGB_5_Vector3;
            float2 _Combine_29753a14fed145578492604872a3eec6_RG_6_Vector2;
            Unity_Combine_float(_Split_c24cbd19338e4c238a3d8adf7156a282_R_1_Float, _Split_c24cbd19338e4c238a3d8adf7156a282_G_2_Float, float(0), float(0), _Combine_29753a14fed145578492604872a3eec6_RGBA_4_Vector4, _Combine_29753a14fed145578492604872a3eec6_RGB_5_Vector3, _Combine_29753a14fed145578492604872a3eec6_RG_6_Vector2);
            float _Property_d79278afbb4647ed91f33143fcfe68db_Out_0_Float = _UVDistortIntensity;
            float2 _Multiply_d869870bc8ae41f389662226668f82c1_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_29753a14fed145578492604872a3eec6_RG_6_Vector2, (_Property_d79278afbb4647ed91f33143fcfe68db_Out_0_Float.xx), _Multiply_d869870bc8ae41f389662226668f82c1_Out_2_Vector2);
            float2 _Multiply_66c543be85744c93bcb9598aed2f95fd_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Clamp_4a76c46de65e406f9f76d3a05366de26_Out_3_Float.xx), _Multiply_d869870bc8ae41f389662226668f82c1_Out_2_Vector2, _Multiply_66c543be85744c93bcb9598aed2f95fd_Out_2_Vector2);
            float _OneMinus_967ca8f843894ed3aa3a6bb3fbed327a_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_R_4_Float, _OneMinus_967ca8f843894ed3aa3a6bb3fbed327a_Out_1_Float);
            float _Clamp_cf75807a0304463ebc3404647ee9b7a1_Out_3_Float;
            Unity_Clamp_float(_OneMinus_967ca8f843894ed3aa3a6bb3fbed327a_Out_1_Float, float(0), float(1), _Clamp_cf75807a0304463ebc3404647ee9b7a1_Out_3_Float);
            float _Absolute_67d102181d144e51b60930e747de9cac_Out_1_Float;
            Unity_Absolute_float(_SampleTexture2D_a668df0b3d354ef582d657dd95b476f5_G_5_Float, _Absolute_67d102181d144e51b60930e747de9cac_Out_1_Float);
            float _Property_95b22648b63b468dbc4f3d21e25d702c_Out_0_Float = _Waterline_Power;
            float _Power_b26ebadc8dde4aec931ce6fd1945fbc3_Out_2_Float;
            Unity_Power_float(_Absolute_67d102181d144e51b60930e747de9cac_Out_1_Float, _Property_95b22648b63b468dbc4f3d21e25d702c_Out_0_Float, _Power_b26ebadc8dde4aec931ce6fd1945fbc3_Out_2_Float);
            float _Property_a70b5e62e84d49548c7f7699ac21e2f5_Out_0_Float = _Waterline_Multiply;
            float _Multiply_7660654260964ac7b39e2cd1ae95e3c3_Out_2_Float;
            Unity_Multiply_float_float(_Power_b26ebadc8dde4aec931ce6fd1945fbc3_Out_2_Float, _Property_a70b5e62e84d49548c7f7699ac21e2f5_Out_0_Float, _Multiply_7660654260964ac7b39e2cd1ae95e3c3_Out_2_Float);
            float _Clamp_4624301fae484d24ad32495de1f19da6_Out_3_Float;
            Unity_Clamp_float(_Multiply_7660654260964ac7b39e2cd1ae95e3c3_Out_2_Float, float(0), float(1), _Clamp_4624301fae484d24ad32495de1f19da6_Out_3_Float);
            float _Add_3b86fe355ae9477bb5e79c529e60d6fd_Out_2_Float;
            Unity_Add_float(_Clamp_cf75807a0304463ebc3404647ee9b7a1_Out_3_Float, _Clamp_4624301fae484d24ad32495de1f19da6_Out_3_Float, _Add_3b86fe355ae9477bb5e79c529e60d6fd_Out_2_Float);
            float _Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float;
            Unity_Clamp_float(_Add_3b86fe355ae9477bb5e79c529e60d6fd_Out_2_Float, float(0), float(1), _Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float);
            float2 _Multiply_0abd01f4d3ce493f8875a5bc5cd4f63b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_66c543be85744c93bcb9598aed2f95fd_Out_2_Vector2, (_Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float.xx), _Multiply_0abd01f4d3ce493f8875a5bc5cd4f63b_Out_2_Vector2);
            float2 _UseDroplets_b7d133c3dca7457db4df6ceba5923ebd_Out_0_Vector2 = _USE_DROPLETS ? _Multiply_0abd01f4d3ce493f8875a5bc5cd4f63b_Out_2_Vector2 : float2(0, 0);
            float2 _Add_45a1a92c9c334a73bfd6dc115a25dbc3_Out_2_Vector2;
            Unity_Add_float2(_UseDistortion_7976697a3f0248b3a1e8910ff1283d69_Out_0_Vector2, _UseDroplets_b7d133c3dca7457db4df6ceba5923ebd_Out_0_Vector2, _Add_45a1a92c9c334a73bfd6dc115a25dbc3_Out_2_Vector2);
            float4 _URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4 = Unity_Universal_SampleBuffer_BlitSource_float((float4(_Add_45a1a92c9c334a73bfd6dc115a25dbc3_Out_2_Vector2, 0.0, 1.0)).xy);
            Bindings_NMSceneColorBlur2_07548ac45fdad9f47a7a89b5095396a0_float _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab;
            float3 _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab_BlurredScene_1_Vector3;
            SG_NMSceneColorBlur2_07548ac45fdad9f47a7a89b5095396a0_float(float(0.03), float(3), float(3), _Add_5be810e36b8348a1abd96e19ddb06346_Out_2_Float, (_URPSampleBuffer_ba1157bee9ba41b7bd565613aedf4737_Output_2_Vector4.xyz), _Add_45a1a92c9c334a73bfd6dc115a25dbc3_Out_2_Vector2, _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab, _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab_BlurredScene_1_Vector3);
            float _Clamp_61a23a25a75645f6a9fc970f959ecb62_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_2b98999b92ff49d481a6db7d2912bf1f_Out_1_Float, float(0), float(1), _Clamp_61a23a25a75645f6a9fc970f959ecb62_Out_3_Float);
            float _Maximum_528ffcbd87e448e4a869b1fb4abfb849_Out_2_Float;
            Unity_Maximum_float(_SceneDepth_2b98999b92ff49d481a6db7d2912bf1f_Out_1_Float, _SampleTexture2DLOD_d2c56e15bde34396a2a5c87ff859afac_R_5_Float, _Maximum_528ffcbd87e448e4a869b1fb4abfb849_Out_2_Float);
            float _Property_fe7ab5979da244c4a8b98161ba244f28_Out_0_Float = _Fog_Multiply;
            float _Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_528ffcbd87e448e4a869b1fb4abfb849_Out_2_Float, _Property_fe7ab5979da244c4a8b98161ba244f28_Out_0_Float, _Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float);
            float _Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float;
            Unity_Clamp_float(_Multiply_149fd97c1ca04eeeafda30a22de8730f_Out_2_Float, float(0), float(10000), _Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float);
            float _Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float;
            Unity_Absolute_float(_Clamp_2f699980f33e4515a0911cb93c654c46_Out_3_Float, _Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float);
            float _Property_e205f74f4b874a95bd024cc7414704e9_Out_0_Float = _Fog_Exp;
            float _Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float;
            Unity_Power_float(_Absolute_353e446496e141aba5349ffe9383866c_Out_1_Float, _Property_e205f74f4b874a95bd024cc7414704e9_Out_0_Float, _Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float);
            float _Clamp_2dfb1582279244bb82c720f3c66c56db_Out_3_Float;
            Unity_Clamp_float(_Power_025d6fcc3bc34b7bbe02da7ff00a296d_Out_2_Float, float(0), float(1), _Clamp_2dfb1582279244bb82c720f3c66c56db_Out_3_Float);
            float _Maximum_637eaad781df4f53befef0f1b69f4261_Out_2_Float;
            Unity_Maximum_float(_Clamp_61a23a25a75645f6a9fc970f959ecb62_Out_3_Float, _Clamp_2dfb1582279244bb82c720f3c66c56db_Out_3_Float, _Maximum_637eaad781df4f53befef0f1b69f4261_Out_2_Float);
            float _Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float;
            Unity_Clamp_float(_Maximum_637eaad781df4f53befef0f1b69f4261_Out_2_Float, float(0.03), float(1), _Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float);
            float3 _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector3;
            Unity_Lerp_float3((_Lerp_db54b9b205f741279556d1f68c9399f9_Out_3_Vector4.xyz), _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab_BlurredScene_1_Vector3, (_Clamp_6e1eee5c76b44094896e923c59c696e1_Out_3_Float.xxx), _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector3);
            float3 _UseSimpleFog_e7400f5f0dd540fdbde681ff2f7b2c2d_Out_0_Vector3 = _USE_SIMPLE_FOG ? _Lerp_17ebedf5424a40e585bf1fb3065c01f3_Out_3_Vector3 : _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab_BlurredScene_1_Vector3;
            float3 _Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector3;
            Unity_Lerp_float3(_UseSimpleFog_e7400f5f0dd540fdbde681ff2f7b2c2d_Out_0_Vector3, _NMSceneColorBlur2_4347873329d7462d8a7b6bd6bfce47ab_BlurredScene_1_Vector3, (_Clamp_c935052085fb46aaabb0f03c2d74d632_Out_3_Float.xxx), _Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector3);
            surface.BaseColor = _Lerp_6296dee8bdfb48faab081b8b444e3b8f_Out_3_Vector3;
            surface.Alpha = float(1);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            float3 normalWS = SHADERGRAPH_SAMPLE_SCENE_NORMAL(input.texCoord0.xy);
            float4 tangentWS = float4(0, 1, 0, 0); // We can't access the tangent in screen space
        
        
        
        
            float3 viewDirWS = normalize(input.texCoord1.xyz);
            float linearDepth = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(input.texCoord0.xy), _ZBufferParams);
            float3 cameraForward = -UNITY_MATRIX_V[2].xyz;
            float camearDistance = linearDepth / dot(viewDirWS, cameraForward);
            float3 positionWS = viewDirWS * camearDistance + GetCameraPositionWS();
        
        
            output.WorldSpacePosition = positionWS;
            output.ScreenPosition = float4(input.texCoord0.xy, 0, 1);
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            output.NDCPosition = input.texCoord0.xy;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenCommon.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenDrawProcedural.hlsl"
        
        ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.Rendering.Fullscreen.ShaderGraph.FullscreenShaderGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}