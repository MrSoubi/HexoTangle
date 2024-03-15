@tool
extends Node2D

var score: int = 0;
var level: int = 1;
var lines: int = 0;
var linesToDoUntilNextLevel = 5;

func _ready():
	if Engine.is_editor_hint():
		#$ControlGUI.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		$Grid.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		print(ProjectSettings.get_setting("display/window/size/viewport_width"))
	if not Engine.is_editor_hint():
		$Timer.wait_time = 1.0;
		$CanvasLayer/VBoxContainer/LevelLabel.text = str(0);

func _on_timer_timeout():
	var scoreAndLines = $Grid.update();
	score += scoreAndLines.x * level;
	lines += scoreAndLines.y;
	print(str(lines))
	if(lines >= linesToDoUntilNextLevel):
		level += 1
		linesToDoUntilNextLevel += 5 * level
		$CanvasLayer/VBoxContainer/LevelLabel.text = str(level);
	$CanvasLayer/VBoxContainer/ScoreLabel.text = str(score);
	$Timer.wait_time = GetFallSpeed()

func GetFallSpeed() -> float:
	return (0.8 - ((level - 1) * 0.007)) ** (level - 1)

