extends Node2D

@export var player_scene: PackedScene = preload("res://Player.tscn")
@export var bullet_scene: PackedScene = preload("res://Bullet.tscn")

@onready var main_player = $player

func _ready():
	start_wave(2)

func start_wave(wave_number):
	print("Starting Wave:", wave_number)	
	# Update wave settings
	settings.apply_wave_settings(wave_number)
	# Remove existing clones before creating new ones
	clear_clones()
	# Spawn clones
	spawn_clones(wave_number - 1)

func spawn_clones(num_clones):
	var clone_offsets = [
		Vector2(30, 0),  # Right
		Vector2(-30, 0),  # Left
		Vector2(0, -30),  # Up
		Vector2(0, 30)  # Down
	]

	# Spawn clones, but limit to available positions
	for i in range(min(num_clones, len(clone_offsets))):
		var new_clone = player_scene.instantiate()
		new_clone.global_position = main_player.global_position + clone_offsets[i]
		get_parent().add_child.call_deferred(new_clone)
		new_clone.shoot.connect(_on_player_shoot)
		
		print("Clone ", i, " created at: ", new_clone.global_position, " Visible:", new_clone.visible)

func clear_clones():
	for child in get_parent().get_children():
		if child is CharacterBody2D and child != main_player:
			child.queue_free()

func _on_player_shoot(pos, dir):
	print("shooting")
	
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
	
