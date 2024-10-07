extends Control

func _on_play_pressed():
	hide()
	Globals.game_started.emit()
	AudioManager.play_attack()


func _on_quit_pressed():
	AudioManager.play_attack()
	get_tree().quit()


func _on_play_again_pressed():
	AudioManager.play_attack()
	Globals.game_started.emit()
	get_tree().reload_current_scene()
	
