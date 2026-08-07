class_name PortalFrame

extends Node2D

@export var portal_id : int = 0


func _on_portal_area_2d_body_entered(_body: Node2D) -> void:
	print("portal frame: id", portal_id)
	Signals.portal.emit(portal_id)
