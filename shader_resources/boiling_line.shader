shader_type canvas_item;

uniform bool enabled = true;
uniform sampler2D noise_texture;
uniform float distortion_strength: hint_range(0, 0.1) = 1.0;
uniform float speed: hint_range(0.1, 10) = 1.0;

void fragment() {
	vec2 uv_offset = vec2(0.0, 0.0);
	if (enabled) {
		vec4 noise_pixel = texture(noise_texture, UV + floor(TIME * speed) / 3.0);
		uv_offset = (noise_pixel.rg * 2.0 - 1.0) * distortion_strength;
	}
	COLOR = texture(TEXTURE, UV + uv_offset);
}