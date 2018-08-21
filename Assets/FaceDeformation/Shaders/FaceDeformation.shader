
Shader "Face/FaceDeformation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
	Pass
	{

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	
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
	float4x4 _displayMatrix;
	float4x4 _faceMatrix;

	v2f vert(appdata_t IN)
	{
		v2f OUT;

		OUT.vertex = UnityObjectToClipPos(IN.vertex);
		OUT.texcoord = IN.texcoord;
		OUT.color = IN.color;

		//移動ができなくなる
		//float4 facePosWorld = mul(UNITY_MATRIX_M, IN.vertex);
		//float4 pos = mul( UNITY_MATRIX_VP, facePosWorld );

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
