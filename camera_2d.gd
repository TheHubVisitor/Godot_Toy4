extends Camera2D

@onready var player: Node2D = $"../Player"
@onready var player_body: CharacterBody2D = player.get_node("CharacterBody2D")

func _process(_delta: float) -> void:
	if player_body:
		position = player_body.global_position
