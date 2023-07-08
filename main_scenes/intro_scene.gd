extends Control


func _on_dialogue_interface_dialog_completed():
	pass


func _on_select_pressed():
	var main = get_tree().get_root().get_node("Main")
	main.changeState(str(self.name), main.GameScene)


func _on_reroll_pressed():
	pass # Replace with function body.
	# TODO: Regenerate Heroes for stretch goal
