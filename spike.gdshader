shader_type canvas_item;

uniform float speed = 5.0;
uniform float height = 2.0;
uniform float frequency = 0.05;

void vertex() {
    // Displace vertex Y based on its X position and time
	if (UV.x == 0.0 && UV.y == 0.0) {
    	VERTEX.x += sin(VERTEX.x * frequency + TIME * speed) * height;
	}
}

//void fragment() {
	//// Called for every pixel the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
