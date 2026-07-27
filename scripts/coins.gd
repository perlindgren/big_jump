extends Area2D

@export var value : int = 5

@onready var coin_sprite = $CoinsSprite2D

func _on_ready() -> void:
	print("_on_ready, coin val ", value)
	#coin_sprite.material.set_shader_parameter()	
	#coin_sprite.material.set_shader_parameter("BloomThreshold", threshold)
	#coin_sprite.speed = speed

func _on_body_entered(_body: Node2D) -> void:
	print("coins ", value)
	Signals.coin.emit(value)
	queue_free()
