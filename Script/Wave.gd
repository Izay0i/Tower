extends Area2D

const SPEED = 100

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var alive_timer = $AliveTimer

var velocity = Vector2.ZERO
var direction = -1

func set_direction(dir):
	direction = dir
	sprite.scale.x = -direction

func _physics_process(delta):
	animation_player.play("Wave")
	velocity.x = SPEED * delta * direction
	translate(velocity)

func _on_AliveTimer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.take_damage(2)
