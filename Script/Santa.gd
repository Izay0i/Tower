extends KinematicBody2D

const WRENCH = preload("res://Projectile/Wrench.tscn")

const MAX_HEALTH = 36
const MAX_SPEED = 64
const SPEED = 64
const BOUNCE = 200
const GRAVITY = 200
const UP_VECTOR = Vector2.UP

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var animation_tree = $AnimationTree
onready var hitbox = $CollisionShape2D
onready var enemy_spawn_position = $EnemySpawnPosition
onready var intro_timer = $IntroTimer
onready var idle_timer = $IdleTimer
onready var spawn_timer = $SpawnTimer
onready var attack_timer = $AttackTimer
onready var death_timer = $DeathTimer
onready var invulnerable_timer = $InvulnerableTimer
onready var intro_sfx = $IntroSFX
onready var bounce_sfx = $BounceSFX
onready var explode_sfx = $ExplodeSFX

var active = false
var direction = -1
var health = 0
var velocity = Vector2.ZERO

func get_class():
	return "Santa"

func take_damage(damage = 1):
	if invulnerable_timer.is_stopped():
		invulnerable_timer.start()
		
		health -= damage
		animation_player.play("Hurt")

func _ready():
	hitbox.disabled = true
	health = MAX_HEALTH

func _physics_process(delta):
	if active:
		if health > 0:
			if !idle_timer.is_stopped():
				velocity.x = 0
			
			if is_on_floor() and !attack_timer.is_stopped():
				bounce_sfx.play()
			
			if is_on_wall():
				direction *= -1
				sprite.scale.x *= -1
				hitbox.position.x *= -1
				enemy_spawn_position.position.x *= -1
		
			_handle_attack_state(delta)
			
			velocity.y += GRAVITY * delta
			velocity = move_and_slide(velocity, UP_VECTOR)
		else:
			hitbox.disabled = true
			if !explode_sfx.playing:
				explode_sfx.play()
			if death_timer.is_stopped():
				death_timer.start()
		
		_handle_animation_state()

func _handle_attack_state(delta):
	if !attack_timer.is_stopped():
		_bounce(delta)
		_spawn_wrench()

func _spawn_wrench():
	if spawn_timer.is_stopped():
		spawn_timer.start()
		
		var wrench = WRENCH.instance()
		wrench.direction = direction
		get_parent().add_child(wrench)
		wrench.global_position = enemy_spawn_position.global_position

func _handle_animation_state():
	animation_tree.set("parameters/state/current", health <= 0)
	animation_tree.set("parameters/alive_state/current", idle_timer.is_stopped())

func _bounce(delta):
	velocity.x += direction * SPEED * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	if is_on_floor():
		velocity.y = -BOUNCE

func _on_IntroTimer_timeout():
	active = true
	hitbox.disabled = false
	idle_timer.start()

func _on_IdleTimer_timeout():
	attack_timer.start()

func _on_AttackTimer_timeout():
	idle_timer.start()

func _on_DeathTimer_timeout():
	queue_free()

func _on_DetectArea_body_entered(body):
	if body.get_class():
		direction *= -1
		sprite.scale.x *= -1
		hitbox.position.x *= -1
		enemy_spawn_position.position.x *= -1
