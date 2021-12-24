extends Area2D

const SCORE = 50

onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D
onready var sfx = $SFX

func get_score():
	return SCORE

func _ready():
	sfx.volume_db = -10

func _on_Rune_body_entered(body):
	if body.name == "Player":
		body.score += SCORE
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false
		sfx.play()
		yield(sfx, "finished")
		queue_free()
