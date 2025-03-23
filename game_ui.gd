extends CanvasLayer

@onready var restart = $RestartButton
@onready var title_screen = $TitleScreen
@onready var credit_screen = $CreditsScreen
@onready var enemy_spawner = $"../Spawner"
@onready var enemy_timer = enemy_spawner.get_node("Timer")

func _on_credits_button_pressed() -> void:
	print("show credits")
	credit_screen.visible = true
	title_screen.visible = false
	settings.game_start = false

func _on_back_button_pressed() -> void:
	print("hide credits")
	credit_screen.visible = false
	title_screen.visible = true
	settings.game_start = false

func _on_start_button_pressed() -> void:
	print("start game")
	$"../BGMusic".play()
	$Panel.visible = false
	title_screen.visible = false
	settings.game_start = true
	enemy_timer.start()
	
	await get_tree().create_timer(1).timeout
	var players = get_tree().get_nodes_in_group("players")
	for p in players:
		p.can_shoot = true

func _on_restart_button_pressed() -> void:
	_on_start_button_pressed()
