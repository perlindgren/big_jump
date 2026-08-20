extends Node

# Global game state variables
@export var levels: Array[PackedScene] = [
	preload("res://scenes/level1.tscn"),
	preload("res://scenes/play_menu.tscn"),
	preload("res://scenes/level0.tscn"),
	preload("res://scenes/Cave.tscn"),
	preload("res://scenes/irisSceneLevel1.tscn"),
	preload("res://scenes/level3.tscn"),
]

@export var current_level: int = 5 # we start from level 0


const SAVE_FILE_NAME = "save_game.dat"

var settings_music_volume: float = 100.0
var settings_fx_volume: float = 100.0

var spawn_position: Vector2 = Vector2.ZERO
var player_direction: float = 0.0
var player_active: bool = false
var player_has_moved: bool = false
var frames: int = 0
var missed_frames: int = 0
var player_position: Vector2 = Vector2.ZERO
var player_velocity: Vector2 = Vector2.ZERO

var coins: int = 0 # ground truth
var coins_display: int = 0 # used for hud display
var flags_used: int = 0
var blood_donated: int = 0

@export var recording: Dictionary[int, int] = {}
enum mode_states {RECORD, REPLAY, GHOST, NONE}
var mode: mode_states = mode_states.RECORD

func is_mode_replay() -> bool:
	return mode == mode_states.REPLAY

func clear_recordin() -> void:
	recording = {}
	
func add_state(input: int) -> void:
	#print("add_state ", input)
	if recording.get(frames):
		#print("same frame, old ", recording[frames])
		recording[frames] |= input
		
	else:
		recording[frames] = input
	#print("recording frame ", frames, " data ", recording[frames])

func record_input(input: int, rec_input: bool) -> bool:
	match mode:
		mode_states.RECORD:
			if rec_input:
				add_state(input)
			return rec_input
			
		mode_states.REPLAY:
			if recording.get(GameState.frames):
				# print ("event ", GameState.frames, " data", recording[GameState.frames], " input", input, "mask",  recording[GameState.frames] & input)
				return recording[GameState.frames] & input
			else:
				return false
		mode_states.GHOST:
			return false
		mode_states.NONE:
			return false
	print("record_input: unreachable")
	get_tree().quit()
	return false

func _process(_delta: float) -> void :
	if Input.is_action_just_pressed(&"save"):
		print("save")
		#var cfg: ConfigFile = ConfigFile.new()
		#cfg.set_value("Save1", "pos", position)
		#cfg.save("user://saves.cfg")
		#print("saved")
		#
		#var dict: Dictionary = {"recording" : recording }
		#print("dict ", dict)
		#print("recording ", recording)
		#var rec = dict["recording"]
		#print("rec ", rec)
		#var rec2 = rec as Dictionary[int, int]
		#print("rec2 ", rec2)
		
		var out_dict = { "recording": recording }
		print("out_dict", out_dict)
		var json_native = JSON.from_native(out_dict, true)
		var json_string = JSON.stringify(json_native)
		print("json_string ", json_string)
		var json_dec_native = JSON.parse_string(json_string)
		var dict = JSON.to_native(json_dec_native, true)
		print("dict ", dict)
		
		save_dictionary_to_steam(out_dict)
		#
	if Input.is_action_just_pressed(&"load"):
		#print("load")
		#var cfg: ConfigFile = ConfigFile.new()
		#cfg.load("user://saves.cfg")
		#position = cfg.get_value("Save1", "pos")
		#print("loaded")
		var dict: Dictionary = load_dictionary_from_steam()
		print("dict", dict)
		recording = dict["recording"]
		
	
# Call this function to save data
func save_dictionary_to_steam(data_dict: Dictionary) -> void:
	# Convert your data dictionary into a PackedByteArray
	var json_native = JSON.from_native(data_dict, true)
	print("json_native ", json_native)
	var json_string = JSON.stringify(json_native)
	print("json_string ", json_string)
	var byte_array = json_string.to_utf8_buffer()
	
	# Save locally as a backup
	var local_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.WRITE)
	if local_file:
		local_file.store_buffer(byte_array)
		local_file.close()
	
	## 3. Upload to Steam Cloud
	#if Steam.isSteamRunning():
		#var file_size = byte_array.size()
		#var success = Steam.fileWrite(SAVE_FILE_NAME, byte_array, file_size)
		#
		#if success:
			#print("Game saved successfully to Steam Cloud!")
		#else:
			#print("Steam fileWrite failed.")
	#else:
		#print("Steam is not running. Saved locally only.")

# Call this function to load data
func load_dictionary_from_steam() -> Dictionary:
	var save_data: Dictionary = {}
	
	## 1. Try loading from Steam Cloud first
	#if Steam.isSteamRunning() and Steam.fileExists(SAVE_FILE_NAME):
		#var file_size = Steam.getFileSize(SAVE_FILE_NAME)
		#var steam_data = Steam.fileRead(SAVE_FILE_NAME, file_size)
		#
		#if steam_data.has("ret") and steam_data["ret"]:
			#var json_string = steam_data["buf"].get_string_from_utf8()
			#var json = JSON.new()
			#if json.parse(json_string) == OK:
				#save_data = json.get_data()
				#print("Loaded save from Steam Cloud.")
				#return save_data

	# 2. Fallback to local save if Steam is unavailable or file is missing
	if FileAccess.file_exists("user://" + SAVE_FILE_NAME):
		var local_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.READ)
		if local_file:
			var json_string = local_file.get_as_text()
			local_file.close()
			var json_native = JSON.parse_string(json_string)
			var native = JSON.to_native(json_native, true)
			return native
			#var json = JSON.new()
			#if json.parse(json_string) == OK:
				#save_data = json.get_data()
				#print("Loaded save from local storage fallback.")
				#return save_data
				
	print("No save file found.")
	return save_data
