extends Node3D

const RAYCAST_LENGTH := 1000

@onready var camera := $Camera3D
@onready var overlay := $Camera3D/Overlay
var overlay_collider: CollisionObject3D

var mouse_line: MeshInstance3D
@export var mouse_line_height := 0.5

var buildings: Array[Building] = []
var selected_building_id := -1
var is_dragging = false

@export var default_value := 10
@export var default_tick := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	overlay_collider = overlay.get_collider()
	
	var building_nodes = get_tree().get_nodes_in_group("buildings")
	for i in range(building_nodes.size()):
		var building: Building = building_nodes[i]
		building.initialize(i, default_value, default_tick)
		buildings.append(building)
	
	Globals.building_team_changed.connect(_on_building_team_changed)
	
func _on_building_team_changed(_old_team, _new_team) -> void:
	var is_player_alive = buildings.any(func(building): return building.team == Globals.Teams.PLAYER)
	var is_enemy_alive = buildings.any(func(building): return building.team == Globals.Teams.ENEMY)
	
	if not is_player_alive:
		$LoseOverlay.show()
	elif not is_enemy_alive:
		$WinOverlay.show()
		
func _process(_delta) -> void:
	if is_dragging:
		handle_drag()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				handle_click()
			elif is_dragging:
				stop_drag()
				
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if selected_building_id > -1:
				close_overlay()
			else:
				pass

func handle_click() -> void:
	var target = _get_click_collider()
	if target:
		if target == overlay_collider:
			pass
		elif target.is_in_group("buildings"):
			if target is not Building:
				return
			if target.team == Globals.Teams.PLAYER:
				selected_building_id = target.id
					
			if selected_building_id == target.id:
				var pos = Vector3(target.position.x, mouse_line_height, target.position.z)
				start_drag(pos)
			#else:
				#selected_building_id = target.id
				#var building = buildings[selected_building_id]
				#open_overlay(building)
		else:
			close_overlay()
	else:
		close_overlay()

func handle_drag():
	var drag_target = _get_mouse_target()
	var color = Color.BURLYWOOD
	if not drag_target.is_empty():
		var mouse_pos: Vector3
		if drag_target.collider.is_in_group("buildings"):
			mouse_pos = drag_target.collider.position
			color = Color.LIME_GREEN
		else:
			mouse_pos = drag_target.position
		
		Draw3d.line(buildings[selected_building_id].position, Vector3(mouse_pos.x, mouse_line_height, mouse_pos.z), color, 1)

func _get_mouse_target():
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 0b01

	return space_state.intersect_ray(query)
	

func _get_click_collider():
	var click_target = _get_mouse_target()
	if not click_target.is_empty():
		return click_target.collider
	return null


func open_overlay(building) -> void:
	#TODO load building data to interior
	overlay.visible = true


func close_overlay() -> void:
	selected_building_id = -1
	overlay.visible = false

	
func start_drag(start_pos: Vector3) -> void:
	is_dragging = true
	

func stop_drag():
	is_dragging = false
	
	var target = _get_click_collider()
	if target and target.is_in_group("buildings") and target.id != selected_building_id:
		var origin = buildings[selected_building_id]
		Globals.spawn_army(origin, target.position)
		
	selected_building_id = -1
		
