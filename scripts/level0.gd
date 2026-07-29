extends Node2D

@onready var flags = [
	$Flags/SpawnFlag,
	$Flags/Flag2,
	$Flags/Flag3,
	$Flags/Flag4,
] 

@onready var portal_exit : Portal = $Portals/Exit
# @onready var portal_secret : Portal = $Portals/Secret

# Level specific logic
func _ready() -> void: 
	Signals.key.connect(_on_key)
	Signals.portal.connect(_on_portal)

func _on_key(key_nr: int) -> void:
	print("level0:", key_nr)
	# key 1 should unlock exit portal
	if key_nr == 1:
		print("unlock exit portal")
		portal_exit.set_state(Portal.State.UNLOCKED)

func _on_portal(portal_id: int) -> void:
	print("level0: _on_portal ", portal_id)
	if portal_id == portal_exit.portal_id and portal_exit.state == Portal.State.UNLOCKED:
		Signals.next_level.emit(0)
