extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Arena.tscn")

func _on_reset_button_pressed() -> void:
	# Mengulang scene saat ini dari awal (reset)
	get_tree().reload_current_scene()


func _on_StartButton_pressed():
	pass # Replace with function body.


func _on_ResetButton_pressed():
	pass # Replace with function body.
