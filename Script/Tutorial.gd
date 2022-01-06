extends Node2D

onready var player = $Player
onready var forest_start = $ForestStart
onready var forest_loop = $ForestLoop
onready var victory = $Victory
onready var pause_screen = $CanvasLayer/PauseScreen
onready var victory_sprite = $CanvasLayer/VictorySprite

var can_play = true

func _ready():
	forest_start.volume_db = -20
	forest_loop.volume_db = -20

func _physics_process(_delta):
	if player.health == 0:
		pause_screen.visible = true
	
	if !has_node("Enemies/Golem"):
		if can_play:
			can_play = false
			victory.play()
			victory_sprite.visible = true
		
		forest_loop.stop()

func _on_WaterBody_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage()
		body.global_position = Vector2(104, 304)
	
	if body.get_class() == "Frog":
		body.global_position = Vector2(248, 360)

func _on_WideWaterBody_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage()
		body.global_position = Vector2(640, 376)

func _on_ForestStart_finished():
	forest_loop.play()

func _on_Victory_finished():
	var highscore = player.score if player.score > Global.tutorial_highscore else Global.tutorial_highscore
	Global.save_highscores(highscore, Global.swamp_highscore, Global.factory_highscore, Global.castle_highscore)
	
	if get_tree().change_scene("res://Screen/StageSelectScreen.tscn") != OK:
		print("Failed to change to stage select")
