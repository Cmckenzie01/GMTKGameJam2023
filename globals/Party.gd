extends Node

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
		"name": "Nite",
		"bonuses": [BonusTypes.COMBAT, BonusTypes.SOCIAL, BonusTypes.RICHES, BonusTypes.GLORY],
	},
	"Thief": {
		"hp": 75,
		"max_hp": 75,
		"mv": 150,
		"max_mv": 150,
		"name": "Feif",
		"bonuses": [BonusTypes.TRAP, BonusTypes.PUZZLE, BonusTypes.RICHES],
	},
	"Wizard": {
		"hp": 75,
		"max_hp": 75,
		"mv": 100,
		"max_mv": 100,
		"name": "W'izar'",
		"bonuses": [BonusTypes.TRAP, BonusTypes.PUZZLE, BonusTypes.RICHES],
	},
	"Bard": {
		"hp": 100,
		"max_hp": 100,
		"mv": 150,
		"max_mv": 150,
		"name": "Brad",
		"bonuses": [BonusTypes.SOCIAL, BonusTypes.PUZZLE, BonusTypes.KNOWLEDGE, BonusTypes.HONOUR, BonusTypes.GLORY],
	}
}

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
		assert(bonus != null)

	return bonus

func DealPartyDamage(dmg: int):
	for h in Heroes:
		h.hp -= dmg
		h.hp = max(h.hp, 0)

func DemotivateParty(dmg: int):
	for h in Heroes:
		h.mv -= dmg
		h.mv = max(h.mv, 0)

func MotivateParty(heal: int, bonus: Variant = null):
	for h in Heroes:
		# Don't motivate dead heroes
		if h.hp > 0:
			var with_bonus = heal

			# Doesn't stack
			if bonus != null:
				for b in bonus:
					b = _get_bonus(b)
					if b in h.bonuses:
						with_bonus *= 1.2
						break

			h.mv += heal
			h.mv = min(h.mv, h.max_mv)

# Check if any party member has a skill (either by string name or enum variant)
# Any hero with 0 hp or mv is not included
func AnyBonus(bonus: Variant) -> bool:
	bonus = _get_bonus(bonus)

	for h in Heroes:
		if h.hp && h.mv:
			if bonus in h.bonuses:
				return true

	return false
