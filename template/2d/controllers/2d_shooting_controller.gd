extends CharacterBody2D

@export var speed = 200
@export var bullet_scene : PackedScene

func get_input():
	look_at(get_global_mouse_position())
	
	var dir = Input.get_axis("ui_down", "ui_up")
	velocity = transform.x * dir * speed
	if Input.is_action_just_pressed("attack"):
		shoot()
	
	
func _physics_process(delta):
	get_input()
	
	move_and_slide()
	
func shoot():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Muzzle.global_transform
