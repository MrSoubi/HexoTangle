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
var lines_to_do_until_next_level = 5;
var time: float = 0;

var side_movement_flip_flop: bool = true;

func _ready():
	ui.display_main_menu();
	bag.fill_queue()
	current_hexomino.set_type(bag.get_next_hex_type())

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
			handle_soft_drop(true);
		if event.keycode == KEY_RIGHT:
			sound_manager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_right();
		if event.keycode == KEY_LEFT:
			sound_manager.playSFX(GlobalData.SFX.MOVEMENT)
			handle_move_left();
		if event.keycode == KEY_UP:
			sound_manager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_clockwise();
		if event.keycode == KEY_Z:
			sound_manager.playSFX(GlobalData.SFX.ROTATION)
			handle_rotate_anti_clockwise();
		if event.keycode == KEY_C:
			handle_hold();
		if event.keycode == KEY_SPACE:
			sound_manager.playSFX(GlobalData.SFX.HARD_DROP)
			handle_hard_drop();

func _on_timer_timeout():
	handle_soft_drop();
	ui.update_values(score, lines, level)

func handle_soft_drop(add_score: bool = false):
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		# Application of the movement to the test hexomino
		test_hexomino.move_to(test_hexomino.position + GlobalData.V_SPACING);
		
		# Check of the new position and application of the movement to the current hexomino
		# Or blocking of the current hexomino
		if (grid.is_hexomino_in_valid_position(test_hexomino)):
			current_hexomino.move_to(test_hexomino.position);
			if (add_score):
				score += 1
				ui.update_values(score, lines, level)
		else:
			current_hexomino.block();
		
		test_hexomino.queue_free();
		
		handle_phantom()
		
		timer.start();

func handle_move_right():
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		move_right(test_hexomino)
		
		if (grid.is_hexomino_in_valid_position(test_hexomino)):
			current_hexomino.move_to(test_hexomino.position);
			side_movement_flip_flop = not side_movement_flip_flop;
		else:
			test_hexomino.position = current_hexomino.position + GlobalData.H_SPACING;
			if (side_movement_flip_flop):
				test_hexomino.position -= GlobalData.V_SPACING / 2;
			else:
				test_hexomino.position += GlobalData.V_SPACING / 2;
				if (grid.is_hexomino_in_valid_position(test_hexomino)):
					current_hexomino.move_to(test_hexomino.position);
					side_movement_flip_flop = not side_movement_flip_flop;
		
		test_hexomino.queue_free();
		
		handle_phantom()

func move_left(hex: Hexomino):
	hex.position = hex.position - GlobalData.H_SPACING;
		
	if (side_movement_flip_flop):
		hex.position += GlobalData.V_SPACING / 2;
	else:
		hex.position -= GlobalData.V_SPACING / 2;

func move_right(hex: Hexomino):
	hex.position = hex.position + GlobalData.H_SPACING;
		
	if (side_movement_flip_flop):
		hex.position += GlobalData.V_SPACING / 2;
	else:
		hex.position -= GlobalData.V_SPACING / 2;

func handle_move_left():
	if (state == GlobalData.GameState.PLAYING):
		# Copying of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		move_left(test_hexomino)
		
		if (grid.is_hexomino_in_valid_position(test_hexomino)):
			current_hexomino.move_to(test_hexomino.position);
			side_movement_flip_flop = not side_movement_flip_flop;
		else:
			test_hexomino.position = current_hexomino.position + GlobalData.H_SPACING;
			if (side_movement_flip_flop):
				test_hexomino.position -= GlobalData.V_SPACING / 2;
			else:
				test_hexomino.position += GlobalData.V_SPACING / 2;
				if (grid.is_hexomino_in_valid_position(test_hexomino)):
					current_hexomino.move_to(test_hexomino.position);
					side_movement_flip_flop = not side_movement_flip_flop;
		
		test_hexomino.queue_free();
		
		handle_phantom()

func handle_rotate_anti_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		test_hexomino.rotate(deg_to_rad(60))
		
		if (!grid.is_hexomino_in_valid_position(test_hexomino)):
			move_left(test_hexomino)
			if(!grid.is_hexomino_in_valid_position(test_hexomino)):
				move_right(test_hexomino)
				move_right(test_hexomino)
				if(!grid.is_hexomino_in_valid_position(test_hexomino)):
					test_hexomino = get_test_hexomino()
		
		current_hexomino.position = test_hexomino.position
		current_hexomino.rotation = test_hexomino.rotation
		
		test_hexomino.queue_free()
		
		handle_phantom()

func handle_rotate_clockwise():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		test_hexomino.rotate(deg_to_rad(-60))
		
		if (!grid.is_hexomino_in_valid_position(test_hexomino)):
			move_left(test_hexomino)
			if(!grid.is_hexomino_in_valid_position(test_hexomino)):
				move_right(test_hexomino)
				move_right(test_hexomino)
				if(!grid.is_hexomino_in_valid_position(test_hexomino)):
					test_hexomino = get_test_hexomino()
		
		current_hexomino.position = test_hexomino.position
		current_hexomino.rotation = test_hexomino.rotation
		
		test_hexomino.queue_free()
		
		handle_phantom()

var can_hold = true
var has_never_held = true
var held_type

func handle_hold():
	if (state == GlobalData.GameState.PLAYING):
		if (can_hold):
			var tmp: GlobalData.HexType = current_hexomino.get_type()
			
			if (has_never_held):
				held_type = bag.get_random_hex_type()
				has_never_held = false
			
			current_hexomino.set_type(held_type)
			
			held_type = tmp
			
			current_hexomino.position = Vector2(0,0)
			current_hexomino.rotation = 0
			
			ui.set_hold_figure(held_type)
			
			can_hold = false

func handle_hard_drop():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		var steps = 0
		
		while (grid.is_hexomino_in_valid_position(test_hexomino)):
			test_hexomino.move_to(test_hexomino.position + GlobalData.V_SPACING)
			steps += 1
		
		test_hexomino.move_to(test_hexomino.position - GlobalData.V_SPACING)
		
		score += (steps - 1) * 2
		
		current_hexomino.move_to(test_hexomino.position)
		current_hexomino.block()
		
		test_hexomino.queue_free()
		
		$Camera2D.shake_down()
		
		timer.start();


func handle_phantom():
	if (state == GlobalData.GameState.PLAYING):
		# Copy of the current hexomino state into a test hexomino, not visible for the player
		var test_hexomino = get_test_hexomino()
		
		while (grid.is_hexomino_in_valid_position(test_hexomino)):
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
	lines_to_do_until_next_level = 5; #WARNING should be adressed when starting from a level > 1 !
	time = 0;
	
	grid.reset()
	
	timer.wait_time = 1.0;
	timer.start();
	timer.set_paused(false);
	global_timer.start();
	global_timer.set_paused(false);
	
	#WARNING : Not clear, UI should handle everything on its own.
	ui.display_game_ui();
	ui.set_time(0);
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

func _on_hexomino_hexomino_has_blocked():
	grid.handle_full_lines()
	current_hexomino.set_type(bag.get_random_hex_type());
	can_hold = true
	handle_phantom()

func _on_grid_lines_completed(count):
	
	match (count):
		1:
			score += 100 * level
			lines += 1
		2:
			score += 300 * level
			lines += 3
		3:
			score += 500 * level
			lines += 5
		4:
			score += 800 * level
			lines += 8
	
	if (lines >= lines_to_do_until_next_level):
		level += 1
		lines_to_do_until_next_level += 5 * level
		timer.set_wait_time(get_fall_speed())
		
	ui.update_values(score, lines, level)

func get_test_hexomino() -> Hexomino:
	# Copy of the current hexomino state into a test hexomino, not visible for the player
	var test_hexomino = hexomino.instantiate()
	test_hexomino.visible = false
	add_child(test_hexomino)
	test_hexomino.set_type(current_hexomino.type)
	test_hexomino.position = current_hexomino.position
	test_hexomino.rotation = current_hexomino.rotation
	
	return test_hexomino
