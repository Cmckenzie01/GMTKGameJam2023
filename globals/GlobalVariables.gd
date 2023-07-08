extends Node


@onready var DungeonFloors: Dictionary = {
	"ThreeFloors": {},
	"FourFloors": {},
	"FiveFloors": {},
}

@onready var DungeonTiles: Dictionary = {
	"TileOne": {
		"name": "The Card",
		"image": preload('res://assets/Cards/pig.jpg'),
		"description": "I'm a card! Look at me! Card card card!",
		"effects": [] # TODO: Make Effect
	},
	"TileTwo": {
		"name": "Another Card",
		"image": preload('res://assets/sprites/Placeholder.png'),
		"description": "But am I a card? Really? When you think about it?",
		"effects": [] # TODO: Make Effect
	},
	"TileThree": {
		"name": "Different Card",
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

# Resistance/Vulnerability Types
@onready var EffectTypes: Dictionary = {
	# Determines effectiveness bonus 
	"Trap": { # For Rogues
		"Type": "Challenge",
	},
	"Combat": { # For Knights
		"Type": "Challenge",
	},
	"Puzzle": { # For Wizards
		"Type": "Challenge",
	},
	"Social": { # For Bards
		"Type": "Challenge",
	},
	"Environmental": { # Universal
		"Type": "Challenge",
	},
	
	# Determines motivation bonus
	"Riches": { # Thief reward
		"Type": "Reward",
	},
	"Knowledge": { # Wizard reward
		"Type": "Reward",
	},
	"Honour": { # Knight reward
		"Type": "Reward",
	},
	"Glory": { # Bard reward
		"Type": "Reward",
	},
	"Heal": { # Universal reward
		"Type": "Reward",
	}
}

# Hero Classes
@onready var HeroClasses: Dictionary = {
	"Knight": {
		
	},
	"Thief": {
		
	},
	"Wizard": {
		
	},
	"Bard": {
		
	}
}
