Shader "Unlit/BasicToon"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Gloss("Gloss", Float) = 5
		_StepColor("Step_color", Float) = 4
		_StepGloss("Step_gloss", Float) = 8
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

			//sampler2D _MainTex;
			//float4 _MainTex_ST;
			float4 _Color;
			float _Gloss;
			float _StepColor;
			float _StepGloss;

			VertexOutput vert(VertextInput v)
			{
				VertexOutput o;
				o.uv0 = v.uv0;
				o.normal = v.normal;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.clipSpacePos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float Posterize(float steps, float value) { return floor(value * steps) / steps; }

			float4 frag(VertexOutput o) : SV_Target
			{
				float2 uv = o.uv0;

				float3 normal = normalize(o.normal); //interpolated

				// lighting
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;

				// direct diffuse light
				float lightFalloff = max(0, dot(lightDir, o.normal));
				lightFalloff = Posterize(_StepColor, lightFalloff);
				float3 directDiffuseLight = lightColor * lightFalloff;

				// ambient light
				float3 ambiantLight = float3(0.2f, 0.2f, 0.2f);

				// direct specular light
				float3 camPos = _WorldSpaceCameraPos;
				float3 fragToCam = camPos - o.worldPos;
				float3 viewDir = normalize(fragToCam);
				float3 viewReflect = reflect(-viewDir, normal);
				float specularFalloff = max(0, dot(viewReflect, lightDir));
				specularFalloff = pow(specularFalloff, _Gloss); // gloss
				specularFalloff = Posterize(_StepGloss, specularFalloff); // gloss
				float3 directSpecular = specularFalloff * lightColor;

				// composite
				float3 diffuseLight = ambiantLight + directDiffuseLight;
				float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecular;

				return float4(finalSurfaceColor, 0);
			}
		ENDCG
		}
	}
}
