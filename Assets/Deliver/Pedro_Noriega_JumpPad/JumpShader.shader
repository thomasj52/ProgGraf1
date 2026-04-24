// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "JumpShader"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Tint("Tint", Color) = (0.1359016,1,0,0)
		_PannerSpeed("PannerSpeed", Vector) = (0,0,0,0)
		_FullColorheight("Full Color height", Range( 1 , 1.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Tint;
		uniform sampler2D _MainTex;
		uniform float2 _PannerSpeed;
		uniform float _FullColorheight;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner11 = ( 1.0 * _Time.y * _PannerSpeed + i.uv_texcoord);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult52 = lerp( _Tint , ( tex2D( _MainTex, ( float2( 0,0 ) + panner11 ) ) * _Tint ) , ( ase_vertex3Pos.y + _FullColorheight ));
			o.Albedo = saturate( lerpResult52 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;654;1464;337;5987.434;767.0236;5.112;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-2237.222,-194.9357;Inherit;False;903.2081;365.0179;Comment;5;17;9;11;12;41;Texture panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2193.887,-127.2985;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;17;-2158.31,5.129273;Inherit;False;Property;_PannerSpeed;PannerSpeed;2;0;Create;True;0;0;0;False;0;False;0,0;0,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;11;-1977.147,-87.65683;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1119.017,-306.4708;Inherit;False;961.7444;588.1625;Comment;7;72;1;52;51;10;46;61;Coloring / Texture height limit;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1756.839,-77.64294;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1622.386,-114.2096;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;a63b2c1adf8261e42966d2dec0876048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-1046.129,190.7612;Inherit;False;Property;_FullColorheight;Full Color height;3;0;Create;True;0;0;0;False;0;False;0;1.194;1;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-964.8772,17.49137;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-1095.51,-256.6062;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;0.1359016,1,0,0;0.08884311,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-784.9448,-105.5104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-733.4147,66.11575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;72;-641.0859,-176.4729;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;52;-421.5199,-24.27556;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;50;23.85107,-28.59844;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;303.824,-29.28425;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;JumpShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;12;0
WireConnection;11;2;17;0
WireConnection;41;1;11;0
WireConnection;9;1;41;0
WireConnection;10;0;9;0
WireConnection;10;1;1;0
WireConnection;51;0;46;2
WireConnection;51;1;61;0
WireConnection;72;0;1;0
WireConnection;52;0;72;0
WireConnection;52;1;10;0
WireConnection;52;2;51;0
WireConnection;50;0;52;0
WireConnection;0;0;50;0
ASEEND*/
//CHKSM=C5C18E208AB71AEB0BE52960A01FC7FD62672963