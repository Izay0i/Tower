extends Node2D

const MAX_TUTORIAL_SCORE = 60
const MAX_SWAMP_SCORE = 710
const MAX_FACTORY_SCORE = 930
const MAX_CASTLE_SCORE = 870

onready var present_button = $PresentButton
onready var audio = $AudioStreamPlayer
onready var gymnopedie_loop = $GymnopedieLoop
onready var tutorial_highscore = $TutorialHighscore
onready var swamp_highscore = $SwampHighscore
onready var factory_highscore = $FactoryHighscore
onready var castle_highscore = $CastleHighscore

onready var ni = $Ni
onready var muop = $Muop

func _ready():
	audio.volume_db = -15
	
	_load_highscores()
	_checksum()

func _load_highscores():
	Global.load_highscores()
	
	tutorial_highscore.set_text("Tutorial %d/%d" % [Global.tutorial_highscore, MAX_TUTORIAL_SCORE])
	swamp_highscore.set_text("Swamp %d/%d" % [Global.swamp_highscore, MAX_SWAMP_SCORE])
	factory_highscore.set_text("Factory %d/%d" % [Global.factory_highscore, MAX_FACTORY_SCORE])
	castle_highscore.set_text("Castle %d/%d" % [Global.castle_highscore, MAX_CASTLE_SCORE])

func _checksum():
	var sum = Global.tutorial_highscore + Global.swamp_highscore + Global.factory_highscore + Global.castle_highscore
	var highest_sum = MAX_TUTORIAL_SCORE + MAX_SWAMP_SCORE + MAX_FACTORY_SCORE + MAX_CASTLE_SCORE
	
	present_button.visible = sum == highest_sum

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

func _on_PresentButton_pressed():
	ni.visible = !ni.visible
	muop.visible = !muop.visible
	
	if audio.playing:
		audio.stop()
		gymnopedie_loop.play()
