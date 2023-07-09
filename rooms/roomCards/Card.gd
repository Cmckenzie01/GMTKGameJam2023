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

func make_card(card_id: String):
	card = card_id
	var card_data = GlobalVariables.Cards[card_id]
	assert(card)
	
	

	card_name_node.text = card_data["name"]
	card_text.text = card_data["description"]
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
