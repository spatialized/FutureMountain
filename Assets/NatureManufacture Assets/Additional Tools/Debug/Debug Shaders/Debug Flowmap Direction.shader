Shader "NatureManufacture Shaders/Debug/Flowmap Direction"
{
    Properties
    {
        [NoScaleOffset]_Direction("Direction", 2D) = "white" {}
        [NoScaleOffset]_Direction_Stop("Direction_Stop", 2D) = "white" {}
        _test("test", Float) = 0
        [NonModifiableTextureData][NoScaleOffset]_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D("Texture2D", 2D) = "white" {}
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Geometry"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define UNLIT_DEFAULT_DECAL_BLENDING 1
        #define UNLIT_DEFAULT_SSAO 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
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
             float4 texCoord3;
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
             float4 uv0;
             float4 uv3;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
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
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Arctangent_float(float In, out float Out)
        {
            Out = atan(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
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
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Normalize_float2(float2 In, out float2 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Round_float2(float2 In, out float2 Out)
        {
            Out = round(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4 = IN.uv3;
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2 = float2(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float);
            float _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float;
            Unity_Distance_float2(_Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2, float2(0, 0), _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float);
            float _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean;
            Unity_Comparison_Equal_float(_Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, float(0), _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean);
            UnityTexture2D _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction_Stop);
            float4 _UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4.xy), float2 (2, 2), float2 (0, 0), _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2);
            float2 _Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2, _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2);
            float2 _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2);
            float2 _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2, _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2);
            float2 _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2);
            float2 _Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2 = float2(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float, _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float);
            float2 _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2, _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2);
            float2 _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2);
            float2 _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2);
            float2 _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2, _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2);
            float2 _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2, _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2, _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2);
            float _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float;
            Unity_Multiply_float_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float, -1, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float);
            float _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean;
            Unity_Comparison_Greater_float(_Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, float(0), _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean);
            float _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float;
            Unity_Divide_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float);
            float _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float;
            Unity_Arctangent_float(_Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float);
            float _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float;
            Unity_Add_float(_Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, float(3.141592), _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float);
            float _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float;
            Unity_Branch_float(_Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float, _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float);
            float2 _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2);
              float4 _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.tex, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.samplerstate, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.GetTransformedUV(_Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_R_5_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_G_6_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_B_7_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.a;
            Gradient _Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient = NewGradient(0, 3, 2, float4(0, 0.0569272, 1, 0),float4(1, 0.9791913, 0, 0.4882429),float4(1, 0, 0, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0));
            float4 _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, float(0), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4);
            float4 _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float.xxxx), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4);
            UnityTexture2D _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction);
            float4 _UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4 = IN.uv0;
            float _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 1, _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float);
            float _Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_dee6095398844cccbbdad26553f6b3d8_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_dee6095398844cccbbdad26553f6b3d8_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2 = float2(_Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float, _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float);
            float2 _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2;
            Unity_Normalize_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2);
            float _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float;
            Unity_Length_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float);
            float _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float;
            Unity_Remap_float(_Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float, float2 (0, 1), float2 (0.5, 1), _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float);
            float2 _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2, (_Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float.xx), _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2);
            float _Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float = float(5);
            float2 _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2);
            float2 _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2;
            Unity_Round_float2(_Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2, _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2);
            float2 _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2;
            Unity_Divide_float2(_Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2);
            float2 _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2, _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2);
            float2 _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2, float2(0.1, 0.1), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2);
            float2 _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4.xy), float2 (2, 2), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2, _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2);
            float2 _Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2, _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2);
            float2 _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2);
            float2 _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2, _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2);
            float2 _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2);
            float2 _Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2 = float2(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float, _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float);
            float2 _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2, _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2);
            float2 _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2);
            float2 _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2);
            float2 _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2, _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2);
            float2 _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2, _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2, _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2);
            float2 _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2);
              float4 _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.tex, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.samplerstate, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.GetTransformedUV(_Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_R_5_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_G_6_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_B_7_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.a;
            float4 _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4);
            float4 _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float.xxxx), _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4);
            float4 _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4, _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4);
            surface.BaseColor = (_Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
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
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
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
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
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
             float3 ObjectSpacePosition;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
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
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
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
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
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
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
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
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
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
             float4 texCoord3;
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
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
             float4 uv0;
             float4 uv3;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP0;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP1;
            #endif
             float4 texCoord0 : INTERP2;
             float4 texCoord3 : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
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
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
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
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Arctangent_float(float In, out float Out)
        {
            Out = atan(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
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
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Normalize_float2(float2 In, out float2 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Round_float2(float2 In, out float2 Out)
        {
            Out = round(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4 = IN.uv3;
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2 = float2(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float);
            float _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float;
            Unity_Distance_float2(_Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2, float2(0, 0), _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float);
            float _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean;
            Unity_Comparison_Equal_float(_Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, float(0), _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean);
            UnityTexture2D _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction_Stop);
            float4 _UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4.xy), float2 (2, 2), float2 (0, 0), _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2);
            float2 _Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2, _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2);
            float2 _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2);
            float2 _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2, _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2);
            float2 _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2);
            float2 _Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2 = float2(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float, _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float);
            float2 _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2, _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2);
            float2 _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2);
            float2 _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2);
            float2 _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2, _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2);
            float2 _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2, _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2, _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2);
            float _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float;
            Unity_Multiply_float_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float, -1, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float);
            float _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean;
            Unity_Comparison_Greater_float(_Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, float(0), _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean);
            float _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float;
            Unity_Divide_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float);
            float _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float;
            Unity_Arctangent_float(_Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float);
            float _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float;
            Unity_Add_float(_Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, float(3.141592), _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float);
            float _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float;
            Unity_Branch_float(_Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float, _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float);
            float2 _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2);
              float4 _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.tex, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.samplerstate, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.GetTransformedUV(_Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_R_5_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_G_6_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_B_7_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.a;
            Gradient _Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient = NewGradient(0, 3, 2, float4(0, 0.0569272, 1, 0),float4(1, 0.9791913, 0, 0.4882429),float4(1, 0, 0, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0));
            float4 _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, float(0), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4);
            float4 _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float.xxxx), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4);
            UnityTexture2D _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction);
            float4 _UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4 = IN.uv0;
            float _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 1, _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float);
            float _Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_dee6095398844cccbbdad26553f6b3d8_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_dee6095398844cccbbdad26553f6b3d8_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2 = float2(_Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float, _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float);
            float2 _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2;
            Unity_Normalize_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2);
            float _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float;
            Unity_Length_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float);
            float _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float;
            Unity_Remap_float(_Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float, float2 (0, 1), float2 (0.5, 1), _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float);
            float2 _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2, (_Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float.xx), _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2);
            float _Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float = float(5);
            float2 _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2);
            float2 _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2;
            Unity_Round_float2(_Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2, _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2);
            float2 _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2;
            Unity_Divide_float2(_Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2);
            float2 _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2, _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2);
            float2 _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2, float2(0.1, 0.1), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2);
            float2 _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4.xy), float2 (2, 2), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2, _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2);
            float2 _Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2, _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2);
            float2 _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2);
            float2 _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2, _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2);
            float2 _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2);
            float2 _Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2 = float2(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float, _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float);
            float2 _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2, _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2);
            float2 _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2);
            float2 _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2);
            float2 _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2, _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2);
            float2 _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2, _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2, _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2);
            float2 _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2);
              float4 _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.tex, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.samplerstate, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.GetTransformedUV(_Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_R_5_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_G_6_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_B_7_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.a;
            float4 _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4);
            float4 _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float.xxxx), _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4);
            float4 _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4, _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4);
            surface.BaseColor = (_Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
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
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        // GraphFunctions: <None>
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
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
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord3;
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
             float4 uv0;
             float4 uv3;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
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
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        float4 _TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D_TexelSize;
        float4 _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D_TexelSize;
        float4 _Direction_TexelSize;
        float4 _Direction_Stop_TexelSize;
        float _test;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D);
        TEXTURE2D(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        SAMPLER(sampler_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D);
        TEXTURE2D(_Direction);
        SAMPLER(sampler_Direction);
        TEXTURE2D(_Direction_Stop);
        SAMPLER(sampler_Direction_Stop);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Arctangent_float(float In, out float Out)
        {
            Out = atan(In);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
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
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Normalize_float2(float2 In, out float2 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Round_float2(float2 In, out float2 Out)
        {
            Out = round(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4 = IN.uv3;
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2 = float2(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float);
            float _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float;
            Unity_Distance_float2(_Vector2_4aeecd1cb271dd8e96c2fb12309b9dd0_Out_0_Vector2, float2(0, 0), _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float);
            float _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean;
            Unity_Comparison_Equal_float(_Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, float(0), _Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean);
            UnityTexture2D _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction_Stop);
            float4 _UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_bee9581f75a740779ac9d0f8936b21ae_Out_0_Vector4.xy), float2 (2, 2), float2 (0, 0), _TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2);
            float2 _Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_5480a1a3275048d989a8ada84ccf24fd_Out_0_Vector2, _Vector2_6b027c9fc0b24ae9b09ed0e39ef8afa1_Out_0_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2);
            float2 _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_e857693cf0014d2988124241518c2341_Out_3_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2);
            float2 _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_f2173bca15d64a7a95c9254f6cb8ab91_Out_2_Vector2, _Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2);
            float2 _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_50322e8363244a3fa08daa41f33e6175_Out_1_Vector2, _Divide_84a2b2746d134f888c260538db791225_Out_2_Vector2, _Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2);
            float2 _Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_57755b34c5a74f3985dd7a4eae03b858_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2 = float2(_TexelSize_57755b34c5a74f3985dd7a4eae03b858_Width_0_Float, _TexelSize_57755b34c5a74f3985dd7a4eae03b858_Height_2_Float);
            float2 _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e38c93e7ec034c5086be5b78b3beb9cf_Out_0_Vector2, _Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2);
            float2 _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_c290d61d37574049a0501237b3936c19_Out_0_Vector2, _Vector2_d1676c776254451ea5a4b594ba7d586f_Out_0_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2);
            float2 _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_2c718c8316074585a741e0df7588c4d8_Out_2_Vector2, _Multiply_aac5d221cfa14a2aaff785af6a1bfc0c_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2);
            float2 _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_c128c58c3000428cbcd857da98dcd09d_Out_2_Vector2, _Subtract_8b2f287e1d2e40b0857ff91d125ebd2e_Out_2_Vector2, _Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2);
            float2 _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_579d83b582594a4587d6a0d63b27edd2_Out_2_Vector2, _Vector2_25402d0d6dde45e4bf47c7286550d927_Out_0_Vector2, _Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2);
            float _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float;
            Unity_Multiply_float_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_G_2_Float, -1, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float);
            float _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean;
            Unity_Comparison_Greater_float(_Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, float(0), _Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean);
            float _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float;
            Unity_Divide_float(_Split_11d6e1d03b6aec85a5cc295d4f2f2c3a_R_1_Float, _Multiply_3bdf02c598430c878e3738cac7f0dae8_Out_2_Float, _Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float);
            float _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float;
            Unity_Arctangent_float(_Divide_2b884a92fd783d82a9012917c2b83115_Out_2_Float, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float);
            float _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float;
            Unity_Add_float(_Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, float(3.141592), _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float);
            float _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float;
            Unity_Branch_float(_Comparison_e67d9847aa86858490dd0c37e68e7505_Out_2_Boolean, _Arctangent_5140ab7fbdf95a8f9329bfd0cd09226c_Out_1_Float, _Add_cf6b7aee4a487f8ca16b9171b64a8f0d_Out_2_Float, _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float);
            float2 _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_c76c3d751aa24c28a8e550926070aa18_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2);
              float4 _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.tex, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.samplerstate, _Property_a4fe676301c247e09a7b62ac797e5ede_Out_0_Texture2D.GetTransformedUV(_Rotate_f74a9f58cb534420b51559e644786c42_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_R_5_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_G_6_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_B_7_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float = _SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_RGBA_0_Vector4.a;
            Gradient _Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient = NewGradient(0, 3, 2, float4(0, 0.0569272, 1, 0),float4(1, 0.9791913, 0, 0.4882429),float4(1, 0, 0, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0));
            float4 _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, float(0), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4);
            float4 _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_44188a7043714beba9807ba93e4699de_A_8_Float.xxxx), _SampleGradient_b10701941e9b43888f964faefb9621b8_Out_2_Vector4, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4);
            UnityTexture2D _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Direction);
            float4 _UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4 = IN.uv0;
            float _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 1, _Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float);
            float _Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[0];
            float _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[1];
            float _Split_dee6095398844cccbbdad26553f6b3d8_B_3_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[2];
            float _Split_dee6095398844cccbbdad26553f6b3d8_A_4_Float = _UV_1ca38e193be034888b8a707af9d47210_Out_0_Vector4[3];
            float2 _Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2 = float2(_Split_dee6095398844cccbbdad26553f6b3d8_R_1_Float, _Split_dee6095398844cccbbdad26553f6b3d8_G_2_Float);
            float2 _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2;
            Unity_Normalize_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2);
            float _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float;
            Unity_Length_float2(_Vector2_1c1c51262be54e80b5387bcb099af6eb_Out_0_Vector2, _Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float);
            float _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float;
            Unity_Remap_float(_Length_9ef4d3c022ed427fa562561ec96b4bd6_Out_1_Float, float2 (0, 1), float2 (0.5, 1), _Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float);
            float2 _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Normalize_5dc0eb9fe39e432fade910da9a3883fe_Out_1_Vector2, (_Remap_46e9b9b3bfb440778c03d53a88d559f8_Out_3_Float.xx), _Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2);
            float _Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float = float(5);
            float2 _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_372da6ef6a334cc58e3e9e3b3d4f7ea1_Out_2_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2);
            float2 _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2;
            Unity_Round_float2(_Multiply_238859756bbd4020ba90209469bfba9d_Out_2_Vector2, _Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2);
            float2 _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2;
            Unity_Divide_float2(_Round_85f252a8937146c5b632ae04fc63341f_Out_1_Vector2, (_Float_19782764654b478f9aa7b41b32ff1c41_Out_0_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2);
            float2 _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Multiply_8d1bd7f920dc4f3ab567d1fa0e06a93e_Out_2_Float.xx), _Divide_cc6138d846924917b965327374284baa_Out_2_Vector2, _Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2);
            float2 _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_7a4ceafa564442bba419b107d8d55373_Out_2_Vector2, float2(0.1, 0.1), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2);
            float2 _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_7c8a457b34527181924b2b4a71350de9_Out_0_Vector4.xy), float2 (2, 2), _Multiply_d68e7dabf6e649eabbe06e09ce902ecc_Out_2_Vector2, _TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2);
            float2 _Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2 = float2(float(1), float(1));
            float2 _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2 = float2(float(30), float(30));
            float2 _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_9a3e446bd0dfc3868e3db6f9bf101ead_Out_0_Vector2, _Vector2_8355e4dbd796b188ba1e500dcabf0c0f_Out_0_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2);
            float2 _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2;
            Unity_Divide_float2(_TilingAndOffset_67d58b7a8092828aaece7f3acfe6e8a9_Out_3_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2);
            float2 _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2;
            Unity_Fraction_float2(_Divide_5d0f49ab4bcab689894f976217114a79_Out_2_Vector2, _Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2);
            float2 _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Fraction_e4f0f05fb76fd3809f5ec855b54a4595_Out_1_Vector2, _Divide_f0d0aaa28637b781bcd99c1c912b5eae_Out_2_Vector2, _Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2);
            float2 _Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2 = float2(float(256), float(256));
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.z;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.w;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelWidth_3_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.x;
            float _TexelSize_18bb9f416e386f87bee91aa46804bc56_TexelHeight_4_Float = UnityBuildTexture2DStructNoScale(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Texture_1_Texture2D).texelSize.y;
            float2 _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2 = float2(_TexelSize_18bb9f416e386f87bee91aa46804bc56_Width_0_Float, _TexelSize_18bb9f416e386f87bee91aa46804bc56_Height_2_Float);
            float2 _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e6d2595367ed0380b42c7a74855838a5_Out_0_Vector2, _Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2);
            float2 _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2 = float2(float(10), float(10));
            float2 _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_e8728bfbf194e5818f010927b4ba8d79_Out_0_Vector2, _Vector2_97c81bcbfd26f08385a101ac3da412f3_Out_0_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2);
            float2 _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2;
            Unity_Subtract_float2(_Multiply_561a2890964f4081a8cf5d16bccb889f_Out_2_Vector2, _Multiply_bccda05b3809138d8da15484dd6a7b4e_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2);
            float2 _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cbcb0de832b1d08288916e46aa8d4df2_Out_2_Vector2, _Subtract_710d4672e66f7780ad90ca6e19a733bd_Out_2_Vector2, _Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2);
            float2 _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2 = float2(float(0.1), float(0.1));
            float2 _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Multiply_cd542324eceadd8daaca18ab78d3fbf6_Out_2_Vector2, _Vector2_df86361e9c36e7828e3097cc1fa8a75b_Out_0_Vector2, _Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2);
            float2 _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2;
            Unity_Rotate_Radians_float(_Multiply_8e351d40d36634829f2bb0905b9b9342_Out_2_Vector2, float2 (0.5, 0.5), _Branch_9de100b31215ba89bb19e5b89012a25a_Out_3_Float, _Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2);
              float4 _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.tex, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.samplerstate, _Property_70a6ddd048a60f81b46e2042f9ae833b_Out_0_Texture2D.GetTransformedUV(_Rotate_ff1406ef744b188ca79c6d3bf0b8bbd7_Out_3_Vector2), float(0));
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_R_5_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.r;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_G_6_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.g;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_B_7_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.b;
            float _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float = _SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_RGBA_0_Vector4.a;
            float4 _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4;
            Unity_SampleGradientV1_float(_Gradient_2989320cfaf94d99b0d33a688a94428f_Out_0_Gradient, _Distance_47e812ff6269a181b6e0faa017faee3b_Out_2_Float, _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4);
            float4 _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_SampleTexture2DLOD_7fdbdd0c5b377086acfc5974a225b0dd_A_8_Float.xxxx), _SampleGradient_6cc0457448dd43209d582725ad86198a_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4);
            float4 _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4;
            Unity_Branch_float4(_Comparison_e4c91e80b3934aee879db576ff293636_Out_2_Boolean, _Multiply_86f5ae6eb4de4a47adbfc66d783a430f_Out_2_Vector4, _Multiply_0563147e8bc9868b8c2a4f2c442c349f_Out_2_Vector4, _Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4);
            surface.BaseColor = (_Branch_978d36ad04c24f45b84a06c6e15c86b5_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}