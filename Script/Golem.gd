extends KinematicBody2D

const MAX_HEALTH = 10

const WAVE = preload("res://Projectile/Wave.tscn")

onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var hitbox = $CollisionShape2D
onready var cooldown_timer = $CooldownTimer
onready var death_timer = $DeathTimer
onready var wave_position = $WavePosition
onready var animation_tree = $AnimationTree
onready var attack_sfx = $AttackSFX

var direction = -1
var health = 0

func get_class():
	return "Golem"

func take_damage(damage = 2):
	health -= damage
	animation_player.play("Flash")

func _ready():
	health = MAX_HEALTH

func _physics_process(_delta):
	if health > 0:
		sprite.play("Attack")
		if cooldown_timer.is_stopped():
			_spawn_wave(direction)
			cooldown_timer.start()
			attack_sfx.play()
	else:
		hitbox.disabled = true
		if death_timer.is_stopped():
			death_timer.start()
		
	_handle_animation_state()

func _handle_animation_state():
	animation_tree.set("parameters/state/current", health <= 0)
	#animation_tree.set("parameters/alive_transition/current", !cooldown_timer.is_stopped())

func _spawn_wave(dir):
	var wave = WAVE.instance()
	get_parent().add_child(wave)
	wave.global_position = wave_position.global_position
	wave.set_direction(dir)

func _on_DeathTimer_timeout():
	queue_free()
