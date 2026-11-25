Shader "Hidden/NatureManufacture Shaders/BrushGenerator"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurSize ("_BlurSize", Float) = 1
        _PassNumber("_PassNumber", Float) = 1
        _BlurAdditionalSize ("_BlurAdditionalSize", Float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass //0 Copy
        {
            Name "Copy"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            float4 frag(v2f i) : SV_Target
            {
                float4 source = tex2D(_MainTex, half2(i.uv.x, i.uv.y));

                return source;
                //return sum; // min(s.r, source);
            }
            ENDCG
        }

        Pass //1 border
        {

            Name "Border"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;


            float Clamp01(float val)
            {
                return clamp(val, 0, 1);
            }

            float4 frag(v2f i) : SV_Target
            {
                float o = _MainTex_TexelSize.xy;

                float4 source = tex2D(_MainTex, float2(i.uv.x, i.uv.y));


                source.b = 1;
                source.a = 1;
                source.g = 1;


                if (source.r == 0)
                    return 0;

                if ((i.uv.y + o) > 1 || (i.uv.y - o) < 0 || (i.uv.x + o) > 1 || (i.uv.x - o) < 0)
                {
                    source.g = 1;
                    source.b = 0;
                    source.a = 1;
                    return source;
                }

                float border = 1;

                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x - o), Clamp01(i.uv.y))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x + o), Clamp01(i.uv.y))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x), Clamp01(i.uv.y - o))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x), Clamp01(i.uv.y + o))).r);

                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x + o), Clamp01(i.uv.y + o))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x + o), Clamp01(i.uv.y - o))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x - o), Clamp01(i.uv.y + o))).r);
                border = min(border, tex2D(_MainTex, float2(Clamp01(i.uv.x - o), Clamp01(i.uv.y - o))).r);


                if (border > 0)
                {
                    source.g = 0;
                }
                else
                {
                    source.g = 1;
                }

                source.b = 1;
                source.a = 1;


                return source;
                //return sum; // min(s.r, source);
            }
            ENDCG
        }
        Pass //2 generate blur
        {

            Name "Generate Blur"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            #define PI 3.14159265
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _BlurSize;
            float _PassNumber;
            float _BlurAdditionalSize;


            float4 frag(v2f i) : SV_Target
            {
                float o = _MainTex_TexelSize.x;
                float4 source = tex2D(_MainTex, half2(i.uv.x, i.uv.y));


                float4 left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y));
                float4 right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y));
                float4 up = tex2D(_MainTex, half2(i.uv.x, i.uv.y + o));
                float4 down = tex2D(_MainTex, half2(i.uv.x, i.uv.y - o));
                float4 up_right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y + o));
                float4 up_left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y + o));
                float4 down_right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y - o));
                float4 down_left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y - o));

                float sum = max(left.g, right.g);
                sum = max(sum, up.g);
                sum = max(sum, down.g);
                sum = max(sum, up_right.g);
                sum = max(sum, up_left.g);
                sum = max(sum, down_right.g);
                sum = max(sum, down_left.g);


                if (source.g == 0 && sum > 0)
                    source.g = 1 - _BlurSize;


                sum = max(left.a, right.a);
                sum = max(sum, up.a);
                sum = max(sum, down.a);
                sum = max(sum, up_right.a);
                sum = max(sum, up_left.a);
                sum = max(sum, down_right.a);
                sum = max(sum, down_left.a);

                if (source.a == 0 && sum > 0)
                    source.a = 1 - _BlurSize / _BlurAdditionalSize;


                float sumSign = sign(left.r);
                sumSign += sign(right.r);
                sumSign += sign(up.r);
                sumSign += sign(down.r);
                sumSign += sign(up_right.r);
                sumSign += sign(up_left.r);
                sumSign += sign(down_right.r);
                sumSign += sign(down_left.r);

                sum = left.r;
                sum += right.r;
                sum += up.r;
                sum += down.r;
                sum += up_right.r;
                sum += up_left.r;
                sum += down_right.r;
                sum += down_left.r;

                if (source.r == 0 && sumSign > 1)
                {
                    source.r = sum / sumSign;
                }


                return source;
            }
            ENDCG
        }

        Pass //3 blur r channel
        {

            Name "Blur R Channel"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            #define PI 3.14159265
            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _BlurSize;
            float _PassNumber;
            float _BlurAdditionalSize;


            float4 frag(v2f i) : SV_Target
            {
                float o = _MainTex_TexelSize.x;
                float4 source = tex2D(_MainTex, half2(i.uv.x, i.uv.y));


                float4 left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y));
                float4 right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y));
                float4 up = tex2D(_MainTex, half2(i.uv.x, i.uv.y + o));
                float4 down = tex2D(_MainTex, half2(i.uv.x, i.uv.y - o));
                float4 up_right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y + o));
                float4 up_left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y + o));
                float4 down_right = tex2D(_MainTex, half2(i.uv.x + o, i.uv.y - o));
                float4 down_left = tex2D(_MainTex, half2(i.uv.x - o, i.uv.y - o));


                float maxR = max(left.r, right.r);
                maxR = max(maxR, up.r);
                maxR = max(maxR, down.r);
                maxR = max(maxR, up_right.r);
                maxR = max(maxR, up_left.r);
                maxR = max(maxR, down_right.r);
                maxR = max(maxR, down_left.r);


                float minR = min(left.r, right.r);
                minR = min(minR, up.r);
                minR = min(minR, down.r);
                minR = min(minR, up_right.r);
                minR = min(minR, up_left.r);
                minR = min(minR, down_right.r);
                minR = min(minR, down_left.r);

                if (source.r > 0 && maxR - minR > 0)
                {
                    float sumSign = sign(left.r);
                    sumSign += sign(right.r);
                    sumSign += sign(up.r);
                    sumSign += sign(down.r);
                    sumSign += sign(up_right.r);
                    sumSign += sign(up_left.r);
                    sumSign += sign(down_right.r);
                    sumSign += sign(down_left.r);

                    float sum = left.r;
                    sum += right.r;
                    sum += up.r;
                    sum += down.r;
                    sum += up_right.r;
                    sum += up_left.r;
                    sum += down_right.r;
                    sum += down_left.r;

                    source.r = (source.r + sum / sumSign) * 0.5;
                }


                return source;
            }
            ENDCG
        }

    }
}