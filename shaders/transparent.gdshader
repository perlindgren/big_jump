shader_type canvas_item;

varying vec2 world_pos;
uniform vec2 circle_center = vec2(100, 200);
uniform float radius = 50;

void vertex() {
    // MODEL_MATRIX transforms local vertex coordinates to global/world space
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float dist = distance(world_pos, circle_center);
	vec4 pixel = texture(TEXTURE, UV);
	COLOR = pixel;
	if (dist < radius) {		
		COLOR.a = 0.5;
	} 
}