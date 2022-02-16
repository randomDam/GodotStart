shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque;
uniform vec4 albedo : hint_color = vec4(1.0);
uniform float point_scale = 10.0;
uniform sampler2D point_texture;
uniform float alpha = 1.0;

uniform bool use_alpha_scissor=true;
uniform float alpha_scissor = 0.5;

uniform vec4 emission : hint_color;
uniform float emission_power = 0.0;
uniform bool useDepthForSize=false;
uniform bool useVertexColorForEmission=false;

void vertex() {
	// sRGB
	if (!OUTPUT_IS_SRGB) {
		COLOR.rgb = mix(pow((COLOR.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), COLOR.rgb* (1.0 / 12.92), lessThan(COLOR.rgb,vec3(0.04045)));
	}
	// Point size adjustment using camera position
	
	if(useDepthForSize){
		float dist = length(CAMERA_MATRIX[3].xyz - VERTEX); //Getting distance between camera and the vertices
		float vpratio = (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y); //Get viewport size ratio
		POINT_SIZE = (point_scale*vpratio)/dist * vpratio; //Adjust point size
	}else{
		POINT_SIZE = 1.0*point_scale;
	}
	NORMAL = VERTEX - WORLD_MATRIX[3].xyz;	
}

void fragment() {
	// use vertex color as albedo
	ALBEDO = COLOR.rgb * albedo.rgb;
	//ALPHA_SCISSOR -= texture(point_texture, POINT_COORD).a-0.5;
	if(use_alpha_scissor){
		ALPHA_SCISSOR = alpha_scissor;
	}
	
	if(useVertexColorForEmission){	
		EMISSION = COLOR.rgb * emission_power;
		//EMISSION = vec3(0,COLOR.g,0) * emission_power;
	}else{
		EMISSION = emission.rgb * emission_power;
	}
	ALPHA = texture(point_texture, POINT_COORD).a*alpha;
	
	//work
	//SSS_STRENGTH = 0.8;
	
	//METALLIC = 8.0;
	
	//SPECULAR = 0.5;
	//RIM = 0.05;
	
	//DEPTH = 0.5;
}
