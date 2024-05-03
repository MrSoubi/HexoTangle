extends Node2D

var dir: GlobalData.Direction;
var type: GlobalData.HexType;

func _ready():
	pass;

func _init(dir: GlobalData.Direction, type: GlobalData.HexType):
	self.dir = dir;
	self.type = type;

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
