extends Camera2D

func shake_down():
	var starting_position = position
	var ending_position = starting_position + Vector2(0, -30)
	
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", ending_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($".", "position", starting_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func shake_right():
	var starting_position = position
	var ending_position = starting_position + Vector2(30, 0)
	
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", ending_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($".", "position", starting_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func shake_left():
	var starting_position = position
	var ending_position = starting_position + Vector2(-30, 0)
	
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", ending_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($".", "position", starting_position, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func zoom_in():
	var starting_zoom = zoom
	var ending_zoom = starting_zoom + Vector2(0.01, 0.01)
	
	var tween = get_tree().create_tween()
	tween.tween_property($".", "zoom", ending_zoom, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property($".", "zoom", starting_zoom, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
