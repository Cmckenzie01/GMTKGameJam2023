extends Control


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and GlobalVariables.tile_selected:
		if GlobalVariables.tile_selected.card_name in GlobalVariables.HardCodedBuffCardsBecauseTimeRestraints:
			GlobalVariables.buffs(GlobalVariables.tile_selected.card_name, 3)
			GlobalVariables.tile_selected.queue_free()
			GlobalVariables.tile_selected = null
			
