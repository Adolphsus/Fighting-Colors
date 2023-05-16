extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

var health = 40


var state = 'idle'
func take_damage(player):
	state = 'hurt'
	if player == 'player1':
		health -= 25
		if health <= 0:
			playback.travel("hurt")
	elif player == 'player2':
		health -= 40
		if health <= 0:
			playback.travel("hurt")
