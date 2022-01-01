extends Node2D

onready var player = $Player
onready var winter_background = $WinterBackground
onready var winter_loop = $WinterLoop
onready var factory_loop = $FactoryLoop
onready var victory = $Victory
onready var snow_particle = $Snow/Particles2D
onready var pause_screen = $CanvasLayer/PauseScreen
onready var victory_sprite = $CanvasLayer/VictorySprite

var can_play = true

func _ready():
	winter_loop.volume_db = -10
	factory_loop.volume_db = -10
	winter_loop.play()
	
	_set_camera_limit(0, 448, 2848, 736)

func _physics_process(_delta):
	if player.health == 0:
		pause_screen.visible = true
	
	if has_node("Snow/Particles2D"):
		snow_particle.position.x = player.position.x - 255

func _set_camera_zoom(x = 0.6, y = 0.6):
	player.camera.zoom.x = x
	player.camera.zoom.y = y

func _set_camera_limit(left, top, right, bottom):
	player.camera.limit_left = left
	player.camera.limit_top = top
	player.camera.limit_right = right
	player.camera.limit_bottom = bottom

func _on_Teleporter_body_entered(body):
	if body.get_class() == "Player":
		body.global_position = Vector2(3088, 720)
		_set_camera_limit(3024, 0, 6944, 800)
		winter_loop.stop()
		factory_loop.play()
		winter_background.queue_free()
		snow_particle.queue_free()

func _on_LimitBody_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(4736, 288, 5664, 832)

func _on_LimitBody2_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(5632, 288, 6944, 512)

func _on_LimitBody3_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(4736, 288, 5664, 832)

func _on_LimitBody4_body_entered(body):
	if body.get_class() == "Player":
		_set_camera_limit(5632, 288, 6944, 512)

func _on_TriggerEnd_body_entered(body):
	if body.get_class() == "Player":
		if can_play:
			can_play = false
			victory.play()
			victory_sprite.visible = true
		
		factory_loop.stop()

func _on_Victory_finished():
	if get_tree().change_scene("res://Screen/StageSelectScreen.tscn") != OK:
		print("Failed to change to stage select")
