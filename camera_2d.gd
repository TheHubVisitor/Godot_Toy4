extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

func _process(_delta: float) -> void:
	position = player.global_position
