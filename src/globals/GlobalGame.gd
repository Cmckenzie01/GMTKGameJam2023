extends Node

@onready var scene_root = get_tree().get_root()

# Towers collected and available for placement
@onready var towerStock: Dictionary = {
	"tower1": 0,
	"tower2": 0,
	"tower3": 0,
	"tower4": 0,
	"tower5": 0
}

@onready var gold: int = 50 : set = update_currency

@onready var tower1Label = scene_root.get_node("LevelOne/GUI/TowerBar/TowerLabels/tower1") 
@onready var tower2Label = scene_root.get_node("LevelOne/GUI/TowerBar/TowerLabels/tower2") 
@onready var tower3Label = scene_root.get_node("LevelOne/GUI/TowerBar/TowerLabels/tower3") 
@onready var tower4Label = scene_root.get_node("LevelOne/GUI/TowerBar/TowerLabels/tower4") 
@onready var tower5Label = scene_root.get_node("LevelOne/GUI/TowerBar/TowerLabels/tower5") 

@onready var currencyLabel = scene_root.get_node("LevelOne/GUI/Currency/Label")


func reduce_stock(tower):
	towerStock[tower] -= 1
	update_towerStock()
	
func no_stock(tower):
	match tower:
		"tower1":
			tower1Label.self_modulate = Color(1, 0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(tower1Label, "self_modulate", Color(1, 1, 1, 1), 1)
		"tower2":
			tower2Label.self_modulate = Color(1, 0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(tower2Label, "self_modulate", Color(1, 1, 1, 1), 1)
		"tower3":
			tower3Label.self_modulate = Color(1, 0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(tower3Label, "self_modulate", Color(1, 1, 1, 1), 1)
		"tower4":
			tower4Label.self_modulate = Color(1, 0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(tower4Label, "self_modulate", Color(1, 1, 1, 1), 1)
		"tower5":
			tower5Label.self_modulate = Color(1, 0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(tower5Label, "self_modulate", Color(1, 1, 1, 1), 1)


func update_towerStock() -> void:
	tower1Label.text = str(towerStock.tower1)
	tower2Label.text = str(towerStock.tower2)
	tower3Label.text = str(towerStock.tower3)
	tower4Label.text = str(towerStock.tower4)
	tower5Label.text = str(towerStock.tower5)

func update_currency(new_gold) -> void:
	currencyLabel.text = str(new_gold)

# Called when the node enters the scene tree for the first time.
func _ready():
	gold = 50
	towerStock.tower1 = 1
	towerStock.tower4 = 8
	update_towerStock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
