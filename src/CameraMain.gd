extends Camera2D

@onready var player: CharacterBody2D = $"../player"

func _process(_delta: float) -> void:
	position = player.global_position
