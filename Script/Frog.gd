extends KinematicBody2D

const MAX_HEALTH = 1
const MAX_SPEED = 64
const SPEED = 32
const GRAVITY = 200
const JUMP_FORCE = 128
const UP_VECTOR = Vector2.UP

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var jump_timer = $JumpTimer
onready var death_timer = $DeathTimer
onready var ribbit_sfx = $RibbitSFX

var velocity = Vector2.ZERO
var direction = -1
var health = 0

func get_class():
	return "Frog"

func take_damage(damage = 1):
	health -= damage
	animation_player.play("Hurt")

func _ready():
	health = MAX_HEALTH
	ribbit_sfx.volume_db = -10

func _physics_process(delta):
	if death_timer.is_stopped():
		sprite.material.set_shader_param("flash_modifier", 0)
		
	if health > 0:
		sprite.play("Idle" if is_on_floor() else "Jump")
		
		_handle_movement(delta)
	else:
		sprite.play("Hurt")
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()

func _handle_movement(delta):
	if is_on_wall():
		direction *= -1
		sprite.scale.x *= -1
	
	if jump_timer.is_stopped() and is_on_floor():
			jump_timer.start()
			
			velocity.y -= JUMP_FORCE
	
	if !is_on_floor():
		velocity.x += direction * SPEED * delta
	else:
		velocity.x = 0
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, UP_VECTOR)

func _on_DeathTimer_timeout():
	queue_free()

func _on_VisibilityEnabler2D_screen_entered():
	if !ribbit_sfx.playing:
		ribbit_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	ribbit_sfx.stop()
