extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

@export var duration: float = 0.6

func trigger_shockwave(global_impact_position: Vector2):
	# 1. Fetch the active 2D viewport camera
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	# 2. Convert world space position to screen pixel space
	var screen_pos = global_impact_position - (camera.get_screen_center_position() - get_viewport_rect().size / 2 / camera.zoom)
	# Account for camera zoom variations
	screen_pos = (screen_pos - get_viewport_rect().size / 2) * camera.zoom + get_viewport_rect().size / 2
	
	# 3. Normalize the pixel position to a 0.0 - 1.0 vector for the shader
	var normalized_center = screen_pos / get_viewport_rect().size
	
	print("shockwave trigger ", normalized_center)
	normalized_center = Vector2(0.5, 0.5)
	
	# 4. Inject variables and animate properties smoothly via a Tween
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("center", normalized_center)
	mat.set_shader_parameter("force", 0.01)
	mat.set_shader_parameter("thickness", 0.18)
	
	var tween = create_tween().set_parallel(true)
	# Expand the shockwave outward
	tween.tween_property(mat, "shader_parameter/size", 1.0, duration).from(0.0)
	# Fade out the distortion force concurrently so it vanishes cleanly
	tween.tween_property(mat, "shader_parameter/force", 0.0, duration)
