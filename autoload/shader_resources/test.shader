// Any 2D shader will be of "canvas_item" type.
shader_type canvas_item;

// These variables are available as Shader Params in the Inspector.
uniform float time_factor = 1.0;
uniform vec2 amplitude = vec2(1.0, 1.0);

// This is applied to each vertex of the object. By default this is the 4 corners, but you can apply a mesh to the object and manipulate the points of that mesh for more precise control.
void vertex() {
	VERTEX.x += cos(TIME * time_factor + VERTEX.x + VERTEX.y) * amplitude.x;
	VERTEX.y += sin(TIME * time_factor  + VERTEX.y + VERTEX. x) * amplitude.y;
} 