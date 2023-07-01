extends CharacterBody2D

@export var speed = 100
var Health = 10

func _process(delta):
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	
	if get_parent().get_progress_ratio() == 1:
		Game.Health -= 1
		death()
		
	if Health <= 0:
		Game.Gold += 1
		death()

func death():
	get_parent().get_parent().queue_free()
