extends ColorRect

func _ready() -> void:
	print("wave_control ready")

var curr_time : float = 0.0

func _process(_delta) -> void:
	curr_time += 0.01
	material.set_shader_parameter("curr_time", curr_time);
	if curr_time > 2:
		curr_time = 0.0;
	
