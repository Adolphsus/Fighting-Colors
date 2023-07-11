extends MarginContainer

@onready var retry = %Retry
@onready var main_menu = %Main_menu



func _ready():
	visible = !visible
	retry.pressed.connect(_on_retry_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)

func _on_retry_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://resources/main_menu.tscn") 
