extends Node2D

var item = "Potion"
var item_quantity = 3

@onready var killcount: int = 0

@onready var character = preload("res://template/2d/controllers/directionalMovement.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action"):
		var c = character.instantiate()
		c.position = Vector2(550, 550)
		$PlayerSpawner.add_child(c)



