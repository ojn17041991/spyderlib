shader_type canvas_item;
render_mode unshaded;

uniform bool enabled = false;

// Fragment runs against every pixel that the shader code handles.
void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (enabled) {
		float r_coeff = 0.2126;
		float g_coeff = 0.7152;
		float b_coeff = 0.7222;
		
		// Basic method of grayscaling:
		//float average_colour = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		
		// More accurate method of grayscaling:
		float average_colour = (
				COLOR.r * r_coeff +
				COLOR.g * g_coeff + 
				COLOR.b * b_coeff
			) / 3.0;
		COLOR.rgb = vec3(average_colour);
	}
}