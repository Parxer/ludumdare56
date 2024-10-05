extends StaticBody3D

@export var id: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func initalize(assigned_id: int) -> void:
	if not assigned_id:
		print_debug("missing building ID")
	else:
		id = assigned_id

func get_id() -> int:
	return id
