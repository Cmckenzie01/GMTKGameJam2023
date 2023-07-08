class_name Room extends Node2D
 

@export var room_name: String = 'Test Room' # TODO The room's "type", e.g. spike trap.
                                            # Unless we want to do multiple kinds of spike trap, for instance, 
                                            # some of which are tougher or have other effects?

@onready var room_name_node = $RoomName
@onready var icon_node = $Icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.room_name_node.text = self.room_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
