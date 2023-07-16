extends StaticBody2D



func _on_area_2d_body_entered(body):
	body.health += 50
	body.play_heal()
	queue_free()
