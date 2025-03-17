extends CharacterBody2D
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@export var chase_target : CharacterBody2D
var speed = 180
var accel = 7


func _physics_process(delta: float) -> void:
	var direction = Vector2()
	navigation_agent.target_position = chase_target.global_position
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed , accel * delta)
	move_and_slide()


func _on_timer_timeout() -> void:
	navigation_agent.set_target_position(chase_target.global_position)
