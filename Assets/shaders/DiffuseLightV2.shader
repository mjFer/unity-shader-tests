// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityShaderTutorial/Tutorial2DiffuseLight2" {
	SubShader
	{
		Pass
		{
			//http://docs.unity3d.com/Manual/RenderTech-ForwardRendering.html
			Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM
			#include "UnityCG.cginc"

		#pragma target 2.0
		#pragma vertex vertexShader
		#pragma fragment fragmentShader

		float4 _LightColor0;
		

		//entro con una posicion y la normal
		struct vsIn {
			float4 position : POSITION;
			float3 normal : NORMAL;
		};

		//salgo a SV_POSITION y la normal correspondiente
		struct vsOut {
			float4 position : SV_POSITION;
			float3 normal : NORMAL;
		};

		//paso a SV_POSITION la pos en la pantalla
		vsOut vertexShader(vsIn v)
		{
			vsOut o;
			o.position = UnityObjectToClipPos(v.position);
			o.normal = normalize(mul(v.normal, unity_WorldToObject));	//lleva la normal
			return o;
		}
		//calculo el pixel shader
		float4 fragmentShader(vsOut psIn) : SV_Target
		{
			//color ambiental heredado de unity
			float4 AmbientLight = UNITY_LIGHTMODEL_AMBIENT;

			//saca la direccion de la luz 0 asignada
			float4 LightDirection = normalize(_WorldSpaceLightPos0);

			//saca el producto escalar entre la normal del vertice en cuestion
			float4 diffuseTerm = saturate(dot(LightDirection, psIn.normal));
			float4 DiffuseLight = diffuseTerm * _LightColor0;

			return AmbientLight + DiffuseLight;
		}

		ENDCG
		}
	}
}