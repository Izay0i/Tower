extends Node2D

func _on_TutorialButton_pressed():
	if get_tree().change_scene("res://Stage/Tutorial.tscn") != OK:
		print("Failed to change to tutorial")

func _on_StagesButton_pressed():
	if get_tree().change_scene("res://Screen/StageSelectScreen.tscn") != OK:
		print("Failed to change to stage select")

func _on_QuitButton_pressed():
	get_tree().quit()
