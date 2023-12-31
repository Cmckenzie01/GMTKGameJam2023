extends Node2D

signal all_dungeon_slots_occupied
signal room_set_in_slot_successfully

const SlotClass = preload("res://levels/empty_dungeon_room.gd")

@export var tile_cards_path =  "GUI/CardUI/TileCards/"

@onready var empty_dungeon_room = preload("res://levels/empty_dungeon_room.tscn")
@onready var grid_size = 128
@onready var grid_offset = Vector2(int($GridSystem.global_position.x), int($GridSystem.global_position.y))

@onready var gridSystem: TileMap = $GridSystem
@onready var empty_dungeon_rooms

@onready var x_coord = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
@onready var y_coord = [0, 1, 2, 3, 4, 5]

@onready var no_of_rooms: int = 0
@onready var no_of_rooms_occupied: int = 0

@onready var default_room = preload("res://rooms/roomTiles/Room.tscn")

@onready var room_sequence: Array = []

func _ready():
	for x in x_coord:
		for y in y_coord:
			if gridSystem.get_cell_source_id(0, Vector2i(x, y)) == 0:
				var slot = empty_dungeon_room.instantiate()
				$RoomContainer.add_child(slot)
				slot.global_position = Vector2(x * grid_size, y * grid_size) + + grid_offset
				slot.gui_input.connect(_on_empty_dungeon_room_gui_input.bind(slot))
				slot.slot_index = len(room_sequence)
				room_sequence.append(null)
				no_of_rooms += 1

func _on_empty_dungeon_room_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and GlobalVariables.tile_selected:
		var room = default_room.instantiate()
		var tile = GlobalVariables.tile_selected
		var tile_name = tile.card_name
		var tile_id = tile.name
		slot.occupySlot(room, tile_name)
		room_sequence[slot.slot_index] = tile_name
		slot.gui_input.disconnect(_on_empty_dungeon_room_gui_input)
		GlobalVariables.tile_selected.queue_free()
		GlobalVariables.tile_selected = null

		#placeholder logic
		no_of_rooms_occupied += 1
		if no_of_rooms == no_of_rooms_occupied:
			GlobalVariables.DungeonSequence = room_sequence
			GlobalVariables.dungon_built = true
			all_dungeon_slots_occupied.emit()
