extends Position2D

export(bool) var spawn_hostile

const GIFT = preload("res://Item/Gift.tscn")
const PRESENT = preload("res://Enemy/Present.tscn")

onready var idle_timer = $IdleTimer
onready var pop_sfx = $PopSFX

func _ready():
	pop_sfx.volume_db = -10
	
	idle_timer.start()

func _spawn():
	var entity
	if !spawn_hostile:
		entity = GIFT.instance()
	else:
		entity = PRESENT.instance()
	get_parent().add_child(entity)
	entity.global_position = self.global_position
	pop_sfx.play()

func _on_IdleTimer_timeout():
	_spawn()
	idle_timer.start()

func _on_VisibilityNotifier2D_screen_entered():
	if idle_timer.is_stopped():
		idle_timer.start()

func _on_VisibilityNotifier2D_screen_exited():
	idle_timer.stop()
