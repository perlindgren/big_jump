
@tool
extends ColorRect

@export var trigger_action: bool = false:
	set(val):
		trigger_shader_action()

func trigger_shader_action() -> void:
	var mat := material as ShaderMaterial
	if mat:
		# Pass a unique value or timestamp to force a change
		var time = Time.get_ticks_msec() / 1000.0
		mat.set_shader_parameter("impact_time", Time.get_ticks_msec() / 1000.0)
		print("set impact_time ", time)
		#var tree = get_tree()
		#if tree:
			#await get_tree().create_timer(0.2).timeout
			#print("set trig false")
			#mat.set_shader_parameter("trig", false)
		
