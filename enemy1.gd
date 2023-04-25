extends CharacterBody2D
class_name Enemy
#@onready var hurt_box = $HurtBox
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback = animation_tree.get("parameters/playback")
@onready var progress_bar = $MarginContainer/ProgressBar

const Max_health = 100
var health = 100:
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

		
func take_damage():
	health = max(health - 25, 0)
	playback.travel("hurt")
	if health == 0:
		playback.travel("knockdown")
		state = DEATH
		
func _physics_process(delta):
	if state == DEATH:
		await get_tree().create_timer(1.3).timeout
		queue_free()
