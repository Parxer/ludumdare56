class_name Building extends Area3D

@onready var timer = $Timer
@onready var value_label = $Value
@onready var player_body = $PlayerBody
@onready var enemy_body = $EnemyBody
@onready var neutral_body = $NeutralBody

@onready var collider = $CollisionShape3D

@export var team = Globals.Teams.PLAYER

const DELTA_SCALE: float = 0.1

const MIN_SCALE: float = 0.5
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

	_process_tick(value)

func _ready() -> void:
	#call once to set correct body
	set_team()
	
	Globals.game_ended.connect(_on_game_ended)
	Globals.game_started.connect(_on_game_started)

func _on_game_started():
	value_label.visible = true
	_start_timer()

func _on_game_ended():	
	value_label.visible = false
	timer.stop()

func update_scale() -> void:
	var scale_diff = 1 + ((float(value) / initial_state.value) - 1) * DELTA_SCALE
	var new_scale = Vector3.ONE * clampf(scale_diff, MIN_SCALE, MAX_SCALE)
	if scale_diff <= 1:
		scale = Vector3.ONE
		player_body.scale = new_scale
		enemy_body.scale = new_scale
	else:
		player_body.scale = Vector3.ONE
		enemy_body.scale = Vector3.ONE
		neutral_body.scale = Vector3.ONE
		scale = new_scale

func _on_timer_timeout() -> void:
	value += 1
	_process_tick()

func _process_tick(new_value: int = value) -> void:
	value_label.text = String.num_int64(new_value)
	update_scale()

func halve():
	value /= 2
	_process_tick()
	_start_timer()

func troop_entered(troop: Troop):
	if troop.team == team:
		value += troop.strength
	else:
		var new_value = value - troop.strength
		if new_value <= 0:
			new_value = abs(new_value) + 1
			set_team(troop.team)
			if troop.team == Globals.Teams.PLAYER:
				AudioManager.play_shroom1()
			elif troop.team == Globals.Teams.ENEMY:
				AudioManager.play_shroom2()
			$Clouds.emitting = true
		else:
			value = new_value
	_process_tick()
	_start_timer()

func _start_timer():
	if not team == Globals.Teams.NEUTRAL:
		timer.start(tick)

func set_team(new_team: Globals.Teams = team) -> void:
	var old_team = team
	team = new_team
	player_body.visible = team == Globals.Teams.PLAYER
	enemy_body.visible = team == Globals.Teams.ENEMY
	neutral_body.visible = team == Globals.Teams.NEUTRAL
	
	if old_team != new_team:
		Globals.building_team_changed.emit(old_team, new_team)
	
