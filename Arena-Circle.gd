extends Node2D

@export var radius := 300.0
@export var segments := 32
@export var wall_thickness := 12.0

# Visual settings
@export var line_width := 6.0
@export var glow_color := Color(0.3, 0.7, 1.0, 1.0)

func _ready():
	create_arena()


func create_arena():

	var points = []

	var angle_step = TAU / segments

	# Generate points
	for i in range(segments + 1):

		var angle = i * angle_step

		var point = Vector2(
			cos(angle),
			sin(angle)
		) * radius

		points.append(point)

	# Create collision walls
	for i in range(segments):

		create_wall_segment(
			points[i],
			points[i + 1]
		)

	# Create glowing visual border
	create_glow_border(points)


func create_wall_segment(start: Vector2, end: Vector2):

	var wall = StaticBody2D.new()
	add_child(wall)

	var collision = CollisionShape2D.new()
	wall.add_child(collision)

	var shape = RectangleShape2D.new()

	var length = start.distance_to(end)

	shape.size = Vector2(length, wall_thickness)

	collision.shape = shape

	# Position
	wall.position = (start + end) / 2

	# Rotation
	wall.rotation = start.angle_to_point(end)

	# Physics material
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0
	physics_material.friction = 0.0

	wall.physics_material_override = physics_material


func create_glow_border(points):

	# Main bright line
	var line = Line2D.new()
	add_child(line)

	line.width = line_width
	line.default_color = glow_color
	line.closed = true

	for point in points:
		line.add_point(point)

	# Soft outer glow
	var glow = Line2D.new()
	add_child(glow)

	glow.width = line_width * 2.5
	glow.default_color = Color(
		glow_color.r,
		glow_color.g,
		glow_color.b,
		0.15
	)

	glow.closed = true

	for point in points:
		glow.add_point(point)
