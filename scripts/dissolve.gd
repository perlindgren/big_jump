class_name Dissolve

extends Node2D

@export var dissolve_time : float = 1.5

@onready var sprite: Sprite2D = $Sprite

func solidify_sprite() -> Signal:
	print("solidify sprite")
	# sprite.set_instance_shader_parameter("dissolve_value", 0.0);
	return create_tween().tween_method(tween_callable, 1.0, 0.0, dissolve_time).finished
	
func dissolve_sprite() -> Signal :
	print("dissolve_sprite, dissolve_time", dissolve_time)
	# sprite.set_instance_shader_parameter("dissolve_value", 0.0);
	return create_tween().tween_method(tween_callable, 0.0, 1.0, dissolve_time).finished
	
func tween_callable(value: float) -> void: 
	sprite.set_instance_shader_parameter("dissolve_value", value)
