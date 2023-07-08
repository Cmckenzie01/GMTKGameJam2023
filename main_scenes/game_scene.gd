extends Control

enum EventState {
	IDLE,
	INITIAL_TEXT,
	END_TEXT,
}
var event_state: EventState = EventState.IDLE
var current_event = null
signal event_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing
	run_event("spike_trap")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func run_event(event_id: String):
	assert(event_state == EventState.IDLE)
	assert(current_event == null)
	current_event = GlobalVariables.EventData[event_id]
	
	event_state = EventState.INITIAL_TEXT
	_send_text(current_event["entry_text"])
	$GoButton.visible = true

# Send text to the dialogue box, and play it
func _send_text(text: String):
	# Create dialogue data
	var data = [
		{
			"text": text,
			"active_sprite": 1,
			# Note: This is displayed as the name, and is also the name of the
			# png to use.
			"name": "Placeholder",
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
	
	if randf_range(0.0, 1.0) < chance:
		# Pass
		print("Event passed")
		Party.MotivateParty(current_event["reward_motivation"], current_event["reward_bonuses"])
		# TODO: Grant exp
		return true
	else:
		# Fail
		print("Event failed")
		Party.DealPartyDamage(current_event["fail_damage"])
		Party.DemotivateParty(current_event["fail_demotivation"])
		return false
	

func _on_go_button_pressed():
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
	print("Test output of event completed!")
	run_event("spike_trap")
