extends Area2D
@onready var nivel = $"."
var players = 0

#spawn_points
@onready var point_1 = $Point1
@onready var point_2 = $Point2
@onready var point_3 = $Point3

@onready var enemy1 = preload("res://enemy1.tscn")
@onready var enemy2 = preload("res://enemy_2.tscn")
@onready var enemy3 = preload("res://enemy_3.tscn")
@onready var enemies = $"../Kinetic/Enemies"

#stage
@onready var stage = get_tree().get_nodes_in_group("Stages")
@onready var current_stage = stage[0]

var limitL = 1450
var limitR = 1917
var contador = 0
var limitRfinal = 3250
@onready var wave = 0
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
		spawn(enemy2, point_1)
		await get_tree().create_timer(1.0).timeout
		spawn(enemy3, point_2)
		contador = 0
		wave = 1
		print("wave: " + str(wave))
		if Game.camera:
			Game.camera.limits(limitL, limitR)
		
func end(): #acá se pasa de un wave a otro
	contador +=1
	if contador == 2 and wave == 1: #se derrotaron a los enemigos necesarios en su wave correspondiente
		contador = 0
		wave = 2
		spawn(enemy1, point_1)
		await get_tree().create_timer(1.0).timeout
		spawn(enemy2, point_2)
		await get_tree().create_timer(1.0).timeout
		spawn(enemy3, point_2)
		print("wave: " + str(wave))
	if contador == 3 and wave == 2:
		contador = 0
		wave = 3
		spawn(enemy1, point_1)
		await get_tree().create_timer(0.5).timeout
		spawn(enemy2, point_2)
		await get_tree().create_timer(4.0).timeout
		spawn(enemy3, point_1)
		await get_tree().create_timer(0.5).timeout
		spawn(enemy3, point_3)
		await get_tree().create_timer(0.5).timeout
		spawn(enemy2, point_3)
		print("wave: " + str(wave))
	if contador == 5 and wave == 3:
		Game.camera.limits(limitL, limitRfinal)
		cleared = true
		remove_from_group("Levels")
		current_stage.next()

func spawn(en, point):
	var spawn_point = Vector2(point.global_position)
	var enemy = en.instantiate()
	enemy.position = spawn_point
	enemy.add_to_group("Enemies")
	enemies.call_deferred("add_child",enemy)

func _ready():
	nivel.body_entered.connect(on_body_entered)
	nivel.body_exited.connect(on_body_exited)
