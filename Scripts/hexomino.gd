class_name Hexomino

enum State {
	FREE,
	BLOCKED
}

var state: State;
var dir: GlobalData.Direction;
var type: GlobalData.HexType;

func _init(dir: GlobalData.Direction, type: GlobalData.HexType):
	self.dir = dir;
	self.type = type;

func rotate_clockwise():
	dir = (dir + 1) % 6;

func rotate_anti_clockwise():
	dir = (dir - 1) % 6;
	if (dir < 0):
		dir += 6
