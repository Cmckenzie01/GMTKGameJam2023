class_name Room extends Node2D

@export var room_name: String = 'Test Room'

@onready var room_name_node = $RoomName
@onready var icon_node = $Icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.room_name_node.text = self.room_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
