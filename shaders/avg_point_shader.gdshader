shader_type spatial;
render_mode blend_mix;
uniform sampler2D albedo_texture : source_color; 
uniform float alpha = 0.8; 

void fragment() {
	vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = tex_color.rgb; 
	ALPHA = tex_color.a * alpha;
}