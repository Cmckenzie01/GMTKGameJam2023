class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal killed

@export var speed := 500
@export var rate_of_fire := 0.25

@onready var muzzle = $Muzzle

var laser_scene = preload("res://mini_game/spaceship_shooter/scenes/laser.tscn")
var shoot_cooldown := false

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cooldown = false

func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	velocity = direction * speed
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)
	
func die():
	killed.emit()
	queue_free()
