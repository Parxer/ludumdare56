extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var sound = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("click")
	sound.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_looped() -> void:
	queue_free()
