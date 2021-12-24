extends Node2D

onready var number = $MarginContainer/HBoxContainer/Bars/Bar/Count/Background/Number
onready var score = $MarginContainer/HBoxContainer/Bars/Bar/Score/Background/Value

func update_health(value):
	number.text = str(value)

func update_score(value):
	score.text = str(value)

func _process(_delta):
	global_rotation = 0
