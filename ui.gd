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
	
func _on_next_level_pressed():
	AudioManager.play_attack()
	get_tree().change_scene_to_file("res://levels/world2.tscn")


func _on_play_2_pressed():
	AudioManager.play_attack()
	get_tree().change_scene_to_file("res://levels/world2.tscn")


func _on_start_pressed():
	AudioManager.play_attack()
	hide()
	Globals.game_started.emit()
