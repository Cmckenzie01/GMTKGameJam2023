extends CharacterBody2D

@export var speed: float = 400
@export var jump_speed: float = -800
@export var double_jump_speed: float = -640
@export var maximum_jumps: int = 2
@export var gravity: float = 1200
@export_range(0.0, 1.0) var friction: float = 1
@export_range(0.0, 1.0) var acceleration: float = 1

var jumps_made: int = 0

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

# NEW
@onready var gridMarker = $GridMarker

func _ready():
	pass
	

func state_machine():
	if velocity.x < 0:
		$Sprite.flip_h = true
		gridMarker.position.x = -74
	if velocity.x > 0:
		$Sprite.flip_h = false
		gridMarker.position.x = 64
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
			state = FALL
		DOUBLE_JUMP:
			$AnimationPlayer.play("Double_Jump")
			state = FALL
		FALL:
			$AnimationPlayer.play("Fall")
		ATTACK:
			$AnimationPlayer.play("Melee_Attack")
			await $AnimationPlayer.animation_finished
			state = IDLE


func _physics_process(delta):
	#if Input.is_action_just_pressed("right_click"):
	#	placementBlock.visible = !placementBlock.visible
	
	if state != SLIDE:
		velocity.y += gravity * delta
		var dir = Input.get_axis("ui_left", "ui_right")
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			
		if -10 <= velocity.x and velocity.x <= 10 and state != ATTACK:
			state = IDLE
		elif velocity.x != 0 and Input.is_action_just_pressed("ui_down") and state != JUMP and state != DOUBLE_JUMP and state != FALL and state != ATTACK:
			velocity.x *= 1.5
			state = SLIDE
		elif velocity.x != 0 and state != SLIDE and state != ATTACK:
			state = RUNNING
			
		if is_on_floor() and state != SLIDE and state != ATTACK:
			jumps_made = 0
			if Input.is_action_just_pressed("ui_up") and jumps_made != 1:
				jumps_made += 1
				velocity.y = jump_speed
				state = JUMP
			
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
			
	if not is_on_floor() and state != ATTACK:
		if velocity.y < 0 and jumps_made == 1:
			state = JUMP
		elif velocity.y < 0 and jumps_made == 2:
			state = DOUBLE_JUMP
		else:
			state = FALL
			
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
			
	if not is_on_floor() and Input.is_action_just_pressed("ui_up"):
		jumps_made += 1
		if jumps_made == 2:
			velocity.y = double_jump_speed
			state = DOUBLE_JUMP
		
	if state == ATTACK:
		velocity.x = lerp(velocity.x, 0.0, friction)
			
		
	move_and_slide()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed


		
	velocity.y += gravity * delta
	move_and_slide()
	state_machine()
