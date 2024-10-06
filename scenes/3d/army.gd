extends Area3D

@onready var collider = $CollisionShape3D
var speed := 0.0
var spawner: Area3D
var target: Vector3

const SPAWN_HEIGHT = 1

func initialize(init_speed: float, init_spawner: Building, init_target: Vector3) -> void:
	spawner = init_spawner
	position = Vector3(spawner.position.x, SPAWN_HEIGHT, spawner.position.z)
	speed = init_speed
	target = Vector3(init_target.x, SPAWN_HEIGHT, init_target.z)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var direction = (target - transform.origin).normalized();
	position += direction * speed * delta


func _on_area_entered(area: Area3D) -> void:
	if not area.is_in_group("buildings") or area == spawner:
		return
	queue_free()
