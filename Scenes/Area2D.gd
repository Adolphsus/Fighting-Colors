extends Area2D
@onready var nivel = $"."
var players = 0
@onready var markerR = $Marker2D
@onready var markerL = $Marker2D2

func on_body_entered(body: Node2D):
	players += 1
	print(players)
func on_body_exited(body: Node2D):
	players -= 1
	print(players)

func lock_camera():
	if players == 2:
		pass #acá se lockea la camara, se spawnean los enemigos
		
# Called when the node enters the scene tree for the first time.
func _ready():
	nivel.body_entered.connect(on_body_entered)
	nivel.body_exited.connect(on_body_exited)
