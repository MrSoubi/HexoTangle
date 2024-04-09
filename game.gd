@tool
extends Node2D

@export var timer: Timer
@export var soundManager: Node
@export var grid: Node
@export var ui: Node

var score: int = 0;
var level: int = 1;
var lines: int = 0;
var linesToDoUntilNextLevel = 5;

func _ready():
	if Engine.is_editor_hint():
		#$ControlGUI.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		grid.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		
	if not Engine.is_editor_hint():
		timer.wait_time = 1.0;
		$UI/VBoxContainer/LevelLabel.text = str(0);

func _on_timer_timeout():
	var scoreAndLines = grid.update();
	
	match(scoreAndLines.y):
		1:
			soundManager.playSFX(GlobalData.SFX.ONE_LINE);
		2:
			soundManager.playSFX(GlobalData.SFX.TWO_LINES);
		3:
			soundManager.playSFX(GlobalData.SFX.THREE_LINES);
		4:
			soundManager.playSFX(GlobalData.SFX.FOUR_LINES);
	
	score += scoreAndLines.x * level;
	lines += scoreAndLines.y;
	print(str(lines))
	if(lines >= linesToDoUntilNextLevel):
		level += 1
		linesToDoUntilNextLevel += 5 * level
		$UI/VBoxContainer/LevelLabel.text = str(level);
	$UI/VBoxContainer/ScoreLabel.text = str(score);
	timer.wait_time = GetFallSpeed()

func GetFallSpeed() -> float:
	return (0.8 - ((level - 1) * 0.007)) ** (level - 1)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			ResetGame();

func ResetGame():
	score = 0
	level = 1
	lines = 0
	linesToDoUntilNextLevel = 5
	timer.wait_time = 1.0;
	$UI/VBoxContainer/LevelLabel.text = str(0);
	grid.Reset()
