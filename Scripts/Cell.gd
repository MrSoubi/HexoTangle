class_name Cell extends Node2D

func update_label():
	$Label.text = str(global_position.x / GlobalData.H_SPACING.x) + " / " + str(global_position.y / (GlobalData.V_SPACING.y / 2))
