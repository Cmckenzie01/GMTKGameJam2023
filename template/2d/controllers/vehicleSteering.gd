extends CharacterBody2D

@export var wheel_base: float = 70 # Distance from front to rear wheel
@export var steering_angle: float = 25 # Amount that front wheel turns, in degrees

var steer_direction

@export var engine_power: float = 450 # Forward acceleration force
var acceleration: Vector2 = Vector2.ZERO

@export var friction: float = -055
@export var drag: float = -0.06

@export var braking: float = -450
@export var max_speed_reverse: float = 250

@export var slip_speed: float = 400 # Speed where traction is reduced
@export var traction_fast: float = 2.5 # High-speed traction
@export var traction_slow: float = 10 # Low-speed traction

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	
func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		velocity = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

