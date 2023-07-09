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
	"Trap Room": {
		"name": "Trap Room",
		"image": preload('res://assets/floors/trap_room.png'),
		"description": "A room with a Trap!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Combat Room": {
		"name": "Combat Room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room to die in!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Puzzle Room": {
		"name": "Puzzle Room",
		"image": preload('res://assets/floors/puzzle_room.png'),
		"description": "A Room with a Puzzle in it!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Social Room": {
		"name": "Social Room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a social dynamic!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Environmental Room": {
		"name": "Environmental Room",
		"image": preload('res://assets/floors/environment_room.png'),
		"description": "A Room with some natural wonder!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Riches Room": {
		"name": "Riches Room",
		"image": preload('res://assets/floors/Treasure_Room.png'),
		"description": "A Room with something shiny!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Knowledge Room": {
		"name": "Knowledge Room",
		"image": preload('res://assets/floors/Knowledge_Room.png'),
		"description": "A Room with some history!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Honour Room": {
		"name": "Honour Room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with a much deserved Shop!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Glory Room": {
		"name": "Glory Room",
		"image": preload('res://assets/floors/combat_room.png'),
		"description": "A Room with some glory!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Heal Room": {
		"name": "Heal Room",
		"image": preload('res://assets/floors/healing_room.png'),
		"description": "A Room to relax in!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Heal Potion": {
		"name": "Heal Potion",
		"image": preload('res://assets/Health Potion.png'),
		"description": "A succulent health potion!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Motivation Potion": {
		"name": "Motivation Potion",
		"image": preload('res://assets/Motivation Potion.png'),
		"description": "Delicious coffee!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	},
	"Exp Boost": {
		"name": "Exp Boost",
		"image": preload('res://assets/Exp_Boost.png'),
		"description": "Download the wisdom of the ages!",
		"effects": [], # TODO: Make Effect
		"type": CardType.TILE,
	}
}

var HardCodedDungeonCardsBecauseTimeRestraints: Array = ["TrapRoom", "CombatRoom", "PuzzleRoom", "SocialRoom", "EnvironmentalRoom", "RichesRoom", "KnowledgeRoom", "HonourRoom", "GloryRoom", "HealRoom"]
var HardCodedBuffCardsBecauseTimeRestraints: Array = ["HealPotion", "MotivationPotion", "ExpBoost"]


# Cards will be added to this list, since we don't load and save, we don't need to keep a copy of
# the original starting deck
var Deck = [
	"Trap Room",
	"Trap Room",
	"Combat Room",
	"Combat Room",
	"Riches Room",
	"Glory Room",
	"Heal Room",
]

var SideDeck = [
	"Heal Potion",
	"Motivation Potion",
	"Exp Boost",
]

@onready var tile_selected = null
@onready var dungon_built: bool = false

var heal_potion_amount = 30  # arbitrary numbers
var mv_potion_amount = 40
var exp_potion_amount = 60

func buffs(effect, hero):
	match effect:
		"Heal Potion":
			Party.Heroes[hero].hp += heal_potion_amount
		"Motivation Potion":
			Party.Heroes[hero].mv += mv_potion_amount
		"Exp Boost":
			Party.Heroes[hero].exp += exp_potion_amount
