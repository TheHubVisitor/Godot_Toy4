extends CharacterBody2D

@onready var lives_label = get_node("/root/Toy4/HUD/LivesLabel")
@export var can_shoot : bool = false

signal shoot

var input : Vector2
var speed : float
var screen_size : Vector2
var health : int

var boost_factor : int = 1
var quick_shots_remaining = 0

func _ready():
	screen_size = get_viewport_rect().size
	health = settings.PLAYER_HEALTH
	if not is_in_group("players"):
		add_to_group("players")
	reset()

func reset():
	#can_shoot = true
	speed = settings.PLAYER_SPEED * get_tile_speed() * boost_factor
	quick_shots_remaining = 0

	$ShotTimer.wait_time = settings.NORMAL_SHOT
	$BoostIndicator.visible = false
	$QuickFireIndicator.visible = false
	$SFX/TakeDamage.stop()
	$SFX/Die.stop()
	
	separate_from_others()

func separate_from_others():
	var players = get_tree().get_nodes_in_group("players")
	for p in players:
		if p != self:
			var distance = global_position.distance_to(p.global_position)
			if distance < 10:
				var push_direction = (global_position - p.global_position).normalized()
				move_and_collide(push_direction * 5)

func take_damage():
	health -= settings.ENEMY_DAMAGE
	settings.total_lives -= settings.ENEMY_DAMAGE
	$SFX/TakeDamage.play()
	explode()
	
	if health == 0:
		can_shoot = false
		$SFX/Die.play()
		await $SFX/Die.finished
		queue_free()

func get_input():
	input.x =  Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y =  Input.get_action_strength("Down") - Input.get_action_strength("Up")

	#mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir, self)
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
	if self == get_tree().get_first_node_in_group("players") and modulate.a < 1.0:
		modulate.a = 1.0
		name = "Player"
		print("New main player assigned: ", name)
	
	if settings.game_start:
		#player movement
		var player_input = get_input()
		speed = settings.PLAYER_SPEED * get_tile_speed() * boost_factor
		
		if player_input != Vector2.ZERO:
			velocity = velocity.lerp(player_input * speed, settings.PLAYER_ACCEL * delta)
		else:
			velocity = velocity.lerp(Vector2.ZERO, settings.FRICTION * delta)

		move_and_slide()
		
		separate_from_others()

		# Get camera viewport bounds
		var camera = get_viewport().get_camera_2d()
		if camera:
			# Clamp player position within camera view
			position.x = clamp(position.x, camera.limit_left, camera.limit_right)
			position.y = clamp(position.y, camera.limit_top, camera.limit_bottom - 50)
		
		# player rotation
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

func explode():
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.global_position = global_position
	explosion.color = Color(1, 0, 0)
	get_parent().add_child(explosion)

func boost():
	$BoostIndicator.visible = true
	boost_factor = 2
	$SFX/Boost.play()
	$BoostTimer.start()

func quick_fire():
	$QuickFireIndicator.visible = true
	quick_shots_remaining = 5
	$SFX/QuickFire.play()
	$FastFireTimer.start()
	$ShotTimer.wait_time = settings.FAST_SHOT

func extra_life():
	settings.PLAYER_HEALTH += 1
	lives_label.text = "X " + str(settings.PLAYER_HEALTH)
	$SFX/Life.play()

func record_shot():
	if quick_shots_remaining > 0:
		quick_shots_remaining -= 1

	if quick_shots_remaining > 0:
		$ShotTimer.wait_time = settings.FAST_SHOT
	else:
		$ShotTimer.wait_time = settings.NORMAL_SHOT
		$QuickFireIndicator.visible = false

func _on_shot_timer_timeout():
	can_shoot = true

func _on_boost_timer_timeout():
	boost_factor = 1
	$BoostIndicator.visible = false

func _on_fast_fire_timer_timeout():
	$ShotTimer.wait_time = settings.NORMAL_SHOT
	$QuickFireIndicator.visible = false
