extends Node2D

onready var audio = $AudioStreamPlayer

func _ready():
	audio.volume_db = -15

func _on_SwampButton_pressed():
	if get_tree().change_scene("res://Stage/SwampStage.tscn") != OK:
		print("Failed to change to swamp stage")

func _on_FactoryButton_pressed():
	if get_tree().change_scene("res://Stage/SnowyIndustrialStage.tscn") != OK:
		print("Failed to change to snowy industrial stage")

func _on_CastleButton_pressed():
	if get_tree().change_scene("res://Stage/CastleStage.tscn") != OK:
		print("Failed to change to castle stage")

func _on_MenuButton_pressed():
	if get_tree().change_scene("res://Screen/TitleScreen.tscn") != OK:
		print("Failed to change to title screen")
