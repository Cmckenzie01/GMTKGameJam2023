class_name Card extends Node2D

@export var card_name: String = 'The Card'
@export var image = preload('res://assets/Cards/pig.jpg')
@export var description = "I'm a card! Look at me! Card card card!"
@export var effects = [] # TODO Make some of these

@onready var card_name_node = $CardFrame/CardName
@onready var card_image = $CardFrame/CardImage
@onready var card_text = $CardFrame/CardText
# TODO Add room for flavour text?

var expanded = false 
var moused_over = false

signal play_card(effects: Array)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    card_name_node.text = card_name
    card_text.text = description
    card_image.texture = image 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
    
    card_text.add_theme_font_size_override('expanded_font', 16)
    
    self.expanded = true 
    
func shrink():
    var original_position = self.global_position 
    self.transform = self.transform.scaled(Vector2(0.5, 0.5))
    self.global_position = original_position
    self.z_index -= 1
    
    card_text.remove_theme_font_size_override('expanded_font')
    
    self.expanded = false 
    
func _input(event: InputEvent):
    if event is InputEventMouseButton and event.double_click and self.moused_over:
        print('Double click')
        
        play_card.emit(self.effects)
