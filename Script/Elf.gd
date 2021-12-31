extends KinematicBody2D

const WRENCH = preload("res://Projectile/Wrench.tscn")

const MAX_HEALTH = 4
const MAX_SPEED = 48
const SPEED = 48
const GRAVITY = 200
const MIN_OFFSET = -16
const MAX_OFFSET = 16

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var death_timer = $DeathTimer
onready var cooldown_timer = $CooldownTimer
onready var wrench_position = $WrenchPosition
onready var detect_area = $DetectArea
onready var laugh_sfx = $LaughSFX

var direction = -1
var x_speed = -1
var velocity = Vector2.ZERO
var health = 0
var original_positon = Vector2.ZERO

func get_class():
	return "Elf"

func take_damage(damage = 1):
	health -= damage
	animation_player.play("Hurt")

func _ready():
	original_positon = global_position
	health = MAX_HEALTH

func _physics_process(delta):
	if health > 0:
		if global_position.x < original_positon.x - MIN_OFFSET:
			x_speed = 1
		elif global_position.x > original_positon.x + MAX_OFFSET:
			x_speed = -1
		
		sprite.play("Attack")
		_handle_movement(delta)
	else:
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()

func _handle_movement(delta):
	velocity.x += x_speed * SPEED * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _spawn_wrench():
	var wrench = WRENCH.instance()
	get_parent().add_child(wrench)
	wrench.direction = direction
	wrench.global_position = wrench_position.global_position

func _on_DeathTimer_timeout():
	queue_free()

func _on_CooldownTimer_timeout():
	_spawn_wrench()
	cooldown_timer.start()

func _on_DetectArea_body_entered(body):
	if body.get_class() == "Player":
		direction *= -1
		sprite.scale.x *= -1
		wrench_position.position.x *= -1
		detect_area.position.x *= -1

func _on_VisibilityEnabler2D_screen_entered():
	if !laugh_sfx.playing:
		laugh_sfx.play()
	
	if cooldown_timer.is_stopped():
		cooldown_timer.start()

func _on_VisibilityEnabler2D_screen_exited():
	laugh_sfx.stop()
	cooldown_timer.stop()
