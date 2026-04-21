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
		_MaxHeight("MaxHeight", Float) = 3
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
0;630;1464;361;3263.283;888.5697;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;39;-2352.134,-842.6047;Inherit;False;670.6368;214.7107;Comment;3;40;34;35;UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;40;-2330.975,-799.056;Inherit;False;Property;_Tilling;Tilling;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-2152.222,-793.394;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;15,15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-2207.222,449.9026;Inherit;False;1305.838;602.7842;Comment;7;9;21;14;10;11;12;38;Height Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1905.497,-792.6047;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2232.318,-446.8604;Inherit;False;1130.529;290.3126;Comment;4;13;19;15;36;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2205.69,12.23698;Inherit;False;1067.676;288.764;Comment;4;17;20;18;37;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1943.928,626.0055;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-2177.601,501.7878;Inherit;True;Property;_HeightMap;HeightMap;0;0;Create;True;0;0;0;False;0;False;None;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;11;-1618.694,725.5079;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;10;-1756.144,506.6315;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1569.692,931.6113;Inherit;False;Property;_MaxHeight;MaxHeight;4;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1843.556,195.8953;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-2114.124,77.85083;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;0;False;0;False;None;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;13;-2166.847,-389.8961;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;None;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;36;-1881.23,-316.3162;Inherit;False;35;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;18;-1602.155,72.91924;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-1671.233,-390.7479;Inherit;True;Property;;;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1301.206,510.2001;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-1319.114,76.53697;Inherit;False;NormalMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1325.789,-393.9023;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1125.384,499.9026;Inherit;False;HeightMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-234.9628,49.98414;Inherit;False;20;NormalMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-231.6628,-44.6159;Inherit;False;19;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-223.7627,285.2841;Inherit;False;21;HeightMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;16;-13.27219,441.3933;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Piso;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;40;0
WireConnection;35;0;34;0
WireConnection;10;0;9;0
WireConnection;10;1;38;0
WireConnection;18;0;17;0
WireConnection;18;1;37;0
WireConnection;15;0;13;0
WireConnection;15;1;36;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;14;2;12;0
WireConnection;20;0;18;0
WireConnection;19;0;15;0
WireConnection;21;0;14;0
WireConnection;0;0;22;0
WireConnection;0;1;23;0
WireConnection;0;11;24;0
WireConnection;0;14;16;0
ASEEND*/
//CHKSM=BC75B5223441AFA10CACC61A492DA0EDE72D8B1B