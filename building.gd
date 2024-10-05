extends StaticBody3D

@onready var timer = $Timer
@onready var value_label = $Value

@export var state = {
	"id": 0,
	"value": 100,
	"tick": 0.5
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func initalize(assigned_id: int) -> void:
	if not assigned_id:
		print_debug("missing building ID")
	else:
		state.id = assigned_id

func _ready() -> void:
	timer.start(state.tick)

func get_id() -> int:
	return state.id


func _on_timer_timeout() -> void:
	state.value += 1
	value_label.text = String.num_int64(state.value)
