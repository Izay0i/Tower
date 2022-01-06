extends Node2D

onready var player = $Player
onready var swamp_boss = $Enemies/SwampBoss
onready var swamp_loop = $SwampLoop
onready var boss_loop = $BossLoop
onready var victory = $Victory
onready var pause_screen = $CanvasLayer/PauseScreen
onready var victory_sprite = $CanvasLayer/VictorySprite

var can_play = true

func _ready():
	swamp_loop.volume_db = -20
	boss_loop.volume_db = -20
	
	_set_camera_limit(0, 0, 640, 288)

func _physics_process(_delta):
	if player.health == 0:
		pause_screen.visible = true
	
	if !has_node("Enemies/SwampBoss"):
		if can_play:
			can_play = false
			victory.play()
			victory_sprite.visible = true
		
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

func _on_WaterBody_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage()
		body.global_position = Vector2(384, 448)

func _on_WaterBody2_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage()
		body.global_position = Vector2(416, 1440)
	
	if body.get_class() == "Frog":
		body.global_position = Vector2(544, 1440)

func _on_WaterBody3_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage()
		body.global_position = Vector2(1504, 2016)

func _on_LimitBody_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(0, 320, 640, 640)

func _on_LimitBody2_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(0, 704, 384, 896)

func _on_LimitBody3_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(176, 1008, 416, 1232)
		_set_camera_zoom(0.35, 0.35)

func _on_LimitBody4_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(576, 960, 1120, 1152)
		_set_camera_zoom(0.6, 0.6)

func _on_LimitBody5_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(256, 1344, 1632, 1568)
		_set_camera_zoom(0.6, 0.6)

func _on_LimitBody6_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(256, 1344, 1632, 1568)

func _on_LimitBody7_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(960, 1632, 1632, 2112)

func _on_LimitBody8_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(960, 2176, 1632, 2368)

func _on_LimitBody9_body_entered(body):
	if body.get_class() == "Player":
		swamp_loop.stop()
		_set_camera_limit(1232, 2368, 1616, 2944)

func _on_TriggerBossArea_body_entered(body):
	if body.get_class() == "Player":
		swamp_boss.intro_timer.start()
		boss_loop.play()

func _on_Victory_finished():
	var highscore = player.score if player.score > Global.swamp_highscore else Global.swamp_highscore
	Global.save_highscores(Global.tutorial_highscore, highscore, Global.factory_highscore, Global.castle_highscore)
	
	if get_tree().change_scene("res://Screen/StageSelectScreen.tscn") != OK:
		print("Failed to change to stage select")
