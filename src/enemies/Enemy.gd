extends CharacterBody2D

@export var movement_speed: float = 150.0
@export var jump_speed: float = -550
@export var jump_delay: int = 2
@export var double_jump_speed: float = -640
@export var maximum_jumps: int = 2
@export var gravity: float = 1200
@export_range(0.0, 1.0) var friction: float = 1
@export_range(0.0, 1.0) var acceleration: float = 1

var jumps_made: int = 0

@export var movement_target: Node2D

@onready var jump_delay_timer = jump_delay

var current_path: PackedVector2Array

func _ready():
	pass

func _physics_process(delta):
	#if Input.is_action_just_pressed("action"):
	velocity.y += gravity * delta
		
	var current_agent_position: Vector2 = global_position
	
	current_agent_position = global_position
	var target_point: Vector2 = movement_target.global_position
	var nav_map: RID = get_world_2d().get_navigation_map()
	current_path = NavigationServer2D.map_get_path(nav_map, current_agent_position, target_point, false)
	var y_distance = 1
	if current_path.size() > 1:
		y_distance = current_path[1].y - current_path[0].y
	if current_path.size():
		current_path.remove_at(0)
		
	var next_path_position: Vector2
	var new_velocity: Vector2
		
	if current_path.size():
		next_path_position = current_path[0]
		new_velocity = next_path_position - current_agent_position 
		new_velocity = new_velocity.normalized() * movement_speed
			
		#if new_velocity.x < 20:
		#	current_path.remove_at(0)
	
		velocity.x = new_velocity.x
		
	if is_on_floor() and y_distance < -10 and velocity.x < 10:
		jumps_made = 0 
		if jump_delay_timer < 0 and jumps_made != 1:
			jumps_made += 1
			velocity.y = jump_speed
			jump_delay_timer = jump_delay
		else:
			jump_delay_timer -= 1
			
	move_and_slide()


		
	
