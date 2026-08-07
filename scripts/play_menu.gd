extends Node2D

@onready var flags = [
	$Flags/SpawnFlag,
]

@onready var portal_level0: PortalFrame = $Portals/Level0
# @onready var portal_secret : Portal = $Portals/Secret

# Level specific logic
func _ready() -> void:
	Signals.portal.connect(_on_portal)

func _on_portal(portal_id: int) -> void:
	print("level0: _on_portal ", portal_id)
	
	if portal_id == portal_level0.portal_id:
		Signals.next_level.emit(1)
