extends Panel

var occupied = null
var slot_index

func occupySlot(room, card):
	room.position = Vector2(64, 64)
	room.tile_name = card
	add_child(room)
