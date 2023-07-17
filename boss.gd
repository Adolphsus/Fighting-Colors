extends CharacterBody2D

#Variables propias
@onready var character = $"."
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")
@onready var progress_bar = $MarginContainer/ProgressBar
@onready var sprite_2d = $Pivot/Sprite2D
@onready var still_time = $Still_time
@onready var pivot = $Pivot
@onready var hitbox = $Pivot/Hitbox
@onready var color_change = $Color_change

#Color actual
enum {RED, BLUE, NONE}
var color = NONE

#audio
@onready var stage = get_tree().get_nodes_in_group("Stages")
@onready var current_stage = stage[0]

#Drop
var food = preload("res://food.tscn")

#variables de navegación
@onready var players = get_tree().get_nodes_in_group("Players")
@onready var target1 = players[0]
@onready var target2 = players[1]
@onready var markers = get_tree().get_nodes_in_group("Markers")
@onready var target1R = markers[0]
@onready var target1L = markers[1] 
@onready var target2R = markers[2]
@onready var target2L = markers[3]
@onready var movement_speed: float = 30.0
@export var navigation_agent: NavigationAgent2D

#Niveles
@onready var levels = get_tree().get_nodes_in_group("Levels")
@onready var current_level = levels[0]


#stats
const Max_health = 1000
var health = 1000:
	set(value):
		health = value
		progress_bar.value = value
	get:
		return health
		
const damage = 250

#estados de la IA
enum { SEEK,
ATTACK,
DEATH,
IDLE,
STILL
}
var state = SEEK

func _ready():
	progress_bar.value = Max_health
	
	# PATHFINDING
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	still_time.timeout.connect(seek_player)
	hitbox.area_entered.connect(on_area_entered)
	color_change.timeout.connect(color_change_func)

func set_target(player):
	if player == "player1" and abs(target1L.global_position - self.global_position) < abs(target1R.global_position - self.global_position):
		return target1L
	elif player == "player1" and abs(target1L.global_position - self.global_position) >= abs(target1R.global_position - self.global_position):
		return target1R
	elif player == "player2" and abs(target2L.global_position - self.global_position) < abs(target2R.global_position - self.global_position):
		return target2L
	elif player == "player2" and abs(target2L.global_position - self.global_position) >= abs(target2R.global_position - self.global_position):
		return target2R
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target1.position)

#setea la posición del target al que va a llegar
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func take_damage(player, damage):
	if player == 'player1':
		if color == RED or color == NONE:
			current_stage.play_hurt()
			color = RED
			if state != ATTACK:
				state = STILL
			health = max(health - damage, 0)
			if damage == 15:
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(0.8)
				color_change.start(0.4)
			if damage == 20:
				pivot.scale.x = target1.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
				color_change.start(0.01)
			if damage == 35:
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(0.8)
				color_change.start(0.5)
			if damage == 50:
				pivot.scale.x = target1.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
				color_change.start(0.01)
		else:
			if damage == 20:
				state = STILL
				pivot.scale.x = target1.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
		
	if player == 'player2':
		if color == BLUE or color == NONE:
			current_stage.play_hurt()
			color = BLUE
			state = STILL
			health = max(health - damage, 0)
			if damage == 15:
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(0.8)
				color_change.start(0.47)
			if damage == 20:
				pivot.scale.x = target2.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
				color_change.start(0.01)
			if damage == 60:
				pivot.scale.x = target2.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
				color_change.start(0.01)
		else:
			if damage == 20:
				state = STILL
				pivot.scale.x = target2.pivot.scale.x
				tween_knockback(pivot.scale.x*5.0)
				if state != ATTACK:
					playback.travel("hurt")
				tween_hit()
				still_time.start(1.4)
	
	if health == 0:
		playback.travel("death")
		state = DEATH
		var tween = create_tween()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		still_time.stop()
		color_change.stop()

func tween_hit():
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
	
func tween_knockback(x):
	var tween = create_tween()
	tween.tween_property(character, "position", Vector2(position.x+x,position.y), 0.5).from_current()

func delete():
	await get_tree().create_timer(2.0).timeout
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
	current_level.end()
	queue_free()

func update_target(target, speed):
	movement_speed = speed
	set_movement_target(target.global_position)
	if navigation_agent.is_navigation_finished():
		if target == target1R or target == target2R:
			pivot.scale.x = 1
		elif target == target1L or target == target2L:
			pivot.scale.x = -1
		state = ATTACK
		playback.travel("attack")
		await get_tree().create_timer(0.45).timeout
		var tween = create_tween()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.1).from_current()
		tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
		still_time.start(1.5)

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()

func on_area_entered(area: Node):
	if area.get_parent().has_method("take_damage_player"):
		area.get_parent().take_damage_player(damage)

func _physics_process(delta):
	if state == DEATH:
		color = NONE
		movement_speed = 0
		delete()
	if state == STILL or state == ATTACK:
		movement_speed = 0
	if state == SEEK:
		playback.travel("walk")
		if velocity.x > 0:
			pivot.scale.x = -1
		if velocity.x < 0:
			pivot.scale.x = 1
			
		if abs(target1.global_position - global_position) <= abs(target2.global_position - global_position):
			update_target(set_target("player1"), 30.0)
		if abs(target2.global_position - global_position) < abs(target1.global_position - global_position):
			update_target(set_target("player2"), 30.0)
	if state == IDLE:
		playback.travel("idle")

func seek_player():
	state = SEEK

func color_change_func():
	var tween = create_tween()
	if color == RED:
		tween.tween_callback($Pivot/Sprite2D.set_modulate.bind(Color.BLUE))
		color = BLUE
	elif color == BLUE:
		tween.tween_callback($Pivot/Sprite2D.set_modulate.bind(Color.RED))
		color = RED
