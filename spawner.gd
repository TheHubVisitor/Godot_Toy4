extends Node2D
@onready var main = get_node("/root/MainScene")
var goblin_scene := preload("res://Enemy.tscn")
var spawn_points := []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_timer_timeout():
	var spawn = spawn_points[randi() % spawn_points.size()]
	var goblin = goblin_scene.instantiate()
	goblin.position = spawn.position
	main.add.child(goblin)
