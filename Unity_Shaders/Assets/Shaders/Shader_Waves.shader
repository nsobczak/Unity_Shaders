Shader "Unlit/Waves"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Gloss("Gloss", Float) = 5
		_WaveSize("WaveSize", Float) = 0.04
		_WaveSpeed("WaveSpeed", Float) = 4
		_WaterColor("WaterColor", Color) = (0.1, 0.2, 1, 1)
		_WavesColor("WavesColor", Color) = (0.4, 0.8, 1, 1)
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
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct VertextInput
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				//float4 colors : COLOR;
				//float4 tangent : TANGENT;
				float2 uv0 : TEXCOORD0;
				//float2 uv1 : TEXCOORD1;
			};

			struct VertexOutput
			{
				float4 clipSpacePos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			float4 _Color;
			float _Gloss;
			float _WaveSize, _WaveSpeed;
			float3 _WaterColor, _WavesColor;

			VertexOutput vert(VertextInput v)
			{
				VertexOutput o;
				o.uv0 = v.uv0;
				o.normal = v.normal;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.clipSpacePos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(VertexOutput o) : SV_Target
			{
				float waveShape = o.uv0.y;
				float waveAmp = (sin(waveShape / _WaveSize + _Time.y * _WaveSpeed) + 1) * 0.5f;

				float3 waterWithWaves = lerp(_WaterColor, _WavesColor, waveAmp);

				return float4(waterWithWaves, 0);
			}
		ENDCG
		}
	}
}
