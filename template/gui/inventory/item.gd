extends Node2D

var item_name
var item_quantity


func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "Mushroom"
	elif rand_val == 1:
		item_name = "Rock"
	else:
		item_name = "Slime Potion"
		
	$TextureRect.texture = load("res://assets/gui/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = str(item_quantity)
		if item_quantity == 1:
			$Label.visible = false 
		
func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://assets/gui/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)
		if item_quantity == 1:
			$Label.visible = false
		
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)
