class_name CaltropsTower extends Node2D

@export var tower_range: int = 300
@export var fire_rate: float = 3 # Caltrops per second
@export var lifespan: int = 1 
@export var damage: int = 1
@export var max_caltrops: int = 3

var timer 
var caltrops_bag
@onready var spawner = $CaltropSpawner

signal spawn_caltrop(origin: Vector2, destination: Vector2, lifespan: int, damage: int) # TODO Element?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('towers')
	
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false 
	timer.wait_time = 1 / self.fire_rate
	timer.stop()
	
	add_child(timer)
	
	caltrops_bag = Node2D.new()
	
	add_child(caltrops_bag)
	
	self.spawn_caltrop.connect(GlobalMechanics.spawn_caltrop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer.is_stopped() and len(caltrops_bag.get_children()) < self.max_caltrops:
		create_caltrop()
		
func create_caltrop() -> void:   
	var window_bounds = DisplayServer.window_get_size()
	
	#print(window_bounds)
	
	var x_min = max(self.global_position.x - self.tower_range, 0)
	var x_max = min(self.global_position.x + self.tower_range, window_bounds.x)
	# TODO Ideally over platform too
	var destination_x = randi_range(x_min, x_max)
	
	var destination = Vector2(destination_x, self.global_position.y) #  - (self.height / 2))
	
	spawn_caltrop.emit(self.spawner.global_position, destination, self.lifespan, self.damage, caltrops_bag)
	
