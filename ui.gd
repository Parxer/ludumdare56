extends Control


func _ready():
	pass 

func _process(delta):
	pass


func _on_play_pressed():
	hide()
	AudioManager.play_attack()


func _on_quit_pressed():
	AudioManager.play_attack()
	get_tree().quit()


func _on_play_again_pressed():
	AudioManager.play_attack()
	get_tree().reload_current_scene()
	
