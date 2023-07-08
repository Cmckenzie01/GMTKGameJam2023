extends Node

signal hero_died(hero_index: int)
signal hero_resurrected(hero_index: int)
signal hero_level_up(hero_index: int, hero_level: int)

# Resistance/Vulnerability Types
enum BonusTypes {
	# For challenges
	TRAP,
	COMBAT,
	PUZZLE,
	SOCIAL,
	ENVIRONMENTAL,

	# For treasure
	RICHES,
	KNOWLEDGE,
	HONOUR,
	GLORY,
	HEAL
}

# Hero Classes
# This acts as a base template for the hero list below; they are copied to create new heroes
const HeroClasses: Dictionary = {
	"Knight": {
		"hp": 150,
		"max_hp": 150,
		"mv": 100,
		"max_mv": 100,
		"exp": 0,
		"level": 0,
		"name": "Nite",
		"bonuses": [BonusTypes.COMBAT, BonusTypes.SOCIAL, BonusTypes.RICHES, BonusTypes.GLORY],
	},
	"Thief": {
		"hp": 75,
		"max_hp": 75,
		"mv": 150,
		"max_mv": 150,
		"exp": 0,
		"level": 0,
		"name": "Feif",
		"bonuses": [BonusTypes.TRAP, BonusTypes.PUZZLE, BonusTypes.RICHES],
	},
	"Wizard": {
		"hp": 75,
		"max_hp": 75,
		"mv": 100,
		"max_mv": 100,
		"exp": 0,
		"level": 0,
		"name": "W'izar'",
		"bonuses": [BonusTypes.TRAP, BonusTypes.PUZZLE, BonusTypes.RICHES],
	},
	"Bard": {
		"hp": 100,
		"max_hp": 100,
		"mv": 150,
		"max_mv": 150,
		"exp": 0,
		"level": 0,
		"name": "Brad",
		"bonuses": [BonusTypes.SOCIAL, BonusTypes.PUZZLE, BonusTypes.KNOWLEDGE, BonusTypes.HONOUR, BonusTypes.GLORY],
	}
}

const LEVEL_THRESHOLDS = [ # TODO Add more levels
	100,
	200,
	400,
	800
]

# Fields of hero:
# hp
# max_hp
# mv
# max_mv
# name
# bonuses
var Heroes = null

func MakeParty(classes: Array):
	Heroes = []

	for c in classes:
		Heroes.append(HeroClasses[c].duplicate())

# Convert a string to a bonus enum variant, or (if it already is an enum variant) pass it unchanged
func _get_bonus(bonus: Variant) -> BonusTypes:
	if bonus is String:
		bonus = BonusTypes.get(bonus)
		assert(bonus != null, "Bonus is null")

	return bonus

func HealParty(heal: int):
	for i in range(len(Heroes)):
		var hero = Heroes[i] # TODO Do we want this to work on dead heroes?
		
		var was_dead = (hero.hp == 0)
		
		hero.hp += heal
		hero.hp = min(hero.hp, hero.max_hp)
		
		if was_dead:
			hero_resurrected.emit(i)

func DealPartyDamage(dmg: int):
	for i in range(len(Heroes)):
		var hero = Heroes[i]
		
		hero.hp -= dmg
		hero.hp = max(hero.hp, 0)
		
		if hero.hp == 0:
			hero_died.emit(i)

func DemotivateParty(dmg: int):
	for hero in Heroes:
		hero.mv -= dmg
		hero.mv = max(hero.mv, 0)

func MotivateParty(heal: int, bonus: Variant = null):
	for hero in Heroes:
		# Don't motivate dead heroes
		if hero.hp > 0:
			var with_bonus = heal

			# Doesn't stack
			if bonus != null:
				for b in bonus:
					b = _get_bonus(b)
					if b in hero.bonuses:
						with_bonus *= 1.2
						break

			hero.mv += with_bonus
			hero.mv = min(hero.mv, hero.max_mv)

func GrantExp(exp: int, bonus: Variant = null):
	for hero_index in range(len(Heroes)):
		var hero = Heroes[hero_index]
		
		# Don't give dead heroes exp
		if hero.hp > 0:
			var with_bonus = exp

			var motivation_level = (hero.mv / hero.max_mv)
			var modifier 
			
			if motivation_level > 0.7:
				modifier = 1.2
			elif motivation_level > 0.4:
				modifier = 1 
			else:
				modifier = 0.8
				
			with_bonus *= modifier

			hero.exp += with_bonus
			
			var new_level = hero.level 
			
			var remaining_exp = hero.exp 
			while remaining_exp >= LEVEL_THRESHOLDS[new_level]:
				new_level += 1
				remaining_exp -= LEVEL_THRESHOLDS[new_level]
				
			if new_level > hero.level:
				LevelUp(hero, hero_index, new_level)
				
func LevelUp(hero: Dictionary, hero_index: int, new_level: int):
	print("Levelling up ", hero.name, " to Level ", str(new_level), "! They have " + str(hero.exp) + " EXP in total.")
	hero.level = new_level # TODO Send some kind of message
	
	hero_level_up.emit(hero_index, hero.level)
	
	# TODO Whatever else we do on level up, e.g. stat boosts

# Check if any party member has a skill (either by string name or enum variant)
# Any hero with 0 hp or mv is not included
func AnyBonus(bonus: Variant) -> bool:
	bonus = _get_bonus(bonus)

	for hero in Heroes:
		if hero.hp > 0 && hero.mv > 0:
			if bonus in hero.bonuses:
				return true

	return false
