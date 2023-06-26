extends CharacterBody2D

const ACCELERATION = 15000
const MAX_SPEED = 625
var item_name

var player = null
var being_picked_up = false

func _ready():
	item_name = "Slime Potion"
	
func _physics_process(delta):
	if being_picked_up == false:
		pass
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		var distance = global_position.distance_to(player.global_position)
		if distance < 40:
			GlobalInventory.add_item(item_name, 1)
			queue_free()
	move_and_slide()
	
func pick_up_item(body):
	player = body
	being_picked_up = true
	

		
