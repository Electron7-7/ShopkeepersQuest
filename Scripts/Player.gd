class_name Player extends CharacterBody2D

#### VARIABLES
@onready var groot = get_node('/root/GameRoot')
@onready var weapons = $Weapons

const ACCELERATION: float = 4990
const SPEED: float = 300

var health = 100


#### ENGINE FUNCTIONS
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	_walk(delta)


#### CUSTOM FUNCTIONS
func _walk(delta: float) -> void:
	var direction = Input.get_vector('left', 'right', 'up', 'down').normalized()
	var new_speed = SPEED - weapons.movement_penalty[weapons.type]
	velocity = velocity.move_toward(direction * new_speed * direction.length(), ACCELERATION * delta)
	move_and_slide()


func damage(damage) -> void:
	health -= damage
	print_debug(health)
