extends Control

func _input(event):
	if event.is_action_pressed("exit"):
		visible = !visible

func _on_RetryButton_pressed():
	var foo = get_tree().reload_current_scene()
	print(foo)

func _on_HomeButton_pressed():
	if get_tree().change_scene("res://Screen/StageSelectScreen.tscn") != OK:
		print("Failed to change to stage select")
