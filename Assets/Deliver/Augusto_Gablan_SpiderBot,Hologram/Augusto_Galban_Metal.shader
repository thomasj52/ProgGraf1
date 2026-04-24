// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Augusto_Galban_Metal"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0.59,0.59,0.59,0)
		_AlbedoBase("AlbedoBase", 2D) = "white" {}
		_AlbedoTiling("AlbedoTiling", Float) = 1
		_NoiseScale("NoiseScale", Float) = 2
		_NoiseStrength("NoiseStrength", Float) = 0.05
		_DarkTint("DarkTint", Color) = (0.45,0.45,0.45,0)
		_DetailMask("DetailMask", 2D) = "white" {}
		_DetailTiling("DetailTiling", Float) = 4
		_DetailStrength("DetailStrength", Float) = 0.15
		_NormalMap("NormalMap", 2D) = "white" {}
		_NormalStrength("NormalStrength", Float) = 1
		_AOMap("AOMap", 2D) = "white" {}
		_EdgePower("EdgePower", Float) = 3
		_EdgeSharpness("EdgeSharpness", Float) = 2.5
		_EdgeColor("EdgeColor", Color) = (1,0.47,0.31,0)
		_TimeSpeed("TimeSpeed", Float) = 1
		_FlickerSpeed("FlickerSpeed", Float) = 8
		_FlickerStrength("FlickerStrength", Float) = 0.2
		_EmissionNoiseScale("EmissionNoiseScale", Float) = 6
		_EmissionThreshold("EmissionThreshold", Float) = 0.65
		_EmissionColor("EmissionColor", Color) = (1,0.47,0.09,0)
		_EmissionStrength("EmissionStrength", Float) = 0.02
		_Metallic("Metallic", Float) = 0.7
		_Smoothness("Smoothness", Float) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalStrength;
		uniform float4 _BaseColor;
		uniform sampler2D _AlbedoBase;
		uniform float _AlbedoTiling;
		uniform float4 _DarkTint;
		uniform float _NoiseScale;
		uniform float _NoiseStrength;
		uniform sampler2D _DetailMask;
		uniform float _DetailTiling;
		uniform float _DetailStrength;
		uniform float _EdgePower;
		uniform float _EdgeSharpness;
		uniform float4 _EdgeColor;
		uniform float _EmissionNoiseScale;
		uniform float _EmissionThreshold;
		uniform float _EmissionStrength;
		uniform float4 _EmissionColor;
		uniform float _TimeSpeed;
		uniform float _FlickerSpeed;
		uniform float _FlickerStrength;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _AOMap;
		uniform float4 _AOMap_ST;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 NormalMap39 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalStrength );
			o.Normal = NormalMap39;
			float2 temp_cast_0 = (_AlbedoTiling).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_0;
			float4 AlbedoBase7 = ( _BaseColor * tex2D( _AlbedoBase, uv_TexCoord4 ) );
			float3 ase_worldPos = i.worldPos;
			float simpleNoise13 = SimpleNoise( ( (ase_worldPos).xz * _NoiseScale ) );
			float MascaraNoise16 = ( simpleNoise13 * _NoiseStrength );
			float4 lerpResult22 = lerp( AlbedoBase7 , ( AlbedoBase7 * _DarkTint ) , MascaraNoise16);
			float4 AlbedoFinal24 = lerpResult22;
			float2 temp_cast_1 = (_DetailTiling).xx;
			float2 uv_TexCoord27 = i.uv_texcoord * temp_cast_1;
			float DetailMask33 = ( 1.0 - ( tex2D( _DetailMask, uv_TexCoord27 ).r * _DetailStrength ) );
			o.Albedo = ( AlbedoFinal24 * DetailMask33 ).rgb;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV47 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode47 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV47, _EdgePower ) );
			float4 FresnelGlow55 = ( ( pow( fresnelNode47 , _EdgeSharpness ) * _EdgeColor ) * 0.05 );
			float simpleNoise73 = SimpleNoise( ( (ase_worldPos).xz * _EmissionNoiseScale ) );
			float4 EmissionMaskFinal81 = ( ( step( simpleNoise73 , _EmissionThreshold ) * _EmissionStrength ) * _EmissionColor );
			float mulTime58 = _Time.y * _TimeSpeed;
			float Flicker65 = ( ( sin( ( mulTime58 * _FlickerSpeed ) ) * _FlickerStrength ) + 1.0 );
			float4 EmissionFinal87 = ( FresnelGlow55 + ( EmissionMaskFinal81 * Flicker65 ) );
			o.Emission = saturate( EmissionFinal87 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float2 uv_AOMap = i.uv_texcoord * _AOMap_ST.xy + _AOMap_ST.zw;
			float AmbientOclussion45 = ( tex2D( _AOMap, uv_AOMap ).r * 1.0 );
			o.Occlusion = AmbientOclussion45;
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
0;654;1464;337;5780.943;1268.216;6.301294;True;False
Node;AmplifyShaderEditor.CommentaryNode;75;-719.2478,1633.011;Inherit;False;1124.451;323.0222;Procedural Mask;7;67;68;69;72;73;71;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-2693.009,1763.131;Inherit;False;1848.142;306.979;;9;57;58;59;60;61;62;63;64;65;Parpadeo;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;67;-669.2477,1686.975;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;68;-464.8304,1683.011;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2643.009,1813.131;Inherit;False;Property;_TimeSpeed;TimeSpeed;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-426.7968,1829.033;Inherit;False;Property;_EmissionNoiseScale;EmissionNoiseScale;18;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2330.868,1946.109;Inherit;False;Property;_FlickerSpeed;FlickerSpeed;16;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-2681.439,1239.801;Inherit;False;1649.737;410.2694;;9;47;48;49;50;51;52;53;54;55;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;-2393.868,1818.11;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;8;-2433.73,-880.4367;Inherit;False;1430.388;507.0001;;7;1;2;3;4;5;6;7;Albedo Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-189.7966,1694.033;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2879.151,-222.2198;Inherit;False;1635.238;304.4287;;8;9;10;11;12;13;14;15;16;NoiseMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;80;443.8289,1645.583;Inherit;False;557;437;Emission Color Result;4;76;77;78;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2054.868,1832.11;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;43.20334,1840.033;Inherit;False;Property;_EmissionThreshold;EmissionThreshold;19;0;Create;True;0;0;0;False;0;False;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;73;-5.796628,1690.033;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2829.151,-167.08;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;48;-2631.439,1414.379;Inherit;False;Property;_EdgePower;EdgePower;12;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2383.73,-513.4362;Inherit;False;Property;_AlbedoTiling;AlbedoTiling;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;47;-2434.09,1289.801;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2468.323,-49.88757;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-2571.124,-172.2197;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2191.73,-532.4363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;34;-941.905,164.4927;Inherit;False;1781;447.848;;9;25;26;27;28;29;30;31;32;33;Detail Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1844.867,1954.109;Inherit;False;Property;_FlickerStrength;FlickerStrength;17;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2187.126,1436.069;Inherit;False;Property;_EdgeSharpness;EdgeSharpness;13;0;Create;True;0;0;0;False;0;False;2.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;71;253.2033,1695.033;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;61;-1822.867,1833.11;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2193.73,-744.4367;Inherit;True;Property;_AlbedoBase;AlbedoBase;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;77;493.8289,1867.583;Inherit;False;Property;_EmissionStrength;EmissionStrength;21;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-1913.125,1438.069;Inherit;False;Property;_EdgeColor;EdgeColor;14;0;Create;True;0;0;0;False;0;False;1,0.47,0.31,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1903.729,-633.4365;Inherit;True;Property;_AlbedoTex;AlbedoTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1573.868,1833.11;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;49;-2030.758,1291.034;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;629.829,1696.583;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-891.905,470.3412;Inherit;False;Property;_DetailTiling;DetailTiling;7;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2255.524,-166.0519;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;79;701.5291,1870.583;Inherit;False;Property;_EmissionColor;EmissionColor;20;0;Create;True;0;0;0;False;0;False;1,0.47,0.09,0;1,0.47,0.09,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-1823.729,-830.4367;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0.59,0.59,0.59,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1912.915,-33.79097;Inherit;False;Property;_NoiseStrength;NoiseStrength;4;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1317.867,1850.11;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;838.829,1695.583;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;25;-761.2963,214.4927;Inherit;True;Property;_DetailMask;DetailMask;6;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NoiseGeneratorNode;13;-2019.915,-168.791;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1622.125,1443.069;Inherit;False;Constant;_EdgeIntensity;EdgeIntensity;15;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-694.9047,453.3412;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1724.125,1309.069;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1441.342,-698.5415;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1491.125,1309.069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1227.342,-686.5415;Inherit;False;AlbedoBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;35;-939.3922,-435.2462;Inherit;False;990.4647;412;;7;23;22;18;20;19;21;24;AlbedoFinal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;98;1470.344,1672.976;Inherit;False;1253.779;280.0864;;6;87;85;84;86;82;83;Final Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1068.867,1854.11;Inherit;False;Flicker;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1705.915,-161.791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-408.9044,300.3411;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;1157.662,1696.51;Inherit;False;EmissionMaskFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1467.915,-155.791;Inherit;False;MascaraNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;1643.302,1833.249;Inherit;False;65;Flicker;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;1595.302,1755.249;Inherit;False;81;EmissionMaskFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-889.3922,-235.2462;Inherit;False;Property;_DarkTint;DarkTint;5;0;Create;True;0;0;0;False;0;False;0.45,0.45,0.45,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-53.90436,456.3412;Inherit;False;Property;_DetailStrength;DetailStrength;8;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-2684.375,827.346;Inherit;False;1255.746;308.0298;;5;42;43;45;44;41;Ambient Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-1255.7,1306.715;Inherit;False;FresnelGlow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-47.90436,334.3411;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-854.3922,-317.2461;Inherit;False;7;AlbedoBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;217.0956,340.3411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;2040.302,1722.249;Inherit;False;55;FresnelGlow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-2634.375,877.3461;Inherit;True;Property;_AOMap;AOMap;11;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1867.302,1759.249;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2752.017,245.9245;Inherit;False;1097.478;424.7317;;4;37;36;38;39;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-575.3923,-279.2461;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-605.3923,-167.2462;Inherit;False;16;MascaraNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-643.3923,-385.2462;Inherit;False;7;AlbedoBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1962.525,1019.376;Inherit;False;Constant;_AOStrength;AOStrength;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;2263.301,1737.249;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;-387.3925,-299.2461;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;-2321.338,884.1745;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;32;392.0955,343.3411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2659.539,486.6561;Inherit;False;Property;_NormalStrength;NormalStrength;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-2702.017,295.9246;Inherit;True;Property;_NormalMap;NormalMap;9;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;615.095,341.3411;Inherit;False;DetailMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-172.9275,-302.713;Inherit;False;AlbedoFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-2281.539,440.6562;Inherit;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;2478.301,1733.249;Inherit;False;EmissionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1874.124,906.2768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;1827.959,628.4542;Inherit;False;24;AlbedoFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;1881.959,855.4542;Inherit;False;87;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-1878.539,440.6562;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;1835.959,702.4542;Inherit;False;33;DetailMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1672.628,903.6759;Inherit;False;AmbientOclussion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;2082.247,1011.827;Inherit;False;Property;_Smoothness;Smoothness;23;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;2028.347,1093.893;Inherit;False;45;AmbientOclussion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;92;2106.959,860.4542;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;89;2100.959,934.4541;Inherit;False;Property;_Metallic;Metallic;22;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;2116.959,684.4542;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;2070.959,784.4542;Inherit;False;39;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2378.039,684.2205;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Augusto_Galban_Metal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;67;0
WireConnection;58;0;57;0
WireConnection;69;0;68;0
WireConnection;69;1;72;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;73;0;69;0
WireConnection;47;3;48;0
WireConnection;10;0;9;0
WireConnection;4;0;5;0
WireConnection;71;0;73;0
WireConnection;71;1;74;0
WireConnection;61;0;59;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;49;0;47;0
WireConnection;49;1;50;0
WireConnection;76;0;71;0
WireConnection;76;1;77;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;64;0;62;0
WireConnection;78;0;76;0
WireConnection;78;1;79;0
WireConnection;13;0;11;0
WireConnection;27;0;28;0
WireConnection;51;0;49;0
WireConnection;51;1;52;0
WireConnection;6;0;1;0
WireConnection;6;1;2;0
WireConnection;53;0;51;0
WireConnection;53;1;54;0
WireConnection;7;0;6;0
WireConnection;65;0;64;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;81;0;78;0
WireConnection;16;0;14;0
WireConnection;55;0;53;0
WireConnection;29;0;26;1
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;85;0;86;0
WireConnection;85;1;84;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;22;2;23;0
WireConnection;42;0;41;0
WireConnection;32;0;30;0
WireConnection;33;0;32;0
WireConnection;24;0;22;0
WireConnection;37;0;36;0
WireConnection;37;5;38;0
WireConnection;87;0;85;0
WireConnection;43;0;42;1
WireConnection;43;1;44;0
WireConnection;39;0;37;0
WireConnection;45;0;43;0
WireConnection;92;0;94;0
WireConnection;88;0;96;0
WireConnection;88;1;95;0
WireConnection;0;0;88;0
WireConnection;0;1;93;0
WireConnection;0;2;92;0
WireConnection;0;3;89;0
WireConnection;0;4;90;0
WireConnection;0;5;97;0
ASEEND*/
//CHKSM=F63C0CCE03B469CDE72C78E642AD0C815697857F