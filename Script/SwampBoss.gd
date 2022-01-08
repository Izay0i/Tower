extends KinematicBody2D

const SKELETON = preload("res://Enemy/Skeleton.tscn")

const POSITION = Vector2(896, 1360)

const ATTACK_DAMAGE = 3
const MAX_HEALTH = 42

onready var intro_timer = $IntroTimer
onready var death_timer = $DeathTimer
onready var idle_timer = $IdleTimer
onready var spawn_timer = $SpawnTimer
onready var attack_timer = $AttackTimer
onready var invulnerable_timer = $InvulnerableTimer
onready var pop_sfx = $PopSFX
onready var cry = $Cry
onready var gas_sfx = $GasSFX
onready var explode_sfx = $ExplodeSFX
onready var spawner = $Spawner
onready var animation_tree = $AnimationTree
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var gas_particle = $GasParticle
onready var gas_hitbox = $Gas/CollisionShape2D
onready var hitbox = $CollisionShape2D

var random_generator = RandomNumberGenerator.new()

var active = false
var health = 0

func get_class():
	return "SwampBoss"

func take_damage(damage = 1):
	if invulnerable_timer.is_stopped():
		health -= damage
		animation_player.play("Flash")
		invulnerable_timer.start()

func _ready():
	gas_sfx.volume_db = 10
	
	health = MAX_HEALTH
	gas_hitbox.disabled = true

func _physics_process(_delta):
	if active:
		if health <= 0:
			if death_timer.is_stopped():
				explode_sfx.play()
				death_timer.start()
		
		_handle_attack_state()
		_handle_animation_state()

func _handle_attack_state():
	if !attack_timer.is_stopped():
		var attacks = ["_spawn_skeletons", "_gas_attack"]
		attacks.shuffle()
		
		var attack = attacks.front()
		call(attack)

func _handle_animation_state():
	animation_tree.set("parameters/state/current", health <= 0)
	animation_tree.set("parameters/alive_transition/current", !attack_timer.is_stopped())

func _spawn_skeletons():
	if spawn_timer.is_stopped():
		spawn_timer.start()
		
		var min_range = -9
		var max_range = 9
		
		random_generator.randomize()
		var spawn_point = spawner.global_position.x + ((random_generator.randi_range(min_range, max_range) + 1) * 10)
		var skeleton = SKELETON.instance()
		get_parent().add_child(skeleton)
		skeleton.get_parent().add_to_group("Enemies")
		skeleton.global_position = Vector2(spawn_point, spawner.global_position.y)
		
		var directions = [-1, 1]
		directions.shuffle()
		var direction = directions.front()
		
		skeleton.direction *= direction
		skeleton.sprite.scale.x *= direction
		skeleton.raycast.position.x *= direction
		
		pop_sfx.play()

func _gas_attack():
	gas_hitbox.disabled = false
	gas_particle.emitting = true
	if !gas_sfx.playing:
		gas_sfx.play()
	animation_player.play("Gas")

func _on_IntroTimer_timeout():
	active = true
	hitbox.disabled = false
	idle_timer.start()
	if !cry.playing:
		cry.play()

func _on_DeathTimer_timeout():
	queue_free()

func _on_IdleTimer_timeout():
	attack_timer.start()

func _on_AttackTimer_timeout():
	gas_hitbox.disabled = true
	gas_particle.emitting = false
	idle_timer.start()

func _on_Gas_body_entered(body):
	if !gas_hitbox.disabled:
		if body.get_class() == "Player":
			body.take_damage(ATTACK_DAMAGE)
