shader_type spatial;
render_mode unshaded, fog_disabled;
uniform float noise_intensity = 0.05;
uniform float scanline_intensity = 0.3;
uniform float scanline_count = 800.0;
uniform float vignette_strength = 0.5;
uniform float chromatic_aberration = 0.003;
uniform float film_grain = 0.02;
uniform bool use_color_filters = true;
uniform float rgb_offset = 0.003;
uniform float static_time : hint_range(0, 10) = 1.0;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}


float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}


void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 color = texture(screen_texture, uv).rgb;
	color += (random(uv * TIME) - 0.5) * noise_intensity;
	float scanline = abs(sin(uv.y * scanline_count + TIME * 0.5)) * scanline_intensity;
    color *= 1.0 - scanline * 0.5;
	vec2 uv_center = uv - 0.5;
    float vignette = 1.0 - dot(uv_center, uv_center) * vignette_strength;
    color *= vignette;
	vec2 aberration_offset = uv_center * chromatic_aberration;
    color.r = texture(screen_texture, uv - aberration_offset).r;
    color.b = texture(screen_texture, uv + aberration_offset).b;
	 if (use_color_filters) {
        color.r = texture(screen_texture, uv + vec2(rgb_offset, 0.0)).r * 1.1;
        color.g = texture(screen_texture, uv).g;
        color.b = texture(screen_texture, uv - vec2(rgb_offset, 0.0)).b * 0.9;
    }
	color += (random(uv + TIME) - 0.5) * film_grain;
	ALBEDO = color;
}