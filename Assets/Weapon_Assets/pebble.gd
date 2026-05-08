extends Node2D

var projectile_scene = preload(
	"res://Assets/Weapon_Assets/pebble_projectile.tscn"
)



func _ready():
	$Timer.start()


func _on_timer_timeout():

	var target = find_nearest_enemy()

	if target:
		fire(target)



func fire(target):

	var p = projectile_scene.instantiate()

	get_tree().current_scene.add_child(p)

	var dir = (
		target.global_position -
		global_position
	).normalized()

	p.global_position = global_position + dir * 25

	p.shooter = get_parent()

	p.initialize(dir)


func find_nearest_enemy():

	var fighters = get_tree().get_nodes_in_group("fighters")

	var nearest = null
	var best_distance = INF


	for f in fighters:

		if f == get_parent():
			continue

		var d = global_position.distance_to(
			f.global_position
		)

		if d < best_distance:
			best_distance = d
			nearest = f


	return nearest
