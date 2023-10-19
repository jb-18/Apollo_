extends Node2D

@export var enemy_scene: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainter
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground
var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var hi_score

var scroll_speed = 100 

func _ready ():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		hi_score = save_file.get_32()
	else:
		hi_score = 0
		save_game()
	
	score = 0
	player = get_tree().get_first_node_in_group("Player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(hi_score)

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	if timer.wait_time > 0.5:
		timer.wait_time -= delta*0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	pb.scroll_offset.y += delta*scroll_speed
	if pb.scroll_offset.y >= 1400:
		pb.scroll_offset.y = 0


func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scene.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points
	if score > hi_score:
		hi_score = score


func _on_player_killed():
	gos.set_score(score)
	gos.set_hi_score(hi_score)
	save_game()
	await get_tree().create_timer(1.0).timeout
	gos.visible = true
