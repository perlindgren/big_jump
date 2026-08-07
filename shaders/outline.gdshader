shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 10.0) = 1.0;
uniform vec2 circle_center = vec2(100, 200);

varying vec4 inherited_color;
varying vec2 world_pos;

void vertex() {
    // Capture the parent's modulate / local COLOR data in the vertex shader
    inherited_color = COLOR;
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * width;
    float alpha = texture(TEXTURE, UV + vec2(size.x, 0.0)).a 
                + texture(TEXTURE, UV + vec2(-size.x, 0.0)).a 
                + texture(TEXTURE, UV + vec2(0.0, size.y)).a 
                + texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    
    vec4 tex_color =  inherited_color * texture(TEXTURE, UV);
	vec4 col = color;
	vec2 dist = world_pos * SCREEN_PIXEL_SIZE;
	float time = mod(TIME, PI);	
	col.gb = vec2(abs(sin(time + PI * dist.x)), abs(sin(time + PI * dist.y)));
	
    vec4 final_color = mix(col, tex_color, tex_color.a);
    COLOR = vec4(final_color.rgb, clamp(alpha + tex_color.a, 0.0, 1.0));
}
