extends Area2D

var hit_targets = {}

func _on_body_entered(body):

	if body == get_parent().weapon_owner:
		return

	if body in hit_targets:
		return

	if body.has_method("take_damage"):
		body.take_damage(1)

		hit_targets[body] = true

		await get_tree().create_timer(0.5).timeout

		hit_targets.erase(body)
