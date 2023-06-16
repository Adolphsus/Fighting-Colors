extends CharacterBody2D

#@onready var hurt_box = $HurtBox
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")
@onready var progress_bar = $MarginContainer/ProgressBar
@onready var sprite_2d = $Pivot/Sprite2D
@onready var hit_stun = $Hit_stun
@onready var pivot = $Pivot

#Color actual
enum {RED, BLUE, NONE}
var color = NONE

#variables de navegación
@onready var players = get_tree().get_nodes_in_group("Players")
@onready var target1 = players[0]
@onready var target2 = players[1]
@onready var markers = get_tree().get_nodes_in_group("Markers")
@onready var target1R = markers[0]
@onready var target1L = markers[1] 
@onready var target2R = markers[2]
@onready var target2L = markers[3]
@onready var movement_speed: float = 40.0
@export var navigation_agent: NavigationAgent2D

# Audio
@onready var audio_stream_player_hurt = $hurt
@onready var audio_stream_player_grunt = $grunt

#vida y barra de vida
const Max_health = 200
var health = 200:
	set(value):
		health = value
		progress_bar.value = value
	get:
		return health

#estados de la IA
enum { SEEK,
ATTACK,
DEATH,
IDLE,
HURT
}
var state = IDLE

func _ready():
	progress_bar.value = Max_health
	
	# PATHFINDING
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.5
	navigation_agent.target_desired_distance = 1.5
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	hit_stun.timeout.connect(seek_player)

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

func take_damage(player):
	var tween = create_tween()
	print(markers)
	if player == 'player1':
		if color ==RED or color == NONE:
			state = HURT
			health = max(health - 25, 0)
			audio_stream_player_hurt.play()
			playback.travel("hurt")
			tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
			tween.tween_callback($Pivot/Sprite2D.set_modulate.bind(Color.BLUE)).set_delay(0.5)
			color = BLUE
	if player == 'player2':
		if color == BLUE or color == NONE:
			state = HURT
			health = max(health - 25, 0)
			audio_stream_player_hurt.play()
			playback.travel("hurt")
			tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
			tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
			tween.tween_callback($Pivot/Sprite2D.set_modulate.bind(Color.RED)).set_delay(0.5)
			color = RED
	if health == 0:
		audio_stream_player_grunt.play()
		playback.travel("knockdown")
		state = DEATH
		hit_stun.stop()
	else:
		hit_stun.start(0.9)

func update_target(target, speed):
	movement_speed = speed
	set_movement_target(target.global_position)
	if navigation_agent.is_navigation_finished():
		state = IDLE

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()

func _physics_process(delta):
	if state == DEATH:
		color = NONE
		movement_speed = 0
		await get_tree().create_timer(2.0).timeout
		queue_free()
	if state == HURT:
		movement_speed = 0
	if state == SEEK:
		playback.travel("walk")
		if velocity.x > 0:
			pivot.scale.x = -1
		if velocity.x < 0:
			pivot.scale.x = 1 
		if color == RED:
			update_target(set_target("player1"), 40.0)
		if color == BLUE:
			var a = set_target("player2")
			update_target(set_target("player2"), 40.0)
	if state == IDLE:
		playback.travel("idle")
		

func seek_player():
	state = SEEK
