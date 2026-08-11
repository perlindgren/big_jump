shader_type canvas_item;

uniform float surface = 0.2;
uniform float impact_x = 0.7;
uniform float impact_time = 0.0; // time of current impact in seconds 

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float x = impact_x ; + (TIME-impact_time);
	
	if (UV.x > x - 0.01 && UV.x < x + 0.01) {
		COLOR.rgb = vec3(1,1,1);
	}
}
