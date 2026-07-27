extends Area2D

@export var KeyNr : int = 1
@export var speed : float = 1

signal key

func _ready() -> void:
	print("key ready")
	
func _on_body_entered(_body: Node2D) -> void:
	print("key ", KeyNr)
	key.emit()
	queue_free()
