shader_type canvas_item;

// Control the speed of the rainbow cycle
uniform float rainbow_speed : hint_range(0.0, 10.0) = 1.0;
// Control the spatial frequency (how stretched out the rainbow is)
uniform float rainbow_frequency : hint_range(0.1, 10.0) = 1.0;

// Helper function to convert HSV values to RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    // Read the texture color of the tile
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Create a scrolling factor based on global time and the tile coordinates
    // Using UV waves the rainbow across individual tiles. 
    // For a global world-space wave, you can swap UV with local/world positions.
    float hue = (UV.x + UV.y) * rainbow_frequency + (TIME * rainbow_speed);
    hue = mod(hue, 1.0); // Wrap between 0.0 and 1.0

    // Generate rainbow color (Hue, Saturation, Value)
    vec3 rainbow = hsv2rgb(vec3(hue, 0.8, 1.0));
    
    // Tint the original visible texture pixels with the rainbow color
    COLOR.rgb = tex_color.rgb * rainbow;
    COLOR.a = tex_color.a; // Maintain transparency
}
