shader_type canvas_item;

// Uniforms editable in the Godot Inspector
uniform float source_point = 0.5; // Center of the object by default (0.0 to 1.0)
uniform float frequency = 40.0;             // How tightly packed the ripples are
uniform float speed = 4.0;                  // How fast the ripples expand outward

void fragment() {
    // 1. Calculate the distance from the current pixel (UV) to the source point
    float distance_from_source = distance(UV.x, source_point);

    // 2. Calculate spatial and time components
    // Spatial component increases as you move away from the center
    float spatial_component = distance_from_source * frequency;
    float time_component = TIME * speed;

    // 3. Compute the expanding travelling wave
    // Subtracting TIME makes the wave move OUTWARD from the source point
    // Changing to (spatial_component + time_component) would make it travel INWARD
    float wave = sin(spatial_component - time_component);

    // 4. Map the wave from [-1, 1] to [0, 1] for visual output
    float color_intensity = wave * 0.5 + 0.5;

    // Output to the screen as a grayscale effect
    COLOR = vec4(vec3(color_intensity), 1.0);
}
