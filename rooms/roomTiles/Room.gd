class_name Room extends Node2D

@export var tile_name: String = 'Healing_room'

@onready var tile_sprite = $TileSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_sprite.texture = GlobalVariables.Cards[tile_name].image

