extends Node2D

onready var audio = $AudioStreamPlayer
onready var tutorial_highscore = $TutorialHighscore
onready var swamp_highscore = $SwampHighscore
onready var factory_highscore = $FactoryHighscore
onready var castle_highscore = $CastleHighscore

func _ready():
	audio.volume_db = -15
	
	_load_highscores()

func _load_highscores():
	Global.load_highscores()
	
	tutorial_highscore.set_text("Tutorial %5d" % Global.tutorial_highscore)
	swamp_highscore.set_text("Swamp %5d" % Global.swamp_highscore)
	factory_highscore.set_text("Factory %5d" % Global.factory_highscore)
	castle_highscore.set_text("Castle %5d" % Global.castle_highscore)

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
