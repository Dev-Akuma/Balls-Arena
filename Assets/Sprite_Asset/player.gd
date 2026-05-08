extends CharacterBody2D

@export var starting_weapon : PackedScene

## =========================
## PLAYER STATS
## =========================

@export var max_hp = 10
var current_hp

@onready var hp: Label = $HP

## =========================
## MOVEMENT
## =========================

@export var launch_power = 4.0
@export var base_speed = 500.0
@export var max_speed = 1200.0
@export var collision_decay = 0.90

## Relaunch control
@export var relaunch_cooldown := 0.35

var can_relaunch = true

## Dragging
var drag_start = Vector2.ZERO
var drag_current = Vector2.ZERO

var aiming = false
var launched = false

## =========================
## INPUT
## =========================

func _input(event):

	if event.is_action_pressed("ui_accept"):
		take_damage(1)

	# -------------------------
	# Mouse Button
	# -------------------------
	if event is InputEventMouseButton:

		# LEFT CLICK PRESS
		if event.pressed:

			if can_relaunch:

				drag_start = get_global_mouse_position()
				drag_current = drag_start

				aiming = true
				queue_redraw()

		# LEFT CLICK RELEASE
		else:

			if aiming:

				var drag_vector = drag_start - drag_current

				# ADD impulse instead of replacing velocity
				velocity += drag_vector * launch_power

				# Clamp maximum speed
				if velocity.length() > max_speed:
					velocity = velocity.normalized() * max_speed

				# Maintain minimum speed
				if velocity.length() < base_speed:
					velocity = velocity.normalized() * base_speed

				launched = true
				aiming = false

				queue_redraw()

				# Relaunch cooldown
				start_relaunch_cooldown()

	# -------------------------
	# Mouse Motion
	# -------------------------
	elif event is InputEventMouseMotion:

		if aiming:
			drag_current = get_global_mouse_position()
			queue_redraw()


## =========================
## PHYSICS
## =========================

func _physics_process(delta):

	if launched:

		var collision_info = move_and_collide(velocity * delta)

		if collision_info:

			# Bounce
			velocity = velocity.bounce(
				collision_info.get_normal()
			)

			# Slight speed decay
			var new_speed = velocity.length() * collision_decay

			# Maintain minimum speed
			new_speed = max(new_speed, base_speed)

			velocity = velocity.normalized() * new_speed


## =========================
## AIM DRAWING
## =========================

func _draw():

	if aiming:

		var local_start = Vector2.ZERO
		var local_end = drag_start - drag_current

		# Main line
		draw_line(
			local_start,
			local_end,
			Color.RED,
			3.0
		)

		# Arrow
		var dir = (local_end - local_start).normalized()

		var left = local_end - dir * 20 + dir.rotated(0.6) * 10
		var right = local_end - dir * 20 + dir.rotated(-0.6) * 10

		draw_line(local_end, left, Color.RED, 3)
		draw_line(local_end, right, Color.RED, 3)


## =========================
## READY
## =========================

func _ready() -> void:

	# Spawn weapon
	if starting_weapon:

		var weapon = starting_weapon.instantiate()

		$WeaponAnchor.add_child(weapon)

	current_hp = max_hp

	update_hp_display()


## =========================
## HP SYSTEM
## =========================

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


## =========================
## RELAUNCH COOLDOWN
## =========================

func start_relaunch_cooldown():

	can_relaunch = false

	await get_tree().create_timer(
		relaunch_cooldown
	).timeout

	can_relaunch = true
