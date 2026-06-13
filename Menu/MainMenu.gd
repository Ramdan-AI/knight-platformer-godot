extends Control



func _on_PlayButton_pressed():
	get_tree().change_scene("res://tilemap/Arena.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Menu/Credits.tscn")
