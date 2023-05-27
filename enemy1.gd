extends CharacterBody2D

#@onready var hurt_box = $HurtBox
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")
@onready var progress_bar = $MarginContainer/ProgressBar
@onready var sprite_2d = $Sprite2D
@onready var hit_stun = $Hit_stun

#Color actual
enum {RED, BLUE, NONE}
var color = NONE

#variables de navegación
var movement_speed: float = 40.0
@export var target1: CharacterBody2D
@export var target2: CharacterBody2D
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
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 30.0
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	hit_stun.timeout.connect(seek_player)


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target1.position)

#setea la posición del target al que va a llegar
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func take_damage(player):
	state = HURT
	health = max(health - 25, 0)
	audio_stream_player_hurt.play()
	playback.travel("hurt")
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(-2,0), 0.07).from_current()
	tween.tween_property(sprite_2d, "position", Vector2(), 0.1).from_current()
	if player == 'player1':
		tween.tween_callback($Sprite2D.set_modulate.bind(Color.RED)).set_delay(0.5)
	if player == 'player2':
		tween.tween_callback($Sprite2D.set_modulate.bind(Color.BLUE)).set_delay(0.5)
	if health == 0:
		audio_stream_player_grunt.play()
		playback.travel("knockdown")
		state = DEATH
		hit_stun.stop()
	else:
		hit_stun.start(0.9)

func _physics_process(delta):
	if state == DEATH:
		movement_speed = 0
		await get_tree().create_timer(2.0).timeout
		queue_free()
	if state == HURT:
		movement_speed = 0
	if state == SEEK:
		if color == RED:
			movement_speed = 40.0
			set_movement_target(target1.position)
			if navigation_agent.is_navigation_finished():
				return

			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()

			var new_velocity: Vector2 = next_path_position - current_agent_position
			new_velocity = new_velocity.normalized()
			new_velocity = new_velocity * movement_speed

			velocity = new_velocity
			move_and_slide()
		
		elif color == BLUE:
			movement_speed = 40.0
			set_movement_target(target2.position)
			if navigation_agent.is_navigation_finished():
				return

			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()

			var new_velocity: Vector2 = next_path_position - current_agent_position
			new_velocity = new_velocity.normalized()
			new_velocity = new_velocity * movement_speed

			velocity = new_velocity
			move_and_slide()

func seek_player():
	state = SEEK
