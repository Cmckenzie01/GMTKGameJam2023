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

@onready var current_dungeon = $Dungeon

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

var playable = false # Stop them getting to Phase 2 before building the dungeon

# Called when the node enters the scene tree for the first time.
func _ready():
	self.current_dungeon.all_dungeon_slots_occupied.connect(all_dungeon_slots_occupied)

	_move_to_next_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func all_dungeon_slots_occupied():
	self.playable = true

func _get_event() -> String:
	var room = current_dungeon.get_node('RoomContainer').get_child(self.current_room-1).get_child(0)
	return room.tile_name

func _num_rooms() -> int:
	return 4 # TODO Replace when we figure out how the dungeon works

func _get_room_pos(room_no: int) -> Vector2:
	match room_no: # TODO Ideally get dynamically
		0:
			return Vector2(103.0, 104.0)
		1:
			return Vector2(360.0, 104.0)
		2:
			return Vector2(488.0, 104.0)
		3:
			return Vector2(744.0, 104.0)
		4:
			return Vector2(872.0, 104.0)

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
		return

	current_room += 1

	# TODO: This should maybe be a path of nodes, otherwise a right angle will result in diagonal movement
	var target = _get_room_pos(current_room)
	var tween = get_tree().create_tween()

	tween.tween_property($Party, "global_position", target, 2.0)

	tween.tween_callback(_finish_moving_to_next_room)

func _finish_moving_to_next_room():
	run_event(_get_event())

# Event (what happens on the tile) logic
func run_event(event_id: String):
	assert(event_state == EventState.IDLE)
	assert(current_event == null)
	print(event_id)
	current_event = GlobalVariables.EventData[event_id]
	current_event['event_type'] = event_id

	event_state = EventState.INITIAL_TEXT
	_send_text(current_event["entry_text"])
	$GoButton.visible = true

# Send text to the dialogue box, and play it
func _send_text(text: String, text_name: String = "Placeholder", use_right_sprite: bool = true):

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
	if randf_range(0.0, 1.0) < chance:
		Party.MotivateParty(current_event["reward_motivation"], current_event["reward_bonuses"])
		Party.GrantExp(current_event["exp"], current_event["reward_bonuses"])
		succeeded = true
	else:
		Party.DealPartyDamage(current_event["fail_damage"])
		Party.DemotivateParty(current_event["fail_demotivation"]) # Extra demotivate if it's your preferred task?

		succeeded = false

	return succeeded

func _on_go_button_pressed():
	match game_state:
		GameState.BUILD_PLACE:
			if self.playable:
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
