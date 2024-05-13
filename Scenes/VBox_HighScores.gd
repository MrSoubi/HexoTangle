extends VBoxContainer
var entry = load("res://Scenes/leaderboard_entry.tscn")

func add_entry(name: String, score: int):
	var local_entry = entry.instantiate()
	local_entry.set_player_name(name)
	local_entry.set_score(score)
	add_child(local_entry)

func _on_button_pressed():
	add_entry($"../VBoxContainer/TextEdit_Name".text, 1000)
