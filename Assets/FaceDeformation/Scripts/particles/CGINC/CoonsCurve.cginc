#ifndef COONSCURVE_INCLUDED
#define COONSCURVE_INCLUDED

float3 coons(float t, float3 p0, float3 p1, float3 v0, float3 v1)
{
	float3 a =  2*p0 - 2*p1 +   v0 + v1;
	float3 b = -3*p0 + 3*p1 - 2*v0 - v1;

	float t2 = t*t;
	float t3 = t2*t;

	return a*t3 + b*t2 + v0*t + p0;
}

float2 coons(float t, float2 p0, float2 p1, float2 v0, float2 v1)
{
	float2 a =  2*p0 - 2*p1 +   v0 + v1;
	float2 b = -3*p0 + 3*p1 - 2*v0 - v1;

	float t2 = t*t;
	float t3 = t2*t;

	return a*t3 + b*t2 + v0*t + p0;
}

float coons(float t, float p0, float p1, float v0, float v1)
{
	float a =  2*p0 - 2*p1 +   v0 + v1;
	float b = -3*p0 + 3*p1 - 2*v0 - v1;

	float t2 = t*t;
	float t3 = t2*t;

	return a*t3 + b*t2 + v0*t + p0;
}

#endif