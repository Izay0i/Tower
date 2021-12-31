extends StaticBody2D

onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var idle_timer = $IdleTimer
onready var press_sfx = $PressSFX

func get_class():
	return "HydraulicPress"

func _ready():
	press_sfx.volume_db = -10
	idle_timer.start()

func _on_IdleTimer_timeout():
	idle_timer.start()
	animation_player.play("Press")
	press_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	press_sfx.stop()
