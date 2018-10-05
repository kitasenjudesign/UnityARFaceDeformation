Shader "FaceDot"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		
		_MainTex ("_MainTex", 2D) = "white" {}


		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Amount ("_Amount", Range(0,10)) = 0.0
		_Speed  ("_Speed", float) = 1
		_Ratio ("_Ratio", Range(0,1)) = 0
		_Size ("_Size", Range(0.01,0.1)) = 0.04
		_Num("_Num", Vector) = (0,0,0,2)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "DisableBatching"="True" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard vertex:vert addshadow
		#pragma instancing_options procedural:setup
		
		struct Input
		{
			float2 uv_MainTex;
            float4 col;//position  : POSITION;
		};
		// Boidの構造体
		struct DotData
		{
			float3 position;
			float3 velocity;
			float3 scale;
			//float3 rotation;
			float4 color;
			float3 basePos;
			float2 uv;
			float time;
		};

		#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			// Boidデータの構造体バッファ
			StructuredBuffer<DotData> _CubeDataBuffer;
		#endif

		sampler2D _MainTex; // テクスチャ

		half   _Glossiness; // 光沢
		half   _Metallic;   // 金属特性
		fixed4 _Color;      // カラー
		float _Amount;
		float _Size;
		float _Speed;
		float _Ratio;
		float _Scale;
		float4 _Num;
		float3 _ObjectScale; // Boidオブジェクトのスケール
		
		float4x4 _modelMatrix;


		// オイラー角（ラジアン）を回転行列に変換
		float4x4 eulerAnglesToRotationMatrix(float3 angles)
		{
			float ch = cos(angles.y); float sh = sin(angles.y); // heading
			float ca = cos(angles.z); float sa = sin(angles.z); // attitude
			float cb = cos(angles.x); float sb = sin(angles.x); // bank

			// Ry-Rx-Rz (Yaw Pitch Roll)
			return float4x4(
				ch * ca + sh * sb * sa, -ch * sa + sh * sb * ca, sh * cb, 0,
				cb * sa, cb * ca, -sb, 0,
				-sh * ca + ch * sb * sa, sh * sa + ch * sb * ca, ch * cb, 0,
				0, 0, 0, 1
			);
		}

		// 頂点シェーダ
		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED


			// インスタンスIDからBoidのデータを取得
			DotData cubeData = _CubeDataBuffer[unity_InstanceID]; 

			float3 pos = cubeData.position.xyz; // Boidの位置を取得
			//float3 scl = float3(_Size,_Size,_Size);//_ObjectScale;          // Boidのスケールを取得

			float ss = saturate(_Amount);
			//float3 scl = float3(_Size-ss*0.02,_Size-ss*0.02,_Size-ss*0.02);//_ObjectScale;          // Boidのスケールを取得
			float3 scl = float3(_Size,_Size,_Size) * cubeData.scale;//_ObjectScale;          // Boidのスケールを取得

			// オブジェクト座標からワールド座標に変換する行列を定義
			float4x4 object2world = (float4x4)0;
			object2world._11_22_33_44 = float4(scl.xyz, 1.0);
			float4x4 rotMatrix = eulerAnglesToRotationMatrix(float3(0, 0, cubeData.position.z*10.0));
			object2world = mul(rotMatrix, object2world);// 行列に回転を適用
			object2world._14_24_34 += pos.xyz;// 行列に位置（平行移動）を適用
			
			//object2world = mul(_modelMatrix, object2world);//親のモデルマトリックスも噛ませます
						
			v.vertex = mul(object2world, v.vertex);
			// 法線を座標変換
			v.normal = normalize(mul(object2world, v.normal));

			float4 faceWorldPos = float4(cubeData.basePos.xyz,1);//mul(_modelMatrix, float4(cubeData.basePos.xyz,1));
			//float4 faceWorldPos = mul(object2world, float4(0,0,0,1.0));

			float4 faceProjPos = mul( UNITY_MATRIX_VP, faceWorldPos );
			float4 faceScreenPos = ComputeScreenPos(faceProjPos);
			float2 uvv = faceScreenPos.xy/faceScreenPos.w;
			
			

			//ここで色を渡している
			o.col = float4(cubeData.color.rgb,0);//uv
			//o.col = float4(_CubeDataBuffer[unity_InstanceID].uv,0,0);//uv

			#endif
		}
		
		void setup()
		{
		}

		// サーフェスシェーダ
		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			//270
			//720
			
			fixed4 c1 = tex2D (_MainTex, IN.col.xy );// + r );
			o.Albedo = IN.col.xyz;//c1.rgb;//IN.col.xyz;//c.rgb;// * IN.color.xyz;
			o.Metallic = _Metallic;
			//o.Emission = IN.col.xyz*0.3;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}