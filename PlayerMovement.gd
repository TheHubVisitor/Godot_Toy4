extends CharacterBody2D

signal shoot

var can_shoot : bool
var input: Vector2
var speed : int
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func reset():
	can_shoot = true
	speed = settings.PLAYER_SPEED
	$ShotTimer.wait_time = settings.NORMAL_SHOT

func get_input():
	input.x =  Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y =  Input.get_action_strength("Down") - Input.get_action_strength("Up")

	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		print("shoot1")
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$ShotTimer.start()

	return input.normalized()

func get_tile_speed():
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("Tilemap")
	#Getting tilemap layer
	if not tilemap:
		return 1
	#If your not on the tilemap
	var cell := tilemap.local_to_map(position)
	#current tile that you are on
	var data: TileData = tilemap.get_cell_tile_data(cell)
	#get data for this tile
	if data: 
		var tile_speed: float = data.get_custom_data("Terrain")
		if tile_speed > 0:
			return tile_speed
	#If there is data on this tile, use that data
	return 1
	#In any other circumstance, use the base velocity.

func _physics_process(delta):
	#player movement
	var playerInput = get_input()
	speed = settings.PLAYER_SPEED
	velocity = lerp(velocity, playerInput * speed * get_tile_speed(), delta)
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
	speed = settings.PLAYER_SPEED * settings.PLAYER_ACCEL

func quick_fire():
	$FastFireTimer.start()
	$ShotTimer.wait_time = settings.FAST_SHOT

func _on_shot_timer_timeout():
	can_shoot = true

func _on_boost_timer_timeout():
	speed = settings.PLAYER_SPEED

func _on_fast_fire_timer_timeout():
	$ShotTimer.wait_time = settings.NORMAL_SHOT
