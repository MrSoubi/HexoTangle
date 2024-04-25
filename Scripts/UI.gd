extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var settings_menu = $SettingsMenu
@onready var leader_board = $LeaderBoard
@onready var game_ui = $GameUI
@onready var help_ui = $HelpUI
@onready var pause_menu = $PauseMenu

func _on_button_play_pressed():
	_display_game_ui();


func _on_button_settings_pressed():
	_display_settings_menu();


func _on_button_help_pressed():
	_display_help_ui();

func _display_game_ui():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = true;
	help_ui.visible = false;
	pause_menu.visible = false;

func _display_settings_menu():
	main_menu.visible = false;
	settings_menu.visible = true;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = false;

func _display_help_ui():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = true;
	pause_menu.visible = false;

func _display_leaderboard():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = true;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = false;

func _display_pause_menu():
	main_menu.visible = false;
	settings_menu.visible = false;
	leader_board.visible = false;
	game_ui.visible = false;
	help_ui.visible = false;
	pause_menu.visible = true;
