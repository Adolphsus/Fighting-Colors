extends MarginContainer

@onready var resume = %Resume
@onready var main_menu = %Main_menu


func _ready():
	visible = !visible
	resume.pressed.connect(_on_resume_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)

func _input(event):
	if event.is_action_pressed("Pause"):
			visible = !visible
			get_tree().paused = visible

func _on_resume_pressed():
	get_tree().paused = false
	visible = !visible


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://resources/main_menu.tscn")
	get_tree().paused = false
