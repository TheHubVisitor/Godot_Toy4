extends CharacterBody2D

signal shoot

const SPEED = 120
const WATER_SPEED = 60
const DEEP_WATER_SPEED = 30
const ACCEL = 2.0
const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1

var can_shoot : bool
var input: Vector2
var speed : int
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func reset():
	can_shoot = true
	#position = screen_size / 2
	speed = SPEED
	$ShotTimer.wait_time = NORMAL_SHOT

func get_input():
	input.x =  Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y =  Input.get_action_strength("Down") - Input.get_action_strength("Up")

	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$ShotTimer.start()

	return input.normalized()

func _physics_process(delta):
	#player movement
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED, delta)
	move_and_slide()
	
	# Get camera viewport bounds
	var camera = get_viewport().get_camera_2d()
	if camera:
		# Clamp player position within camera view
		position.x = clamp(position.x, camera.limit_left, camera.limit_right)
		position.y = clamp(position.y, camera.limit_top, camera.limit_bottom - 20)
	
	#player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	#player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

func boost():
	$BoostTimer.start()
	speed = SPEED * ACCEL

func quick_fire():
	$FastFireTimer.start()
	$ShotTimer.wait_time = FAST_SHOT

func _on_shot_timer_timeout():
	can_shoot = true

func _on_boost_timer_timeout():
	speed = SPEED

func _on_fast_fire_timer_timeout():
	$ShotTimer.wait_time = NORMAL_SHOT
