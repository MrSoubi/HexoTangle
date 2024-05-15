class_name Cell extends Node2D


func set_color(type: GlobalData.HexType):
	match (type):
		GlobalData.HexType.I:
			$Sprite2D.texture = GlobalData.texture_I
		GlobalData.HexType.O:
			$Sprite2D.texture = GlobalData.texture_O
		GlobalData.HexType.T:
			$Sprite2D.texture = GlobalData.texture_T
		GlobalData.HexType.L:
			$Sprite2D.texture = GlobalData.texture_L
		GlobalData.HexType.J:
			$Sprite2D.texture = GlobalData.texture_J
		GlobalData.HexType.Z:
			$Sprite2D.texture = GlobalData.texture_Z
		GlobalData.HexType.S:
			$Sprite2D.texture = GlobalData.texture_S

func set_phantom_color():
	$Sprite2D.texture = GlobalData.texturePhantom

func animate_destruction():
	var destruction_time = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(2, 2), destruction_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Sprite2D, "self_modulate:a", 0, destruction_time)
	tween.tween_callback($".".queue_free)
