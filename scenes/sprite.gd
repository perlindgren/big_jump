extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("BloomIntensity", 0.0)
	#material.set_shader_parameter("BloomThreshold", 0.5)
	#material.set_shader_parameter("BloomRadious", 2.0)
	up()
	
func up() -> void :
	print("up", material)
	var t : Tween = create_tween().set_parallel()
	t.tween_property(material, "shader_parameter/BloomIntensity", 5.0, 1.0)
	await t.finished
	down()
	
func down() -> void:
	print("down", material)
	var t : Tween = create_tween().set_parallel()
	t.tween_property(material, "shader_parameter/BloomIntensity", 0.0, 1.0)
	await t.finished
	up()
