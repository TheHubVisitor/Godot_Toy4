extends Node2D

@export var player_scene: PackedScene = preload("res://player.tscn")
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")

@onready var main_player = $Player

func _ready():
	start_wave()
	$GameUI/RestartButton.pressed.connect(restart_game)

func start_wave(wave_number: int = 1):
	print("Starting Wave:", wave_number)
	# Update wave settings
	settings.apply_wave_settings(wave_number)
	# Remove existing clones before creating new ones
	clear_clones()
	# Spawn clones
	spawn_clones(wave_number - 1)
	$Spawner/Timer.wait_time = settings.SPAWN_INTERVAL
	reset()

func reset():
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	# Update HUD
	$HUD.visible = true
	$HUD/LivesLabel.text = "X " + str(settings.PLAYER_HEALTH * settings.current_wave)
	$HUD/WaveLabel.text = "WAVE: " + str(settings.current_wave)
	$HUD/EnemiesLabel.text = "X " + str(settings.NUMBER_ENEMIES)

func restart_game():
	start_wave()
	# Hide Game UI
	$GameUI/WavesSurvivedLabel.visible = false
	$GameUI/GameOverLabel.visible = false
	$GameUI/RestartButton.visible = false
	$GameUI/Panel.visible = false

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
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
	
func _process(_delta):
	if is_wave_completed():
		start_wave(settings.current_wave + 1)

func _on_spawner_hit_p():
	settings.PLAYER_HEALTH -= settings.ENEMY_DAMAGE
	$HUD/LivesLabel.text = "X " + str(settings.PLAYER_HEALTH)
	if settings.PLAYER_HEALTH <= 0:
		$GameUI/WavesSurvivedLabel.text = "WAVES SURVIVED: " + str(settings.current_wave - 1)
		$GameUI/WavesSurvivedLabel.visible = true
		$GameUI/GameOverLabel.visible = true
		$GameUI/RestartButton.visible = true
		$GameUI/Panel.visible = true
		$HUD.visible = false

func is_wave_completed():
	var num_left = 0
	var enemies = get_tree().get_nodes_in_group("enemies")
	#check if all enemies have spawned first
	if enemies.size() == settings.NUMBER_ENEMIES:
		for e in enemies:
			if e.alive:
				num_left += 1
		return (num_left == 0)
	else:
		return false
	
