extends Node

var load_saved_game = false
const SAVEPATH = "user://savegame.dat"

func _ready():
	pass
	
func save():
	var data = {
		#"character": GlobalCharacter.to_dictionary(),
		#"game": GlobalGame.to_dictionary(),
		"inventory": GlobalInventory.to_dictionary()
	}
	var file := FileAccess.open(SAVEPATH, FileAccess.WRITE)
	file.store_var(data)
	
	
func load_data():
	load_saved_game = true
	if FileAccess.file_exists(SAVEPATH):
		var file = FileAccess.open(SAVEPATH, FileAccess.READ)
		var data = file.get_var()
		#GlobalCharacter.from_dictionary(data.character)
		#GlobalGame.from_dictionary(data.game)
		GlobalInventory.from_dictionary(data.inventory)
		
func _input(_event):
	#if event.is_action_pressed("ui_save"): #Globals.can_save == true &&
	#	save()
	#	print("I've saved the game")
	#if event.is_action_pressed("ui_restart"):
	#	load_data()
	#	print("I've loaded the game")
	pass
