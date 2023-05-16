extends CharacterBody2D
class_name Enemy

#@onready var hurt_box = $HurtBox
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")
@onready var progress_bar = $MarginContainer/ProgressBar
@onready var sprite_2d = $Sprite2D

const Max_health = 99999
var health = 99999:
	set(value):
		health = value
		progress_bar.value = value
	get:
		return health
		
enum { SEEK,
ATTACK,
DEATH
}

var state = SEEK

func _ready():
	progress_bar.value = Max_health

		
func take_damage(player):
	health = max(health - 25, 0)
	playback.travel("hurt")
	var tween = create_tween()
	if player == 'player1':
		tween.tween_callback($Sprite2D.set_modulate.bind(Color.RED)).set_delay(2)
	if player == 'player2':
		tween.tween_callback($Sprite2D.set_modulate.bind(Color.BLUE)).set_delay(2)

	if health == 0:
		playback.travel("knockdown")
		state = DEATH
		
func _physics_process(delta):
	if state == DEATH:
		await get_tree().create_timer(1.3).timeout
		queue_free()
