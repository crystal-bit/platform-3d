shader_type canvas_item;

uniform float time;

void vertex() {
	vec2 transformed = (1.0 - time) * VERTEX * sin(VERTEX.x * 0.01 * time) + VERTEX * (time);
 	VERTEX = transformed;
}

void fragment() {
	float r = mix(0, 1, time * 2.0);
	float g = mix(0, 1, time * 3.0);
	COLOR.rgb = vec3(r, g, time);
}
