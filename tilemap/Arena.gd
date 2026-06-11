extends Node2D

onready var win_menu = $CanvasLayer/Finish

func _on_flor_body_entered(body):
	if body.name == 'Player':
		body.mati()
		#get_tree().change_scene("res://tilemap/Arena.tscn")


func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_FinishArea_body_entered(body):
	if body.name == 'Player':
		print("YOU WIN")
		body.game_finished =true
		win_menu.visible = true
