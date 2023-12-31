class_name Card extends Node2D

signal play_card(effects: Array)
signal card_left_clicked(card)

@export var card: String = "HealRoom"
@export var zoom_in_size: float = 2.0
@export var zoom_in_time: float = 0.2
@export var in_mouse_time: float = 0.1

@onready var card_frame = $CardFrame
@onready var card_name_node = $CardFrame/CardName
@onready var card_image = $CardFrame/CardImage
@onready var card_text = $CardFrame/CardText
# TODO Add some room for flavour text?

var card_name

var starting_pos = Vector2()
var current_pos = Vector2()

var expanded = false
var moused_over = false

var original_left_bound
var original_right_bound

var following_mouse: bool

var original_width
var original_height

var world_right_x = ProjectSettings.get('display/window/size/viewport_width')
var world_bottom_y = ProjectSettings.get('display/window/size/viewport_height')

var life_heart = preload('res://assets/life_heart.png')
var motivation_heart = preload('res://assets/mv_heart.png')

const ICONS = {
	"TRAP": preload('res://assets/trap_icon.png'),
	"COMBAT": preload('res://assets/combat_icon.png'),
	"PUZZLE": preload('res://assets/puzzle_icon.png'),
	"SOCIAL": preload('res://assets/social_icon.png'),
	#"ENVIRONMENTAL": preload('res://assets/environmental_icon.png'),

	"RICHES": preload('res://assets/riches_icon.png'),
	"KNOWLEDGE": preload('res://assets/knowledge_icon.png'),
	"HONOUR": preload('res://assets/honour_icon.png'),
	"GLORY": preload('res://assets/glory_icon.png'),
	#"HEAL": preload('res://assets/heal_icon.png')
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.following_mouse = false

	var left_x = card_frame.get_rect().position.x
	var bottom_y = card_frame.get_rect().position.y

	var right_x = left_x + card_frame.get_rect().size.x
	var top_y = bottom_y + card_frame.get_rect().size.y

	original_width = right_x - left_x
	original_height = top_y - bottom_y

	starting_pos = transform.origin

	make_card(card)

func pascal(s: String):
	return s.to_pascal_case()

func make_card(card_id: String):
	card = card_id
	var card_data = GlobalVariables.Cards[card_id]
	assert(card)

	var card_description = card_data["description"]

	card_text.text = card_description + '\n'

	if card_id in GlobalVariables.EventData:
		var card_event = GlobalVariables.EventData[card_id]

		if len(card_event.bonuses):
			card_text.add_text('Types: ')

			if true:
				for bonus in card_event.bonuses:
					if bonus in ICONS:
						card_text.add_image(ICONS[bonus])
			else:
				card_text.add_text(str(card_event.bonuses.map(pascal)))

			card_text.add_text('\n')

		if len(card_event.reward_bonuses):
			card_text.add_text('Reward: ')

			if true:
				for bonus in card_event.reward_bonuses:
					if bonus in ICONS:
						card_text.add_image(ICONS[bonus])
			else:
				var card_reward_bonuses_text = 'Reward: ' + str(card_event.reward_bonuses.map(pascal))

				card_text.text += card_reward_bonuses_text

			if "HEAL" in card_event.reward_bonuses:
				card_text.add_text(', +' + str(GlobalVariables.heal_amount)) # TODO Is a hack, but we have no time
				card_text.add_image(life_heart)

			if card_event.reward_motivation > 0:
				card_text.add_text(', +' + str(card_event.reward_motivation))
				card_text.add_image(motivation_heart)

			if card_event.exp > 0:
				card_text.add_text(', +' + str(card_event.exp) + ' EXP')  # add_text rather than += to avoid clearing the stack and recognstructing which kills the image added previously

			card_text.add_text('\n')

		if card_event.base_chance < 1:
			var card_failure_text = 'Fail: '

			card_text.add_text(card_failure_text)

			if card_event.fail_damage > 0:
				card_text.add_text('-' + str(card_event.fail_damage))
				card_text.add_image(life_heart)

			if card_event.fail_demotivation > 0:
				card_text.add_text(', -' + str(card_event.fail_demotivation))
				card_text.add_image(motivation_heart)
	else: # Is a buff card
		match card_id:
			"HealPotion":
				card_text.add_text("Heals the hero by " + str(GlobalVariables.health_potion_amount))
				card_text.add_image(life_heart)
			"MotivationPotion":
				card_text.add_text("Motivates the hero by " + str(GlobalVariables.motivation_potion_amount))
				card_text.add_image(motivation_heart)
			"ExpBoost":
				card_text.add_text("Gives the hero " + str(GlobalVariables.exp_potion_amount) + " EXP")

	card_name_node.text = card_data["name"].replace('Room', ' Room').replace('Potion', ' Potion').replace('Boost', ' Boost')

	card_image.texture = card_data["image"]
	card_name = card_data["name"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.following_mouse:
		self.global_position.x = clamp(get_viewport().get_mouse_position().x + 70, 0 + self.original_width/2, world_right_x - self.original_width/2)
		self.global_position.y = clamp(get_viewport().get_mouse_position().y + 100, 0 + self.original_height/2, world_bottom_y - self.original_height/2)

func _on_area_2d_mouse_entered() -> void:
	self.expand()

	self.moused_over = true

func _on_area_2d_mouse_exited() -> void:
	self.shrink()

	self.moused_over = false

func expand(): # TODO If expanded and hover over another card in those bounds, stays expanded. Fix via signals?
	if not self.expanded and not self.following_mouse:
		var original_position = self.global_position
		self.transform = self.transform.scaled(Vector2(2, 2))
		self.global_position = original_position
		self.z_index += 1

		self.expanded = true

func shrink():
	if self.expanded:
		var original_position = self.global_position
		self.transform = self.transform.scaled(Vector2(0.5, 0.5))
		self.global_position = original_position
		self.z_index -= 1

		self.expanded = false

func _on_card_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if !GlobalVariables.tile_selected:
			GlobalVariables.tile_selected = self
			follow_mouse()
		elif GlobalVariables.tile_selected == self:
			stop_follow_mouse()
		elif GlobalVariables.tile_selected and GlobalVariables.tile_selected != self:
			GlobalVariables.tile_selected.stop_follow_mouse()
			GlobalVariables.tile_selected = self
			follow_mouse()
		card_left_clicked.emit(self)

func follow_mouse():
	self.following_mouse = true
	self.shrink()
	$Card.mouse_filter = 2 # Ignore Mouse
	self.z_index = 1

func stop_follow_mouse():
	self.following_mouse = false
	self.transform.origin = starting_pos
	$Card.mouse_filter = 1 # Pass Mouse
	self.z_index = 0
	# TODO Reset position

func _on_card_mouse_entered():
	self.expand()

	self.moused_over = true

func _on_card_mouse_exited():
	self.shrink()

	self.moused_over = false
