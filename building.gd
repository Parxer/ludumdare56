class_name Building extends Area3D

@onready var timer = $Timer
@onready var value_label = $Value

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
	timer.start(tick)

func update_scale() -> void:
	var scale_diff = (float(value) / initial_state.value)
	scale = Vector3.ONE * scale_diff

func _on_timer_timeout() -> void:
	value += 1
	value_label.text = String.num_int64(value)
	update_scale()
