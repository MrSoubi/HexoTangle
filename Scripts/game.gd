@tool
extends Node2D

@export var timer: Timer
@export var soundManager: Node
@export var grid: Node
@export var ui: Node
@export var global_timer: Timer
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

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			handle_pause_game();
		if event.keycode == KEY_DOWN:
			soundManager.playSFX(GlobalData.SFX.SOFT_DROP)
			handle_soft_drop();
		if event.keycode == KEY_RIGHT:
			soundManager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_right();
		if event.keycode == KEY_LEFT:
			soundManager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_left();
		if event.keycode == KEY_UP:
			soundManager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_anti_clockwise();
		if event.keycode == KEY_Z:
			soundManager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_clockwise();
		if event.keycode == KEY_C:
			handle_hold();
		if event.keycode == KEY_SPACE:
			soundManager.playSFX(GlobalData.SFX.HARD_DROP)
			handle_hard_drop();

func _on_timer_timeout():
	handle_soft_drop();

func handle_soft_drop():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_soft_drop();
		timer.start();

func handle_move_right():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_move_right();

func handle_move_left():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_move_left();

func handle_rotate_anti_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_rotate_anti_clockwise();

func handle_rotate_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_rotate_clockwise();

func handle_hold():
	if (state == GlobalData.GameState.PLAYING):
		timer.start();

func handle_hard_drop():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_hard_drop();
		timer.start();

func handle_pause_game():
	if (state == GlobalData.GameState.PLAYING):
		state = GlobalData.GameState.PAUSED;
		
		timer.set_paused(true);
		global_timer.set_paused(true);
		
		ui.display_pause_menu();

func handle_resume_game():
	if (state == GlobalData.GameState.PAUSED):
		state = GlobalData.GameState.PLAYING;
		
		timer.set_paused(false);
		global_timer.set_paused(false);
		
		ui.display_game_ui();

func handle_game_over():
	if (state == GlobalData.GameState.PLAYING):
		state = GlobalData.GameState.MENU;
		
		timer.stop();
		global_timer.stop();
		
		ui.display_game_over_menu();

func handle_quit_game():
	state = GlobalData.GameState.MENU;
	
	timer.stop();
	global_timer.stop();
	
	ui.display_game_menu();

func handle_start_game(startingLevel : int = 1):
	state = GlobalData.GameState.PLAYING;
	
	score = 0;
	level = startingLevel;
	lines = 0;
	linesToDoUntilNextLevel = 5; #WARNING should be adressed when starting from a level > 1 !
	time = 0;
	
	grid.Reset()
	
	timer.wait_time = 1.0;
	timer.start();
	timer.set_paused(false);
	global_timer.start();
	global_timer.set_paused(false);
	
	#WARNING : Not clear, UI should handle everything on its own.
	ui.display_game_ui();
	ui.set_time(0);
	ui.update_values(score, lines, level);

func updateGame():
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
	
	if (lines >= linesToDoUntilNextLevel):
		level += 1
		linesToDoUntilNextLevel += 5 * level
	
	timer.wait_time = get_fall_speed()
	ui.update_values(score, lines, level);

func get_fall_speed() -> float:
	return (0.8 - ((level - 1) * 0.007)) ** (level - 1)

func _on_ui_start_game():
	handle_start_game();

func _on_ui_quit_game():
	handle_quit_game();

func _on_ui_resume_game():
	handle_resume_game();


func _on_global_timer_timeout():
	time += $GlobalTimer.wait_time;
	ui.set_time(time)


func _on_grid_figure_blocked(line_count, cell_count, is_hard_drop):
	pass # Replace with function body.











func try_hold() -> Hexomino:
	var localHex;
	
	if(canHold && heldHexomino == -1):
		heldHexomino = currentHexomino.type;
		canHold = false;
		soundManager.playSFX(GlobalData.SFX.HOLD)
		var type = getNextHexomino()
		localHex = hexomino.new(startingPosition, GlobalData.Direction.TOP, type, GlobalData.GetTextureFromType(type));
	else:
		if(heldHexomino != -1 && canHold):
			localHex = hexomino.new(startingPosition, GlobalData.Direction.TOP, heldHexomino, GlobalData.GetTextureFromType(heldHexomino));
			$"../UI/VBoxContainer/Control/HoldLabel".texture = null;
			heldHexomino = currentHexomino.type;
			canHold = false;
			soundManager.playSFX(GlobalData.SFX.HOLD)
		else:
			localHex = null;
	
	match (heldHexomino):
			0:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_I;
			1:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_O;
			2:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_T;
			3:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_L;
			4:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_J;
			5:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_Z;
			6:
				$"../UI/VBoxContainer/Control/HoldLabel".texture = GlobalData.texture_Form_S;
	
	return localHex;


func endTurn() -> int:
	block_hexomino();
	var lines = handleFullLines();
	@warning_ignore("integer_division")
	GenNewHexomino();
	return lines;



func update() -> Vector2i:
	var localScore = score
	score = 0
	var lines = 0;
	
	var localHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	localHex.move(GlobalData.add_directions(GlobalData.Direction.BOTTOM, 0));
	if isPositionValid(localHex):
		undrawHexomino();
		current_hexomino = localHex;
		drawHexomino();
	else:
		lines = endTurn();
	
	match (lines):
		1:
			localScore += 100
		2:
			localScore += 300
		3:
			localScore += 500
		4:
			localScore += 800
	
	return Vector2i(localScore, lines); #score and number of lines
