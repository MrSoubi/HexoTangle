@tool
extends Node2D

var score: int = 0;
var level: int = 1;

func _ready():
	if Engine.is_editor_hint():
		$ControlGUI.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		$Grid.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		print(ProjectSettings.get_setting("display/window/size/viewport_width"))
	if not Engine.is_editor_hint():
		$Timer.wait_time = 1.0;

func _on_timer_timeout():
	score += $Grid.update() * level;
	$ControlGUI/VBoxContainer/ScoreLabel.text = str(score);
	$ControlGUI/VBoxContainer/LevelLabel.text = str(level);
	level = floor(score/500) + 1;
	$Timer.wait_time = GetFallSpeed()

func GetFallSpeed() -> float:
	return (0.8 - ((level - 1) * 0.007)) ** (level - 1)
