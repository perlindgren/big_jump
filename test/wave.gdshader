shader_type canvas_item;

uniform vec4 water_color : source_color = vec4(0.0, 0.4, 0.6, 0.6);
uniform float speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_strength : hint_range(0.01, 0.2) = 0.05;
uniform sampler2D noise_texture : repeat_enable, filter_linear;

void fragment() {
    // Scroll UV coordinates over time
    vec2 uv = UV + TIME * speed * vec2(0.05, 0.02);
    
    // Sample noise to get distortion offset
    float noise = texture(noise_texture, uv).r;
    vec2 distorted_uv = UV + vec2((noise - 0.5) * wave_strength);
    
    // Output final blended color
    vec4 final_color = texture(TEXTURE, distorted_uv) * water_color;
    COLOR = final_color;
}