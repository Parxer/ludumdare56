class_name Troop extends Area3D

var player_mat = preload("res://assets/fx/mat_troop_player.tres")
var enemy_mat = preload("res://assets/fx/mat_troop_enemy.tres")

@onready var collider = $CollisionShape3D
@onready var mesh = $MeshInstance3D

var speed := 0.0
var spawner: Area3D
var target: Vector3

var team: Globals.Teams
var strength := 1

const SPAWN_HEIGHT = 1

func initialize(init_speed: float, init_spawner: Building, init_target: Vector3) -> void:
	spawner = init_spawner
	team = spawner.team
	position = Vector3(spawner.position.x, SPAWN_HEIGHT, spawner.position.z)
	speed = init_speed
	target = Vector3(init_target.x, SPAWN_HEIGHT, init_target.z)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if team == Globals.Teams.PLAYER:
		#mesh.set_surface_override_material(0, player_mat)
	#else:
	mesh.material_override = enemy_mat

func _physics_process(delta: float) -> void:
	var direction = (target - transform.origin).normalized();
	position += direction * speed * delta


func _on_area_entered(area: Area3D) -> void:
	if not area.is_in_group("buildings") or area == spawner:
		return
	if area is Building:
		area.troop_entered(self)
		AudioManager.play_attack()
		
		queue_free()
