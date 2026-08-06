extends Sprite2D

@export var speed : float = 1.0
@export var intensity : float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("BloomIntensity", 0.0)
	up()
	
func up() -> void :
	var t : Tween = create_tween()
	t.tween_property(material, "shader_parameter/BloomIntensity", intensity, speed)
	await t.finished
	down()
	
func down() -> void:
	var t : Tween = create_tween()
	t.tween_property(material, "shader_parameter/BloomIntensity", intensity, speed)
	await t.finished
	up()
