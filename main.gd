extends Node3D

const RAYCAST_LENGTH := 100

var overlay: Control
var opened_building := -1

var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overlay = get_node("Overlay")
	camera = get_node("Camera3D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_click()
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pass

func handle_click() -> void:
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 0b01

	var click_target = space_state.intersect_ray(query)
	if not click_target.is_empty() and click_target.collider.is_in_group("buildings"):
		open_overlay(click_target.collider.id)
	else:
		close_overlay()

func open_overlay(building_id: int) -> void:
	if opened_building > -1:
		close_overlay()
		
	overlay.open()
	opened_building = building_id

func close_overlay() -> void:
	overlay.close()
