extends Control

@onready var music_vol: Label = $Settings/Panel/VBox/Music/Volume
@onready var fx_vol: Label = $Settings/Panel/VBox/Fx/Volume
@onready var music_vol_slider: HSlider = $Settings/Panel/VBox/Music/HSlider
@onready var fx_vol_slider: HSlider = $Settings/Panel/VBox/Fx/HSlider

@onready var panel = $Menu/Panel

@export var skew_time : float = 5.0
@export var skew_amount : float = 0.1

var unique_stylebox

func up() -> void :
	var t : Tween = create_tween().set_parallel()
	t.tween_property(unique_stylebox, "skew", Vector2(-skew_amount, -skew_amount), skew_time)
	await t.finished
	down()
	
func down() -> void:
	var t : Tween = create_tween().set_parallel()
	t.tween_property(unique_stylebox, "skew", Vector2(skew_amount, skew_amount), skew_time)
	await t.finished
	up()


func _ready() -> void:
	# to allow mouse input
	# grab_focus()
	music_vol_slider.set_value_no_signal(GameState.settings_music_volume)
	fx_vol_slider.set_value_no_signal(GameState.settings_fx_volume)
	set_music_vol()
	set_fx_vol()
	show_menu()
	unique_stylebox = panel.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	panel.add_theme_stylebox_override("panel", unique_stylebox)
	up()
	
func show_menu() -> void:
	$Menu.show()
	$Settings.hide()

func set_music_vol() -> void:
	music_vol.text = "Music Volume   %03d " % GameState.settings_music_volume

func set_fx_vol() -> void:
	fx_vol.text = "Effects Volume %03d " % GameState.settings_fx_volume
		
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	$Settings.show()
	$Menu.hide()


func _on_ok_pressed() -> void:
	show_menu()

func _on_music_vol_slider_value_changed(value: float) -> void:
	GameState.settings_music_volume = value
	set_music_vol()
	
func _on_fx_vol_slider_value_changed(value: float) -> void:
	GameState.settings_fx_volume = value
	set_fx_vol()


func _on_resume_mouse_entered() -> void:
	pass # Replace with function body.
