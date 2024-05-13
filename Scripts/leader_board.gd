extends Control

@onready var v_box_high_scores = $VBoxContainer/VBox_HighScores

func render():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	for score in SilentWolf.Scores.scores:
		v_box_high_scores.add_entry("player", score.score)
