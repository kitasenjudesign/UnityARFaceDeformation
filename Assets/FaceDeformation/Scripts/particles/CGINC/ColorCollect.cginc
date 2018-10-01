#ifndef COLOR_COLLECT
#define COLOR_COLLECT

float3 rgb2hsv(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
float3 hsv2rgb(float3 c)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
    return lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y) * c.z;
}

//s:sourceColor, b:blendColor
#define blendOverlay(s,b) (b < 0.5) ? (2.0 * s * b) : (1.0 - 2.0 * (1.0 - s) * (1.0 - b))
#define blendScreen(s,b) 1.0 - ((1.0 - s) * (1.0 - b))

#endif // COLOR_COLLECT
