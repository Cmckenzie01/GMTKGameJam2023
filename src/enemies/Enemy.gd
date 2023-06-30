extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var jump_speed: float = -600
@export var jump_delay: int = 1
@export var double_jump_speed: float = -640
@export var maximum_jumps: int = 2
@export var gravity: float = 1200
@export_range(0.0, 1.0) var friction: float = 1
@export_range(0.0, 1.0) var acceleration: float = 1

var jumps_made: int = 0

@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 10.0
	navigation_agent.max_speed = movement_speed
	navigation_agent.avoidance_enabled = true
	navigation_agent.navigation_layers = 1
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	set_movement_target(Vector2(634, 141))
#movement_target.position

func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	

func _physics_process(delta):
	#if Input.is_action_just_pressed("action"):
		velocity.y += gravity * delta
		
		if navigation_agent.is_navigation_finished():
			return
			
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		
		var new_velocity: Vector2 = next_path_position - current_agent_position 
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * movement_speed
		
		velocity.x = new_velocity.x
		
		if is_on_floor() and velocity.x < 50:
			jumps_made = 0 
			if jump_delay < 0 and jumps_made != 1:
				jumps_made += 1
				velocity.y = jump_speed
				jump_delay = 100
			else:
				jump_delay -= 1
			
		move_and_slide()
	
