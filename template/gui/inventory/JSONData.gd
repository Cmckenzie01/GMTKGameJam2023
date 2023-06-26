extends Node

var item_data: Dictionary

func _ready():
	item_data = LoadData("res://template/gui/inventory/data/itemData.json")
	
func LoadData(file_path):
	var json_data = JSON.new()
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	json_data = JSON.parse_string(file_data.get_as_text())
	file_data.close()
	return json_data

