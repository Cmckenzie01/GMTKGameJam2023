class_name Card extends Node2D

signal card_left_clicked(card)

@export var tile: String = "TileOne"
@export var zoom_in_size: float = 2.0
@export var zoom_in_time: float = 0.2
@export var in_mouse_time: float = 0.1

@onready var card_name: String = GlobalVariables.DungeonTiles[tile]["name"]
@onready var image = GlobalVariables.DungeonTiles[tile]["image"]
@onready var description = GlobalVariables.DungeonTiles[tile]["description"]
@onready var effets = GlobalVariables.DungeonTiles[tile]["effects"]


@onready var card_name_node = $CardFrame/CardName
@onready var card_image = $CardFrame/CardImage
@onready var card_text = $CardFrame/CardText
# TODO Add room for flavour text?

var starting_pos = Vector2()
var current_pos = Vector2()

var expanded = false 
var moused_over = false

signal play_card(effects: Array)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    card_name_node.text = card_name
    card_text.text = description
    card_image.texture = image 
    
    starting_pos = global_position
    current_pos = global_position
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _on_area_2d_mouse_entered() -> void:
    if not self.expanded:
        self.expand()
        
    self.moused_over = true
    
func _on_area_2d_mouse_exited() -> void:
    self.shrink()
    
    self.moused_over = false
    
func expand(): # TODO If expanded and hover over another card in those bounds, stays expanded. Fix via signals?
    var original_position = self.global_position 
    self.transform = self.transform.scaled(Vector2(2, 2))
    self.global_position = original_position
    self.z_index += 1
    
    self.expanded = true 
    
func shrink():
    var original_position = self.global_position 
    self.transform = self.transform.scaled(Vector2(0.5, 0.5))
    self.global_position = original_position
    self.z_index -= 1
    
    self.expanded = false 
    
func _input(event: InputEvent):
    # TODO: Single Click Card, emit signal card_left_clicked(card/self) to GUI Script,
    # which will handle the dragging the card around the screen functionality and what happens if 
    # left clicked again (if over slot, active card, if not, return to hand)
    
    if event is InputEventMouseButton and event.double_click and self.moused_over:
        print('Double click')
        
        play_card.emit(self.effects)
        
func _on_gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
            emit_signal("card_left_clicked", self)
