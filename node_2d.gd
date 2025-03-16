extends Node2D

func _process(delta: float) -> void:
	self.global_position = Vector2($"../CharacterBody2D".global_position.x + 5, $"../CharacterBody2D".global_position.y)
	self.global_rotation = $"../CharacterBody2D".global_rotation
