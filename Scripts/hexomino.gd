extends Node2D

@onready var cell_1 = $Cell_1
@onready var cell_2 = $Cell_2
@onready var cell_3 = $Cell_3
@onready var cell_4 = $Cell_4

var dir: GlobalData.Direction;
var type: GlobalData.HexType;

func set_type(type: GlobalData.HexType):
	self.type = type;
	
	match type:
		GlobalData.HexType.I:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING; # bottom
			cell_3.position = position + GlobalData.V_SPACING * 2; # bottom twice
			cell_4.position = position - GlobalData.V_SPACING; # top
		GlobalData.HexType.O:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING; # bottom
			cell_3.position = position - (GlobalData.V_SPACING / 2) + GlobalData.H_SPACING; # top right
			cell_4.position = position + (GlobalData.V_SPACING / 2) + GlobalData.H_SPACING; # bottom right
		GlobalData.HexType.T:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING;
			cell_3.position = position + GlobalData.V_SPACING * 2;
			cell_4.position = position - GlobalData.V_SPACING;
		GlobalData.HexType.L:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING;
			cell_3.position = position + GlobalData.V_SPACING * 2;
			cell_4.position = position - GlobalData.V_SPACING;
		GlobalData.HexType.J:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING;
			cell_3.position = position + GlobalData.V_SPACING * 2;
			cell_4.position = position - GlobalData.V_SPACING;
		GlobalData.HexType.Z:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING;
			cell_3.position = position + GlobalData.V_SPACING * 2;
			cell_4.position = position - GlobalData.V_SPACING;
		GlobalData.HexType.S:
			cell_1.position = position;
			cell_2.position = position + GlobalData.V_SPACING;
			cell_3.position = position + GlobalData.V_SPACING * 2;
			cell_4.position = position - GlobalData.V_SPACING;

func _ready():
	set_type(GlobalData.HexType.O)

func rotate_clockwise():
	dir = (dir + 1) % 6;

func rotate_anti_clockwise():
	dir = (dir - 1) % 6;
	if (dir < 0):
		dir += 6

func move_to(position: Vector2):
	self.position = position;

func move_down():
	pass;

func move_right():
	pass;

func move_left():
	pass;
