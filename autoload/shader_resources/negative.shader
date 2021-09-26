shader_type canvas_item;
render_mode unshaded;

uniform bool enabled = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (enabled) {
		COLOR.r = 1.0 - COLOR.r;
		COLOR.g = 1.0 - COLOR.g;
		COLOR.b = 1.0 - COLOR.b;
	}
}