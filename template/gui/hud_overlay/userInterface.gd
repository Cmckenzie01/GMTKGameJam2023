extends Control

@onready var pauseOverlay: ColorRect = get_node("pauseOverlay")
@onready var pauseTitle: Label = get_node("pauseOverlay/title")
@onready var settings_menu := $pauseOverlay/settings_menu
@onready var inventoryOverlay := $inventoryOverlay
@onready var inventory := $inventoryOverlay/Inventory

@onready var gameFrozen: bool = false
@onready var gamePaused: bool = false

func _ready():
	pass 

# Pause Screen
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and !gameFrozen:
		gamePaused = !gamePaused
		get_tree().paused = gamePaused
		pauseOverlay.visible = !pauseOverlay.visible
		
		
	if event.is_action_pressed("inventory") and !gamePaused:
		gameFrozen = !gameFrozen
		get_tree().paused = gameFrozen
		inventoryOverlay.visible = !inventoryOverlay.visible
		inventory.initialize_inventory()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	#StageManager.changeStage(StageManager.startScreen, 0, 0)

func _on_options_button_pressed():
	settings_menu.popup_centered()

func _on_quit_button_pressed():
	get_tree().quit()
