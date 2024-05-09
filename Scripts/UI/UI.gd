extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var settings_menu = $SettingsMenu
@onready var leader_board = $LeaderBoard
@onready var game_ui = $GameUI
@onready var help_ui = $HelpUI
@onready var pause_menu = $PauseMenu
@onready var game_over_menu = $GameOverMenu

signal startGame;
signal resumeGame;
signal quitGame;

func set_time(time: int):
	game_ui.set_time(time);

func _on_button_play_pressed():
	display_game_ui();
	startGame.emit();

func _on_button_settings_pressed():
	display_settings_menu();

func _on_button_help_pressed():
	display_help_ui();

func _on_button_resume_pressed():
	pause_menu.visible = false;
	resumeGame.emit();

func _on_button_quit_pressed():
	display_main_menu();
	quitGame.emit();

func display_main_menu():
	main_menu.visible = true
	settings_menu.visible = false
	leader_board.visible = false
	game_ui.visible = false
	help_ui.visible = false
	pause_menu.visible = false
	game_over_menu.visible = false

func display_game_ui():
	main_menu.visible = false
	settings_menu.visible = false
	leader_board.visible = false
	game_ui.visible = true
	help_ui.visible = false
	pause_menu.visible = false
	game_over_menu.visible = false

func display_settings_menu():
	main_menu.visible = false
	settings_menu.visible = true
	leader_board.visible = false
	game_ui.visible = false
	help_ui.visible = false
	pause_menu.visible = false

func display_help_ui():
	help_ui.visible = true

func display_leaderboard():
	main_menu.visible = false
	settings_menu.visible = false
	leader_board.visible = true
	game_ui.visible = false
	help_ui.visible = false
	pause_menu.visible = false
	game_over_menu.visible = false

func display_pause_menu():
	pause_menu.visible = true

func display_game_over_menu():
	game_over_menu.visible = true

func update_values(score, lines, level):
	game_ui.set_score(score)
	game_ui.set_lines(lines)
	game_ui.set_level(level)

func _on_button_back_pressed():
	help_ui.visible = false

func _on_button_new_game_pressed():
	display_game_ui()
	startGame.emit()

func set_hold_figure(f: GlobalData.HexType):
	game_ui.set_hold_figure(f)

func add_figure_to_queue(f: GlobalData.HexType):
	game_ui.push_next_figure(f)

func _on_h_slider_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value/100))

func _on_h_slider_vfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))
