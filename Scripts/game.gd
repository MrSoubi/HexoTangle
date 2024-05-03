extends Node2D

@onready var animated_background = $AnimatedBackground
@onready var global_timer = $GlobalTimer
@onready var timer = $Timer
@onready var grid = $Grid
@onready var ui = $UI
@onready var sound_manager = $SoundManager
@onready var bag = $Bag
@onready var current_hexomino = $Hexomino
@onready var phantom = $Phantom

var hexomino = load("res://Scenes/hexomino.tscn");

var state: GlobalData.GameState = GlobalData.GameState.MENU;

var score: int = 0;
var level: int = 1;
var lines: int = 0;
var linesToDoUntilNextLevel = 5;
var time: float = 0;

var side_movement_flip_flop: bool = true;

func _ready():
	ui.display_main_menu();

func initialize_leaderBoard():
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
			sound_manager.playSFX(GlobalData.SFX.SOFT_DROP)
			handle_soft_drop();
		if event.keycode == KEY_RIGHT:
			sound_manager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_right();
		if event.keycode == KEY_LEFT:
			sound_manager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_left();
		if event.keycode == KEY_UP:
			sound_manager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_anti_clockwise();
		if event.keycode == KEY_Z:
			sound_manager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_clockwise();
		if event.keycode == KEY_C:
			handle_hold();
		if event.keycode == KEY_SPACE:
			sound_manager.playSFX(GlobalData.SFX.HARD_DROP)
			handle_hard_drop();

func _on_timer_timeout():
	handle_soft_drop();

func handle_soft_drop():
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate();
		test_hexomino.visible = false;
		add_child(test_hexomino);
		test_hexomino.set_type(current_hexomino.type);
		test_hexomino.position = current_hexomino.position;
		test_hexomino.rotation = current_hexomino.rotation;
		
		# Application of the movement to the test hexomino
		test_hexomino.move_to(test_hexomino.position + GlobalData.V_SPACING);
		
		# Check of the new position and application of the movement to the current hexomino
		# Or blocking of the current hexomino
		if (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			current_hexomino.move_to(test_hexomino.position);
		else:
			current_hexomino.block();
			current_hexomino.set_type(GlobalData.HexType.I);
		
		test_hexomino.queue_free();
		
		handle_phantom()
		
		timer.start();

func handle_move_right():
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate();
		test_hexomino.visible = false;
		add_child(test_hexomino);
		test_hexomino.set_type(current_hexomino.type);
		test_hexomino.position = current_hexomino.position + GlobalData.H_SPACING;
		test_hexomino.rotation = current_hexomino.rotation;
		
		if (side_movement_flip_flop):
			test_hexomino.position += GlobalData.V_SPACING / 2;
		else:
			test_hexomino.position -= GlobalData.V_SPACING / 2;
		
		if (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			current_hexomino.move_to(test_hexomino.position);
			side_movement_flip_flop = not side_movement_flip_flop;
		
		test_hexomino.queue_free();
		
		handle_phantom()

func handle_move_left():
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate();
		test_hexomino.visible = false;
		add_child(test_hexomino);
		test_hexomino.set_type(current_hexomino.type);
		test_hexomino.position = current_hexomino.position - GlobalData.H_SPACING;
		test_hexomino.rotation = current_hexomino.rotation;
		
		if (side_movement_flip_flop):
			test_hexomino.position += GlobalData.V_SPACING / 2;
		else:
			test_hexomino.position -= GlobalData.V_SPACING / 2;
		
		if (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			current_hexomino.move_to(test_hexomino.position);
			side_movement_flip_flop = not side_movement_flip_flop;
		
		test_hexomino.queue_free();
		
		handle_phantom()

func handle_rotate_anti_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate();
		test_hexomino.visible = false;
		add_child(test_hexomino);
		test_hexomino.set_type(current_hexomino.type);
		test_hexomino.position = current_hexomino.position;
		test_hexomino.rotation = current_hexomino.rotation;
		
		test_hexomino.rotate(deg_to_rad(60));
		
		if (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			current_hexomino.rotate_anti_clockwise();
		
		test_hexomino.queue_free();
		
		handle_phantom()

func handle_rotate_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate();
		test_hexomino.visible = false;
		add_child(test_hexomino);
		test_hexomino.set_type(current_hexomino.type);
		test_hexomino.position = current_hexomino.position;
		test_hexomino.rotation = current_hexomino.rotation;
		
		test_hexomino.rotate(deg_to_rad(-60));
		if (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			current_hexomino.rotate_clockwise();
		
		test_hexomino.queue_free();
		
		handle_phantom()

func handle_hold():
	if (state == GlobalData.GameState.PLAYING):
		timer.start();

func handle_hard_drop():
	if (state == GlobalData.GameState.PLAYING):
		grid.try_hard_drop();
		timer.start();

func handle_phantom():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = hexomino.instantiate()
		test_hexomino.visible = false
		add_child(test_hexomino)
		test_hexomino.set_type(current_hexomino.type)
		test_hexomino.position = current_hexomino.position
		test_hexomino.rotation = current_hexomino.rotation
		
		while (grid.is_position_available(test_hexomino.cell_1.global_position)
		and grid.is_position_available(test_hexomino.cell_2.global_position)
		and grid.is_position_available(test_hexomino.cell_3.global_position)
		and grid.is_position_available(test_hexomino.cell_4.global_position)):
			test_hexomino.move_to(test_hexomino.position + GlobalData.V_SPACING)
		
		test_hexomino.move_to(test_hexomino.position - GlobalData.V_SPACING)
		
		
		phantom.position = test_hexomino.position
		phantom.rotation = test_hexomino.rotation
		phantom.set_type(current_hexomino.type)
		phantom.set_phantom_color()
		
		test_hexomino.queue_free()

func handle_pause_game():
	if (state == GlobalData.GameState.PLAYING):
		state = GlobalData.GameState.PAUSED
		
		timer.set_paused(true)
		global_timer.set_paused(true)
		
		ui.display_pause_menu()

func handle_resume_game():
	if (state == GlobalData.GameState.PAUSED):
		state = GlobalData.GameState.PLAYING
		
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
	
	ui.display_main_menu();

func handle_start_game(startingLevel : int = 1):
	state = GlobalData.GameState.PLAYING;
	
	score = 0;
	level = startingLevel;
	lines = 0;
	linesToDoUntilNextLevel = 5; #WARNING should be adressed when starting from a level > 1 !
	time = 0;
	
	timer.wait_time = 1.0;
	timer.start();
	timer.set_paused(false);
	global_timer.start();
	global_timer.set_paused(false);
	
	#WARNING : Not clear, UI should handle everything on its own.
	ui.display_game_ui();
	ui.set_time(0);
	ui.update_values(score, lines, level);

func update_game():
	var scoreAndLines = grid.update();
	
	match(scoreAndLines.y):
		1:
			sound_manager.playSFX(GlobalData.SFX.ONE_LINE);
		2:
			sound_manager.playSFX(GlobalData.SFX.TWO_LINES);
		3:
			sound_manager.playSFX(GlobalData.SFX.THREE_LINES);
		4:
			sound_manager.playSFX(GlobalData.SFX.FOUR_LINES);
	
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


func _on_hexomino_hexomino_has_blocked():
	grid.handle_full_lines()
