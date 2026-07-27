extends Area2D

@export var coin_nr : int = 5
@export var speed : float = 1

signal Coins

func _ready() -> void:
	print("coins ready")
	
func _on_body_entered(_body: Node2D) -> void:
	print("coins ", coin_nr)
	Coins.emit()
	queue_free()
