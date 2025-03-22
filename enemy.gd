extends CharacterBody2D

@onready var main = get_node("/root/Toy4")
@onready var nav: NavigationAgent2D = $NavigationAgent2D

var explosion_scene := preload("res://explosion.tscn")
var item_scene := preload("res://drop_item.tscn")

var alive : bool
var direction : Vector2
var collision_cooldown = false

func _ready():
	alive = true
	$Damagebox.add_to_group("damageboxes")

func _physics_process(delta):
	if alive and settings.game_start:
		$AnimatedSprite2D.animation = "Run"
		
		var players = get_tree().get_nodes_in_group("players")
		if players.size() > 0:
			# choose the closest target
			players.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
			nav.target_position = players[0].position
			direction = nav.get_next_path_position() - global_position
			velocity = velocity.lerp(direction.normalized() * settings.ENEMY_SPEED, delta * settings.ENEMY_ACCEL)
			move_and_slide()
		
			if velocity.x != 0:
				$AnimatedSprite2D.flip_h = velocity.x < 0

func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "Death"
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	if randf() <= settings.DROP_RATE:
		drop_item()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		collision_cooldown = true
		body.take_damage()
		
		# Set a short cooldown before another collision can trigger
		await get_tree().create_timer(0.5).timeout
		collision_cooldown = false
