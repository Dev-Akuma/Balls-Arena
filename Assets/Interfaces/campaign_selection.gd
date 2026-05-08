extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Fade Transition/AnimationPlayer".play("Fade_out")
	await $"Fade Transition/AnimationPlayer".animation_finished
	$"Fade Transition".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



## level group
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Playground_Asset/playground.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Interfaces/main_menu.tscn")
