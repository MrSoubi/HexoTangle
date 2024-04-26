@tool
extends Node2D

@export var timer: Timer
@export var soundManager: Node
@export var grid: Node
@export var ui: Node

@export var leaderboard: Node

var state: GlobalData.GameState = GlobalData.GameState.MENU;

var score: int = 0;
var level: int = 1;
var lines: int = 0;
var linesToDoUntilNextLevel = 5;
var time: float = 0;

func _ready():
	if Engine.is_editor_hint():
		#$ControlGUI.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		grid.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
		
	if not Engine.is_editor_hint():
		initializeLeaderBoard();
		$UI/VBoxContainer/LevelLabel.text = str(0);
		
		ui.display_main_menu();

func initializeLeaderBoard():
	SilentWolf.configure({
		"api_key": "MIibx4NgJy1Jm3c2Iw6NxaXPQC8eIg535fguNf4W",
		"game_id": "HexoTangle",
		"log_level": 0
	})
	
	#leaderboard.render();

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
	
	if(lines >= linesToDoUntilNextLevel):
		level += 1
		linesToDoUntilNextLevel += 5 * level
	
	time += timer.wait_time;
	timer.wait_time = GetFallSpeed()
	
	ui.update_values(score, lines, level, time);

func GetFallSpeed() -> float:
	return (0.8 - ((level - 1) * 0.007)) ** (level - 1)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			pause();
			ui.display_pause_menu();

func ResetGame():
	score = 0
	level = 1
	lines = 0
	linesToDoUntilNextLevel = 5
	time = 0;
	timer.wait_time = 1.0;
	ui.update_values(score, lines, level, time);
	grid.Reset()

func _on_ui_start_game():
	ResetGame();
	timer.start();
	timer.set_paused(false);
	state = GlobalData.GameState.PLAYING;
	grid.canPlay = true;

func pause():
	timer.set_paused(true);
	grid.canPlay = false;
	state = GlobalData.GameState.PAUSED;

func _on_ui_quit_game():
	state = GlobalData.GameState.MENU;

func _on_ui_resume_game():
	state = GlobalData.GameState.PLAYING;
	timer.set_paused(false);
	grid.canPlay = true;
