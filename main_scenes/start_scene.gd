extends Control

func _on_start_button_pressed():
	var main = get_tree().get_root().get_node("Main")
	main.changeState(str(self.name), main.IntroScene)
