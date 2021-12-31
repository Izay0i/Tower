extends KinematicBody2D

const MAX_HEALTH = 4
const MAX_SPEED = 64
const SPEED = 48
const GRAVITY = 256
const UP_VECTOR = Vector2.UP

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var raycast = $RayCast2D
onready var explosion_range_hitbox = $ExplosionRange/CollisionShape2D
onready var body_hitbox = $Body/CollisionShape2D
onready var detect_area = $DetectArea
onready var detect_area_hitbox = $DetectArea/CollisionShape2D
onready var death_timer = $DeathTimer
onready var explode_sfx = $ExplodeSFX
onready var scream_sfx = $ScreamSFX

var health = 0
var velocity = Vector2.ZERO
var direction = -1
var is_in_range = false

func get_class():
	return "Present"

func take_damage(damage = 1):
	health -= damage
	animation_player.play("Hurt")

func _ready():
	scream_sfx.volume_db = -15
	
	health = MAX_HEALTH

func _physics_process(delta):
	if health > 0 and !is_in_range:
		if is_on_floor() and !raycast.is_colliding():
			_flip_properties()
		
		_handle_movement(delta)
	else:
		_disable_properties()
		sprite.play("Explode")
		if !explode_sfx.playing:
			explode_sfx.play()

func _flip_properties():
	direction *= -1
	raycast.position.x *= -1
	hitbox.position.x *= -1
	body_hitbox.position.x *= -1
	detect_area.position.x *= -1
	sprite.scale.x *= -1

func _disable_properties():
	hitbox.disabled = true
	#explosion_range_hitbox.disabled = true
	body_hitbox.disabled = true
	detect_area_hitbox.disabled = true
	if death_timer.is_stopped():
		death_timer.start()

func _handle_movement(delta):
	if is_on_floor():
		if is_on_wall():
			direction *= -1
			sprite.scale.x *= -1
			raycast.position.x *= -1
	
	velocity.x += direction * SPEED * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, UP_VECTOR)

func _on_ExplosionRange_body_entered(body):
	if body.get_class() == "Player":
		body.take_damage(4)

func _on_Body_area_entered(area):
	if area.get_class() == "Lava":
		take_damage(MAX_HEALTH)

func _on_Body_body_entered(body):
	if body.get_class() == "Player":
		is_in_range = true
		explosion_range_hitbox.set_deferred("disabled", false)

func _on_DeathTimer_timeout():
	queue_free()

func _on_DetectArea_body_entered(body):
	if body.get_class() == "Player":
		_flip_properties()

func _on_VisibilityEnabler2D_screen_entered():
	if !scream_sfx.playing:
		scream_sfx.play()

func _on_VisibilityEnabler2D_screen_exited():
	scream_sfx.stop()
