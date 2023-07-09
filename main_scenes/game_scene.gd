extends Control

enum GameState {
	# Build (Phase 1)
	BUILD_PLACE,

	# Play (Phase 2)
	PLAY,
}
var game_state: GameState = GameState.BUILD_PLACE
var current_room: int = -1
var current_floor: int = 0
var move_target: Vector2 = Vector2(0.0, 0.0)

enum EventState {
	IDLE,
	INITIAL_TEXT,
	END_TEXT,
}
var event_state: EventState = EventState.IDLE
var current_event = null
signal event_completed

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

# Called when the node enters the scene tree for the first time.
func _ready():
	_move_to_next_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_event() -> String:
	if GlobalVariables.DungeonSequence.size():
		return GlobalVariables.DungeonSequence.pop_front()
	return "healing_room"
	
func _num_rooms() -> int:
	return no_of_rooms

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

	assert(false, "Room index " + str(room_no) + " not >= 0 and <= 4")
	return Vector2()

# Tile movement logic
func _move_to_next_floor():
	current_room = 0
	current_floor += 1

	print("=== Moving To Floor " + str(current_floor) + " ===")

	game_state = GameState.BUILD_PLACE

	$Party.global_position = _get_room_pos(0)

func _start_moving_to_next_room():
	if current_room >= _num_rooms():
		_move_to_next_floor()
		Party.HealParty(50) # TODO Temporary for testing
		return

	current_room += 1

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

# Event (what happens on the tile) logic
func run_event(event_id: String):
	assert(event_state == EventState.IDLE)
	assert(current_event == null)
	current_event = GlobalVariables.EventData[event_id]
	current_event['event_type'] = event_id

	event_state = EventState.INITIAL_TEXT
	_send_text(current_event["entry_text"])
	$GoButton.visible = true

# Send text to the dialogue box, and play it
func _send_text(text: String, name: String = "MinionNo1", use_right_sprite: bool = false):

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
			"name": name,
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
	if false: # randf_range(0.0, 1.0) < chance:
		Party.MotivateParty(current_event["reward_motivation"], current_event["reward_bonuses"])
		Party.GrantExp(current_event["exp"], current_event["reward_bonuses"])
		# TODO: Grant exp
		succeeded = true
	else:
		Party.DealPartyDamage(current_event["fail_damage"])
		Party.DemotivateParty(current_event["fail_demotivation"]) # Extra demotivate if it's your preferred task?

		succeeded = false

	return succeeded

func _on_go_button_pressed():
	match game_state:
		GameState.BUILD_PLACE:
			no_of_rooms = GlobalVariables.DungeonSequence.size() + 2
			#GlobalVariables.DungeonSequence.push_front("start_room") # Option of adding a start room scene (would need adjustments to trigger straight away)
			GlobalVariables.DungeonSequence.push_back("end_room")
			game_state = GameState.PLAY
			_start_moving_to_next_room()

		GameState.PLAY:
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
	_start_moving_to_next_room()
