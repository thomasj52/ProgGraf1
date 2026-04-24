// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Island"
{
	Properties
	{
		_heightmap("height map", 2D) = "white" {}
		_Height("Height", Range( 0 , 4)) = 0
		_Texture("Texture ", 2D) = "white" {}
		_MaxHeight("Max Height", Range( 0 , 2.5)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _heightmap;
		uniform float4 _heightmap_ST;
		uniform float _Height;
		uniform float _MaxHeight;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.1);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_heightmap = v.texcoord * _heightmap_ST.xy + _heightmap_ST.zw;
			float4 temp_cast_1 = (_MaxHeight).xxxx;
			float4 clampResult9 = clamp( ( tex2Dlod( _heightmap, float4( uv_heightmap, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _Height ) , float4( 0,0,0,0 ) , temp_cast_1 );
			v.vertex.xyz += clampResult9.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			o.Albedo = tex2D( _Texture, uv_Texture ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;654;1464;337;1398.75;-327.4097;1.283584;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-1199.426,236.9172;Inherit;False;1146.56;499.926;Height map;7;5;3;6;7;11;4;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1106.386,641.4259;Inherit;False;Property;_Height;Height;1;0;Create;True;0;0;0;False;0;False;0;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;6;-1009.837,485.6971;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;3;-1145.188,285.1835;Inherit;True;Property;_heightmap;height map;0;0;Create;True;0;0;0;False;0;False;-1;4902d0bf70cbe7a42800988992ca2d50;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-558.0613,290.3211;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-703.1827,595.7748;Inherit;False;Property;_MaxHeight;Max Height;3;0;Create;True;0;0;0;False;0;False;1;0.5;0;2.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;9;-370.2732,287.8702;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.5377358,0.5377358,0.5377358,0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;4;-347.8948,532.8774;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;8;-412.6535,-5.115938;Inherit;True;Property;_Texture;Texture ;2;0;Create;True;0;0;0;False;0;False;-1;7bf586a3a23003b4d98d89d8d2745e7f;1028a9ab963ee014eb604a527e73c29b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;6;0
WireConnection;5;2;7;0
WireConnection;9;0;5;0
WireConnection;9;2;11;0
WireConnection;0;0;8;0
WireConnection;0;11;9;0
WireConnection;0;14;4;0
ASEEND*/
//CHKSM=BC817F33B60505AC0280577BB392D3BE72B24A2C