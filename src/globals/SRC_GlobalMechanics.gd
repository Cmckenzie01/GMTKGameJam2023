extends Node

var tileGrid
var currTile
var selectedTile
var objectGrid

func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("right_click"):
		tileGrid = get_tree().get_root().get_node("LevelOne/TileGrid")
		objectGrid = get_tree().get_root().get_node("LevelOne/TileMap")
		tileGrid.visible = !tileGrid.visible
		
		if selectedTile:
			tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
			tileGrid.erase_cell(1, selectedTile)
		
		selectedTile = null
		
	if Input.is_action_just_pressed("interact"):
		if tileGrid:
			if tileGrid.visible and selectedTile:
				objectGrid.set_cell(1, selectedTile, 1, Vector2(2,0), 0)
				tileGrid.erase_cell(1, selectedTile)
				selectedTile = null
		
	if tileGrid:
		if tileGrid.visible:
			var playerGrid = get_tree().get_root().get_node("LevelOne/Player/GridMarker").global_position
			# Returns the coordinates of the current marked tile
			currTile = tileGrid.local_to_map(playerGrid)
			
			# Initialise First Selected Tile
			if selectedTile == null and tileGrid.get_cell_tile_data(0, currTile):
				tileGrid.set_cell(1, currTile, 0, Vector2(2,0), 0) # Set Orange
				tileGrid.erase_cell(0, currTile) # Remove Purple
				selectedTile = currTile
				
			# Switch Tile (if previous tile, curr tile exists and tiles are not the same
			elif selectedTile and tileGrid.get_cell_tile_data(0, currTile) and !(selectedTile == currTile):
				# set new tile orange 
				tileGrid.set_cell(1, currTile, 0, Vector2(2,0), 0)
				tileGrid.erase_cell(0, currTile)
				
				# set old tile purple
				tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
				tileGrid.erase_cell(1, selectedTile)
			
				# make new tile -> old tile
				selectedTile = currTile
				
			# Switch Tile but there's no new tile
			elif selectedTile and !(tileGrid.get_cell_tile_data(0, currTile)) and !(selectedTile == currTile):
				# set old tile purple
				tileGrid.set_cell(0, selectedTile, 1, Vector2(0,0), 0)
				tileGrid.erase_cell(1, selectedTile)
				
				# set selected tile null
				selectedTile = null
			
			# In theory nothing should happen if the tiles match
			
					
			
			#0, coords, 1, atlas_coords, 0
			
	
		
		

func _Input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		print("mouse down")
		tileGrid = get_tree().get_root().get_node("TileGrid")
		tileGrid.visible = !tileGrid.visible
		
