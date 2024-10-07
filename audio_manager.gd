extends Node

@onready var ambience = $Ambience
@onready var attack = $Attack
@onready var poof = $Poof
@onready var shroom1 = $Shroom1
@onready var shroom2 = $Shroom2

func play_attack():
	if not attack.playing:
		attack.play()

func play_poof():
		poof.play()

func play_shroom1():
		shroom1.play()

func play_shroom2():
		shroom2.play()
