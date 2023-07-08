extends Panel

var occupied = null
var slot_index

func occupySlot(room):
	room.position = Vector2(64, 64)
	add_child(room)
