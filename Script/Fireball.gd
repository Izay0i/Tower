extends Area2D

const SPEED = 200

onready var alive_timer = $AliveTimer
onready var sprite = $Sprite

var velocity = Vector2.ZERO
var direction = 1

func set_direction(dir):
	direction = dir
	sprite.scale.x = direction

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func _on_AliveTimer_timeout():
	queue_free()

func _on_Fireball_body_entered(body):
	if body.name != "Player":
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
