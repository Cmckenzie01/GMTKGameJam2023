extends Node

func read_json_file(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		print(file.get_as_text())
		var json = JSON.new()
		assert(!json.parse(file.get_as_text()))
		return json.get_data()

@onready var EventData: Dictionary = read_json_file('res://data/events.json')


@onready var DungeonFloors: Dictionary = {
	"ThreeRoomFloor": {
		"scene": preload("res://levels/three_room_dungeon.tscn")
	},
	"FourRoomFloor": {
		"scene": preload("res://levels/four_room_dungeon.tscn")
	},
	"FiveRoomFloor": {
		"scene": preload("res://levels/five_room_dungeon.tscn")
	},
}

enum CardType {
	TILE,
	BUFF
}

const Cards: Dictionary = {
	# Dungeon Tiles
	"TrapRoom": {
		"name": "trap_room",
		"image": preload('res://assets/floors/trap_room.png'),
		"description": "A room with a Trap!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"CombatRoom": {
		"name": "combat_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room to relax in!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"PuzzleRoom": {
		"name": "puzzle_room",
		"image": preload('res://assets/floors/puzzle_room.png'),
		"description": "A Room with a Puzzle in it!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"SocialRoom": {
		"name": "social_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a social dynamic!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"EnvironmentalRoom": {
		"name": "environmental_room",
		"image": preload('res://assets/floors/environment_room.png'),
		"description": "A Room with some natural wonder!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"RichesRoom": {
		"name": "riches_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with something shiny!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"KnowledgeRoom": {
		"name": "knowledge_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with some history!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"HonourRoom": {
		"name": "honour_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a much deserved Shop!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"GloryRoom": {
		"name": "glory_room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with some glory!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"HealRoom": {
		"name": "Healing_Room",
		"image": preload('res://assets/floors/healing_room.png'),
		"description": "But am I a card? Really? When you think about it?",
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

@onready var tile_selected = null
