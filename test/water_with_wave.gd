extends Node2D

@onready var water_rect = $WaterRect;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		var time = Time.get_ticks_msec() / 1000.0
		
		print("set impact_time ", time)
		water_rect.material.set_shader_parameter("impact_time", Time.get_ticks_msec() / 1000.0)
		await get_tree().create_timer(1.0).timeout
		print("wait over")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
