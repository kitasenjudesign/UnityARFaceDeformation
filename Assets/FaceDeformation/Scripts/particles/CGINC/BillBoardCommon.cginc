// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#ifndef BILLBOARD_INCLUDED
#define BILLBOARD_INCLUDED

float4 vPosBillboard(float4 pos, float2 uv, float size){
	float4 center = pos;
	center.xy -= uv-0.5;
	half4 vPos = mul(UNITY_MATRIX_MV, center);
	vPos.xy += (uv-0.5)*size;
	return vPos;
}

float4 wPosOnePoleBillboard(float4 pos, float2 uv, float size){
	float4 center = pos;
	center.xy -= uv-0.5;
	center = mul(unity_ObjectToWorld, center);
	
	float3 forward = normalize(_WorldSpaceCameraPos - center.xyz);
	float3 up = UNITY_MATRIX_V[1].xyz;
	float3 right = normalize(cross(forward, up));
	up = normalize(cross(right, forward));
	
	float3 wPos = center.xyz + ((uv.x-0.5) * right + (uv.y-0.5) * up)*size;
	return float4(wPos,1.0);
}

#endif
