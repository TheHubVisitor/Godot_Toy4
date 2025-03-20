extends Node2D

@onready var main = get_node("/root/Toy4")
var is_spawning = false
var enemy_scene := preload("res://enemy.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
			$LengthTimer.paused = true

func _on_timer_timeout() -> void:
	$LengthTimer.paused = false
	var is_spawning = true
	var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn.position
	main.add_child(enemy)
	EnemyCount.count += 1
	
	if $LengthTimer.timeout == true:
		$Timer.paused = true
		$LengthTimer.paused = true
		await EnemyCount.count == 0

# Make the spawner stop spawning after a certain period (scaling with wave)
func _on_length_timer_timeout() -> void:
	$LengthTimer.wait_time *= 1.5
