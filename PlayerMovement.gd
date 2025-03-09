extends CharacterBody2D


const SPEED = 120
const WATER_SPEED = 60
const DEEP_WATER_SPEED = 30
const ACCEL = 2.0

var input: Vector2

func get_input():
	input.x =  Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y =  Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()
func _process(delta: float) -> void:
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	move_and_slide()
