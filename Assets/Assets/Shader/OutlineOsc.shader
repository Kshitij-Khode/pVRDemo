// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Outlined/OutlineOsc" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (0.0, 0.03)) = .005
		_MainTex ("Base (RGB)", 2D) = "white" { }
	}
 
	SubShader {
		Tags { 
			"RenderType"="Opaque" 
		}

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			float4 color : Color;
			float2 uv_MainTex;
			float3 viewDir;
			float4 _Time;
		};

		float4 _ColorTint;
		sampler2D _MainTex;
		float4 _GlowColor;
		float _GlowPower;
		float _UpDown;

		void surf(Input IN, inout SurfaceOutput o) {
			_GlowPower = 5 * sin(_Time.y);
			IN.color = _ColorTint;
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * IN.color;
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _GlowColor.rgb * pow(rim, _GlowPower);
		}
		ENDCG
	}
 
	Fallback "Diffuse"
}