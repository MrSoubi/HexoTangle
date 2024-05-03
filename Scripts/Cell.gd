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
