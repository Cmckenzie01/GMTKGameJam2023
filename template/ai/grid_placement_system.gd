extends Node

var tileGrid
var currTile
var prevTile
var nextTile

var selectedTile
var prevSelTile
var nextSelTile

var objectGrid

var defenceTowers = [
	Vector2(2, 0),
	Vector2(4, 0),
	Vector2(6, 0),
	Vector2(8, 0),
	Vector2(10, 0)
]

var defenceSelection = [
	Vector2(2, 6),
	Vector2(4, 6),
	Vector2(6, 6),
	Vector2(8, 6),
	Vector2(10, 6)
]


var towerIndex = 0
var prevIndex = defenceTowers.size() - 1
var nextIndex = 1

var selectedTower = defenceTowers[towerIndex]
var prevTower = defenceSelection[prevIndex]
var nextTower = defenceSelection[nextIndex]

func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("right_click"):
		tileGrid = get_tree().get_root().get_node("LevelOne/TileGrid") # placementGrid
		objectGrid = get_tree().get_root().get_node("LevelOne/TileMap") # objectGrid
		tileGrid.visible = !tileGrid.visible
		
		if selectedTile: # Clear selected item when placementGrid is turned off
			tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
			tileGrid.erase_cell(1, selectedTile)
			
			# clear prev/next towers
			tileGrid.erase_cell(1, prevSelTile)
			tileGrid.erase_cell(1, nextSelTile)
		
		selectedTile = null
		prevSelTile = null
		nextSelTile = null
		
	if Input.is_action_just_released("ui_text_scroll_up"):
		if tileGrid:
			if tileGrid.visible:
				towerIndex += 1
				prevIndex += 1
				nextIndex += 1
				if towerIndex > defenceTowers.size() - 1:
					towerIndex = 0
				if nextIndex > defenceTowers.size() - 1:
					nextIndex = 0
				if prevIndex > defenceTowers.size() - 1:
					prevIndex = 0
					
				selectedTower = defenceTowers[towerIndex]
				prevTower = defenceSelection[prevIndex]
				nextTower = defenceSelection[nextIndex]
				
				if selectedTile:
					tileGrid.set_cell(1, currTile, 0, selectedTower, 0)
					
					tileGrid.set_cell(1, prevTile, 0, prevTower, 0)
					tileGrid.set_cell(1, nextTile, 0, nextTower, 0)
					
					
			
	
	if Input.is_action_just_released("ui_text_scroll_down"):
		if tileGrid:
			if tileGrid.visible:
				towerIndex -= 1
				prevIndex -= 1
				nextIndex -= 1
				if towerIndex < 0:
					towerIndex = defenceTowers.size() - 1
				if prevIndex < 0:
					prevIndex = defenceTowers.size() - 1
				if nextIndex < 0:
					nextIndex = defenceTowers.size() - 1
					
				selectedTower = defenceTowers[towerIndex]
				prevTower = defenceSelection[prevIndex]
				nextTower = defenceSelection[nextIndex]
				
				if selectedTile: 
					
					tileGrid.set_cell(1, currTile, 0, selectedTower, 0)
					tileGrid.set_cell(1, prevTile, 0, prevTower, 0)
					tileGrid.set_cell(1, nextTile, 0, nextTower, 0)
	
		
	if Input.is_action_just_pressed("interact"):
		if tileGrid:
			if tileGrid.visible and selectedTile:
				selectedTower = defenceTowers[towerIndex]
				objectGrid.set_cell(1, selectedTile, 1, selectedTower, 0)
				tileGrid.erase_cell(1, selectedTile)
				selectedTile = null
				
				tileGrid.erase_cell(1, prevSelTile)
				tileGrid.erase_cell(1, nextSelTile)
				
				prevSelTile = null
				nextSelTile = null
		
	if tileGrid:
		if tileGrid.visible:
			
			selectedTower = defenceTowers[towerIndex]
			prevTower = defenceSelection[prevIndex]
			nextTower = defenceSelection[nextIndex]
			
			var playerGrid = get_tree().get_root().get_node("LevelOne/Player/GridMarker").global_position
			var flipped = get_tree().get_root().get_node("LevelOne/Player/GridMarker").position.x < 0
			# Returns the coordinates of the current marked tile
			
			currTile = tileGrid.local_to_map(playerGrid)
			var tileOffset
			if flipped:
				tileOffset = 2
			else:
				tileOffset = -2
			prevTile = currTile + Vector2i(tileOffset, -2)
			nextTile = currTile + Vector2i(tileOffset, 2)
			
			# Initialise First Selected Tile
			if selectedTile == null and tileGrid.get_cell_tile_data(0, currTile):
				tileGrid.set_cell(1, currTile, 0, selectedTower, 0) # Set Orange
				tileGrid.erase_cell(0, currTile) # Remove Purple
				
				selectedTile = currTile
				prevSelTile = prevTile
				nextSelTile = nextTile
				
				
				# prev/next
				tileGrid.set_cell(1, prevTile, 0, prevTower, 0)
				tileGrid.set_cell(1, nextTile, 0, nextTower, 0)
				
				
			# Switch Tile (if previous tile, curr tile exists and tiles are not the same
			elif selectedTile and tileGrid.get_cell_tile_data(0, currTile) and !(selectedTile == currTile):
				# set new tile orange 
				tileGrid.set_cell(1, currTile, 0, selectedTower, 0)
				tileGrid.erase_cell(0, currTile)
				
				### set prev & next tiles
				tileGrid.set_cell(1, prevTile, 0, prevTower, 0)
				tileGrid.set_cell(1, nextTile, 0, nextTower, 0)
				
				# set old tile purple
				tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
				tileGrid.erase_cell(1, selectedTile)
				
				# erase old select position
				tileGrid.erase_cell(1, nextSelTile)
				tileGrid.erase_cell(1, prevSelTile)
				
			
				# make new tile -> old tile
				selectedTile = currTile
				prevSelTile = prevTile
				nextSelTile = nextTile
				
				
			# Switch Tile but there's no new tile
			elif selectedTile and !(tileGrid.get_cell_tile_data(0, currTile)) and !(selectedTile == currTile):
				# set old tile purple
				tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
				tileGrid.erase_cell(1, selectedTile)
				
				### clear prev & next tiles
				tileGrid.erase_cell(1, prevSelTile)
				tileGrid.erase_cell(1, nextSelTile)
				
			
				
				# set selected tile null
				selectedTile = null
				prevSelTile = null
				nextSelTile = null
			
			# In theory nothing should happen if the tiles match
			
					
			
			#0, coords, 1, atlas_coords, 0
			
	
		
		

func _Input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		print("mouse down")
		tileGrid = get_tree().get_root().get_node("TileGrid")
		tileGrid.visible = !tileGrid.visible
		
