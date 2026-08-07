shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 10.0) = 1.0;

varying vec4 inherited_color;

void vertex() {
    // Capture the parent's modulate / local COLOR data in the vertex shader
    inherited_color = COLOR;
}

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * width;
    float alpha = texture(TEXTURE, UV + vec2(size.x, 0.0)).a 
                + texture(TEXTURE, UV + vec2(-size.x, 0.0)).a 
                + texture(TEXTURE, UV + vec2(0.0, size.y)).a 
                + texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    
    vec4 tex_color =  inherited_color * texture(TEXTURE, UV);
	vec4 col = color;
	col.g *= abs(sin(TIME*2.0));
	col.b *= abs(sin(TIME*9.0));
	//col.g = cos(TIME*9.0);
	//col.b = sin(TIME*9.0+PI);
	
    vec4 final_color = mix(col, tex_color, tex_color.a);
    COLOR = vec4(final_color.rgb, clamp(alpha + tex_color.a, 0.0, 1.0));
}
