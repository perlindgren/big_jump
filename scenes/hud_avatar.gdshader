shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.4;
 
void fragment() {
    float dist = distance(UV, vec2(0.5)); 
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (dist > radius) {
        discard; 
    } else {
        COLOR = tex_color;
    }
}
