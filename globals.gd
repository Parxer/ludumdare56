extends Node

enum Teams { PLAYER, ENEMY, NEUTRAL }

signal building_team_changed

var troop_scene: PackedScene = preload("res://scenes/3d/troop.tscn")

func spawn_army(spawner: Building, target: Vector3) -> void:
	var army_size: int = spawner.value / 2
	spawner.halve()
		
	var spawn_delay = 0.1

	for i in range(army_size):
		var timer = Timer.new()
		timer.wait_time = spawn_delay * i + 0.1 * randf_range(0.1,2)
		timer.one_shot = true
		
		var random_offset = Vector3(
			randf_range(-0.5, 0.5),
			randf_range(-0.2,0.2),
			randf_range(-0.5, 0.5)
		)
		var varied_target = target + random_offset

		timer.timeout.connect(spawn_troop.bind(spawner, varied_target))
		
		add_child(timer)
		timer.start()

func spawn_troop(spawner: Building, target: Vector3) -> void:
	var new_troop = troop_scene.instantiate()
	new_troop.initialize(5.0, spawner, target)
	get_tree().current_scene.add_child(new_troop)
