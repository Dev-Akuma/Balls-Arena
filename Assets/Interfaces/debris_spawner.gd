extends Node2D

@export var debris_scene : PackedScene
@export var debris_textures : Array[Texture2D]

func _ready():

	for i in range(15):

		spawn_debris()


func spawn_debris():

	var debris = debris_scene.instantiate()

	add_child(debris)

	# Random position
	var screen_size = get_viewport_rect().size

	debris.position = Vector2(
		randf_range(-100, screen_size.x+100),
		randf_range(-100, screen_size.y+100)
	)

	# Random texture
	debris.get_node("Sprite2D").texture = (
		debris_textures.pick_random()
	)
