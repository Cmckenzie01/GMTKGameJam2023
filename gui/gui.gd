extends CanvasLayer

signal follow_mouse(card: Card)
signal stop_follow_mouse(card: Card)

signal tile_selected(held_card: Card)

var holding_offset = Vector2(120, 120)
var held_card = null

const CardScene = preload("res://rooms/roomCards/Card.tscn")

@onready var current_dungeon = get_parent().get_node("Dungeon")
@onready var cards_container = get_node('CardUI/Cards')

@onready var hero_huds = [%Hero1, %Hero2, %Hero3, %Hero4]

func _ready():
	Party.hero_died.connect(hero_died)
	Party.hero_resurrected.connect(hero_resurrected)
	Party.hero_level_up.connect(set_hero_level)
	Party.lose_game.connect(lose_game)

# Note: This will play at different frame rates depending on the user. Probably fine for a jam game
func _slide_to(current: int, target: int) -> int:
	if current > target:
		return current - 1
	elif current < target:
		return current + 1
	return current

func _process(_delta):
	# In theory this can be triggered by an event, rather than doing it every frame, but ehh
	for i in range(len(Party.Heroes)):
		var hero = Party.Heroes[i]
		var hud = hero_huds[i]

		hud.get_node("Label").text = hero.name

		hud.get_node("HealthBar").max_value = hero.max_hp
		hud.get_node("HealthBar").value = _slide_to(hud.get_node("HealthBar").value, hero.hp)
		hud.get_node("MotivationBar").max_value = hero.max_mv
		hud.get_node("MotivationBar").value = _slide_to(hud.get_node("MotivationBar").value, hero.mv)
		set_hero_level(i, hero.level)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if GlobalVariables.tile_selected:
			GlobalVariables.tile_selected.stop_follow_mouse()

func set_hero_level(hero_index, hero_level: int):
	hero_huds[hero_index].get_node('LevelLabel').text = 'Lvl ' + str(hero_level + 1)

func hero_died(hero_index: int):
	var hero_hud = hero_huds[hero_index]

	hero_hud.get_node('SkullIcon').visible = true
	hero_hud.get_node('Sprite2D').modulate.a = 0.7 # Make them translucent

func hero_resurrected(hero_index: int):
	var hero_hud = hero_huds[hero_index]

	hero_hud.get_node('SkullIcon').visible = false
	hero_hud.get_node('Sprite2D').modulate.a = 1.0 # Make them opaque

func lose_game():
	print("The game is lost!")
	# TODO Dialogue
	# TODO Scene change

func left_click_empty_slot(room: Room):#: SlotClass):
	room.set_card(GlobalVariables.tile_selected)

func draw_hand(count: int):
	for c in %Cards.get_children():
		c.queue_free()

	GlobalVariables.Deck.shuffle()

	var at = %Cards.transform.origin
	for i in range(0, count):
		var card = CardScene.instantiate()
		card.transform.origin = at
		%Cards.add_child(card)
		card.make_card(GlobalVariables.Deck[i])

		at.x += 150

func draw_side_hand(count: int):
	GlobalVariables.SideDeck.shuffle()
	var existing_cards = %Cards2.get_child_count()
	var at = %Cards2.transform.origin + Vector2(800,0)
	for i in range(existing_cards, count):
		var card = CardScene.instantiate()
		card.transform.origin = at
		%Cards2.add_child(card)
		card.make_card(GlobalVariables.SideDeck[i])
		card.process_mode = 4
		at.x += 50
	deactivate_side_hand()

func deactivate_main_hand():
	var offset = 0
	for card in %Cards.get_children():
		card.process_mode = 4
		card.transform.origin = Vector2(51 + offset, 66)
		offset += 50
		card.modulate = Color(1,1,1,0.6)

func deactivate_side_hand():
	var at = %Cards2.transform.origin + Vector2(800,0)
	for card in %Cards2.get_children():
		card.transform.origin = at
		card.process_mode = 4
		at.x += 50
		card.modulate = Color(1,1,1,0.6)

func activate_side_hand():
	var offset = 200
	for card in %Cards2.get_children():
		card.process_mode = 0
		card.transform.origin.x -= offset
		offset -= 50
		card.modulate = Color(1,1,1,1)
