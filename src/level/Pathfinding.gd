extends Node2D

var astar = AStar2D.new()
var tilemap : TileMap
var half_cell_size: Vector2
var used_rect : Rect2

func create_navigation_map(tilemap: TileMap):
	self.tilemap = tilemap
	
	half_cell_size = Vector2(tilemap.cell_quadrant_size / 2, tilemap.cell_quadrant_size / 2)
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells(0)
	
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	
func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
	
func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		
		for x in range(3):
			for y in range(3):
				var target = tile + Vector2(x - 1, y - 1)
				var target_id = get_id_for_point(target)
				
				if tile == target or not astar.has_point(target_id):
					continue
				
				astar.connect_points(id, target_id, true)

func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x
