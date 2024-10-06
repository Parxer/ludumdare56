extends Node3D

const RAYCAST_LENGTH := 100

@onready var camera := $Camera3D
@onready var overlay := $Camera3D/Overlay
var overlay_collider: CollisionObject3D

var buildings: Array[Building] = []
var opened_building := -1

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
	
	spawn_army(buildings[0], buildings[1].position)

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
		elif target.is_in_group("buildings"):
			opened_building = target.id
			var building = buildings[opened_building]
			open_overlay(building)
		else:
			close_overlay()
	else:
		close_overlay()

func open_overlay(building) -> void:
	#TODO load building data to interior
	overlay.visible = true

func close_overlay() -> void:
	overlay.visible = false
	
func spawn_army(spawner: Building, target: Vector3) -> void:
	var new_army = army_scene.instantiate()
	new_army.initialize(5.0, spawner, target)
	get_tree().current_scene.add_child(new_army)
