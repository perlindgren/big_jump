shader_type canvas_item;

uniform float surface_level : hint_range(0.0, 1.0) = 0.1;

// Called for every vertex the material is visible on.
void vertex() {
}


// Called for every pixel the material is visible on.
void fragment() {
	float dist = sin(UV.x * PI);
	float surface = surface_level * dist * (0.5 - 0.5 * sin(TIME + UV.x * TAU)); // surface_level * (1.0 - distance(UV.x, 0.5)); //  * (1.0 - sin(TIME + UV.x));
	if (UV.y < surface) {
		discard;
	}
	
	// COLOR = COLOR;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
