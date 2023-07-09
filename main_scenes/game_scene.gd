extends Control

enum GameState {
	# Build (Phase 1)
	BUILD_PLACE,

	# Play (Phase 2)
	PLAY,

	# Reward Selection
	SELECT_REWARD,
}
var game_state: GameState = GameState.BUILD_PLACE
var current_room: int = -1
var current_floor: int = 0
var move_target: Vector2 = Vector2(0.0, 0.0)

@onready var current_dungeon = $Dungeon

enum EventState {
	IDLE,
	INITIAL_TEXT,
	END_TEXT,
}
var event_state: EventState = EventState.IDLE
var current_event = null
signal event_completed
signal win_game

const INSULTS = [
	"Bumbling",
	"Idiot",
	"Clumsy",
	"Buffonish",
	"Smelly",
	"Lazy",
	"Oafish",
	"Moronic",
	"Vain"
]

var no_of_rooms: int = 4
var no_of_floors: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dungeon.queue_free()
	generate_new_dungeon()

	_move_to_next_floor()

@onready var DungeonFloors: Array = [preload("res://levels/three_room_dungeon.tscn")]#[preload("res://levels/three_room_dungeon.tscn"), preload("res://levels/four_room_dungeon.tscn"), preload("res://levels/five_room_dungeon.tscn")]

func generate_new_dungeon():
	var new_dungeon = DungeonFloors.pick_random().instantiate()
	add_child(new_dungeon)
	current_dungeon = new_dungeon
	current_dungeon.all_dungeon_slots_occupied.connect(_on_dungeon_all_dungeon_slots_occupied)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_event() -> String:
	if GlobalVariables.DungeonSequence.size():
		return GlobalVariables.DungeonSequence.pop_front()

	return "healing_room" # TODO Code fails if we don't return anything

func _num_rooms() -> int:
	return no_of_rooms + 1

func _get_room_pos(room_no: int) -> Vector2:
	match room_no: # TODO Ideally get dynamically
		0:
			return Vector2(103.0, 88.0)
		1:
			return Vector2(360.0, 88.0)
		2:
			return Vector2(488.0, 88.0)
		3:
			return Vector2(744.0, 88.0)
		4:
			return Vector2(872.0, 88.0)
		5:
			return Vector2(872.0, 88.0)

	assert(false, "Room index " + str(room_no) + " not >= 0 and <= 4")
	return Vector2()

func _complete_floor():
	game_state = GameState.SELECT_REWARD
	$GUI.draw_rewards(3)

# Tile movement logic
func _move_to_next_floor():
	current_room = 0
	current_floor += 1

	if current_floor > self.no_of_floors:
		Party.game_won = true

	current_dungeon.queue_free()
	GlobalVariables.dungon_built = false
	generate_new_dungeon()

	print("=== Moving To Floor " + str(current_floor) + " ===")

	game_state = GameState.BUILD_PLACE

	$Party.global_position = _get_room_pos(0)
	$GUI.draw_hand(5)
	$GUI.draw_side_hand(3)

func _start_moving_to_next_room():
	current_room += 1
	print("Current Rooms: ", current_room)
	print("Number of Rooms: ", _num_rooms())
	if current_room > _num_rooms():
		_complete_floor()
		return

	# TODO: This should maybe be a path of nodes, otherwise a right angle will result in diagonal movement
	var target = _get_room_pos(current_room)
	var tween = get_tree().create_tween()
	$Party/Knight/KnightPlayer.play("move")
	$Party/Thief/ThiefPlayer.play("move")
	$Party/Wizard/WizardPlayer.play("move")
	$Party/Bard/BardPlayer.play("move")
	tween.tween_property($Party, "global_position", target, 2.0)

	tween.tween_callback(_finish_moving_to_next_room)

func _finish_moving_to_next_room():
	$Party/Knight/KnightPlayer.stop()
	$Party/Thief/ThiefPlayer.stop()
	$Party/Wizard/WizardPlayer.stop()
	$Party/Bard/BardPlayer.stop()
	run_event(_get_event())
	%GoButton.visible = true

# Event (what happens on the tile) logic
func run_event(event_id: String):
	assert(event_state == EventState.IDLE)
	assert(current_event == null)
	print(event_id)
	current_event = GlobalVariables.EventData[event_id]
	current_event['event_type'] = event_id

	event_state = EventState.INITIAL_TEXT

	_send_text(current_event["entry_text"])
	$GUI/GoButton.visible = true

func update_text_title(text: String):
	return text.replace('{title}', GlobalVariables.dark_lord_title)

# Send text to the dialogue box, and play it
func _send_text(text: String, text_name: String = "MinionNo1", use_right_sprite: bool = false):

	text = update_text_title(text)

	var active_sprite
	if use_right_sprite:
		active_sprite = 1
	else:
		active_sprite = 0

	# Create dialogue data
	var data = [
		{
			"text": text,
			"active_sprite": active_sprite,
			# Note: This is displayed as the name, and is also the name of the
			# png to use.
			"name": text_name,
		}
	];

	$GUI/DialogueInterface.visible = true
	$GUI/DialogueInterface.play_data(data)

# Do the event (damage, randomness, update HP) and return whether it succeded or not
func _do_event() -> bool:
	var chance = current_event["base_chance"]

	# NOTE: Bonuses don't stack
	for b in current_event["bonuses"]:
		if Party.AnyBonus(b):
			chance += 0.2
			break

	var succeeded
	print(chance)
	if randf_range(0.0, 1.0) < chance:
		Party.MotivateParty(current_event["reward_motivation"], current_event["reward_bonuses"])
		Party.GrantExp(current_event["exp"], current_event["reward_bonuses"])
		succeeded = true

		if "HEAL" in current_event["reward_bonuses"]:
			Party.HealParty(GlobalVariables.heal_amount)
	else:
		Party.DealPartyDamage(current_event["fail_damage"])
		Party.DemotivateParty(current_event["fail_demotivation"]) # Extra demotivate if it's your preferred task?

		succeeded = false

	return succeeded

func _on_go_button_pressed():
	assert(game_state == GameState.PLAY)

	match event_state:
		EventState.INITIAL_TEXT:
			var result = _do_event()
			var text

			if result:
				text = current_event["pass_text"]
			else:
				text = current_event["fail_text"]

			_send_text(text)

			event_state = EventState.END_TEXT

		EventState.END_TEXT:
			current_event = null
			event_state = EventState.IDLE
			event_completed.emit()

func _on_event_completed():
	%GoButton.visible = false
	_start_moving_to_next_room()


func _on_gui_reward_selected(card):
	var card_type = GlobalVariables.Cards[card].type
	match card_type:
		GlobalVariables.CardType.BUFF:
			GlobalVariables.SideDeck.append(card)
		GlobalVariables.CardType.TILE:
			GlobalVariables.Deck.append(card)
	_move_to_next_floor()


func _on_dungeon_all_dungeon_slots_occupied():
	no_of_rooms = GlobalVariables.DungeonSequence.size()
	#GlobalVariables.DungeonSequence.push_front("start_room") # Option of adding a start room scene (would need adjustments to trigger straight away)
	GlobalVariables.DungeonSequence.push_back("end_room")
	$GUI.deactivate_main_hand()
	$GUI.activate_side_hand()
	game_state = GameState.PLAY
	_start_moving_to_next_room()
