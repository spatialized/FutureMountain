Shader "Hidden/NatureManufacture Shaders/StampHeight"
{

    Properties
    {
        _MainTex ("Texture", any) = "" {}
    }

    SubShader
    {

        ZTest Always Cull Off ZWrite Off

        CGINCLUDE
        #define PI 3.1415926538
        #include "UnityCG.cginc"
        #include "TerrainTool.cginc"

        sampler2D _MainTex;
        float4 _MainTex_TexelSize; // 1/width, 1/height, width, height

        sampler2D _BrushTex;
        // r- Angle
        // g- Concave
        // b- Height
        sampler2D _MaskTex;
        //r -Angle
        //g -Power
        //b -Height
        sampler2D _ParamsTex;
        sampler2D _NoiseTex;
        sampler2D _StampTex;

        float4 _BrushParams;
        float4 _NoiseParams;
        float4 _NoiseParamsSecond;
        float4 _ConvexParams;
        float4 _MainParams;


        #define POWER_MULTIPLIER     (_MainParams[0])
        #define HEIGHT_MULTIPLIER  (_MainParams[1])
        #define HEIGHT_POWER   (_MainParams[2])


        #define BRUSH_STRENGTH      (_BrushParams[0])
        #define BRUSH_NOISE  (_BrushParams[1])
        #define BRUSH_STAMPHEIGHT   (_BrushParams[2])


        #define NOISE_MULTIPLIER   (_NoiseParams[0])
        #define NOISE_SIZE_X   (_NoiseParams[1])
        #define NOISE_SIZE_Z   (_NoiseParams[2])
        #define NOISE_MULTIPLIER_OUTSIDE   (_NoiseParams[3])
        #define NOISE_MULTIPLIER_POWER   (_NoiseParamsSecond[0])


        #define CONVEX_STEPS   (_ConvexParams[0])
        #define CONVEX_STEP_SIZE   (_ConvexParams[1])
        #define CONVEX_STRENGTH   (_ConvexParams[2])
        #define CONVEX_WORKING   (_ConvexParams[3])
        //#define BRUSH_ANGLE   (_NoiseParams[3])

        struct appdata_t
        {
            float4 vertex : POSITION;
            float2 pcUV : TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 pcUV : TEXCOORD0;
        };

        v2f vert(appdata_t v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.pcUV = v.pcUV;
            return o;
        }


        float AddSub(float base, float blend, float opacity)
        {
            float oneBlend = 1 - blend;
            oneBlend -= 0.5;
            float blendHalf = blend - 0.5;

            float sub = base - oneBlend;
            sub += blendHalf;
            sub = saturate(sub);
            return lerp(base, sub, opacity);
        }


        //simple noise
        inline float unity_noise_randomValue(float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
        }

        inline float unity_noise_interpolate(float a, float b, float t)
        {
            return (1.0 - t) * a + (t * b);
        }

        inline float unity_valueNoise(float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = unity_noise_randomValue(c0);
            float r1 = unity_noise_randomValue(c1);
            float r2 = unity_noise_randomValue(c2);
            float r3 = unity_noise_randomValue(c3);

            float bottomOfGrid = unity_noise_interpolate(r0, r1, f.x);
            float topOfGrid = unity_noise_interpolate(r2, r3, f.x);
            float t = unity_noise_interpolate(bottomOfGrid, topOfGrid, f.y);
            return t;
        }

        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3 - 0));
            t += unity_valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3 - 1));
            t += unity_valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3 - 2));
            t += unity_valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            Out = t;
        }

        //perlin noise
        float2 unity_gradientNoise_dir(float2 p)
        {
            p = p % 289;
            float x = (34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        float unity_gradientNoise(float2 p)
        {
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(unity_gradientNoise_dir(ip), fp);
            float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            Out = clamp(unity_gradientNoise(UV * Scale) + 0.5, 0, 1);
        }
        ENDCG

        Pass // 0 copy terrain heightmap
        {
            Name "0 Copy Heights"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment RaiseHeight

            float4 RaiseHeight(v2f i) : SV_Target
            {
                //float2 brushUV = PaintContextUVToBrushUV(i.pcUV);
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);

                // out of bounds multiplier
                // float oob = all(saturate(brushUV) == brushUV) ? 1.0f : 0.0f;

                float height = UnpackHeightmap(tex2D(_MainTex, heightmapUV));
                //float brushShape = oob * UnpackHeightmap(tex2D(_BrushTex, brushUV));

                return PackHeightmap(clamp(height, 0, 0.5));
            }
            ENDCG
        }

        Pass // 1 Stamp terrain
        {
            Name "Stamp terrain"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment StampHeight


            float4 StampHeight(v2f i) : SV_Target
            {
                float2 brushUV = PaintContextUVToBrushUV(i.pcUV);
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);

                // out of bounds multiplier
                float oob = all(saturate(brushUV) == brushUV) ? 1.0f : 0.0f;

                float height = UnpackHeightmap(tex2D(_MainTex, heightmapUV));

                //float brushShape = oob * UnpackHeightmap(tex2D(_BrushTex, brushUV));
                float4 brush = tex2D(_BrushTex, brushUV);

                float brushShape = oob * brush.r * 0.5;
                float brushBlend = oob * brush.a;

                float distance = brush.g;
                distance = 1 - distance;

                distance = distance * 0.5;

                float brushChange = lerp(0.5 - distance, distance + 0.5, brush.b);

                brushChange = tex2D(_ParamsTex, brushChange).r * 2 - 1;

                float x = i.pcUV.x;
                float z = i.pcUV.y;

                float stamp = tex2D(_StampTex, i.pcUV);


                float brushHeight = brushShape + stamp * brushChange * 0.5;


                //sin ((x+0.5)*\pi )) +1)*0.5
                brushBlend = 1 - (sin((brushBlend + 0.5) * PI) + 1) * 0.5;

                float brushStrength = lerp(BRUSH_STRENGTH, 1, brush.b);

                float targetHeight = lerp(height, brushHeight, pow(brushBlend, brushStrength));

                targetHeight = clamp(targetHeight, 0.0, 0.5); // Keep in valid range (0..0.5f)
                height = targetHeight; //targetHeight;

                return PackHeightmap(height);
                //return PackHeightmap(brush.b*0.5);
            }
            ENDCG
        }

        Pass // 2 Get angle
        {
            Name "Get angle"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment SetHeight

            float3 NormalFromTexture(float2 UV, float Offset, float Strength)
            {
                //Offset = pow(Offset, 3) * 0.1;
                float2 offsetU = float2(UV.x + Offset, UV.y);
                float2 offsetV = float2(UV.x, UV.y + Offset);
                float normalSample = UnpackHeightmap(tex2D(_MainTex, UV)); //Texture.Sample(Sampler, UV);

                float uSample = UnpackHeightmap(tex2D(_MainTex, offsetU)); //Texture.Sample(Sampler, offsetU);
                float vSample = UnpackHeightmap(tex2D(_MainTex, offsetV)); //Texture.Sample(Sampler, offsetV);
                float3 va = float3(1, 0, (uSample - normalSample) * Strength);
                float3 vb = float3(0, 1, (vSample - normalSample) * Strength);


                return normalize(cross(va, vb));
            }

            float4 SetHeight(v2f i) : SV_Target
            {
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);


                float offset = _MainTex_TexelSize.x;

                float4 normal = 1;
                normal.xyz = NormalFromTexture(heightmapUV, offset, 1000);

                // normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));

                return normal;
            }
            ENDCG
        }

        Pass // 3 Mask Generator
        {
            Name "Mask Generator"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment GetMask


            float3 NormalFromTexture(float2 UV, float Offset, float Strength)
            {
                //Offset = pow(Offset, 3) * 0.1;
                float2 offsetU = float2(UV.x + Offset, UV.y);
                float2 offsetV = float2(UV.x, UV.y + Offset);
                float normalSample = UnpackHeightmap(tex2D(_MainTex, UV)); //Texture.Sample(Sampler, UV);

                float uSample = UnpackHeightmap(tex2D(_MainTex, offsetU)); //Texture.Sample(Sampler, offsetU);
                float vSample = UnpackHeightmap(tex2D(_MainTex, offsetV)); //Texture.Sample(Sampler, offsetV);
                float3 va = float3(1, 0, (uSample - normalSample) * Strength);
                float3 vb = float3(0, 1, (vSample - normalSample) * Strength);

                float3 normal = normalize(cross(va, vb));

                return normal;
            }

            float CavityFromTexture(float2 UV, float Offset, float Strength)
            {
                float height = UnpackHeightmap(tex2D(_MainTex, UV));

                Offset = Offset * CONVEX_STEP_SIZE;

                half4 blur = 0.0;
                float remaining = 1.0;
                float coef = 1.0;
                float fI = 0;
                for (int j = 0; j < CONVEX_STEPS; j++)
                {
                    fI++;
                    coef *= 0.32;
                    blur += tex2D(_MainTex, float2(UV.x, UV.y - fI * Offset)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x - fI * Offset, UV.y)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x + fI * Offset, UV.y)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x, UV.y + fI * Offset)) * coef;

                    blur += tex2D(_MainTex, float2(UV.x + fI * Offset, UV.y + fI * Offset)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x - fI * Offset, UV.y + fI * Offset)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x + fI * Offset, UV.y - fI * Offset)) * coef;
                    blur += tex2D(_MainTex, float2(UV.x - fI * Offset, UV.y - fI * Offset)) * coef;

                    remaining -= 8 * coef;
                }
                blur += tex2D(_MainTex, float2(UV.x, UV.y)) * remaining;


                //float concave = (height - texcol) * Strength * CONVEX_STRENGTH;

                blur = 1 - blur;
                float concave = AddSub(height, blur, 0.5);
                concave = AddSub(concave, concave, Strength * CONVEX_STRENGTH);

                if (CONVEX_WORKING == 0)
                    concave = 1;

                if (CONVEX_WORKING == 1)
                {
                    concave -= 0.5;
                }

                if (CONVEX_WORKING == 2)
                {
                    concave += 0.5;
                    concave = 1 - concave;
                }


                return concave;
            }

            float CavityFromTextureNormal(float2 heightmapUV, float Offset, float Strength)
            {
                float3 normal = NormalFromTexture(heightmapUV, Offset, BRUSH_STAMPHEIGHT);
                float normalR = NormalFromTexture(heightmapUV + float2(Offset, 0), Offset, BRUSH_STAMPHEIGHT).r;
                float normalG = NormalFromTexture(heightmapUV + float2(0, Offset), Offset, BRUSH_STAMPHEIGHT).g;

                normalR = normal.r - normalR;
                normalR = 0.5 - normalR;

                normalG = normal.g - normalG;
                normalG = 0.5 - normalG;

                float concave = lerp(normalR, normalG, 0.5);
                concave = AddSub(concave, concave, CONVEX_STRENGTH);

                return concave;
            }

            float4 GetMask(v2f i) : SV_Target
            {
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);
                float height = UnpackHeightmap(tex2D(_MainTex, heightmapUV));

                float offset = _MainTex_TexelSize.x;

                float3 normal = NormalFromTexture(heightmapUV, offset, BRUSH_STAMPHEIGHT);


                float angle = acos(dot(normal, float3(0, 0, 1))) / (PI * 0.5);


                float concave = CavityFromTexture(heightmapUV, offset, BRUSH_STAMPHEIGHT);
                float concave2 = CavityFromTextureNormal(heightmapUV, offset, BRUSH_STAMPHEIGHT);

                float4 mask = 0;
                mask.r = angle;
                mask.g = concave;
                mask.b = height;
                mask.a = concave2;
                // normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));

                return mask;
            }
            ENDCG
        }

        Pass // 4 paint splat alphamap
        {
            Name "Paint Texture"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment PaintSplatAlphamap


            float Angle(float3 from, float3 to)
            {
                float num = sqrt(dot(from, from) * dot(to, to));
                return num < 1.0000000036274937E-15 ? 0.0f : acos(clamp(dot(from, to) / num, -1, 1)) * 57.29578;
            }

            float4 PaintSplatAlphamap(v2f i) : SV_Target
            {
                float2 brushUV = PaintContextUVToBrushUV(i.pcUV);

                // out of bounds multiplier
                float oob = all(saturate(brushUV) == brushUV) ? 1.0 : 0.0;

                float4 brush = oob * tex2D(_BrushTex, brushUV);


                // float brushStrength = BRUSH_STRENGTH * brush.a;
                float distance = brush.g;
                distance = 1 - distance;

                distance = distance * 0.5;

                float brushStrength = lerp(0.5 - distance, distance + 0.5, brush.b);
                brushStrength = tex2D(_ParamsTex, brushStrength).g * POWER_MULTIPLIER * brush.a;

                float x = i.pcUV.x;
                float z = i.pcUV.y;

                float noise = tex2D(_NoiseTex, i.pcUV);


                float4 mask = (tex2D(_MaskTex, i.pcUV));

                float angle = mask.r;

                angle = tex2D(_ParamsTex, angle).r;


                float concave = mask.g;

                float heightMap = tex2D(_ParamsTex, mask.b).b;
                heightMap = pow(heightMap,HEIGHT_POWER) * HEIGHT_MULTIPLIER;

                float alphaMap = tex2D(_MainTex, i.pcUV).r;
                return alphaMap + brushStrength * noise * angle * concave * heightMap;
            }
            ENDCG
        }

        Pass // 5 Stamp terrain min
        {
            Name "Stamp terrain min"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment StampHeight


            float4 StampHeight(v2f i) : SV_Target
            {
                float2 brushUV = PaintContextUVToBrushUV(i.pcUV);
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);

                // out of bounds multiplier
                float oob = all(saturate(brushUV) == brushUV) ? 1.0f : 0.0f;

                float height = UnpackHeightmap(tex2D(_MainTex, heightmapUV));

                //float brushShape = oob * UnpackHeightmap(tex2D(_BrushTex, brushUV));
                float4 brush = tex2D(_BrushTex, brushUV);

                float brushShape = oob * brush.r * 0.5;
                float brushBlend = oob * brush.a;

                float distance = brush.g;
                distance = 1 - distance;

                distance = distance * 0.5;

                float brushChange = lerp(0.5 - distance, distance + 0.5, brush.b);

                brushChange = tex2D(_ParamsTex, brushChange).r * 2 - 1;

                float x = i.pcUV.x;
                float z = i.pcUV.y;

                float stamp = tex2D(_StampTex, i.pcUV);


                float brushHeight = brushShape + stamp * brushChange * 0.5;


                //sin ((x+0.5)*\pi )) +1)*0.5
                brushBlend = 1 - (sin((brushBlend + 0.5) * PI) + 1) * 0.5;

                float brushStrength = lerp(BRUSH_STRENGTH, 1, brush.b);

                float targetHeight = lerp(height, brushHeight, pow(brushBlend, brushStrength));

                targetHeight = clamp(targetHeight, 0.0, 0.5); // Keep in valid range (0..0.5f)
                height = min(height, targetHeight);

                return PackHeightmap(height);
                //return PackHeightmap(brush.b*0.5);
            }
            ENDCG
        }

        Pass // 6 Stamp terrain max
        {
            Name "Stamp terrain max"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment StampHeight


            float4 StampHeight(v2f i) : SV_Target
            {
                float2 brushUV = PaintContextUVToBrushUV(i.pcUV);
                float2 heightmapUV = PaintContextUVToHeightmapUV(i.pcUV);

                // out of bounds multiplier
                float oob = all(saturate(brushUV) == brushUV) ? 1.0f : 0.0f;

                float height = UnpackHeightmap(tex2D(_MainTex, heightmapUV));

                //float brushShape = oob * UnpackHeightmap(tex2D(_BrushTex, brushUV));
                float4 brush = tex2D(_BrushTex, brushUV);

                float brushShape = oob * brush.r * 0.5;
                float brushBlend = oob * brush.a;

                float distance = brush.g;
                distance = 1 - distance;

                distance = distance * 0.5;

                float brushChange = lerp(0.5 - distance, distance + 0.5, brush.b);

                brushChange = tex2D(_ParamsTex, brushChange).r * 2 - 1;

                float x = i.pcUV.x;
                float z = i.pcUV.y;

                float stamp = tex2D(_StampTex, i.pcUV);


                float brushHeight = brushShape + stamp * brushChange * 0.5;


                //sin ((x+0.5)*\pi )) +1)*0.5
                brushBlend = 1 - (sin((brushBlend + 0.5) * PI) + 1) * 0.5;

                float brushStrength = lerp(BRUSH_STRENGTH, 1, brush.b);

                float targetHeight = lerp(height, brushHeight, pow(brushBlend, brushStrength));

                targetHeight = clamp(targetHeight, 0.0, 0.5); // Keep in valid range (0..0.5f)
                height = max(height, targetHeight);

                return PackHeightmap(height);
                //return PackHeightmap(brush.b*0.5);
            }
            ENDCG
        }


        Pass // 7 copy terrain heightmap
        {
            Name "7 Mask Boolean"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment RaiseHeight

            float4 RaiseHeight(v2f i) : SV_Target
            {
                float mask = tex2D(_MainTex, i.pcUV);
                float maskMain = tex2D(_MaskTex, i.pcUV);

                return (mask + maskMain) > 0.5;
            }
            ENDCG
        }



    }
    Fallback Off
}