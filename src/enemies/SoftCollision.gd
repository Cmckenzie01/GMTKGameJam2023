extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		pass
	return #push_vector
		
