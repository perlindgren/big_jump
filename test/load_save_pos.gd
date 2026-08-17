extends Sprite2D

const SAVE_FILE_NAME = "save_game.dat"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void :
	if Input.is_action_pressed(&"left"):
		position.x -= 1
	if Input.is_action_pressed(&"right"):
		position.x += 1
		
	if Input.is_action_just_pressed(&"save"):
		print("save")
		var cfg: ConfigFile = ConfigFile.new()
		cfg.set_value("Save1", "pos", position)
		cfg.save("user://saves.cfg")
		print("saved")
		
		var dict: Dictionary = {"pos" : position }
		save_game_to_steam(dict)
		
		
		
		
	if Input.is_action_just_pressed(&"load"):
		print("load")
		var cfg: ConfigFile = ConfigFile.new()
		cfg.load("user://saves.cfg")
		position = cfg.get_value("Save1", "pos")
		print("loaded")
		var dict: Dictionary = load_game_from_steam()
		print("dict", dict)
	
# Call this function to save data
func save_game_to_steam(data_dict: Dictionary) -> void:
	# 1. Convert your data dictionary into a PackedByteArray
	var json_string = JSON.stringify(data_dict)
	var byte_array = json_string.to_utf8_buffer()
	
	# 2. Save locally as a backup
	var local_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.WRITE)
	if local_file:
		local_file.store_buffer(byte_array)
		local_file.close()
	
	# 3. Upload to Steam Cloud
	if Steam.isSteamRunning():
		var file_size = byte_array.size()
		var success = Steam.fileWrite(SAVE_FILE_NAME, byte_array, file_size)
		
		if success:
			print("Game saved successfully to Steam Cloud!")
		else:
			print("Steam fileWrite failed.")
	else:
		print("Steam is not running. Saved locally only.")

# Call this function to load data
func load_game_from_steam() -> Dictionary:
	var save_data: Dictionary = {}
	
	# 1. Try loading from Steam Cloud first
	if Steam.isSteamRunning() and Steam.fileExists(SAVE_FILE_NAME):
		var file_size = Steam.getFileSize(SAVE_FILE_NAME)
		var steam_data = Steam.fileRead(SAVE_FILE_NAME, file_size)
		
		if steam_data.has("ret") and steam_data["ret"]:
			var json_string = steam_data["buf"].get_string_from_utf8()
			var json = JSON.new()
			if json.parse(json_string) == OK:
				save_data = json.get_data()
				print("Loaded save from Steam Cloud.")
				return save_data

	# 2. Fallback to local save if Steam is unavailable or file is missing
	if FileAccess.file_exists("user://" + SAVE_FILE_NAME):
		var local_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.READ)
		if local_file:
			var json_string = local_file.get_as_text()
			local_file.close()
			
			var json = JSON.new()
			if json.parse(json_string) == OK:
				save_data = json.get_data()
				print("Loaded save from local storage fallback.")
				return save_data
				
	print("No save file found.")
	return save_data
