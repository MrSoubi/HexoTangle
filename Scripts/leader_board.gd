extends Control

var VBox_highscores: VBoxContainer
var sw_result: Dictionary
var label_HS = []

func render():
	VBox_highscores = get_node("VBox_HighScores")
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	var i = 0;
	for score in SilentWolf.Scores.scores:
		label_HS.append(Label.new());
		label_HS[i].text = str(score.score)
		VBox_highscores.add_child(label_HS[i]);
		i += 1
