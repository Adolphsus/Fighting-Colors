extends Node2D
@onready var defeat_menu = $CanvasLayer/Defeat_menu
@onready var hurt = $Hurt

func defeat():
	get_tree().paused = true
	defeat_menu.visible = true

func play_hurt():
	hurt.play()
