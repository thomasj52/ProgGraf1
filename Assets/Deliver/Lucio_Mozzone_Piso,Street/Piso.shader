// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Piso"
{
	Properties
	{
		_HeightMap("HeightMap", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (0,1,0,0)
		_NormalMap("NormalMap", 2D) = "white" {}
		_MaxHeight("MaxHeight", Range( 0 , 0.3)) = 3
		_Tilling("Tilling", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _HeightMap;
		uniform float2 _Tilling;
		uniform float3 _Vector0;
		uniform float _MaxHeight;
		uniform sampler2D _NormalMap;
		uniform sampler2D _Albedo;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TexCoord34 = v.texcoord.xy * _Tilling;
			float2 UV35 = uv_TexCoord34;
			float4 HeightMap21 = ( tex2Dlod( _HeightMap, float4( UV35, 0, 0.0) ) * float4( _Vector0 , 0.0 ) * _MaxHeight );
			v.vertex.xyz += HeightMap21.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord34 = i.uv_texcoord * _Tilling;
			float2 UV35 = uv_TexCoord34;
			float4 NormalMap20 = tex2D( _NormalMap, UV35 );
			o.Normal = NormalMap20.rgb;
			float4 Albedo19 = tex2D( _Albedo, UV35 );
			o.Albedo = Albedo19.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;654;1464;337;3996.966;609.7083;4.053029;True;False
Node;AmplifyShaderEditor.CommentaryNode;39;-2222.297,-842.6047;Inherit;False;670.6368;214.7107;UV;3;40;34;35;UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;40;-2201.138,-799.056;Inherit;False;Property;_Tilling;Tilling;5;0;Create;True;0;0;0;False;0;False;0,0;40,40;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-2022.385,-793.394;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;15,15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-2207.222,448.379;Inherit;False;1305.838;602.7842;HeightMap;7;9;21;14;10;11;12;38;Height Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1775.659,-792.6047;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-2177.601,500.2642;Inherit;True;Property;_HeightMap;HeightMap;0;0;Create;True;0;0;0;False;0;False;None;141ca89b0c8951849be9034b4c4ea905;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;25;-2232.318,-446.8604;Inherit;False;1130.529;290.3126;Albedo;4;13;19;15;36;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2201.017,14.57367;Inherit;False;1067.676;288.764;NormalMap;4;17;20;18;37;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1943.928,624.4819;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-2166.847,-389.8961;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;None;6d3afb4bf8648164d8b214139ceea8f9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;12;-1737.904,906.3796;Inherit;False;Property;_MaxHeight;MaxHeight;4;0;Create;True;0;0;0;False;0;False;3;0.3;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-1881.23,-316.3162;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-2109.451,80.18752;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;0;False;0;False;None;3c5c32196e2c3d843b45b505774f6b4f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;11;-1618.694,723.9843;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1838.883,198.232;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-1756.144,505.1079;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1301.206,508.6765;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-1671.233,-390.7479;Inherit;True;Property;;;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1597.481,75.25593;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;72;-8032.57,-712.8079;Inherit;False;4601.471;977.4993;Comment;29;43;44;45;48;50;54;53;51;46;47;55;49;58;57;59;61;62;63;56;60;65;66;67;64;68;73;87;121;71;Parallax Mapping;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1325.789,-393.9023;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-1314.44,78.87366;Inherit;False;NormalMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1125.384,498.379;Inherit;False;HeightMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;50;-7215.959,-280.4859;Inherit;True;Property;_TextureParralax;Texture Parralax;6;0;Create;True;0;0;0;False;0;False;-1;6d3afb4bf8648164d8b214139ceea8f9;6d3afb4bf8648164d8b214139ceea8f9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-5107.457,-265.1209;Inherit;True;Property;_TextureSample5;Texture Sample 5;13;0;Create;True;0;0;0;False;0;False;-1;None;6d3afb4bf8648164d8b214139ceea8f9;True;0;False;white;Auto;False;Instance;50;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-7314.427,-53.88812;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0.09;0;0.09;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;64;-4712.357,-437.5784;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;60;-5389.572,-436.3154;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-334.1774,-36.88272;Inherit;False;19;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;45;-7834.263,-147.6401;Inherit;False;Constant;_Vector2;Vector 2;6;0;Create;True;0;0;0;False;0;False;3,3,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-7034.829,-55.18811;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-4959.662,137.2388;Inherit;False;55;View;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-6986.19,73.49146;Inherit;False;View;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-5690.856,6.729903;Inherit;False;53;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-3688.759,-447.4577;Inherit;False;ParallaxMapping;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;57;-6470.005,-308.4393;Inherit;True;Property;_TextureSample3;Texture Sample 3;13;0;Create;True;0;0;0;False;0;False;-1;None;6d3afb4bf8648164d8b214139ceea8f9;True;0;False;white;Auto;False;Instance;50;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;49;-6726.823,-437.288;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-6322.21,93.92049;Inherit;False;55;View;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;121;-7786.452,-412.9557;Inherit;False;Property;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-3929.826,-448.6305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-7582.109,-430.2774;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;47;-7531.454,-73.61893;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-7536.253,-259.1115;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;44;-7198.609,-431.3774;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-6383.052,-18.97696;Inherit;False;53;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-6967.732,-436.6357;Inherit;False;ScaleAndOffset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;16;-246.47,414.2588;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;54;-7207.92,74.32987;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;24;-261.14,295.836;Inherit;False;21;HeightMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-5630.014,119.6274;Inherit;False;55;View;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;73;-4241.885,-644.6667;Float;False;Property;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;56;-6090.347,-438.0003;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;68;-4327.971,-442.6653;Inherit;True;Property;_TextureSample6;Texture Sample 6;13;0;Create;True;0;0;0;False;0;False;-1;None;6d3afb4bf8648164d8b214139ceea8f9;True;0;False;white;Auto;False;Instance;50;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;122;-342.604,84.30027;Inherit;False;20;NormalMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-5020.503,24.34137;Inherit;False;53;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-5777.809,-282.7325;Inherit;True;Property;_TextureSample4;Texture Sample 4;13;0;Create;True;0;0;0;False;0;False;-1;None;6d3afb4bf8648164d8b214139ceea8f9;True;0;False;white;Auto;False;Instance;50;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Piso;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;40;0
WireConnection;35;0;34;0
WireConnection;10;0;9;0
WireConnection;10;1;38;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;14;2;12;0
WireConnection;15;0;13;0
WireConnection;15;1;36;0
WireConnection;18;0;17;0
WireConnection;18;1;37;0
WireConnection;19;0;15;0
WireConnection;20;0;18;0
WireConnection;21;0;14;0
WireConnection;66;1;60;0
WireConnection;64;0;60;0
WireConnection;64;1;66;1
WireConnection;64;2;65;0
WireConnection;64;3;67;0
WireConnection;60;0;56;0
WireConnection;60;1;62;1
WireConnection;60;2;61;0
WireConnection;60;3;63;0
WireConnection;53;0;51;0
WireConnection;55;0;54;0
WireConnection;71;0;87;0
WireConnection;57;1;49;0
WireConnection;49;0;48;0
WireConnection;49;1;50;1
WireConnection;49;2;53;0
WireConnection;49;3;55;0
WireConnection;87;0;73;0
WireConnection;87;1;68;0
WireConnection;43;0;121;0
WireConnection;47;0;45;3
WireConnection;47;1;45;4
WireConnection;46;0;45;1
WireConnection;46;1;45;2
WireConnection;44;0;43;0
WireConnection;44;1;46;0
WireConnection;44;2;47;0
WireConnection;48;0;44;0
WireConnection;56;0;49;0
WireConnection;56;1;57;1
WireConnection;56;2;58;0
WireConnection;56;3;59;0
WireConnection;68;1;64;0
WireConnection;62;1;56;0
WireConnection;0;0;22;0
WireConnection;0;1;122;0
WireConnection;0;11;24;0
WireConnection;0;14;16;0
ASEEND*/
//CHKSM=B320A6DAEE4C67A0DEB4FD1A531CA9217AA9CA30