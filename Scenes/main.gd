extends Node2D
@onready var defeat_menu = $CanvasLayer/Defeat_menu
@onready var hurt = $Hurt

func defeat():
	get_tree().paused = true
	defeat_menu.visible = true

func play_hurt():
	hurt.play()

func next():
	$CanvasLayer/Next.visible = true
	$CanvasLayer/Next/Next_sound.play()
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/Next.visible = false
	await get_tree().create_timer(0.1).timeout
	$CanvasLayer/Next.visible = true
	$CanvasLayer/Next/Next_sound.play()
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/Next.visible = false
	await get_tree().create_timer(0.1).timeout
	$CanvasLayer/Next.visible = true
	$CanvasLayer/Next/Next_sound.play()
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/Next.visible = false
	await get_tree().create_timer(0.1).timeout
	$CanvasLayer/Next.visible = true
	$CanvasLayer/Next/Next_sound.play()
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/Next.visible = false

func win():
	$CanvasLayer/Win.visible = true
