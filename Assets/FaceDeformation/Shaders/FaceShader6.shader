// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Face/FaceShader6"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DispTex ("Texture", 2D) = "white" {}
		_DummyTex ("_DummyTex", 2D) = "white" {}
		_EmoRatio("EmoRatio", Range(-0.2,0.2)) = 0
		//_ColorTex ("Texture", 2D) = "white" {}		
		_Offset ("Offset", Vector) = (0,0,1,1)
		_DeformRatio ("_DeformRatio",	Range (0.0,3.0)) = 3.0
		_DeformFreq ("_DeformFreq",		Range(0.0,100.0)) = 50.0
		_DeformSpeed ("_DeformSpeed",		Range(0.0,100.0)) = 50.0
		

		//_mono("mono",Range(0.0,1.0)) = 1.0
		_ColorScale("_ColorScale",Range(-2.0,2.0)) = 1.0
	}
	
	SubShader
	{
		Cull off

	Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile __ DEBUG
		
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
		sampler2D _DispTex;	
		sampler2D _DummyTex;
		float4x4 _displayMatrix;
		float4x4 _faceMatrix;	
		//sampler2D _GlobalTextureColor;		
			

		float4 _Offset;
		float _DeformRatio;//変形用の値です。
		float _DeformFreq;
		float _DeformSpeed;
		float _EmoRatio;
		//色のスケールを変えるものにしたい

		float _ColorScale;
		// vertex shader


		v2f vert(appdata_t IN)
		{
			v2f OUT;

			float4 v = IN.vertex;

			//顔をランダムに動かす
			float4 deform = tex2Dlod (_MainTex, float4(IN.texcoord.xy,0,0));	//
			float4 emotion = tex2Dlod (_DispTex, float4(IN.texcoord.xy,0,0));	//顔用のdisplacement
			
			float ratioByImg = _DeformRatio * deform.x;//sin(_Time.x);

			//v.x = v.x + ratioByImg * 0.20 * snoise(v.y*30.0 + _Time.z*80.0 + 3.0);
			//v.x = v.x + ratioByImg * 0.20 * snoise( v.y*_DeformFreq + _Time.z*_DeformSpeed);
			//v.y = v.y + ratioByImg * 0.01 * snoise(v*11.0 + _Time.y/2.0 + 4.0);
			//v.z = v.z - ratioByImg * 0.03 + ratioByImg * 0.05 * sin( v.y * 50.0 + _Time.y);

				float3 vv = v;

				//to polar
				float amp = length(vv);
				float radX = (-atan2(vv.z, vv.x) + 3.1415 * 0.5); //+ vv.y * sin(_count) * nejireX;//横方向の角度
				float radY = asin(vv.y / amp);

				amp += 0.02 * snoise(vv.xyz*10.0 + _Time.z*80.0 + 3.0);
				
				vv.x = amp * sin( radX ) * cos( radY );//横
				vv.y = amp * sin( radY );//縦
				vv.z = amp * cos( radX ) * cos( radY );//横

			//faceEmotion
			float emoValue = - (emotion.x - 0.5) * _EmoRatio;
			v.y += emoValue;
			v.z += abs( emoValue * 0.05 );

			OUT.vertex = UnityObjectToClipPos(vv);
			OUT.texcoord = IN.texcoord;
			OUT.color = IN.color;

			//UV用。
			//float4 pos = UnityObjectToClipPos(IN.vertex);
			float4 facePosWorld = mul(_faceMatrix,IN.vertex);
			float4 pos = mul( UNITY_MATRIX_VP, facePosWorld );
			float4 hoge = ComputeScreenPos(pos);
			float2 uv = hoge.xy/hoge.w;
				float texX = uv.x;
				float texY = uv.y;
				uv.x = (_displayMatrix[0].x * texX + _displayMatrix[1].x * (texY) + _displayMatrix[2].x);
				uv.y = (_displayMatrix[0].y * texX + _displayMatrix[1].y * (texY) + (_displayMatrix[2].y));

			OUT.screenpos = uv;
			
			return OUT;
		}
		
		// fragment shader
		fixed4 frag(v2f IN) : COLOR
		{

			float2 xy = IN.screenpos.xy;

			xy = min(xy,float2(0.999,0.999));
			xy = max(xy,float2(0.001,0.001));

			fixed4 col = tex2D(_MainTex, xy);

			#if DEBUG
				col = tex2D(_DummyTex, IN.texcoord);
			#endif

			return col;
			//return fixed4(1,0,0,1);

		}
		ENDCG
	}
	}


}
