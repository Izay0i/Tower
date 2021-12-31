extends KinematicBody2D

const MAX_HEALTH = 6
const MAX_SPEED = 64
const SPEED = 64
const GRAVITY = 256
const UP_VECTOR = Vector2.UP

onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var vibe_sfx = $VibeSFX
onready var death_timer = $DeathTimer
onready var raycast = $RayCast2D

var velocity = Vector2.ZERO
var direction = -1
var health = 0

func _ready():
	health = MAX_HEALTH

func get_class():
	return "Gingerbread"

func take_damage(damage = 1):
	health -= damage
	animation_player.play("Hurt")

func _physics_process(delta):
	if health > 0:
		_handle_movement(delta)
	else:
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()

func _handle_movement(delta):
	if is_on_floor():
		if is_on_wall() or !raycast.is_colliding():
			direction *= -1
			raycast.position.x *= -1
	
	velocity.x += direction * SPEED * delta
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, UP_VECTOR)

func _on_VisibilityEnabler2D_screen_entered():
	if !vibe_sfx.playing:
		vibe_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	vibe_sfx.stop()

func _on_DeathTimer_timeout():
	queue_free()

func _on_Body_area_entered(area):
	if area.get_class() == "Lava":
		take_damage(MAX_HEALTH)
