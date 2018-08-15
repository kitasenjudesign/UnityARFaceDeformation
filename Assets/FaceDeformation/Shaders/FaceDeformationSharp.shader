Shader "Face/FaceDeformationSharp"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplaceTex ("Texture", 2D) = "white" {}		
		_Offset ("Offset", Vector) = (0,0,1,1)
		_Ratio ("Ratio", Range (0.0,3.0))= 3.0
	}
	
	SubShader
	{
	Pass
	{
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	#include "./noise/SimplexNoise3D.hlsl"
	
	struct appdata_t
	{
		float4 vertex : POSITION;
		float4 color : COLOR;
		float2 texcoord : TEXCOORD0;
	};
	
	struct v2f
	{
		float4 vertex : POSITION;
		float4 color : COLOR;
		float2 texcoord : TEXCOORD0;
		float2 screenpos : TEXCOORD1;
	};
	
	sampler2D _MainTex;
	sampler2D _DisplaceTex;
	
	
	float4x4 _displayMatrix;
	float4x4 _faceMatrix;

	float4 _Offset;
	float _Ratio;
	// vertex shader

		float mirrored(float v) {
			float m = fmod(v, 2.0);
			return lerp(m, 2.0 - m, step(1.0, m));
		}

	v2f vert(appdata_t IN)
	{
		v2f OUT;

		float4 v = IN.vertex;

		//顔をランダムに動かす
		float2 xy = IN.texcoord.xy; 
		xy.x = mirrored(xy.x*2)/2;
		float4 sharpCol = tex2Dlod (_DisplaceTex, float4(xy,0,0));	//顔用のdisplacement
			
		float3 vv = v;

		//to polar
		float amp = length(vv);
		float radX = (-atan2(vv.z, vv.x) + 3.1415 * 0.5);
		float radY = asin(vv.y / amp);

		float rr = step(0.5,sharpCol.x);
		float gg = step(0.5,sharpCol.y);
		float bb = step(0.5,sharpCol.z);
		amp += (rr+gg+bb) * _Ratio;
				
		vv.x = amp * sin( radX ) * cos( radY );//横
		vv.y = amp * sin( radY );//縦
		vv.z = amp * cos( radX ) * cos( radY );//横

		OUT.vertex = UnityObjectToClipPos(vv);
		OUT.texcoord = IN.texcoord;
		OUT.color = IN.color;

		float4 faceWorldPos = mul(_faceMatrix,IN.vertex);
		float4 faceProjPos = mul( UNITY_MATRIX_VP, faceWorldPos );
		float4 faceScreenPos = ComputeScreenPos(faceProjPos);
		float2 uv = faceScreenPos.xy/faceScreenPos.w;
		
		OUT.screenpos = uv;
		
		return OUT;
	}
	
	// fragment shader
	fixed4 frag(v2f IN) : COLOR
	{

		float2 xy = IN.screenpos.xy;
		half4 c = tex2D(_MainTex, xy);// * IN.color;		
		return c;

	}
	ENDCG
	}
	}


}
