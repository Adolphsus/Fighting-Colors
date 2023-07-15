extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D
@onready var players = get_tree().get_nodes_in_group("Players")
@onready var target1 = players[0]
@onready var target2 = players[1]
var food = preload("res://food.tscn")
var health = 40


func take_damage(player, damage):
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(randf_range(-10,10),randf_range(-3, 3)), 0.02)
	tween.tween_property(sprite_2d, "position", Vector2(), 0.02)
	if player == 'player1':
		if damage == 50:
			playback.travel("hurt")
			$Sprite2D.scale.x = target1.pivot.scale.x
			delete($Sprite2D.scale.x*10)
	elif player == 'player2':
		if damage == 60:
			playback.travel("hurt")
			$Sprite2D.scale.x = target2.pivot.scale.x
			delete($Sprite2D.scale.x*10)

func spawn():
	var node = food.instantiate()
	node.position = global_position
	get_parent().add_child(node)


func delete(x):
	var tween = create_tween()
	tween.tween_property($".", "position", Vector2(position.x + x, position.y-2), 0.1).from_current()
	tween.tween_property($".", "position", Vector2(position.x + x, position.y+2), 0.1).from_current()
	await get_tree().create_timer(0.3).timeout
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	await get_tree().create_timer(0.1).timeout
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	await get_tree().create_timer(0.1).timeout
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	await get_tree().create_timer(0.1).timeout
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	await get_tree().create_timer(0.1).timeout
	spawn()
	queue_free()

