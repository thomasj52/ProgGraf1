// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ParedExteriorShader"
{
	Properties
	{
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_Vector1("Vector 0", Vector) = (0,0,0,0)
		_Float1("Float 0", Float) = 0
		_TextureSample2("Texture Sample 1", 2D) = "bump" {}
		_TextureSample3("Texture Sample 2", 2D) = "white" {}
		_TextureSample4("Texture Sample 3", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _TextureSample2;
		uniform float2 _Vector1;
		uniform float _Float1;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample4;
		uniform sampler2D _TextureSample3;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_6_0 = ( float3( ( _Vector1 / _Float1 ) ,  0.0 ) * (ase_worldPos).xyz );
			o.Normal = UnpackNormal( tex2D( _TextureSample2, temp_output_6_0.xy ) );
			o.Albedo = tex2D( _TextureSample1, temp_output_6_0.xy ).rgb;
			o.Smoothness = tex2D( _TextureSample4, temp_output_6_0.xy ).r;
			o.Occlusion = tex2D( _TextureSample3, temp_output_6_0.xy ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
243.2;73.6;1007.6;555;1791.336;930.0015;2.379945;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1153.198,-51.8172;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;2;-1084.998,-308.1173;Inherit;False;Property;_Vector1;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;3;-1070.699,-159.9172;Inherit;False;Property;_Float1;Float 0;2;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;4;-946.4996,-57.0172;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-880.1998,-253.3172;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-694.2994,-168.8171;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;7;-471.834,-476.2878;Inherit;True;Property;_TextureSample1;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;792d0f119fdb13f4b91674c99f744692;792d0f119fdb13f4b91674c99f744692;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-476.4943,-275.3655;Inherit;True;Property;_TextureSample2;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;1487087e53fd63b45a10cd95b7c76426;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-472.0723,-73.57942;Inherit;True;Property;_TextureSample4;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;3b160947d242dcd4395f4471452c000a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-470.7502,146.0931;Inherit;True;Property;_TextureSample3;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;f215e3a6d81ef3d4689eef8d40e04abf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-79.43928,-249.1235;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ParedExteriorShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;7;1;6;0
WireConnection;8;1;6;0
WireConnection;10;1;6;0
WireConnection;9;1;6;0
WireConnection;0;0;7;0
WireConnection;0;1;8;0
WireConnection;0;4;10;0
WireConnection;0;5;9;0
ASEEND*/
//CHKSM=3ABEA385FEEA005D72D74048730922EAEFED647A