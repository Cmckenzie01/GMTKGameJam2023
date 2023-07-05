class_name Enemy extends CharacterBody2D

signal enemy_killed(enemy: Enemy)

@export var movement_speed: float = 150.0
@export var jump_speed: float = -550
@export var jump_delay: int = 2
@export var double_jump_speed: float = -640
@export var maximum_jumps: int = 2
@export var gravity: float = 1200
@export_range(0.0, 1.0) var friction: float = 1
@export_range(0.0, 1.0) var acceleration: float = 1
@export var movement_target: Node2D
@export var health = 1 
@export var gold = 1 

var jumps_made: int = 0
@onready var jump_delay_timer = jump_delay

# Pathfinding 
var current_path: PackedVector2Array
var scene_root
var testNavPoints
var testTarget

# Effects
var _effects = {}
@onready var effect_timer = $EffectTimer

# Random Special
@onready var specialSprite = preload("res://assets/sprites/slimes/GoldSlime.png")


func _ready():
	enemy_killed.connect(GlobalMechanics.enemy_killed)
	
	# Chris playing around with Sprites
	randomize()
	var random_number = randi_range(1, 20)
	if random_number == 20:
		$Sprite2D.texture = specialSprite
		gold = 10
		
	
	# Random Navpath
	scene_root = get_tree().get_root()
	testNavPoints = [
	scene_root.get_node("LevelOne/TestNavPoints/Marker1").global_position,
	scene_root.get_node("LevelOne/TestNavPoints/Marker2").global_position,
	scene_root.get_node("LevelOne/TestNavPoints/Marker3").global_position,
	scene_root.get_node("LevelOne/TestNavPoints/Marker4").global_position,
	scene_root.get_node("LevelOne/TestNavPoints/Marker5").global_position,
]
	testTarget = testNavPoints.pick_random()

# Combat
func hit(projectile: Bullet):
	apply_damage(projectile.damage)
		
func apply_damage(damage: int):
	self.health -= damage # TODO Resistances etc.
	
	if self.health <= 0:
		die()
		
func die():
	enemy_killed.emit(self)
	queue_free()



func _process(_delta):
	apply_periodic_effects()
	
# Status Effects
func apply_periodic_effects():
	if len(self._effects) > 0 and effect_timer.is_stopped():
		for effect_name in self._effects:
			var keys = self._effects[effect_name]
			
			for key in keys:
				var strength = self._effects[effect_name][key]
				
				match effect_name: # TODO Eventually enemies might be immune/resistant/etc.
					GlobalMechanics.Aura.BURN:
						var damage = 1 * strength
						apply_damage(damage)


func add_effect(effect: String, strength: float, key: String):
	# TODO Check immunities here, and do animations and stuff
	
	if effect not in self._effects:
		self._effects[effect] = {}
	
	self._effects[effect][key] = strength
	
func remove_effect(effect: String, key: String):
	# TODO Animations etc.
	
	self._effects[effect].erase(key)
	
	if len(self._effects[effect]) == 0:
		self._effects.erase(effect)


# Pathfinding
func seek_and_destroy():
	var current_agent_position: Vector2 = global_position
	var target_point: Vector2 = movement_target.global_position
	var nav_map: RID = get_world_2d().get_navigation_map()

	# testTarget = target_point
	if testTarget.x - current_agent_position.x < 36 and testTarget.x - current_agent_position.x > -36 and testTarget.y - current_agent_position.y < 36 and testTarget.y - current_agent_position.y > -36:
		testTarget = target_point
	
	# Calcualtes path between agent and target
	current_path = NavigationServer2D.map_get_path(nav_map, current_agent_position, testTarget, false)
	# Calculates if path is vertical
	var y_distance = 1
	if current_path.size() > 1:
		y_distance = current_path[1].y - current_path[0].y
	elif current_path.size() < 5:
		current_path = NavigationServer2D.map_get_path(nav_map, current_agent_position, target_point, false)
	
	# Update path to required next step
	if current_path.size():
		current_path.remove_at(0)
		
	# Slow Effect
	var movement_speed_multiplier = 1.0 
	
	if GlobalMechanics.Aura.keys()[GlobalMechanics.Aura.SLOW] in self._effects:
		var max_slow = self._effects[GlobalMechanics.Aura.keys()[GlobalMechanics.Aura.SLOW]].values().max()
		
		movement_speed_multiplier = (1 - max_slow)
		
		# print(movement_speed)
		# print(movement_speed * movement_speed_multiplier)
		
	# Calculates agent's next movement	
	var next_path_position: Vector2
	var new_velocity: Vector2
	var _original_velocity
	
	# If there is a next movement, then calculates required velocity to reach it
	if current_path.size():
		next_path_position = current_path[0]
		new_velocity = next_path_position - current_agent_position 
		new_velocity = new_velocity.normalized() * movement_speed * movement_speed_multiplier
		_original_velocity = new_velocity.normalized() * movement_speed
		
		#if new_velocity.x < 20:
		#	current_path.remove_at(0)
		
		# Updates x velocity from movement calculation
		velocity.x = new_velocity.x
	
	# Updates y velocity if jump is required
	if is_on_floor() and y_distance < -10: # and velocity.x < 10:
		jumps_made = 0 
		if jump_delay_timer < 0 and jumps_made != 1:
			jumps_made += 1
			velocity.y = jump_speed # * movement_speed_multiplier # TODO If slowing down jumps, it just can't reach
			jump_delay_timer = jump_delay
		else:
			jump_delay_timer -= 1
		
		
# Physics
func _physics_process(delta):
	velocity.y += gravity * delta
	
	# Pathfinding
	seek_and_destroy()
	
			
	if GlobalMechanics.Aura.keys()[GlobalMechanics.Aura.SLOW] in self._effects:
		# print(new_velocity)
		# print(original_velocity)
		# print('-----')
		pass
			
	move_and_slide()


