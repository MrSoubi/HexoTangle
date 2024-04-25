extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var settings_menu = $SettingsMenu
@onready var leader_board = $LeaderBoard
@onready var game_ui = $GameUI
@onready var help_ui = $HelpUI
@onready var pause_menu = $PauseMenu

signal startGame;

func _on_button_play_pressed():
	display_game_ui();
	startGame.emit();

func _on_button_settings_pressed():
	display_settings_menu();

func _on_button_help_pressed():
	display_help_ui();

func display_main_menu():
	main_menu.visible = true;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = false;

func display_game_ui():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = true;
	help_ui.visible = false;
	pause_menu.visible = false;

func display_settings_menu():
	main_menu.visible = false;
	settings_menu.visible = true;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = false;

func display_help_ui():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = true;
	pause_menu.visible = false;

func display_leaderboard():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = true;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = false;

func display_pause_menu():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = true;

func update_values(score, lines, level, time):
	game_ui.set_score(score);
	game_ui.set_time(time);
	game_ui.set_lines(lines);
	game_ui.set_level(level);
