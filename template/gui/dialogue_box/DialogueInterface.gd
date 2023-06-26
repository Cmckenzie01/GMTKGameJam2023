extends CanvasLayer

signal dialog_completed 

@export var dialogue_file: JSON

@onready var sprite1 = $Sprites/Sprite1
@onready var sprite2 = $Sprites/Sprite2

var dialogues = []
var current_dialogue_id = 0
var dialog_index = 0
var dialog_finished = false
var current_speaker = null
var active_sprite = 0


func _ready():
	play()

func _process(_delta):
	$"NinePatchRect/next-indicator".visible = dialog_finished

func play():
	var data = dialogue_file.get_data()
	dialogues = data #load_dialogue()
	
	current_dialogue_id = -1
	next_line()

func _input(event):
	if event.is_action_pressed("action") and dialog_finished:
		next_line()
	else:
		pass # SPEED UP DIALOG
		
		
func next_line():
	current_dialogue_id += 1
	
	if current_dialogue_id >= len(dialogues):
		emit_signal("dialog_completed")
		self.queue_free()
		return
	
	current_speaker = dialogues[current_dialogue_id]['name']
	active_sprite = dialogues[current_dialogue_id]['active_sprite']
	
	if active_sprite == 1:
		sprite1.texture = load(str("res://assets/gui/", current_speaker, ".png"))
		sprite1.visible = true
		sprite2.visible = false
	else:
		sprite2.texture = load(str("res://assets/gui/", current_speaker, ".png"))
		sprite1.visible = false
		sprite2.visible = true
	
	dialog_finished = false
	$NinePatchRect/Name.text = dialogues[current_dialogue_id]['name']
	$NinePatchRect/Message.text = dialogues[current_dialogue_id]['text']
	$NinePatchRect/Message.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property($NinePatchRect/Message, "visible_ratio", 1, 0.5)
	tween.tween_callback(_on_Tween_tween_completed)
	#tween.tween_callback(queue_free)
#	$NinePatchRect/Tween.interpolate_property(
#		$NinePatchRect/Message, "percent_visible", 0, 1, 1, 
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
#	)
	

#func load_dialogue():
#	if FileAccess.file_exists(dialogue_file):
#		var file = FileAccess.open(dialogue_file, FileAccess.READ)
#		var json = JSON.new()
#		var json_string = json.stringify(file)
#		return json_string

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed():
	dialog_finished = true
