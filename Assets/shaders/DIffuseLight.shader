// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderTutorial/Tutorial2DiffuseLight" {
	Properties{
		_AmbientLightColor("Ambient Light Color", Color) = (1,1,1,1)
		_AmbientLighIntensity("Ambient Light Intensity", Range(0.0, 1.0)) = 1.0

		_DiffuseDirection("Diffuse Light Direction", Vector) = (0.22,0.84,0.78,1)
		_DiffuseColor("Diffuse Light Color", Color) = (1,1,1,1)
		_DiffuseIntensity("Diffuse Light Intensity", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
#pragma target 2.0
#pragma vertex vertexShader
#pragma fragment fragmentShader

			float4 _AmbientLightColor;
			float _AmbientLighIntensity;
			float3 _DiffuseDirection;
			float4 _DiffuseColor;
			float _DiffuseIntensity;

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
				o.normal = v.normal;
				return o;
			}
			//calculo el pixel shader
			float4 fragmentShader(vsOut psIn) : SV_Target
			{
				//calculo el producto escalar entre la direccion y la normal (da el brillo)
				float4 diffuse = saturate(dot(_DiffuseDirection, psIn.normal));
				//retorno la suma de la luz ambiente propia + el difusso
				return (_AmbientLightColor * _AmbientLighIntensity)
					+ (diffuse * _DiffuseColor * _DiffuseIntensity);
			}

			ENDCG
		}
	}
}