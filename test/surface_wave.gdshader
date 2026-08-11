shader_type canvas_item;

// Uniforms editable in the Godot Inspector
uniform float source_point : hint_range(0.0, 1.0) = 0.5; // Center of the object by default (0.0 to 1.0)
uniform float frequency : hint_range(10.0, 100.0) = 40.0;             // How tightly packed the ripples are
uniform float speed : hint_range(0.0, 10.0) = 4.0;                  // How fast the ripples expand outward
uniform float height = 0.3;
uniform float width : hint_range(0.0, 0.5) = 0.1;
uniform float tail : hint_range(1.0, 10.0) = 1.0;
uniform float damp : hint_range(0.0, 2.0) = 1.0;
uniform float curr_time : hint_range(0.0, 2.0) = 0;

void fragment() {
    float distance_from_source = distance(UV.x, source_point);
    float spatial_component = distance_from_source * frequency;
    float time_component = curr_time * speed;

    float wave = cos(spatial_component - time_component);	
	if (UV.x < source_point) {
		float front = 1.0 - smoothstep(source_point + width - curr_time, source_point - curr_time, UV.x);
		float back = 1.0 - smoothstep(source_point - curr_time, tail * width + source_point - curr_time, UV.x);

		if (UV.y < height * (1.0 + clamp(1.0 - damp * distance_from_source, 0.0, 1.0) * wave * front * back )) {
			discard;
		}	
	} else {
		float front = 1.0 - smoothstep(source_point + curr_time - width, source_point + curr_time, UV.x);
		float back = 1.0 - smoothstep(source_point + curr_time, source_point + curr_time - tail * width, UV.x);
	
		if (UV.y < height * (1.0 + clamp(1.0 - damp * distance_from_source, 0.0, 1.0) * wave * front * back )) {
			discard;
		}	
	}      
}
