extends KinematicBody2D

const FIREBALL = preload("res://Projectile/Fireball.tscn")

const DEBUG = false

const MAX_HEALTH = 5
const MAX_SCORE = 9999

const DAMAGE_TAKEN_BY_REGULAR_ENEMIES = 1
const DAMAGE_TAKEN_BY_BOSSES = 2

const ACCEL = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.02
const GRAVITY = 200
const JUMP_FORCE = 128
const UP_VECTOR = Vector2.UP

onready var camera = $Camera2D
onready var hitbox = $CollisionShape2D
onready var body_hitbox = $Body/CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var animation_tree = $AnimationTree
onready var invulnerable_timer = $InvulnerableTimer
onready var cooldown_timer = $CooldownTimer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var scythe_hitbox = $Scythe/Area2D/ScytheHitbox
onready var hud = $CanvasLayer/HUD
onready var redtint_sprite = $CanvasLayer/RedTintSprite
onready var hurt_sfx = $HurtSFX
onready var weapon_swing_sfx = $WeaponSwingSFX
onready var run_sfx = $RunSFX
onready var jump_sfx = $JumpSFX
onready var fireball_posiiton = $FireballPosition
onready var ceil_raycast = $CeilRaycast

var velocity = Vector2.ZERO

var health = 0
var score = 0
var projectile_direction = 1

func get_class():
	return "Player"

func take_damage(damage = 1):
	if invulnerable_timer.is_stopped():
		health -= damage
		invulnerable_timer.start()
		hurt_sfx.play()
		animation_player.play("Hurt")

func _ready():
	health = MAX_HEALTH
	
	_reset_timer()

func _physics_process(delta):
	if DEBUG:
		if Input.is_action_just_pressed("debug"):
			#Tutorial
			#_teleport(Vector2(640, 376))
			#SwampStage
			#_teleport(Vector2(1424, 2336))
			#SnowyIndustrialStage
			#_teleport(Vector2(2800, 688))
			#_teleport(Vector2(6864, 424))
			#CastleStage
			#_teleport(Vector2(3216, 944))
			#_teleport(Vector2(3264, 160))
			_teleport(Vector2(3296, -184))
	
	if health > 0:
		if Input.is_action_pressed("move_left"):
			animated_sprite.flip_h = true
			projectile_direction = -1
		if Input.is_action_pressed("move_right"):
			animated_sprite.flip_h = false
			projectile_direction = 1
		
		if Input.is_action_just_pressed("shoot") and cooldown_timer.is_stopped():
			_spawn_fireball(projectile_direction)
			cooldown_timer.start()
		if Input.is_action_pressed("melee") and attack_cooldown_timer.is_stopped():
			weapon_swing_sfx.play()
			attack_cooldown_timer.start()
	
	health = clamp(health, 0, MAX_HEALTH)
	score = clamp(score, 0, MAX_SCORE)
	
	hitbox.disabled = health == 0
	body_hitbox.disabled = health == 0
	redtint_sprite.visible = health == 1
	scythe_hitbox.disabled = attack_cooldown_timer.is_stopped()
	
	hud.update_health(health)
	hud.update_score(score)
	
	_handle_collision()
	_handle_animation_state()
	if health > 0:
		_handle_movement(delta)

func _handle_collision():
	if ceil_raycast.is_colliding():
		var collider = ceil_raycast.get_collider()
		match collider.get_class():
			"HydraulicPress":
				take_damage(MAX_HEALTH)
	
	var slide_count = get_slide_count()
	if slide_count:
		for collision_index in slide_count:
			var collision = get_slide_collision(collision_index)
			_on_Body_body_entered(collision.collider)

func _handle_animation_state():
	animation_tree.set("parameters/alive_state/current", health <= 0)
	animation_tree.set("parameters/state/current", !cooldown_timer.is_stopped() or !attack_cooldown_timer.is_stopped())
	animation_tree.set("parameters/attack_transition/current", !attack_cooldown_timer.is_stopped())
	animation_tree.set("parameters/air_transition/current", !is_on_floor())
	animation_tree.set("parameters/movement_transition/current", Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))

func _handle_movement(delta):
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if x_input != 0:
		scythe_hitbox.position.x = x_input * abs(scythe_hitbox.position.x)
		fireball_posiiton.position.x = x_input * abs(fireball_posiiton.position.x)
		
		if !run_sfx.playing and is_on_floor():
			run_sfx.play()
		
		velocity.x += x_input * ACCEL * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if x_input == 0:
			#velocity.x = lerp(velocity.x, 0, FRICTION)
			velocity.x = 0
			
		if Input.is_action_just_pressed("jump"):
			velocity.y -= JUMP_FORCE
			jump_sfx.play()
	else:
		if Input.is_action_just_released("jump") and velocity.y < -JUMP_FORCE / 2.0:
			velocity.y = -JUMP_FORCE / 2.0
		
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	velocity = move_and_slide(velocity, UP_VECTOR, true)

func _reset_timer():
	pass

func _spawn_fireball(direction):
	var fireball = FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.global_position = fireball_posiiton.global_position
	fireball.set_direction(direction)

func _teleport(position):
	self.global_position = position

func _on_Body_area_entered(area):
	match area.get_class():
		"IceSpike", "Spike":
			take_damage(DAMAGE_TAKEN_BY_REGULAR_ENEMIES)
		"Wave", "Wrench":
			take_damage(DAMAGE_TAKEN_BY_BOSSES)
		"Lava":
			take_damage(MAX_HEALTH)

func _on_Body_body_entered(body):
	match body.get_class():
		"Frog", "Skeleton", "Golem", "Bat", "Gingerbread", "Elf":
			take_damage(DAMAGE_TAKEN_BY_REGULAR_ENEMIES)
		"Santa":
			take_damage(DAMAGE_TAKEN_BY_BOSSES)

#Scythe's hitbox
func _on_Area2D_body_entered(body):
	if body.get_class() != "Player":
		if body.has_method("take_damage"):
			var damage_dealt = 1
			match body.get_class():
				"Present":
					damage_dealt = 4
				"SwampBoss", "Santa":
					damage_dealt = 3
				"Skeleton", "Golem", "Gingerbread", "Elf":
					damage_dealt = 2
			body.take_damage(damage_dealt)
