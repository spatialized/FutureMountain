Shader "NatureManufacture/URP/Water/NM Decal Caustic Directional"
{
    Properties
    {
        [NoScaleOffset]_Caustic("Caustic", 2D) = "white" {}
        _Caustic_Speed("Caustic Speed", Float) = 0.03
        _Caustic_Tiling("Caustic Tiling", Float) = 1
        _Caustic_Falloff("Caustic Falloff", Float) = 2.33
        [HDR]_Caustic_Color("Caustic Color", Color) = (1, 1, 1, 1)
        _Caustic_Intensivity("Caustic Intensivity", Float) = 7.07
        _Caustic_Blend("Caustic Blend", Range(0, 1)) = 1
        [Toggle(_CAUSTIC_DISTANCE_BLEND)]_CAUSTIC_DISTANCE_BLEND("Caustic Distance Blend", Float) = 1
        _Caustic_Distance_Multiply("Caustic Distance Multiply", Range(0.01, 200)) = 20
        _Caustic_Distance_Exp("Caustic Distance Exp", Range(0.01, 4)) = 1.3
        [Toggle(_USE_DISTORTION)]_USE_DISTORTION("Use Distortion", Float) = 1
        [NoScaleOffset]_Distortion_Texture("Distortion Texture", 2D) = "linearGrey" {}
        _Distortion_Power("Distortion Power", Range(0, 1)) = 0.055
        _Distortion_Tiling("Distortion Tiling", Float) = 1
        _Distortion_Speed("Distortion Speed", Vector, 2) = (-0.08, 0.07, 0, 0)
        [HideInInspector]_DrawOrder("Draw Order", Range(-50, 50)) = 0
        [HideInInspector][Enum(Default, 0, Depth Bias, 0, View Bias, 1)]_DecalMeshBiasType("DecalMesh BiasType", Float) = 0
        [HideInInspector]_DecalMeshDepthBias("DecalMesh DepthBias", Float) = 0
        [HideInInspector]_DecalMeshViewBias("DecalMesh ViewBias", Float) = 0
        [HideInInspector]_DecalAngleFadeSupported("Decal Angle Fade Supported", Float) = 1
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
            "PreviewType"="Plane"
            // Queue: <None>
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalDecalSubTarget"
        }
        Pass
        {
            Name "DecalProjectorForwardEmissive"
            Tags
            {
                "LightMode" = "DecalProjectorForwardEmissive"
            }
        
            // Render State
            Cull Front
        Blend 0 SrcAlpha One
        ZTest Greater
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _DECAL_LAYERS
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_PROJECTOR
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalScreenSpaceProjector"
            Tags
            {
                "LightMode" = "DecalScreenSpaceProjector"
            }
        
            // Render State
            Cull Front
        Blend SrcAlpha OneMinusSrcAlpha
        ZTest Greater
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.5
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalGBufferProjector"
            Tags
            {
                "LightMode" = "DecalGBufferProjector"
            }
        
            // Render State
            Cull Front
        Blend 0 SrcAlpha OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha
        Blend 3 SrcAlpha OneMinusSrcAlpha
        ZTest Greater
        ZWrite Off
        ColorMask 0
        ColorMask 0 1
        ColorMask 0 2
        ColorMask RGB 3
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_PROJECTOR
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 texCoord0 : INTERP5;
             float3 positionWS : INTERP6;
             float3 normalWS : INTERP7;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalMeshForwardEmissive"
            Tags
            {
                "LightMode" = "DecalMeshForwardEmissive"
            }
        
            // Render State
            Blend 0 SrcAlpha One
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _DECAL_LAYERS
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_MESH
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalScreenSpaceMesh"
            Tags
            {
                "LightMode" = "DecalScreenSpaceMesh"
            }
        
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.5
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _DECAL_LAYERS
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_MESH
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalGBufferMesh"
            Tags
            {
                "LightMode" = "DecalGBufferMesh"
            }
        
            // Render State
            Blend 0 SrcAlpha OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha
        Blend 3 SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        ColorMask 0
        ColorMask 0 1
        ColorMask 0 2
        ColorMask RGB 3
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_MESH
        #define _MATERIAL_AFFECTS_EMISSION 1
        #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float
        {
        float3 ObjectSpacePosition;
        };
        
        void SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float _Sharpness, Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float IN, out float Mask_1)
        {
        float3 _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3;
        Unity_Add_float3(IN.ObjectSpacePosition, float3(0.5, 0.5, 0.5), _Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3);
        float3 _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3;
        Unity_OneMinus_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3);
        float3 _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_54a0e6a92bc54d398974c36131327a71_Out_2_Vector3, _OneMinus_b69452e66116496c9fb73a6e1e311464_Out_1_Vector3, _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3);
        float _Split_040f2669b21e47e0b7644de186562ac4_R_1_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[0];
        float _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[1];
        float _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float = _Multiply_96ad1f89ec964b85920a6b210a339e0c_Out_2_Vector3[2];
        float _Split_040f2669b21e47e0b7644de186562ac4_A_4_Float = 0;
        float _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float;
        Unity_Multiply_float_float(_Split_040f2669b21e47e0b7644de186562ac4_R_1_Float, _Split_040f2669b21e47e0b7644de186562ac4_G_2_Float, _Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float);
        float _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_43842b06142b4e3d86c6a4ff082e7690_Out_2_Float, _Split_040f2669b21e47e0b7644de186562ac4_B_3_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float);
        float _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_881185ecd63d4194a06af27c7ac3001e_Out_2_Float, _Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float);
        float _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float = _Sharpness;
        float _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float;
        Unity_Multiply_float_float(_Multiply_7cdc1e1683824f8aa6ec47343ed9da06_Out_2_Float, _Property_a20f488a72284671a89a8d80f60220f1_Out_0_Float, _Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float);
        float _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        Unity_Saturate_float(_Multiply_35bd862573e44fe3b04b82db39a32aee_Out_2_Float, _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float);
        Mask_1 = _Saturate_49d906b81fbd4031a81cfb0ba44f83f4_Out_1_Float;
        }
        
        void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
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
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            UV -= Center;
            float s, c;
            sincos(Rotation, s, c);
            float3 r3 = float3(-s, c, s);
            float2 r1;
            r1.y = dot(UV, r3.xy);
            r1.x = dot(UV, r3.yz);
            Out = r1 + Center;
        }
        
        void Unity_Minimum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Absolute_float4(float4 In, out float4 Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float4(float4 A, float4 B, out float4 Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float = _Caustic_Blend;
            Bindings_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14;
            _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            SG_DecalEdgeMask_ea046900739fbcc4498f7b47f45545c9_float(float(500000), _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14, _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float);
            float _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float;
            Unity_SceneDepth_Raw_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float);
            float _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float;
            Unity_Clamp_float(_SceneDepth_459db58854624d2c8270a23da7031dcd_Out_1_Float, float(0), float(1), _Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float);
            float _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float = _Caustic_Distance_Multiply;
            float _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_36a5cb750d2c467c827268a941303f54_Out_3_Float, _Property_7e96f7c55dae42d0bff2868464ca1952_Out_0_Float, _Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float);
            float _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float;
            Unity_Clamp_float(_Multiply_b511c1dfe8df48299b74cb583a7016fe_Out_2_Float, float(0), float(1), _Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float);
            float _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float;
            Unity_Absolute_float(_Clamp_79e997c03e6e4425a1d4cd3d204f204c_Out_3_Float, _Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float);
            float _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float = _Caustic_Distance_Exp;
            float _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float;
            Unity_Power_float(_Absolute_ce207da2b3ca45879577091fd0f82625_Out_1_Float, _Property_e702f209ed3f4c599536b342c18b6871_Out_0_Float, _Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float);
            float _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float;
            Unity_Clamp_float(_Power_394f361b8a4f4cd3a21be0e2188ad297_Out_2_Float, float(0), float(1), _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float);
            float _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            Unity_Multiply_float_float(_DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float, _Clamp_d5daa5cac3aa470395002531b08b096f_Out_3_Float, _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float);
            #if defined(_CAUSTIC_DISTANCE_BLEND)
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _Multiply_dd90e536f46440d891cc6dd311bdeab8_Out_2_Float;
            #else
            float _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float = _DecalEdgeMask_64beaa5d57e14ae5b73dc0ea68331b14_Mask_1_Float;
            #endif
            float _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4a2a7f2652c4491b4111f2cabc0da77_Out_0_Float, _CausticDistanceBlend_2a3ab74809624fbc8aced58f71cd4032_Out_0_Float, _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float);
            UnityTexture2D _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Caustic);
            float4 _UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4 = IN.uv0;
            float _Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float = _Caustic_Tiling;
            float4 _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4);
            float _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float = _Caustic_Speed;
            float _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_4546ab8a7f18461d983ee651a1e5e6bf_Out_0_Float, _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float);
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float = _Multiply_4c54623d40eb4a19b715533ace65fe8d_Out_2_Float;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_B_3_Float = 0;
            float _Split_cdd97a543beb4e3c97ea59f121d74a3e_A_4_Float = 0;
            float4 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4;
            float3 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3;
            float2 _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2;
            Unity_Combine_float(_Split_cdd97a543beb4e3c97ea59f121d74a3e_R_1_Float, _Split_cdd97a543beb4e3c97ea59f121d74a3e_G_2_Float, float(0), float(0), _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGBA_4_Vector4, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RGB_5_Vector3, _Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2);
            float2 _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(-0.87657, 0.9345), _Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2);
            UnityTexture2D _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Distortion_Texture);
            float4 _UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4 = IN.uv0;
            float _Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float = _Distortion_Tiling;
            float4 _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_90703c6bcbef48cdb369735893e907f2_Out_0_Vector4, (_Property_3ba1c01db0d8432780fb9cefc2b8e859_Out_0_Float.xxxx), _Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4);
            float2 _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2 = _Distortion_Speed;
            float2 _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Property_ad2128200a1b4dafbcf9287a83726329_Out_0_Vector2, _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2);
            float2 _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2;
            Unity_Add_float2((_Multiply_692a8ecc9ac047f099b1f079f282dee9_Out_2_Vector4.xy), _Multiply_c81e5b7f6f724b9899b3e51bfdbb6caf_Out_2_Vector2, _Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2);
            float4 _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_87d7eed317f64f169a0d40e1d02e4b6a_Out_0_Texture2D.GetTransformedUV(_Add_576c7b9edc3b41caae125168ef15d2b0_Out_2_Vector2) );
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.r;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_G_5_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.g;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_B_6_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.b;
            float _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_A_7_Float = _SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_RGBA_0_Vector4.a;
            float _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float = _Distortion_Power;
            float _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_976ed9e3caf14fa1bb9ae4a72efa094c_R_4_Float, _Property_ad0af1c3a8844210aeb77d6b6afebd2a_Out_0_Float, _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float);
            float _UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float = _USE_DISTORTION ? _Multiply_a2f89e18997c4a1699a9b42a5119c48e_Out_2_Float : float(0);
            float2 _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2;
            Unity_Add_float2(_Multiply_16dfa8e61ff94a8abd2c43e0860623b2_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2);
            float2 _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2;
            Unity_Add_float2((_Multiply_1f914e8e58bc480aaf125d60a5f772b8_Out_2_Vector4.xy), _Add_3842cf857541491f9611ac1d312a2117_Out_2_Vector2, _Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2);
            float2 _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Add_f3e682f9a0df44fabdf1386ba83701de_Out_2_Vector2, float2 (0.5, 0.5), float(0.3), _Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2);
            float4 _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Rotate_9c1dc2b8de05429f95d4086748fe1048_Out_3_Vector2) );
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_R_4_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.r;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_G_5_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.g;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_B_6_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.b;
            float _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_A_7_Float = _SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4.a;
            float4 _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_b7cc06d71a0946f6ab004fd36acf4c8f_Out_0_Vector4, (_Property_5f4157dcd8484150a7ef836560a6eb00_Out_0_Float.xxxx), _Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4);
            float2 _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Combine_fdb89a62e8ff4dbf9804733c7a66f70e_RG_6_Vector2, float2(0.8907, -0.9752), _Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2);
            float2 _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e3c654e2b13c4a959ff8164a0414f67b_Out_2_Vector2, (_UseDistortion_b93bbd6410504f67ab732ebcf4b2473f_Out_0_Float.xx), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2);
            float2 _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2;
            Unity_Add_float2((_Multiply_b40c4571afaa49bb87aebc5ec80a8b01_Out_2_Vector4.xy), _Add_4c46d7ed2c4a4cf1bfbaee8acaef37cb_Out_2_Vector2, _Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2);
            float4 _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _Property_e372bfa24170420db9b2d8ac1317b96d_Out_0_Texture2D.GetTransformedUV(_Add_9a0f214b574e4dfb882f6b4ee5aca537_Out_2_Vector2) );
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_R_4_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.r;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_G_5_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.g;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_B_6_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.b;
            float _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_A_7_Float = _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4.a;
            float4 _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4;
            Unity_Minimum_float4(_SampleTexture2D_84d4de6ec1274d2e89dac4452c27b38b_RGBA_0_Vector4, _SampleTexture2D_fde6b02a6c1347efad6276f1514e3be4_RGBA_0_Vector4, _Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4);
            float _Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float = _Caustic_Falloff;
            float4 _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Minimum_39cc630dcd0e4941ba4159af66b063c9_Out_2_Vector4, (_Property_50fe59e67996475fbd7d1f4f2eeaf018_Out_0_Float.xxxx), _Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4);
            float4 _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Caustic_Color) : _Caustic_Color;
            float4 _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_e201ac2447e94867b375e1fefef711d4_Out_2_Vector4, _Property_6e8c71fedf1942bf93de6e8b43817a61_Out_0_Vector4, _Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4);
            float4 _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4;
            Unity_Absolute_float4(_Multiply_442f99839e16493ebb2edb56ee654b22_Out_2_Vector4, _Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4);
            float _Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float = _Caustic_Intensivity;
            float4 _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4;
            Unity_Power_float4(_Absolute_c040bfd4bc1e4ca78ed4cae012958dbe_Out_1_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4);
            float4 _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Power_929320d7221e4e00ac999bcdfa5d29ca_Out_2_Vector4, (_Property_c9dd9a5e88ec45f8a415e251afa5cfc4_Out_0_Float.xxxx), _Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4);
            float4 _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4;
            Unity_Clamp_float4(_Multiply_596b1367525842d2851261c4da54e6c0_Out_2_Vector4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4);
            surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Alpha = _Multiply_d943fc2d68d64bb8b2b2b9305e494285_Out_2_Float;
            surface.Emission = (_Clamp_1d1ac1c976e34eac87b94ff3da8e524f_Out_3_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
            output.ObjectSpacePosition =                        TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters =                             _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
            // Render State
            Cull Back
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        #pragma vertex Vert
        #pragma fragment Frag
        
            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature _ _CAUSTIC_DISTANCE_BLEND
        #pragma dynamic_branch _ _USE_DISTORTION
        
        #if defined(_CAUSTIC_DISTANCE_BLEND)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _Caustic_TexelSize;
        float _Caustic_Speed;
        float _Caustic_Tiling;
        float _Caustic_Falloff;
        float4 _Caustic_Color;
        float _Caustic_Intensivity;
        float _Caustic_Blend;
        float _Caustic_Distance_Multiply;
        float _Caustic_Distance_Exp;
        float4 _Distortion_Texture_TexelSize;
        float _Distortion_Power;
        float _Distortion_Tiling;
        float2 _Distortion_Speed;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Caustic);
        SAMPLER(sampler_Caustic);
        TEXTURE2D(_Distortion_Texture);
        SAMPLER(sampler_Distortion_Texture);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            // GraphFunctions: <None>
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
        #else
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
        
                // copy across graph values, if defined
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.Rendering.Universal.DecalShaderGraphGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}