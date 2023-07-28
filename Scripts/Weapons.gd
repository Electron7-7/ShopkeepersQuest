class_name Weapons extends Node2D

#### VARIABLES
@export_enum('Knife:0', 'Pistol:1') var type: int = 0

var damage: Array = [1, 5]
var distance: Array = [2, 10]
var movement_penalty: Array = [0, 0]
var attack_speed: Array = [5, 3]

var canAttack: bool = true
var equipped_weapons: int = 2

@onready var sprites: Array = $WeaponSprites.get_children()


#### ENGINE FUNCTIONS
func _ready() -> void:
	_switch_weapon(0)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed('action_1') and canAttack: _attack()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed('switch_weapon_down'):
		_switch_weapon(clamp(type - 1, 0, equipped_weapons - 1))

	if Input.is_action_pressed('switch_weapon_up'):
		_switch_weapon(clamp(type + 1, 0, equipped_weapons - 1))


#### CUSTOM FUNCTIONS
func _attack() -> void:
	pass

func _switch_weapon(selection: int):
	sprites[type].visible = false
	sprites[selection].visible = true
	type = selection
		
