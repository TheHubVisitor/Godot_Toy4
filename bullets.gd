extends CharacterBody2D
var pos:Vector2
var rota:float
var dir: float
var speed = 2000
@onready var timer = $Timer
func _ready():
	global_position = pos
	global_rotation = rota
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	

func _on_timer_timeout() -> void:
	self.queue_free()
