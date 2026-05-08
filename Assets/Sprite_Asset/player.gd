extends CharacterBody2D

@export var starting_weapon : PackedScene

## Player Stats
@export var max_hp = 10
var current_hp
@onready var hp: Label = $HP

## pull-launch mechanics
@export var launch_power = 4.0
@export var base_speed = 500.0        # Permanent minimum speed
@export var collision_decay = 0.90    # Lose 10% per collision

var drag_start = Vector2.ZERO
var drag_current = Vector2.ZERO

var aiming = false
var launched = false

func _input(event):
	
	if event.is_action_pressed("ui_accept"):
		take_damage(1)
	
	if launched:
		return

	if event is InputEventMouseButton:

		if event.pressed:
			drag_start = get_global_mouse_position()
			drag_current = drag_start
			aiming = true
			queue_redraw()

		else:
			if aiming:

				var drag_vector = drag_start - drag_current

				# Initial launch can exceed base speed
				velocity = drag_vector * launch_power

				# Ensure at least base speed
				if velocity.length() < base_speed:
					velocity = velocity.normalized() * base_speed

				launched = true
				aiming = false
				queue_redraw()

	elif event is InputEventMouseMotion:

		if aiming:
			drag_current = get_global_mouse_position()
			queue_redraw()




func _physics_process(delta):

	if launched:

		var collision_info = move_and_collide(velocity * delta)

		if collision_info:

			# Bounce off wall
			velocity = velocity.bounce(
				collision_info.get_normal()
			)

			# Reduce speed after collision
			var new_speed = velocity.length() * collision_decay

			# Never drop below base speed
			new_speed = max(new_speed, base_speed)

			velocity = velocity.normalized() * new_speed
##


func _draw():

	if aiming:

		var local_start = Vector2.ZERO
		var local_end = drag_start - drag_current

		draw_line(
			local_start,
			local_end,
			Color.RED,
			3.0
		)

		var dir = (local_end - local_start).normalized()

		var left = local_end - dir * 20 + dir.rotated(0.6) * 10
		var right = local_end - dir * 20 + dir.rotated(-0.6) * 10

		draw_line(local_end, left, Color.RED, 3)
		draw_line(local_end, right, Color.RED, 3)

func _ready() -> void:
	if starting_weapon:
		var weapon = starting_weapon.instantiate()
		$WeaponAnchor.add_child(weapon)
	
	current_hp = max_hp	
	update_hp_display()

func take_damage(amount):
	current_hp -= amount
	if current_hp < 0:
		current_hp = 0
	update_hp_display()
	if current_hp == 0:
		die()

func update_hp_display():
	hp.text = str(current_hp)

func die():
	queue_free()
