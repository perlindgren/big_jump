extends Node

func _init() -> void:
	var status : Dictionary = Steam.steamInitEx(480, true)
	print("steam status", status)
	
	var username : String = Steam.getPersonaName()
	print(username)
	
	var steam_id : int = Steam.getSteamID()
	print(steam_id)
