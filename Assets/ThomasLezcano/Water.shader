// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_Bias("Bias", Range( 0 , 5)) = 0
		_Exp("Exp", Range( 0 , 1)) = 1
		_Scale("Scale", Range( 0.2 , 0.6)) = 0.4
		_WaterTexture("Water Texture", 2D) = "white" {}
		_Flowmap("Flow map", 2D) = "white" {}
		_Pannerspeed("Panner speed", Range( 0 , 0.6)) = 0
		_DistortionWeight("Distortion Weight", Range( 0 , 4)) = 0.5
		_TexUV("Tex UV", Vector) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
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
				float distanceDepth4 = abs( ( screenDepth4 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
				
				
				finalColor = ( lerpResult76 + saturate( ( 1.0 - pow( ( ( distanceDepth4 + _Bias ) * _Scale ) , _Exp ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;669;1465;322;-75.56128;-110.6144;2.271295;True;False
Node;AmplifyShaderEditor.SamplerNode;41;-228.3407,-222.0011;Inherit;True;Property;_Flowmap;Flow map;9;0;Create;True;0;0;0;False;0;False;-1;None;937a03d553d046247b6248917b286e18;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;49;-96.86206,54.85089;Inherit;False;Property;_TexUV;Tex UV;12;0;Create;True;0;0;0;False;0;False;0,0;60,60;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;6;226.7961,652.6099;Inherit;False;Property;_Bias;Bias;0;0;Create;True;0;0;0;False;0;False;0;0.34;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;4;253.071,539.6087;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;206.4046,-204.6336;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;95.51878,35.20293;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;15,15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;227.4641,734.5747;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;0.4;0.213;0.2;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;600.9778,534.2574;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;387.2596,379.7881;Inherit;False;Property;_Pannerspeed;Panner speed;10;0;Create;True;0;0;0;False;0;False;0;0.273;0;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;1010.527,887.5142;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;340.7497,149.8027;Inherit;False;Property;_DistortionWeight;Distortion Weight;11;0;Create;True;0;0;0;False;0;False;0.5;3.05;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;470.0182,-114.0001;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;43;408.5049,250.0909;Inherit;False;Constant;_PannerDir;Panner Dir;10;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;855.7469,535.6511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;227.5471,830.775;Inherit;False;Property;_Exp;Exp;1;0;Create;True;0;0;0;False;0;False;1;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;660.998,27.74273;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;664.3765,252.8136;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;61;1193.749,863.1146;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;170;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;9;1067.002,536.9284;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;80;1375.705,860.2529;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;1143.181,-104.8766;Inherit;True;Property;_WaterTexture;Water Texture;8;0;Create;True;0;0;0;False;0;False;None;6b0f37006043e82419e10dda2978e574;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;34;911.6592,117.2644;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;11;1251.386,537.6508;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;1416.697,321.363;Inherit;False;Property;_Color1;Color 1;13;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3001513,0.6507838,0.8962264,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;85;1699.536,865.4404;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;1440.804,115.4424;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;17;1437.174,539.2717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;1890.955,266.2159;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;81;2311.826,646.8065;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;90;1274.741,-522.2578;Inherit;False;Constant;_Color2;Color 2;14;0;Create;True;0;0;0;False;0;False;0.6698113,0.3191082,0.3191082,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;27;-165.8407,-1049.858;Inherit;False;23;VoronoiAngle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;25;102.0852,-1123.02;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.DynamicAppendNode;87;1186.787,-310.1201;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;30;268.7536,-1435.358;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1180.51,-1091.603;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-974.5206,-977.6784;Inherit;False;VoronoiAngle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-165.7516,-1141.112;Inherit;False;24;TextureCoord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;21;-745.2897,-1441.436;Inherit;False;Property;_WaveColor;Wave Color;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6367924,0.9697522,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1045.92,-855.0351;Inherit;False;Property;_VoronoiScale;Voronoi Scale;4;0;Create;True;0;0;0;False;0;False;2;240;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;877.5745,-1238.562;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-955.1879,-1082.934;Inherit;False;TextureCoord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-221.5887,-957.301;Inherit;False;Property;_VoronoiWavedetailScale;Voronoi Wave detail Scale;7;0;Create;True;0;0;0;False;0;False;2;260;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;88;1386.046,-313.931;Inherit;False;Global;_GrabScreen0;Grab Screen 0;14;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-747.5851,-1691.321;Inherit;False;Property;_Watercolor;Water color;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.255518,0.3877512,0.6226415,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1544.071,-878.4301;Inherit;False;Property;_WaveSpeed;Wave Speed;5;0;Create;True;0;0;0;False;0;False;0;2.94;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1186.226,-971.0605;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-508.0181,-988.6125;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1652.423,-298.1848;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;86;913.6276,-340.4551;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-192.6166,-1437.1;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;31;-61.67632,-1676.454;Inherit;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0.1878337,0.3402378,0.6320754,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;82;2085.857,669.9606;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-733.3338,-995.4561;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;60;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;46;2081.769,271.3155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2324.58,283.3148;Float;False;True;-1;2;ASEMaterialInspector;100;1;Water;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;38;0;41;1
WireConnection;38;1;41;2
WireConnection;36;0;49;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;37;0;38;0
WireConnection;37;1;36;0
WireConnection;7;0;5;0
WireConnection;7;1;8;0
WireConnection;35;0;36;0
WireConnection;35;1;37;0
WireConnection;35;2;42;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;61;1;63;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;80;0;61;0
WireConnection;34;0;35;0
WireConnection;34;2;44;0
WireConnection;11;0;9;0
WireConnection;85;0;80;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;17;0;11;0
WireConnection;76;0;33;0
WireConnection;76;1;77;0
WireConnection;76;2;85;0
WireConnection;81;1;82;0
WireConnection;25;0;26;0
WireConnection;25;1;27;0
WireConnection;25;2;28;0
WireConnection;87;0;86;1
WireConnection;87;1;86;2
WireConnection;30;0;20;0
WireConnection;30;1;31;0
WireConnection;30;2;25;0
WireConnection;23;0;3;0
WireConnection;24;0;16;0
WireConnection;88;0;87;0
WireConnection;3;0;18;0
WireConnection;19;0;1;0
WireConnection;89;0;90;0
WireConnection;89;1;88;0
WireConnection;20;0;12;0
WireConnection;20;1;21;0
WireConnection;20;2;19;0
WireConnection;1;0;24;0
WireConnection;1;1;23;0
WireConnection;1;2;15;0
WireConnection;46;0;76;0
WireConnection;46;1;17;0
WireConnection;0;0;46;0
ASEEND*/
//CHKSM=FE3935C481D1C5AE3CAE1A0B3204E7938C4BA65E