extends Control

@onready var label_title = $MarginContainer/VBoxContainer/Label_Title
@onready var h_box_container_how_to_play = $MarginContainer/VBoxContainer/HBoxContainer_HowToPlay
@onready var h_box_container_controls = $MarginContainer/VBoxContainer/VBoxContainer_Controls
@onready var h_box_container_general_info = $MarginContainer/VBoxContainer/HBoxContainer_GeneralInfo

var currentPanel: int = 1;

func _on_button_left_pressed():
	if currentPanel > 1:
		currentPanel -= 1;
	
	match currentPanel:
		1:
			h_box_container_how_to_play.visible = true;
			h_box_container_controls.visible = false;
			label_title.text = "HOW TO PLAY";
		2:
			h_box_container_controls.visible = true;
			h_box_container_general_info.visible = false;
			label_title.text = "CONTROLS";


func _on_button_right_pressed():
	if currentPanel < 3:
		currentPanel += 1;
	
	match currentPanel:
		2:
			h_box_container_how_to_play.visible = false;
			h_box_container_controls.visible = true;
			label_title.text = "CONTROLS";
		3:
			h_box_container_controls.visible = false;
			h_box_container_general_info.visible = true;
			label_title.text = "GENERAL INFO";
