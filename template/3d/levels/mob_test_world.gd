extends Node3D

var mob = preload("res://template/3d/enemies/mob.tscn")

func _ready():
	randomize()


func _on_timer_timeout():
	var m = mob.instantiate()
	add_child(m)
	m.start($Marker3D.transform)
