extends KinematicBody2D

const MAX_HEALTH = 1
const FLY_SPEED = 32

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var death_timer = $DeathTimer
onready var bat_sfx = $BatSFX

var frequency = 3
var amplitude = 64
var time = 0

var velocity = Vector2.ZERO
var health = 0

func get_class():
	return "Bat"

func take_damage(damage = 1):
	health -= damage
	animation_player.play("Hurt")

func _ready():
	health = MAX_HEALTH

func _physics_process(delta):
	if health > 0:
		sprite.play("Fly")
		
		_handle_movement(delta)
	else:
		sprite.play("Hurt")
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()

func _handle_movement(delta):
	time += delta
	velocity.x += -FLY_SPEED * delta
	velocity.y = sin(time * frequency) * amplitude
	velocity = move_and_slide(velocity)

func _on_DeathTimer_timeout():
	queue_free()

func _on_VisibilityEnabler2D_screen_entered():
	if !bat_sfx.playing:
		bat_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	bat_sfx.stop()
