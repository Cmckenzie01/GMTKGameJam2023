extends Node2D

const StartScene = preload("res://main_scenes/start_scene.tscn")
const IntroScene = preload("res://main_scenes/intro_scene.tscn")
const GameScene = preload("res://main_scenes/game_scene.tscn")

# Floors
const ThreeRoomDungeon = preload("res://levels/three_room_dungeon.tscn")

func _ready():
	get_node("StageManager/transitionScreen").hide()
	get_node("StageManager/loadingLabel").hide()

func changeState(current_stage, next_stage):
	#get_node("StageManager/transitionScreen").show()
	#get_node("StageManager/loadingLabel").show()
	get_node("StageManager/transitionAnimation").play("TransIn")
	await get_node("StageManager/transitionAnimation").animation_finished

	var stage = next_stage.instantiate()
	get_node(current_stage).free()
	add_child(stage)

	get_node("StageManager/transitionAnimation").play("TransOut")
	await get_node("StageManager/transitionAnimation").animation_finished
	#get_node("StageManager/transitionScreen").hide()
	#get_node("StageManager/loadingLabel").hide()
