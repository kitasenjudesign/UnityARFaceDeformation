// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Face/FaceShader5sin"
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


	v2f vert(appdata_t IN)
	{
		v2f OUT;

		float4 v = IN.vertex;

		float4 deform = tex2Dlod (_DisplaceTex, float4(IN.texcoord.xy,0,0));	//
		float ratio = _Ratio * deform;//sin(_Time.x);
		v.x = v.x + ratio * 0.01 * snoise(v*7.0 + _Time.x + 3.0);
		v.y = v.y + ratio * 0.01 * snoise(v*11.0 + _Time.y/2.0 + 4.0);
		v.z = v.z - ratio * 0.05 + ratio * 0.05 * sin( v.y * 50.0 + _Time.y);

		OUT.vertex = UnityObjectToClipPos(v);
		OUT.texcoord = IN.texcoord;
		OUT.color = IN.color;

		//UV用。
		//float4 pos = UnityObjectToClipPos(IN.vertex);
		float4 facePosWorld = mul(_faceMatrix,IN.vertex);
		float4 pos = mul( UNITY_MATRIX_VP, facePosWorld );
		float4 hoge = ComputeScreenPos(pos);
		float2 uv = hoge.xy/hoge.w;
		
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
