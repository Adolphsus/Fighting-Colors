extends Area2D
@onready var nivel = $"."
var players = 0

#spawn_points
@onready var point_1 = $Point1
@onready var point_2 = $Point2

@onready var enemy1 = preload("res://enemy1.tscn")
@onready var enemy2 = preload("res://enemy_2.tscn")
@onready var enemy3 = preload("res://enemy_3.tscn")

var limitL = 540
var limitR = 1010
var contador = 0
var limitRfinal = 3250
var cleared = false

func on_body_entered(body: Node2D):
	players += 1
	print(players)
	if players == 2:
		start()
	
func on_body_exited(body: Node2D):
	players -= 1
	print(players)

func start():
	if not cleared:
		spawn(enemy1, point_1)
		spawn(enemy1, point_2)
		if Game.camera:
			Game.camera.limits(limitL, limitR)
		
func end():
	contador +=1
	print(contador)
	if contador == 2:
		Game.camera.limits(limitL, limitRfinal)
		cleared = true
		print('funciono')

func spawn(en, point):
	var spawn_point = Vector2(point.position)
	var enemy = en.instantiate()
	enemy.position = spawn_point
	enemy.add_to_group("Enemies")
	call_deferred("add_child", enemy)

func _ready():
	nivel.body_entered.connect(on_body_entered)
	nivel.body_exited.connect(on_body_exited)
	
