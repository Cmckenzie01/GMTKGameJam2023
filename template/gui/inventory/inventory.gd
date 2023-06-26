extends Node2D

const SlotClass = preload("res://template/gui/inventory/slot.gd")
@onready var inventory_slots = $TextureRect/GridContainer
@onready var holding_offset = Vector2(120, 120)
var holding_item = null

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		var slot = slots[i]
		slot.gui_input.connect(slot_gui_input.bind(slot))
		slot.slot_index = i
	initialize_inventory()
	
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if GlobalInventory.inventory.has(i):
			slots[i].initialize_item(GlobalInventory.inventory[i][0], GlobalInventory.inventory[i][1])
			
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			# Currently holding an Item
			if holding_item != null:
				if !slot.item: # Place holding item to slot
					left_click_empty_slot(slot)
				else:
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(event, slot)
			elif slot.item:
				left_click_not_holding(slot)
		#TODO: ADD RIGHT CLICK ITEM SPLIT FUNCTIONALITY
				
				
func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - holding_offset
		
func left_click_empty_slot(slot: SlotClass):
	GlobalInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null
	
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	GlobalInventory.remove_item(slot)
	GlobalInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item
	
func left_click_same_item(_event: InputEvent, slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		GlobalInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		GlobalInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	GlobalInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position() - holding_offset
