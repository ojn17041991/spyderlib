shader_type canvas_item;

uniform float time_factor = 1.0;
uniform vec2 amplitude = vec2(1.0, 1.0);

void vertex() {
	if (VERTEX.y > 0.0 && VERTEX.y < 1280000.0) {
		VERTEX.y += cos(TIME) * 5.0;
	}
}