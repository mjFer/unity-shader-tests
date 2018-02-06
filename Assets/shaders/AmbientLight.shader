// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//https://digitalerr0r.wordpress.com/2015/09/02/unity-5-shader-programming-1-an-introduction-to-shaders/
Shader "UnityShaderTutorial/Tutorial1AmbientLight" {
	Properties{
		_AmbientLightColor("Ambient Light Color", Color) = (1,1,1,1)
		_AmbientLighIntensity("Ambient Light Intensity", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Pass
		{
		CGPROGRAM
		//vertex shader 2.0
		#pragma target 2.0
		#pragma vertex vertexShader
		//pixel shader
		#pragma fragment fragmentShader

		//asi ve el shader nuestras properties
			fixed4 _AmbientLightColor;
			float _AmbientLighIntensity;

			//lo unico que hace es tomar el vertex y sacar la posicion en la pantalla
			//SV_POSITION es algo como un registro para definirle a la gpu donde retorna el resultado
			//	y como es POSITION sabe la gpu que es una pos x y z w
			float4 vertexShader(float4 v:POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(v);
			}

			//Toma la posicion del vertex shader por medio de SV_Target y le pinta el pixel
			fixed4 fragmentShader() : SV_Target
			{
				return _AmbientLightColor * _AmbientLighIntensity;
			}

		ENDCG
		}
	}
}
