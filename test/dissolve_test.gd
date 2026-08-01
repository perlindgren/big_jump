extends Node2D

@onready var lock = $DissolveLock
@onready var door = $DissolveDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(0)
	
	var lock_signal : Signal = lock.solidify_sprite() # continue directly, save signal
	door.solidify_sprite() # await the door to be solid
	await lock_signal
	
	lock.dissolve_sprite() # dissolve lock continue directly
	await get_tree().create_timer(2).timeout # wait for 2 seconds
	var door_signal : Signal = door.dissolve_sprite() # dissolve door, save signal

	print(" door dissolving")
	await door_signal
	print(" door dissolved")
