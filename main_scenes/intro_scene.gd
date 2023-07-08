extends Control


func _on_dialogue_interface_dialog_completed():
	pass


func _on_select_pressed():
	# Create a test party
	Party.MakeParty(["Knight", "Thief", "Wizard", "Bard"])
	Party.DemotivateParty(50)

	var main = get_tree().get_root().get_node("Main")
	main.changeState(str(self.name), main.GameScene)


func _on_reroll_pressed():
	pass # Replace with function body.
	# TODO: Regenerate Heroes for stretch goal


func _on_line_edit_1_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		var Hero1Name = new_text
		$Hero1/LineEdit1.clear()
		$Hero1/Name.text = "Name :" + Hero1Name
		$Hero1/LineEdit1.visible = false


func _on_line_edit_2_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		var Hero2Name = new_text
		$Hero2/LineEdit2.clear()
		$Hero2/Name.text = "Name :" + Hero2Name
		$Hero2/LineEdit2.visible = false


func _on_line_edit_3_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		var Hero3Name = new_text
		$Hero3/LineEdit3.clear()
		$Hero3/Name.text = "Name :" + Hero3Name
		$Hero3/LineEdit3.visible = false


func _on_line_edit_4_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		var Hero4Name = new_text
		$Hero4/LineEdit4.clear()
		$Hero4/Name.text = "Name :" + Hero4Name
		$Hero4/LineEdit4.visible = false
