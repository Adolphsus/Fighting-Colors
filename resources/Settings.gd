extends Control

@onready var Return = %Return

func _ready():
	Return.pressed.connect(_on_Return_pressed)

func _on_Return_pressed():
	get_tree().change_scene_to_file("res://resources/main_menu.tscn")


func _on_check_box_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
