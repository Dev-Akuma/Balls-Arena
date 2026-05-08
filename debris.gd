extends Node2D

var velocity = Vector2.ZERO
var rotation_speed = 0.0

func _ready():

	randomize()

	# Random movement
	var angle = randf_range(0, TAU)

	var speed = randf_range(20, 80)

	velocity = Vector2.RIGHT.rotated(angle) * speed

	# Random rotation
	rotation_speed = randf_range(-1.0, 1.0)

	# Random scale
	scale = Vector2.ONE * randf_range(2.0, 4.0)

	# Transparency
	modulate.a = randf_range(0.3, 0.8)


func _process(delta):

	position += velocity * delta

	rotation += rotation_speed * delta

	# Despawn if too far away
	var screen_size = get_viewport_rect().size

	if position.x < -200 \
	or position.x > screen_size.x + 200 \
	or position.y < -200 \
	or position.y > screen_size.y + 200:

		queue_free()
