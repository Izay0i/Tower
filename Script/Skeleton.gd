extends KinematicBody2D

const MAX_HEALTH = 3
const MAX_SPEED = 16
const SPEED = 16
const GRAVITY = 256
const UP_VECTOR = Vector2.UP

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var death_timer = $DeathTimer
onready var rattle_sfx = $RattleSFX
onready var raycast = $RayCast2D

var velocity = Vector2.ZERO
var direction = -1
var health = 0

func get_class():
	return "Skeleton"

func take_damage(damage = 2):
	health -= damage
	animation_player.play("Hurt")

func _ready():
	health = MAX_HEALTH
	rattle_sfx.volume_db = -10
	
func _physics_process(delta):
	if health > 0:
		sprite.play("Walk")
		
		_handle_movement(delta)
	else:
		sprite.play("Hurt")
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()

func _handle_movement(delta):
	if is_on_floor():
		if is_on_wall() or !raycast.is_colliding():
			direction *= -1
			sprite.scale.x *= -1
			raycast.position.x *= -1
	
	velocity.x += direction * SPEED * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, UP_VECTOR)

func _on_DeathTimer_timeout():
	queue_free()

func _on_VisibilityEnabler2D_screen_entered():
	if !rattle_sfx.playing:
		rattle_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	rattle_sfx.stop()
