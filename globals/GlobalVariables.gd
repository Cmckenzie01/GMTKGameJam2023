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
    "Trap": {
        "Type": "Challenge",
    },
    "Combat": {
        "Type": "Challenge",
    },
    "Puzzle": {
        "Type": "Challenge",
    },
    "Social": {
        "Type": "Challenge",
    },
    "Environmental": {
        "Type": "Challenge",
    },
    "Riches": {
        "Type": "Reward",
    },
    "Knowledge": {
        "Type": "Reward",
    },
    "Upgrades": {
        "Type": "Reward",
    },
    "Glory": {
        "Type": "Reward",
    },
    "Heal": {
        "Type": "Reward",
    }
}

# Hero Classes
@onready var HeroClasses: Dictionary = {
    "Knight": {
        
    },
    "Swashbuckler": {
        
    },
    "Barbarian": {
        
    },
    "Warrior": {
        
    },
    "Gambler": {
        
    },
    "Ninja": {
        
    },
    "Assassin": {
        
    },
    "Thief": {
        
    },
    "Illusionist": {
        
    },
    "Sorcerer": {
        
    },
    "Mage": {
        
    },
    "Wizard": {
        
    },
    "Ranger": {
        
    },
    "Archer": {
        
    },
    "BeastMaster": {
        
    },
    "Cleric": {
        
    },
    "Priest": {
        
    },
    "Healer": {
        
    }, 
}
