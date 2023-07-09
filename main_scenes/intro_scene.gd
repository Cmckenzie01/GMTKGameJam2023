extends Control


func _ready():
	Party.MakeParty(["Wizard", "Thief", "Bard", "Knight"])
	$DialogueInterface.dialogue_file = load("res://assets/dialogues/introScene_dialogue.json")
	$DialogueInterface.play()

func _on_dialogue_interface_dialog_completed():
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_node_or_null("DialogueInterface"):
			if $DialogueInterface.dialog_finished:
				$DialogueInterface.next_line()	

func _on_select_pressed():
	# Create a test party
	Party.DemotivateParty(50)

	var main = get_tree().get_root().get_node("Main")
	main.changeState(str(self.name), main.GameScene)


func _on_reroll_pressed():
	pass # Replace with function body.
	# TODO: Regenerate Heroes for stretch goal


func _on_line_edit_1_text_submitted(new_text):
	if len(new_text) > 0:
		print(Party.Heroes)
		Party.Heroes[0].name = new_text
		$Hero1/LineEdit1.clear()
		$Hero1/Name.text = "Name :" + new_text
		$Hero1/LineEdit1.visible = false


func _on_line_edit_2_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[1].name = new_text
		$Hero2/LineEdit2.clear()
		$Hero2/Name.text = "Name :" + new_text
		$Hero2/LineEdit2.visible = false


func _on_line_edit_3_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[2].name = new_text
		$Hero3/LineEdit3.clear()
		$Hero3/Name.text = "Name :" + new_text
		$Hero3/LineEdit3.visible = false


func _on_line_edit_4_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[3].name = new_text
		$Hero4/LineEdit4.clear()
		$Hero4/Name.text = "Name :" + new_text
		$Hero4/LineEdit4.visible = false
