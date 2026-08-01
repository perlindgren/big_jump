shader_type canvas_item;

uniform sampler2D dissolve_texture : hint_default_white;
instance uniform float dissolve_value : hint_range(0.0, 1.0) = 0.0;
uniform float burn_size : hint_range(0.0, 0.2) = 0.05;
uniform vec4 burn_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);

void fragment() {
    vec4 main_tex = texture(TEXTURE, UV);
    float noise = texture(dissolve_texture, UV).r;
    
    // Check if pixel should be dissolved
    if (noise < dissolve_value) {
        discard;
    } else if (noise < dissolve_value + burn_size) {
        // Burn edge effect color
		// Notice RHS COLOR is inherited allowing parent modulation
        COLOR = burn_color * main_tex.a * COLOR;
    } else {
        COLOR = main_tex * COLOR;
    }
}