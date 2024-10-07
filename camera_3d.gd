extends Camera3D
	
const SPEED = 10.0
const ZOOM_SPEED = 60.0
const X_MIN = -15.0
const X_MAX = -5.0
const Y_MIN = 5.0
const Y_MAX = 25.0
const Z_MIN = -10.0
const Z_MAX = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	position.x += direction.x * SPEED * delta
	position.z += direction.z * SPEED * delta
	
	# Clamp the position to limit the camera's area.
	position.x = clamp(position.x, X_MIN, X_MAX)
	position.y = clamp(position.y, Y_MIN, Y_MAX)
	position.z = clamp(position.z, Z_MIN, Z_MAX)
	
	# Handle zoom in and out.
	if Input.is_action_just_released("zoom_in"):
		if projection == PROJECTION_PERSPECTIVE:
			position.y -= ZOOM_SPEED * delta
	if projection == PROJECTION_ORTHOGONAL:
		size -= ZOOM_SPEED * delta
	if Input.is_action_just_released("zoom_out"):
		if projection == PROJECTION_PERSPECTIVE:
			position.y += ZOOM_SPEED * delta
	if projection == PROJECTION_ORTHOGONAL:
		size += ZOOM_SPEED * delta
		
		# Clamp the Y position after zooming.
		position.y = clamp(position.y, Y_MIN, Y_MAX)
