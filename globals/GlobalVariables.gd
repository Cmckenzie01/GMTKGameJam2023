extends Node

func read_json_file(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		assert(!json.parse(file.get_as_text()))
		return json.get_data()

@onready var EventData: Dictionary = read_json_file('res://data/events.json')

@onready var DungeonSequence: Array = []

@onready var DungeonFloors: Array = [preload("res://levels/three_room_dungeon.tscn")]#[preload("res://levels/three_room_dungeon.tscn"), preload("res://levels/four_room_dungeon.tscn"), preload("res://levels/five_room_dungeon.tscn")]

@export var dark_lord_title = 'Your Malevolence'

@export var heal_amount = 50

enum CardType {
	TILE,
	BUFF
}

const Cards: Dictionary = {
	# Dungeon Tiles
	"TrapRoom": {
		"name": "TrapRoom",
		"image": preload('res://assets/floors/trap_room.png'),
		"description": "A room with a Trap!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"CombatRoom": {
		"name": "CombatRoom",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room to die in!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"PuzzleRoom": {
		"name": "PuzzleRoom",
		"image": preload('res://assets/floors/puzzle_room.png'),
		"description": "A Room with a Puzzle in it!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"SocialRoom": {
		"name": "SocialRoom",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a social dynamic!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"EnvironmentalRoom": {
		"name": "EnvironmentalRoom",
		"image": preload('res://assets/floors/environment_room.png'),
		"description": "A Room with some natural wonder!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"RichesRoom": {
		"name": "RichesRoom",
		"image": preload('res://assets/Floors/Treasure_Room.png'),
		"description": "A Room with something shiny!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"KnowledgeRoom": {
		"name": "KnowledgeRoom",
		"image": preload('res://assets/Floors/Knowledge_Room.png'),
		"description": "A Room with some history!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"HonourRoom": {
		"name": "HonourRoom",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a much deserved Shop!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"GloryRoom": {
		"name": "GloryRoom",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with some glory!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"HealRoom": {
		"name": "HealRoom",
		"image": preload('res://assets/floors/healing_room.png'),
		"description": "A Room to relax in!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
}

# Cards will be added to this list, since we don't load and save, we don't need to keep a copy of
# the original starting deck
var Deck = [
	"TrapRoom",
	"TrapRoom",
	"CombatRoom",
	"CombatRoom",
	"RichesRoom",
	"GloryRoom",
	"HealRoom",
]

var SideDeck = [
	"TrapRoom",
	"TrapRoom",
	"CombatRoom",
]

@onready var tile_selected = null
@onready var dungon_built: bool = false
