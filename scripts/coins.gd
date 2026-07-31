extends Area2D

@export var value : int = 1

@onready var coin_sprite : Sprite2D = $Sprite2D

func _on_ready() -> void:
	print("Coins: _on_ready, coin val ", value)
	#coin_sprite.material.set_shader_parameter()	
	#coin_sprite.material.set_shader_parameter("BloomThreshold", threshold)
	#coin_sprite.speed = speed

func _on_body_entered(_body: Node2D) -> void:
	print("coins: coin ", value)
	if GameState.player_active:
		Signals.coin.emit(value, self)
	
