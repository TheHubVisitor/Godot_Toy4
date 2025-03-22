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
	$Panel.visible = false
	title_screen.visible = false
	settings.game_start = true
	enemy_timer.start()

func _on_restart_button_pressed() -> void:
	_on_start_button_pressed()
