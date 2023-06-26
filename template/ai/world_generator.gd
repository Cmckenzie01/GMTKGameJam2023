extends Node2D

@onready var tilemap = $TileMap
@onready var player = $player

const MAP_SIZE = Vector2(140, 80)

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var biome = {}
var empty_land_cells = []
var objects = {}

var tiles = {"grass": Vector2(0, 0), "jungle_grass": Vector2(0,0), "sand": Vector2(0,0), "water": Vector2(3,3), "stone": Vector2(0,0)}
var object_tiles = {"tree": preload("res://template/code/components/Tree.tscn"), "bush": preload("res://template/code/components/Bush.tscn")}

var biome_data = {
	"plains": {"grass": 1},
	"beach": {"sand": 0.95, "stone": 0.05},
	"jungle": {"jungle_grass": 1},
	"desert": {"sand": 0.95, "stone": 0.05},
	"lake": {"water": 1},
	"mountain": {"stone": 0.95, "grass": 0.05},
	"snow": {"snow": 0.95, "stone": 0.03, "grass": 0.02},
	"ocean": {"water": 1}
}

var object_data = {
	"plains": {"tree": 0.03},
	"beach": {"tree": 0.01, "bush": 0.01},
	"jungle": {"tree": 1},
	"desert": {"tree": 0.05, "bush": 0.05},
	"lake": {},
	"mountain": {"tree": 0.05, "bush": 0.05},
	"snow": {"tree": 0.05, "bush": 0.03},
	"ocean": {}
}


func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.001
	#generate_world(player.position)

func _process(_delta):
	generate_world(player.position)

@warning_ignore("shadowed_variable_base_class")
func generate_world(position):
	var tile_pos = tilemap.local_to_map(position)
	
	for x in range(MAP_SIZE.x):
		for y in range(MAP_SIZE.y):
			var coords = Vector2i(tile_pos.x - MAP_SIZE.x / 2 + x, tile_pos.y - MAP_SIZE.y / 2 + y)
			var moist = moisture.get_noise_2d(coords.x, coords.y) * 10
			var temp = temperature.get_noise_2d(coords.x, coords.y) * 10
			var alt = altitude.get_noise_2d(coords.x, coords.y) * 150
			
			var atlas_coords = Vector2(3 if alt < 2 else round((moist + 10) / 5), round((temp + 10) / 5))
			
			tilemap.set_cell(0, coords, 1, atlas_coords, 0)
			
			var tile_biome = null
			if atlas_coords.x == 3:
				tile_biome = "ocean"
			elif atlas_coords.y == 0:
				tile_biome = "mountain"
			elif atlas_coords == Vector2(0, 2) or atlas_coords == Vector2(2,0) or atlas_coords == Vector2(0, 3):
				tile_biome = "desert"	
			else: tile_biome = "plains"
			
			biome[coords] = tile_biome
			
			if atlas_coords.x != 3:
				empty_land_cells.append(coords)
	
	### Process Generation doesn't like cliffs and will duplicate objects, use only on _ready generation			
	#tilemap.set_cells_terrain_connect(1, empty_land_cells, 0, 0)
	#set_objects()

@warning_ignore("shadowed_variable")
func random_tile(data, biome):
	var current_biome = data[biome]
	var rand_num = randf_range(0,1)
	var running_total = 0
	for tile in current_biome:
		running_total = running_total+current_biome[tile]
		if rand_num <= running_total:
			return tile

func set_objects():
	objects = {}
	for pos in biome:
		var current_biome = biome[pos]
		var random_object = random_tile(object_data, current_biome)
		objects[pos] = random_object
		if random_object != null:
			tile_to_scene(random_object, pos)
			
func tile_to_scene(random_object, pos):
	var instance = object_tiles[str(random_object)].instantiate()
	instance.position = tilemap.map_to_local(pos)
	instance.scale = instance.scale * 5
	add_child(instance)
	
