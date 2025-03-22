extends Area2D

@onready var main = get_node("/root/Toy4")

var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += settings.BULLET_SPEED * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.name == "TileMapLayer" or body.name == "Tress":
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageboxes"):
		var enemy = area.get_parent()
		if "alive" in enemy and enemy.alive:
			enemy.die()
			main.on_enemy_died()
			queue_free()
