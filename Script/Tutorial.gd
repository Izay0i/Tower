extends Node2D

onready var forest_start = $ForestStart
onready var forest_loop = $ForestLoop

func _ready():
	forest_start.volume_db = -20
	forest_loop.volume_db = -20

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
