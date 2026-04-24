// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Augusto_Galban_Energy"
{
	Properties
	{
		_EnergyTex("EnergyTex", 2D) = "white" {}
		_EnergyTiling("EnergyTiling", Float) = 4
		_PowerMask("PowerMask", Float) = 2
		_FresnelPower("FresnelPower", Float) = 4
		_FresnelIntensity("FresnelIntensity", Float) = 0.3
		_EnergyColor("EnergyColor", Color) = (1,0.55,0.16,0)
		_EnergyIntensity("EnergyIntensity", Float) = 1.8
		_Metallic("Metallic", Float) = 0.4
		_Smoothness("Smoothness", Float) = 0.6
		_BaseColor("BaseColor", Color) = (0.18,0.18,0.18,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _BaseColor;
		uniform sampler2D _EnergyTex;
		uniform float _EnergyTiling;
		uniform float _PowerMask;
		uniform float _FresnelPower;
		uniform float _FresnelIntensity;
		uniform float4 _EnergyColor;
		uniform float _EnergyIntensity;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _BaseColor.rgb;
			float2 temp_cast_1 = (_EnergyTiling).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_1;
			float2 panner7 = ( 1.0 * _Time.y * float2( 1.2,0 ) + uv_TexCoord5);
			float2 UVEnergy4 = panner7;
			float EnergyMask13 = pow( tex2D( _EnergyTex, UVEnergy4 ).r , _PowerMask );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode15 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV15, _FresnelPower ) );
			float Fresnel19 = ( fresnelNode15 * _FresnelIntensity );
			float4 EmissionFinal27 = ( ( ( EnergyMask13 + Fresnel19 ) * _EnergyColor ) * _EnergyIntensity );
			o.Emission = EmissionFinal27.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
0;654;1465;337;1007.738;19.20569;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-2965.204,153.801;Inherit;False;1012;391;UV Energy;5;5;6;7;8;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2915.204,301.801;Inherit;False;Property;_EnergyTiling;EnergyTiling;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2703.204,203.801;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-2628.677,372.0402;Inherit;False;Constant;_Soeed;Soeed;3;0;Create;True;0;0;0;False;0;False;1.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-2394.203,226.801;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2931.032,-280.9484;Inherit;False;1483.09;385.145;EnergyMask;7;1;2;3;10;11;12;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-2177.203,218.801;Inherit;False;UVEnergy;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;32;-3098.003,647.0874;Inherit;False;1181.577;377.7333;Fresnel;5;16;17;19;18;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2881.032,-230.9484;Inherit;True;Property;_EnergyTex;EnergyTex;0;0;Create;True;0;0;0;False;0;False;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;3;-2824.204,-16.19899;Inherit;False;4;UVEnergy;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2997.871,820.5806;Inherit;False;Property;_FresnelPower;FresnelPower;3;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2530.203,-147.199;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;10;-2177.709,-119.9491;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2654.001,922.912;Inherit;False;Property;_FresnelIntensity;FresnelIntensity;4;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;15;-2764.26,730.254;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2054.672,-11.80336;Inherit;False;Property;_PowerMask;PowerMask;2;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-1885.672,-119.8034;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2409.772,734.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1671.942,-122.7686;Inherit;False;EnergyMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-2155.772,732.452;Inherit;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1685.756,673.1769;Inherit;False;19;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-1698.191,584.2316;Inherit;False;13;EnergyMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-1522.556,745.028;Inherit;False;Property;_EnergyColor;EnergyColor;5;0;Create;True;0;0;0;False;0;False;1,0.55,0.16,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1449.708,621.0627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1265.556,751.028;Inherit;False;Property;_EnergyIntensity;EnergyIntensity;6;0;Create;True;0;0;0;False;0;False;1.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1266.556,620.028;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1052.556,621.028;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-805.5564,617.028;Inherit;False;EmissionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-306.5929,117.3955;Inherit;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-369.8206,-128.1717;Inherit;False;Property;_BaseColor;BaseColor;9;0;Create;True;0;0;0;False;0;False;0.18,0.18,0.18,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;31;-347.3618,44.42712;Inherit;False;27;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-324.7446,195.9927;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Augusto_Galban_Energy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;6;0
WireConnection;7;0;5;0
WireConnection;7;2;8;0
WireConnection;4;0;7;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;10;0;2;1
WireConnection;15;3;16;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;18;0;15;0
WireConnection;18;1;17;0
WireConnection;13;0;11;0
WireConnection;19;0;18;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;26;0;23;0
WireConnection;26;1;25;0
WireConnection;27;0;26;0
WireConnection;0;0;28;0
WireConnection;0;2;31;0
WireConnection;0;3;29;0
WireConnection;0;4;30;0
ASEEND*/
//CHKSM=ED4F1979D595518113F13053533256351F25C1C9