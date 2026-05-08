extends Area2D

var direction = Vector2.ZERO
var speed = 300
var damage = 1
var shooter

func initialize(dir):
	direction = dir*25


func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):

	# Don't hit shooter
	if body == shooter:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
