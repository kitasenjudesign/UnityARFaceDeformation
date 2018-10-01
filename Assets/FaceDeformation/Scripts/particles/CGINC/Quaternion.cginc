#ifndef QUATERNION_INCLUDED
#define QUATERNION_INCLUDED

#include "/Assets/CGINC/Random.cginc"
#define PI2 6.28318530718
// Quaternion multiplication.
// http://mathworld.wolfram.com/Quaternion.html
float4 qmul(float4 q1, float4 q2)
{
	return float4(
		q2.xyz * q1.w + q1.xyz * q2.w + cross(q1.xyz, q2.xyz),
		q1.w * q2.w - dot(q1.xyz, q2.xyz)
		);
}

//Convert Matrix to Quaternion
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
float4 matrix_to_quaternion(float3x3 m) {

	float tr = m[0][0] + m[1][1] + m[2][2];
	float4 q = float4(0, 0, 0, 0);

	if (tr > 0) {
		float s = sqrt(tr + 1.0) * 2; // S=4*qw 
		q.w = 0.25 * s;
		q.x = (m[2][1] - m[1][2]) / s;
		q.y = (m[0][2] - m[2][0]) / s;
		q.z = (m[1][0] - m[0][1]) / s;
	}
	else if ((m[0][0] > m[1][1]) && (m[0][0] > m[2][2])) {
		float s = sqrt(1.0 + m[0][0] - m[1][1] - m[2][2]) * 2; // S=4*qx 
		q.w = (m[2][1] - m[1][2]) / s;
		q.x = 0.25 * s;
		q.y = (m[0][1] + m[1][0]) / s;
		q.z = (m[0][2] + m[2][0]) / s;
	}
	else if (m[1][1] > m[2][2]) {
		float s = sqrt(1.0 + m[1][1] - m[0][0] - m[2][2]) * 2; // S=4*qy
		q.w = (m[0][2] - m[2][0]) / s;
		q.x = (m[0][1] + m[1][0]) / s;
		q.y = 0.25 * s;
		q.z = (m[1][2] + m[2][1]) / s;
	}
	else {
		float s = sqrt(1.0 + m[2][2] - m[0][0] - m[1][1]) * 2; // S=4*qz
		q.w = (m[1][0] - m[0][1]) / s;
		q.x = (m[0][2] + m[2][0]) / s;
		q.y = (m[1][2] + m[2][1]) / s;
		q.z = 0.25 * s;
	}

	return q;
}

// Rotate a vector with a rotation quaternion.
// http://mathworld.wolfram.com/Quaternion.html
float3 rotateWithQuaternion(float3 v, float4 r)
{
	float4 r_c = r * float4(-1.0, -1.0, -1.0, 1.0);
	return qmul(r, qmul(float4(v, 0.0), r_c)).xyz;
}

float4 getAngleAxisRotation(float3 v, float3 axis, float angle) {
	axis = normalize(axis);
	float s, c;
	sincos(angle*0.5, s, c);
	return float4(axis.x*s, axis.y*s, axis.z*s, c);
}

float3 rotateAngleAxis(float3 v, float3 axis, float angle) {
	float4 q = getAngleAxisRotation(v, axis, angle);
	return rotateWithQuaternion(v, q);
}

float4 fromToRotation(float3 from, float3 to) {
	float3
		v1 = normalize(from),
		v2 = normalize(to),
		cr = cross(v1, v2);
	float4 q = float4(cr, 1 + dot(v1, v2));
	return normalize(q);
}

float4 getRandomRotation(float2 uv) {

	// Uniform random unit quaternion.
	// http://tog.acm.org/resources/GraphicsGems/gemsiii/urot.c
	float3 r3 = rand3(uv);

	float r1 = sqrt(1.0 - r3.x);
	float r2 = sqrt(r3.x);
	float t1 = PI2 * r3.y;
	float t2 = PI2 * r3.z;

	return float4(sin(t1) * r1, cos(t1) * r1, sin(t2) * r2, cos(t2) * r2);
}

#endif