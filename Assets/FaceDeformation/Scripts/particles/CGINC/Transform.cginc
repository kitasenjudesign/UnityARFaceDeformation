#ifndef TRANSFORM_INCLUDED
#define TRANSFORM_INCLUDED
// calculating formula from
// http://www.cg.info.hiroshima-cu.ac.jp/~miyazaki/knowledge/tech07.html

float3x3 getRotateMatrix(float3 right, float3 up, float3 forward) {
	float3x3 rot = float3x3(
		right.x, up.x, forward.x,
		right.y, up.y, forward.y,
		right.z, up.z, forward.z
		);
	return rot;
}

float3x3 getLookRotationMatrix(float3 look, float3 up) {
	float3 right = cross(up, look);
	up = cross(look, right);
	look = normalize(look);
	up = normalize(up);
	right = normalize(right);
	return getRotateMatrix(right, up, look);
}

float3 rotateX(float3 v, float angle) {
	float
		s = sin(angle),
		c = cos(angle);
	float3x3 rot = float3x3(
		1, 0, 0,
		0, c, -s,
		0, s, c
		);
	return mul(rot, v);
}

float3 rotateY(float3 v, float angle) {
	float
		s = sin(angle),
		c = cos(angle);
	float3x3 rot = float3x3(
		c, 0, s,
		0, 1, 0,
		-s, 0, c
		);
	return mul(rot, v);
}

float3 rotateZ(float3 v, float angle) {
	float
		s = sin(angle),
		c = cos(angle);
	float3x3 rot = float3x3(
		c, -s, 0,
		s, c, 0,
		0, 0, 1
		);
	return mul(rot, v);
}

float3 rotate(float3 v, float3 axis, float angle) {
	float
		s = sin(angle),
		c = cos(angle);
	float
		nx = axis.x,
		ny = axis.y,
		nz = axis.z;
	float3x3 rot = float3x3(
		nx*nx*(1 - c) + c, nx*ny*(1 - c) - nz*s, nz*nx*(1 - c) + ny*s,
		nx*ny*(1 - c) + nz*s, ny*ny*(1 - c) + c, ny*nz*(1 - c) - nx*s,
		nz*nx*(1 - c) - ny*s, ny*nz*(1 - c) + nx*s, nz*nz*(1 - c) + c
		);
	return mul(rot, v);
}
#endif // TRANSFORM_INCLUDED