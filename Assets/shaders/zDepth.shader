Shader "Custom/zDepth"
{
	SubShader
	{
		Tags{ "Queue" = "Transparent" }

		GrabPass
		{
			"_GrabTexture"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			sampler2D _GrabTexture;
			sampler2D _CameraDepthTexture;

			fixed4 frag(v2f i) : SV_Target
			{
				half4 depthValue = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.uv)).r * 10.0;
				half4 depth;

				depth.r = depthValue;
				depth.g = depthValue;
				depth.b = depthValue;

				depth.a = 1;
				return depth;
			}
				ENDCG
	}
	}
		FallBack "Diffuse"
}
