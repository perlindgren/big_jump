extends Node2D

@onready var lock = $DissolveLock
@onready var door = $DissolveDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(0)
	lock.dissolve_sprite()
	await get_tree().create_timer(2).timeout
	door.dissolve_sprite()
	pass
