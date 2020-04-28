Shader "Unlit/BasicShader"
{
	Properties
	{
		//_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct VertextInput
			{
				float4 vertex : POSITION;
				//float4 normal : NORMAL;
				//float4 colors : COLOR;
				//float4 tangent : TANGENT;
				//float2 uv0 : TEXCOORD0;
				//float2 uv1 : TEXCOORD1;
			};

			struct VertexOutput
			{
				float4 clipSpacePos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			VertexOutput vert(VertextInput v)
			{
				VertexOutput o;
				o.clipSpacePos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(VertexOutput i) : SV_Target
			{
				return float4(1, 1, 1, 0);
			}
		ENDCG
		}
	}
}
