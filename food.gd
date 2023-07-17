extends StaticBody2D



func _on_area_2d_body_entered(body):
	body.health += 100
	body.play_heal()
	queue_free()
