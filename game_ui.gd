extends CanvasLayer

@onready var restart = $RestartButton
@onready var title_screen = $TitleScreen
@onready var credit_screen = $CreditsScreen

func _on_credits_button_pressed() -> void:
	print("show credits")
	credit_screen.visible = true
	title_screen.visible = false
	settings.game_start = false

func _on_back_button_pressed() -> void:
	print("high credits")
	credit_screen.visible = false
	title_screen.visible = true
	settings.game_start = false

func _on_start_button_pressed() -> void:
	print("start game")
	$Panel.visible = false
	title_screen.visible = false
	settings.game_start = true
