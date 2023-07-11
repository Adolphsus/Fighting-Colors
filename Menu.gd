extends Control

@onready var Return = %Return

func _ready():
	Return.pressed.connect(_on_Return_pressed)

func _on_Return_pressed():
	get_tree().change_scene_to_file("res://resources/main_menu.tscn")

