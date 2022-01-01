extends Node2D

onready var player = $Player
onready var santa = $Enemies/Santa
onready var castle_start = $CastleStart
onready var castle_loop = $CastleLoop
onready var boss_start = $BossStart
onready var boss_loop = $BossLoop
onready var victory = $Victory

var can_play = true

func _ready():
	castle_start.volume_db = -15
	castle_loop.volume_db = -15
	boss_start.volume_db = -5
	boss_loop.volume_db = -5
	victory.volume_db = -10
	castle_start.play()
	
	_set_camera_zoom(0.45, 0.45)
	#_set_camera_limit(0, 0, 384, 192)
	_set_camera_limit(768, 512, 3280, 992)

func _physics_process(_delta):
	if !has_node("Enemies/Santa"):
		if can_play:
			can_play = false
			victory.play()
		
		boss_loop.stop()
		var enemies = get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			enemy.queue_free()

func _set_camera_zoom(x = 0.6, y = 0.6):
	player.camera.zoom.x = x
	player.camera.zoom.y = y

func _set_camera_limit(left, top, right, bottom):
	player.camera.limit_left = left
	player.camera.limit_top = top
	player.camera.limit_right = right
	player.camera.limit_bottom = bottom

func _on_CastleStart_finished():
	castle_loop.play()

func _on_BossStart_finished():
	boss_loop.play()

func _on_Teleporter_body_entered(body):
	if body.get_class() == "Player":
		player.global_position = Vector2(904, 360)
		_set_camera_limit(784, 0, 2336, 400)

func _on_Teleporter2_body_entered(body):
	if body.get_class() == "Player":
		player.global_position = Vector2(64, 136)
		_set_camera_zoom(0.6, 0.6)
		_set_camera_limit(0, 0, 384, 192)
		santa.intro_timer.start()
		santa.intro_sfx.play()
		castle_loop.stop()
		boss_start.play()

func _on_CameraLimit_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(2352, 0, 3328, 224)

func _on_WaterBody_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(960, 872)

func _on_WaterBody2_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(1120, 824)

func _on_WaterBody3_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(1488, 808)

func _on_WaterBody4_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(1984, 840)

func _on_WaterBody5_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(1696, 344)

func _on_WaterBody6_body_entered(body):
	if body.get_class() == "Player":
		player.take_damage()
		player.global_position = Vector2(2096, 328)
