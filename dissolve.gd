extends Node2D

@export var dissolve_time : float = 1.0

@onready var sprite: Sprite2D = $Sprite

func solidify_sprite() -> void:
	print("solidify sprite")
	sprite.set_instance_shader_parameter("dissolve_value", 0.0);
	
func dissolve_sprite() -> void :
	print("dissolve_sprite, dissolve_time", dissolve_time)
	# set initial dissolve value
	sprite.set_instance_shader_parameter("dissolve_value", 0.0);
	create_tween().tween_method(tween_callable, 0.0, 1.0, dissolve_time)
	
func tween_callable(value: float) -> void: 
	sprite.set_instance_shader_parameter("dissolve_value", value)
