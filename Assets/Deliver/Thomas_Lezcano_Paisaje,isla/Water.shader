// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_Bias("Bias", Range( 0 , 5)) = 0
		_Exp("Exp", Range( 0 , 1)) = 1
		_Scale("Scale", Range( 0 , 0.6)) = 0.4
		_WaterTexture("Water Texture", 2D) = "white" {}
		_Flowmap("Flow map", 2D) = "white" {}
		_Pannerspeed("Panner speed", Range( 0 , 0.6)) = 0
		_DistortionWeight("Distortion Weight", Range( 0 , 4)) = 0.5
		_TexUV("Tex UV", Vector) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_DeptColor("Dept Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _WaterTexture;
			uniform float _Pannerspeed;
			uniform float2 _TexUV;
			uniform sampler2D _Flowmap;
			uniform float4 _Flowmap_ST;
			uniform float _DistortionWeight;
			uniform float4 _Color1;
			uniform float4 _DeptColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Bias;
			uniform float _Scale;
			uniform float _Exp;
					float2 voronoihash61( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi61( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash61( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord36 = i.ase_texcoord1.xy * _TexUV + float2( 0,0 );
				float2 uv_Flowmap = i.ase_texcoord1.xy * _Flowmap_ST.xy + _Flowmap_ST.zw;
				float4 tex2DNode41 = tex2D( _Flowmap, uv_Flowmap );
				float2 appendResult38 = (float2(tex2DNode41.r , tex2DNode41.g));
				float2 lerpResult35 = lerp( texCoord36 , ( appendResult38 + texCoord36 ) , _DistortionWeight);
				float2 panner34 = ( 1.0 * _Time.y * ( float2( 1,1 ) * _Pannerspeed ) + lerpResult35);
				float mulTime63 = _Time.y * 2.0;
				float time61 = mulTime63;
				float2 coords61 = i.ase_texcoord1.xy * 170.0;
				float2 id61 = 0;
				float2 uv61 = 0;
				float voroi61 = voronoi61( coords61, time61, id61, uv61, 0 );
				float smoothstepResult80 = smoothstep( 0.0 , 1.0 , voroi61);
				float4 lerpResult76 = lerp( tex2D( _WaterTexture, panner34 ) , _Color1 , saturate( smoothstepResult80 ));
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth4 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth4 = abs( ( screenDepth4 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 10.0 ) );
				float4 lerpResult91 = lerp( _DeptColor , float4( 0,0,0,0 ) , saturate( ( 1.0 - pow( ( ( distanceDepth4 + _Bias ) * _Scale ) , _Exp ) ) ));
				
				
				finalColor = ( lerpResult76 + lerpResult91 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;654;1464;337;473.1753;349.5147;2.599302;True;False
Node;AmplifyShaderEditor.CommentaryNode;99;4.043823,-883.3489;Inherit;False;1797.931;680.2935;Texture panner;13;45;43;44;42;49;36;35;34;41;38;37;33;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;95;-140.6373,469.8297;Inherit;False;1417.631;466.1521;Depth fade;9;17;11;9;10;7;8;5;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;49;122.2548,-558.975;Inherit;False;Property;_TexUV;Tex UV;7;0;Create;True;0;0;0;False;0;False;0,0;60,60;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DepthFade;4;-68.67669,534.2148;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;36.38917,-835.8064;Inherit;True;Property;_Flowmap;Flow map;4;0;Create;True;0;0;0;False;0;False;-1;None;937a03d553d046247b6248917b286e18;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;97;480.8942,-65.99729;Inherit;False;1148.332;343.3327;External Wave noise;6;77;63;61;80;85;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-98.81406,652.6099;Inherit;False;Property;_Bias;Bias;0;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;513.6934,8.797583;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-98.14606,734.5747;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;0.4;0.6;0;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;275.3679,534.2574;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;339.5405,-578.6229;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;15,15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;480.192,-808.7587;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;826.8003,-761.5465;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;624.2042,-285.6456;Inherit;False;Property;_Pannerspeed;Panner speed;5;0;Create;True;0;0;0;False;0;False;0;0.089;0;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;610.4426,-500.8394;Inherit;False;Property;_DistortionWeight;Distortion Weight;6;0;Create;True;0;0;0;False;0;False;0.5;5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;43;741.8643,-412.7206;Inherit;False;Constant;_PannerDir;Panner Dir;10;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;61;686.4241,-13.9789;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;170;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;530.137,535.6511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-98.06305,830.775;Inherit;False;Property;_Exp;Exp;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;9;741.392,536.9284;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;996.2374,-578.3281;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;1012.725,-429.2909;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;80;892.3966,-15.4106;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;34;1195.344,-577.9319;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;11;925.7764,537.6508;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;1291.458,303.7021;Inherit;False;536.115;330.0707;Depth fade Color;2;92;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;85;1137.621,-14.51308;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;1144.488,-813.7905;Inherit;True;Property;_WaterTexture;Water Texture;3;0;Create;True;0;0;0;False;0;False;None;6b0f37006043e82419e10dda2978e574;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;17;1112.797,539.2717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;98;1398.242,205.2623;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;92;1356.871,353.3524;Inherit;False;Property;_DeptColor;Dept Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1264685,0.1275068,0.1320755,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;1406.27,-4.19706;Inherit;False;Property;_Color1;Color 1;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.004494493,0.5609563,0.9528302,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;1484.963,-601.7572;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;76;1887.897,122.4797;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;91;1643.994,492.1494;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;2081.769,271.3155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2320.58,273.3148;Float;False;True;-1;2;ASEMaterialInspector;100;1;Water;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;36;0;49;0
WireConnection;38;0;41;1
WireConnection;38;1;41;2
WireConnection;37;0;38;0
WireConnection;37;1;36;0
WireConnection;61;1;63;0
WireConnection;7;0;5;0
WireConnection;7;1;8;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;35;0;36;0
WireConnection;35;1;37;0
WireConnection;35;2;42;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;80;0;61;0
WireConnection;34;0;35;0
WireConnection;34;2;44;0
WireConnection;11;0;9;0
WireConnection;85;0;80;0
WireConnection;17;0;11;0
WireConnection;98;0;85;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;76;0;33;0
WireConnection;76;1;77;0
WireConnection;76;2;98;0
WireConnection;91;0;92;0
WireConnection;91;2;17;0
WireConnection;46;0;76;0
WireConnection;46;1;91;0
WireConnection;0;0;46;0
ASEEND*/
//CHKSM=CE31C9CBDD86F79F15BF240D6D90E9B843757395