extends Camera2D
@onready var player = $"../Kinetic/Players/Player"
@onready var player_2 = $"../Kinetic/Players/Player2"

const LEFT = 0
const TOP = 0
const RIGHT = 3300
const BOTTOM = 250
const ZOOM = Vector2(0.7, 0.6)

func limits(x, y):
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "limit_left", x, 2.5)
	tween.tween_property(self, "limit_right", y, 2.5)
	pass
func _ready():
	Game.camera = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var A = max(player.global_position.x, player_2.global_position.x) * 3/4 + min(player.global_position.x, player_2.global_position.x) * 1/4
	position.x = A
	$"physic limits".global_position = get_screen_center_position()
