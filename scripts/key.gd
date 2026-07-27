extends Area2D

@export var key_nr : int = 1
@export var speed : float = 1

func _ready() -> void:
	print("key ready")
	
func _on_body_entered(_body: Node2D) -> void:
	print("key ", key_nr)
	Signals.key.emit(key_nr)
	queue_free()
