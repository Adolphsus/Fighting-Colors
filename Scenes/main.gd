extends Node2D
@onready var defeat_menu = $CanvasLayer/Defeat_menu

func defeat():
	get_tree().paused = true
	defeat_menu.visible = true
