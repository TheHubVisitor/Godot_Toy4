extends Camera2D

func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("players")
	if player:
		position = player.global_position
