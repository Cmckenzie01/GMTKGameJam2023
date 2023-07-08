extends CanvasLayer

const SlotClass = 0#preload("res://rooms/roomCards/Card.gd") #To be replaced with slot script

var holding_offset = Vector2(120, 120)
var holding_card = null


func _ready():
    if $CardUI/TileCards.get_children():
        for child in $CardUI/TileCards.get_children():
            child.card_left_clicked.connect(card_left_clicked)
    
    
    
func slot_gui_input(event: InputEvent, slot):#: SlotClass):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
            # Currently holding a Card
            if holding_card != null:
                if !slot.occupied: # Place card item to slot
                    left_click_empty_slot(slot)
                else:
                    if slot.occupied: 
                        left_click_occupied_slot(slot) 
                    else: # Clicked anywhere on screen that isn't a slot
                        return_card_to_hand() 
            elif holding_card == null:
                pass
                

func left_click_empty_slot(slot):#: SlotClass):
    pass 
    # TODO: Activate Card Effect depending on Slot, 
    #(i.e., if TileCard, place the appropriate room scene on the map
    
func left_click_occupied_slot(slot):
    pass
    # TODO: Visual cue that card cannot be placed in an occupied slot
    
func return_card_to_hand():
    pass
    
func card_left_clicked(card):
    print("This card has been left clicked ", card)
    
