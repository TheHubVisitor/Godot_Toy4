extends CharacterBody2D

@onready var main = get_node("/root/Toy4")
@onready var player = get_node("/root/Toy4/Player")
@onready var nav: NavigationAgent2D = $NavigationAgent2D

#var explosion_scene := preload("res://explosion.tscn")
var item_scene := preload("res://drop_item.tscn")

signal hit_player

var alive : bool
var direction : Vector2

func _ready():
	alive = true

func _physics_process(delta):
	if alive and settings.game_start:
		$AnimatedSprite2D.animation = "Run"
		nav.target_position = player.position
		direction = nav.get_next_path_position() - global_position
		velocity = velocity.lerp(direction.normalized() * settings.ENEMY_SPEED, delta * settings.ENEMY_ACCEL)
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "Dead"
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if randf() <= settings.DROP_RATE:
		drop_item()
	#var explosion = explosion_scene.instantiate()
	#explosion.position = position
	#main.add_child(explosion)
	#explosion.process_mode = Node.PROCESS_MODE_ALWAYS

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0, 2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func _on_area_2d_body_entered(_body):
	hit_player.emit()

