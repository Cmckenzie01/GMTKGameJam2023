extends Control

@onready var healthBar = $healthBar
@onready var manaBar = $manaBar


func _ready():
	#GlobalCharacter.healthUpdated.connect(updateHealth)
	#GlobalCharacter.manaUpdated.connect(updateMana)
	#GlobalCharacter.statsUpdated.connect(updateStats)
	#GlobalCharacter.character_died.connect(updateDeath)
	
	$characterName.text = "Test Name" #GlobalCharacter.characterName
	
	# Set initial values
	updateHealth()
	updateMana()
	updateStats()

func updateHealth():
	@warning_ignore("integer_division")
	var newHealth: int = 50 #(GlobalCharacter.characterHealth * 100)/GlobalCharacter.characterMaxHealth 
	healthBar.value = newHealth
	$HUDBase/healthNumbers.text = "50 / 100" #str(GlobalCharacter.characterHealth) + " / " + str(GlobalCharacter.characterMaxHealth)
	#if GlobalCharacter.characterHealth > 0:
	#	$skull.hide()

	
func updateMana():
	@warning_ignore("integer_division")
	var newMana: int = 25 #(GlobalCharacter.characterMana * 100)/GlobalCharacter.characterMaxMana
	manaBar.value = newMana
	$HUDBase/manaNumbers.text = "25 / 100" #str(GlobalCharacter.characterMana) + " / " + str(GlobalCharacter.characterMaxMana)
	

func updateStats():
	$HUDBase/bodyStat.text = "3" #str(GlobalCharacter.characterBody)
	$HUDBase/mindStat.text = "5" #str(GlobalCharacter.characterMind)
	$HUDBase/soulStat.text = "9" #str(GlobalCharacter.characterSoul)
	$HUDBase/luckStat.text = "0" #str(GlobalCharacter.characterLuck)

func updateDeath():
	$skull.show()


