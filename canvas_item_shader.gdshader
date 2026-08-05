shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float alpha_multiplier : hint_range(0.0, 1.0) = 0.5;
uniform vec2 circle_center = vec2(0.5, 0.5); 
uniform float circle_radius : hint_range(0.0, 1.0) = 0.3;

uniform float aspect_ratio = 1.0;

//varying vec2 pixel_size;
//
//void vertex() {
    //// VERTEX holds the local pixel coordinates of the current vertex
    //// UV maps from 0.0 to 1.0 across the CanvasGroup's bounding box
    //pixel_size = VERTEX / UV;
//}

void fragment() {
    // Sample what the CanvasGroup has rendered underneath
    vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
    
    // Fix premultiplied alpha from the internal buffer
    //if (c.a > 0.0001) {
        //c.rgb /= c.a;
    //}
	//float aspect_ratio = pixel_size.x / pixel_size.y;
	//vec2 square_uv = UV;
	//square_uv *= aspect_ratio;
	//
	float dist = distance(UV * vec2(aspect_ratio, 1.0), circle_center);
    
    // 2. Check if the pixel is inside the radius
    if (dist < circle_radius) {
	    // Modify the per-pixel alpha here
    	c.a *= alpha_multiplier;
	}
    
    // Reapply premultiplied alpha for correct blending if needed, or output directly
    COLOR = c;
}
