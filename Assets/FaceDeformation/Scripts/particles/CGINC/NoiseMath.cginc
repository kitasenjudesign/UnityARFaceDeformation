
// Ramp関数
float Ramp(float r)
{
    if (r >= 1.0)
    {
        return 1.0;
    }
    else if (r <= -1.0)
    {
        return -1.0;
    }
    else
    {
        // ((15.0 / 8.0) * r) - ((10.0 / 8.0) * (r * r * r)) + ((3.0 / 8.0) * (r * r * r * r * r))
        return (1.875 * r) - (1.25 * (r * r * r)) + (0.375 * (r * r * r * r * r));
    }
}

float Fade(float t)
{
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float Lerp(float t, float a, float b)
{
    return a + t * (b - a);
}

float Grad(int hash, float x, float y, float z)
{
    int h = hash & 15;
    float u = (h < 8) ? x : y;
    float v = (h < 4) ? y : (h == 12 || h == 14) ? x : z;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
}

float Rand(float3 co)
{
    return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
}