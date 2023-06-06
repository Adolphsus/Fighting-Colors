extends Camera2D
@onready var player = $"../Kinetic/Players/Player"
@onready var player_2 = $"../Kinetic/Players/Player2"

const LEFT = 0
const TOP = 0
const RIGHT = 3300
const BOTTOM = 240
const ZOOM = Vector2(0.7, 0.7)


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var A = max(player.global_position.x, player_2.global_position.x) * 3/4 + min(player.global_position.x, player_2.global_position.x) * 1/4
	position.x = A
	$"physic limits".global_position = get_screen_center_position()
