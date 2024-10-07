extends Node

@onready var ambience = $Ambience
@onready var poof = $Poof

func play_attack():
	if not poof.playing:
		poof.play()
