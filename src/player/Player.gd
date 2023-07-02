extends CharacterBody2D

@export var speed: float = 200
@export var slide_multiplier: float = 1.5
@export var jump_speed: float = -400
@export var double_jump_speed: float = -320
@export var maximum_jumps: int = 2
@export var coyote_frames = 30
@export var gravity: float = 600
@export_range(0.0, 1.0) var friction: float = 0.5
@export_range(0.0, 1.0) var acceleration: float = 0.5

# JUMP VARIABLES
var jumps_made: int = 0
var coyote = false
var last_floor = false
var jumping = false

# STATE MACHINE
enum {
	IDLE,
	RUNNING,
	SLIDE,
	JUMP,
	DOUBLE_JUMP,
	FALL,
	ATTACK
}
@onready var state = IDLE

# GRID MARKER
@onready var gridMarker = $GridMarker


func _ready():
	$CoyoteTimer.wait_time = coyote_frames / 60.0
	

func state_machine():
	# Left/Right Animation Flips
	if velocity.x < 0:
		$Sprite.flip_h = true
		gridMarker.position.x = -74
	if velocity.x > 0:
		$Sprite.flip_h = false
		gridMarker.position.x = 64
	
	# Animations
	match(state):
		IDLE:
			$AnimationPlayer.play("Idle")
		
		RUNNING:
			$AnimationPlayer.play("Running")
		
		SLIDE:
			$AnimationPlayer.play("Slide")
			await $AnimationPlayer.animation_finished
			state = IDLE
		
		JUMP:
			$AnimationPlayer.play("Jump")
			if is_on_floor():
				state = IDLE
		
		DOUBLE_JUMP:
			$AnimationPlayer.play("Double_Jump")
			if is_on_floor():
				state = IDLE
		
		FALL:
			$AnimationPlayer.play("Fall")
			if is_on_floor():
				state = IDLE
		
		ATTACK:
			$AnimationPlayer.play("Melee_Attack")
			await $AnimationPlayer.animation_finished
			state = IDLE


func _physics_process(delta):
	var AIRBORNE: bool = state == JUMP or state == DOUBLE_JUMP or state == FALL
	var ATTACKING: bool = state == ATTACK # or state == RANGED_ATTACK
	var SLIDING: bool = state == SLIDE # or state == PHASE_SLIDE
	
	var CAN_JUMP_OR_RUN: bool = !SLIDING and !ATTACKING 
	var CAN_SLIDE: bool = velocity.x != 0 and !AIRBORNE and !ATTACKING
	
	# movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if !SLIDING:
		if direction != 0:
			# speed up
			velocity.x = lerp(velocity.x, direction * speed, acceleration)
		else:
			# slow down
			velocity.x = lerp(velocity.x, 0.0, friction)
	
	# set default IDLE when not moving or attacking	
	if !ATTACKING and !AIRBORNE:
		if -10 <= velocity.x and velocity.x <= 10:
			state = IDLE
		# else run
		elif velocity.x != 0 and CAN_JUMP_OR_RUN:
			state = RUNNING
	
	# slide
	if Input.is_action_just_pressed("ui_down") and CAN_SLIDE:
		velocity.x *= 1.5
		SLIDING = true
		state = SLIDE
	
	# attack 	
	if Input.is_action_just_pressed("attack"):
		ATTACKING = true
		state = ATTACK
		
	# reset jump variables
	if is_on_floor():
		jumping = false
		jumps_made = 0

	# jump
	if Input.is_action_just_pressed("ui_up"):
		# has jumps left
		if jumps_made < maximum_jumps:
			# first jump
			if (is_on_floor() or coyote) and CAN_JUMP_OR_RUN and jumps_made == 0:
				velocity.y = jump_speed
				AIRBORNE = true
				state = JUMP
			# follow-up jumps
			if not is_on_floor() and CAN_JUMP_OR_RUN and jumps_made > 0:
				velocity.y = double_jump_speed
				AIRBORNE = true
				state = DOUBLE_JUMP 
			
			jumps_made += 1
				
	# cancelled jump
	if Input.is_action_just_released("ui_up") and velocity.y < jump_speed * 0.5:
		velocity.y = jump_speed * 0.5
			

	# prolonged state animations
	if not is_on_floor() and !ATTACKING:
		if velocity.y < 0 and jumps_made == 1:
			state = JUMP
		elif velocity.y < 0 and jumps_made > 1:
			state = DOUBLE_JUMP
		else:
			state = FALL	
			
	if not is_on_floor() and ATTACKING:
		state = ATTACK

	# jump coyote logic
	if not is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()	
	last_floor = is_on_floor()

	# loop	
	velocity.y += gravity * delta
	move_and_slide()
	state_machine()


func _on_coyote_timer_timeout():
	coyote = false
