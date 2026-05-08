extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("fighters").size() == 1:
		print("Winner")
		get_tree().paused = true
