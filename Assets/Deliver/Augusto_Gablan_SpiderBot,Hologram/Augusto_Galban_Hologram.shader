// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Augusto_Galban_Hologram"
{
	Properties
	{
		_LineSpeed("LineSpeed", Float) = 2
		_Speed("Speed", Float) = 2
		_Frequency("Frequency", Float) = 8
		_Reveal("Reveal", Range( 0 , 1)) = 1
		_Opacity("Opacity", Range( 0 , 1)) = 0.9
		_InnerShieldtexture("Inner Shield texture", 2D) = "white" {}
		_Texturecolor("Texture color", Color) = (1,1,1,0)
		_Scanlinetexture("Scanline texture", 2D) = "white" {}
		_Scanlinecolor("Scanline color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+3100" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Scanlinetexture;
		uniform float4 _Scanlinetexture_ST;
		uniform float4 _Scanlinecolor;
		uniform sampler2D _InnerShieldtexture;
		uniform float4 _InnerShieldtexture_ST;
		uniform float4 _Texturecolor;
		uniform float _LineSpeed;
		uniform float _Speed;
		uniform float _Frequency;
		uniform float _Opacity;
		uniform float _Reveal;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Scanlinetexture = i.uv_texcoord * _Scanlinetexture_ST.xy + _Scanlinetexture_ST.zw;
			float2 uv_InnerShieldtexture = i.uv_texcoord * _InnerShieldtexture_ST.xy + _InnerShieldtexture_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float VertexAxis10 = ase_vertex3Pos.y;
			float mulTime7 = _Time.y * _LineSpeed;
			float ScanlineWave4 = ( ( sin( ( ( ( VertexAxis10 + mulTime7 ) * _Speed ) * _Frequency ) ) + 1.0 ) / 2.0 );
			float4 lerpResult39 = lerp( ( tex2D( _Scanlinetexture, uv_Scanlinetexture ) * _Scanlinecolor ) , ( tex2D( _InnerShieldtexture, uv_InnerShieldtexture ) * _Texturecolor ) , ScanlineWave4);
			float4 HologramColor2 = lerpResult39;
			o.Albedo = saturate( HologramColor2 ).rgb;
			float HoloOpacity34 = ( ( ( ( ScanlineWave4 + 1.0 ) / 2.0 ) * _Opacity ) * _Reveal );
			o.Alpha = HoloOpacity34;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;654;1464;337;4460.54;1215.444;4.299711;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1691.418,-71.47545;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;60;-2588.981,163.0151;Inherit;False;1948.96;323.4166;;12;4;20;19;15;14;11;13;8;12;7;9;6;Line Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-1466.307,-20.87117;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2555.325,296.4066;Inherit;False;Property;_LineSpeed;LineSpeed;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1198.337,-27.90825;Inherit;False;VertexAxis;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-2393.836,302.6729;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-2394.836,224.673;Inherit;False;10;VertexAxis;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-2165.836,239.6731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2232.654,375.0036;Inherit;False;Property;_Speed;Speed;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2009.555,392.5648;Inherit;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1958.837,236.6731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1808.837,235.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;15;-1637.837,236.673;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1503.022,237.4511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1365.021,234.4511;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-830.75,232.2846;Inherit;False;ScanlineWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-2260.494,-872.1191;Inherit;False;2004.774;722.5978;;10;43;40;42;2;39;5;46;41;45;47;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-2288.291,609.2922;Inherit;False;1531.205;354.1891;;8;34;38;37;32;33;29;28;27;HoloOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;42;-2247.112,-761.7011;Inherit;True;Property;_InnerShieldtexture;Inner Shield texture;5;0;Create;True;0;0;0;False;0;False;5798ded558355430c8a9b13ee12a847c;5798ded558355430c8a9b13ee12a847c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2164.385,669.8422;Inherit;False;4;ScanlineWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-1886.846,-761.8494;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;5798ded558355430c8a9b13ee12a847c;5798ded558355430c8a9b13ee12a847c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;-1396.651,-824.8656;Inherit;True;Property;_Scanlinetexture;Scanline texture;7;0;Create;True;0;0;0;False;0;False;-1;aaaba0e5d62f83240892e62ae30d8c92;aaaba0e5d62f83240892e62ae30d8c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;-2084.38,-397.799;Inherit;False;Property;_Texturecolor;Texture color;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1866.287,675.9104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;-1306.264,-624.1784;Inherit;False;Property;_Scanlinecolor;Scanline color;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1491.74,-412.0567;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;5;-1229.159,-244.9931;Inherit;False;4;ScanlineWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1795.86,783.4611;Inherit;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;0.9;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1060.001,-733.8718;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-1656.393,677.464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;-927.9249,-441.4546;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1792.581,871.0358;Inherit;False;Property;_Reveal;Reveal;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1423.831,675.3773;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2;-508.9583,-584.7772;Inherit;False;HologramColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1144.381,675.4655;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-960.6325,670.7141;Inherit;False;HoloOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-643.3858,-3.816479;Inherit;False;2;HologramColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;25;-418.0137,2.327812;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-203.168,300.4093;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-245.6813,215.2216;Inherit;False;34;HoloOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Augusto_Galban_Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;3100;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;16;2
WireConnection;10;0;17;0
WireConnection;7;0;6;0
WireConnection;8;0;9;0
WireConnection;8;1;7;0
WireConnection;11;0;8;0
WireConnection;11;1;12;0
WireConnection;14;0;11;0
WireConnection;14;1;13;0
WireConnection;15;0;14;0
WireConnection;19;0;15;0
WireConnection;20;0;19;0
WireConnection;4;0;20;0
WireConnection;40;0;42;0
WireConnection;28;0;27;0
WireConnection;41;0;40;0
WireConnection;41;1;43;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;29;0;28;0
WireConnection;39;0;46;0
WireConnection;39;1;41;0
WireConnection;39;2;5;0
WireConnection;32;0;29;0
WireConnection;32;1;33;0
WireConnection;2;0;39;0
WireConnection;38;0;32;0
WireConnection;38;1;37;0
WireConnection;34;0;38;0
WireConnection;25;0;26;0
WireConnection;0;0;25;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=7EDB31CBA3D49B6578DD50AD8892D137BDDA68FA