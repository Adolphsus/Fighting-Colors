extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D

var health = 40



var state = 'idle'
func take_damage(player, damage):
	state = 'hurt'
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(), 0.02)
	if player == 'player1':
		health -= 25
		if health <= 0:
			playback.travel("hurt")
	elif player == 'player2':
		health -= 40
		if health <= 0:
			playback.travel("hurt")

