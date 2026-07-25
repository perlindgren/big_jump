shader_type canvas_item;

// Screen texture registration for Godot 4+
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap, repeat_disable;

// Shockwave parameters managed via code/AnimationPlayer
uniform vec2 center = vec2(0.5, 0.5); // Normalized screen coordinates (0.0 to 1.0)
uniform float force = 0.05;          // Distortion strength
uniform float size = 0.0;            // Current radius of the shockwave ring
uniform float thickness = 0.1;       // Width of the shockwave ring

void fragment() {
	// Correct for aspect ratio to maintain a perfect circle
    vec2 aspect_ratio = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
    vec2 scaled_uv = SCREEN_UV * aspect_ratio;
    vec2 scaled_center = center * aspect_ratio;
    
    // Calculate distance from current pixel to center of impact
    float current_dist = distance(scaled_uv, scaled_center);
    
    // Default to normal screen pixels
    vec2 target_uv = SCREEN_UV;
    
    // Apply displacement only if the pixel is inside the expanding ring mask
    if (current_dist <= size + thickness && current_dist >= size - thickness) {
        float mask = smoothstep(size - thickness, size, current_dist) * (1.0 - smoothstep(size, size + thickness, current_dist));
        vec2 disp_direction = normalize(scaled_uv - scaled_center);
        
        // Push the UV outwards based on force and mask strength
        target_uv -= disp_direction * force * mask;
    }
    
    // Sample the background screen texture with displaced UVs
    COLOR = textureLod(screen_texture, target_uv, 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
