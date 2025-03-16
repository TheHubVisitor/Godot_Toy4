extends CharacterBody2D


const SPEED = 150
const WATER_SPEED = 60
const DEEP_WATER_SPEED = 30
const ACCEL = 2.0
var bullet_path = preload("res://Bullet.tscn")
var input: Vector2

func get_input():
	input.x =  Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y =  Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()
	#movement stuff
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
func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = rotation
	bullet.pos = $"../Node2D".global_position
	bullet.rota = global_rotation
	get_parent().add_child(bullet)
func _process(delta: float) -> void: 
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Shoot"):
		fire()
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED * get_tile_speed(), delta * ACCEL)
	move_and_slide()
