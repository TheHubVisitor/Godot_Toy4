extends Node2D

@export var player_scene: PackedScene = preload("res://player.tscn")
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")

func _ready():
	print("---MainScene Ready---")
	start_wave(1)
	$GameUI/RestartButton.pressed.connect(restart_game)

func start_wave(wave_number: int = 1):
	print("Starting Wave:", wave_number)
	# Update wave settings
	settings.apply_wave_settings(wave_number)

	var player = get_tree().get_first_node_in_group("players")
	player.reset()
	clear_clones()
	# Spawn clones
	if wave_number > 1:
		print("Spawning Clones: ", wave_number - 1)
		spawn_clones(wave_number - 1)
		await get_tree().process_frame
		print("Total # clones: ", get_tree().get_nodes_in_group("players").size() - 1)
	else:
		print("Not spawning clones for Wave 1")
	$Spawner/Timer.wait_time = settings.SPAWN_INTERVAL
	reset()

func reset():
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	# Update HUD
	$HUD.visible = true
	$HUD/LivesLabel.text = "X " + str(settings.total_lives)
	$HUD/WaveLabel.text = "WAVE: " + str(settings.current_wave)
	$HUD/EnemiesLabel.text = "X " + str(settings.NUMBER_ENEMIES)

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func spawn_clones(num_clones):
	var radius = 100  # Increase distance between clones
	var angle_step = TAU / num_clones  # Spread clones evenly
	var player = get_tree().get_first_node_in_group("players")

	# Spawn clones, but limit to available positions
	for i in range(num_clones):
		# Place clones in a circular formation around the main player
		var new_clone = player_scene.instantiate()
		var angle = i * angle_step
		var offset = Vector2(cos(angle), sin(angle)) * radius
		if player:
			new_clone.global_position = player.global_position + offset
		else:
			print("Error: No active main player found!")
		
		new_clone.can_shoot = true
		new_clone.modulate.a = 0.6
		get_parent().add_child.call_deferred(new_clone)
		new_clone.shoot.connect(_on_player_shoot)
		new_clone.add_to_group("players")
		
		print("Clone ", i, " created at: ", new_clone.global_position, " Visible:", new_clone.visible)

func clear_clones():
	var players = get_tree().get_nodes_in_group("players")
	
	if players.size() > 1:
		var first = players[0]
		for p in players:
			if p != first:
				p.queue_free()

func _on_player_shoot(pos, dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")

func _process(_delta):
	if is_wave_completed():
		if settings.current_wave == settings.NUMBER_WAVES:
			$GameUI/GameOverLabel.text = "CONGRATULATIONS!"
			$GameUI/GameOverLabel.visible = true
			$GameUI/WavesSurvivedLabel.text = "You've Survived All " + str(settings.current_wave) + " Waves"
			$GameUI/WavesSurvivedLabel.visible = true
			$GameUI/RestartButton.visible = true
			$GameUI/Panel.visible = true
			$HUD.visible = false
		else:
			start_wave(settings.current_wave + 1)
	else:
		$HUD/LivesLabel.text = "X " + str(settings.total_lives)
		if settings.total_lives <= 0:
			$GameUI/GameOverLabel.text = "GAME OVER!"
			$GameUI/GameOverLabel.visible = true
			$GameUI/WavesSurvivedLabel.text = "Waves Survived: " + str(settings.current_wave - 1)
			$GameUI/WavesSurvivedLabel.visible = true
			$GameUI/RestartButton.visible = true
			$GameUI/Panel.visible = true
			$HUD.visible = false
			get_tree().paused = true

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
	
