extends Node

@onready var ambience = $Ambience
@onready var attack = $Attack
@onready var poof = $Poof
@onready var shroom1 = $Shroom1
@onready var shroom2 = $Shroom2
@onready var bg_music = $BGmusic
@onready var win = $Win
@onready var game_over = $GameOver

func play_music():
	bg_music.play()
	ambience.play()

func stop_music():
	bg_music.stop()

func play_attack():
	attack.pitch_scale = randf_range(0.85, 1.15)
	attack.play()

func play_poof():
	poof.play()

func play_shroom1():
	shroom1.play()

func play_shroom2():
	shroom2.play()

func play_win():
	win.play()

func play_game_over():
	game_over.play()
