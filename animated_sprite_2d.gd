extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	autoplay = "idle"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		visible = !visible
		
