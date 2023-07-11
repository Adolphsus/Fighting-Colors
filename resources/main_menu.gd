extends MarginContainer
@onready var play = %Play
@onready var settings = %Settings
@onready var credits = %Credits
@onready var exit = %Exit

func _ready():
	get_tree().paused = false
	play.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://resources/Settings.tscn")
	
func _on_credits_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()
