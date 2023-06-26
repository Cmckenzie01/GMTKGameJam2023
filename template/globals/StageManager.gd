extends CanvasLayer

### Preload Common Scene
#const startScreen = preload("res://world/levels//startScreen/startScreen.tscn")


func _ready():
	get_node("transitionScreen").hide()
	get_node("loadingLabel").hide()
	
func changeStage(stage_path, x, y):
	get_node("transitionScreen").show()
	get_node("loadingLabel").show()
	get_node("transitionAnim").play("TransIn")
	await get_node("transitionAnim").animation_finished
	
	var stage = stage_path.instantiate()
	get_tree().get_root().get_child(-1).free()
	get_tree().get_root().add_child(stage)
	if stage.has_node("Player"):
		stage.get_node("Player").position = Vector2(x, y)
	
	get_node("transitionAnim").play("TransOut")
	await get_node("transitionAnim").animation_finished
	get_node("transitionScreen").hide()
