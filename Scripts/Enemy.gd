class_name Enemy extends CharacterBody2D

#### VARIABLES
@export_enum('Basic:0', 'Fast:1') var type: int = 0

@onready var groot := get_node('/root/GameRoot')
@onready var player: Node2D = get_node('../Player')
@onready var raycast := $RayCast
@onready var navigator := $NavAgent
@onready var carrot_on_a_stick := $WanderPoint
@onready var can_turn := $TurnTimer
@onready var whisker := $Whisker
@onready var attack_timer := $AttackTimer

enum STATE {WANDERING, CHASING, STALKING}

var _state = STATE.WANDERING
var rngsus := RandomNumberGenerator.new()
var can_smell_player := false
var player_last_position: Vector2
var movement_acceleration := 200

var movement_speed: Array[float] = [80.0, 120.0]
var damage: Array[int] = [5, 3]
var attack_speed: Array[float] = [1.0, 0.5]


#### ENGINE FUNCTIONS
func _ready() -> void:
	rngsus.randomize()
	attack_timer.start(attack_speed[type])


func _physics_process(delta: float) -> void:
	if _can_see_player(): _state = STATE.CHASING
	if whisker.is_colliding() and whisker.get_collider().is_in_group('Player'):
			if is_zero_approx(attack_timer.time_left):
				player.damage(damage[type])
	_match_state()


#### CUSTOM FUNCTIONS
func _match_state() -> void:
	match _state:
		STATE.WANDERING:
			_wander()
		STATE.CHASING:
			if not _can_see_player(): _state = STATE.STALKING
			else:
				player_last_position = player.global_position
				_move_towards(player.global_position)
		STATE.STALKING:
			_stalk_player()


func _can_see_player() -> bool:
	raycast.position = position
	raycast.target_position = player.global_position - global_position
	if raycast.is_colliding():
		if raycast.get_collider().is_in_group('Player'):
			return can_smell_player
	return false


func _move_towards(target: Vector2) -> void:
	look_at(target)
	navigator.target_position = target
	var new_velocity = navigator.get_next_path_position() - global_position
	velocity = new_velocity.normalized() * movement_speed[type]
	move_and_slide()


func _wander() -> void:
	if is_zero_approx(can_turn.time_left):
		if rngsus.randi_range(1, 3) == 1:
			var random_rotation := deg_to_rad(rngsus.randi_range(15, 45))
			if rngsus.randi_range(0, 1) == 1: random_rotation = -random_rotation
			rotate(random_rotation)
	
	if whisker.is_colliding():
		if whisker.get_collider().is_in_group('World'):
			rotate(deg_to_rad(180))

	_move_towards(carrot_on_a_stick.global_position)


func _stalk_player() -> void:
	_move_towards(player_last_position)
	if navigator.is_navigation_finished(): _state = STATE.WANDERING


#### SIGNALS
func _on_nose_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		can_smell_player = true


func _on_nose_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		can_smell_player = false
