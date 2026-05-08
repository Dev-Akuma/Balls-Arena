extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Game_Assets/main_menu.tscn")

## level group
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Playground_Asset/playground.tscn")
