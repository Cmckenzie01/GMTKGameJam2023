extends Node

func read_json_file(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		print(file.get_as_text())
		var json = JSON.new()
		assert(!json.parse(file.get_as_text()))
		return json.get_data()

@onready var EventData: Dictionary = read_json_file('res://data/events.json')


@onready var DungeonFloors: Dictionary = {
	"ThreeFloors": {},
	"FourFloors": {},
	"FiveFloors": {},
}

@onready var DungeonTiles: Dictionary = {
	"TileOne": {
		"name": "spike_trap",
		"image": preload('res://assets/Cards/pig.jpg'),
		"description": "I'm a card! Look at me! Card card card!",
		"effects": [] # TODO: Make Effect
	},
	"TileTwo": {
		"name": "Healing_Room",
		"image": preload('res://assets/sprites/Placeholder.png'),
		"description": "But am I a card? Really? When you think about it?",
		"effects": [] # TODO: Make Effect
	},
	"TileThree": {
		"name": "Weapon_Upgrade_Room",
		"image": preload('res://assets/Cards/pig.jpg'),
		"description": "It's okay, I'm a card! You can true me!",
		"effects": [] # TODO: Make Effect
	},
	"TileFour": {},
	"TileFive": {},
	"TileSix": {},
	"TileSeven": {},
	"TileEight": {},
	"TileNine": {},
	"TileTen": {},
}

@onready var BuffCards: Dictionary = {
	"CardOne": {},
	"CardTwo": {},
	"CardThree": {},
	"CardFour": {},
	"CardFive": {},
	"CardSix": {},
	"CardSeven": {},
	"CardEight": {},
	"CardNine": {},
	"CardTen": {},
}

@onready var tile_selected = null
