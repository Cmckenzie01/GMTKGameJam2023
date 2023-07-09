extends Node

func read_json_file(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		assert(!json.parse(file.get_as_text()))
		return json.get_data()

@onready var EventData: Dictionary = read_json_file('res://data/events.json')

@onready var DungeonSequence: Array = []

@onready var DungeonFloors: Array = [preload("res://levels/three_room_dungeon.tscn")]#[preload("res://levels/three_room_dungeon.tscn"), preload("res://levels/four_room_dungeon.tscn"), preload("res://levels/five_room_dungeon.tscn")]

@onready var DungeonTiles: Dictionary = {
	"TrapTile": {
		"name": "trap_room",
		"image": preload("res://assets/floors/trap_room.png"),
		"description": "A Room with a Trap!",
		"effects": [] # TODO: Make Effect
	},
	"CombatTile": {
		"name": "combat_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room to relax in!",
		"effects": [] # TODO: Make Effect
	},
	"PuzzleTile": {
		"name": "puzzle_room",
		"image": preload("res://assets/floors/puzzle_room.png"),
		"description": "A Room with a Puzzle in it!",
		"effects": [] # TODO: Make Effect
	},
	"SocialTile": {
		"name": "social_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room with a social dynamic!",
		"effects": [] # TODO: Make Effect
	},
	"EnvironmentalTile": {
		"name": "environmental_room",
		"image": preload("res://assets/floors/environment_room.png"),
		"description": "A Room with some natural wonder!",
		"effects": [] # TODO: Make Effect
	},
	"RicesTile": {
		"name": "riches_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room with something shiny!",
		"effects": [] # TODO: Make Effect
	},
	"KnowledgeTile": {
		"name": "Knowledge_room",
		"image": preload("res://assets/floors/Combat_room.png"),
		"description": "A Room with some history!",
		"effects": [] # TODO: Make Effect
	},
	"HonourTile": {
		"name": "honour_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room with a much deserved Shop!",
		"effects": [] # TODO: Make Effect
	},
	"GloryTile": {
		"name": "glory_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room with some glory!",
		"effects": [] # TODO: Make Effect
	},
	"HealTile": {
		"name": "healing_room",
		"image": preload("res://assets/floors/combat_room.png"),
		"description": "A Room to take a deserved rest in!",
		"effects": [] # TODO: Make Effect
	},
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
@onready var dungon_built: bool = false
