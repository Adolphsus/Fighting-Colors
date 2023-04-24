extends CharacterBody2D
class_name Enemy
#@onready var hurt_box = $HurtBox
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")

func take_damage():
	print('o')
	playback.travel("hurt")
