extends Control

@onready var dialogue_count = 0

func _ready():
	$CanvasLayer/Cover.hide()
	Party.MakeParty(["Wizard", "Thief", "Bard", "Knight"])
	$DialogueInterface.dialogue_file = load("res://assets/dialogues/introScene_dialogue.json")
	$DialogueInterface.play()

func _on_dialogue_interface_dialog_completed():
	$Hero1.process_mode = 0
	$Hero2.process_mode = 0
	$Hero3.process_mode = 0
	$Hero4.process_mode = 0
	$Hero1/LineEdit1.focus_mode = 2
	$Hero2/LineEdit2.focus_mode = 2
	$Hero3/LineEdit3.focus_mode = 2
	$Hero4/LineEdit4.focus_mode = 2
	#$Select.disabled = false
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		match dialogue_count:
			0:
				$IntroSceneAnimation.play("FirstHero")
				await $IntroSceneAnimation.animation_finished
			1:
				pass
			2:
				$IntroSceneAnimation.play("SecondHero")
				await $IntroSceneAnimation.animation_finished
			3: 
				pass
			4: 
				pass
			5: 
				$IntroSceneAnimation.play("ThirdHero")
				await $IntroSceneAnimation.animation_finished
			6:
				pass
			7:
				pass
			8:
				$IntroSceneAnimation.play("FourthHero")
				await $IntroSceneAnimation.animation_finished
			9:
				pass
			10:
				pass
			11:
				$IntroSceneAnimation.play("FinalAnimation")
				await $IntroSceneAnimation.animation_finished
		
		if get_node_or_null("DialogueInterface"):
			if $DialogueInterface.dialog_finished:
				$DialogueInterface.next_line()
				dialogue_count += 1

func _on_select_pressed():
	# Create a test party
	Party.DemotivateParty(50)

	$CanvasLayer/Cover.show()
	$IntroSceneAnimation.play("ExitAnimation")
	await $IntroSceneAnimation.animation_finished
	

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
		$Hero1/Name.text = "Name: " + new_text
		$Hero1/LineEdit1.visible = false


func _on_line_edit_2_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[1].name = new_text
		$Hero2/LineEdit2.clear()
		$Hero2/Name.text = "Name: " + new_text
		$Hero2/LineEdit2.visible = false


func _on_line_edit_3_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[2].name = new_text
		$Hero3/LineEdit3.clear()
		$Hero3/Name.text = "Name: " + new_text
		$Hero3/LineEdit3.visible = false


func _on_line_edit_4_text_submitted(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[3].name = new_text



func _on_line_edit_4_text_changed(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[3].name = new_text
		$Hero4/LineEdit4.clear()
		$Hero4/Name.text = "Name: " + new_text
		$Hero4/LineEdit4.visible = false


func _on_line_edit_3_text_changed(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[2].name = new_text



func _on_line_edit_1_text_changed(new_text):
	if len(new_text) > 0:
		print(Party.Heroes)
		Party.Heroes[0].name = new_text


func _on_line_edit_2_text_changed(new_text):
	if len(new_text) > 0:
		print("set character name to...") # TODO: Connect to Hero Name in backend
		Party.Heroes[1].name = new_text
