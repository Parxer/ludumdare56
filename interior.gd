class_name Interior extends Node2D

@onready var ground := $GroundTileMap
@onready var creatures := $CreaturesTileMap
@onready var rng = RandomNumberGenerator.new()

@onready var click_scene: PackedScene = preload("res://scenes/2d/click.tscn")

var value := 0

const SIZE := 7

var creatures_array: Array[Vector2i]

func initialize(start_value: int = 10) -> void:
	value = start_value
	creatures_array = []
	
	for x in range(SIZE):
		for y in range(SIZE):
			ground.set_cell([x, y], 3, [2, 1])
	
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var creatures_count = creatures_array.size()
	#if creatures_count < value / 50:
		#_spawn_creature()
	#elif creatures_count > value + 49 / 50:
		#_despawn_creature()	
	#
#
#func _spawn_creature() -> void:
	#var coord = _get_random_free_coord_recursive(creatures_array, SIZE, SIZE)
	#
	#
#func _despawn_creature() -> void:
	#var coords = creatures_array.pop_back()
	#
	
#func _get_random_free_coord_recursive(used_coords: Array[Vector2i], max_x: int, max_y: int, level = 0) -> Vector2i:
	#if level >= 100 or used_coords.size() >= max_x * max_y:
		#return Vector2i(-1, -1)
	#
	#var coord = Vector2i(rng.randi_range(0, max_x), rng.randi_range(0, max_y))
	#if used_coords.has(coord):
		#return _get_random_free_coord_recursive(used_coords, max_x, max_y, level + 1)
	#else:
		#return coord
	#
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
		var click = click_scene.instantiate()
		click.global_transform.origin = event.position
		add_child(click)
	
	
func render() -> void:
	pass
