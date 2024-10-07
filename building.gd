class_name Building extends Area3D

@onready var timer = $Timer
@onready var value_label = $Value
@onready var player_body = $PlayerBody
@onready var enemy_body = $EnemyBody
@onready var collider = $CollisionShape3D

@export var team = Globals.Teams.PLAYER


const DELTA_VALUE: int = 1
const DELTA_SCALE: float = DELTA_VALUE / 2.0

const MIN_SCALE: float = 0.25
const MAX_SCALE: float = 2.5

var initial_state = {
	"id": 0,
	"value": 0,
	"tick": 0.0
}

var id: int
var value: int
var tick: float

func initialize(init_id: int, init_value: int, init_tick: float) -> void:
	initial_state.id = init_id
	initial_state.value = init_value
	initial_state.tick = init_tick
	
	id = init_id
	value = init_value
	tick = init_tick

func _ready() -> void:
	set_team()
	timer.start(tick)

func update_scale() -> void:
	var scale_diff = (float(value) / initial_state.value)
	var new_scale = Vector3.ONE * scale_diff
	player_body.scale = new_scale
	enemy_body.scale = new_scale
	scale = Vector3(new_scale.x, 1, new_scale.z)

func _on_timer_timeout() -> void:
	value += 1
	_process_tick()

func _process_tick() -> void:
	value_label.text = String.num_int64(value)
	update_scale()

func halve():
	value /= 2
	_process_tick()
	timer.start()

func troop_entered(troop: Troop):
	if troop.team == team:
		value += troop.strength
	else:
		var new_value = value - troop.strength
		if new_value <= 0:
			new_value = abs(new_value) + 1
			set_team(troop.team)
		else:
			value = new_value
	_process_tick()
	timer.start()

func set_team(new_team: Globals.Teams = team) -> void:
	team = new_team
	player_body.visible = team == Globals.Teams.PLAYER
	enemy_body.visible = team == Globals.Teams.ENEMY
