#ifndef POST_BLEND_INCLUDE
#define POST_BLEND_INCLUDE

#define WET(n) o.blendAlpha.w = n;
struct pOut
{
	half4 blendColor : SV_Target0;
	half4 blendAlpha : SV_Target1;
	half4 mull : SV_Target2;
	half4 add : SV_Target3;
};

half blendWeight(half depth){
	depth = abs(depth);
	return clamp(pow(depth, -4),1e-4,5e10);
}
half blendDepth(half depth){
	depth = abs(depth);
	return max(0,_ProjectionParams.z - depth);
}

pOut alphaBlend(half4 c, half depth){
	half w = blendWeight(depth);
	pOut o;

	o.blendColor = half4(c.rgb*c.a*w,c.a);
	o.blendAlpha = half4(c.a*w, 0, 0, 0);
	o.mull = 0;
	o.add = 0;
	
	return o;
}

pOut additiveBlend(half4 c){
	c.rgb *= c.a;
	pOut o;
	
	o.blendColor = 0;
	o.blendAlpha = half4(0,0,0,0);
	o.mull = 0;
	o.add = half4(c.rgb,0);
	
	return o;
}

pOut multiplyBlend(half4 c){
	c.rgb = lerp(half3(1,1,1), c.rgb, c.a);
//	c.rgb = saturate(c.rgb);
	pOut o;
	
	o.blendColor = 1;
	o.blendAlpha = 1;
	o.mull = half4(c.rgb,1);
	o.add = 1;
	
	return o;
}

pOut alphaDepth(half4 c, half depth){
	c.a = saturate(c.a*5);
	pOut o;
	
	o.blendColor = 0;
	o.blendAlpha = half4(0, c.a*blendDepth(depth), 0, 0);
	o.mull = 0;
	o.add = 0;
	
	return o;
}
pOut multiplyDepth(half4 c, half depth){
	c.rgb = lerp(half3(1,1,1), c.rgb, c.a);
	c.a = distance(half3(1,1,1), c.rgb);
	c.a = saturate(c.a*5);
	pOut o;
	
	o.blendColor = 0;
	o.blendAlpha = 0;
	o.mull = half4(0,0,0,c.a*blendDepth(depth));
	o.add = 0;
	
	return o;
}
pOut additiveDepth(half4 c, half depth){
	c.rgb *= c.a;
	c.a = distance(half3(0,0,0), c.rgb);
	c.a = saturate(c.a*5);
	pOut o;
	
	o.blendColor = 0;
	o.blendAlpha = 0;
	o.mull = 0;
	o.add = half4(0,0,0,c.a*blendDepth(depth));
	
	return o;
}

#endif