extends Node2D

signal all_dungeon_slots_occupied

const SlotClass = preload("res://levels/empty_dungeon_room.gd")

@onready var empty_dungeon_room = preload("res://levels/empty_dungeon_room.tscn")
@onready var grid_size = 128
@onready var grid_offset = Vector2(int($GridSystem.global_position.x), int($GridSystem.global_position.y))

@onready var gridSystem: TileMap = $GridSystem
@onready var empty_dungeon_rooms

@onready var x_coord = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
@onready var y_coord = [0, 1, 2, 3, 4, 5]

@onready var no_of_rooms: int = 0
@onready var no_of_rooms_occupied: int = 0

@onready var test_room = preload("res://rooms/roomTiles/Room.tscn")

func _ready():
	for x in x_coord:
		for y in y_coord:
			if gridSystem.get_cell_source_id(0, Vector2i(x, y)) == 0:
				var slot = empty_dungeon_room.instantiate()
				$RoomContainer.add_child(slot)
				slot.global_position = Vector2(x * grid_size, y * grid_size) + + grid_offset
				slot.gui_input.connect(_on_empty_dungeon_room_gui_input.bind(slot))
				no_of_rooms += 1


func _on_empty_dungeon_room_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var room = test_room.instantiate()
		slot.occupySlot(room)
		slot.gui_input.disconnect(_on_empty_dungeon_room_gui_input)
		
		#placeholder logic
		no_of_rooms_occupied += 1
		if no_of_rooms == no_of_rooms_occupied:
			all_dungeon_slots_occupied.emit()
			print("all rooms occupied")
		
			
		
		
		
