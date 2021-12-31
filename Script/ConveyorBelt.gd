extends StaticBody2D

export(int) var speed = 100

onready var sprite = $Sprite

func _ready():
	constant_linear_velocity.x = speed

func _process(delta):
	sprite.texture.region.position.x -= speed * delta
