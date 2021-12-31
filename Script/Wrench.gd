extends Area2D

const SPEED = 40
const GRAVITY = 10
const BOUNCE = 3

var velocity = Vector2.ZERO
var direction = -1

func get_class():
	return "Wrench"

func _ready():
	velocity.y = -BOUNCE

func _physics_process(delta):
	velocity.x = direction * SPEED * delta
	velocity.y += GRAVITY * delta
	translate(velocity)

func _on_DespawnTimer_timeout():
	queue_free()
