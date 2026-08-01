shader_type canvas_item;


void fragment() {
	// Ignore inherited COLOR, allowing parent to be modulated by
	// sampling the texture 
    COLOR = texture(TEXTURE, UV);
}
