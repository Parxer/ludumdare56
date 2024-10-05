extends Node3D

const RAYCAST_LENGTH := 100

@onready var camera := $Camera3D
@onready var overlay := $Camera3D/Overlay

var overlay_collider: CollisionObject3D
var opened_building := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overlay_collider = overlay.get_collider()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_click()
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if opened_building > -1:
				close_overlay()
			else:
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
	if not click_target.is_empty():
		var target = click_target.collider
		print_debug(target)
		if target == overlay_collider:
			pass
		else:
			if target.is_in_group("buildings"):
				open_overlay(target.state.id)
			else:
				close_overlay()
	else:
		close_overlay()

func open_overlay(building_id: int) -> void:
	if opened_building > -1:
		close_overlay()
	
	opened_building = building_id
	overlay.visible = true

func close_overlay() -> void:
	overlay.visible = false
	opened_building = -1
