extends Node

signal healthUpdated
signal manaUpdated
signal statsUpdated

signal character_died

# INITIAL VARIABLES
@onready var characterSprite: Object = load("res://assets/sprites/Ass-Ass-In.png")
@onready var characterName: String = "Ass-Ass-In"
#@onready var characterFreeItem: String
@onready var characterShipName: String = "Swift Wind"


@onready var characterMaxHealth: int = 10
@onready var characterMaxMana: int = 10


# LEVEL & SKILLS
@onready var characterLevel: int = 1
@onready var characterExp: int = 0
@onready var characterBody: int = 3
@onready var characterMind: int = 3
@onready var characterSoul: int = 3
@onready var characterLuck: int = 3


@onready var characterHealth: int = characterMaxHealth
@onready var characterMana: int = characterMaxMana



func _ready():
	pass # Replace with function body.


# DAMAGE & HEALING
func change_health(value):
	characterHealth = characterHealth + value
	if characterHealth > characterMaxHealth:
		characterHealth = characterMaxHealth
	elif characterHealth < 1:
		characterHealth = 0
		character_died.emit()
	healthUpdated.emit()
	
# MANA
func change_mana(value):
	characterMana = characterMana + value
	if characterMana > characterMaxMana:
		characterMana = characterMaxMana
	elif characterMana < 1:
		characterMana = 0
	manaUpdated.emit()
	

# SAVE & LOAD FUNCTIONS
func to_dictionary():
	return {
		"characterSprite": characterSprite,
		"characterName": characterName,
		"characterShipName": characterShipName,
		"characterLevel": characterLevel,
		"characterExp": characterExp,
		"characterBody": characterBody,
		"characterMind": characterMind,
		"characterSoul": characterSoul,
		"characterLuck": characterLuck, 
		"characterMaxHealth": characterMaxHealth,
		"characterMaxMana": characterMaxMana,
		"characterHealth": characterHealth,
		"characterMana": characterMana
	}
	
	
func from_dictionary(data):
	characterSprite = data["characterSprite"]
	characterName = data["characterName"]
	characterShipName = data["characterShipName"]
	characterLevel = data["characterLevel"]
	characterExp = data["characterExp"]
	characterBody = data["characterBody"]
	characterMind = data["characterMind"]
	characterSoul = data["characterSoul"]
	characterLuck = data["characterLuck"]
	characterMaxHealth = data["characterMaxHealth"]
	characterMaxMana = data["characterMaxMana"]
	characterHealth = data["characterHealth"]
	characterMana = data["characterMana"]
