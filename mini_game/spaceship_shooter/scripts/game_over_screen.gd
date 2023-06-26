extends Control



func _on_resert_button_pressed():
	get_tree().reload_current_scene()
	
func set_score(value):
	$Panel/Score.text = "Score: " + str(value)
	
func set_high_score(value):
	$Panel/HigScore.text = "Hi-Score: " + str(value)
