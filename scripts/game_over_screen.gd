extends Control

func _on_restart_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/Score.text = "Score: " + str(value)

func  set_hi_score(value):
	$"Panel/Hi Score".text = "Hi Score: " + str(value)
