extends CanvasLayer

signal follow_mouse(card: Card)
signal stop_follow_mouse(card: Card)

signal tile_selected(held_card: Card)

var holding_offset = Vector2(120, 120)
var held_card = null

@onready var current_dungeon = get_parent().get_node("Dungeon")
@onready var cards_container = get_node('CardUI/TileCards')

@onready var hero_huds = [%Hero1, %Hero2, %Hero3, %Hero4]

func _ready():
	for child in cards_container.get_children():
		child.card_left_clicked.connect(card_left_clicked)
		
		follow_mouse.connect(child.follow_mouse)
		stop_follow_mouse.connect(child.stop_follow_mouse)
		
	Party.hero_died.connect(hero_died)
	Party.hero_resurrected.connect(hero_resurrected)
	

# Note: This will play at different frame rates depending on the user. Probably fine for a jam game
func _slide_to(current: int, target: int) -> int:
	if current > target:
		return current - 1
	elif current < target:
		return current + 1
	return current

func _process(_delta):
	# In theory this can be triggered by an event, rather than doing it every frame, but ehh
	for i in range(0, 4):
		var hero = Party.Heroes[i]
		var hud = hero_huds[i]

		hud.get_node("Label").text = hero.name

		hud.get_node("HealthBar").max_value = hero.max_hp
		hud.get_node("HealthBar").value = _slide_to(hud.get_node("HealthBar").value, hero.hp)
		hud.get_node("MotivationBar").max_value = hero.max_mv
		hud.get_node("MotivationBar").value = _slide_to(hud.get_node("MotivationBar").value, hero.mv)

func hero_died(hero_index: int):
	var hero_hud = hero_huds[hero_index]
			
	hero_hud.get_node('SkullIcon').visible = true
	hero_hud.get_node('Sprite2D').modulate.a = 0.7 # Make them translucent
	
func hero_resurrected(hero_index: int):
	var hero_hud = hero_huds[hero_index]

	hero_hud.get_node('SkullIcon').visible = false
	hero_hud.get_node('Sprite2D').modulate.a = 1.0 # Make them opaque
	
func left_click_empty_slot(room: Room):#: SlotClass):
	room.set_card(self.held_card)
	
	pass 
	# TODO: Activate Card Effect depending on Slot, 
	#(i.e., if TileCard, place the appropriate room scene on the map
	
func left_click_occupied_slot(room: Room):
	pass
	# TODO: Visual cue that card cannot be placed in an occupied slot
	
func return_card_to_hand():
	stop_follow_mouse.emit(self.held_card)
	self.held_card = null
	GlobalVariables.tile_selected = null
	
func card_left_clicked(card: Card):
	print("This card has been left clicked ", card.name)
	
	if held_card == null:
		follow_mouse.emit(card)
		held_card = card
		GlobalVariables.tile_selected = card
	else:
		stop_follow_mouse.emit(card)
		held_card = null
		GlobalVariables.tile_selected = null
	
