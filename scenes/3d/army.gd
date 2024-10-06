extends Area3D

@onready var collider = $CollisionShape3D
var speed := 0.0
var spawner: Area3D
var target: Vector3

func initialize(init_speed: float, init_spawner: Building, init_target: Vector3) -> void:
	spawner = init_spawner
	position = spawner.position
	speed = init_speed
	target = init_target
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += target.normalized() * speed * delta


func _on_area_entered(area: Area3D) -> void:
	if not area.is_in_group("buildings") or area == spawner:
		return
	print_debug("Other building hit!")
