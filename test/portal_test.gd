extends Node2D

@onready var portal : Portal = $Portal
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.DARK_SLATE_GRAY)
	await get_tree().create_timer(2.0).timeout
	print("dissolve")
	portal.set_state(Portal.State.UNLOCKED)
	portal.set_active(true)
	
	await get_tree().create_timer(2.0).timeout
	portal.set_active(false)
	
	await get_tree().create_timer(2.0).timeout
	portal.set_state(Portal.State.LOCKED)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
