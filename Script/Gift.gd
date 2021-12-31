extends KinematicBody2D

const GRAVITY = 200

onready var despawn_timer = $DespawnTimer

var velocity = Vector2.ZERO

func _ready():
	despawn_timer.start()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_DespawnTimer_timeout():
	queue_free()
