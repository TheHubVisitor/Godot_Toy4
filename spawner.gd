extends Node2D

@onready var main = get_node("/root/Toy4")

var enemy_scene := preload("res://enemy.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout():
	#check how many enemies have already been created
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < settings.NUMBER_ENEMIES:
		#pick random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]
		#spawn enemy
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn.position
		main.add_child(enemy)
		enemy.add_to_group("enemies")
		print("enemies spawned: ", enemies.size() + 1)
