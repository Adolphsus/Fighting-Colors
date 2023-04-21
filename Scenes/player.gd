extends CharacterBody2D
var speed_x = 70
var speed_y = 40

## Player script

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var pivot = $Pivot
@onready var playback = animation_tree.get("parameters/playback")

func get_H():
	var input_direction_H = Input.get_axis("left2", "right2")
	if input_direction_H:
		velocity.x = input_direction_H * speed_x
	else:
		velocity.x = 0

func get_V():
	var input_direction_V = Input.get_axis("up2", "down2")
	if input_direction_V:
		velocity.y = input_direction_V * speed_y
	else:
		velocity.y = 0
func attacks():
	var input_punch = Input.is_action_pressed("punch2")
	var input_kick = Input.is_action_pressed("kick2")
	if input_punch:
		playback.travel("punch")
	elif input_kick:
		playback.travel("kick")
	else:
		if velocity.x == 0 and velocity.y == 0:
			playback.travel("idle")
		else:
			playback.travel("walk")
			
func jump():
	var input_jump= Input.is_action_just_pressed("jump")
	if input_jump:
		playback.travel("jump")
	else:
		if velocity.x == 0 and velocity.y == 0:
			playback.travel("idle")
		else:
			playback.travel("walk")
		
func animationplayer():
	var input_jump= Input.is_action_just_pressed("jump")
	if velocity.x == 0 and velocity.y == 0:
		playback.travel("idle")
	elif velocity.x != 0:
		if velocity.x > 0:
			playback.travel("walk")
			pivot.scale.x = 1
		if velocity.x < 0:
			playback.travel("walk")
			pivot.scale.x = -1
	elif velocity.y != 0:
		playback.travel("walk")
	if input_jump:
		playback.travel("jump")
	else:
		if velocity.x == 0 and velocity.y == 0:
			playback.travel("idle")
		else:
			playback.travel("walk")
		

func _physics_process(delta):
	get_H()
	get_V()
	animationplayer()
	move_and_slide()
	attacks()
	
