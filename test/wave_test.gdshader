shader_type canvas_item;

uniform float surface_level : hint_range(0.0, 1.0) = 0.1;
uniform float impact_x : hint_range(0.0, 1.0) = 0.3;
// uniform float trig_time = 0.0;
uniform float curr_time : hint_range(0.0, 2.0) = 0.0;
uniform float width : hint_range(0.0, 0.5) = 0.1;
uniform float wave_time : hint_range(0.0, 4.0) = 2.0;

// Called for every vertex the material is visible on.
void vertex() {
}

// The idea is to emit two sinusidual waves at impact_x 
// in left and right directions

// Called for every pixel the material is visible on.
void fragment() {
	float dist = UV.x - (impact_x + curr_time);
	
	// Rightward wave
	if (UV.x > impact_x) {
		float surface = clamp(1.0 - curr_time/wave_time, 0.0, 1.0) * sin(TAU * ((UV.x - curr_time) - impact_x)/width) ;
		float surface_scale = 1.0 - (smoothstep(impact_x + curr_time - width, impact_x + curr_time, UV.x));
		surface_scale *= smoothstep(impact_x, impact_x + curr_time, UV.x);
		if (UV.y < surface_level + clamp(1.0 - curr_time/wave_time, 0.0, 1.0) * surface_scale * surface * surface_level) {
			discard;
		}
	} else {
		float surface2 = clamp(1.0 - curr_time/wave_time, 0.0, 1.0) * sin(-TAU * ((UV.x + curr_time) - impact_x)/width) ;
		float surface_scale2 = smoothstep(impact_x - curr_time, width + impact_x - curr_time, UV.x); 
		surface_scale2 *= 1.0 - smoothstep(impact_x - curr_time, impact_x, UV.x);
	
		if (UV.x < impact_x && (UV.y < surface_level + (clamp(1.0 - curr_time/wave_time, 0.0, 1.0) * surface_scale2 * surface2) * surface_level)) {
			discard;
		}
	}
	
	//// left size of impact
	//if (distance(UV.x, impact_x + curr_time - width) < 0.01) {
		//COLOR = vec4(0,0,1,1);
	//}
	//
	//// right size of impact
	//if (distance(UV.x, impact_x + curr_time + width) < 0.01) {
		//COLOR = vec4(0,0,1,1);
	//}
	//
	//// left size of impact
	//if (distance(UV.x, impact_x - curr_time - width) < 0.01) {
		//COLOR = vec4(1,1,0,1);
	//}
	//
	//// right size of impact
	//if (distance(UV.x, impact_x - curr_time + width) < 0.01) {
		//COLOR = vec4(0.5,0.5,0,1);
	//}
	//
	//
	//if (distance(UV.x, impact_x) < 0.01) {
		//COLOR = vec4(1,1,1,1);
	//}
	//
	//// center
	//if (distance(UV.x, impact_x + curr_time) < 0.01) {
		//COLOR = vec4(1,0,1,1);
	//}
	//
	//float dist_right = distance(UV.x, impact_x - curr_time);
	//float dist_left = distance(UV.x, impact_x - curr_time);
	//
	//if (distance(UV.x, impact_x - curr_time) < 0.01) {
		//COLOR = vec4(0,1,1,1);
	//}
	//
	//if (distance(UV.x, curr_time) < 0.01) {
		//COLOR = vec4(1,0,0,1);
	//}
	
	// COLOR = COLOR;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
