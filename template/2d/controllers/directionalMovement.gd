extends CharacterBody2D

# MOVEMENT VARIABLES
@export var ACCELERATION: int = 15000
@export var MAX_SPEED: int = 1250
@export var ROLL_SPEED: int = 1750
@export var FRICTION: int = 18000

# STATES
enum {
	MOVE,
	ROLL,
	ATTACK
}

@onready var state = MOVE
@onready var roll_vector: Vector2 = Vector2.LEFT


# ANIMATIONS
@onready var sprite = $Sprite2D
@onready var animPlayer = $AnimationPlayer
@onready var animTree = $AnimationTree
@onready var animState = animTree.get("parameters/playback")


# CODE
func _ready():
	# set sprite by code ### sprite.texture = sprite input
	randomize()
	animTree.active = true
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			#roll_state()
			state = MOVE
		ATTACK:
			attack_state()
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animTree.set("parameters/Idle/blend_position", input_vector)
		animTree.set("parameters/Run/blend_position", input_vector)
		animTree.set("parameters/Attack/blend_position", input_vector)
		animTree.set("parameters/Roll/blend_position", input_vector)
		animState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animState.travel("Roll")
	move()
		
func attack_state():
	velocity = Vector2.ZERO
	animState.travel("Attack")

func move():
	move_and_slide()

func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
