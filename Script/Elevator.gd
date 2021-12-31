extends Node2D

onready var animation_player = $AnimationPlayer
onready var move_sfx = $MoveSFX

func _on_TriggerArea_body_entered(body):
	if body.get_class() == "Player":
		animation_player.play("Move")
		if !move_sfx.playing:
			move_sfx.play()
