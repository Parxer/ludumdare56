class_name Building extends Area3D

@onready var timer = $Timer
@onready var value_label = $Value

@export var mesh_scene = preload("res://scenes/3d/mushroom.tscn")

@export var team = Globals.Teams.PLAYER

const DELTA_VALUE: int = 1
const DELTA_SCALE: float = DELTA_VALUE / 2.0

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
	get_node("deleteme").queue_free()
	timer.start(tick)
	var mesh_instance = 	mesh_scene.instantiate()
	add_child(mesh_instance)
	

func update_scale() -> void:
	var scale_diff = (float(value) / initial_state.value)
	scale = Vector3.ONE * scale_diff

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
			value = abs(new_value) + 1
			team = troop.team
	_process_tick()
	timer.start()
