extends Area2D

var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += settings.BULLET_SPEED * direction * delta

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	print(body.name)
	if body.name == "TileMapLayer" or body.name == "Tress":
		queue_free()
	elif body.name != "Enemy":
		if body.alive:
			body.die()
			queue_free()
