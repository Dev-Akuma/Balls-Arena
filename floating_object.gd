extends CharacterBody2D

@export var speed := 150.0

func _ready():

	randomize()

	var angle = randf_range(0, TAU)

	velocity = Vector2.RIGHT.rotated(angle) * speed


func _physics_process(delta):

	var collision = move_and_collide(
		velocity * delta
	)

	if collision:

		velocity = velocity.bounce(
			collision.get_normal()
		)

		rotation += randf_range(-0.2, 0.2)
