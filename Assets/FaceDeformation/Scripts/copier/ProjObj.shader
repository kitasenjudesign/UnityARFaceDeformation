// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ProjObj"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScaleY ("_ScaleY",float) = 0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }//"DisableBatching"="True" }
		LOD 100
		Cull off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 screenPos : TEXCOORD2;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			
			
			float4x4 _tMat;
			float4x4 _modelMat;
			float4x4 _projMat;
			float4x4 _viewMat;
			float _ScaleY;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				

				float4 vv = v.vertex;
				float yy = 1 + 6 * (0.5 + 0.5 * sin(_ScaleY-3.1415/2));
				vv.y = sign(vv.y) * 0.5 * pow( abs( vv.y )*2, 1/yy ) * yy;
				o.vertex = UnityObjectToClipPos(vv);


				float4 worldPos = mul(_modelMat,float4(v.vertex.xyz, 1.0));
				float4 viewPos = mul( _viewMat, worldPos );
				float4 projPos = mul( _projMat, viewPos );
				float4 screenPos = ComputeScreenPos(projPos);
				
				//float2 uv = screenPos.xy/screenPos.w;
				//uv.y = 1 - uv.y;
				//o.tangent = float4(uv,0,0);
				o.screenPos = screenPos;
				
				//mul(_tMat, projPos);//TRANSFORM_TEX(v.uv, _MainTex);

				/*
					float4 faceWorldPos = mul(_faceMatrix,IN.vertex);
					float4 faceProjPos = mul( UNITY_MATRIX_VP, faceWorldPos );
					float4 faceScreenPos = ComputeScreenPos(faceProjPos);
					float2 uv = faceScreenPos.xy/faceScreenPos.w;
				*/

				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2DProj(texture, i.tangent);//tex2D(_MainTex, i.uv);
				
				float2 uv = i.screenPos.xy/i.screenPos.w;
				//uv.y = 1 - uv.y;
				//o.tangent = float4(uv,0,0);

				//fixed4 col =tex2D(_MainTex, i.tangent.xy / i.tangent.w);
				fixed4 col = tex2D( _MainTex, uv);//i.tangent.xy );
				
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
