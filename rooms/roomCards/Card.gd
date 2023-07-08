class_name Card extends Node2D

signal play_card(effects: Array)
signal card_left_clicked(card)

@export var tile: String = "TileOne"
@export var zoom_in_size: float = 2.0
@export var zoom_in_time: float = 0.2
@export var in_mouse_time: float = 0.1

@onready var card_name: String = GlobalVariables.DungeonTiles[tile]["name"]
@onready var image = GlobalVariables.DungeonTiles[tile]["image"]
@onready var description = GlobalVariables.DungeonTiles[tile]["description"]
@onready var effets = GlobalVariables.DungeonTiles[tile]["effects"]

@onready var card_frame = $CardFrame
@onready var card_name_node = $CardFrame/CardName
@onready var card_image = $CardFrame/CardImage
@onready var card_text = $CardFrame/CardText
# TODO Add some room for flavour text?

var starting_pos = Vector2()
var current_pos = Vector2()

var expanded = false 
var moused_over = false

var original_left_bound
var original_right_bound

var following_mouse: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_name_node.text = card_name
	card_text.text = description
	card_image.texture = image
	
	self.following_mouse = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.following_mouse:
		self.global_position = get_viewport().get_mouse_position()

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
	
func _input(event: InputEvent):
	# TODO: Single Click Card, emit signal card_left_clicked(card/self) to GUI Script,
	# which will handle the dragging the card around the screen functionality and what happens if 
	# left clicked again (if over slot, active card, if not, return to hand)
	
	if event is InputEventMouseButton and self.moused_over and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print('Single click on ' + self.card_name)
		
		card_left_clicked.emit(self)
				
func follow_mouse(card: Card):
	if self.name == card.name:
		print("I am going to follow the mouse", self.name)
		self.following_mouse = true
		self.shrink()
		
func stop_follow_mouse(card: Card):
	if self.name == card.name:
		print("I am going to stop following the mouse", self.name)
		self.following_mouse = false
		# TODO Reset position
