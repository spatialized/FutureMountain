Shader "Hidden/NatureManufacture Shaders/NoiseShader"
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

        float _OperationType;
        float4 _NoiseParams;
        float _Seed; // dodano seed


        #define NOISE_MULTIPLIER   (_NoiseParams[0])
        #define NOISE_SIZE_X   (_NoiseParams[1])
        #define NOISE_SIZE_Z   (_NoiseParams[2])
        #define NOISE_MULTIPLIER_POWER   (_NoiseParams[3])


        struct appdata_t
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        v2f vert(appdata_t v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
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
        float2 unity_gradientNoise_dir(float2 p, float seed)
        {
            p = p % 289;
            float x = (34 * p.x + 1) * p.x % 289 + p.y + seed; // seed wpływa na wynik
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        float unity_gradientNoise(float2 p, float seed)
        {
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(unity_gradientNoise_dir(ip, seed), fp);
            float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1), seed), fp - float2(0, 1));
            float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0), seed), fp - float2(1, 0));
            float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1), seed), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, float seed, out float Out)
        {
            Out = clamp(unity_gradientNoise(UV * Scale, seed) + 0.5, 0, 1);
        }
        ENDCG


        Pass // 0 Noise
        {
            Name "Noise base"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragment


            float4 fragment(v2f i) : SV_Target
            {
                float base = tex2D(_MainTex, i.uv);


                float x = i.uv.x;
                float z = i.uv.y;

                float noise = 1;


                //Unity_SimpleNoise_float(float2(x * NOISE_SIZE_X, z * NOISE_SIZE_Z), 1, noise);
                Unity_GradientNoise_float(float2(x * NOISE_SIZE_X, z * NOISE_SIZE_Z), 1, _Seed, noise);

                noise = clamp(noise, 0, 1);

                if (NOISE_MULTIPLIER < 0)
                    noise = 1 - noise;


                noise = pow(noise,NOISE_MULTIPLIER_POWER) * abs(NOISE_MULTIPLIER);

                /*     Add,
            Subtract,
            Multiply,
            Divide*/

                float finalNoise;
                if (_OperationType == 0)
                {
                    finalNoise = base + noise;
                }
                else if (_OperationType == 1)
                {
                    finalNoise = base - noise;
                }
                else if (_OperationType == 2)
                {
                    finalNoise = base * noise;
                }
                else if (_OperationType == 3)
                {
                    finalNoise = base / noise;
                }
                else
                {
                    finalNoise = noise;
                }

                finalNoise = clamp(finalNoise, 0, 1);

                return finalNoise;
            }
            ENDCG
        }


        Pass // 1 White
        {
            Name "White"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragment


            float4 fragment(v2f i) : SV_Target
            {
                return 1;
            }
            ENDCG
        }

        Pass // 2 Black
        {
            Name "Black"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragment


            float4 fragment(v2f i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }


    }
    Fallback Off
}