// Based on cician's shader from: https://forum.unity3d.com/threads/simple-optimized-blur-shader.185327/#post-1267642
// also from https://forum.unity3d.com/threads/simple-optimized-blur-shader.185327/

Shader "Custom/BlurShader2" {
	Properties
	{
		_Size("Blur", Range(0, 10)) = 1
		[HideInInspector] _MainTex("Texture (RGB)", 2D) = "white" {}
		// _TintColor ("Tint Color", Color) = (1,1,1,1)
	}

	CGINCLUDE
	#define STEPS 8
	struct appdata_t
	{
		float4 vertex : POSITION;
		float2 texcoord: TEXCOORD0;
		float4 color    : COLOR;
	};

	struct v2f
	{
		float4 vertex : POSITION;
		float4 uvgrab : TEXCOORD0;
		float2 uvmain : TEXCOORD1;
		float4 color    : COLOR;
	};

	float blur_weight(float x) {
		return smoothstep(0.0f, 1.0f, 1.0f - abs(x)*0.01f);
	}
	ENDCG

	Category{
		// We must be transparent, so other objects are drawn before this one.
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
	
		SubShader
		{
			ZWrite Off
			// Horizontal blur
			GrabPass{"_HBlur"}

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

					#if UNITY_UV_STARTS_AT_TOP
							float scale = -1.0;
					#else
							float scale = 1.0;
					#endif

					o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
					o.uvgrab.zw = o.vertex.zw;

					o.uvmain = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.color = v.color;
					return o;
				}

				sampler2D _HBlur;
				float4 _HBlur_TexelSize;
				float _Size;

				half4 frag(v2f i) : COLOR
				{
					float alpha = tex2D(_MainTex, i.uvmain).a * i.color.a;
					half4 sum = half4(0,0,0,0);

					#define GRABPIXEL(kernelx , kernely) tex2Dproj( _HBlur, UNITY_PROJ_COORD(float4(i.uvgrab.x + _HBlur_TexelSize.x * kernelx * _Size * alpha, i.uvgrab.y + _HBlur_TexelSize.y * kernely * _Size * alpha, i.uvgrab.z, i.uvgrab.w))) * weight

					float totalWeight = 0;
					for (int step = -STEPS; step <= STEPS; ++step) {
						float weight = blur_weight(step);
						sum += GRABPIXEL(  step , 0);
						totalWeight += weight;
					}

					return sum / totalWeight;
				}
				ENDCG
			}

			// Vertical blur
			GrabPass{"_VBlur"}

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

					#if UNITY_UV_STARTS_AT_TOP
							float scale = -1.0;
					#else
							float scale = 1.0;
					#endif

					o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
					o.uvgrab.zw = o.vertex.zw;

					o.uvmain = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.color = v.color;
					return o;
				}

				sampler2D _VBlur;
				float4 _VBlur_TexelSize;
				float _Size;

				half4 frag(v2f i) : COLOR
				{
					float alpha = tex2D(_MainTex, i.uvmain).a * i.color.a;
					half4 sum = half4(0,0,0,0);


					#define GRABPIXEL(kernelx , kernely) tex2Dproj( _VBlur, UNITY_PROJ_COORD(float4(i.uvgrab.x + _VBlur_TexelSize.x * kernelx * _Size * alpha, i.uvgrab.y + _VBlur_TexelSize.y * kernely * _Size * alpha, i.uvgrab.z, i.uvgrab.w))) * weight

					float totalWeight = 0;
					for (int step = -STEPS; step <= STEPS; ++step) {
						float weight = blur_weight(step);
						sum += GRABPIXEL(0, step);
						totalWeight += weight;
					}

					return sum / totalWeight;
				}
				ENDCG
			}


			// Cross blur
			GrabPass{"_CBlur"}

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

					#if UNITY_UV_STARTS_AT_TOP
						float scale = -1.0;
					#else
						float scale = 1.0;
					#endif

					o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
					o.uvgrab.zw = o.vertex.zw;

					o.uvmain = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.color = v.color;
					return o;
				}

				sampler2D _CBlur;
				float4 _CBlur_TexelSize;
				float _Size;

				half4 frag(v2f i) : COLOR
				{
					float alpha = tex2D(_MainTex, i.uvmain).a * i.color.a;
					half4 sum = half4(0,0,0,0);

					#define GRABPIXEL(kernelx , kernely) tex2Dproj( _CBlur, UNITY_PROJ_COORD(float4(i.uvgrab.x + _CBlur_TexelSize.x * kernelx * _Size * alpha, i.uvgrab.y + _CBlur_TexelSize.y * kernely * _Size * alpha, i.uvgrab.z, i.uvgrab.w))) * weight

					float totalWeight = 0;
					for (int step = -STEPS; step <= STEPS; ++step) {
						float weight = blur_weight(step);
						sum += GRABPIXEL(step, step);
						sum += GRABPIXEL(-step, step);
						totalWeight += weight * 2 ;
					}

					return sum / totalWeight;
				}
				ENDCG
			}

		}
	}
}
