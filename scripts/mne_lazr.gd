extends Sprite2D

func _process(delta):
	translate(Vector2(0, 1) * 1000 * delta)

func _on_area_2d_body_entered(body):
	if body.name == Player:
		texture = load("res://Assest/Exsplosion.png")
		set_process(false)
		body.take_damage()
		await get_tree().create_timer(0,2).timeout

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
