extends Node2D

@onready var path = preload("res://mini_game/basic_tower_defense/Mobs/Stage 1.tscn")

func _on_timer_timeout():
	var tempPath = path.instantiate()
	add_child(tempPath)
