extends Node2D

@onready var nav = $TileNav

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#pathfinding.create_navigation_map(nav)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
