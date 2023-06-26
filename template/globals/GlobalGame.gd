extends Node

# INITIAL VARIABLES
@onready var currentMap: String
@onready var currentPosition: String




func _ready():
	pass # Replace with function body.


func to_dictionary():
	return {
		"level": "1",
		"monsters slain": "500"
	}	
	
func from_dictionary(data):
	print("game data:")
	print(data)
