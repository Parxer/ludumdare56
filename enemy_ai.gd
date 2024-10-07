extends Node

var my_buildings: Array[Building]
var timer: Timer

const MY_TEAM = Globals.Teams.ENEMY
@export var spawn_delay := 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_my_buildings()
	Globals.building_team_changed.connect(_on_building_team_changed)
	Globals.game_started.connect(_on_game_started)
	Globals.game_ended.connect(_on_game_ended)
	
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_game_started():
	timer.start(spawn_delay / 2)
	timer.wait_time = spawn_delay
	
func _on_game_ended():
	timer.stop()

func _on_building_team_changed(old_team, new_team) -> void:
	if old_team == MY_TEAM or new_team == MY_TEAM:
		_update_my_buildings()

func _on_timer_timeout():
	var origin: Building = my_buildings.pick_random()
	var targets = get_tree().get_nodes_in_group("buildings").filter(func(building): return building.team != MY_TEAM)
	
	if not targets.is_empty():
		var closest_target: Building
		var smallest_distance = 999999.9
		for target in targets:
			var distance = _get_distance(origin, target)
			if distance <= smallest_distance:
				closest_target = target
				smallest_distance = distance
		
		attack(origin, closest_target)

func attack(origin: Building, target: Building):
	Globals.spawn_army(origin, target.position)

func _get_distance(from: Building, to: Building) -> float:
	return from.position.distance_squared_to(to.position)

func _update_my_buildings() -> void:
	var filtered = get_tree().get_nodes_in_group("buildings").filter(func(b): return b.team == MY_TEAM)
	my_buildings.assign(filtered)
