extends Node3D

const RAYCAST_LENGTH := 100

@onready var camera := $Camera3D
@onready var overlay := $Camera3D/Overlay
var overlay_collider: CollisionObject3D
@onready var arrow := $Arrow

var buildings: Array[Building] = []
var opened_building := -1
var is_dragging = false

@export var default_value := 10
@export var default_tick := 1.0

var army_scene: PackedScene = preload("res://scenes/3d/army.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overlay_collider = overlay.get_collider()
	
	var building_nodes = get_tree().get_nodes_in_group("buildings")
	var i = 0
	for node in building_nodes:
		if node is not Building:
			pass
		var building: Building = node
		building.initialize(i, default_value, default_tick)
		buildings.append(building)
		i += 1


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				handle_click()
			elif is_dragging:
				stop_drag()
				
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if opened_building > -1:
				close_overlay()
			else:
				pass

func handle_click() -> void:
	var target = _get_click_collider()
	if target:
		print_debug(target)
		if target.is_in_group("buildings"):
			if opened_building == target.id:
				start_drag(target.position)
			else:
				opened_building = target.id
				var building = buildings[opened_building]
				open_overlay(building)
		else:
			close_overlay()
	else:
		close_overlay()

func _get_click_collider():
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 0b01

	var click_target = space_state.intersect_ray(query)
	if not click_target.is_empty() and click_target.collider != overlay_collider:
		return click_target.collider
	return null

func open_overlay(building) -> void:
	#TODO load building data to interior
	overlay.visible = true

func close_overlay() -> void:
	opened_building = -1
	overlay.visible = false
	
func start_drag(start_pos: Vector3) -> void:
	is_dragging = true
	arrow.position = Vector3(start_pos.x, 0.2, start_pos.z)
	arrow.visible = true

func stop_drag():
	is_dragging = false
	arrow.visible = false
	
	var target = _get_click_collider()
	if target and target.is_in_group("buildings") and target.id != opened_building:
		var origin = buildings[opened_building]
		spawn_army(origin, target.position)


func spawn_army(spawner: Building, target: Vector3) -> void:
	var new_army = army_scene.instantiate()
	new_army.initialize(5.0, spawner, target)
	get_tree().current_scene.add_child(new_army)
