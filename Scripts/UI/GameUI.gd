extends Control

@onready var texture_rect_hold = $MarginContainer/VBoxContainer_Left/MarginContainer/TextureRect_Hold
@onready var score_value = $MarginContainer/VBoxContainer_Left/VBoxContainer_Score/Label_Value
@onready var time_value = $MarginContainer/VBoxContainer_Left/VBoxContainer_Time/Label_Value
@onready var lines_value = $MarginContainer/VBoxContainer_Left/VBoxContainer_Lines/Label_Value
@onready var level_value = $MarginContainer/VBoxContainer_Left/VBoxContainer_Level/Label_Value
@onready var texture_rect_next_1 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_1
@onready var texture_rect_next_2 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_2
@onready var texture_rect_next_3 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_3
@onready var texture_rect_next_4 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_4
@onready var texture_rect_next_5 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_5
@onready var texture_rect_next_6 = $MarginContainer/VBoxContainer_Right/TextureRect_Next_6

func set_time(s: int):
	time_value.text = str(s/60) + "\'" + str(s%60) + "\'\'";

func set_score(s: int):
	score_value.text = str(s);

func set_lines(l: int):
	lines_value.text = str(l);

func set_level(l: int):
	level_value.text = str(l);

func push_next_figure(f: GlobalData.HexType):
	pass;

func set_hold_figure(f: GlobalData.HexType):
	pass;
