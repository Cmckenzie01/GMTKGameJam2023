extends Control

@onready var currency: Dictionary = {"gold": 5, "silver": 15, "copper": 43, "emblems": 2} #stand-in for singleton variable
@onready var gold := $GoldCounter/Gold
@onready var silver := $SilverCounter/Silver
@onready var copper := $CopperCounter/Copper
@onready var emblems := $EmblemCounter/Emblems

func _ready() -> void:
	#GlobalInventory.connect("currency_updated", update_interface)
	update_interface()
	
func update_interface() -> void:
	gold.text = str(currency.gold)
	silver.text = str(currency.silver)
	copper.text = str(currency.copper)
	emblems.text = str(currency.emblems)
