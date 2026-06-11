extends Area2D



func _on_coin_body_entered(body):
	if body.name == "Player":
		body.get_coin()
	queue_free()
