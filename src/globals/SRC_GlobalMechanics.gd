extends Node

@onready var scene_root = get_tree().get_root()

# TileMaps
@onready var tileGrid: TileMap = scene_root.get_node("LevelOne/TileGrid") 
@onready var objectGrid: TileMap = scene_root.get_node("LevelOne/TileMap") 

# Grid Marker
@onready var playerMarker = scene_root.get_node("LevelOne/Player/GridMarker").global_position
@onready var flipped = scene_root.get_node("LevelOne/Player/GridMarker").position.x < 0

### TEMP
@onready var towersBox = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers")
@onready var towerSelector = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/selector")

@onready var tower1 = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/tower1")
@onready var tower2 = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/tower2")
@onready var tower3 = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/tower3")
@onready var tower4 = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/tower4")
@onready var tower5 = scene_root.get_node("LevelOne/CanvasLayer/TowerBar/Towers/tower5")

@onready var overlayIndex = towerIndex

# Tiles
var markedTile: Vector2i
var activeTile = null

# Tower Grid/Atlas Coordinates
var availableTowers = [
	Vector2(2, 0), # Tower 1,
	Vector2(4, 0), # Tower 2, etc...
	Vector2(6, 0),
	Vector2(8, 0),
	Vector2(10, 0)
]
var towerIndex: int = 0 # defenceTower key
var activeTower: Vector2 = availableTowers[towerIndex] # defenceTower object


func _ready():
	### TEMP
	towerSelector.global_position = tower1.global_position
	tower1.self_modulate = Color(1, 1, 1, 1)
	
func setOverlay():
	### TEMP HACK SOLUTION - WILL UPDATE WHEN DOING THE REST OF THE GUI
	if overlayIndex != towerIndex:
		match overlayIndex:
			0:
				tower1.self_modulate = Color(1, 1, 1, 0.3)
			1:
				tower2.self_modulate = Color(1, 1, 1, 0.3)
			2:
				tower3.self_modulate = Color(1, 1, 1, 0.3)
			3:
				tower4.self_modulate = Color(1, 1, 1, 0.3)
			4:
				tower5.self_modulate = Color(1, 1, 1, 0.3)
		match towerIndex:
			0:
				tower1.self_modulate = Color(1, 1, 1, 1)
				towerSelector.global_position = tower1.global_position
			1:
				tower2.self_modulate = Color(1, 1, 1, 1)
				towerSelector.global_position = tower2.global_position
			2:
				tower3.self_modulate = Color(1, 1, 1, 1)
				towerSelector.global_position = tower3.global_position
			3:
				tower4.self_modulate = Color(1, 1, 1, 1)
				towerSelector.global_position = tower4.global_position
			4:
				tower5.self_modulate = Color(1, 1, 1, 1)
				towerSelector.global_position = tower5.global_position
		overlayIndex = towerIndex

func _process(_delta):
	# Placement Grid Active
	if tileGrid.visible:
		activeTower = availableTowers[towerIndex]
		playerMarker = scene_root.get_node("LevelOne/Player/GridMarker").global_position
		flipped = scene_root.get_node("LevelOne/Player/GridMarker").position.x < 0
			
		# Current Marked Tile
		markedTile = tileGrid.local_to_map(playerMarker)
			
		# Initialise First Selected Tile (if there is no active tile and the marked tile exists)
		if activeTile == null and tileGrid.get_cell_tile_data(0, markedTile):
			tileGrid.set_cell(1, markedTile, 0, activeTower, 0) # Set Tower Cell in Tower Layer (1)
			tileGrid.erase_cell(0, markedTile) # Remove Cell in Empty Layer (0)
			
			# Set the active tile as the current marked tile
			activeTile = markedTile

				
		# Switch Active Tiles (if active tile exists, new marked tile exists, and they're not the same tile)
		elif activeTile and tileGrid.get_cell_tile_data(0, markedTile) and !(activeTile == markedTile):
			tileGrid.set_cell(1, markedTile, 0, activeTower, 0) # Set Tower Cell in Tower Layer
			tileGrid.erase_cell(0, markedTile) # Remove Cell in Empty Layer
				
			# Remove previous Tower and reset empty cell in previous square
			tileGrid.set_cell(0, activeTile, 1, Vector2(0,0), 0) # Set purple block
			tileGrid.erase_cell(1, activeTile) # Remove old Tower

			# Set the active tile as the current marked tile
			activeTile = markedTile
				
				
		# Switch Tiles (when no new marked tile is available
		elif activeTile and !(tileGrid.get_cell_tile_data(0, markedTile)) and !(activeTile == markedTile):
			# Remove previous Tower and reset empty cell in previous square
			tileGrid.set_cell(0, activeTile, 1, Vector2(0,0), 0)
			tileGrid.erase_cell(1, activeTile)

			# Set the active tile to null
			activeTile = null
		
	
	# Activate/Deactivate Placement Grid
	if Input.is_action_just_pressed("right_click"):
		tileGrid.visible = !tileGrid.visible
		
		if activeTile: # Remove previous Tower and reset empty cell when grid is deactivated
			tileGrid.set_cell(0, activeTile, 1, Vector2(0,0), 0)
			tileGrid.erase_cell(1, activeTile)
			
		activeTile = null # Should start and end empty
		
	# Place Tower when grid is active, and there is a selected tile/tower
	if Input.is_action_just_pressed("interact") and tileGrid.visible and activeTile:
			activeTower = availableTowers[towerIndex]
			
			# Set Tower in Object Grid
			objectGrid.set_cell(1, activeTile, 1, activeTower, 0)
			
			# Remove Tower Hologram
			tileGrid.erase_cell(1, activeTile)
			activeTile = null
			
	if Input.is_action_just_released("ui_text_scroll_up") and tileGrid.visible and activeTile:
		towerIndex += 1
		if towerIndex > availableTowers.size() - 1:
			towerIndex = 0
		activeTower = availableTowers[towerIndex]
		
		if activeTile:
			tileGrid.set_cell(1, markedTile, 0, activeTower, 0)
			
		setOverlay()


	if Input.is_action_just_released("ui_text_scroll_down") and tileGrid.visible and activeTile:
		towerIndex -= 1
		if towerIndex < 0:
			towerIndex = availableTowers.size() - 1
		activeTower = availableTowers[towerIndex]
		
		if activeTile:
			tileGrid.set_cell(1, markedTile, 0, activeTower, 0)
		
		setOverlay()
		
					
	
		
