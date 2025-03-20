extends Area2D

@onready var main = get_node("/root/Toy4")
@onready var lives_label = get_node("/root/Toy4/HUD/LivesLabel")

var item_type : int # 0: coffee, 1: health, 2: gun

var coffee_box = preload("res://assets/items/coffee_box.png")
var health_box = preload("res://assets/items/health_box.png")
var gun_box = preload("res://assets/items/gun_box.png")
var textures = [coffee_box, health_box, gun_box]

func _ready():
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	if body == get_tree().get_first_node_in_group("players"):
		# coffee
		if item_type == 0:
			body.boost()
		# health
		elif item_type == 1:
			settings.PLAYER_HEALTH += 1
			lives_label.text = "X " + str(settings.PLAYER_HEALTH)
		# gun
		elif item_type == 2:
			body.quick_fire()
		# delete item
		queue_free()
