extends Control

func set_player_name(name: String):
	$HBoxContainer/Label_Name.text = name

func set_score(score: int):
	$HBoxContainer/Label_Score.text = str(score)
