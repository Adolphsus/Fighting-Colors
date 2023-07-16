extends Control

@onready var Return = %Return
@onready var bar = $HSlider
@onready var index = AudioServer.get_bus_index("Master")
@onready var current_volume = AudioServer.get_bus_volume_db(index)
@onready var check_box = $MainMenu/PanelContainer/MarginContainer/VBoxContainer/Fullscreen/CheckBox

func _ready():
	bar.value = current_volume
	Return.pressed.connect(_on_Return_pressed)
	if DisplayServer.window_get_mode() == 0:
		check_box.button_pressed = false
	if DisplayServer.window_get_mode() == 3:
		check_box.button_pressed = true

func _on_Return_pressed():
	get_tree().change_scene_to_file("res://resources/main_menu.tscn")


func _on_check_box_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _physics_process(delta):
	AudioServer.set_bus_volume_db(index, bar.value)
