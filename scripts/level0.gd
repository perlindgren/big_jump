extends Node2D

@onready var flags = [
	$Flags/SpawnFlag,
	$Flags/Flag2,
	$Flags/Flag3,
	$Flags/Flag4,
] 

@onready var portal1 = $Portals/Exit

# Level specific logic
func _ready() -> void: 
	Signals.key.connect(_on_key)
	
func _on_key(key_nr: int) -> void:
	print("level0:", key_nr)
	
